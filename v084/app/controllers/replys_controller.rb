# -*- coding: utf-8 -*-  
class  ReplysController < ScreenController
	before_filter :authenticate_user!  
	respond_to :html ,:xml ## 
	def index    ##  		
		@pare_class = "online"
		command_c = init_from_screen params
		command_c[:sio_session_id] =   1
		dbreply = DbReplys.new
		dbreply.perform_setreplys(command_c[:sio_viewname],command_c[:sio_user_code])
	end
end