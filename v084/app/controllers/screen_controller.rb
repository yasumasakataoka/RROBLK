# -*- coding: utf-8 -*-  
#### v084
## 同一login　userではviewとscreenは一対一
### show_data   画面の対するviewとその項目をユーザー毎にセット
class ScreenController < ListController
  respond_to :html ,:xml ##  将来　タイトルに変更
   def index
      get_screen_code   ##@screen_code,@jqgrid_id  
	  ##debugger
      init_from_screen 
      @pare_class = "online"
      @scriptopt = @options = {}
      @options[:div_repl_id] =   @ss_id = "" ###@ss_id 親画面から引き継いだid
      @disp_screenname_name = sub_blkgetpobj(@screen_code,"screen")
      ### set_detail screen_code => "",@div_id => "" ,sqlstr =>""  ###親の画面だからnst なし
      ##debugger ## 詳細項目の確認
   end  ##index
   def disp   ##  jqgrid返り
      ##debugger ## 詳細項目セット
      params[:page] ||= 1 
      params[:rows] ||= 50
      ##fprnt "class #{self} : LINE #{__LINE__} screen_code #{screen_code}"
	  get_screen_code
	  command_c = init_from_screen 
      command_c[:sio_strsql] = get_strsql if params[:ss_id] and  params[:ss_id] != ""  ##親画面情報引継
      rdata =  []
      ##fprnt "class #{self} : LINE #{__LINE__} command_r #{command_r}"
      command_c[:sio_classname] = "plsql_blk_paging"
      command_c[:sio_start_record] = (params[:page].to_i - 1 ) * params[:rows].to_i + 1
      command_c[:sio_end_record] = params[:page].to_i * params[:rows].to_i 
      command_c[:sio_sord] = params[:sord]
      command_c[:sio_search] = params[:_search] 
      command_c[:sio_sidx]  = params[:sidx]
      ##debugger #command_r[:sio_code]  = @screen_code
      rdata = subpaging(command_c,@screen_code)     ## rdata[データの中身,レコード件数]
      plsql.commit
      @tbldata = rdata[0].to_jqgrid_xml(@show_data[:allfields] ,params[:page], params[:rows],rdata[1]) 
      ##debugger ##fprnt "class #{self} : LINE #{__LINE__} @tbldata #{@tbldata}"
      respond_with @tbldata
   end  ##disp
   def nst  ###子画面　
      get_screen_code ###
      init_from_screen 
      pare_code =  params[:nst_tbl_val].split("_div_")[0]   ### 親のviewのcode
      chil_code =  params[:nst_tbl_val].split("_div_")[1]   ### 子のviewのcode
      @disp_screenname_name =  sub_blkgetpobj(params[:nst_tbl_val].split("_div_")[1],"screen")   ### 子の画面
      #####cnt_detail =  params[:nst_tbl_val].split(";")[3]   ### 子の画面位置
      ##@show_data = get_show_data(@screen_code)
      ##########
      @options ={}
      @options[:div_repl_id] = "#{pare_code}_div_#{chil_code}"  ### 親画面内の子画面表示のための　div のid
      @options[:autowidth] = "false"  
      strsql = " where pobject_code_scr_ch = '#{chil_code}' and pobject_code_scr = '#{pare_code}' and chilscreen_Expiredate > sysdate order by chilscreen_expiredate "
      chilf = plsql.r_chilscreens.all(strsql)
	  chil_screen = chilf[0][:pobject_code_scr_ch]
	  pkey = []
	  rcd_id = []
	  chilf.each do |rec|
         rcd_id  << params[:data][rec[:pobject_code_sfd].to_sym]  ### 親画面テーブル内の子画面へのkeyとなるid
		 pkey << rec[:pobject_code_sfd_ch]
	  end
      @ss_id = user_parescreen_nextval( current_user[:id]).to_s   ###子画面に引き継ぐセッションid
      rcdkey = "RCD_ID" + current_user[:id].to_s + @jqgrid_id + @ss_id
      hash_rcd = {}
      hash_rcd[:rcd_id_val] = rcd_id ##### rcd_id:親画面テーブル内の子画面へのkeyとなるid
	  ###子の画面の既定値をセット
	  tmp_str = plsql.r_screens.first("where pobject_code_scr = '#{chil_screen}' and screen_Expiredate > sysdate order by screen_expiredate ")
      if  tmp_str[:screen_strwhere] =~ /where / 
	     hash_rcd[:strsql] = "(select * from #{chil_screen} " +  tmp_str[:screen_strwhere]
	    else
		   hash_rcd[:strsql] = "(select * from #{chil_screen} where "
      end		
      pkey.each_with_index do |ele,idx|
	  	 hash_rcd[:strsql]  << "#{ele} = #{rcd_id[idx]}  and " 
      end	
	  if  tmp_str[:screen_strgrouporder]
	       hash_rcd[:strsql]  =  hash_rcd[:strsql][0..-5] +	  tmp_str[:screen_strgrouporder] + " )  a " 
		 else
		    hash_rcd[:strsql]  =  hash_rcd[:strsql][0..-5] +	" )  a "
	  end
      sub_parescreen_insert rcdkey,hash_rcd
      render :layout=>false 
	  ##debugger 
      plsql.commit
   end   ### nst
