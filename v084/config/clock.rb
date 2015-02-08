require 'clockwork'
require File.expand_path('../boot', __FILE__)
require File.expand_path('../environment', __FILE__)
require File.expand_path('../initializers/myplugin',__FILE__)
require File.expand_path('../../app/worker/db_cud',  __FILE__)
include Clockwork
include Ror_blkctl
module Clockwork
	handler do |job|	
		blk_development
		__send__(job) if job =~ /^blk_#{Rails.env}/
	end
			
	every(1.hour, 'blk_production_01')
	every(1.second, 'blk_test') 
	every(1.second, 'blk_development') 
	
		
	def blk_production_01
		proc_clockwork
	end
	def blk_production_02
		proc_clockwork
	end
	def blk_test
		proc_clockwork
	end
	def blk_development
		proc_clockwork
	end	
	def sql_mk_clock screen_code
		tblnamechop = screen_code.split("_",2)[1].chop + "_"
		%Q& select * from #{screen_code} a where #{tblnamechop}result_f = 's'
				and #{tblnamechop}expiredate > current_date
				and (#{tblnamechop}runtime - substr(to_char(current_date,'yyyy/mm/dd hh24'),12,2)) = 0
				and not exists (select 1 from #{screen_code} b
										where b.#{tblnamechop}result_f = '0'
										and a.#{tblnamechop}RUNTIME = b.#{tblnamechop}RUNTIME
										and a.#{tblnamechop}CHRGPERSON_ID_TRN = b.#{tblnamechop}CHRGPERSON_ID_TRN 
										and a.#{tblnamechop}CHRGPERSON_id_org = b.#{tblnamechop}CHRGPERSON_ID_org
										and a.#{tblnamechop}prdpurshp = b.#{tblnamechop}PRDPURSHP)
		&
	end
	def proc_clockwork		
		["r_mkords","r_mkinsts"].each do |i|   ###i screen_cod & viewname
			mks = ActiveRecord::Base.connection.select_all(sql_mk_clock(i))
			tblnamechop = i.split("_",2)[1].chop
			mks.each do |mk|				
                    @screen_code = i
					command_c = {}
					mk.each do |key,val|  ###plsqlからactiverecordに変更したら不要
						command_c[key.to_sym] = val
					end
                    command_c[:sio_session_counter] =   user_seq_nextval    ##
                    command_c[:sio_classname] = "plsql_auto_add_by_clockwork"
                    command_c[:sio_viewname] = i
                    command_c[:id] = command_c[(tblnamechop + "_id").to_sym] = proc_get_nextval(tblnamechop+"s_seq")
                    command_c[:sio_user_code] = ActiveRecord::Base.connection.select_one("select * from persons where code = '0'")["id"]
					command_c["#{tblnamechop}_result_f".to_sym]= '0'
					proc_simple_sio_insert command_c
			end
		end
	end
end
