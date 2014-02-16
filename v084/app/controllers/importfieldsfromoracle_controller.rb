class ImportfieldsfromoracleController < ApplicationController
  before_filter :authenticate_user!  
  def index
      @tsqlstr = ""
      tblid  = params[:q].to_i
      if  rec = plsql.r_blktbs.first("where id = #{tblid}  ") then 
          if rec[:blktb_expiredate] > Time.now then
             sub_import_fields_from_oracle rec[:pobject_code_tbl],rec[:id]
            else
             @errmsg = "out of expiredate"
          end
         else
             @errmsg = " id not correct"
     end
 end
 def sub_import_fields_from_oracle   pobject_code_tbl,rec_id
     ##開発環境のみ buttonにセット
     begin
     @errmsg = ""
     if rec_id.nil? then 
         tmp_rec_id = plsql.r_blktbs.first("where pobject_code_tbl = '#{pobject_code_tbl}' and pobject_objecttype_tbl = 'tbl' and blktb_expiredate > sysdate ")
         if  tmp_rec_id then
             rec_id = tmp_rec_id[:id]
            else
             @errmsg = " id not found"
         end
      end
     ##debugger
     tblconts = PLSQL::Table.find(plsql, pobject_code_tbl.to_sym)
     if tblconts
         columns = plsql.__send__(pobject_code_tbl).columns
         ###子コードのチェック
         chk_chil_tbl = plsql.select(:all,%Q%select c.table_name,c.COLUMN_NAME from user_constraints a, user_constraints b, user_cons_columns c
                                             where a.constraint_name = b.r_constraint_name and  b.constraint_name = c.constraint_name 
                                             and b.constraint_type = 'R' and a.constraint_type = 'P' and a.table_name = UPPER('blktbsfieldcodes')%)
         chk_chil_tbl.each do |rec|
              blktfc_id = plsql.blktbsfieldcodes.all("where blktbs_id = #{rec_id}  and  expiredate > sysdate") 
              blktfc_id.each do |id_rec|
                 chk_done = plsql.__send__(rec[:table_name]).first("where #{rec[:column_name]} = #{id_rec[:id]} ")
                 if  chk_done then
                      @errmsg << "Can not delete blktbsfieldcodes because table #{rec[:table_name]} has   blktbsfieldcodes = #{id_rec[:id]} "
                 end
              end
         end
         plsql.blktbsfieldcodes.delete("where blktbs_id = #{rec_id}  and  expiredate > sysdate")
         prv_import_columns rec_id,columns
         if  @errmsg.size < 1 then 
             chk_index(pobject_code_tbl,columns) 
             if  @errmsg.size > 1 then 
                     raise
             end
           else
                 raise
         end
       else
          @errmsg << " table #{pobject_code_tbl} not exists"
         raise
      end
   rescue
     plsql.rollback
     @errmsg << @tsqlstr
     @errmsg << $!.to_s
     @errmsg << $@.to_s
     fprnt"class #{self} : LINE #{__LINE__} @errmsg: #{@errmsg} " 
     fprnt"class #{self} : LINE #{__LINE__} @tsqlstr: #{@tsqlstr} " 
     else
      @errmsg << "  nothing "  
     plsql.commit  
  end   ##begin
  end
  def chk_index ltblname,columns
      tblname = ltblname.upcase
      prv_create_index_pk ltblname
      r_key = plsql.user_constraints.all("where  table_name = '#{tblname}' and constraint_type = 'R' ")  ##外部key
      fkey=[]
      r_key.each do |rec|
         fkey << rec[:constraint_name]
      end
      hash_rkey = {}
      columns.each do |key,value|
            hash_rkey[key] = key.to_s if key.to_s =~ /s_id/
      end
      hash_rkey.each do|k,v|
             unless fkey.index("#{tblname.chop}_#{v.upcase}") then
                    @tsqlstr = " ALTER TABLE #{tblname} ADD CONSTRAINT #{tblname.chop}_#{v} "
                    @tsqlstr << " FOREIGN KEY(#{v}) REFERENCES #{v.split("_")[0]}(id)"  #####custord
                    ##debugger
                    plsql.execute @tsqlstr
             end
      end
      ####ユニークindex
      ukeys = plsql.r_blkukys.all("where pobject_code_tbl = '#{tblname.downcase}' order by blkuky_grp,blkuky_seqno")
      keyarray={}
      ukeys.each do |rec|
          unless  keyarray[rec[:blkuky_grp].to_sym] then  keyarray[rec[:blkuky_grp].to_sym] = [] end
          keyarray[rec[:blkuky_grp].to_sym] << rec[:pobject_code_fld] 
      end
      constr = plsql.blk_constraints.all("where table_name = '#{tblname}'  and  constraint_type = 'U' order by  constraint_name,position")
      orakeyarray = []
      constr.each do |rec|
           unless  orakeyarray.index(rec[:constraint_name]) then  orakeyarray << rec[:constraint_name]   end  
      end
      ##debugger
      case  keyarray.size 
            when 0 then
                case  orakeyarray.size
                     when 1..999
                            prv_drop_constr tblname,orakeyarray
                end  
            when 1..999 then
               case  orakeyarray.size
                     when 1..999
                          prv_drop_constr tblname,orakeyarray
               end  
                prv_add_constr  keyarray,tblname
      end         
  end
  def prv_drop_constr tblname,orakeyarray
       orakeyarray.each do |key|
          @tsqlstr = " ALTER TABLE #{tblname} drop CONSTRAINT #{key}"
          plsql.execute @tsqlstr
      end
  end
  def  prv_add_constr  keyarray,tblname
       keyarray.each do |key,val|
          @tsqlstr = " ALTER TABLE #{tblname} Add CONSTRAINT #{tblname}_UKYS#{key.to_s} UNIQUE ( "
          val.each do |i|
             @tsqlstr << i+","
          end
          @tsqlstr = @tsqlstr.chop+")"
          plsql.execute @tsqlstr
       end
  end
  def prv_import_columns rec_id,columns
       chk_mandatory_field = prv_init
       columns.each do |field,attr|
            chk_mandatory_field.delete(field)
            fieldcode = prv_chk_fieldcodes field.to_s,attr
            prv_add_blktbsfieldcodes rec_id,fieldcode if @errmsg.size <1
       end
       chk_mandatory_field.each do |key,value|
           @errmsg << " ...#{key.to_s} not exists...." 
       end
  end
  def  prv_add_blktbsfieldcodes rec_id,fieldcode
       tmp = {}
       tmp[:id] = plsql.blktbsfieldcodes_seq.nextval
       tmp[:blktbs_id] = rec_id
       ##tmp[:ctblname] = "fieldcodes"
       tmp[:fieldcodes_id] = fieldcode[:id]
       tmp[:persons_id_upd] = plsql.persons.first(:email =>current_user[:email])[:id]  ||= 0
       tmp[:expiredate]=Time.parse("2099-12-31")
       tmp[:created_at] = Time.now
       tmp[:updated_at] = Time.now
       tmp[:remark] = " from oracle"
       plsql.blktbsfieldcodes.insert tmp
  end
  def prv_chk_pobjects field,objecttype
      rec = plsql.pobjects.first("where code = '#{field}' and objecttype = '#{objecttype}' and expiredate > sysdate")
      unless rec
         rec = prv_add_pobjects field,objecttype
      end
      return rec
  end 
  def  prv_chk_fieldcodes field,attr
       rec =  prv_chk_pobjects field,"tbl_field"
       ##debugger
       fieldcode = plsql.r_fieldcodes.first("where pobject_code_fld = '#{field}' and pobject_objecttype_fld = 'tbl_field' and fieldcode_expiredate > sysdate")
       if fieldcode then
          prv_chk_attr field,fieldcode,attr
         else
          fieldcode = prv_add_fieldcode rec[:id],attr
       end
       return fieldcode 
  end
  def  prv_add_fieldcode rec_id,attr
       tmp = {}
       tmp[:id] = plsql.fieldcodes_seq.nextval
       tmp[:pobjects_id_fld] = rec_id
       tmp[:ftype] = attr[:data_type].downcase
       tmp[:fieldlength] = attr[:data_length]
       tmp[:datapresion] = attr[:data_precision]
       tmp[:datascale] =   attr[:data_scale]
       tmp[:persons_id_upd] = plsql.persons.first(:email =>current_user[:email])[:id]  ||= 0 
       tmp[:expiredate] = Time.parse("2099/12/31")
       tmp[:created_at] = Time.now
       tmp[:updated_at] = Time.now
       tmp[:remark] = " from oracle"
       ##debugger
       plsql.fieldcodes.insert tmp
       return tmp
  end 
  def prv_add_pobjects field,objecttype
      tmp ={}
      tmp[:id] = plsql.pobjects_seq.nextval
      tmp[:objecttype] = objecttype
      tmp[:persons_id_upd] =plsql.persons.first(:email =>current_user[:email])[:id]  ||= 0 
      tmp[:created_at] = Time.now
      tmp[:updated_at] = Time.now
      tmp[:expiredate] = Time.parse("2099/12/31")
      tmp[:code] = field
      ##debugger
      plsql.pobjects.insert tmp
      return tmp
  end
  def prv_chk_attr field,fieldcode,attr
      if fieldcode[:fieldcode_ftype] == attr[:data_type].downcase then
          case fieldcode[:ftype]
               when "number"
                    if fieldcode[:fieldcode_datapresion] != attr[:data_precision] and
                       ieldcode[:fieldcode_datapresion] != 0 and    attr[:data_precision] != 38 then
                         @errmsg << " lenhtg unmatch"
                     end 
                    if fieldcode[:fieldcode_datapresion] == attr[:data_precision] and
                       (fieldcode[:fieldcode_datapresion] !=   attr[:data_precision]  or
                         fieldcode[:fieldcode_datascale] !=   attr[:data_scale])
                         @errmsg << " lenhtg unmatch"
                     end                      
                when /char/
                    if fieldcode[:fieldcode_fieldlength] != attr[:data_length] then
                       @errmsg << " lenhtg unmatch"
                    end 
            end
         else
         ##debugger
           if fieldcode[:fieldcode_ftype] =~ /timestamp/  and  attr[:data_type].downcase =~ /timestamp/  then
             else
              @errmsg << "...field =>#{field}  is  already exists and type unmatch...type => #{fieldcode[:fieldcode_ftype]}  but  oracle =>#{attr[:data_type].downcase}..."
           end
      end
  end
  def prv_init
      mandatory_field ={:id=>["000","id"," number(38),"],
                        :remark=>["901","remark","  varchar2(100),"],
                        :expiredate=>["902","expiredate","  date ,"],
                        :persons_id_upd=>["903","persons_id_upd"," number(38),"],
                        :update_ip=>["904","update_ip"," varchar2(40),"] ,
                        :created_at=>["905","created_at"," timestamp(6),"] ,
                        :updated_at=>["906","updated_at"," timestamp(6),"] } 
  end 
 def create_or_replace_view  tblid,tblname   ### 
    subfields = plsql.r_fieldcodes.all("where id in(select fieldcodes_id from blktbsfieldcodes where blktbs_id = #{tblid} )")
    selectstr = " select "
        wherestr = "\n where "   ##joinが条件
        fromstr = "\n from " + tblname + " " + tblname.chop + " ,"   ## 最後のSはとる。
        sub_rtbl = "r_" + tblname   ##create view name  tbl:view=1:1
        subfields.each do |rec|
           js = rec[:pobject_code_fld]
           if  js =~ /_id/  then
               if  js =~  /persons_id_/ then
                   join_rtbl = " persons " ##JOINするテーブル名
                   rtblname =  "person" + (js.split(/_id/)[1] ||= "")
                   fromstr << join_rtbl + "  " + rtblname + ','    
                   wherestr << " #{rtblname}.id = " 
	           wherestr << tblname.chop + "." + "persons_id" + (js.split(/_id/)[1] ||= "") + " and "   ## i table name
                   selectstr << "#{rtblname}.code person_code" + (js.split(/_id/)[1] ||= "") + " ,#{rtblname}.name person_name" + (js.split(/_id/)[1] ||= "")  + "," 
                 else ## not person_id
                  join_rtbl = "r_" + js.split(/_id/)[0]  ##JOINするテーブル名
                  rtblname =  js.sub(/s_id/,"")
                  fromstr << join_rtbl + "  " + rtblname + ','    ### from r_xxxxs xxxxx 
                  wherestr << " #{rtblname}.#{rtblname.split("_")[0]}_id = "  ##相手側のテーブルのid
	          wherestr << tblname.chop + "." + js  + " and "   ## 自分のテーブル内の相手がわを示すid
                  selectstr << tblname.chop + "." +  js + " " + tblname.chop + "_" +  js.sub("s_id","_id") + " ,"
                  subtblcrt  js,rtblname do |k|   ###相手側の項目セット
                      selectstr << k
                  end
               end ##person_id
             else ##not _id
               ##debugger
               @errmsg << "length over table:" + tblname + " field:" +  js + " length:" + (tblname.chop.length + js.length).to_s if  (tblname.chop.length + js.length) > 30
                  selectstr << tblname.chop + "." +  js  + " id,"   if js == 'id' 
                  selectstr << tblname.chop + "." +  js + " " + tblname.chop + "_" +  js + " ," 
           end      ##if  js =~ /_id/   
        end   ##subfields
        @strsql1 = "create or replace view  r_" + tblname + " as "   
        @strsql1 << selectstr.chop +  fromstr.chop + wherestr[0..-5]
        plsql.execute  @strsql1   
 end  #end create_or_replace_view 
 def  subtblcrt  subrtbl ,rtblname   ## sub_rtbl:テーブル名,rtblname:省略形
        k = ""
        join_rtbl = "r_" + subrtbl.split(/_id/)[0] 
        ##subfields = plsql.USER_TAB_COLUMNS.all("WHERE TABLE_NAME = :1",join_rtbl)
	if PLSQL::View.find(plsql, join_rtbl.to_sym).nil?
           @errmsg << "create view #{ join_rtbl }"
           raise 
           ### create_or_replace_view  tblid,tblname
	end  

	subfields = plsql.__send__(join_rtbl).column_names
        subfields.each do |j|
          js = j.to_s
          xfield =  j.to_s  
          if join_rtbl == "r_persons"
                 xfield  = "" if js.match("_upd")
                else
                 xfield  = "" if js.match("person")
           end   ## if join_rtbl  
            ["EXPIREDATE","UPDATE_IP","CREATED_AT","UPDATED_AT","USERGROUP_CODE_UPD","USERGROUP_NAME_UPD","USERGROUP_CODE_CHRG","USERGROUP_NAME_CHRG"].each do |x|
                     xfield = "" if js.upcase.match(x)
             end
              xfield = "" if js.upcase == "ID" 
               if   xfield  != "" then 
                    xfield = rtblname + "." + xfield + " " + xfield +  subrtbl.split(/_id/)[1] if subrtbl.split(/_id/)[1]
                    xfield = rtblname + "." + xfield + " "  + xfield  if subrtbl.split(/_id/)[1].nil?
                    k <<  " " +  xfield   + "," 
                    lngerrfield = xfield.split(" ")[1]
                    ###p " 127 #{xfield}"
                   @errmsg << "sub table: #{join_rtbl}   field: #{lngerrfield}  length: #{(lngerrfield.length).to_s}"  if ( lngerrfield.length) > 29
               end  
            end  ## subfields.each           
         yield k           
 end 
      ##
 def  init_screenfields
      screenfields = 
         {:selection   =>  1,
          :expiredate   => Time.parse("2099/12/31"),
          :remark   => "auto_crt",
          :persons_id_upd   => plsql.persons.first(:email =>current_user[:email])[:id]  ||= 0 ,
          :update_ip   => @myip,
          :created_at   => Time.now,
          :updated_at   => Time.now,
          :paragraph => nil,
          :edoptvalue => nil,
          :subindisp => nil,
          :editable => nil
          }
