class AddScreen
 def initialize 
    @strsql = ""
    @tblnamex = ""
    @screenfields  = {}
    if defined?(ActionController).nil?
       require 'socket'
       @myname = Socket::gethostname
       @myip = IPSocket.getaddress(Socket::gethostname)
      else
       @myip =  request.remote_ip
     end  ##if defined?
     
    ##   viewにspaceが入っているとspaceがカットされる。 
    @crt_screen_name = <<-SQL1
      insert into screens(id,tcode_view,Expiredate,Remark,
                    tcode,Persons_id_Upd,created_at,Updated_at)
      select screens_seq.nextval,lower(view_name),'2099/12/31','auto_crt',
              lower(view_name),0, sysdate,sysdate from   user_views a 
      where not exists   
       (select 1 from screens b where lower(a.view_name) = b.tcode_view)
      SQL1

   @crt_pobject_code_view = <<-SQL2
      insert into pobjects(id,objecttype,Expiredate,Remark,
                    tcode,Persons_id_Upd,created_at,Updated_at)
      select pobjects_seq.nextval,'view','2099/12/31','auto_crt',
              tcode,0, sysdate,sysdate from   screens a 
      where not exists   
       (select 1 from pobjects b where a.tcode_view = b.tcode and objecttype = 'view')
    SQL2
       @crt_pobject_code_screen = <<-SQL23
      insert into pobjects(id,objecttype,Expiredate,Remark,
                    tcode,Persons_id_Upd,created_at,Updated_at)
      select pobjects_seq.nextval,'screen','2099/12/31','auto_crt',
              tcode,0, sysdate,sysdate from   screens a 
      where not exists   
       (select 1 from pobjects b where a.tcode_view = b.tcode and objecttype = 'screen')
    SQL23


       @crt_pobject_code_tbl = <<-SQL25
      insert into pobjects(id,objecttype,Expiredate,Remark,
                    tcode,Persons_id_Upd,created_at,Updated_at)
      select pobjects_seq.nextval,'tbl','2099/12/31','auto_crt',
              replace(tcode,'r_',''),0, sysdate,sysdate from   screens a 
      where not exists   
       (select 1 from pobjects b where replace(a.tcode,'r_','') = b.tcode and objecttype = 'tbl')
    SQL25

   @crt_blktables = <<-SQL28
      insert into blktables(id,tcode,Expiredate,Remark,
                    Persons_id_Upd,created_at,Updated_at)
      select blktables_seq.nextval,tcode,'2099/12/31','auto_crt',
              0, sysdate,sysdate from  pobjects a 
      where a.objecttype = 'tbl' and  not exists   
       (select 1 from blktables b where a.tcode = b.tcode and a.objecttype = 'tbl')
   SQL28

    @crt_screen_dtl = <<-SQL3
       B.ID SCREENS_ID,COLUMN_NAME,
       DATA_TYPE ,TABLE_NAME,
       DATA_LENGTH,DATA_PRECISION,DATA_SCALE
       FROM USER_TAB_COLUMNS A,SCREENS B
       WHERE TABLE_NAME = tcode_view
    SQL3
 end ## initialize   

 def set_sql
    ###テーブル画面は大文字　項目は小文字
    @crt_pobject_code_field = <<-SQL4
      insert into pobjects(id,objecttype,Expiredate,Remark,
                    tcode,Persons_id_Upd,created_at,Updated_at)
      select pobjects_seq.nextval,'view_field','2099/12/31','auto_crt',
              tcode,0, sysdate,sysdate
     from (select tcode from   screenfields  group by tcode) a 
      where not exists   
       (select 1 from pobjects b where a.tcode = b.tcode and objecttype = 'view_field')
    SQL4

    @crt_pobject_code_field1 = <<-SQL5
      insert into pobjects(id,objecttype,Expiredate,Remark,
                    tcode,Persons_id_Upd,created_at,Updated_at)
      select pobjects_seq.nextval,'view_field','2099/12/31','auto_crt',
              lower(column_name),0, sysdate,sysdate from   USER_TAB_COLUMNS a 
      where not exists   
       (select 1 from pobjects b where lower(a.column_name) = b.tcode and objecttype = 'view_field' ) and table_name = '#{@tblnamex.split("_")[1]}'
    SQL5

     @crt_pobject_code_field2 = <<-SQL6
      insert into pobjects(id,objecttype,Expiredate,Remark,
                    tcode,Persons_id_Upd,created_at,Updated_at)
      select pobjects_seq.nextval,'view_field','2099/12/31','auto_crt',
              '#{@tblnamex.split("_")[1].chop}',0, sysdate,sysdate from   dual 
      where not exists   
       (select 1 from pobjects b where  b.tcode = '#{@tblnamex.split("_")[1].chop}'   and objecttype = 'view_field' )
    SQL6
 end




     ##
 def  init_screenfields
      @screenfields = 
         {:selection   =>  1,
          :expiredate   => Time.parse("2099/12/31"),
          :remark   => "auto_crt",
          :persons_id_upd   => 0,
          :update_ip   => @myip,
          :created_at   => Time.now,
          :updated_at   => Time.now,
          :paragraph => nil,
          :edoptvalue => nil,
          :subindisp => nil,
          :editable => nil
          }
