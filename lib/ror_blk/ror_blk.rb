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
  def  command_r
       @command_r ||= Hash.new
  end  ## command_r
  def  sub_getfield
       strfields = []
       command_r.each  do |i,j|
          tmp_field = i.to_s 
          unless  tmp_field =~ /^sio_/  then
             unless  tmp_field == "id_tbl" then
               strfields <<  tmp_field
             end 
          end  ## unless  unless i.to_s =~ /^sio_/ 
       end   ## command_r.each
       strfields =  strfields.join(",") 
       return strfields
  end   ##  sub_getfield

 def insert_command_r tmp_command_r
      tmp_command_r[:sio_replay_time] = Time.now
      tmp_command_r[:sio_command_response] = "R"
      tmp_seq = "SIO_#{tmp_command_r[:sio_viewname]}_seq"
      tmp_command_r.each_key do |j_key|  ##cbol 対策
             tmp_command_r.delete(j_key) if tmp_command_r[j_key].nil?
      end
      
      fprnt " LINE :#{__LINE__} tmp_command_r[:sio_viewname] =  #{tmp_command_r[:sio_viewname]}  command_r #tmp_{command_r}  "
      tmp_command_r[:id] = plsql.__send__(tmp_seq).nextval
      plsql.__send__("SIO_#{tmp_command_r[:sio_viewname]}").insert tmp_command_r
 end

 end
 