end #
def create_screenfields viewname     ### viewname = "R_xxxxxxxS"   <==== R_xxxxxS_ID

    @tsqlstr = "delete from  screenfields a where screens_id  in ( select id from  screens "
    @tsqlstr << " where Pobjects_id_view = (select id from pobjects where code = '#{viewname}'  and objecttype = 'view') )"
    @tsqlstr << " and created_at = updated_at   " ##自動作成分のみ削除
    @tsqlstr << " and not exists (select 1 from blkukys where a.id  = 	blktbsfieldcodes_id)"
    @tsqlstr << " and not exists (select 1 from chilscreens where a.id  = 	screenfields_id_ch)"
    @tsqlstr << " and not exists (select 1 from chilscreens where a.id  = 	screenfields_id)"

    plsql.execute @tsqlstr

       @tsqlstr = "select pobject_code_sfd from r_screenfields a where screenfield_screen_id  in ( select id from  screens "
    @tsqlstr << " where Pobjects_id_view = (select id from pobjects where code = '#{viewname}'  and objecttype = 'view') )"
    @tsqlstr << " and id in (select id from r_screenfields where not exists( select 1 from "
    @tsqlstr << "  USER_TAB_COLUMNS where table_name = '#{viewname.upcase}' and upper(pobject_code_sfd) = column_name))"
    @tsqlstr << " and ( exists (select 1 from  blkukys where a.id  = 	blktbsfieldcodes_id)"
    @tsqlstr << " or  exists (select 1 from  chilscreens where a.id  = 	screenfields_id_ch)"
    @tsqlstr << " or  exists (select 1 from  chilscreens where a.id  = 	screenfields_id) )"

    chktb =  plsql.select(:all, @tsqlstr)  ###子テーブルに該当データがあるとき

     @errmsg  << "  blkukys or chilscreen_screenfields have records #{chktb.join(',')} " if chktb.size> 0
    @tsqlstr = "delete from  screenfields a where screens_id  in ( select id from  screens "
    @tsqlstr << " where Pobjects_id_view = (select id from pobjects where code = '#{viewname}'  and objecttype = 'view') )"
    @tsqlstr << " and id in (select id from r_screenfields where not exists( select 1 from "
    @tsqlstr << "  USER_TAB_COLUMNS where table_name = '#{viewname.upcase}' and upper(pobject_code_sfd) = column_name))"
    @tsqlstr << " and not exists (select 1 from  blkukys where a.id  = 	blktbsfieldcodes_id)"
    @tsqlstr << " and not exists (select 1 from  chilscreens where a.id  = 	screenfields_id_ch)"
    @tsqlstr << " and not exists (select 1 from  chilscreens where a.id  = 	screenfields_id)"
 ###     @tsqlstr << " and created_at = updated_at   " ##自動作成分のみ削除 削除は自分で  中止 1/18
    plsql.execute @tsqlstr if  chktb.size == 0  ##存在しない項目削除
    fields = plsql.__send__(viewname).columns  ###select(:all,tmp_screen_dtl)   ###テーブルの項目をセット  R_xxxx
    ###debugger
    screen_ids = plsql.screens.all(" where pobjects_id_view = (select id from pobjects where code = '#{viewname}'  and objecttype = 'view') ")
     @errmsg << "_______missing screen code #{viewname}"  if screen_ids.empty?
    screen_ids.each do |rec|
       screen_id = rec[:id]
       row_cnt ||= 1
       fields.each  do |ii,jj|
           setscreenfields ii.to_s,jj,viewname,screen_id,fields,row_cnt   ## iiの中はscreens_id 「s」がつくよ
          row_cnt += 1          
       end 
       code_rowpos_name = plsql.r_screenfields.all("where screenfield_screen_id = #{screen_id} and screenfield_expiredate > sysdate ") 
       tmp_rowpos= {} 
       code_rowpos_name.each do |rec|
            if rec[:pobject_code_sfd] =~ /_code/ and rec[:screenfield_created_at] == rec[:screenfield_updated_at] then
               tmp_rowpos[rec[:pobject_code_sfd].to_sym] = rec[:screenfield_rowpos]
            end
       end
       tmp_rowpos.each do |key,rowpos|
           namekey = key.to_s.gsub("_code","_name")
           namerec = plsql.r_screenfields.first("where screenfield_screen_id = #{screen_id} and screenfield_expiredate > sysdate and pobject_code_sfd = '#{namekey}'") 
           if  namerec then
               tmp_rec = {}
               tmp_rec[:rowpos] = rowpos
               tmp_rec[:where] = {:id => namerec[:id]}
               plsql.screenfields.update tmp_rec
           end
       end
       crttype    viewname                 ##interface用　ｓｉｏ作成
    end
 end  ##create_screenfields 
 def setscreenfields   ii,jj,viewname,screen_id,fields,row_cnt
       screenfields = init_screenfields
       code_pos = []
       indisp = 0 
       indisp = sub_indisp(ii,viewname)  if (ii =~ /_code/ or ii =~ /_name/) and  ii !~ /_upd$/  and ii.split(/_/)[0] != viewname.split("_")[1].chop
       screenfields[:editable] =  indisp  
       screenfields[:hideflg] = 0
       screenfields[:id]  = plsql.screenfields_seq.nextval
       screenfields[:screens_id] = screen_id
	if  ii =~ /_code/ or ii =~ /_name/ then
              screenfields[:hideflg] = 0
           else
             if  viewname.split(/_/)[1].chop  == ii.split(/_/)[0] then  ## テーブ目名の「s」はふくめない。
                  screenfields[:hideflg] = 0
                else
                  screenfields[:hideflg] = 1
              end                          
         end
        screenfields[:hideflg]   = if ii =~ /_id/  or ii =="id" then 1 else 0 end 
        tid = plsql.pobjects.first("where code = '#{ii}' and objecttype ='view_field' and expiredate > sysdate ")
        if tid then
               screenfields[:pobjects_id_sfd]   = tid[:id]   
            else
               tmp = prv_add_pobjects ii,"view_field"
               screenfields[:pobjects_id_sfd] =  tmp[:id]      
        end
	if jj[:data_length] > 400  then
	   screenfields[:type]   =  "textarea" 
	   screenfields[:edoptrow]  = if (jj[:data_length] / 80).ceil > 10 then 10 else (jj[:data_length] / 80).ceil end
	   screenfields[:edoptcols] = 80
	   else
           screenfields[:type]   =   jj[:data_type].downcase
	 end
	 screenfields[:edoptmaxlength]   =  jj[:data_length]
         screenfields[:dataprecision]   =  jj[:data_precision]
         screenfields[:datascale]   =  jj[:data_scale]
         screenfields[:indisp]   =  indisp  
	 ### screenfields[:editablehide] =  nil
	 screenfields[:width] =  if jj[:data_length] * 6 > 300 then 300  else jj[:data_length] * 6 end 
         screenfields[:width] =  60 if  /_upd$/ =~ ii      or  /_ip$/ =~ ii 
	 ##screenfields[:edoptsize]  =  screenfields[:edoptmaxlength]  
         ##screenfields[:edoptsize]  =  10 if jj[:data_type] == "date"  or  j[:data_type] =~ /timestamp/ 
         screenfields[:width] =   100 if jj[:data_type] == "date" or  jj[:data_type] =~ /timestamp/ 
         if  viewname.split(/_/)[1].chop  == ii.split(/_/)[0] then   ##同一テーブルの項目のみ変更可
             screenfields[:editable] =  1                  
             screenfields[:editable] =  0 if /_ip$/ =~ ii     ##  
             screenfields[:editable] =  0 if /_id/ =~ ii   ## 更新者と更新時間          
             screenfields[:editable] =  0 if  /_at$/ =~ ii     
         end
          
         ##   editform positon 
         screenfields[:seqno] = 999 
         screenfields[:seqno] = 888 if  screenfields[:editable] == 1 
         ##screenfields[:rowpos] = 999   if screenfields[:editable] ==  1 
         unless   screenfields[:pobjects_id_sfd] then
                  tmp =  prv_add_pobjects ii, "view_field"
                  screenfields[:pobjects_id_sfd] =  tmp[:id]      
         end
         ##debugger
         if screenfields[:editable] ==  1  then
	     screenfields[:rowpos] = row_cnt
             screenfields[:colpos] = 1
             screenfields[:colpos] = 2  if ii =~ /_name/
	 end

	 ###  項目別にソート済
         plsql.screenfields.insert screenfields unless  plsql.r_screenfields.first("where screenfield_pobject_id_sfd = '#{screenfields[:pobjects_id_sfd]}' and screenfield_screen_id = #{screenfields[:screens_id]} ") 
         if @strsql then @strsql << " ," else   @strsql = "," end
         @strsql << ii + " " + jj[:data_type]
         @strsql << "(" +  jj[:data_length].to_s + ")" if jj[:data_type] =~ /CHAR/
         if jj[:data_type] == "NUMBER" then
             spr = jj[:data_precision].to_s
             ssc = jj[:data_scale].to_s
             @strsql << "(" +  spr + "," + ssc + ")" if spr =~ /[0..9]/
             ###  p "a120" +  spr + "," + ssc 
         end    
 end ##setscreenfields  
 def sub_indisp  column_name,viewname   ##孫のテーブルのidは不要　edit addの時必須にしない
     xtblname = viewname.split(/_/)[1]
     ##chk_screen_id = "SELECT COLUMN_NAME    FROM USER_TAB_COLUMNS WHERE TABLE_NAME =  '#{xtblname}' " 
     ##chk_screen_id << %Q| and COLUMN_NAME = '#{column_name.sub("_" + column_name.split(/_/)[1],"S_ID")}'|      ####CODE又はNAMEをID
     chk_screen_id  = column_name.sub("_" + column_name.split(/_/)[1],"s_id")   ####CODE又はNAMEをID
     chil_fields = plsql.__send__(xtblname).column_names   ## テーブルの項目
     if chil_fields.index(chk_screen_id.to_sym) then
        indisp = 1
       else
	indisp = 0
      end
     return  indisp