end # 
def fprnt str
    foo = File.open("blk#{Process::UID.eid.to_s}.log", "a") # 書き込みモード
    foo.puts str
    foo.close
end   ##fprnt str
def addmain viewname     ### viewname = "R_xxxxxxxS"   <==== R_xxxxxS_ID
    @tblnamex = viewname
    plsql.execute  @crt_screen_name   ## list 用メニュー作成
    plsql.execute   @crt_pobject_code_view    ##pobject view
    plsql.execute   @crt_pobject_code_tbl     ## pobject tbl
    plsql.execute   @crt_pobject_code_screen   ## pobject screen
    plsql.execute   @crt_blktables   ## pobject screen
    ### p @crt_screen_name.gsub("@type@",screen_type)
    ##tmp_screen_dtl = "SELECT " + @crt_screen_dtl  + " AND TABLE_NAME = '#{@tblnamex}' order by column_name "
    tsqlstr = "delete from  screenfields where (id  in ( select id from  r_screenfields "
    tsqlstr << " where  screen_tcode_view = '#{viewname}'  and Expiredate > sysdate )"
    tsqlstr << " and created_at = updated_at ) or " ##自動作成分のみ削除
    tsqlstr << " not exists(select 1 from  USER_TAB_COLUMNS where lower(table_name) =  '#{viewname}' and tcode = lower(column_name))" 
    tsqlstr << " and screens_id =  (select id from  screens  where  tcode_view = '#{viewname}'  and Expiredate > sysdate  and rownum <2)"
    plsql.execute tsqlstr
    fields = plsql.__send__(viewname).columns  ###select(:all,tmp_screen_dtl)   ###テーブルの項目をセット  R_xxxx
    @row_cnt = 0
    @code_pos = {}
    @editable_code_name = []
    screen_id = plsql.screens.first("where tcode_view = '#{viewname}' and Expiredate > sysdate ")[:id]
    fields.each  do |ii,jj|
       setscreenfields ii.to_s,jj,viewname,screen_id,fields  ## iiの中はscreens_id 「s」がつくよ
    end    
   crttype                     ##interface用　ｓｉｏ作成
   set_sql
   fprnt "@crt_pobject_code_field2 = #{@crt_pobject_code_field2}"
   plsql.execute   @crt_pobject_code_field
   plsql.execute   @crt_pobject_code_field1
   plsql.execute   @crt_pobject_code_field2
 end  #end addmain 
 def setscreenfields   ii,jj,viewname,screen_id,fields
       init_screenfields
       indisp = 0 
       indisp = sub_indisp(ii,viewname)  if (ii =~ /_code/ or ii =~ /_name/) and  ii !~ /_upd$/  and ii.split(/_/)[0] != viewname.split("_")[1].chop
       ### indisp = sub_indisp(ii,viewname,"_NAME")  if ii[:column_name] =~ /_NAME/ and  ii[:column_name] != "PERSON_NAME_UPD"  and ii[:column_name].split(/_NAME/)[0] != viewname[2..-2]
        ##@screenfields[:editable] =  0
        ##@screenfields[:editable] = indisp  
        @screenfields[:hideflg] = 0
        @screenfields[:id]  = plsql.screenfields_seq.nextval
        @screenfields[:screens_id] = screen_id
	if  ii =~ /_code/ or ii =~ /_name/ then
              @screenfields[:hideflg] = 0
           else
             if  viewname.split(/_/)[1].chop  == ii.split(/_/)[0] then  ## テーブ目名の「s」はふくめない。
                  @screenfields[:hideflg] = 0
                else
                  @screenfields[:hideflg] = 1
              end                          
         end
        @screenfields[:hideflg]   = if ii =~ /_id/  or ii =="id" then 1 else 0 end 
        @screenfields[:tcode]   = ii
	if jj[:data_length] > 100  then
	   @screenfields[:type]   =  "textarea" 
	   @screenfields[:edoptrow]  = if (jj[:data_length] / 80).ceil > 10 then 10 else (jj[:data_length] / 80).ceil end
	   @screenfields[:edoptcols] = 80
	   else
           @screenfields[:type]   =   jj[:data_type] 
	 end
	 @screenfields[:edoptmaxlength]   =  jj[:data_length]
         @screenfields[:dataprecision]   =  jj[:data_precision]
         @screenfields[:datascale]   =  jj[:data_scale]
         @screenfields[:indisp]   =  indisp  
	 ### @screenfields[:editablehide] =  nil
	 @screenfields[:width] =  if jj[:data_length] * 6 > 300 then 300  else jj[:data_length] * 6 end 
         @screenfields[:width] =  60 if  /_upd$/ =~ ii      or  /_ip$/ =~ ii 
	 @screenfields[:edoptsize]  =  @screenfields[:edoptmaxlength]  
         @screenfields[:edoptsize]  =  10 if jj[:data_type] == "DATE"
         @screenfields[:width] =   60 if jj[:data_type] == "DATE"
         ## p "ii[:table_name] : #{ii[:table_name]}"
         ## p "ii[:column_name].split(/_/)[0] #{ii[:column_name].split(/_/)[0]}"
         if  viewname.split(/_/)[1].chop  == ii.split(/_/)[0] then   ##同一テーブルの項目のみ変更可
             @screenfields[:editable] =  1                  
             @screenfields[:editable] =  0 if /_ip$/ =~ ii     ##  
             @screenfields[:editable] =  0 if /_id/ =~ ii   ## 更新者と更新時間          
             @screenfields[:editable] =  0 if  /_at$/ =~ ii     
	     ##@editable_code_name <<  ii.split(/_/)[0] if /_id/ =~ ii  and /person/ !~ ii
             ##@screenfields[:editable] =  0 if  /_UPDATED_AT$/ =~ ii[:column_name]                 
             ## @screenfields[:editablehide] =  "ADD" if /_UPDATE_IP$/ =~ ii[:column_name]     ##  
             ## @screenfields[:editablehide] =  "ADD" if /_ID_UPD$/ =~ ii[:column_name]     ## 更新者と更新時間          
             ## @screenfields[:editablehide] =  "ADD" if  /_CREATED_AT$/ =~ ii[:column_name]         
             ## @screenfields[:editablehide] =  "ADD" if  /_UPDATED_AT$/ =~ ii[:column_name]  
           ###  p " xx indisp #{ @screenfields[:editable] } ,ii[:column_name] :#{ii[:column_name] } "  if ii[:column_name] =~ /_CODE/ 
         end
          
         ##   editform positon 
         @screenfields[:seqno] = 999 
         @screenfields[:seqno] = 888 if  @screenfields[:editable] == 1 
         ##@screenfields[:rowpos] = 999   if @screenfields[:editable] ==  1 
         if (@screenfields[:editable] ==  1 or indisp == 1) and  ( @screenfields[:tcode] =~ /_code/ or  @screenfields[:tcode] =~ /_name/) then 
	    key = @screenfields[:tcode].sub(@screenfields[:tcode].split("_")[1],"").to_sym
	    @screenfields[:rowpos] =  @row_cnt  += 1 if @code_pos[key].nil?
            @code_pos[key] = @row_cnt if @code_pos[key].nil?
	    @screenfields[:rowpos] = @code_pos[key]  if @code_pos[key]
	     @screenfields[:editable] =  1 
	     @screenfields[:indisp]  = 1
	     @screenfields[:indisp]  = 0 if  @screenfields[:tcode] =~ /_name/
	   else
	     @screenfields[:rowpos] =  @row_cnt  += 1   if @screenfields[:editable] ==  1 or indisp == 1
	 end
	 @screenfields[:colpos] = 1     if @screenfields[:editable] ==  1 
	 @screenfields[:colpos] = 2     if @screenfields[:editable] ==  1  and  @screenfields[:tcode] =~ /_name/
	 ### 他の同一テーブルに必須項目は　codeとNAMEだけ 項目別にソート済
	 ##@screenfields[:rowpos] = @row_cnt     if @screenfields[:editable] ==  1  and  @screenfields[:tcode] =~ /_name/
         fprnt " @screenfields = #{@screenfields}"
         plsql.screenfields.insert @screenfields unless  plsql.screenfields.first("where tcode = '#{@screenfields[:tcode]}' and screens_id = #{@screenfields[:screens_id]} and to_char(EXPIREDATE,'yyyy/mm/dd') = '#{@screenfields[:expiredate].strftime("%Y/%m/%d")}'") 
         @strsql << " ,"
         @strsql << ii + " " + jj[:data_type]
         @strsql << "(" +  jj[:data_length].to_s + ")" if jj[:data_type] =~ /CHAR/
         if jj[:data_type] == "NUMBER" then
             spr = jj[:data_precision].to_s
             ssc = jj[:data_scale].to_s
             @strsql << "(" +  spr + "," + ssc + ")" if spr =~ /[0..9]/
             ###  p "a120" +  spr + "," + ssc 
         end    
        ### crttype if @tblnamex != ii[:table_name] 
        ## @tblnamex = ii[:table_name]
 end ##setscreenfields  \
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
def crttype     
 sio_fields
 begin   
   tsqlstr  =  "DROP TABLE " + "SIO_" + @tblnamex  
   plsql.execute tsqlstr
   rescue
    # 例外が発生したときの処理
   else
      # 例外が発生しなかったときに実行される処理
   ensure
      # 例外の発生有無に関わらず最後に必ず実行する処理
  end         
     tsqlstr =  "CREATE TABLE " + "SIO_" + @tblnamex   + " (\n" 
     tsqlstr <<  "          sio_id numeric(38)  CONSTRAINT " +  "SIO_" + @tblnamex   + "_id_pk PRIMARY KEY \n"
     tsqlstr <<  "          ,sio_user_code numeric(38)\n"
     tsqlstr <<  "          ,sio_Term_id varchar(30)\n"
     tsqlstr <<  "          ,sio_session_id varchar(256)\n"
     tsqlstr <<  "          ,sio_Command_Response char(1)\n"
     tsqlstr <<  "          ,sio_session_counter numeric(38)\n"
     tsqlstr <<  "          ,sio_classname varchar(30)\n" 
     tsqlstr <<  "          ,sio_viewname varchar(30)\n" 
     tsqlstr <<  "          ,sio_code varchar(30)\n"
     tsqlstr <<  "          ,sio_strsql varchar(4000)\n"
     tsqlstr <<  "          ,sio_totalcount numeric(38)\n"
     tsqlstr <<  "          ,sio_recordcount numeric(38)\n"
     tsqlstr <<  "          ,sio_start_record numeric(38)\n"
     tsqlstr <<  "          ,sio_end_record numeric(38)\n"
     tsqlstr <<  "          ,sio_sord varchar(256)\n"
     tsqlstr <<  "          ,sio_search varchar(10)\n"
     tsqlstr <<  "          ,sio_sidx varchar(256)\n"
     tsqlstr  <<  @strsql
     tsqlstr <<  "          ,sio_org_tblname varchar(30)\n"
     tsqlstr <<  "          ,sio_org_tblid numeric(38)\n"
     tsqlstr <<  "          ,sio_add_time date\n"
     tsqlstr <<  "          ,sio_replay_time date\n"
     tsqlstr <<  "          ,sio_result_f char(1)\n"
     tsqlstr <<  "          ,sio_message_code char(10)\n"
     tsqlstr <<  "          ,sio_message_contents varchar(256)\n"
     tsqlstr <<  "          ,sio_chk_done char(1)\n"
     tsqlstr <<  ")\n"
     fprnt tsqlstr 
     plsql.execute tsqlstr

     tsqlstr =  " CREATE INDEX SIO_#{@tblnamex}_uk1 \n"
     tsqlstr << "  ON SIO_#{@tblnamex}(sio_user_code,sio_session_id) \n"
     tsqlstr << "  TABLESPACE USERS  STORAGE (INITIAL 20K  NEXT 20k  PCTINCREASE 75)"  
     fprnt tsqlstr 
   plsql.execute tsqlstr
   
  begin                        
    tsqlstr =  "drop sequence SIO_" + @tblnamex + "_seq"
    plsql.execute tsqlstr 
  rescue
  end    ### begin 
     tsqlstr =  "create sequence SIO_" + @tblnamex + "_seq" 
     plsql.execute tsqlstr
   

