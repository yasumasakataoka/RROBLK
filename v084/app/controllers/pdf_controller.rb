class PdfController < ApplicationController
##page 対応
##合計
##新規　変更
before_filter :authenticate_user!  
include ActionView::Helpers::NumberHelper
	class PdfReport < Prawn::Document
		def to_pdf 
			yield
			render
		end
	end
    def index
        pdfparam = {}
        pagekey = []   ###定義してないとevalで消える
        if params[:pdflist]
            pdfscript = plsql.r_reports.first("where pobject_code_rep = '#{params[:pdflist]}' and  report_Expiredate > sysdate")
	        if pdfscript
	            f = File.open(".#{pdfscript[:report_filename]}", "r:UTF-8")	                        
                command_c = init_from_screen ###gridの選択項目をセットするため	@sio_user_code set			
				@new_sio_session_counter  = user_seq_nextval
				plsql.connection.autocommit = false
				command_c[:sio_session_counter] =   @new_sio_session_counter  = user_seq_nextval
		        sqlstr = proc_pdfwhere(pdfscript,command_c)
				viewname = pdfscript[:pobject_code_view]
	            if f
                    str = ""  ###prawn ruby coding
                    pdfparam = nil     
	                @sum = nil
	                while l = f.gets
                        case
	                        when l[0..14] == "##### /pdfparam"
                                eval(l.split("/")[1])	
                            when l[0..14] == "##### /order by"
	                            sqlstr << l.split("/")[1]    
	                        when l[0..13] == "##### /pagekey"
	                            eval(l.split("/")[1])    
	                        when l[0..10] == "##### /@sum"
	                             eval(l.split("/")[1])  
	                        else
                            str << l
	                    end  ##case
	                end  ##while
                    f.close 
	            end  ## f
	            ppdf = PdfReport.new({:page_size =>pdfparam[:page_size],:page_layout =>pdfparam[:page_layout],:margin =>pdfparam[:margin]})
	            ppdf.font "./vendor/font/ipaexm.ttf"
	            ##p "strsql #{sqlstr}"
                records = plsql.__send__(viewname).all(sqlstr)  
	            output = ppdf.to_pdf do
	                rcnt = cnt = 1
                    savebreakvalue = []
                    sum998 = {}
                    sum999 = {}
                    @sum.each do |key|
                        sum999[key] = 0
                        sum998[key] = 0
                    end
                    sum999[:blk_reccnt] = 0
                    sum999[:blk_pagecnt] = 0
		            sum998[:blk_reccnt] = 0
                    sum998[:blk_pagecnt] = 0
                    records.each do |record|
		                tmpbreakvalue = []
		                record.each_pair do |key,value|
	                        record[key] = value.encode('utf-8') if value.class == String
	                        tmpbreakvalue << value  if pagekey.index(key.to_s)
		                end
	                    if savebreakvalue != tmpbreakvalue then
	                        rcnt = 998
		                    ##p sum998 if  savebreakvalue != []
		                    eval(str) if  savebreakvalue != []
		                    @sum.each do |key|
                               sum998[key] = 0
	                        end
	                        sum998[:blk_pagecnt] = 1 
		                    sum999[:blk_pagecnt] += 1 
		                    sum998[:blk_reccnt] = 0
		                    ppdf.start_new_page  if  savebreakvalue != []
	                        savebreakvalue = tmpbreakvalue
		                    rcnt = cnt = 1
		                end                        ###ページ替えでない時
		                record.each_pair do |key,value|
	                        if @sum.index(key) then
	                            sum998[key] += value if value
	                            sum999[key] += value if value
	                        end
		                end
		                sum998[:blk_reccnt] += 1 
                        sum999[:blk_reccnt] += 1
	                    eval(str)
                        insert_hisofrprts pdfscript,record
	                    ##ppdf.text " " if rcnt == pdfparam[:max_rcnt] ###TypeError (can't dup NilClass):  対策
	                    if rcnt == pdfparam[:max_rcnt] then
		                    ppdf.start_new_page 
                            sum998[:blk_pagecnt] += 1 
                            sum999[:blk_pagecnt] += 1 
                        end
                        cnt += 1
	                    rcnt = if cnt.divmod(pdfparam[:max_rcnt])[1]  == 0 then pdfparam[:max_rcnt] else cnt.divmod(pdfparam[:max_rcnt])[1]  end
	                end ##record
 	                unless records.empty?
                        rcnt = 998
                        eval(str)
                        rcnt = 999
                        eval(str)
	                end
                end ## to_pdf	   
                @text = ""
                send_data output,:filename => "#{sub_blkgetpobj(params[:pdflist],'report')}_#{Time.now.strftime("%y%m%d%H%M%S")}.pdf",
				                 :type => "application/pdf" 	unless records.empty?																															
				plsql.commit
				dbcud = DbCud.new
				dbcud.perform(command_c[:sio_session_counter],@sio_user_code,"")
				plsql.connection.autocommit = true
                @text = " no record     --->click   here  close the window "
	            render :action=>"index" and return if records.empty?
            end  #pdfscript
            @text = " missing pdf scrit --->click   here  close the window "
            render :action=>"index" and return  unless  pdfscript
        end ##pdfscript
        @text = " pdf param missing      --->click   here  close the window "
        render :action=>"index" and return  unless params[:pdflist]
    end	##index
    def  insert_hisofrprts pdfscript,record
	    rec = {}
	    rec[:id] = proc_get_nextval "hisofrprts_seq"
	    rec[:tblname] = pdfscript[:pobject_code_view]  ##tblname = viewname
	    rec[:recordid] = record[:id]
	    rec[:reports_id] = pdfscript[:id]
	    rec[:issuedate] = Time.now
	    rec[:expiredate] = Date.strptime("2099/12/31", "%Y/%m/%d")
	    rec[:persons_id_upd] =  @sio_user_code
	    rec[:update_ip] = request.remote_ip
	    rec[:created_at] = Time.now
	    rec[:updated_at] = Time.now
	    plsql.hisofrprts.insert rec
		###オーダ確定
		confirm_sym = (pdfscript[:pobject_code_view].split("_")[1].chop + "_confirm").to_sym
		if pdfscript[:pobject_code_rep] =~ /order_list/ and record[confirm_sym] != "1"
			command_c = record.dup
			command_c = proc_set_command_c(command_c,pdfscript[:pobject_code_view]) do 
				command_c[confirm_sym] = "1"
				command_c[:sio_classname] = "pdfscript_edit_confirm"
			end
			proc_insert_sio_c    command_c 
			sub_userproc_chk_set command_c 
		end
    end
end  ###class
