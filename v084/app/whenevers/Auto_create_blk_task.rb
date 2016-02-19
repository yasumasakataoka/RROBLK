##require 'ror_blk/ror_blkctl'
##ActionController::Base.send :include,Ror_blkctl
class AutoCreateBlkTask < DbCud
	def self.proc_autoinst_create_task
	   logger.debug " proc_autoinst_create #{Time.now} "
		dbruby = DbCud.new
		###dbruby.perform_crt_def_all  ### perform_crt_def_all では動かない。
		dbruby.auto_create_ords_insts		
	end
end