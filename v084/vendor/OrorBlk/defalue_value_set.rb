
### default value
define_method(name) do |field_name|
end

### check calulate
define_method(name) do |field_name|
end

person_screenlevel_id_chrg_dflt
allfs = plsql.r_screenfields.all("where screenfield_expiredate > sysdate") 
sfdrubycode = nil
strsql = ""
allfs.each do |fld|
  sfdrubycode = nil
  tblname = fld[:pobject_code_scr].split("_")[1].chop
  if tblname == fld[:pobject_code_sfd].split("_")[0] 
     sfdrubydefname = fld[:pobject_code_sfd]
	 if  fld[:screenfield_rubycode] 
     	 sfdrubycode = fld[:screenfield_rubycode]
       else
	     strsql = %Q/where pobject_code_tbl = '#{fld[:pobject_code_scr].split("_")[1]}'  and pobject_code_fld = '#{fld[:pobject_code_sfd].split("_",2)[1]}' 	 and blktbsfieldcode_expiredate > sysdate/
	     tmp = plsql.r_blktbsfieldcodes.first(strsql)
		 ##
		 ##   sfdrubycode = tmp[:blktbsfieldcode_rubycode]  if tmp
    	 ## if sfdrubycode.nil?
		 ##   strsql = %Q/where  pobject_code_fld = '#{fld[:pobject_code_sfd].split("_",2)[1]}'  and fieldcode_expiredate > sysdate/
		 ##   tmp = plsql.r_fieldcodes.first(strsql)
         ##   sfdrubycode = tmp[:fieldcode_rubycode] if tmp
         ## end
     end	
  end
  if sfdrubycode
     define_method("sub_set_default_value_#{sfdrubydefname}") do |command_c|
	    sfdrubycode
     end 
  end	 
end




 def in_the_future
    # Some other code
  end
  # 5.minutes.from_now will be evaluated when in_the_future is called
  handle_asynchronously :in_the_future, :run_at => Proc.new { 5.minutes.from_now }
  
  
  class BlkLink < DbCud
        def initialize
		    
   
        end
  end		
  
            str_newclass = ""
            recs = plsql.r_tblinks.all  
			recs.each do |rec|
			     str_newclass << "class DbCud_#{rec[:pobject_code_tbl_src]}_#{rec[:pobject_code_tbl_dest]} \n"
				 kyrec = plsql.r_tblinkkys.first("where tblink_id = #{rec[:id]} ")
				 if kyrec
				    prv_chk_linkkys rec[:tblink_blktb_id_dest]
				   else 
				    prv_add_linkkys rec[:tblink_blktb_id_dest]
				 end	
				 fldrec = plsql.r_tblinkflds.first("where tblink_id = #{rec[:id]} ")
				 if kyrec
				     prv_chk_linkfld rec[:tblink_blktb_id_dest]
				   else 
				    prv_add_linkflds rec[:tblink_blktb_id_dest]
				 end	
				 str_newclass << "def initialize command_c \n"
				 str_newclass << %Q/@destfld = plsql.#{rec[:pobject_code_tbl_dest]}.first(" where id = #{id} ") \n/
				 str_newclass << "end \n"
			end
			
		def testlinks	
	        recs = plsql.r_tblinks.all  
			recs.each do |rec|
				 fldrec = plsql.r_tblinkflds.first("where tblink_id = #{rec[:id]} ")
				 if fldrec.nil?
				    fldrecs = plsql.r_blktbsfieldcode.all("where blktbsfieldcode_blktb_id = #{rec[:blktb_id_src]}  and blktbsfieldcode_expiredate > sysdate")
			        fldrecs.each do |fldrec|
			           fld = {}
		    	       fld[:tblinks_id] = rec[:tblink_id]
			           fld[:persons_id_upd] = 0
			           fld[:created_at] = Time.now
			           fld[:updated_at] = Time.now
		               fld[:remark] = "auto created "		   
			           fld[:id] = plsql.tblinkflds_seq.nextval
			           fld[:fieldcode] = fldrec[:pobject_code_fld]
			        end
				 end	
			end
		end	
		def prv_init_add_linkflds rec
		    fldrecs = plsql.r_blktbsfieldcode.all("where blktbsfieldcode_blktb_id = #{rec[:blktb_id_src]}  and blktbsfieldcode_expiredate > sysdate")
			fldrecs.each do |fldrec|
			    fld = {}
		    	fld[:tblinks_id] = rec[:tblink_id]
			    fld[:persons_id_upd] = 0
			    fld[:created_at] = Time.now
			    fld[:updated_at] = Time.now
		        fld[:remark] = "auto created "		   
			   fld[:id] = plsql.tblinkflds_seq.nextval
			   fld[:fieldcode] = fldrec[:pobject_code_fld]
			end
		end