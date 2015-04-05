# -*- coding: utf-8 -*-  
#### v084
## 同一login　userではviewとscreenは一対一
### show_data   画面の対するviewとその項目をユーザー毎にセット
class ScreenController < ListController
  respond_to :html ,:xml ##  将来　タイトルに変更
   def index
      init_from_screen ###params
      @pare_class = "online"
      @scriptopt = @options = {}
      @options[:div_repl_id] =   @ss_id = "" ###@ss_id 親画面から引き継いだid
      @title = sub_blkgetpobj(@screen_code,"screen")
	  if @screen_code =~ /gantttrn/ 
	      @master = false  
		else
          @master = true 
	  end
    end  ##index
    def disp   ##  jqgrid返り
        params[:page] ||= 1 
        params[:rows] ||= 50
        ##fprnt "class #{self} : LINE #{__LINE__} screen_code #{screen_code}"		
	    command_c = init_from_screen ###params
        rdata =  []
        ##fprnt "class #{self} : LINE #{__LINE__} command_r #{command_r}"
        command_c[:sio_strsql] = get_strsql if params[:ss_id] and  params[:ss_id] != ""  ##親画面情報引継
        command_c[:sio_classname] = @sio_classname = "screen_blk_paging"
        command_c[:sio_start_record] = (params[:page].to_i - 1 ) * params[:rows].to_i + 1
        command_c[:sio_end_record] = params[:page].to_i * params[:rows].to_i 
        command_c[:sio_sord] = params[:sord]
        command_c[:sio_search] = if params[:_search] == "true" or params[:undefined_search] == "true" then "true" else "false" end  
        command_c[:sio_sidx]  = params[:sidx]
        rdata = subpaging(command_c,@screen_code)     ## rdata[データの中身,レコード件数]
        ####plsql.commit    要チェック
        @tbldata = rdata[0].to_jqgrid_xml(@show_data[:allfields] ,params[:page], params[:rows],rdata[1]) 
        ##fprnt "class #{self} : LINE #{__LINE__} @tbldata #{@tbldata}"
        respond_with @tbldata
    end  ##disp
    def nst  ###子画面　
        init_from_screen ###params
        pare_code =  params[:nst_tbl_val].split("_div_")[0]   ### 親のviewのcode
        chil_code =  params[:nst_tbl_val].split("_div_")[1]   ### 子のviewのcode
        @title =  sub_blkgetpobj(params[:nst_tbl_val].split("_div_")[1],"screen")   ### 子の画面
        #####cnt_detail =  params[:nst_tbl_val].split(";")[3]   ### 子の画面位置
        ##########
        @options ={}
        @options[:div_repl_id] = "#{pare_code}_div_#{chil_code}"  ### 親画面内の子画面表示のための　div のid
        @options[:autowidth] = "false"  
        strsql = " where pobject_code_scr_ch = '#{chil_code}' and pobject_code_scr = '#{pare_code}' and chilscreen_Expiredate > current_date order by chilscreen_expiredate "
        chilf = plsql.r_chilscreens.all(strsql)
	    chil_screen = chilf[0][:pobject_code_scr_ch]
	    pkey = []
	    rcd_id = []
	    chilf.each do |rec|
           rcd_id  << params[:data][rec[:pobject_code_sfd].to_sym]  ### 親画面テーブル内の子画面へのkeyとなるid
		   pkey << rec[:pobject_code_sfd_ch]
	    end
        @ss_id = user_parescreen_nextval.to_s   ###子画面に引き継ぐセッションid 
	    ### 
        hash_rcd = {}
        hash_rcd[:rcd_id_val] = rcd_id ##### rcd_id:親画面テーブル内の子画面へのkeyとなるid
	    ###子の画面の既定値をセット
	    tmp_str = plsql.r_screens.first("where pobject_code_scr = '#{chil_screen}' and screen_Expiredate > current_date order by screen_expiredate ")
        if  tmp_str[:screen_strwhere] =~ /where / 
	        hash_rcd[:strsql] = "(select * from #{tmp_str[:pobject_code_view]} " +  tmp_str[:screen_strwhere]
	     else
		    hash_rcd[:strsql] = "(select * from #{tmp_str[:pobject_code_view]} where "
        end		
        pkey.each_with_index do |ele,idx|
	  	   hash_rcd[:strsql]  << "#{ele} = #{rcd_id[idx]}  and " 
        end	
	    if  tmp_str[:screen_strgrouporder]
	        hash_rcd[:strsql]  =  hash_rcd[:strsql][0..-5] +	  tmp_str[:screen_strgrouporder] + " )  a " 
		  else
		    hash_rcd[:strsql]  =  hash_rcd[:strsql][0..-5] +	" )  a "
	    end
        sub_parescreen_insert hash_rcd
        render :layout=>false 
        plsql.commit
    end   ### nst
