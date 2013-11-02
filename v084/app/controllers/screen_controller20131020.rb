# -*- coding: utf-8 -*-  
#### v084
## 同一login　userではviewとscreenは一対一
### show_data   画面の対するviewとその項目をユーザー毎にセット
class ScreenController < ApplicationController
  before_filter :authenticate_user!  
  respond_to :html ,:xml, :json
  def index
      ###  @screenname_name  将来　タイトルに変更
     @pare_class = "online"
     @scriptopt ={}
     @options = {}
     @options[:div_repl_id] = ""
     @screen_code,@jqgrid_id  = get_screen_code
     @disp_screenname_name = sub_blkgetpobj(@screen_code,"screen")
    ### set_detail screen_code => "",@div_id => "" ,sqlstr =>""  ###親の画面だからnst なし
    ##debugger ## 詳細項目の確認
  end  ##index
  def disp   ##  jqgrid返り
   ##debugger ## 詳細項目セット
   params[:page] ||= 1 
   params[:rows] ||= 50
   @screen_code,@jqgrid_id = get_screen_code
    ##fprnt "class #{self} : LINE #{__LINE__} screen_code #{screen_code}"
   show_cache_key =  "show " + @screen_code +  sub_blkget_grpcode
   if Rails.cache.exist?(show_cache_key) then
           show_data = Rails.cache.read(show_cache_key)
          else 
	   ### create_def screen_code
	   show_data = set_detail(screen_code )  ## set gridcolumns
   end
   command_r = set_fields_from_allfields(show_data) ###画面の内容をcommand_rへ
   command_r[:sio_strsql] = get_strsql  ##親画面情報引継
   rdata =  []
   ##fprnt "class #{self} : LINE #{__LINE__} command_r #{command_r}"
   command_r[:sio_classname] = "plsql_blk_paging"
   command_r[:sio_start_record] = (params[:page].to_i - 1 ) * params[:rows].to_i + 1
   command_r[:sio_end_record] = params[:page].to_i * params[:rows].to_i 
   command_r[:sio_sord] = params[:sord]
   command_r[:sio_search] = params[:_search] 
   command_r[:sio_sidx]  = params[:sidx]
   command_r[:sio_code]  = @screen_code
   rdata = subpaging(command_r)     ## subpaging  
   ##debugger ##fprnt "class #{self} : LINE #{__LINE__} @tbldata #{@tbldata}"
   plsql.commit
   tcnt = rdata[1]

   @tbldata = rdata[0].to_jqgrid_xml(show_data[:allfields] ,params[:page], params[:rows],rdata[1]) 
   respond_with @tbldata
  end  ##disp
  def nst  ###子画面　link   xxxS_IDでリンクする時と　ctlXXXでリンクする時で分かれる。
     rcd_id  =  params[:id]  ### 親画面テーブル内の子画面へのkeyとなるid
     pare_code =  params[:nst_tbl_val].split("_div_")[0]   ### 親のviewのcode
     chil_code =  params[:nst_tbl_val].split("_div_")[1]   ### 子のviewのcode
     @disp_screenname_name =  sub_blkgetpobj(params[:nst_tbl_val].split("_div_")[1],"screen")   ### 子の画面
     #####cnt_detail =  params[:nst_tbl_val].split(";")[3]   ### 子の画面位置
     @screen_code,@jqgrid_id = get_screen_code
     show_cache_key =  "show " + @screen_code +  sub_blkget_grpcode
     if Rails.cache.exist?(show_cache_key) then
         show_data = Rails.cache.read(show_cache_key)
     else 
	 ### create_def screen_code
	 show_data = set_detail(@screen_code )  ## set gridcolumns
     end
     ##########
     @options ={}
     @options[:div_repl_id] = "#{pare_code}_div_#{chil_code}"  ### 親画面内の子画面表示のための　div のid
     @options[:autowidth] = "true"  
     chil_view = plsql.r_screens.first("where pobject_code_scr = '#{chil_code}' and screen_Expiredate > sysdate order by screen_expiredate ")[:pobject_code_view]  ## set @gridcolumns 
     pare_view = plsql.r_screens.first("where pobject_code_scr = '#{pare_code}' and screen_Expiredate > sysdate order by screen_expiredate ")[:pobject_code_view]  ## 
     ##debugger 
     ##p "chil_view : #{chil_view}  : #{@jqgrid_id} : "#{@disp_screenname_name} "
     ##p "{pare_view}{chil_view} : #{pare_view}#{chil_view}   :xxx: #{ params[:nst_tbl_val].split(";")[2]}" 
      rcd_id_cache_key = "RCD_ID" + current_user[:id].to_s + @jqgrid_id 
      ### set_detail でセットされた@jqgrid_id
      pkey = "#{chil_view.split("_")[1].chop}_#{pare_view.split("_")[1].chop}_id"
      hash_rcd = {}
      hash_rcd[:rcd_id_val] = rcd_id
      hash_rcd[:rcd_id_key] = pkey.to_sym
      if show_data[:allfields].index(pkey.to_sym) then
	  hash_rcd[:strsql] = "(select * from #{chil_view} where #{pkey} = #{rcd_id} )  a "
	 else
	     show_data[:allfields].each do |k|
		 if k.to_s[0,pkey.size - 1] == pkey then
	            pkey = k.to_s
		    hash_rcd[:strsql] = "(select * from #{chil_view} where #{pkey} = #{rcd_id} )  a "
		 end
             end
	     if hash_rcd[:strsql].nil?
		 hash_rcd[:strsql] = "(select * from  #{chil_view} where id in(select ctblid from CTL#{pare_view.split("_")[1]} where ptblid = #{rcd_id} and ctblname ='#{chil_view.split("_")[1]}')) a "
	     end
	 end
      Rails.cache.write(rcd_id_cache_key,hash_rcd)   ### add で受け取るための親　id save
      set_pare_contents pare_view,rcd_id      ## 
     ##debugger 
      render :layout=>false 
     plsql.commit
 end   ### nst

