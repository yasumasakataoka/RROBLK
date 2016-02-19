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
	    command_c = init_from_screen ###params
        rdata =  []
        command_c[:sio_strsql] = get_strsql if params[:ss_id] and  params[:ss_id] != ""  ##親画面情報引継
        command_c[:sio_classname] = @sio_classname = "screen_blk_paging"
        command_c[:sio_start_record] = (params[:page].to_i - 1 ) * params[:rows].to_i + 1
        command_c[:sio_end_record] = params[:page].to_i * params[:rows].to_i 
        command_c[:sio_sord] = params[:sord]
        command_c[:sio_search] = if params[:_search] == "true" or params[:undefined_search] == "true" then "true" else "false" end  
        command_c[:sio_sidx]  = params[:sidx]
        rdata = subpaging(command_c,@screen_code)     ## rdata[データの中身,レコード件数]
        @tbldata = rdata[0].to_jqgrid_xml(@show_data[:allfields] ,params[:page], params[:rows],rdata[1]) 
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
        strsql = " select * from  r_chilscreens where pobject_code_scr_ch = '#{chil_code}' and pobject_code_scr = '#{pare_code}' and chilscreen_Expiredate > current_date order by chilscreen_expiredate "
        chilf = ActiveRecord::Base.connection.select_all(strsql)
	    chil_screen = chilf[0]["pobject_code_scr_ch"]
	    pkey = []
	    rcd_id = []
	    chilf.each do |rec|
           rcd_id  << params[:data][rec["pobject_code_sfd"].to_sym]  ### 親画面テーブル内の子画面へのkeyとなるid
		   pkey << rec["pobject_code_sfd_ch"]
	    end
        @ss_id = user_parescreen_nextval.to_s   ###子画面に引き継ぐセッションid 
	    ### 
        hash_rcd = {}
        hash_rcd[:rcd_id_val] = rcd_id ##### rcd_id:親画面テーブル内の子画面へのkeyとなるid
	    ###子の画面の既定値をセット
	    tmp_str = ActiveRecord::Base.connection.select_one(" select * from r_screens where pobject_code_scr = '#{chil_screen}' and screen_Expiredate > current_date order by screen_expiredate ")
        if  tmp_str["screen_strwhere"] =~ /where / 
	        hash_rcd[:strsql] = "(select * from #{tmp_str["pobject_code_view"]} " +  tmp_str["screen_strwhere"]
	     else
		    hash_rcd[:strsql] = "(select * from #{tmp_str["pobject_code_view"]} where "
        end		
        pkey.each_with_index do |ele,idx|
	  	   hash_rcd[:strsql]  << "#{ele} = #{rcd_id[idx]}  and " 
        end	
	    if  tmp_str["screen_strgrouporder"]
	        hash_rcd[:strsql]  =  hash_rcd[:strsql][0..-5] +	  tmp_str["screen_strgrouporder"] + " )  a " 
		  else
		    hash_rcd[:strsql]  =  hash_rcd[:strsql][0..-5] +	" )  a "
	    end
        sub_parescreen_insert hash_rcd
        render :layout=>false 
            ActiveRecord::Base.connection.commit_db_transaction()
    end   ### nst
