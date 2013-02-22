class DbCud  < ActionController::Base
 ## @queue = :default
 ## def self.perform(sio_id,sio_view_name)
  def perform(sio_id,sio_view_name)
      strsql = "where sio_session_counter = #{sio_id} and sio_command_response = 'C'"
      fprnt"class #{self} : LINE #{__LINE__} sio_view_name: #{sio_view_name} strsql: #{strsql}"
      @chk_cmn =  plsql.__send__(sio_view_name).all(strsql)
      tblname = sio_view_name.split(/_/,3)[2]
      xtblname = tblname.downcase.chop
      @chk_cmn.each do |i|
	   tmp_key = {}
	   r_cnt = 0
	   to_command_r = {}
           i.each do |j,k|
                j_to_s = j.to_s
		 fprnt"class #{self} : LINE #{__LINE__} j_to_s: #{j_to_s} xtblname: #{xtblname}"
	        ###debugger
                if j_to_s.split(/_/,2)[0] == xtblname then  ##本体の更新
                   to_command_r[j_to_s.split(/_/,2)[1].to_sym] = k  unless k.nil?  ###org tbl field name
                   else  ### link先のidを求める
	           if   j_to_s =~ /(_upd|sio_|id_tbl)/ or k.nil? or j_to_s == "id"  or j_to_s =~ /^sio_/ then
                        else
                        tmp_key[j] = k  if j_to_s =~ /(_code)/  ##tmp_key[j] = other tablename+_+fielfname+_+shikibetushi  <-- value
                   end  ## unless j_to_s
                end   ## if j_to_s.
           end ## i
           to_command_r.merge! sub_code_to_id(tmp_key)
	   fprnt"class #{self} : LINE #{__LINE__} sio_view_name: #{sio_view_name} strsql: #{strsql} ****person_id #{i[:person_id_upd]}"
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
                    plsql.__send__(tblname).update  to_command_r
                when "plsql_blk_delete" then 
                    plsql.__send__(tblname).delete(:id => i[:id_tbl])
		when "plsql_blk_copy_insert" then
                    to_command_r[:id] = plsql.__send__(tblname + "_seq").nextval
		    plsql.__send__(tblname).insert to_command_r
		    add_tbl_ctlxxxxxx i[:sio_org_tblname],i[:sio_org_tblid],tblname,to_command_r[:id] 
           end   ## case iud 
	   r_cnt += 1
	   tmp_sio_record_r = {}
	   tmp_sio_record_r = i
	   tmp_sio_record_r[:sio_recordcount] = r_cnt
           tmp_sio_record_r[:sio_result_f] = "0"
           tmp_sio_record_r[:sio_message_contents] = nil
	   insert_sio_r  tmp_sio_record_r
	   cmnd_code = "process_scrs_" + sio_view_name.split(/_/,2)[1]   ##画面ごとの処理
           __send__(cmnd_code, tmp_sio_record_r)   if self.respond_to?(cmnd_code)
      end   ##chk_cmn.each
      plsql.commit
  end   ## perform
  handle_asynchronously :perform
  def   sub_code_to_id  tmp_key
	   fprnt "class #{self} : LINE #{__LINE__} tmp_key #{tmp_key}"
           strwhere = "where Expiredate >= SYSDATE  and "
	   sub_command_r  = {}
           tmp_key.sort.each do|key, value|
                 strwhere = "where Expiredate >= SYSDATE  and code = '#{value}'    "
		 sub_command_r.merge! sub_get_main_data(strwhere,key.to_s) 
           end	
           sub_command_r
  end
  ### code + exipredateでユニークであること
  def   sub_get_main_data strwhere,key
        others_tbl_id_isrt = {}
        strwhere = strwhere + " order by  Expiredate"
        tblname = key.split(/_/,2)[0] + "s"
        fprnt"class #{self} : LINE #{__LINE__} :  tblname : #{tblname}   strwhere = '#{strwhere}' :: key #{key}"
        aim_id = plsql.__send__(tblname).first(strwhere)
        ## fprnt" aim_id =  '#{aim_id}',"
        add_char = key.split(/_code/,2)[1] ||= ""
        others_tbl_id_isrt[(tblname + "_id" + add_char).to_sym] = aim_id[:id] unless aim_id.nil?
        others_tbl_id_isrt[:sio_message_contents] = "logic err" if aim_id.nil?
        return  others_tbl_id_isrt
  end   ### def sub_get...
##  def str_to_hash
##       tmp_array = command_r[:sio_strsql].split(",")
##       ## fprnt"command_r[:sio_strsql] #{command_r[:sio_strsql]}"
##       ## fprnt"tmp_array #{tmp_array}"
##       return Hash[*tmp_array]
##  end 
end ## class 