end 
def crttype   viewname  
 sio_fields viewname
 begin   
   @tsqlstr  =  "DROP TABLE " + "SIO_" + viewname  
   plsql.execute @tsqlstr
   rescue
    # 例外が発生したときの処理
   else
      # 例外が発生しなかったときに実行される処理
   ensure
      # 例外の発生有無に関わらず最後に必ず実行する処理
  end         
     @tsqlstr =  "CREATE TABLE " + "SIO_" + viewname   + " (\n" 
     @tsqlstr <<  "          sio_id numeric(38)  CONSTRAINT " +  "SIO_" + viewname   + "_id_pk PRIMARY KEY \n"
     @tsqlstr <<  "          ,sio_user_code numeric(38)\n"
     @tsqlstr <<  "          ,sio_Term_id varchar(30)\n"
     @tsqlstr <<  "          ,sio_session_id varchar(256)\n"
     @tsqlstr <<  "          ,sio_Command_Response char(1)\n"
     @tsqlstr <<  "          ,sio_session_counter numeric(38)\n"
     @tsqlstr <<  "          ,sio_classname varchar(30)\n" 
     @tsqlstr <<  "          ,sio_viewname varchar(30)\n" 
     @tsqlstr <<  "          ,sio_code varchar(30)\n"
     @tsqlstr <<  "          ,sio_strsql varchar(4000)\n"
     @tsqlstr <<  "          ,sio_totalcount numeric(38)\n"
     @tsqlstr <<  "          ,sio_recordcount numeric(38)\n"
     @tsqlstr <<  "          ,sio_start_record numeric(38)\n"
     @tsqlstr <<  "          ,sio_end_record numeric(38)\n"
     @tsqlstr <<  "          ,sio_sord varchar(256)\n"
     @tsqlstr <<  "          ,sio_search varchar(10)\n"
     @tsqlstr <<  "          ,sio_sidx varchar(256)\n"
     @tsqlstr  <<  @strsql
     @tsqlstr <<  "          ,sio_ctltbl varchar(4000)\n"
     @tsqlstr <<  "          ,sio_org_tblname varchar(30)\n"
     @tsqlstr <<  "          ,sio_org_tblid numeric(38)\n"
     @tsqlstr <<  "          ,sio_add_time date\n"
     @tsqlstr <<  "          ,sio_replay_time date\n"
     @tsqlstr <<  "          ,sio_result_f char(1)\n"
     @tsqlstr <<  "          ,sio_message_code char(10)\n"
     @tsqlstr <<  "          ,sio_message_contents varchar(256)\n"
     @tsqlstr <<  "          ,sio_chk_done char(1)\n"
     @tsqlstr <<  ")\n"
     ##fprnt @tsqlstr 
     plsql.execute @tsqlstr

     @tsqlstr =  " CREATE INDEX SIO_#{viewname}_uk1 \n"
     @tsqlstr << "  ON SIO_#{viewname}(sio_user_code,sio_session_id) \n"
     @tsqlstr << "  TABLESPACE USERS  STORAGE (INITIAL 20K  NEXT 20k  PCTINCREASE 75)"  
     ##fprnt @tsqlstr 
   plsql.execute @tsqlstr
   
  begin                        
    @tsqlstr =  "drop sequence SIO_" + viewname + "_seq"
    plsql.execute @tsqlstr 
  rescue
  end    ### begin 
     @tsqlstr =  "create sequence SIO_" + viewname + "_seq" 
     plsql.execute @tsqlstr
   