#####
   def get_strsql 
       strsql = ""
       hash_rcd = plsql.__send__("parescreen#{current_user[:id].to_s}s").first("where id = #{params[:ss_id]} and expiredate > sysdate")
      ##debugger
      ##if Rails.cache.exist?(rcdkey)   then  ### 
      if hash_rcd   then   strsql =  hash_rcd[:strsql]  end  ### 親からのidで子を表示
     strsql = nil if strsql == ""
     return strsql
   end
   def  set_fields_from_allfields ###画面の内容をcommand_rへ
     command_c = {}
     @show_data[:evalstr].each do |key,rubycode|   ###既定値等セット　画面からの入力優先
         ##debugger
         command_c[key] = eval(rubycode)
     end
     @show_data[:allfields].each do |j|
	## nilは params[j] にセットされない。
        command_c[j] = params[j]  if params[j]  ##unless j.to_s  == "id"  ## sioのidとｖｉｅｗのｉｄが同一になってしまう
        ##command_c[:id_tbl] = params[j].to_i if j.to_s == "id"          
     end ##
    return command_c
   end  
   def  get_url_from_code  ###params[:q]  screen_code   ,params[:fieldname] page downが押された項目
      akeyfs,viewname,delm =  get_ary_find_field params[:q],params[:fieldname]
      if   viewname then   
          @getname = {:viewname => viewname}
          render :json => @getname
         else
           render :nothing => true
      end
   end
   def  code_to_name    ### 必須keyとして登録された_codeが変化したときcall　　該当データなしの時の表示方法
      ##debugger
      keyfields = {}
      tblnamechop,field,delm = params[:chgname].split("_",3)
      exit if  tblnamechop == params[:q].split("_")[1].chop and params[:code_to_name_oper] != "add" and params[:code_to_name_oper] != "copyandadd" 
      ###既定値のセット
      params.each do |key,val|   
            dfltval =  plsql.r_rubycodings.first("where  pobject_objecttype = 'view_field' and  pobject_code = '#{key.to_s}'
	                       and rubycoding_code like '%_dflt%'  AND rubycoding_expiredate > sysdate")          
            if  dfltval
			    params[key] = eval(dfltval[:rubycoding_rubycode])  
			end
      end
      case tblnamechop
           when params[:q].split("_")[1].chop  ###同一テーブル新規のときのチェック		        
		        sw = same_tbl_code_to_name tblnamechop,field
           when "vf"+params[:q].split("_")[1].chop
			    sw = get_view_code_frm_screen_tblname  ###tblname対応
		   else
                sw = oth_tbl_code_to_name tblnamechop  
      end
      ##debugger
      if sw == "ON" 
     	  render :json => @getname and return
	  else
    	  render :nothing => true
      end
   end
   def get_ary_find_field screen_code,field   ###excel importでも使用
      strwhere = "where pobject_code_sfd = '#{field}' and screenfield_paragraph is not null  "    ##検索元のテーブルを求める。
      strwhere  << " and pobject_code_scr = '#{screen_code}' AND screenfield_expiredate > sysdate" 
      v = plsql.r_screenfields.first(strwhere)
      viewname =  rec = delm = nil
      akeyfs = []
      if   v then   ###グループを求める。
           viewname,delm =  v[:screenfield_paragraph].split(":_")
           strwhere = "where screenfield_paragraph = '#{v[:screenfield_paragraph]}' "
           strwhere  << " and pobject_code_scr = '#{screen_code}' AND screenfield_expiredate > sysdate" 
           keyfs = plsql.r_screenfields.all(strwhere)
           keyfs.each do |rec|
              akeyfs << rec[:pobject_code_sfd]
           end
      end
      return akeyfs,viewname,delm
   end	
   def    oth_tbl_code_to_name tblnamechop
      akeyfs,viewname,delm =  get_ary_find_field params[:q],params[:chgname]
      keyfields = {}
      sw = "ON"
      params.each do |key,val|
           if  akeyfs.index(key.to_s) then
               if  params[key] and params[key] != "" then keyfields[key] = val else sw = "OFF" end
           end
      end
      ##debugger
      rec = get_tblfieldval_from_code keyfields,viewname,delm  if sw == "ON" 
      @getname ={}
      if   rec then
             mytbl = params[:q].split("_")[1].chop
             rec.each do |key,val|
                  if  delm then nkey = (key.to_s+"_"+delm).to_sym else nkey = key end
                  if  nkey.to_s != "id" then  @getname[nkey] = rec[key].to_s end  ### 
             end
           else
		      @getname[params[:chgname].to_sym] = "???"  ### ""だとスペースにならない。
      end
      ##debugger
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
       ##debugger
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
                 ##debugger
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
      strwhere << "#{tblname}_expiredate > sysdate order by #{tblname}_expiredate "
      ##debugger
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
      ##debugger
	  if sw == "ON" 	     
         mytbl = params[:q].split("_")[1].chop
	     tblnamekey = (mytbl+"_tblname").to_sym
	     viewname = params[tblnamekey].to_s
		 prgfs = plsql.r_blktbsfieldcodes.all("where pobject_code_tbl = '#{params[:q].split("_")[1]}' and blktbsfieldcode_viewflmk like 'tblnamefields%' and blktbsfieldcode_expiredate > sysdate ")
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
		 ##debugger
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
      ##debugger
      return sw
    end

   def preview_prnt
      #show_data = get_show_data(@screen_code)
      #command_r ={}
      #command_r[:sio_totalcount] = 0
      rdata =  []
      pdfscript = plsql.r_reports.first("where pobject_Code_lst = '#{params[:pdflist]}' and  report_Expiredate > sysdate")
      unless  pdfscript.nil? then
         reports_id = pdfscript[:id]
		 get_screen_code
		 commnad_r = init_from_screen 
         strwhere = sub_pdfwhere(@show_data[:screen_code_view] ,reports_id,command_r)
         command_r[:sio_strsql] = " (select * from #{@show_data[:screen_code_view]} " + strwhere + " ) a"
	     command_r[:sio_end_record] = 1000
	     command_r[:sio_start_record] = 1
		 command_r[:sio_totalcount] = 0
         ##p "strwhere #{strwhere}"
         rdata = subpaging(command_r,@screen_code)     ## subpaging  
         plsql.commit
      end
     ##respond_with @tbldata.to_jqgrid_json(@show_data[:allfields] ,params[:page], params[:rows],command_r[:sio_totalcount]) 
       @tbldata = rdata[0].to_jqgrid_xml(@show_data[:allfields] ,params[:page], params[:rows],rdata[1]) 
       respond_with @tbldata
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
         ##debugger
         @errmsg << "err:duplicate #{strwhere[6..-5]} " if rec
      end
   end
   def updatechk_edit command_c
      ## updateのとき
      ## 外部keyとして参照されているとき　codeの変更は不可
	  updtbl = plsql.__send__(command_c[:sio_viewname].split("_")[1].upcase).first("where id = #{command_c[:id]}")
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
   def updatechk_del command_c
      ## delのとき
      ##すでに外部keyとして参照されているときは削除不可
	  constr = plsql.blk_constraints.all("where column_name like '#{command_c[:sio_viewname].split("_")[1].upcase}_ID%'  and  constraint_type = 'R' ")
	  constr.each do |rec|
	        ex = plsql.__send__(rec[:table_name]).first ("where  #{rec[:column_name]} = #{command_c[:id]}")
		    @errmsg << " #{rec[:table_name]}," if ex
	  end 
	  if @errmsg.size> 1
         @errmsg = ("err:code already use  table " + @errmsg).chop	  
	  end
   end
   def updatechk_foreignkey command_c   ###画面の必須keyになっていれば、不要
       constr = plsql.blk_constraints.all("where table_name = '#{command_c[:sio_viewname].split("_")[1].upcase}'  and  constraint_type = 'R' ")
	   constr.each do |rec|
	        ##debugger  ##person_id_updは必ずある。
	        fsym = (command_c[:sio_viewname].split("_")[1].chop+"_"+rec[:column_name].split("_")[0].chop.downcase + "_" + rec[:column_name].split("_",2)[1].downcase).to_sym
	        if  command_c[fsym] and command_c[fsym].size > 0
	            ex = plsql.__send__(rec[:column_name].split("_")[0]).first ("where id =  #{command_c[fsym]}")
		        @errmsg << " #{rec[:column_name].split("_")[0]}," if ex.nil?
			else
				@errmsg << " #{rec[:column_name].split("_")[0]}," 
		    end
	   end 
	   if @errmsg.size> 1
         @errmsg = ("err:mandatory　code not exists " + @errmsg).chop	  
	   end
   end
   def wherefieldset(key,command_c)
       new_key = if key =~ /_id/ then command_c[:sio_viewname].split("_")[1].chop + "_"  + key.sub("s_id","_id") else
                                      command_c[:sio_viewname].split("_")[1].chop+ "_"  + key end
      ##debugger
      return command_c[new_key.to_sym]                      
   end
   def init_from_screen 
      ###@screen_code,@jqgrid_id  = get_screen_code
	  ##debugger
	  command_c = {}
	  @show_data = get_show_data @screen_code
	  command_c = set_fields_from_allfields	
	  command_c[:sio_user_code] = plsql.persons.first(:email =>current_user[:email])[:id]  ||= 0   ###########   LOGIN USER
	  ##command_c[:person_id_upd] = command_c[:sio_user_code]
	  command_c[:sio_viewname]  = @show_data[:screen_code_view] 
	  command_c[:sio_code]  = @screen_code
	  command_c[(command_c[:sio_viewname].split("_")[1].chop+"_person_id_upd").to_sym] = command_c[:sio_user_code]
	  command_c[(command_c[:sio_viewname].split("_")[1].chop+"_update_ip").to_sym] = request.remote_ip
      return command_c
   end
end ## ScreenController


