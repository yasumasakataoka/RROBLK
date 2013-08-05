class DbCud  < ActionController::Base
 ## @queue = :default
 ## def self.perform(sio_id,sio_view_name)
   def command_r
      @command_r
  end
  def perform(sio_session_counter,sio_view_name)
      begin
     @command_r = {}
     command_r
       @pare_class = "batch"
      strsql = "where sio_session_counter = #{sio_session_counter} and sio_command_response = 'C'"
      ## fprnt"class #{self} : LINE #{__LINE__} sio_view_name: #{sio_view_name} strsql: #{strsql}"
      chk_cmn =  plsql.__send__(sio_view_name).all(strsql)
      tblname = sio_view_name.split(/_/,3)[2]
      xtblname = tblname.downcase.chop
      chk_cmn.each do |i|
	   tmp_key = {}
	   r_cnt = 0
	   to_cr = {}   ###テーブル更新用
           i.each do |j,k|
                j_to_s = j.to_s
		 ## fprnt"class #{self} : LINE #{__LINE__} j_to_s: #{j_to_s} xtblname: #{xtblname}"
	        ###debugger
                if j_to_s.split(/_/,2)[0] == xtblname then  ##本体の更新
	           ###2013/3/25 追加覚書　 xxxx_id_yyyy   yyyy:自身のテーブルの追加  プラス _idをs_idに
	              to_cr[j_to_s.split(/_/,2)[1].sub("_id","s_id").to_sym] = k  if k  ###org tbl field name
                   else  ### link先のidを求める
			 ##CODEでユニークにならなかった時の考慮が漏れている。
	           if   j_to_s =~ /(_upd|sio_)/ or k.nil? or j_to_s == "id"  or j_to_s =~ /^sio_/ then
                        else
			  case j_to_s 
                               when   /_code/  ##tmp_key[j] = other tablename+_+fielfname+_+shikibetushi  <-- value
				    tmp_key[j] = k  if i.key?((xtblname + "_" + j_to_s.sub("_code","_id")).to_sym)
			       ## when  /_id/
				####      to_cr[j_to_s.split(/_/,2)[1].sub("_id","s_id").to_sym] = k  if k 
		           end
                   end  ## unless j_to_s
                end   ## if j_to_s.
           end ## j,k
           to_cr.merge! sub_code_to_id(tmp_key)  ##codeからもとめたid優先
	   ##CODEでユニークにならないテーブルの考慮が漏れている。
	   ##  fprnt"class #{self} : LINE #{__LINE__} sio_view_name: #{sio_view_name} strsql: #{strsql} ****person_id #{i[:person_id_upd]}"
	   to_cr[:persons_id_upd] = i[(xtblname + "_person_id_upd").to_sym]
	   case i[:sio_classname]
                when "plsql_blk_insert" then
                    to_cr[:id] = plsql.__send__(tblname + "_seq").nextval
		    to_cr[:created_at] = Time.now
		    to_cr[:updated_at] = Time.now
		    fprnt "class #{self} : LINE #{__LINE__} INSERT : to_cr = #{to_cr}"
		    plsql.__send__(tblname).insert to_cr
                when "plsql_blk_update" then
                    to_cr[:where] = {:id => i[:id]}             ##update deleteの時はテーブル_idにはなにもセットされない。
		    to_cr[:updated_at] = Time.now
                    fprnt "class #{self} : LINE #{__LINE__} update : to_cr = #{to_cr}"
		    ##debugger
                    plsql.__send__(tblname).update  to_cr
                when "plsql_blk_delete" then 
                    plsql.__send__(tblname).delete(:id => i[:id])
		when "plsql_blk_copy_insert" then   ###画面から新しい画面に
                    to_cr[:id] = plsql.__send__(tblname + "_seq").nextval
		    fprnt "class #{self} : LINE #{__LINE__} COPY INSERT : to_cr = #{to_cr}"
		    to_cr[:created_at] = Time.now
		    to_cr[:updated_at] = Time.now
		    plsql.__send__(tblname).insert to_cr
		    add_tbl_ctlxxxxxx i[:sio_org_tblname],i[:sio_org_tblid],tblname,to_cr[:id] 
		when "plsql_blk_chk_insert" then   ##バランスチェック
                    to_cr[:id] = plsql.__send__(tblname + "_seq").nextval
		    to_cr[:created_at] = Time.now
		    to_cr[:updated_at] = Time.now
		    fprnt "class #{self} : LINE #{__LINE__} chk INSERT : to_cr = #{to_cr}"
		    plsql.__send__(tblname).insert to_cr
		end   ## case iud 
	   r_cnt += 1
	   ##debugger
               command_r = i
	       command_r[:id] = command_r[(xtblname + "_id").to_sym] =  to_cr[:id]   if i[:sio_classname] =~/_insert/
	       command_r[:sio_recordcount] = r_cnt
               command_r[:sio_result_f] = "0"
               command_r[:sio_message_contents] = nil
	       to_cr.each do |i,j| 
	          if i.to_s =~ /s_id/ then
		     newi = (xtblname + "_" + i.to_s.sub("s_id","_id")).to_sym
		     command_r[newi] = j if j
	          end
	        end
	   sub_insert_sio_r   command_r do
	   end	   ## 結果のsio書き込み
	   cmnd_code = "process_scrs_" + i[:sio_code]   ##画面ごとの処理
	   fprnt " LINE #{__LINE__}  i[:sio_code] = #{i[:sio_code]}  "
	   ##debugger
              create_def_screen  i[:sio_code]   unless respond_to?(cmnd_code)
	    fprnt " LINE #{__LINE__}  cmnd_code : #{cmnd_code}   \n #{command_r}"
	    ##debugger
              __send__(cmnd_code, command_r)  #### if respond_to?(cmnd_code)
            fprnt " LINE #{__LINE__} cmnd_code } "
	   reset_show_data(i[:screen_code]) if tblname.upcase == "DETAILFIELDS"
      end   ##chk_cmn.each
      rescue
	      plsql.rollback
	      p  $!
	      p  $@
	      p " rescue line #{__LINE__}  sio_view_name = #{sio_view_name} "
	      fprnt  " err object    #{$!}"
	      fprnt  "err line  #{$@}"
	      fprnt " resure line #{__LINE__}  sio_view_name = #{sio_view_name} "

	      ##debugger
            else
	      p "ok  line #{__LINE__}  sio_view_name = #{sio_view_name} "
	      plsql.commit   ### エラーが発生した時　6重に登録された。
     end   ## begin
  end   ##perform
  handle_asynchronously :perform
 end ## class