#####  親の項目をテーブルの上に表示
 def set_pare_contents pare_view,rcd_id
     @options[:pare_contents] = ""
     pare_data = plsql.__send__(pare_view).first("where id = #{rcd_id}")
     pare_data.each do |key,value|
       skey = key.to_s
       if (skey =~ /_code/ or skey =~ /_name/) and  skey !~ /_upd/  then
          @options[:pare_contents] << " <span> #{key.to_s} :  #{value}    ; </span> "   if value
       end
     end
 ##fprnt " class #{self} : LINE #{__LINE__}  nst @scriptopt[:pare_contents]  : #{@scriptopt[:pare_contents]}"
 end    ### def set_pare_contents pare_view,rcd_id
 ### formで矢印がきかない
 def add_upd_del    ##  add update delete
     params[:oper] = "add" if  params[:copy] == "yes"   ### copy and add
     screen_code,jqgrid_id = get_screen_code
     show_cache_key =  "show " + screen_code +  sub_blkget_grpcode
     if Rails.cache.exist?(show_cache_key) then
           show_data = Rails.cache.read(show_cache_key)
          else 
	   show_data = set_detail(screen_code )  ## set gridcolumns
     end
     ##debugger
     command_r  = set_fields_from_allfields(show_data)
     command_r[:sio_viewname]  = show_data[:screen_code_view] 
     command_r[:sio_user_code] = plsql.persons.first(:email =>current_user[:email])[:id]  ||= 0   ###########   LOGIN USER  
     command_r[:sio_code] = screen_code
     case params[:oper] 
       when "add"
          rcd_id_cache_key = "RCD_ID" + current_user[:id].to_s +  params[:q]  ### :q -->@jqgrid_id
          hash_rcd = Rails.cache.read(rcd_id_cache_key)  
          command_r[hash_rcd[:rcd_id_key]] =  hash_rcd[:rcd_id_val] unless hash_rcd.nil?
          command_r[:sio_classname] = "plsql_blk_insert"
          sub_insert_sio_c    command_r  ###更新要求
          ## command_r[:id_tbl] = nil
       when "del"
	  command_r[:sio_classname] = "plsql_blk_delete"
          sub_insert_sio_c command_r
       when "edit"
	 ###debugger
         command_r[:sio_classname] = "plsql_blk_update"
         sub_insert_sio_c     command_r  ###p "tblfields[:id_tbl] : #{tblfields[:id_tbl]}"
       else     
       ##debugger ## textは表示できないのでメッセージの変更要
       render :text => "return to menu because session loss params:#{params[:oper]} "
     end ## case parems[:oper]
     ##debugger
     plsql.commit
    dbcud = DbCud.new
    dbcud.perform(command_r[:sio_session_counter],"SIO_#{command_r[:sio_viewname]}")
   render :nothing=>true
 end  ## add_upd_del
 #####
  def get_strsql 
      rcd_id_cache_key = "RCD_ID" + current_user[:id].to_s + @jqgrid_id 
      if Rails.cache.exist?(rcd_id_cache_key)   then  ### 
         strsql =  Rails.cache.read(rcd_id_cache_key)[:strsql]   ### 親からのidで子を表示
        else
         tmp_str = plsql.r_screens.first("where pobject_code_scr = '#{screen_code}' and screen_Expiredate > sysdate order by screen_expiredate ")
         if tmp_str then
           strsql = " ( "  if tmp_str[:screen_strselect]
           strsql << tmp_str[:screen_strselect] if tmp_str[:screen_strselect]
           strsql << tmp_str[:screen_strwhere] if tmp_str[:screen_strwhere]
           strsql << tmp_str[:screen_strgrouporder] if tmp_str[:screen_strgrouporder]
           strsql << " ) a "  if tmp_str[:strselect]
         end
      end
     strsql = nil if strsql == ""
     return strsql
  end
  def set_fields_from_allfields show_data ###画面の内容をcommand_rへ
     command_r = {}
     eval( show_data[:evalstr] ) unless   show_data[:evalstr]  == ""   ###既定値等セット　画面からの入力優先
     show_data[:allfields].each do |j|
	## nilは params[j] にセットされない。
        command_r[j] = params[j]  if params[j]  ##unless j.to_s  == "id"  ## sioのidとｖｉｅｗのｉｄが同一になってしまう
        ##command_r[:id_tbl] = params[j].to_i if j.to_s == "id"          
     end ##
    ##fprnt " class #{self} : LINE #{__LINE__}  show_data : #{  show_data }"
    ##char_to_number_data      ##parmsの文字型を数字・日付に
    return command_r
  end  
  def screen_code
      @screen_code
  end

 def code_to_name
      chgname = params[:chgname]
      chgval  = params[:chgval]
     if chgname then
       getrecord = plsql.__send__(chgname.split(/_/)[0]+"s").first("where code = '#{chgval}'  and expiredate > sysdate  order by expiredate")
       if getrecord.nil? then
          @getname =  {"name" => "!!! no record"}
	 else
	  if getrecord[:name].nil? then
	     @getname = {"name" => "!!! no record"}
	   else
             @getname = {"name" => "#{getrecord[:name]}"}
          end ##getrecord[:name].nil? 
	 end ## getrecord
     end ##chgcode
     render :json => @getname
  end  #code_to_name
  def preview_prnt
       screen_code,jqgrid_id = get_screen_code
       show_cache_key =  "show " + screen_code +  sub_blkget_grpcode
       show_data = Rails.cache.read(show_cache_key)
      command_r ={}
      command_r[:sio_totalcount] = 0
      rdata =  []
      pdfscript = plsql.r_reports.first("where pobject_Code_lst = '#{params[:pdflist]}' and  report_Expiredate > sysdate")
      unless  pdfscript.nil? then
         reports_id = pdfscript[:id]
         strwhere = sub_pdfwhere(show_data[:screen_code_view] ,reports_id,command_r)
         command_r = set_fields_from_allfields(show_data) ###画面の内容をcommand_rへ
         command_r[:sio_strsql] = " (select * from #{show_data[:screen_code_view]} " + strwhere + " ) a"
	 command_r[:sio_end_record] = 1000
	 command_r[:sio_start_record] = 1
         ##p "strwhere #{strwhere}"
         rdata = subpaging(command_r)     ## subpaging  
         plsql.commit
      end
     ##respond_with @tbldata.to_jqgrid_json(show_data[:allfields] ,params[:page], params[:rows],command_r[:sio_totalcount]) 
       @tbldata = rdata[0].to_jqgrid_xml(show_data[:allfields] ,params[:page], params[:rows],rdata[1]) 
       respond_with @tbldata
  end  #select _opt

