# RorBlk
 module Ror_blk

   def getblkpobj code,ptype     ## fieldsの名前
       tmp_person =  plsql.r_persons.first(:person_email =>current_user[:email])
       ##  p " current_user[:email] #{current_user[:email]}"
       if tmp_person.nil?
          render :text => "add persons to your email "  and return 
            else
          user_code = tmp_person[:person_code]
       end 
      if code =~ /_ID/ or   code == "ID" then
         oragname = code
        else
         orgname = ""      
         basesql = "select pobjgrp_name from R_POBJGRPS where USERGROUP_CODE = '#{user_code}' and   "
         fstrsql  =  basesql  +  " POBJECT_CODE = '#{code}' and POBJECT_OBJECTTYPE = '#{ptype}' "
         ###  フル項目で指定しているとき
         orgname = plsql.select(:first,fstrsql)[:pobjgrp_name]  unless plsql.select(:first,fstrsql).nil?
         ## p "orgname #{orgname}"
         ## p "code #{code}"
         if orgname.empty? or orgname.nil? then
            orgname = ""
            code.split('_').each do |i|
              fstrsqly =  basesql +  "   POBJECT_CODE = '#{i}' "
              # p pstrsqly
              unless plsql.select(:first,fstrsqly).nil? then   ## tbl name get
                  orgname << plsql.select(:first,fstrsqly)[:pobjgrp_name]
               end   
            end   ## do code. 
         end ## iforgname
            orgname = code if orgname == "" or orgname.nil?
      end  ## if ocde
      return orgname 
  end  ## def getpobj
  def fprnt str
    foo = File.open("blk#{Process::UID.eid.to_s}.log", "a") # 書き込みモード
    foo.puts str
    foo.close
  end   ##fprnt str
##definde_method process_scrs_code do  |tmp_sio_record_r|
##  record_auto tmp_sio_record_r,to_screenl,field
###end
#:to_table=>"aaa"
#:field=>{:aaaa=> fa + fb,:bbbb=>xxxx(zzzz)}	
# fa,zzzzはtmp_sio_record_rのレコード名
### 必須　文法チェックは画面でする。
def create_def
save_code = ""
rs = plsql.screens.select(:all,"where EXPIREDATE> sysdate and substr(viewname,1,2) = 'R_' order by code,EXPIREDATE")
    rs .each do |r|
	if save_code != r[:code]  and  r[:ymlcode]  then
	    r[:ymlcode].gsub("\n","").split(/:to_/).each do |yml|
		case 
                when yml =~ /^screen/
		     cmdstr = " def process_scrs_#{r[:code]} tmp_sio_record_r " +  "\n" + "record_auto tmp_sio_record_r,"
	             yml_f = yml.split(/:field/,2)[1]
		     cmdstr << yml_f[1].split(/=>/,2)[1]
		when yml  =~ /^subcmd/
		     cmdstr << "\n" + yml.split(/=>/,2)[1] 
		end	
	    end
	    if  cmdstr then 
	        cmdstr << "\n end"
	        eval(cmnstr)
	    end
            cmdstr = nil
     	    save_code = r[:code] h
         end  ## if
    end  ##rs
end
def record_auto tmp_sio_record_r,to_screen,fields = {}
    orgtbl = tmp_sio_record_r[:sio_viewname].split(/_/,2)[1].chop
    to_command_r = {} 
    screen_code = to_screen.upcase 
    get_show_data 
    tmp_sio_record_r.each do |k,val| 
	key = k.to_s
	j = key.sub(orgtbl,to_screen.downcase).to_sym
	if key =~ /^sio_/  
		to_command_r[j] = val 
        end
	if  show_data[:allfield].key?(j) 
		to_command_r[j] = val if fields[j].nil?
		to_command_r[j] = tmp_sio_record_r[fields[j]] if fields[j]
        end

    end
    if to_command_r[:sio_classname] =~ /insert/ then
	to_command_r[:sio_org_tblid]  = to_command_r[:id_tbl] 
        to_command_r[:sio_org_tblname]  =  orgtbl
        to_command_r[:sio_classname] = "plsql_blk_copy_insert"
    end	
    to_command_r[:sio_viewname] =  plsql.screens.select(:first,"where EXPIREDATE> sysdate and code = '#{screen_code}' order by EXPIREDATE")[:viewname]
    to_command_r[:id] =  plsql.__send__("SIO_#{command_r[:sio_viewname]}_SEQ").nextval
    to_command_r[:sio_session_counter] = plsql.sessioncounters_seq.nextval  ### user_id に変更
    to_command_r[:sio_add_time] = Time.now
    to_command_r.delete(:msg_ok_ng)  ## sioに照会・更新依頼時は更新結果は不要
    fprnt " class #{self} : LINE #{__LINE__} sio_\#{ command_r[:sio_viewname] } :sio_#{command_r[:sio_viewname]}"
    fprnt " class #{self} : LINE #{__LINE__} to_command_r #{to_command_r}"
      ## debugger
    plsql.__send__("SIO_#{command_r[:sio_viewname]}").insert to_command_r
    plsql.commit 
    dbcud = DbCud.new
    dbcud.perform(to_command_r[:sio_session_counter],"SIO_#{to_command_r[:sio_viewname]}")
  end   ## subcopyinsertsio
  def insert_sio_r tmp_sio_record_r
      tmp_sio_record_r[:sio_replay_time] = Time.now
      tmp_sio_record_r[:sio_command_response] = "R"
      tmp_seq = "SIO_#{tmp_sio_record_r[:sio_viewname]}_seq"
      tmp_sio_record_r.each_key do |j_key|  
             tmp_sio_record_r.delete(j_key) if tmp_sio_record_r[j_key].nil?
      end
      fprnt " LINE :#{__LINE__} tmp_sio_record_r[:sio_viewname] =  #{tmp_sio_record_r[:sio_viewname]}  command_r #tmp_{command_r}  "
      tmp_sio_record_r[:id] = plsql.__send__(tmp_seq).nextval
      plsql.__send__("SIO_#{tmp_sio_record_r[:sio_viewname]}").insert tmp_sio_record_r
  end   ##insert_sio_r  

 end   ##module Ror_blk

 
