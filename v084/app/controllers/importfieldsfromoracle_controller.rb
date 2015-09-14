class ImportfieldsfromoracleController < ApplicationController
  ###  created_at updated_at remark は必須
  ###  _idは自動的に外部keyを作成する。
	before_filter :authenticate_user!  
	def index
		@tsqlstr = ""
		tblid  = params[:sio_viewname].to_i
		if  rec = plsql.r_blktbs.first("where id = #{tblid}  ") then 
			if rec[:blktb_expiredate] > Time.now then
				plsql.logoff
				plsql.connect! "rails", "rails",  :database => "xe"
				sub_import_fields_from_oracle rec[:pobject_code_tbl],rec[:id]
				##Rails.cache.clear(nil)
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
         tmp_rec_id = plsql.r_blktbs.first("where pobject_code_tbl = '#{pobject_code_tbl}' and pobject_objecttype_tbl = 'tbl' and blktb_expiredate > current_date ")
         if  tmp_rec_id then
             rec_id = tmp_rec_id[:id]
            else
             @errmsg = " id not found"
         end
      end
     tblconts = PLSQL::Table.find(plsql, pobject_code_tbl.to_sym)
     if tblconts
         columns = plsql.__send__(pobject_code_tbl).columns
         ###子コードのチェック
         chk_chil_tbl = plsql.select(:all,%Q%select c.table_name,c.COLUMN_NAME from user_constraints a, user_constraints b, user_cons_columns c
                                             where a.constraint_name = b.r_constraint_name and  b.constraint_name = c.constraint_name 
                                             and b.constraint_type = 'R' and a.constraint_type = 'P' and a.table_name = UPPER('blktbsfieldcodes')%)
         chk_chil_tbl.each do |rec|
              blktfc_id = plsql.blktbsfieldcodes.all("where blktbs_id = #{rec_id}  and  expiredate > current_date") 
              blktfc_id.each do |id_rec|
                 chk_done = plsql.__send__(rec[:table_name]).first("where #{rec[:column_name]} = #{id_rec[:id]} ")
                 if  chk_done then
                      @errmsg << "Can not delete blktbsfieldcodes because table #{rec[:table_name]} has   blktbsfieldcodes = #{id_rec[:id]} "
                 end
              end
         end
         plsql.blktbsfieldcodes.delete("where blktbs_id = #{rec_id}  and  expiredate > current_date")
         prv_import_columns rec_id,columns
         if  @errmsg.size < 1 then 
             chk_index(pobject_code_tbl,columns) if columns
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
		### postgresqlの時は　user_constraintsはtable_constraintsになる。
		fkey=[]
		r_key.each do |rec|
			fkey << rec[:constraint_name]
		end
		hash_rkey = {}
		columns.each do |key,value|
            hash_rkey[key] = key if key =~ /s_id/
		end
		hash_rkey.each do|k,v|
             unless fkey.index("#{tblname.chop}_#{v.upcase}") then
                    @tsqlstr = " ALTER TABLE #{tblname} ADD CONSTRAINT #{tblname.chop}_#{v} "
                    @tsqlstr << " FOREIGN KEY(#{v}) REFERENCES #{v.split("_")[0]}(id)"  #####custord
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
       tmp[:persons_id_upd] = plsql.persons.first(:email =>current_user[:email])[:id] 
       tmp[:expiredate]=Time.parse("2099-12-31")
       tmp[:created_at] = Time.now
       tmp[:updated_at] = Time.now
       tmp[:remark] = " set by prv_add_blktbsfieldcodes"
       plsql.blktbsfieldcodes.insert tmp
  end
  def prv_chk_pobjects field,objecttype
      rec = plsql.pobjects.first("where code = '#{field}' and objecttype = '#{objecttype}' and expiredate > current_date")
      unless rec
         rec = prv_add_pobjects field,objecttype
      end
      return rec
  end 
  def  prv_chk_fieldcodes field,attr
       rec =  prv_chk_pobjects field,"tbl_field"
       fieldcode = plsql.r_fieldcodes.first("where pobject_code_fld = '#{field}' and pobject_objecttype_fld = 'tbl_field' and fieldcode_expiredate > current_date")
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
       tmp[:dataprecision] = attr[:data_precision]
       tmp[:datascale] =   attr[:data_scale]||=0
       tmp[:persons_id_upd] = plsql.persons.first(:email =>current_user[:email])[:id]
       tmp[:expiredate] = Time.parse("2099/12/31")
       tmp[:created_at] = Time.now
       tmp[:updated_at] = Time.now
       tmp[:remark] = " set by prv_add_fieldcode"
       plsql.fieldcodes.insert tmp
       return tmp
  end 
  def prv_add_pobjects field,objecttype
      tmp ={}
      tmp[:id] = plsql.pobjects_seq.nextval
      tmp[:objecttype] = objecttype
      tmp[:persons_id_upd] =plsql.persons.first(:email =>current_user[:email])[:id] 
      tmp[:created_at] = Time.now
      tmp[:updated_at] = Time.now
      tmp[:expiredate] = Time.parse("2099/12/31")
      tmp[:code] = field
      plsql.pobjects.insert tmp
      return tmp
  end
	def prv_chk_attr field,fieldcode,attr
		if fieldcode[:fieldcode_ftype] == attr[:data_type].downcase then
			case fieldcode[:ftype]
				when "number"
                    if fieldcode[:fieldcode_dataprecision] != attr[:data_precision] and
                       ieldcode[:fieldcode_dataprecision] != 0 and    attr[:data_precision] != 38 then
                         @errmsg << " lenhtg unmatch"
                    end 
                    if fieldcode[:fieldcode_dataprecision] == attr[:data_precision] and
                       (fieldcode[:fieldcode_dataprecision] !=   attr[:data_precision]  or
                         fieldcode[:fieldcode_datascale] !=   attr[:data_scale])
                         @errmsg << " lenhtg unmatch"
                    end                      
                when /char/
                    if fieldcode[:fieldcode_fieldlength] != attr[:data_length] then
                       @errmsg << " lenhtg unmatch"
                    end 
            end
        else
           if fieldcode[:fieldcode_ftype] =~ /timestamp/  and  attr[:data_type].downcase =~ /timestamp/  then
             else
              @errmsg << "...field =>#{field}  is  already exists and type unmatch...type => #{fieldcode[:fieldcode_ftype]}  but  oracle =>#{attr[:data_type].downcase}..."
			end
		end
	end
	def prv_init
		mandatory_field ={:id=>["001","id"," number(38),"],
                        :contents=>["801","contents","  varchar2(4000),"],
                        :expiredate=>["802","expiredate","  date ,"],
                        :remark=>["803","remark","  varchar2(100),"],
                        :persons_id_upd=>["901","persons_id_upd"," number(38),"],
                        :update_ip=>["904","update_ip"," varchar2(40),"] ,
                        :created_at=>["902","created_at"," timestamp(6),"] ,
                        :updated_at=>["903","updated_at"," timestamp(6),"] } 
	end 
	def  init_screenfields
		screenfields = 
         { :expiredate   => Time.parse("2099/12/31"),
          :remark   => "auto_crt",
          :persons_id_upd   =>  plsql.persons.first(:email =>current_user[:email])[:id]  ,
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
		@tsqlstr << "  USER_TAB_COLUMNS where upper(table_name) = '#{viewname.upcase}' and upper(pobject_code_sfd) = column_name))"
		@tsqlstr << " and ( exists (select 1 from  blkukys where a.id  = 	blktbsfieldcodes_id)"
		@tsqlstr << " or  exists (select 1 from  chilscreens where a.id  = 	screenfields_id_ch)"
		@tsqlstr << " or  exists (select 1 from  chilscreens where a.id  = 	screenfields_id) )"

		chktb =  plsql.select(:all, @tsqlstr)  ###子テーブルに該当データがあるとき

		@errmsg  << "  blkukys or chilscreen_screenfields have records #{chktb.join(',')} " if chktb.size> 0
		@tsqlstr = "delete from  screenfields a where screens_id  in ( select id from  screens "
		@tsqlstr << " where Pobjects_id_view = (select id from pobjects where code = '#{viewname}'  and objecttype = 'view') )"
		@tsqlstr << " and id in (select id from r_screenfields where not exists( select 1 from "
		@tsqlstr << "  USER_TAB_COLUMNS where upper(table_name) = '#{viewname.upcase}' and upper(pobject_code_sfd) = column_name))"
		@tsqlstr << " and not exists (select 1 from  blkukys where a.id  = 	blktbsfieldcodes_id)"
		@tsqlstr << " and not exists (select 1 from  chilscreens where a.id  = 	screenfields_id_ch)"
		@tsqlstr << " and not exists (select 1 from  chilscreens where a.id  = 	screenfields_id)"
		###     @tsqlstr << " and created_at = updated_at   " ##自動作成分のみ削除 削除は自分で  中止 1/

		
		plsql.execute @tsqlstr if  chktb.size == 0  ##存在しない項目削除
		crttype    viewname                 ##interface用　ｓｉｏ作成
	end  ##create_screenfields 
    def setscreenfields   sr,ii,viewname,row_cnt   ### sr["column_name"]
        screenfields = init_screenfields
		screenfields[:selection] = 0
        code_pos = []
        indisp = 0 
        if sr["column_name"] =~ /_code|_name|_gno|_cno|_sno/ and  sr["column_name"] !~ /_upd$/  and sr["column_name"].split("_")[0] != viewname.split("_")[1].chop
			indisp = sub_indisp(sr["column_name"],viewname) 
		end
        screenfields[:editable] =  indisp  
        screenfields[:hideflg] = 0
        screenfields[:id]  = proc_get_nextval("screenfields_seq")
        screens_id = ActiveRecord::Base.connection.select_value("select id from r_screens where pobject_code_scr = '#{viewname}' and screen_expiredate > current_date")
		if screens_id
			screenfields[:screens_id]   = screens_id
			if  sr["column_name"] =~ /_code|_name|_gno|_cno|_sno|itm_/ then
				screenfields[:hideflg] = 0
				screenfields[:selection] = 1
			else
				if  viewname.split(/_/)[1].chop  == sr["column_name"].split(/_/)[0] then  ## テーブ目名の「s」はふくめない。
					screenfields[:hideflg] = 0
					screenfields[:selection] = 1
				else
					screenfields[:hideflg] = 1
				end                          
			end
			screenfields[:hideflg]   = if sr["column_name"] =~ /_id/  or sr["column_name"] =="id" then 1 else 0 end 
			tid = plsql.pobjects.first("where code = '#{sr["column_name"]}' and objecttype ='view_field' and expiredate > current_date ")
			if tid then
				screenfields[:pobjects_id_sfd]   = tid[:id]   
            else
				tmp = prv_add_pobjects sr["column_name"],"view_field"
				screenfields[:pobjects_id_sfd] =  tmp[:id]      
			end
			if ii["fieldcode_fieldlength"] > 400  then
				screenfields[:type]   =  "textarea" 
				screenfields[:edoptrow]  = if (ii["fieldcode_fieldlength"] / 80).ceil > 10 then 10 else (ii["fieldcode_fieldlength"] / 80).ceil end
				screenfields[:edoptcols] = 80
			else
				screenfields[:type]   =   ii["fieldcode_ftype"].downcase
			end
			screenfields[:edoptmaxlength]   =  ii["fieldcode_fieldlength"]
			screenfields[:dataprecision]   =  (ii["fieldcode_dataprecision"]||=0)
			screenfields[:datascale]   =  (ii["fieldcode_datascale"]||=0)
			screenfields[:indisp]   =  indisp  
			screenfields[:width] =  if ii["fieldcode_fieldlength"] * 6 > 300 then 300  else ii["fieldcode_fieldlength"] * 6 end 
			screenfields[:width] = if /_upd$/ =~ sr["column_name"]     or  /_ip$/ =~ sr["column_name"] then 85 else screenfields[:width] end
			screenfields[:edoptsize]  =  if ii["fieldcode_fieldlength"] > 100 then 100 else ii["fieldcode_fieldlength"] end ## if ii["fieldcode_ftype"] == "date"  or  j[:data_type] =~ /timestamp/ 
			screenfields[:width] =  if ii["fieldcode_ftype"] == "date" or  ii["fieldcode_ftype"] =~ /timestamp/ then 9 else screenfields[:width] end
			if  viewname.split(/_/)[1].chop  == sr["column_name"].split(/_/)[0] ##同一テーブルの項目のみ変更可
				screenfields[:editable] =  1                  
				screenfields[:editable] = if /_ip$|_id|at$/ =~ sr["column_name"] then   0  else   screenfields[:editable]  end ##  ## 更新者と更新時間
			end
          
			##   editform positon 
			screenfields[:seqno] = 999 
			screenfields[:seqno] = 888 if  screenfields[:editable] == 1 
			##screenfields[:rowpos] = 999   if screenfields[:editable] ==  1 
			unless   screenfields[:pobjects_id_sfd] 
				tmp =  prv_add_pobjects sr["column_name"], "view_field"
				screenfields[:pobjects_id_sfd] =  tmp[:id]      
			end
			if screenfields[:editable] ==  1  then
				screenfields[:rowpos] = row_cnt
				screenfields[:colpos] = if sr["column_name"] =~ /_name/ then 2 else 1 end
			end
			strsql = "select id from r_screenfields where screenfield_pobject_id_sfd = #{screenfields[:pobjects_id_sfd]} and screenfield_screen_id = #{screens_id} " 
			chkfield = ActiveRecord::Base.connection.select_value(strsql)
			if chkfield.nil?
				plsql.screenfields.insert screenfields
			end
		else
			@errmsg = " screen_code not exists screen_code #{viewname}"
			raise
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
	  begin   
		@tsqlstr  =  "DROP TABLE " + "SIO_" + viewname  
		plsql.execute @tsqlstr
      rescue
			###例外が発生したときの処理
	  else
      # 例外が発生しなかったときに実行される処理
      ensure
      # 例外の発生有無に関わらず最後に必ず実行する処理
	  end         
		@tsqlstr =  "CREATE TABLE " + "SIO_" + viewname   + " (\n" 
		@tsqlstr <<  "          sio_id number(38)  CONSTRAINT " +  "SIO_" + viewname   + "_id_pk PRIMARY KEY \n"
		@tsqlstr <<  "          ,sio_user_code number(38)\n"
		@tsqlstr <<  "          ,sio_Term_id varchar(30)\n"
		@tsqlstr <<  "          ,sio_session_id number\n"
		@tsqlstr <<  "          ,sio_Command_Response char(1)\n"
		@tsqlstr <<  "          ,sio_session_counter number(38)\n"
		@tsqlstr <<  "          ,sio_classname varchar(50)\n" 
		@tsqlstr <<  "          ,sio_viewname varchar(30)\n" 
		@tsqlstr <<  "          ,sio_code varchar(30)\n"
		@tsqlstr <<  "          ,sio_strsql varchar(4000)\n"
		@tsqlstr <<  "          ,sio_totalcount number(38)\n"
		@tsqlstr <<  "          ,sio_recordcount number(38)\n"
		@tsqlstr <<  "          ,sio_start_record number(38)\n"
		@tsqlstr <<  "          ,sio_end_record number(38)\n"
		@tsqlstr <<  "          ,sio_sord varchar(256)\n"
		@tsqlstr <<  "          ,sio_search varchar(10)\n"
		@tsqlstr <<  "          ,sio_sidx varchar(256)\n"
		@tsqlstr  <<  sio_fields(viewname)
		@tsqlstr <<  "          ,sio_errline varchar(4000)\n"
		@tsqlstr <<  "          ,sio_org_tblname varchar(30)\n"
		@tsqlstr <<  "          ,sio_org_tblid number(38)\n"
		@tsqlstr <<  "          ,sio_add_time date\n"
		@tsqlstr <<  "          ,sio_replay_time date\n"
		@tsqlstr <<  "          ,sio_result_f char(1)\n"
		@tsqlstr <<  "          ,sio_message_code char(10)\n"
		@tsqlstr <<  "          ,sio_message_contents varchar(4000)\n"
		@tsqlstr <<  "          ,sio_chk_done char(1)\n"
		@tsqlstr <<  ")\n"
		fprnt @tsqlstr 
		plsql.execute @tsqlstr

		@tsqlstr =  " CREATE INDEX SIO_#{viewname}_uk1 \n"
		@tsqlstr << "  ON SIO_#{viewname}(sio_user_code,sio_session_counter,sio_session_id,sio_Command_Response) \n"
		@tsqlstr << "  TABLESPACE USERS  STORAGE (INITIAL 20K  NEXT 20k  PCTINCREASE 75)"  
		##fprnt @tsqlstr 
		plsql.execute @tsqlstr
		unless PLSQL::Sequence.find(plsql,"sio_#{viewname}_seq".to_sym)           
			@tsqlstr =  "create sequence SIO_" + viewname + "_seq" 
			plsql.execute @tsqlstr
		end
    end #crttype 
	def vproc_get_view_fieldname(viewname)
		ActiveRecord::Base.uncached() do
			case Db_adapter 
				when /oracle/
					ActiveRecord::Base.connection.select_all("select lower(column_name) column_name from USER_TAB_COLUMNS where  table_name = '#{viewname.upcase}'")
				when /post/
					ActiveRecord::Base.connection.select_all("SELECT column_name  FROM information_schema.columns WHERE   table_name = '#{viewname}'")
			end
		end
	end
	def sio_fields viewname
		sio_field_strsql = ""
		### blktbsfieldcode   xxxxxx  fieldcode_ftype  pobject_code_fld
		srfields = vproc_get_view_fieldname(viewname)
		row_cnt ||= 1
		srfields.each do |sr|
			row_cnt += 1          
			field = if sr["column_name"] == "id" then "id" else sr["column_name"].split("_",2)[1] end
			field.sub!("_id","s_id")
			strsql = %Q& select * from  r_fieldcodes where pobject_code_fld = '#{field}' and fieldcode_expiredate > current_date &
			ii = ActiveRecord::Base.connection.select_one(strsql)
			if ii.nil?
				delms =  sr["column_name"].split("_")
				i = delms.size
				while i >1 and ii.nil?
					field.sub!("_"+delms[i-1],"")
					strsql = %Q& select * from  r_fieldcodes where pobject_code_fld = '#{field}' and fieldcode_expiredate > current_date &
					ii = ActiveRecord::Base.connection.select_one(strsql)
					i -= 1
				end
				if ii.nil?
				debugger
					fprnt "line : #{__LINE__} -->sio_fields error field: #{sr["column_name"]} not find  viewname: #{viewname} "
					raise
				end
			end
			setscreenfields sr,ii,viewname,row_cnt   ## iiの中はscreens_id 「s」がつくよ
			sio_field_strsql << " ,"
			sio_field_strsql << sr["column_name"] + " " + ii["fieldcode_ftype"] 
			case  ii["fieldcode_ftype"]
				when /char/
					sio_field_strsql << "(" +  ii["fieldcode_fieldlength"].to_s + ") \n" 
			    when "number" 
					spr = if (ii["fieldcode_dataprecision"]||=0) != 0 then ii["fieldcode_dataprecision"].to_s  else "22" end
					ssc = if ii["fieldcode_datascale"] then ii["fieldcode_datascale"].to_s  else "0" end
					sio_field_strsql << if spr != "0" or ssc != "0"  then "(" +  spr + "," + ssc + ") \n"  else " \n" end
				else
					sio_field_strsql << " \n"
				###  p "a120" +  spr + "," + ssc 
			end 
		end   
		return sio_field_strsql
	end
	def crt_chil_screen viewname
##    p "addmain1"
##  対象となるテーブルは　idをフィールドに持つこと
## tablenameS_ID_xxx_xxxのレイアウトであること。
## viewの名前は R_xxxx のようにすること。
## 全テーブルに対応は中止した。
		tblarea = {}  
		notextview = {}
		strsql = "select * from  r_screenfields where pobject_code_view =  '#{viewname}' and screenfield_Expiredate > current_date "
		fields = ActiveRecord::Base.connection.select_all(strsql) 
		fields.each  do |tbldata|
			if tbldata[:object_code_sfd]  =~ /_id/ then
				pare_tbl = (tbldata["object_code_sfd"].split(/_id/)[0] + "S")
				tblarea[pare_tbl] = viewname
			end
		end
    
		y = ActiveRecord::Base.connection.select_value("select id from r_screens WHERE pobject_code_view = '#{viewname}' ")
		tblarea.each_key  do |i|
			x = ActiveRecord::Base.connection.select_value("select id from r_screens WHERE pobject_code_view = 'r_#{i}' ")
			next if x.nil?
			tmp_area = tblarea[i] 
            next if x.nil?
            chil_r = ActiveRecord::Base.connection.select_value("select * from ChilScreens where screens_id = #{x} and screens_id_chil = #{y}")
            if chil_r.nil?
                val_chil = {
					:id => plsql.chilscreens_seq.nextval,
                    :screens_id => x[:id],
                    :screens_id_chil => y[:id],
                    :expiredate => Time.parse("2099/12/31"),
                    :remark => "auto_create", 
                    :persons_id_upd => plsql.persons.first(:email =>current_user[:email])[:id]  , 
                    :update_ip =>  "1",
                    :created_at => Time.now,
                    :updated_at => Time.now
                    }
                  Chilscreen.create val_chil
                  ## p "insert"
            end ## if
		end    ## i
	end  #end crt_chil_screen 
	def prv_create_index_pk tblname
		case Db_adapter 
			when /oracle/
				seq = ActiveRecord::Base.connection.select_one("select sequence_name from user_sequences where sequence_name = '#{tblname.upcase}_SEQ'")
				### BLK_CONSTRAINTSは独自に作成したview  table_name, constraint_name, constraint_type, position, column_name
				strsql = " select * from BLK_CONSTRAINTS where table_name = '#{tblname.upcase}' and constraint_type in( 'P') "   ### 主keyとunique key
			when /post/
				seq = ActiveRecord::Base.connection.select_one("select relname from pg_statio_all_sequences where sequence_name = '#{tblname}_seq}'")
				strsql = " SELECT attr.attname AS column_name,cons.contype AS constraint_type
							FROM pg_attribute AS attr
							INNER JOIN pg_stat_user_tables AS stat
									ON attr.attrelid = stat.relid      AND stat.relname = '#{tblname}'
							INNER JOIN pg_constraint cons
									ON attr.attnum = ANY (cons.conkey)   AND cons.contype IN('p')   AND cons.conrelid = stat.relid"

		end
		c_keys = ActiveRecord::Base.connection.select_all(strsql)  ###主key
		if seq.nil? 
             @tsqlstr =  "create sequence " + tblname + "_seq" 
             ActiveRecord::Base.connection.execute @tsqlstr
		end
		id_sw = "on" 
		c_keys.each do |key|
			if key["column_name"].upcase == "ID" 
				id_sw = "off"
			else
				id_sw = "err"
				@errmsg << "#{key["column_name"]} is PRIMARY KEY"
				break
			end ### 主keyはidのみ   
		end
		if id_sw == "on" 
              @tsqlstr =  "ALTER TABLE " + tblname + "  add  CONSTRAINT #{tblname}_id_pk PRIMARY KEY(id) " 
              ActiveRecord::Base.connection.execute  @tsqlstr     
		end
	end
end

