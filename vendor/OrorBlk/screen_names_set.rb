class AddScreen
 def initialize 
    @strsql = ""
    @tblnamex = ""
    @detailfields  = {}
    if defined?(ActionController).nil?
       require 'socket'
       @myname = Socket::gethostname
       @myip = IPSocket.getaddress(Socket::gethostname)
      else
       @myip =  request.remote_ip
     end  ##if defined?
     
    ##   viewにspaceが入っているとspaceがカットされる。 
    @crt_screen_name = <<-SQL1
      insert into screens(id,ViewName,Expiredate,Remark,
                    code,Persons_id_Upd,created_at,Updated_at)
      select screens_seq.nextval,view_name,'2099/12/31','auto_crt',
              view_name,1, sysdate,sysdate from   user_views a 
      where not exists   
       (select 1 from screens b where a.view_name = b.viewname)
        and view_name like 'R_%' 
      SQL1

   @crt_pobject_code = <<-SQL2
      insert into pobjects(id,objecttype,Expiredate,Remark,
                    code,Persons_id_Upd,created_at,Updated_at)
      select screens_seq.nextval,'A','2099/12/31','auto_crt',
              viewname,1, sysdate,sysdate from   screens a 
      where not exists   
       (select 1 from pobjects b where a.code = b.code and objecttype = 'A')
    SQL2

    @crt_screen_dtl = <<-SQL3
       B.ID SCREENS_ID,COLUMN_NAME,
       DATA_TYPE ,TABLE_NAME,
       DATA_LENGTH,DATA_PRECISION,DATA_SCALE
       FROM USER_TAB_COLUMNS A,SCREENS B
       WHERE TABLE_NAME = VIEWNAME
    SQL3
     ##
