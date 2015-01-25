# -*- coding: utf-8 -*-  
#### v084
## 同一login　userではviewとscreenは一対一
### show_data   画面の対するviewとその項目をユーザー毎にセット
### insert  ==> add,update ==> edit に統一
class  AddupddelController < ScreenController
	before_filter :authenticate_user!  
	respond_to :html ,:xml ##  将来　タイトルに変更
	def index    ##  add update delete  
		@pare_class = "online"
		command_c = init_from_screen params
		command_c[:sio_session_id] =   1	  
	    command_c[(command_c[:sio_viewname].split("_")[1].chop+"_person_id_upd").to_sym] = command_c[:sio_user_code]
	    command_c[(command_c[:sio_viewname].split("_")[1].chop+"_update_ip").to_sym] = request.remote_ip
		@errmsg = ""
      case  params[:copy]  
          when /add/
             updatechk_add command_c
			 updatechk_foreignkey command_c if  @errmsg == ""
             if  @errmsg == "" then
                 command_c[:sio_classname] = "plsql_blk_add_"
				 ##debugger if command_c[:sio_viewname].split("_")[1] == "custords"
                 command_c[:id] = plsql.__send__(command_c[:sio_viewname].split("_")[1] + "_seq").nextval 
                 command_c[(command_c[:sio_viewname].split("_")[1].chop + "_id").to_sym] =  command_c[:id]
             end 
          when /delete/
	         command_c[:sio_classname] = "plsql_blk_delete_"
			 updatechk_del command_c
          when /edit/
             command_c[:sio_classname] = "plsql_blk_edit_"
			 updatechk_edit command_c
			 updatechk_foreignkey command_c  if  @errmsg == ""
          else     
           ## textは表示できないのでメッセージの変更要
          render :text => "return to menu because session loss params:#{params[:oper]} "
      end ## case parems[:oper]
      if  @errmsg == "" 
	      @req_userproc = false
		  @sio_classname = command_c[:sio_classname]
          plsql.connection.autocommit = false
          command_c[:sio_session_counter] =   @new_sio_session_counter  = user_seq_nextval
		  command_c[:sio_recordcount] = 1
		  Rails.cache.clear(nil) if command_c[:sio_viewname] =~ /screen/  ###db_cudではクリされた結果がscreenのクラスでは反映されない模様
          sub_insert_sio_c    command_c 
          sub_userproc_chk_set command_c
          plsql.commit
          dbcud = DbCud.new
          dbcud.perform(command_c[:sio_session_counter],@sio_user_code.to_i,"")
		  ###  line画面の時
          sym_code = (command_c[:sio_viewname].split("_")[1].chop+"_code").to_sym
		  sym_sno = (command_c[:sio_viewname].split("_")[1].chop+"_sno").to_sym
		  if command_c[sym_code]||command_c[sym_sno]
		     scode =  if  command_c[sym_code] then   command_c[sym_code] else command_c[sym_sno]  end
			else
			  command_c.each do |key,value|
			      scode = value if key.to_s == /_code_#{command_c[:sio_viewname].split("_")[1].chop}/
			  end
		  end   ###serverへの送信を画面に表示
		  if  params[:copy] == "add" then jstxt = %Q%jQuery("form input").val("");jQuery("form textarea").val("");% else jstxt = "" end 
              jstxt << %Q%jQuery("p#blkmsg'").remove();jQuery("td.navButton").append("<p id='blkmsg'>sent code:#{scode} to server</p>");%
		      render :js=>jstxt
       else
		  render :js=>%Q%jQuery("p#blkmsg'").remove();jQuery("td.navButton").append("<p id='blkmsg'><font color='#ff0000'>#{@errmsg} </font></p>");%
       end
   end  ## add_upd_del
end