end #crttype 
 def sio_fields
      @strsql = ""
      #sql = "SELECT * FROM USER_TAB_COLUMNS WHERE TABLE_NAME = '#{@tblnamex}' "
      #fields = plsql.select(:all,sql)
      fields = plsql.__send__(@tblnamex).columns    ### @tblname = R_xxxxx
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
    strsql = " where screen_tcode_view =  '#{viewname}' and screenfield_Expiredate > sysdate "
       fields = plsql.R_screenfields.all(strsql)
       ## p "strsql : #{strsql}"
    ## p fields   
##    p "addmain2"
    fields.each  do |tbldata|
       if tbldata[:screenfield_tcode]  =~ /_id/ then
          pare_tbl_sym = (tbldata[:screenfield_tcode].split(/_id/)[0] + "S").to_sym
          tblarea[pare_tbl_sym] = viewname
       end
    end
    
    y = plsql.screens.first("WHERE tcode_view = '#{viewname}' ")
    tblarea.each_key  do |i|
        x = plsql.screens.first("WHERE tcode_view = 'r_#{i.to_s}' ")
        next if x.nil?
        ## p "i " + "WHERE tcode_view like '%#{i.to_s}' "
        tmp_area = tblarea[i] 
              next if x.nil?
              ## p "WHERE tcode_view like '%#{j.to_s}' "
                 chil_r = plsql.ChilScreens.first("where screens_id = :1 and screens_id_chil = :2",x[:id],y[:id])
                 ##  p  "where screens_id_Pare = :1 and screens_id = :2"
                 if chil_r.nil? then
                    val_chil = {
                    :id => plsql.chilscreens_seq.nextval,
                    :screens_id => x[:id],
                    :screens_id_chil => y[:id],
                    :expiredate => Time.parse("2099/12/31"),
                    :remark => "auto_create", 
                    :persons_id_upd => 0, 
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
end   #class AddScreena