end #crttype 
def sio_fields viewname
      @strsql = ""
      #sql = "SELECT * FROM USER_TAB_COLUMNS WHERE TABLE_NAME = '#{viewname}' "
      #fields = plsql.select(:all,sql)
      fields = plsql.__send__(viewname).columns    ### @tblname = R_xxxxx
      fields.each do |key,ii|
         @strsql << " ,"
         jj = key.to_s
         ## jj <<  "_tbl" if jj == "id"
         @strsql << jj + " " + ii[:data_type] + " "
         @strsql << "(" +  ii[:data_length].to_s + ") " if ii[:data_type] =~ /CHAR/
         if ii[:data_type] == "NUMBER" then
             spr = ii[:data_precision].to_s
             ssc = ii[:data_scale].to_s
             @strsql << "(" +  spr + "," + ssc + ") " if spr =~ /[0..9]/
             ###  p "a120" +  spr + "," + ssc 
         end 
      end   
 end
 def crt_chil_screen viewname
##    p "addmain1"
##  対象となるテーブルは　idをフィールドに持つこと
## tablenameS_ID_xxx_xxxのレイアウトであること。
## viewの名前は R_xxxx のようにすること。
## 全テーブルに対応は中止した。
    tblarea = {}  
    notextview = {}
    strsql = " where pobject_code_view =  '#{viewname}' and screenfield_Expiredate > sysdate "
       fields = plsql.R_screenfields.all(strsql)
       ## p "strsql : #{strsql}"
    ## p fields   
