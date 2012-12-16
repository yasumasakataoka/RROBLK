# RorBlk
  require "rubygems"
  require "ruby-plsql"
  plsql.connection = OCI8.new("rails","tq6t7rjx","xe")
   def getfobj user_code,code
      if code =~ /_ID/ or   code == "ID" then
         oragname = code
        else
         orgname = ""
         pstrsqlx = "select pobjgrp_name from R_POBJGRPS where USERGROUP_USER_CODE = '#{user_code}' and  POBJECT_OBJECTTYPE = 'TABLE' "
         pstrsql =   pstrsqlx + "  and  POBJECT_CODE = '#{code}'  "
      
         fstrsqlx = "select Fobjgrp_name from R_FOBJGRPS where USERGROUP_USER_CODE = '#{user_code}' and"
         fstrsql =  fstrsqlx + "  FOBJECT_CODE = '#{code}' "
         ###  フル項目で指定しているとき
         orgname = plsql.select(:first,fstrsql)[:fobjgrp_name]  if !plsql.select(:first,fstrsql).nil?
         ## p "orgname #{orgname}"
         ## p "code #{code}"
         if orgname.empty? or orgname.nil? then
            orgname = ""
            code.split('_').each do |i|
              tmp = i + "S"
              pstrsqly =  pstrsqlx +  "  and POBJECT_CODE = '#{tmp}' "
              # p pstrsqly
              if plsql.select(:first,pstrsqly).nil? then 
                 fstrsqly =  fstrsqlx +  "  FOBJECT_CODE = '#{i}' "
                 if !plsql.plsql.select(:first,fstrsqly).nil?                                  
                     orgname << plsql.plsql.select(:first,fstrsqly)[:fobjgrp_name]  
                 end  ## if !plsql
                else
                  orgname << plsql.select(:first,pstrsqly)[:pobjgrp_name]
               end   
            end   ## do code. 
         end ## iforgname
            orgname = code if orgname == "" or orgname.nil?
      end  ## if ocde
      return orgname 
  end  ## def getfobj

    @screenname_id = 'R_SCREENS'
    tmp_pre_screen = plsql.r_PreFields.all("where screen_name = :1
                                              and prefield_selection = :2",@screenname_id,1)
    person_id = "1"   
    @pre_screen = []                                  
    tmp_pre_screen.each do |i|
      pre_field = {}
      pre_field[:prefield_code] = i[:prefield_code]
      pre_field[:prefield_name] = getfobj(person_id,i[:prefield_code])
      pre_field[:prefield_type] = i[:prefield_type]
      pre_field[:prefield_length] = i[:prefield_length]
      pre_field[:prefield_datascale] = i[:prefield_datascale]
      @pre_screen << pre_field
      p " #{i[:prefield_code]}  : #{pre_field[:prefield_name]} "
    end
 