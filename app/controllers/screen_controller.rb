#### v081
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
     @scriptopt[:pare_contents] = ""
     @options[:div_repl_id] = ""
     @options[:autowidth] = "true"
     ###sub_set_fields_from_allfields ###画面の内容をcommand_rへ
     get_screen_code 
     render :text =>"Create DetailFields #{screen_code} by crt_r_view_sql.rb" and  return if show_data.nil?
     @disp_screenname_name = sub_blkgetpobj(screen_code,"A")
     view_item_set
     ### set_detail screen_code => "",@div_id => "" ,sqlstr =>""  ###親の画面だからnst なし
    ##fprnt " class #{self} : LINE #{__LINE__}  show_data : #{  show_data }"
    ##fprnt " class #{self} : LINE #{__LINE__}  index  @gridcolumns : #{ @gridcolumns}"
    ##debugger ## 詳細項目の確認
   end  ##index

  def  view_item_set   
      ##debugger ## viewへの詳細項セット
      ### buttonの時は画面が変わるので
      ### 保持しているデータは削除
      # @session_data[:person_id] = plsql.persons.first(:email =>current_user[:email])[:id]   ###########   LOGIN USER  
      @options[:grp_search_form] = true if  screen_code =~ /^H\d_/
      @extbutton  = show_data[:extbutton] 
      @extdiv_id  = show_data[:extdiv_id]  
      ###@scriptopt[:scriptopt]  = show_data[:scriptopt] 
      @scriptopt[:aftershowform_add]  = show_data[:aftershowform_add] 
      @scriptopt[:aftershowform_edit]  = show_data[:aftershowform_edit] 
      @scriptopt[:pdf] = show_data[:pdf]   ###帳票名セット
      @gridcolumns =  show_data[:gridcolumns] 
      ##testx = "pdflist=custorder&initprnt=1"
      @scriptopt[:pdfdata] = %Q|function nWin() {var pdata = jQuery("##{@nst_screenname_id}").getPostData(); 
      var strparam;jQuery.each(pdata, function(key, value) {strparam = strparam + key + "=" + value + "&" }); strparam = strparam + "q=#{@nst_screenname_id}";
      var url = "/pdf/index?"+strparam;window.open(url);}jQuery(function() {jQuery(".#{@nst_screenname_id}_filterbuttonclass").click(nWin);});|
      ##jQuery(".#{id}_filterbuttonclass").click(function(){var pdata; pdata = jQuery("##{id}").getPostData(); 
     ### @scriptopt[:test] = 'window.open("/pdf/index");jQuery.get("/pdf/index",pdata);|

  end  ## user_scree
  
  def disp   ##  jqgrid返り
   ##debugger ## 詳細項目セット
   params[:page] ||= 1 
   params[:rows] ||= 50
   get_screen_code
    ##fprnt "class #{self} : LINE #{__LINE__} screen_code #{screen_code}"
   set_fields_from_allfields ###画面の内容をcommand_rへ
   command_r[:sio_strsql] = get_strsql
   rdata =  []
   ##fprnt "class #{self} : LINE #{__LINE__} command_r #{command_r}"
   command_r[:sio_classname] = "plsql_blk_paging"
   command_r[:sio_start_record] = (params[:page].to_i - 1 ) * params[:rows].to_i + 1
   command_r[:sio_end_record] = params[:page].to_i * params[:rows].to_i 
   command_r[:sio_sord] = params[:sord]
   command_r[:sio_search] = params[:_search] 
   command_r[:sio_sidx]  = params[:sidx]
   rdata = subpaging(command_r)     ## subpaging  
   ##debugger ##fprnt "class #{self} : LINE #{__LINE__} @tbldata #{@tbldata}"
   plsql.commit
   ##respond_with @tbldata.to_jqgrid_json(show_data[:allfields] ,params[:page], params[:rows],command_r[:sio_totalcount]) 
   tcnt = rdata[1]
   @tbldata = rdata[0].to_jqgrid_xml(show_data[:allfields] ,params[:page], params[:rows],rdata[1]) 
   respond_with @tbldata
  end  ##disp
  def nst  ###子画面　link
     rcd_id  =  params[:id]  ### 親画面テーブル内の子画面へのkeyとなるid
     pare_code =  params[:nst_tbl_val].split("-")[0]   ### 親のviewのcode
     chil_code =   params[:nst_tbl_val].split("-")[1]   ### 子のviewのcode
     @disp_screenname_name =  sub_blkgetpobj(params[:nst_tbl_val].split(";")[2],"A")   ### 子の画面
     #####cnt_detail =  params[:nst_tbl_val].split(";")[3]   ### 子の画面位置
     get_screen_code
     ##########
     @nst_screenname_id = "#{pare_code};#{chil_code}"   ### 親テーブルと子テーブルを;で分けた。
     @scriptopt = {}
     @options ={}
     @options[:div_repl_id] = "#{pare_code}-#{chil_code}"  ### 親画面内の子画面表示のための　div のid
     @options[:autowidth] = "true"  
     chil_view = plsql.screens.first("where code = '#{chil_code}' and Expiredate > sysdate order by expiredate ")[:viewname].upcase  ## set @gridcolumns 
     pare_view = plsql.screens.first("where code = '#{pare_code}' and Expiredate > sysdate order by expiredate ")[:viewname].upcase  ## set @gridcolumns 
     view_item_set    ###画面項目セット
     ##debugger 
     ## p "chil_view : #{chil_view.downcase}  : #{@nst_screenname_id} : "#{@disp_screenname_name} "
     ## p "{pare_view}{chil_view} : #{pare_view}#{chil_view}   :xxx: #{ params[:nst_tbl_val].split(";")[2]}" 
      rcd_id_cache_key = "RCD_ID" + current_user[:id].to_s + @nst_screenname_id 
      ### set_detail でセットされた@nst_screenname_id
      pkey = "#{pare_view[2..-2]}_id".downcase
      if show_data[:allfields].index(pkey.to_sym) then
	 else
	     show_data[:allfields].each do |k|
	     pkey = k.to_s if k.to_s[0,pkey.size] == pkey
         end
      end
      hash_rcd = {}
      hash_rcd[:strsql] = "(select * from #{chil_view} where #{pkey} = '#{rcd_id}' )  a "
      Rails.cache.write(rcd_id_cache_key,hash_rcd)   ### add で受け取るための親　id save
      set_pare_contents pare_view,rcd_id      ## 
     ##debugger 
     ## render :nst
     plsql.commit
     render :nst,:layout =>false
 end   ### nst