##  def xparams
##      @xparams
##  end
 ####### ajaxでは xls,xlsxはdownloadできない?????
 def blk_print
     render :nothing=> true
 end
 def gantt
     @ganttdata = sub_gantt_chart(params[:screen_code],params[:id])
     ###debugger
    fprnt("@ganttdata :#{@ganttdata}")
     render :json =>@ganttdata
 end
 def uploadgantt
     #JSON.parse(params)[:task]
     @ganttreturn = "retrurn ok"
 end
  def sub_gantt_chart screen_code,id
      ngantts = []
      time_now =  Time.now 
      ## {n0[:itm_id]} and locas_id = #{n0[:loca_id]} and processseq = #{n0[:processseq]} and priority = #{n0[:priority]}
      case screen_code
      when /^r_itms/   ##r_opeitm とcpo　procordがまだ
          itm = plsql.itms.first("where id = '#{id}'  ")
          r = plsql.opeitms.first("where itms_id = #{id} and Expiredate > sysdate   order by processseq desc,priority desc, Expiredate ")
      end
     ##debugger
     if r then 
        ngantts << {:seq=>"001",:mlevel=>1,:itm_id=>r[:itms_id],:loca_id=>r[:locas_id],:processseq=>r[:processseq],:priority=>r[:priority],:endtime=>time_now}
        cnt = 0
        @bgantts = {}
        @bgantts[:"000"] = {:mlevel=>0,:itm_code=>"",:itm_name=>"全行程",:loca_code=>"",:loca_name=>"",:duration=>"",:assigs=>"",:endtime=>time_now,:starttime=>nil,:depends=>""}
        until ngantts.size == 0
          cnt += 1
          ngantts = psub_get_itms_locas ngantts
          break if cnt >= 5
        end
      else
         return ""
     end
     id = 0
     min_starttime = time_now
     maxmlevel = 1  ##for level
     @bgantts.sort.each  do|key,value|
        id += 1
        @bgantts[key].merge! :id=>id
        if key.to_s.size > 3 then
           @bgantts[key.to_s[0..-4].to_sym][:depends] << id.to_s + "," 
           maxmlevel = @bgantts[key][:mlevel]  if @bgantts[key][:mlevel] > maxmlevel
        end
        min_starttime = @bgantts[key][:starttime] if  min_starttime > (@bgantts[key][:starttime]||= time_now)
     end
     @bgantts[:"000"][:starttime] = min_starttime 
     @bgantts[:"000"][:duration] =   ((@bgantts[:"000"][:endtime]  - min_starttime).divmod(24*60*60))[0]
     strgantt = '{"tasks":['
     @bgantts.sort.each  do|key,value|
     strgantt << %Q%{"id":"#{value[:id]}","itm_code":"#{value[:itm_code]}","itm_name":"#{value[:itm_name]}","loca_code":"#{value[:loca_code]}","loca_name":"#{value[:loca_name]}","pare_num":"#{value[:pare_num]}","chil_num":"#{value[:chil_num]}","start":#{value[:starttime].to_i.*1000},"duration":#{value[:duration]},"end":#{value[:endtime].to_i.*1000},"assigs":[],"depends":"#{value[:depends]}","level":#{if value[:mlevel] == 0 then 0 else (maxmlevel - value[:mlevel] ) end},"mlevel":#{value[:mlevel]}},%
     end
     ##debugger
     strgantt = strgantt.chop + %Q|],"selectedRow":0,"deletedTaskIds":[],"canWrite":true,"canWriteOnParent":true }|
     return strgantt
 end  
 def psub_get_itms_locas ngantts ### bgantt 表示内容　ngantt treeスタック
     ##ngantts[:seq,:mlevel,:loca_id,:itm_id]
     ##@bgantts{seq=>{:itm_code,:itm_name,:loca_code,:loca_name,:mlevel,:pare_num,:chil_num,:duration,:assigs,}}
     n0 = ngantts.shift
     #p "n0:#{n0}"
     r0 =  plsql.opeitms.first("where itms_id = #{n0[:itm_id]} and locas_id = #{n0[:loca_id]} and processseq = #{n0[:processseq] ||= 999} and priority = #{n0[:priority] ||= 999} and Expiredate > sysdate")
     if r0 then
         endtime = psub_get_contents(n0,r0)
         ngantts.concat(psub_get_chil_itms(n0,r0,endtime))
         ngantts.concat(psub_get_next_process(n0,r0,endtime))
        else
           psub_get_contents(n0,{})
          #p "where itms_id = #{n0[:itm_id]} and locas_id = #{n0[:loca_id]} and processseq = #{n0[:processseq]} and priority = #{n0[:priority]} and Expiredate > sysdate"
     end
     return ngantts
 end  ##  psub_get_itms_locas 
 def psub_get_contents(n0,r0)
     bgantt = {}
     itm = plsql.itms.first("where id = #{n0[:itm_id]} ")
     loca = plsql.locas.first("where id = #{n0[:loca_id]} ")
     bgantt[n0[:seq].to_sym] = {:mlevel=>n0[:mlevel],:itm_code=>itm[:code],:itm_name=>itm[:name],:loca_code=>loca[:code],:loca_name=>loca[:name],:duration=>(r0[:lt]||=0),:assigs=>"",:endtime=>n0[:endtime],:starttime=>n0[:endtime]-(r0[:lt]||=0)*24*60*60,:depends=>"",:pare_num=>n0[:pare_num],:chil_num=>n0[:chil_num]}
    ##p " Line #{__LINE__} #{bgantt}"
     @bgantts.merge! bgantt
     return bgantt[n0[:seq].to_sym][:starttime]
 end
 def psub_get_chil_itms(n0,r0,endtime)
     ngantts = []
     rnditms = plsql.nditms.all("where opeitms_id = #{r0[:id]} and Expiredate > sysdate ")
     if rnditms.size > 0 then
        mlevel = n0[:mlevel]
        mlevel += 1
        rnditms.each.with_index(1)  do |i,cnt|
           ngantts << {:seq=>n0[:seq] + sprintf("%03d", cnt),:mlevel=>mlevel,:itm_id=>i[:itms_id_nditm],:loca_id=>i[:locas_id_nditm],:priority=>r0[:priority],:endtime=>endtime,:pare_num=>i[:parenum],:chil_num=>i[:chilnum]}
        end         
     end
     return ngantts
 end
 def psub_get_next_process(n0,r0,endtime)
     ngantts = []
     ropeitms = plsql.opeitms.all("where itms_id = #{r0[:itms_id]} and Expiredate > sysdate and Priority = #{r0[:priority]} and processseq < #{r0[:processseq]}  order by   itms_id, processseq ")
     if ropeitms.size > 0 then
        nseq = n0[:seq][0..-3]
        ropeitms..each.with_index(2)  do |i,cnt|
           ngantts << {:seq=>(nseq + sprintf("%02d", cnt)),:mlevel=>n0[:mlevel],:itm_id=>i[:itms_id],:loca_id=>i[:locas_id],:endtime=>endtime}
           endtime = endtime - i[:lt]*24*60*60
        end         
     end
     return ngantts
 end

end ## ScreenController