#####
    def get_strsql 
        ActiveRecord::Base.connection.select_value("select strsql from parescreen#{@sio_user_code}s where id = #{params[:ss_id]} and expiredate > current_date")
    end  
    def  get_url_from_code  ###params[:sio_viewname]  screen_code   ,params[:fieldname] page downが押された項目
		init_from_screen
		case params[:fieldname]
			when /_code/
				akeyfs,scrname,delm,mltblname =  get_ary_find_field params[:fieldname]
				if   scrname then   
					@getname = {:scrname => scrname}
					render :json => @getname
				else
					render :nothing => true
				end
			when /_sno_|_cno_/
		end
	end
	def  set_price_and_amt  ###画面
		tblnamechop,field = params[:chgname].split("_")
		@getprice = {}
		command_c = init_from_screen
		if tblnamechop == @screen_code.split("")[1].chop and field =~ /price/
			if params[(tblnamechop+"_qty").to_sym] != ""
				command_c[("#{tblnamechop}_contract_price").to_sym] = "Z"
				@getprice = proc_price_amt(command_c)
				render :json => @getprice
			else
				render :nothing => true
			end
		else
			if params[:itm_code] != "" and params[(tblnamechop+"_qty").to_sym] != "" and ( params[:loca_code_dealer] != "" or params[:loca_code_cust] != "")
				@getprice = proc_price_amt(command_c)
				render :json => @getprice
			else
				render :nothing => true
			end
		end
	end
	def  code_to_name    ### 必須keyとして登録された_codeが変化したときcall　　該当データなしの時の表示方法
		command_c = init_from_screen
		return if params[params[:chgname]]  =~ /dummy/ and params[:chgname] =~ /_sno_|_cno_/  ###trn でdummyの時は処理しない
		case 	params[:chgname]
			when /_sno_/  ###dummyの時は処理しない
				sw = vproc_get_contents_frm_sno 
			when /_cno_/  ###dummyの時は処理しない
				sw = vproc_get_contents_frm_cno
			else  ###codeの時は複数の項目でkeyになることがある。
				keyfields = {}
				if params[:chgname] =~ /^mk/
					mktblname,tblnamechop,field,delm = params[:chgname].split("_",4)
					if mktblname =~ /mksch|mkord|mkinst|mkact/
					else
						return
					end
				else
					tblnamechop,field,delm = params[:chgname].split("_",3)
				end
				@errmsg = ""
				if respond_to?("proc_view_field_#{params[:chgname]}_chk")
					__send__("proc_view_field_#{params[:chgname]}_chk",params)  ###バッチで処理することもあるのであえてparamsを引数にしている。
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
						when @screen_code.split("_",2)[1].chop  ###同一テーブル新規のときのチェック		        
							sw = same_tbl_code_to_name tblnamechop,field
						when "vf"+@screen_code.split("_")[1].chop
							sw = get_view_code_frm_screen_tblname params ###tblname対応
						else
							sw = oth_tbl_code_to_name params ####tblnamechop  
					end
				end
		end
		fprnt " line #{__LINE__} @getname #{@getname}" if @getname.has_key?(:custinst_loca_id_custrcvplc)
		if sw == "ON" or sw == "MISSING"
			render :json => @getname
		else
			render :nothing => true
		end
	end
	def get_ary_find_field field   ###excel importでも使用 そのためscreen_code等が引数になっている。
		strwhere = "select * from r_screenfields where pobject_code_sfd = '#{field}' and screenfield_paragraph is not null  "    ##検索元のテーブルを求める。
		strwhere  << " and pobject_code_scr = '#{@screen_code}' AND screenfield_expiredate > current_date" 
		v = ActiveRecord::Base.connection.select_one(strwhere)
		scrname =  rec = delm = nil
		akeyfs = []
		if   v then   ###グループを求める。
			scrname,delm =  v["screenfield_paragraph"].split(":_")
			strwhere = "select * from r_screenfields where screenfield_paragraph = '#{v["screenfield_paragraph"]}' "
			strwhere  << " and pobject_code_scr = '#{@screen_code}' AND screenfield_expiredate > current_date" 
			keyfs = ActiveRecord::Base.connection.select_all(strwhere)
			keyfs.each do |rec|
				akeyfs << rec["pobject_code_sfd"] 
			end
		end
		mktblname = if field =~ /^mk/ then field.split("_")[0] else nil end
		return akeyfs,scrname,delm,mktblname
	end	
	def    oth_tbl_code_to_name params ####tblnamechop
		akeyfs,scrname,delm,mktblname =  get_ary_find_field params[:chgname]
		keyfields = {}
		sw = "ON"
		params.each do |key,val|
			if  akeyfs.index(key.to_s) then
				if  params[key] and params[key] != "" and key.to_s !~ /_cno/ then keyfields[key] = val else sw = "OFF" end
			end
		end
		rec = get_tblfieldval_from_code keyfields,scrname,delm ,mktblname if sw == "ON"   ###data get
		@getname ={}
		if  rec then
			rec.each do |key,val|
				if mktblname.nil? then nkey = key else nkey = (mktblname + "_" + key)  end
				nkey = if  delm.nil? then  nkey else  (nkey+"_"+delm)  end
				if  nkey != "id" then  @getname[nkey] = rec[key] end  ### 
			end
          else
			@getname[params[:chgname].to_sym] = "???"  if sw == "ON" ### ""だとスペースにならない。
		end
		return sw
    end

   def  same_tbl_code_to_name tblnamechop,field
		sw = "OFF"
		grps  = proc_blk_constrains(tblnamechop+"s",field,"U",nil)
		keyfields = {}
		grps.each do  |grp| 
			keyfs = proc_blk_constrains(tblnamechop+"s",nil,"U",grp["constraint_name"])
			keyfs.each do |rec|
				fld = rec["column_name"].downcase
				if params[tblnamechop+"_"+fld]
					if params[tblnamechop+"_"+fld] != "" 
						keyfields[tblnamechop+"_"+fld] = params[tblnamechop+"_"+fld]
						sw = "ON"
					else
						sw = "OFF"
					end
				else
					sw = "OFF"
				end
			end
			break if sw == "ON"
			keyfields = {}
		end 
		rec = nil
		rec = get_tblfieldval_from_code keyfields,"r_"+tblnamechop+"s",nil,nil  if sw == "ON" 
		@getname ={}
		if rec then
            rec.each do |key,val|
                if  key != "id" then  @getname[key] = rec[key] end  ### 
            end
             @getname[:errmsg] = " #{keyfields.values.join(',')}.....already exists"
        else
             @getname.delete(params[:chgname].to_sym)
        end
        return sw
    end
   def get_tblfieldval_from_code keys,viewname,delm,mktblname
      strwhere = " where "
      tblname = viewname.split("_")[1].chop
      keys.each do |key,val|
           if  delm then nkey = key.to_s.sub("_#{delm}","") else nkey = key end
           nkey = if  mktblname then nkey.sub("#{mktblname}_","") else nkey end
           strwhere << nkey + " = '" + val  + "'    and "
      end
      strwhere << "#{tblname}_expiredate > current_date order by #{tblname}_expiredate "
      rec = ActiveRecord::Base.connection.select_one("select * from #{viewname} #{strwhere}")
   end
   def   get_view_code_frm_screen_tblname params
      akeyfs,scrname,delm,mktblname =  get_ary_find_field params[:chgname]
      keyfields = {}
      sw = "ON"
      params.each do |key,val|
           if  akeyfs.index(key.to_s) then
               if  params[key] and params[key] != "" then keyfields[key] = val else sw = "OFF" end
           end
      end
	  if sw == "ON" 	     
         mytbl = @screen_code.split("_")[1].chop
	     tblnamekey = (mytbl+"_tblname").to_sym
	     scrname = params[tblnamekey].to_s
		 prgfs = ActiveRecord::Base.connection.select_all(" select * from r_tblfields where pobject_code_tbl = '#{@screen_code.split("_")[1]}' 
											and tblfield_viewflmk like 'tblnamefields%' and tblfield_expiredate > current_date ")
		 newkeyfields = {}
		 tblarray = {}
		 prgfs.each do |prgf|  ###tblnameの架空項目を実項目へ変換
		    key = "vf" + mytbl + "_" + prgf["pobject_code_fld"]
		    if akeyfs.index(key)
               tblarray = eval(prgf["tblfield_viewflmk"])
               newkeyfields[tblarray[params[tblnamekey].to_sym].to_sym] = params[key.to_sym]			   
			end
		 end
         rec = get_tblfieldval_from_code newkeyfields,scrname,nil, nil  #### delm = mktblname = nil 
         @getname ={}
         if   rec then
			 @getname[(mytbl+"_tblid")] = rec["id"]
             prgfs.each do |keys|
				     tblarray = eval(keys["tblfield_viewflmk"])
                     orgkey = tblarray[params[tblnamekey].to_sym]	
			         @getname[("vf"+mytbl+"_"+keys["pobject_code_fld"]).to_sym] = rec[orgkey]
             end
           else
		      @getname[params[:chgname].to_sym] = "???"  ### ""だとスペースにならない。
         end
	  end
      return sw
    end
	def   vproc_get_contents_frm_sno
		sw = "ON"
		strsql = "select screenfield_paragraph from r_screenfields where pobject_code_sfd = '#{params[:chgname]}' and pobject_code_scr = '#{@screen_code}' AND screenfield_expiredate > current_date" 
		screenfield_paragraph = ActiveRecord::Base.connection.select_value(strsql)   ###画面のfield
		@getname ={}
		if screenfield_paragraph
			sno_tblnamechop = screenfield_paragraph.split(":_")[0].split("_")[1].chop
			sno_fld = params[:chgname].split("_",2)[1].sub((screenfield_paragraph.split(":")[1]||=""),"")   ### params[:chgname] = table name _ field
			strsql = "select * from r_#{sno_tblnamechop}s where #{sno_tblnamechop}_#{sno_fld} = '#{params[params[:chgname]]}'  and #{sno_tblnamechop}_expiredate > current_date "
			sno_rec = ActiveRecord::Base.connection.select_one(strsql)    ### snoのrec
			@getname ={}
			if sno_rec
				bal_qty = proc_get_bal_qty(sno_tblnamechop+"s",sno_rec["id"])
				##proc_opeitm_instance(sno_rec)
				screen_show_data = get_show_data(@screen_code)[:allfields]
				flds_sno_show_data = get_show_data("r_#{sno_tblnamechop}s")[:allfields]
				type_sno_show_data = get_show_data("r_#{sno_tblnamechop}s")[:alltypes]
				screen_show_data.each do |scrf|
					if flds_sno_show_data.index(scrf) and sno_rec[scrf.to_s] and params[scrf] == ""
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
						if sno_rec[fld]  and params[scrf]   == "" ###xxx_yyyy でテーブル名xxxが異なっていても項目yyyyが同じならデータを引く継
							case type_sno_show_data[fld.to_sym]
								when /date/
									@getname[scrf] = sno_rec[fld].strftime("%Y/%m/%d")
								when /time/
									@getname[scrf] = sno_rec[fld].strftime("%Y/%m/%d %H:%M")
								else
									@getname[scrf] = sno_rec[fld] ## if k_to_s != "id" 
							end
						end		
					end
				end
				sym_balqty = (@screen_code.split("_",2)[1].chop + "_qty_bal").to_sym 
				@getname[sym_balqty] = bal_qty
				if (sno_rec["opeitm_packqty"]||=0) == 0
					@getname[sym_balqty.to_s.sub("_qty_bal","_qty_case_bal").to_sym] = bal_qty
				else
					@getname[sym_balqty.to_s.sub("_qty_bal","_qty_case_bal").to_sym] = bal_qty / sno_rec["opeitm_packqty"]
				end
			else
		      @getname[params[:chgname].to_sym] = "???"  ### ""だとスペースにならない。
            end   
		else
		      @getname[params[:chgname].to_sym] = " paragraph set error "  ### 画面登録時にチェックしている　チェック漏れがない限り発生しない。
        end
		return sw
    end
	def proc_get_bal_qty tblname,id
		case tblname
			when /ords$/
				strsql = "select sum(qty) bal_qty from alloctbls where srctblname = 'trngantts' and destblname = '#{tblname}' and destblid = #{id} and qty > 0
					group by srctblname "
				bal_qty_ord = ActiveRecord::Base.connection.select_value(strsql)
				bal_qty_ord ||= 0
				strsql = "select sum(qty) bal_qty from alloctbls where srctblname = 'trngantts' and destblname = '#{tblname.sub(/ords$/,"insts")}'

													and destblid in (select id from #{tblname.sub(/ords$/,"insts")} where sno_ord in(select  sno from #{tblname} where id = #{id}))
							group by srctblname"
				bal_qty_inst = ActiveRecord::Base.connection.select_value(strsql)
				bal_qty_inst ||= 0			
			when /insts$/
				strsql = "select sum(qty) bal_qty from alloctbls where srctblname = 'trngantts' and destblname = '#{tblname}' and destblid = #{id} and qty > 0
					group by srctblname , destblname, destblid "
				bal_qty_inst = ActiveRecord::Base.connection.select_value(strsql)
				bal_qty_inst ||= 0
				bal_qty_ord = 0
		end
		case @screen_code
			when /ord$/
				return bal_qty_ord + bal_qty_inst
			when /insts$/
				return bal_qty_inst
			when /reply/
				return bal_qty_ord
			when /rslt/
				return bal_qty_inst
		end
	end
	def   vproc_get_contents_frm_cno   ###
		sw = "ON"
		strsql = %Q& select screenfield_paragraph from r_screenfields where pobject_code_sfd = '#{params[:chgname]}' 
							  and pobject_code_scr = '#{@screen_code}' AND screenfield_expiredate > current_date& 
		cno_screen = ActiveRecord::Base.connection.select_value(strsql).split(":_")[0]   ###画面のfield
		strsql = %Q& select pobject_code_sfd,screenfield_paragraph from r_screenfields where pobject_code_scr = '#{@screen_code}'
								and screenfield_paragraph like '#{cno_screen}%' AND screenfield_expiredate > current_date& 
		cno_keys = ActiveRecord::Base.connection.select_all(strsql)
		@getname ={}
		strwhere = "where "
		cno_keys.each do |cno_key|
			if cno_key["pobject_code_sfd"] =~ /_cno/
				strwhere << %Q& #{cno_screen.split("_",2)[1].chop}_cno  = '#{params[cno_key["pobject_code_sfd"].to_sym]}' and  &
			else
				strwhere << %Q& #{cno_key["pobject_code_sfd"].sub((cno_key["screenfield_paragraph"].split(":_")[1]||=""),"")} = '#{params[cno_key["pobject_code_sfd"].to_sym]}' and   &
			end
		end
		if cno_screen
			strsql = "select * from #{cno_screen} #{strwhere} #{cno_screen.split("_",2)[1].chop}_expiredate > current_date "
			cno_rec = ActiveRecord::Base.connection.select_one(strsql)    ### cnoのrec
			if   cno_rec 
				screen_show_data = get_show_data(@screen_code)[:allfields]
				flds_cno_show_data = get_show_data(cno_screen)[:allfields]
				type_cno_show_data = get_show_data(cno_screen)[:alltypes]
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
						fld = if scrf.to_s.split("_",2)[1]  then (cno_screen.split("_",2)[1].chop + "_" + scrf.to_s.split("_",2)[1]) else "" end
						if cno_rec[fld] and  fld =~/_qty|_duedate|_sno_|_id/  ###cnoの引き継ぎ項目 ###xxx_yyyy でテーブル名xxxが異なっていても項目yyyyが同じならデータを引く継
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
        pdfscript = ActiveRecord::Base.connection.select_one("select * from r_reports where pobject_Code_rep = '#{params[:pdflist]}' and  report_Expiredate > current_date")
        if  pdfscript
            reports_id = pdfscript["id"]
		    command_c = init_from_screen ###params   ##get @show_data
            strwhere = proc_pdfwhere(pdfscript,command_c)
            command_c[:sio_strsql] = " (select * from #{@show_data[:screen_code_view]} " + strwhere + " ) a"
	        command_c[:sio_end_record] = 1000
	        command_c[:sio_start_record] = 1
		    command_c[:sio_totalcount] = 0
			command_c[:sio_classname] = @sio_classname = "preview_prnt_paging"
            ##p "strwhere #{strwhere}"
            rdata = subpaging(command_c,@screen_code)     ## subpaging  
            ActiveRecord::Base.connection.commit_db_transaction()
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
    def proc_updatechk_add command_c,add_edit   ### view blk_constraintsは初期セットしていること
		## addのとき
		## ukeyの重複はエラー
		####strsql = %Q% where table_name = '#{command_c[:sio_viewname].split("_")[1].upcase}'  and  constraint_type = 'U' order by constraint_name %
		constr = proc_blk_constrains command_c[:sio_viewname].split("_")[1],nil,'U',nil
		orakeyarray = {}
		constr.each do |rec|
			if  orakeyarray[rec["constraint_name"].to_sym] then
				orakeyarray[rec["constraint_name"].to_sym]  << rec["column_name"]  ##二回目以降
            else
				orakeyarray[rec["constraint_name"].to_sym]  =[]      ###初回
				orakeyarray[rec["constraint_name"].to_sym]  << rec["column_name"]
			end
		end
		orakeyarray.each do |inx,val|
			strwhere = " where "
			val.each do |key|
				strwhere << " #{wherefieldset(key.downcase,command_c)}     and " 
			end
			rec_id = ActiveRecord::Base.connection.select_value(%Q& select id from #{command_c[:sio_viewname].split("_")[1]} #{strwhere[0..-5]} &)
			@errmsg << "err:duplicate #{strwhere[6..-5]} " if rec_id and add_edit == "add"
			@errmsg << "err:already exists #{strwhere[6..-5]} " if rec_id and rec_id != command_c[:id] and add_edit == "edit"
		end
	end
	def proc_updatechk_edit command_c   ###全面修正か廃止 code-->^code xxxs_idとして使用されているかどうか
		## updateのとき
		## 外部keyとして参照されているとき　codeの変更は不可
		updtbl =  ActiveRecord::Base.connection.select_one(%Q& SELECT * FROM #{command_c[:sio_viewname].split("_")[1]} where id = #{command_c[:id]||=-1} &)
		if updtbl
			if updtbl[:code]
				if updtbl[:code] != command_c[(command_c[:sio_viewname].split("_")[1].chop + "_code").to_sym]
					constr = proc_blk_constrains nil,"#{command_c[:sio_viewname].split("_")[1].upcase}_ID%",'R',nil
					constr.each do |rec|
						ex = ActiveRecord::Base.connection.select_one("select * from #{rec["table_name"]} where  #{rec[:column_name]} = #{command_c[:id]}")
						@errmsg << " #{rec[:table_name]}," if ex
					end
				end
			end	 
			if @errmsg.size> 1
				@errmsg = ("err:code:#{updtbl[:code]} already use  table " + @errmsg).chop	  
			end
		end
    end
    def updatechk_del command_c
		## delのとき
		##すでに外部keyとして参照されているときは削除不可
		### idだけでなくなくcodeとの整合性も確認のこと
		### strsql = %Q& select * from blk_constraints where column_name like '#{command_c[:sio_viewname].split("_",2)[1].upcase}_ID%'  and  constraint_type = 'R' &
		constr = proc_blk_constrains nil,"#{command_c[:sio_viewname].split("_")[1].upcase}_ID%",'R',nil
		constr.each do |rec|
			ex = ActiveRecord::Base.connection.select_one(%Q& select * from #{rec["table_name"]}  where  #{rec["column_name"]} = #{command_c[:id]} &)
		    @errmsg << " #{rec["table_name"]}," if ex
		end 
		if @errmsg.size> 1
			@errmsg = ("err:code already use  table " + @errmsg).chop	  
		end
    end
    def updatechk_foreignkey command_c   ## xxx_idの確認		
		constr =
			ActiveRecord::Base.uncached() do
				case Db_adapter 
					when /post/
						ActiveRecord::Base.connection.select_values("SELECT xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")  ##post
					when /oracle/
						ActiveRecord::Base.connection.select_values("select column_name from blk_constraints where table_name = '#{command_c[:sio_viewname].split("_")[1].upcase}'  and  constraint_type = 'R' ")  ##oracle
				end
			end
	    constr.each do |column_name|    ### blk_constraints   user_constraints と user_cons_columns　から作成 
	        ##key = command_c[:sio_viewname].split("_")[1].chop+"_"+ column_name.split("_")[0].chop.downcase + "_id"
	        key = command_c[:sio_viewname].split("_")[1].chop+"_"+ column_name.downcase.sub("s_id","_id")
	        if  command_c[key.to_sym] 
					ex = ActiveRecord::Base.connection.select_value(" select id from #{column_name.split("_")[0]} where id =  #{command_c[key.to_sym]}")
					@errmsg << " #{column_name.split("_")[0]}," if ex.nil?
			else
				@errmsg << " #{column_name.split("_")[0]},"
		    end
	    end
	    if @errmsg.size> 1 and command_c[:sio_viewname] !~ /screenfields/
           @errmsg = ("err:table #{@errmsg} can not find  or expiredate < #{Time.now} ").chop	
	   else
			@errmsg = ""
	    end
    end
    def wherefieldset(key,command_c)
        new_key = if key =~ /_id/ then command_c[:sio_viewname].split("_")[1].chop + "_"  + key.sub("s_id","_id") else
                                      command_c[:sio_viewname].split("_")[1].chop+ "_"  + key end
        new_val = command_c[new_key.to_sym]  
		type = ActiveRecord::Base.connection.select_one(%Q& select * from r_tblfields where pobject_code_tbl = '#{command_c[:sio_viewname].split("_")[1]}' and pobject_code_fld = '#{key}' &)["fieldcode_ftype"]
		case type
			when /date/
				key = "to_char(#{key},'yyyy/mm/dd') "
				new_val = "'#{new_val.strftime('%Y/%m/%d')}'"
			when /time/
				key = "to_char(#{key},'yyyy/mm/dd hh24:mi') "
				new_val = "'#{new_val.strftime('%Y/%m/%d %H:%M')}'"
			when /char|text/
				new_val = "'#{new_val}'"
			when /number/
				new_val = new_val.to_s
		end
		return key + " = " + new_val
    end
end ## ScreenController