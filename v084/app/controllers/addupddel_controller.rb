# -*- coding: utf-8 -*-  
#### v084
## 同一login　userではviewとscreenは一対一
### show_data   画面の対するviewとその項目をユーザー毎にセット
class  AddupddelController < ScreenController
   before_filter :authenticate_user!  
   respond_to :html ,:xml ##  将来　タイトルに変更
   def index    ##  add update delete  
      params[:oper] = "add" if  params[:copy] == "copyandadd"   ### copy and add
      params[:oper] = "add" if  params[:copy] == "inlineadd"
      screen_code,jqgrid_id = get_screen_code
      ##debugger
      show_data = get_show_data(screen_code)
      command_c  = set_fields_from_allfields(show_data)
      command_c[:sio_viewname]  = show_data[:screen_code_view] 
      command_c[:sio_user_code] = plsql.persons.first(:email =>current_user[:email])[:id]  ||= 0   ###########   LOGIN USER  
      command_c[:sio_code] = screen_code
      command_c[:sio_session_counter] =   user_seq_nextval(command_c[:sio_user_code]) if command_c[:sio_session_counter].nil?   ##
      rcdkey = "RCD_ID" + current_user[:id].to_s +  params[:q] +  params[:ss_id]  ### :q -->@jqgrid_id
      ##hash_rcd = Rails.cache.read(rcdkey) ||{} 
      hash_rcd = plsql.__send__("parescreen#{current_user[:id].to_s}s").first("where rcdkey = '#{rcdkey}' and expiredate > sysdate")
      @errmsg = ""
      case params[:oper] 
          when "add"
           ###command_c[hash_rcd[:rcd_id_key]] =  hash_rcd[:rcd_id_val] unless hash_rcd.nil?
             updatechk_add command_c
             if  @errmsg == "" then

                 command_c[:sio_classname] = "plsql_blk_insert"
                 if  hash_rcd   then ##ctltblによる親子関係
                     if  hash_rcd[:ctltbl] 
                         command_c[:sio_ctltbl] =  hash_rcd[:ctltbl] 
                       else 
                         command_c[:id] = plsql.__send__(command_c[:sio_viewname].split("_")[1] + "_seq").nextval 
                         command_c[(command_c[:sio_viewname].split("_")[1].chop + "_id").to_sym] =  command_c[:id]
                     end
                   else
                     command_c[:id] = plsql.__send__(command_c[:sio_viewname].split("_")[1] + "_seq").nextval 
                     command_c[(command_c[:sio_viewname].split("_")[1].chop + "_id").to_sym] =  command_c[:id]
                 end
             end 
          when "del"
	     command_c[:sio_classname] = "plsql_blk_delete"
             command_c[:sio_ctltbl] =  hash_rcd[:ctltbl] if hash_rcd 
          when "edit"
             command_c[:sio_classname] = "plsql_blk_update"
          else     
          ##debugger ## textは表示できないのでメッセージの変更要
          render :text => "return to menu because session loss params:#{params[:oper]} "
      end ## case parems[:oper]
      ##debugger
      if  @errmsg == "" then 
          sub_insert_sio_c    command_c 
          sub_userproc_insert command_c
          plsql.commit
          dbcud = DbCud.new
          dbcud.perform(command_c[:sio_session_counter],command_c[:sio_user_code])
          render :nothing=>true
       else
          p "err #{@errmsg} "
          render :text=>@errmsg
      end
   end  ## add_upd_del
   def updatechk_add command_c
      ## addのとき
      ## ukeyの重複はエラー
      constr = plsql.blk_constraints.all("where table_name = '#{command_c[:sio_viewname].split("_")[1].upcase}'  and  constraint_type = 'U' ")
      orakeyarray = {}
      constr.each do |rec|
         if  orakeyarray[rec[:constraint_name].to_sym] then
             orakeyarray[rec[:constraint_name].to_sym]  << rec[:column_name]
            else
              orakeyarray[rec[:constraint_name].to_sym]  =[]
              orakeyarray[rec[:constraint_name].to_sym]  << rec[:column_name]
          end
      end
      orakeyarray.each do |inx,val|
         strwhere = " where "
         val.each do |key|
            strwhere << " #{key} = '#{wherefieldset(key.downcase,command_c)}'   and " 
         end
         rec = plsql.__send__(command_c[:sio_viewname].split("_")[1]).first(strwhere[0..-5])
         ##debugger
         @errmsg << "err:duplicate #{strwhere[6..-5]} " if rec
      end
   end
   def updatechk_edit
      ## updateのとき
      ## 外部keyとして参照されているとき　codeの変更は不可
   end
   def updatechk_del
      ## delのとき
      ##すでに外部keyとして参照されているときは削除不可
   end
   def wherefieldset(key,command_c)
       new_key = if key =~ /_id/ then command_c[:sio_viewname].split("_")[1].chop + "_"  + key.sub("s_id","_id") else
                                      command_c[:sio_viewname].split("_")[1].chop+ "_"  + key end
      ##debugger
      return command_c[new_key.to_sym]                      
   end
end
