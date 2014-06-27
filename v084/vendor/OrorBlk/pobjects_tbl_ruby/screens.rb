def sub_tbl_screens  sioarray,command_c
    if command_c[:sio_classname] =~ /insert/   then
       pob_code = plsql.pobjects.first("where objecttype = 'view' and code = '#{command_c[:pobject_code_scr]}' and expiredate > sysdate")
       if     pob_code.nil?   ###excelからの入力の時使用　画面からのときはチェックされている。
              req_command_c = {}
              req_command_c = command_c.dup
              req_command_c[:pobject_id] = req_command_c[:id] = plsql.pobjects_seq.nextval
              req_command_c[:pobject_objecttype] = "view" 
              req_command_c[:pobject_code] = command_c[:pobject_code_scr] 
              req_command_c[:pobject_expiredate] = command_c[:screen_expiredate] 
              req_command_c[:sio_code] = "r_pobjects"
              req_command_c[:sio_viewname] = "r_pobjects"
              req_command_c[:sio_ctltbl] = nil
              sio_copy_insert req_command_c
              sioarray.unshift "sio_r_pobjects" 
             command_c[:screen_pobject_id_view] = req_command_c[:id]
             command_c[:where] ={:sio_id=>command_c[:sio_id]}
             plsql.sio_r_screens.update command_c
       end
       pob_code = plsql.pobjects.first("where objecttype = 'screen' and code = '#{command_c[:pobject_code_scr]}' and expiredate > sysdate")
       if     pob_code.nil?
              req_command_c = {}
              req_command_c = command_c.dup
              req_command_c[:pobject_id] = req_command_c[:id] = plsql.pobjects_seq.nextval
              req_command_c[:pobject_objecttype] = "screen" 
              req_command_c[:pobject_code] = command_c[:pobject_code_scr]
              req_command_c[:pobject_expiredate] = command_c[:screen_expiredate] 
              req_command_c[:sio_code] = "r_pobjects"
              req_command_c[:sio_viewname] = "r_pobjects"
              req_command_c[:sio_ctltbl] = nil
              sio_copy_insert req_command_c
              sioarray.unshift "sio_r_pobjects"   unless sioarray.index("sio_r_pobjects")
             command_c[:screen_pobject_id_scr] = req_command_c[:id]
             command_c[:where] ={:sio_id=>command_c[:sio_id]}
             plsql.sio_r_screens.update command_c
       end
    end  ## if command_c[:sio_classname] =~ /insert/ 
   return sioarray,command_c
end
