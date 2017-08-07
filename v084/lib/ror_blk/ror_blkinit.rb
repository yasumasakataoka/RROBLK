# -*- coding: utf-8 -*-  
# RorBlkinit
# 2099/12/31を修正する時は　2100/01/01の修正も
###		Blksdate = Date.today - 1  ##在庫基準日　sch,ord,instのこれ以前の納期は許さない。
###		Confirmdate = Date.today + 7  ##在庫基準日　sch,ord,instのこれ以降の納期は許さない。
module Ror_blkinit  
	def proc_blkgetpobj_init code,ptype
		##sub_blkgetpobj code,ptype
	##end
    ##def sub_blkgetpobj code,ptype    ###
        fstrsqly = ""
        ##grp_code =  sub_blkget_grpcode 
		if grp_code == "batch"
            oragname = code
		end
		if code =~ /_id/ or   code == "id" 
			oragname = code
		else
			orgname = ""      
			basesql = "select pobjgrp_name from R_POBJGRPS where POBJGRP_EXPIREDATE > current_date AND USRGRP_CODE = '#{grp_code}' and   "
			fstrsql = basesql +  " POBJECT_CODE = '#{code}' and POBJECT_OBJECTTYPE = '#{ptype}' "
			###  フル項目で指定しているとき
			orgname = ActiveRecord::Base.connection.select_value(fstrsql) 
			orgname ||= code
			if orgname == code and ptype == "view_field" then  ###view項目の時はテーブル項目まで
				orgname = ""
				code.split('_').each_with_index do |value,index|
					fstrsqly =  basesql +  "   POBJECT_CODE = '#{if index == 0 then value + "s" else value end}'  and POBJECT_OBJECTTYPE = '#{if index == 0 then  'tbl' else 'tbl_field' end}' "
					if ActiveRecord::Base.connection.select_value(fstrsql)   ## tbl name get
						orgname <<  ActiveRecord::Base.connection.select_value(fstrsql)  + "_"
					else
						orgname << value + "_"
					end   
				end   ## do code. 
				orgname.chop!
			end ## if orgname
		end  ## 
        return orgname 
    end  ## def getpobj
    def sub_blkget_code_fm_name_init name,ptype    ###
         ##grp_code =  sub_blkget_grpcode 
         if name =~ /_id/ or   name == "id" then
            orgcode = name
           else
            orgcode = ""      
            basesql = "select POBJECT_CODE  from R_POBJGRPS where POBJGRP_EXPIREDATE > current_date AND USERGROUP_CODE = '#{grp_code}' and   "
            basesql  <<  " pobjgrp_name = '#{name}' and POBJECT_OBJECTTYPE = '#{ptype}' "
            pobject_code = ActiveRecord::Base.connection.select_value(basesql)
            orgcode =  if pobject_code then pobject_code else name end			
         end  ## if ocde
      return orgcode ||= name
    end  ## def getpobj
    def crt_def_all_init
        eval("def dummy_def \n end")
		begin
			def_rubycoding
			proc_create_tblinkfld_def
			def_tblink
		rescue	
				p " error class #{self} #{Time.now}:  $@: #{$@} " 
				p "  error class #{self} :  $!: #{$!} "
		end
	end
	def def_rubycoding
		ActiveRecord::Base.connection.select_all("select * from rubycodings where expiredate > current_date").each do |src_tbl|
			vproc_crt_def_rubycode src_tbl
		end
	end
	def def_tblink
		ActiveRecord::Base.connection.select_all("select * from tblinks where expiredate > current_date order by codel ").each do |src_tbl|
			vproc_crt_def_rubycode src_tbl
		end
	end
    def vproc_crt_def_rubycode src_tbl
		strdef = "def #{src_tbl["codel"]}  #{src_tbl["hikisu"]} \n" 
		strdef << src_tbl["rubycode"]
	    strdef <<"\n end"
		###	p strdef[0..50]
	    Ror_blkctl.module_eval(strdef)
    end
    def proc_create_tblinkfld_def 	
		strsql = "select * from r_tblinkflds where tblinkfld_expiredate > current_date and tblink_expiredate > current_date 
		 order by tblink_codel,tblink_beforeafter,tblink_seqno,tblinkfld_seqno "
	    recs = ActiveRecord::Base.connection.select_all(strsql)
		streval = nil
		tblchop = ""
		src_screen = ""
		beforeafter = ""
		seqno = ""
	    recs.each do |rec|
			if src_screen != rec["pobject_code_scr_src"] or 	tblchop != rec["pobject_code_tbl_dest"].chop or
					beforeafter != rec["tblink_beforeafter"] or seqno != rec["tblink_seqno"]
					if streval
						streval << str_sio_set(tblchop)
						###	p streval[0..50]
						Ror_blkctl.module_eval(streval)
					end
					src_screen = rec["pobject_code_scr_src"]
					tblchop = rec["pobject_code_tbl_dest"].chop
					beforeafter = rec["tblink_beforeafter"]
					seqno = rec["tblink_seqno"]
					streval = "def proc_fld_#{src_screen}_#{tblchop}s_#{beforeafter+seqno.to_s}\n"
					streval << str_init_command_c("r_#{rec["pobject_code_tbl_dest"]}")
			end
			if  rec["pobject_code_fld"] =~ /s_id/   ###tblchop==delm ###ヘッダーと同じものは除く crttblviewscreen
				fld = tblchop + "_" + rec["pobject_code_fld"].sub("s_id","_id")
			else
				fld = tblchop+"_"+rec["pobject_code_fld"]
			end
			if rec["tblinkfld_rubycode"] and rec["tblinkfld_rubycode"] != "undefined"
					streval << %Q&\n	command_c[:#{fld}] = #{rec["tblinkfld_rubycode"]} 	&
			else
				str = vproc_tblinkfld_dflt_set_fm_rubycoding(fld)
				if str
					streval << %Q&\n command_c[:#{fld}] = #{str} 	&
				end
			end
			if  rec["pobject_code_fld"] =~ /s_id/
				streval << %Q&\n 	command_c[:#{fld}] = "missing id #{fld}"  if command_c[:#{fld}].nil?  &  	###_id項目は必須
			end
	    end ##
		if recs.size > 0
		    streval << %Q&\n command_c[(command_c[:sio_viewname].split("_")[1].chop+"_id").to_sym] = command_c[:id] &
			streval << str_sio_set(tblchop)
			##	p streval[0..50]
			Ror_blkctl.module_eval(streval)
		end
    end
	def vproc_tblinkfld_dflt_set_fm_rubycoding fld
		dflt_rubycode = nil
		strsql = %Q& select * from r_rubycodings where pobject_objecttype = 'view_field' 	and  pobject_code = '#{fld}'
							and rubycoding_codel like '%dflt_for_tbl_set' &
		rubycode_view = ActiveRecord::Base.connection.select_one(strsql)
		if rubycode_view
			dflt_rubycode = rubycode_view["rubycoding_codel"] + " " +(rubycode_view["rubycoding_hikisu"]||="" )
		else
			fld_tbl = fld.split("_",2)[1] 
			strsql = %Q& select * from r_rubycodings where pobject_objecttype = 'tbl_field' 	and  pobject_code = '#{fld_tbl}'
					and rubycoding_codel like '%dflt_for_tbl_set' &
			rubycode_tbl = ActiveRecord::Base.connection.select_one(strsql)
			if rubycode_tbl
				dflt_rubycode = rubycode_tbl["rubycoding_codel"] + " " + (rubycode_tbl["rubycoding_hikisu"]||="")
			end
		end
		return dflt_rubycode
	end
	def str_init_command_c tbl_dest
	    %Q%
		command_c = {}.with_indifferent_access 
		command_c[:sio_session_counter] =   @new_sio_session_counter 
		command_c[:sio_recordcount] = 1
		command_c[:sio_user_code] =   @sio_user_code
		command_c[:sio_code] = command_c[:sio_viewname] = @sio_code = "#{tbl_dest}"
		command_c.merge!(yield) if block_given?
		###  command_c[:sio_classname] = @sio_classname
		%
	end
	def str_sio_set tblchop
		%Q%
		command_c[:sio_classname] = (@#{tblchop}_classname ||= @sio_classname)
		proc_simple_sio_insert command_c
	    end
		%
	end
end   ##module Ror_blk