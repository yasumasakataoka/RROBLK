module Roblk
  protected
  def getfobj user_cod,code
      if code =~ '_ID' or   code == 'ID' then
          code
        else
         orgname = ""
         fstrsql = " where FOBJECT_CODE = :1 and USERGROUP_USER_CODE = :2 "
         pstrsql = " where POBJECT_CODE = :1 and USERGROUP_USER_CODE = :2 and  POBJECT_OBJECTTYPE = 'TABLE' "
         orgname = plsql.R_FOBJGRPS.first(fstrsql,user_cod,code)[:fobjgrp_name]  
         if orgname.empty? then
            code.split('_').each do |i|
              orgname = plsql.R_POBJGRPS.first(pstrsql,user_cod,i)[:pobjgrp_name] if orgname == ""
              orgname << plsql.R_FOBJGRPS.first(fstrsql,user_cod,i)[:fobjgrp_name] if orgname != ""
            end
            orgname = code if orgname == ""
         end
      end
      return orgname 
   end
  def getpobj objecttype,user_cod,code
      pstrsql = " where POBJECT_CODE = :1 and USERGROUP_USER_CODE = :2 and  POBJECT_OBJECTTYPE = :3 "
      orgname = plsql.R_POBJGRPS.first(pstrsql,user_cod,i)[:pobjgrp_name] 
      orgname = code if orgname == ""
      return orgname 
  end
end