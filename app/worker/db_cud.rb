class DbCud  < ActionController::Base
 ## @queue = :default
 ## def self.perform(sio_id,sio_view_name)
  def perform(sio_id,sio_view_name)
      begin
       @pare_class = "batch"
      strsql = "where sio_session_counter = #{sio_id} and sio_command_response = 'C'"
      ## fprnt"class #{self} : LINE #{__LINE__} sio_view_name: #{sio_view_name} strsql: #{strsql}"
      @chk_cmn =  plsql.__send__(sio_view_name).all(strsql)
      tblname = sio_view_name.split(/_/,3)[2]
      xtblname = tblname.downcase.chop
      @chk_cmn.each do |i|
	   tmp_key = {}
	   r_cnt = 0
	   to_command_r = {}
           i.each do |j,k|
                j_to_s = j.to_s
		 ## fprnt"class #{self} : LINE #{__LINE__} j_to_s: #{j_to_s} xtblname: #{xtblname}"
	        ###debugger
                if j_to_s.split(/_/,2)[0] == xtblname then  ##本体の更新
	           ###2013/3/25 追加覚書　 xxxx_id_yyyy   yyyy:自身のテーブルの追加  プラス _idをs_idに
	              to_command_r[j_to_s.split(/_/,2)[1].sub("_id","s_id").to_sym] = k  unless k.nil?  ###org tbl field name
                   else  ### link先のidを求める
	           if   j_to_s =~ /(_upd|sio_|id_tbl)/ or k.nil? or j_to_s == "id"  or j_to_s =~ /^sio_/ then
                        else
                        tmp_key[j] = k  if j_to_s =~ /(_code)/  ##tmp_key[j] = other tablename+_+fielfname+_+shikibetushi  <-- value
                   end  ## unless j_to_s
                end   ## if j_to_s.
           end ## j,k
           to_command_r.merge! sub_code_to_id(tmp_key)  ##codeからもとめたid優先
	   ##  fprnt"class #{self} : LINE #{__LINE__} sio_view_name: #{sio_view_name} strsql: #{strsql} ****person_id #{i[:person_id_upd]}"
	   to_command_r[:persons_id_upd] = i[:person_id_upd]
           to_command_r[:created_at] = Time.now
	   case i[:sio_classname]
                when "plsql_blk_insert" then
                    to_command_r[:id] = plsql.__send__(tblname + "_seq").nextval
		    fprnt "class #{self} : LINE #{__LINE__} INSERT : to_command_r = #{to_command_r}"
		    plsql.__send__(tblname).insert to_command_r
                when "plsql_blk_update" then
                    to_command_r[:where] = {:id => i[:id_tbl]}
                    fprnt "class #{self} : LINE #{__LINE__} update : to_command_r = #{to_command_r}"
		    ##debugger
                    plsql.__send__(tblname).update  to_command_r
                when "plsql_blk_delete" then 
                    plsql.__send__(tblname).delete(:id => i[:id_tbl])
		when "plsql_blk_copy_insert" then
                    to_command_r[:id] = plsql.__send__(tblname + "_seq").nextval
		    fprnt "class #{self} : LINE #{__LINE__} COPY INSERT : to_command_r = #{to_command_r}"
		    plsql.__send__(tblname).insert to_command_r
		    add_tbl_ctlxxxxxx i[:sio_org_tblname],i[:sio_org_tblid],tblname,to_command_r[:id] 
           end   ## case iud 
	   r_cnt += 1
	   tsio_r = {}
	   tsio_r = i
	   tsio_r[:id_tbl] =  to_command_r[:id] 
	   tsio_r[:sio_recordcount] = r_cnt
           tsio_r[:sio_result_f] = "0"
           tsio_r[:sio_message_contents] = nil
	   to_command_r.each do |i,j| 
	      if i.to_s =~ /s_id/ then
		 newi = i.to_s.sub("s_id","_id").to_sym
		 tsio_r[newi] = j if j
	      end
	   end
	    fprnt " LINE #{__LINE__}  "
	   insert_sio_r  tsio_r   ## 結果のsio書き込み
	   cmnd_code = "process_scrs_" + i[:sio_code]   ##画面ごとの処理
	   fprnt " LINE #{__LINE__}  i[:sio_code] = #{i[:sio_code]}  "
	   ##debugger
              create_def_screen  i[:sio_code]   unless respond_to?(cmnd_code)
	    fprnt " LINE #{__LINE__}  cmnd_code : #{cmnd_code}  "
	    ##debugger
              __send__(cmnd_code, tsio_r)  #### if respond_to?(cmnd_code)
            fprnt " LINE #{__LINE__} cmnd_code : #{cmnd_code} "
	   reset_show_data(i[:screen_code]) if tblname.upcase == "DETAILFIELDS"
      end   ##chk_cmn.each
      rescue
	      debugger
	      plsql.rollback
	      p " error line #{__LINE__}  sio_view_name = #{sio_view_name} "
	      ##debugger
            else
	      p "ok  line #{__LINE__}  sio_view_name = #{sio_view_name} "
	      plsql.commit   ### エラーが発生した時　6重に登録された。
     end   ## begin
  end   ##perform
  handle_asynchronously :perform
 end ## class