#####
    def get_strsql 
        hash_rcd = plsql.__send__("parescreen#{@sio_user_code}s").first("where id = #{params[:ss_id]} and expiredate > current_date")
        ##if Rails.cache.exist?(rcdkey)   then  ### 
        if hash_rcd   then   strsql =  hash_rcd[:strsql] else  strsql = nil  end  ### 親からのidで子を表示
        return strsql
    end  
    def  get_url_from_code  ###params[:q]  screen_code   ,params[:fieldname] page downが押された項目
		case params[:fieldname]
			when /_code/
				akeyfs,viewname,delm =  get_ary_find_field params[:q],params[:fieldname]
				if   viewname then   
					@getname = {:viewname => viewname}
					render :json => @getname
				else
					render :nothing => true
				end
			when /_sno_|_cno_/
		end
	end
	def  set_price_and_amt  ###画面
		tblnamechop = params[:q].split("_")[1].chop
		@getprice = {}
		if params[:itm_code] and params[(tblnamechop+"_qty").to_sym] and ( params[:loca_code_dealer] or params[:loca_code_cust])\
			and params[(tblnamechop+"_contract_price").to_sym]  != "Z"  ###  手入力の時は何もしない
			command_c = params.dup  ### paramsをパラメータで渡すと　excelの取り込みが変わってしまう
			@getprice = proc_price_amt(command_c)
		else
			@getprice = {}
		end
	end
	def  code_to_name    ### 必須keyとして登録された_codeが変化したときcall　　該当データなしの時の表示方法
		case 	params[:chgname]
			when /_sno_/
				sw = vproc_get_contents_frm_sno
			when /_cno_/
				sw = vproc_get_contents_frm_cno
			else  ###codeの時は複数の項目でkeyになることがある。
				keyfields = {}
				tblnamechop,field,delm = params[:chgname].split("_",3)
				exit if  tblnamechop == params[:q].split("_")[1].chop and params[:code_to_name_oper] != "add" and params[:code_to_name_oper] != "copyandadd" 
				###既定値のセットは2dc_jqgridで実施
				## 前処理
				@errmsg = ""								
				if respond_to?("proc_view_field_#{params[:chgname]}_chk")
					__send__("proc_view_field_#{params[:chgname]}_chk",params)
					if @errmsg != ""
						@getname = {}
						@getname[params[:chgname].to_sym] = @errmsg
						render :json => @getname and return
					end
				end
				if @errmsg == ""
					if respond_to?("proc_view_field_#{params[:chgname]}_init")
						__send__("proc_view_field_#{params[:chgname]}_init",params)
						##tbs,screen,field,の時は　pobjectへの登録もしている。
					else	  
						fld_key = params[:chgname].split("_",2)[1]
						if respond_to?("proc_field_#{fld_key}_init")
							__send__("proc_field_#{fld_key}_init",params) 
						end
					end
					case tblnamechop
						when params[:q].split("_")[1].chop  ###同一テーブル新規のときのチェック		        
							sw = same_tbl_code_to_name tblnamechop,field
						when "vf"+params[:q].split("_")[1].chop
							sw = get_view_code_frm_screen_tblname  ###tblname対応
						else
							sw = oth_tbl_code_to_name ####tblnamechop  
					end
				end
		end
		debugger if @getname.has_key?(:custinst_loca_id_custrcvplc)
		if sw == "ON" or sw == "MISSING"
			render :json => @getname and return
		else
			render :nothing => true
		end
	end
	def get_ary_find_field screen_code,field   ###excel importでも使用 そのためscreen_code等が引数になっている。
		strwhere = "where pobject_code_sfd = '#{field}' and screenfield_paragraph is not null  "    ##検索元のテーブルを求める。
		strwhere  << " and pobject_code_scr = '#{screen_code}' AND screenfield_expiredate > current_date" 
		v = plsql.r_screenfields.first(strwhere)
		viewname =  rec = delm = nil
		akeyfs = []
		if   v then   ###グループを求める。
			viewname,delm =  v[:screenfield_paragraph].split(":_")
			strwhere = "where screenfield_paragraph = '#{v[:screenfield_paragraph]}' "
			strwhere  << " and pobject_code_scr = '#{screen_code}' AND screenfield_expiredate > current_date" 
			keyfs = plsql.r_screenfields.all(strwhere)
			keyfs.each do |rec|
				akeyfs << rec[:pobject_code_sfd]
			end
		end
		return akeyfs,viewname,delm
	end	
	def    oth_tbl_code_to_name ####tblnamechop
		akeyfs,viewname,delm =  get_ary_find_field params[:q],params[:chgname]
		keyfields = {}
		sw = "ON"
		params.each do |key,val|
			if  akeyfs.index(key.to_s) then
				if  params[key] and params[key] != "" then keyfields[key] = val else sw = "OFF" end
			end
		end
		rec = get_tblfieldval_from_code keyfields,viewname,delm  if sw == "ON"   ###data get
		@getname ={}
		if  rec then
			rec.each do |key,val|
				if  delm.nil? then nkey = key else nkey = (key.to_s+"_"+delm).to_sym  end
				if  nkey.to_s != "id" then  @getname[nkey] = rec[key].to_s end  ### 
			end
          else
			@getname[params[:chgname].to_sym] = "???"  if sw == "ON" ### ""だとスペースにならない。
		end
		return sw
    end

   def  same_tbl_code_to_name tblnamechop,field
      sw = "ON"
	  strsql = %Q% where table_name = '#{(tblnamechop+"s").upcase}'  and  constraint_type = 'U' and  column_name =  '#{field.upcase}'  %
      grp  = plsql.blk_constraints.first(strsql)
      if  grp then
		  strsql = %Q% where table_name = '#{(tblnamechop+"s").upcase}'  and  constraint_type = 'U' and  constraint_name =  '#{grp[:constraint_name]}'  %
          keyfs = plsql.blk_constraints.all(strsql)
          akeyfs = []
          keyfs.each do |rec|
             akeyfs << rec[:column_name]
          end
          keyfields = {}
          params.each do |key,val|
             if  key.to_s.split("_")[0]  == tblnamechop and akeyfs.index(key.to_s.split("_",2)[1].upcase) then
                 if  params[key] and params[key] != "" then keyfields[key] = val else sw = "OFF" end
             end
          end
         else
           sw = "OFF"
       end 
       rec = nil
       rec = get_tblfieldval_from_code keyfields,"r_"+tblnamechop+"s",nil  if sw == "ON" 
       @getname ={}
       if rec then
             rec.each do |key,val|
                  if  key.to_s != "id" then  @getname[key] = rec[key].to_s end  ### 
             end
             @getname[:errmsg] = " #{keyfields.values.join(',')}.....already exists"
          else
             @getname.delete(params[:chgname].to_sym)
        end
        return sw
   end
   def get_tblfieldval_from_code keys,viewname,delm
      strwhere = " where "
      tblname = viewname.split("_")[1].chop
      keys.each do |key,val|
           if  delm then nkey = key.to_s.sub("_#{delm}","") else nkey = key.to_s end
           strwhere << nkey + " = '" + val  + "'    and "
      end
      strwhere << "#{tblname}_expiredate > current_date order by #{tblname}_expiredate "
      rec = plsql.__send__(viewname).first(strwhere)
   end
   def   get_view_code_frm_screen_tblname 
      akeyfs,viewname,delm =  get_ary_find_field params[:q],params[:chgname]
      keyfields = {}
      sw = "ON"
      params.each do |key,val|
           if  akeyfs.index(key.to_s) then
               if  params[key] and params[key] != "" then keyfields[key] = val else sw = "OFF" end
           end
      end
	  if sw == "ON" 	     
         mytbl = params[:q].split("_")[1].chop
	     tblnamekey = (mytbl+"_tblname").to_sym
	     viewname = params[tblnamekey].to_s
		 prgfs = plsql.r_blktbsfieldcodes.all("where pobject_code_tbl = '#{params[:q].split("_")[1]}' and blktbsfieldcode_viewflmk like 'tblnamefields%' and blktbsfieldcode_expiredate > current_date ")
		 newkeyfields = {}
		 tblarray = {}
		 prgfs.each do |prgf|  ###tblnameの架空項目を実項目へ変換
		    key = "vf" + mytbl + "_" + prgf[:pobject_code_fld]
		    if akeyfs.index(key)
               tblarray = eval(prgf[:blktbsfieldcode_viewflmk])
               newkeyfields[tblarray[params[tblnamekey].to_sym].to_sym] = params[key.to_sym]			   
			end
		 end
		 delm = nil
         rec = get_tblfieldval_from_code newkeyfields,viewname,delm  
         @getname ={}
         if   rec then
			 @getname[(mytbl+"_tblid").to_sym] = rec[:id]
             prgfs.each do |keys|
				     tblarray = eval(keys[:blktbsfieldcode_viewflmk])
                     orgkey = tblarray[params[tblnamekey].to_sym]	
			         @getname[("vf"+mytbl+"_"+keys[:pobject_code_fld]).to_sym] = rec[orgkey.to_sym]
             end
           else
		      @getname[params[:chgname].to_sym] = "???"  ### ""だとスペースにならない。
         end
	  end
      return sw
    end
	def   vproc_get_contents_frm_sno
		sw = "ON"
		strsql = "select screenfield_paragraph from r_screenfields where pobject_code_sfd = '#{params[:chgname]}' and pobject_code_scr = '#{params[:q]}' AND screenfield_expiredate > current_date" 
		sno_view = ActiveRecord::Base.connection.select_one(strsql)   ###画面のfield
		@getname ={}
		if sno_view
			sno_tblnamechop = sno_view["screenfield_paragraph"].split("_",2)[1].chop
			strsql = "select * from #{sno_view["screenfield_paragraph"]} where #{sno_tblnamechop}_sno = '#{params[params[:chgname].to_sym]}'  and #{sno_tblnamechop}_expiredate > current_date "
			sno_rec = ActiveRecord::Base.connection.select_one(strsql)    ### snoのrec
			bal_sno_qty = vproc_get_sno_bal_qty(sno_tblnamechop+"s",sno_rec["id"])
			proc_opeitm_instance(sno_rec)
			@getname ={}
			if   sno_rec then
				screen_show_data = get_show_data(params[:q])[:allfields]
				flds_sno_show_data = get_show_data(sno_view["screenfield_paragraph"])[:allfields]
				type_sno_show_data = get_show_data(sno_view["screenfield_paragraph"])[:alltypes]
				screen_show_data.each do |scrf|
					if flds_sno_show_data.index(scrf) and sno_rec[scrf.to_s]
						case type_sno_show_data[scrf]
							when /date/
								@getname[scrf] = sno_rec[scrf.to_s].strftime("%Y/%m/%d")
							when /time/
								@getname[scrf] = sno_rec[scrf.to_s].strftime("%Y/%m/%d %H:%M")
							else
								@getname[scrf] = sno_rec[scrf.to_s] ## if k_to_s != "id"        ## 2dcのidを修正したほうがいいのかな
						end
					else
						fld = if scrf.to_s.split("_",2)[1]  then (sno_tblnamechop + "_" + scrf.to_s.split("_",2)[1]) else "" end
						if sno_rec[fld] ###xxx_yyyy でテーブル名xxxが異なっていても項目yyyyが同じならデータを引く継
							case type_sno_show_data[fld.to_sym]
								when /date/
									@getname[scrf] = sno_rec[fld].strftime("%Y/%m/%d")
								when /time/
									@getname[scrf] = sno_rec[fld].strftime("%Y/%m/%d %H:%M")
								else
									@getname[scrf] = sno_rec[fld] ## if k_to_s != "id" 
									if fld =~ /_qty$/ then @getname[scrf] = bal_sno_qty end 
									if fld =~ /_qty_case$/ then   @getname[scrf] = bal_sno_qty / @opeitm[:packqty]	end 									   
							end
						end
					end
				end
			else
		      @getname[params[:chgname].to_sym] = "???"  ### ""だとスペースにならない。
            end   
		else
		      @getname[params[:chgname].to_sym] = " paragraph set error "  ### 画面登録時にチェックしている　チェック漏れがない限り発生しない。
        end
		return sw
    end
	def vproc_get_sno_bal_qty tblname,id
		strsql = "select sum(qty) bal_qty from alloctbls where srctblname = 'trngantts' and destblname = '#{tblname}' and destblid = #{id} and qty > 0
					group by srctblname , destblname, destblid "
		bal = ActiveRecord::Base.connection.select_one(strsql)
		if bal then bal["bal_qty"] else 0 end
	end
	def   vproc_get_contents_frm_cno   ###cnoの時は　itms_idとcusts_idは必須
		sw = "ON"
		strsql = %Q& select * from r_screens where pobject_code_scr  = (
		                      select screenfield_paragraph from r_screenfields where pobject_code_sfd = '#{params[:chgname]}' 
							  and pobject_code_scr = '#{params[:q]}' AND screenfield_expiredate > current_date)& 
		cno_screen = ActiveRecord::Base.connection.select_one(strsql)   ###画面のfield
		@getname ={}
		if params[:itm_code].nil? or params[:itm_code] == "" 
			sw = "MISSing"
			@getname[params[:chgname].to_sym] = "missing item_cod" 
			@getname[:itm_code] = "???"
			return sw
		end		
		if params[:loca_code_cust].nil? or params[:loca_code_cust] == "" 
			sw = "MISSING"
			@getname[params[:chgname].to_sym] = "missing cust_cod" 
			@getname[:loca_code_cust] = "???"
			return sw
		end
		if cno_screen
			strsql = "select * from #{cno_screen["pobject_code_view"]} 
								where #{cno_screen["pobject_code_view"].split("_",2)[1].chop}_cno = '#{params[params[:chgname].to_sym]}'  
			                    and itm_code = '#{params[:itm_code]}' and loca_code_cust = '#{params[:loca_code_cust]}'
								and #{cno_screen["pobject_code_view"].split("_",2)[1].chop}_expiredate > current_date "
			cno_rec = ActiveRecord::Base.connection.select_one(strsql)    ### cnoのrec
			if   cno_rec then
				screen_show_data = get_show_data(params[:q])[:allfields]
				flds_cno_show_data = get_show_data(cno_screen["pobject_code_scr"])[:allfields]
				type_cno_show_data = get_show_data(cno_screen["pobject_code_scr"])[:alltypes]
				screen_show_data.each do |scrf|
					if flds_cno_show_data.index(scrf) and cno_rec[scrf.to_s]
						case type_cno_show_data[scrf]
							when /date/
								@getname[scrf] = cno_rec[scrf.to_s].strftime("%Y/%m/%d")
							when /time/
								@getname[scrf] = cno_rec[scrf.to_s].strftime("%Y/%m/%d %H:%M")
							else
								@getname[scrf] = cno_rec[scrf.to_s] ## if k_to_s != "id"        ## 2dcのidを修正したほうがいいのかな
						end
					else
						fld = if scrf.to_s.split("_",2)[1]  then (cno_screen["pobject_code_view"].split("_",2)[1].chop + "_" + scrf.to_s.split("_",2)[1]) else "" end
						if cno_rec[fld] and  fld =~/_qty|_duedate/  ###cnoの引き継ぎ項目 get_return_name_valの修正も必要 ###xxx_yyyy でテーブル名xxxが異なっていても項目yyyyが同じならデータを引く継
							case type_cno_show_data[fld.to_sym]
								when /date/
									@getname[scrf] = cno_rec[fld].strftime("%Y/%m/%d")
								when /time/
									@getname[scrf] = cno_rec[fld].strftime("%Y/%m/%d %H:%M")
								else
									@getname[scrf] = cno_rec[fld] ## if k_to_s != "id"  									   
							end
						end
					end
				end
			else
				@getname[params[:chgname].to_sym] = "???"  ### ""だとスペースにならない。
				sw = "MISSing"
            end   
		else
			@getname[params[:chgname].to_sym] = " paragraph set error "  ### 画面登録時にチェックしている　チェック漏れがない限り発生しない。
			sw = "MISSing"
        end
		return sw
    end
    def preview_prnt 
        rdata =  []
        pdfscript = plsql.r_reports.first("where pobject_Code_rep = '#{params[:pdflist]}' and  report_Expiredate > current_date")
        if  pdfscript
            reports_id = pdfscript[:id]
		    command_c = init_from_screen ###params   ##get @show_data
            strwhere = proc_pdfwhere(pdfscript,command_c)
            command_c[:sio_strsql] = " (select * from #{@show_data[:screen_code_view]} " + strwhere + " ) a"
	        command_c[:sio_end_record] = 1000
	        command_c[:sio_start_record] = 1
		    command_c[:sio_totalcount] = 0
			command_c[:sio_classname] = @sio_classname = "preview_prnt_paging"
            ##p "strwhere #{strwhere}"
            rdata = subpaging(command_c,@screen_code)     ## subpaging  
            plsql.commit
            ##respond_with @tbldata.to_jqgrid_json(@show_data[:allfields] ,params[:page], params[:rows],command_c[:sio_totalcount]) 
            @tbldata = rdata[0].to_jqgrid_xml(@show_data[:allfields] ,params[:page], params[:rows],rdata[1]) 
            respond_with @tbldata
		  else
            render :nothing =>true		  
	 	end
    end  #select _opt