#####  親の項目をテーブルの上に表示
 def set_pare_contents pare_view,rcd_id
     @scriptopt[:pare_contents] = ""
     pare_data = plsql.__send__(pare_view).first("where id = #{rcd_id}")
     tcode = (pare_view[2..-2] + "_code").downcase.to_sym
     tname = (pare_view[2..-2] + "_name").downcase.to_sym
     @scriptopt[:pare_contents] = "code = #{pare_data[tcode]}"  unless pare_data[tcode].nil? 
     @scriptopt[:pare_contents] << " ( name : " + pare_data[tname]  + " )"   unless pare_data[tname].nil?
     if   @scriptopt[:pare_contents].empty? then
          dispfields = plsql.r_detailfields.all("where screen_viewname = '#{pare_view}' and              DETAILFIELD_TBLKEY = '#{pare_view[2..-1]}_ID'     order by detailfield_seqno ")
          if dispfields then
             dispfields.each do |i|
                if i[:detailfield_code] =~ /CODE/ then
                  ##fprnt "class #{self} : LINE #{__LINE__}  i[:detailfield_code] : #{i[:detailfield_code] } " 
                   @scriptopt[:pare_contents] << pare_data[i[:detailfield_code].downcase.to_sym] 
                   tname =i[:detailfield_code].gsub(/CODE/,"NAME").downcase.to_sym
                   @scriptopt[:pare_contents] << " (" + pare_data[tname]  + ")     "
                end
             end 
             dispfields.each do |i|
                unless i[:detailfield_code] =~ /CODE/ then
                   @scriptopt[:pare_contents] << sub_blkgetpobj(i[:detailfield_code],"1")  ### LOGIN_USER_ID
                   @scriptopt[:pare_contents] << " (" + pare_data[i[:detailfield_code].downcase.to_sym].to_s  + ")   "
                end
             end
          end  ### unless dispfields.nil? then
     end  ### if   @scriptopt[:pare_contents].empty?
  ##fprnt " class #{self} : LINE #{__LINE__}  nst @scriptopt[:pare_contents]  : #{@scriptopt[:pare_contents]}"
 end    ### def set_pare_contents pare_view,rcd_id
 ### formで矢印がきかない
 def add_upd_del    ##  add update delete
     params[:oper] = "add" if  params[:copy] == "yes"   ### copy and add
     get_screen_code
     set_fields_from_allfields
     case params[:oper] 
       when "add"
          rcd_id_cache_key = "RCD_ID" + current_user[:id].to_s +  params[:q]  ### :q -->@nst_screenname_id
          hash_rcd = Rails.cache.read(rcd_id_cache_key)  
          ##tmp_isnr =  sub_set_fields_from_allfields
          ##fprnt " class #{self} : LINE #{__LINE__}  hash_rcd  #{hash_rcd}"  unless hash_rcd.nil?
          ##fprnt " class #{self} : LINE #{__LINE__} hash_rcd  nil nil"  if hash_rcd.nil?
          tmp_isnr.merge! hash_rcd unless hash_rcd.nil?
          sub_insert_sio_c   do    ###更新要求
             command_r[:sio_classname] = "plsql_blk_insert"
             ## command_r[:id_tbl] = nil
          end
       when "del"
	  ##sub_set_fields_from_allfields ###画面の内容をcommand_rへ
          sub_insert_sio_c   do
             command_r[:sio_classname] = "plsql_blk_delete"
          end
       when "edit"
	 ###debugger
	 ##sub_set_fields_from_allfields ###画面の内容をcommand_rへ
         sub_insert_sio_c   do
           command_r[:sio_classname] = "plsql_blk_update"
	   ### p "tblfields[:id_tbl] : #{tblfields[:id_tbl]}"
         end
       else     
       ##debugger ## textは表示できないのでメッセージの変更要
       render :text => "return to menu because session loss params:#{params[:oper]} "
     end ## case parems[:oper]
     ###debugger
     plsql.commit
    dbcud = DbCud.new
    dbcud.perform(command_r[:sio_session_counter],"SIO_#{command_r[:sio_viewname]}")
    render :nothing=>true
 end  ## add_upd_del
 #####
  def get_strsql 
      rcd_id_cache_key = "RCD_ID" + current_user[:id].to_s + @nst_screenname_id 
      if Rails.cache.exist?(rcd_id_cache_key)   then  ### 
         strsql =  Rails.cache.read(rcd_id_cache_key)[:strsql]   ### 親からのidで子を表示
        else
         tmp_str = plsql.screens.first("where code = '#{screen_code}' and Expiredate > sysdate order by expiredate ")
         if tmp_str then
           strsql = " ( "  if tmp_str[:strselect]
           strsql << tmp_str[:strselect] if tmp_str[:strselect]
           strsql << tmp_str[:strwhere] if tmp_str[:strwhere]
           strsql << tmp_str[:strgrouporder] if tmp_str[:strgrouporder]
           strsql << " ) a "  if tmp_str[:strselect]
         end
      end
     strsql = nil if strsql == ""
     return strsql
  end
  def set_fields_from_allfields ###画面の内容をcommand_rへ
     #get_screen_code 
     @command_r = {}
     command_r
     if show_data.empty? 
        render :text => "Create DetailFields #{screen_code} by (crt_r_view_sql.rb  #{screen_code.split(/_/)[1]}) and restart rails "  and return
     end
     eval( show_data[:evalstr] ) unless  eval( show_data[:evalstr] ) == ""   ###既定値等セット　画面からの入力優先
     show_data[:allfields].each do |j|
	## nilは params[j] にセットされない。
        command_r[j] = params[j]  if params[j]  ##unless j.to_s  == "id"  ## sioのidとｖｉｅｗのｉｄが同一になってしまう
        ##command_r[:id_tbl] = params[j].to_i if j.to_s == "id"          
     end ##
    ##fprnt " class #{self} : LINE #{__LINE__}  show_data : #{  show_data }"
    ##char_to_number_data      ##parmsの文字型を数字・日付に
  end  
  def get_screen_code 
      ##debugger ## 画面の項目
      if params[:action]  == "index"  then  ## listからの初期画面の時
         @screen_code = @nst_screenname_id  = params[:id].upcase
      else
        if  params[:q]  and  params[:q].split('_')[2].nil?  then ## 
            @screen_code = @nst_screenname_id   =  params[:q].to_s.upcase 
        else    ###子画面の時
	  @nst_screenname_id   =  params[:q].to_s.upcase
          ###@screen_code = params[:q].split('_')[1].to_s.upcase[-1] +  "_" + params[:q].split('_')[2].to_s.upcase
          @screen_code =  params[:nst_tbl_val].split(";")[1]  ###chil_scree_code
	end
      end
     screen_code
     @show_data = get_show_data(screen_code, @nst_screenname_id )
     show_data
     ##debugger
     @scriptopt = {}
     @scriptopt[:pare_contents] = ""
  end
  def screen_code
      @screen_code
  end
  def show_data
      @show_data
  end
  def command_r
      @command_r
  end
 def code_to_name
      chgname = params[:chgname]
      chgval  = params[:chgval]
     if chgname then
       getrecord = plsql.__send__(chgname.split(/_/)[0]+"s").first("where code = '#{chgval}' order by expiredate")
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
      get_screen_code
      @command_r = {}
      command_r[:sio_totalcount] = 0
      rdata =  []
      pdfscript = plsql.reports.first("where Code = '#{params[:pdflist]}' and  Expiredate > sysdate")
      unless  pdfscript.nil? then
         reports_id = pdfscript[:id]
         strwhere = sub_pdfwhere show_data[:screen_viewname] ,reports_id
         set_fields_from_allfields ###画面の内容をcommand_rへ
         command_r[:sio_strsql] = " (select * from #{show_data[:screen_viewname]} " + strwhere + " ) a"
         ##p "strwhere #{strwhere}"
         rdata = subpaging(command_r)     ## subpaging  
         plsql.commit
      end
     ##respond_with @tbldata.to_jqgrid_json(show_data[:allfields] ,params[:page], params[:rows],command_r[:sio_totalcount]) 
       respond_with rdata[0].to_jqgrid_xml(show_data[:allfields] ,params[:page], params[:rows],rdata[1]) 
  end  #select _opt

##  def xparams
##      @xparams
##  end
 ####### ajaxでは xls,xlsxはdownloadできない?????
 def blk_print
     render :nothing=> true
 end
end ## ScreenController
