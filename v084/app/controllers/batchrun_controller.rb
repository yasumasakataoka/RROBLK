class BatchrunController < ScreenController
  before_filter :authenticate_user!  
	respond_to :html ,:xml #
    def index
		command_c = init_from_screen
		command_c[:sio_session_id] =   1
		case @screen_code
			when "purord_replyinputs"
				command_c[:purrply_result_f] = "0"
				command_c[:purrply_runtime] = -1
				command_c[:purrply_person_id_upd] = command_c[:sio_user_code]
				command_c[:purrply_update_ip] = request.remote_ip
				command_c[:purrply_tblname] = "replyinputs"
				command_c[:sio_viewname] = "r_purrplys"
                command_c[:sio_session_counter] =   user_seq_nextval   ##
                command_c[:sio_classname] = "_add_by_batchrun"
                command_c[:id] = command_c[:purrply_id] = proc_get_nextval("purrplys_seq") 
                command_c[:sio_user_code] = ActiveRecord::Base.connection.select_one("select * from persons where email = '#{current_user[:email]}'")["id"]
                proc_insert_sio_c command_c				
		end
		render :action=>"index" and return
    end
end