##    p "addmain2"
    fields.each  do |tbldata|
       if tbldata[:object_code_sfd]  =~ /_id/ then
          pare_tbl_sym = (tbldata[:object_code_sfd].split(/_id/)[0] + "S").to_sym
          tblarea[pare_tbl_sym] = viewname
       end
    end
    
    y = plsql.r_screens.first("WHERE pobject_code_view = '#{viewname}' ")
    tblarea.each_key  do |i|
        x = plsql.screens.first("WHERE pobject_code_view = 'r_#{i.to_s}' ")
        next if x.nil?
        tmp_area = tblarea[i] 
              next if x.nil?
                 chil_r = plsql.ChilScreens.first("where screens_id = :1 and screens_id_chil = :2",x[:id],y[:id])
                 ##  p  "where screens_id_Pare = :1 and screens_id = :2"
                 if chil_r.nil? then
                    val_chil = {
                    :id => plsql.chilscreens_seq.nextval,
                    :screens_id => x[:id],
                    :screens_id_chil => y[:id],
                    :expiredate => Time.parse("2099/12/31"),
                    :remark => "auto_create", 
                    :persons_id_upd => plsql.persons.first(:email =>current_user[:email])[:id]  ||= 0 , 
                    :update_ip =>  "1",
                    :created_at => Time.now,
                    :updated_at => Time.now
                    }
                  plsql.chilscreens.insert val_chil
                  ## p "insert"
                  end ## if
    end    ## i
    plsql.commit 
 end  #end crt_chil_screen 
 def prv_create_index_pk ltblname
     tblname = ltblname.upcase
      unless PLSQL::Sequence.find(plsql,"#{tblname}_seq".to_sym) then 
             @tsqlstr =  "create sequence " + tblname + "_seq" 
             plsql.execute @tsqlstr
       end
       c_key = plsql.user_constraints.first("where table_name = '#{tblname}' and constraint_type = 'P' ")  ###主key
       if c_key then
                keys = plsql.user_ind_columns.all(" where table_name = '#{tblname}' and index_name =  '#{c_key[:constraint_name]}' ")
                      keys.each do |rec|
                      @errmsg << "PRIMARY KEY diffrent"  if  rec[:column_name] != "ID" 
                end
           else
              @tsqlstr =  "ALTER TABLE " + tblname + "  add  CONSTRAINT #{tblname}_id_pk PRIMARY KEY(id) " 
              plsql.execute @tsqlstr     
       end
 end
 def chk_ctl_index ltblname,columns
     tblname = ltblname.upcase
     r_key = plsql.user_constraints.all("where  table_name = '#{tblname}' and constraint_type = 'R' ")  ##外部key
     fkey=[]
     r_key.each do |rec|
         fkey << rec[:constraint_name]
     end
     hash_rkey = {}
     columns.each do |key,value|
            hash_rkey[key] = key.to_s 
     end
     hash_rkey.each do|k,v|
             unless fkey.index("#{tblname}_#{v.upcase}") then
                    @tsqlstr = " ALTER TABLE #{tblname} ADD CONSTRAINT #{tblname}_#{v} "
                    @tsqlstr << " FOREIGN KEY(#{v}) REFERENCES #{v.split("_")[0]}(id)"  #####custord
                    ##debugger
                    plsql.execute @tsqlstr
             end
        end
      ####ユニークindex
      ukeys = plsql.r_blkukys.all("where pobject_code_tbl = '#{tblname.downcase}' order by blkuky_seqno")
      keyarray=[]
      ukeys.each do |rec|
          keyarray << rec[:pobject_code_fld]
      end
      constr = plsql.blk_constraints.all("where table_name = '#{tblname}'  and  constraint_name = '#{tblname}_UKYS_BLK' order by position")
      orakeyarray = []
      constr.each do |rec|
          orakeyarray << rec[:column_name]
      end
      ##debugger
      case  keyarray.size 
            when 0 then
                case  orakeyarray.size
                     when 1..999
                            prv_drop_constr tblname
                end  
            when 1..999 then
               case  orakeyarray.size
                     when 0 then
                            prv_add_constr  keyarray,tblname
                     when 1..999
                          if   keyarray !=  orakeyarray then
                               prv_drop_constr tblname
                               prv_add_constr  keyarray,tblname
                          end
                end  
      end         
  end
end