##  def xparams
##      @xparams
##  end
 ####### ajaxでは xls,xlsxはdownloadできない?????
    def blk_print
        render :nothing=> true
    end  
    def befor_chk_update
    end
    def updatechk_add command_c   ### view blk_constraintsは初期セットしていること
      ## addのとき
      ## ukeyの重複はエラー
	  strsql = %Q% where table_name = '#{command_c[:sio_viewname].split("_")[1].upcase}'  and  constraint_type = 'U' order by constraint_name %
      constr = plsql.blk_constraints.all(strsql)
      orakeyarray = {}
      constr.each do |rec|
         if  orakeyarray[rec[:constraint_name].to_sym] then
             orakeyarray[rec[:constraint_name].to_sym]  << rec[:column_name]  ##二回目以降
            else
              orakeyarray[rec[:constraint_name].to_sym]  =[]      ###初回
              orakeyarray[rec[:constraint_name].to_sym]  << rec[:column_name]
          end
      end
      orakeyarray.each do |inx,val|
         strwhere = " where "
         val.each do |key|
            strwhere << " #{key} = '#{wherefieldset(key.downcase,command_c)}'   and " 
         end
         rec = plsql.__send__(command_c[:sio_viewname].split("_")[1]).first(strwhere[0..-5])
         @errmsg << "err:duplicate #{strwhere[6..-5]} " if rec
      end
   end
   def updatechk_edit command_c   ###全面修正か廃止 code-->^code xxxs_idとして使用されているかどうか
      ## updateのとき
      ## 外部keyとして参照されているとき　codeの変更は不可
	  updtbl = plsql.__send__(command_c[:sio_viewname].split("_")[1]).first("where id = #{command_c[:id]}")
	  if updtbl[:code]
	     if updtbl[:code] != command_c[(command_c[:sio_viewname].split("_")[1].chop + "_code").to_sym]
	        constr = plsql.blk_constraints.all("where column_name like '#{command_c[:sio_viewname].split("_")[1].upcase}_ID%'  and  constraint_type = 'R' ")
	        constr.each do |rec|
	            ex = plsql.__send__(rec[:table_name]).first ("where  #{rec[:column_name]} = #{command_c[:id]}")
		        @errmsg << " #{rec[:table_name]}," if ex
	        end
	     end
	  end	 
	  if @errmsg.size> 1
         @errmsg = ("err:code:#{updtbl[:code]} already use  table " + @errmsg).chop	  
	  end
    end
	def proc_command_c_chk command_c
		command_c.each do |key,val|
			if val  ##必須チェックは画面又はimportで実施のこと
				if respond_to?("proc_view_field_#{key.to_s}_chk")
					__send__("proc_view_field_#{key.to_s}_chk",command_c,val)
				end
			end
		end
	end
    def updatechk_del command_c
		## delのとき
		##すでに外部keyとして参照されているときは削除不可
		### idだけでなくなくcodeとの整合性も確認のこと
		strsql = %Q& select * from blk_constraints where column_name like '#{command_c[:sio_viewname].split("_",2)[1].upcase}_ID%'  and  constraint_type = 'R' &
		constr = ActiveRecord::Base.connection.select_all(strsql)
		constr.each do |rec|
			ex = ActiveRecord::Base.connection.select_one(%Q& select * from #{rec["table_name"]}  where  #{rec["column_name"]} = #{command_c[:id]} &)
			debugger if ex
		    @errmsg << " #{rec[:table_name]}," if ex
		end 
		if @errmsg.size> 1
			@errmsg = ("err:code already use  table " + @errmsg).chop	  
		end
    end
    def updatechk_foreignkey command_c   ###画面の必須keyになっていれば、不要
        constr = plsql.blk_constraints.all("where table_name = '#{command_c[:sio_viewname].split("_")[1].upcase}'  and  constraint_type = 'R' ")
		fsym = :id
	    constr.each do |rec|    ### blk_constraints   user_constraints と user_cons_columns　から作成 
	        fsym = (command_c[:sio_viewname].split("_")[1].chop+"_"+rec[:column_name].split("_")[0].chop.downcase + "_" + rec[:column_name].split("_",2)[1].downcase).to_sym
	        if  command_c[fsym] and command_c[fsym].size > 0
	            ex = plsql.__send__(rec[:column_name].split("_")[0]).first ("where id =  #{command_c[fsym]}")
		        @errmsg << " #{rec[:column_name].split("_")[0]}," if ex.nil?
			else
				@errmsg << " #{rec[:column_name].split("_")[0]},"
		    end
	    end 
	    if @errmsg.size> 1
           @errmsg = ("err:table #{@errmsg} can not find  or expiredate < #{Time.now} ").chop	  
	    end
    end
    def wherefieldset(key,command_c)
        new_key = if key =~ /_id/ then command_c[:sio_viewname].split("_")[1].chop + "_"  + key.sub("s_id","_id") else
                                      command_c[:sio_viewname].split("_")[1].chop+ "_"  + key end
        return command_c[new_key.to_sym]                      
    end
	
end ## ScreenController