end  ## initialize   
def  init_detailfields
      @detailfields = 
         {:selection   =>  1,
          :expiredate   => Time.parse("2099/12/31"),
          :remark   => "auto_crt",
          :persons_id_upd   => 1,
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
def addmain tblname
    @tblnamex = tblname
    plsql.execute  @crt_screen_name   ## list 用メニュー作成
    plsql.execute   @crt_pobject_code    ## 画面の名前の元ネタ作成
    ### p @crt_screen_name.gsub("@type@",screen_type)
    tmp_screen_dtl = "SELECT DetailFields_SEQ.NEXTVAL SEQ," + @crt_screen_dtl  + " AND TABLE_NAME = '#{@tblnamex}'  "
    tsqlstr = "delete from  detailfields where id  in ( select id from  r_detailfields "
    tsqlstr << " where  screen_viewname = '#{tblname}'  and Expiredate > sysdate )"
    plsql.execute tsqlstr
    fields = plsql.select(:all,tmp_screen_dtl)   ###テーブルの項目をセット
    fields.each  do |ii|
       setdetailfields ii,tblname  ## iiの中はscreens_id 「s」がつくよ
    end
    
   crttype                     ##interface用　ｓｉｏ作成
 end  #end addmain 
 def setdetailfields   ii,tblname
       init_detailfields
       indisp = 0 
       indisp = sub_indisp(ii,tblname,"_CODE")  if ii[:column_name] =~ /_CODE/ and  ii[:column_name] != "PERSON_CODE_UPD"  and ii[:column_name].split(/_CODE/)[0] != tblname[2..-2]
       indisp = sub_indisp(ii,tblname,"_NAME")  if ii[:column_name] =~ /_NAME/ and  ii[:column_name] != "PERSON_NAME_UPD"  and ii[:column_name].split(/_NAME/)[0] != tblname[2..-2]
        @detailfields[:hideflg] = 0
        @detailfields[:id]  = ii[:seq]
        @detailfields[:screens_id] = ii[:screens_id]
        @detailfields[:hideflg]   = if ii[:column_name] =~ /_ID/ then 1 else 0 end 
        if  ii[:column_name] =~ /CODE/ or ii[:column_name] =~ /NAME/ then
              @detailfields[:hideflg] = 0
           else
             if  ii[:table_name][2..-2] == ii[:column_name].split(/_/)[0] then  ## テーブ目名の「s」はふくめない。
                  @detailfields[:hideflg] = 0
                else
                  @detailfields[:hideflg] = 1
              end                          
         end
         @detailfields[:code]   = ii[:column_name]
	if ii[:data_length] >=100  then
	   @detailfields[:type]   =  "textarea" 
	   @detailfields[:edoptrow]  = if (ii[:data_length] / 80).ceil > 10 then 10 else (ii[:data_length] / 80).ceil end
	   @detailfields[:edoptcols] = 80
	   else
           @detailfields[:type]   =   ii[:data_type] 
	 end
	 @detailfields[:edoptmaxlength]   =  ii[:data_length]
         @detailfields[:dataprecision]   =  ii[:data_precision]
         @detailfields[:datascale]   =  ii[:data_scale]
         @detailfields[:indisp]   =  indisp  
         @detailfields[:editable] =  0
         ### @detailfields[:editablehide] =  nil
	 @detailfields[:width] =  if ii[:data_length] * 6 > 300 then 300  else ii[:data_length] * 6 end 
         @detailfields[:width] =  60 if  /_UPD$/ =~ ii[:column_name]      or  /_UPDATE_IP$/ =~ ii[:column_name] 
	 @detailfields[:edoptsize]  =  @detailfields[:edoptmaxlength]  
         @detailfields[:edoptsize]  =  10 if ii[:data_type] == "DATE"
         @detailfields[:width] =   60 if ii[:data_type] == "DATE"
         ## p "ii[:table_name] : #{ii[:table_name]}"
         ## p "ii[:column_name].split(/_/)[0] #{ii[:column_name].split(/_/)[0]}"
         if  ii[:table_name][2..-2] == (ii[:column_name].split(/_/)[0]) then   ##同一テーブルの項目のみ変更可
             @detailfields[:editable] =  1                  
             @detailfields[:editable] =  0 if /_UPDATE_IP$/ =~ ii[:column_name]     ##  
             @detailfields[:editable] =  0 if /_ID_UPD$/ =~ ii[:column_name]     ## 更新者と更新時間          
             @detailfields[:editable] =  0 if  /_CREATED_AT$/ =~ ii[:column_name]         
             @detailfields[:editable] =  0 if  /_UPDATED_AT$/ =~ ii[:column_name]                 
             ## @detailfields[:editablehide] =  "ADD" if /_UPDATE_IP$/ =~ ii[:column_name]     ##  
             ## @detailfields[:editablehide] =  "ADD" if /_ID_UPD$/ =~ ii[:column_name]     ## 更新者と更新時間          
             ## @detailfields[:editablehide] =  "ADD" if  /_CREATED_AT$/ =~ ii[:column_name]         
             ## @detailfields[:editablehide] =  "ADD" if  /_UPDATED_AT$/ =~ ii[:column_name]  
           ###  p " xx indisp #{ @detailfields[:editable] } ,ii[:column_name] :#{ii[:column_name] } "  if ii[:column_name] =~ /_CODE/ 
         end
          
         @detailfields[:editable] = indisp if ii[:column_name] =~ /_CODE/ and ii[:column_name] != "PERSON_CODE_UPD"  and  ii[:column_name].split(/_CODE/)[0] != tblname[2..-2] 
         ##   editform positon 
         @detailfields[:seqno] = 999 
         @detailfields[:seqno] = 88 if  @detailfields[:editable] == 1 
         @detailfields[:rowpos] = 999   if @detailfields[:editable] ==  1 
         @detailfields[:colpos] = 1     if @detailfields[:editable] ==  1 
         ## p " yy indisp #{ @detailfields[:editable] } ,ii[:column_name] :#{ii[:column_name] } "  if ii[:column_name] =~ /_CODE/ 
         fprnt " @detailfields = #{@detailfields}"
         plsql.detailfields.insert @detailfields
         @strsql << " ,"
         @strsql << ii[:column_name] + " " + ii[:data_type]
         @strsql << "(" +  ii[:data_length].to_s + ")" if ii[:data_type] =~ /CHAR/
         if ii[:data_type] == "NUMBER" then
             spr = ii[:data_precision].to_s
             ssc = ii[:data_scale].to_s
             @strsql << "(" +  spr + "," + ssc + ")" if spr =~ /[0..9]/
             ###  p "a120" +  spr + "," + ssc 
         end    
         crttype if @tblnamex != ii[:table_name] 
         @tblnamex = ii[:table_name]
 end ##setdetailfields  \
 def sub_indisp  ii,tblname,chngchar   ##孫のテーブルのidは不要　edit addの時必須にしない。
     chk_screen_id = "SELECT 1," + @crt_screen_dtl  + " AND TABLE_NAME = '#{tblname}'  "
     tblname_of_id = ii[:column_name].sub( chngchar,"_ID")
     chk_screen_id << " and A.COLUMN_NAME =  '#{tblname_of_id}' " 
     ##  p " chk_screen_id = '#{chk_screen_id}'"
     if plsql.select(:first,chk_screen_id) then
        indisp = 1
       else
        indisp = 0
      end
     return  indisp
end 
def crttype     
foo = File.open("screen_names_set.log", "a") # 書き込みモード

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
     tsqlstr <<  "          id numeric(38)  CONSTRAINT " +  "SIO_" + @tblnamex   + "_id_pk PRIMARY KEY \n"
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
     foo.puts tsqlstr 
     plsql.execute tsqlstr

     tsqlstr =  " CREATE INDEX SIO_#{@tblnamex}_uk1 \n"
     tsqlstr << "  ON SIO_#{@tblnamex}(sio_user_code,sio_session_id) \n"
     tsqlstr << "  TABLESPACE USERS  STORAGE (INITIAL 20K  NEXT 20k  PCTINCREASE 75)"  
     foo.puts tsqlstr 
     foo.close  

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
      sql = "SELECT * FROM USER_TAB_COLUMNS WHERE TABLE_NAME = '#{@tblnamex}' "
      fields = plsql.select(:all,sql)
      fields.each do |ii|
         @strsql << " ,"
         jj = ii[:column_name]
         jj <<  "_tbl" if jj == "ID"
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
 def crt_chil_screen tblname
##    p "addmain1"
##  対象となるテーブルは　idをフィールドに持つこと
## tablenameS_ID_xxx_xxxのレイアウトであること。
## viewの名前は R_xxxx のようにすること。
## 全テーブルに対応は中止した。
    tblarea = {}  
    notextview = {}
    strsql = " where screen_viewname =  '#{tblname}' and detailfield_Expiredate > sysdate "
       fields = plsql.R_detailfields.all(strsql)
       ## p "strsql : #{strsql}"
    ## p fields   
##    p "addmain2"
    fields.each  do |tbldata|
       if tbldata[:detailfield_code]  =~ /_ID/ then
          pare_tbl_sym = (tbldata[:detailfield_code].split(/_ID/)[0] + "S").to_sym
          tblarea[pare_tbl_sym] = tblname
       end
    end
    
    y = plsql.screens.first("WHERE ViewName = '#{tblname}' ")
    tblarea.each_key  do |i|
        x = plsql.screens.first("WHERE ViewName = 'R_#{i.to_s}' ")
        next if x.nil?
        ## p "i " + "WHERE ViewName like '%#{i.to_s.upcase}' "
        tmp_area = tblarea[i] 
              next if x.nil?
              ## p "WHERE ViewName like '%#{j.to_s.upcase}' "
                 chil_r = plsql.ChilScreens.first("where screens_id = :1 and screens_id_chil = :2",x[:id],y[:id])
                 ##  p  "where screens_id_Pare = :1 and screens_id = :2"
                 if chil_r.nil? then
                    val_chil = {
                    :id => plsql.chilscreens_seq.nextval,
                    :screens_id => x[:id],
                    :screens_id_chil => y[:id],
                    :expiredate => Time.parse("2099/12/31"),
                    :remark => "auto_create", 
                    :persons_id_upd => 1, 
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

