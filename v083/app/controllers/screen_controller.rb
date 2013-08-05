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
     get_screen_tcode 
     render :text =>"Create ScreenFields #{screen_tcode} by crt_r_view_sql.rb" and  return if show_data.nil?
     @disp_screenname_name = sub_blkgetpobj(screen_tcode,"screen")
     view_item_set
     ### set_detail screen_tcode => "",@div_id => "" ,sqlstr =>""  ###親の画面だからnst なし
    ##fprnt " class #{self} : LINE #{__LINE__}  show_data : #{  show_data }"
    ##fprnt " class #{self} : LINE #{__LINE__}  index  @gridcolumns : #{ @gridcolumns}"
    ##debugger ## 詳細項目の確認
   end  ##index
  def disp   ##  jqgrid返り
   ##debugger ## 詳細項目セット
   params[:page] ||= 1 
   params[:rows] ||= 50
   get_screen_tcode
    ##fprnt "class #{self} : LINE #{__LINE__} screen_tcode #{screen_tcode}"
   set_fields_from_allfields ###画面の内容をcommand_rへ
   command_r[:sio_strsql] = get_strsql  ##親画面情報引継
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
  def nst  ###子画面　link   xxxS_IDでリンクする時と　ctlXXXでリンクする時で分かれる。
     rcd_id  =  params[:id]  ### 親画面テーブル内の子画面へのkeyとなるid
     pare_tcode =  params[:nst_tbl_val].split("_div_")[0]   ### 親のviewのtcode
     chil_tcode =   params[:nst_tbl_val].split("_div_")[1]   ### 子のviewのtcode
     @disp_screenname_name =  sub_blkgetpobj(params[:nst_tbl_val].split("_div_")[2],"screen")   ### 子の画面
     #####cnt_detail =  params[:nst_tbl_val].split(";")[3]   ### 子の画面位置
     get_screen_tcode
     ##########
     @jqgrid_id = "#{pare_tcode}_div_#{chil_tcode}"   ### 親テーブルと子テーブルを_div_で分けた。
     @scriptopt = {}
     @options ={}
     @options[:div_repl_id] = "#{pare_tcode}_div_#{chil_tcode}"  ### 親画面内の子画面表示のための　div のid
     @options[:autowidth] = "true"  
     chil_view = plsql.screens.first("where tcode = '#{chil_tcode}' and Expiredate > sysdate order by expiredate ")[:tcode_view]  ## set @gridcolumns 
     pare_view = plsql.screens.first("where tcode = '#{pare_tcode}' and Expiredate > sysdate order by expiredate ")[:tcode_view]  ## set @gridcolumns 
     view_item_set    ###画面項目セット
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
      ##render :nst
     plsql.commit
     render :nst,:layout =>false
 end   ### nst

#####  親の項目をテーブルの上に表示
 def set_pare_contents pare_view,rcd_id
     @scriptopt[:pare_contents] = ""
     pare_data = plsql.__send__(pare_view).first("where id = #{rcd_id}")
      @scriptopt[:pare_contents] = ""
     pare_data.each do |key,value|
	skey = key.to_s
       if (skey =~ /code/ or skey =~ /name/) and skey.split("_")[0] == pare_view.split("_")[1].chop  then
          @scriptopt[:pare_contents] << " <span> #{key.to_s} :  #{value}    ; </span> "   if value
       end
     end
 ##fprnt " class #{self} : LINE #{__LINE__}  nst @scriptopt[:pare_contents]  : #{@scriptopt[:pare_contents]}"
 end    ### def set_pare_contents pare_view,rcd_id
 ### formで矢印がきかない
 def add_upd_del    ##  add update delete
     params[:oper] = "add" if  params[:copy] == "yes"   ### copy and add
     get_screen_tcode
     set_fields_from_allfields
     command_r[:sio_viewname]  = show_data[:screen_tcode_view] 
     person_id_upd =  (command_r[:sio_viewname].split("_")[1].chop + "_person_id_upd").to_sym  unless command_r[:sio_viewname] == "r_persons"
     person_id_upd = :person_id_upd if command_r[:sio_viewname] == "r_persons"
     command_r[person_id_upd] = plsql.persons.first(:email =>current_user[:email])[:id]  ||= 0   ###########   LOGIN USER  
     case params[:oper] 
       when "add"
          rcd_id_cache_key = "RCD_ID" + current_user[:id].to_s +  params[:q]  ### :q -->@jqgrid_id
          hash_rcd = Rails.cache.read(rcd_id_cache_key)  
          ##tmp_isnr =  sub_set_fields_from_allfields
          ##fprnt " class #{self} : LINE #{__LINE__}  hash_rcd  #{hash_rcd}"  unless hash_rcd.nil?
          ##fprnt " class #{self} : LINE #{__LINE__} hash_rcd  nil nil"  if hash_rcd.nil?
          command_r[hash_rcd[:rcd_id_key]] =  hash_rcd[:rcd_id_val] unless hash_rcd.nil?
          command_r[:sio_classname] = "plsql_blk_insert"
          sub_insert_sio_c    command_r  ###更新要求
          ## command_r[:id_tbl] = nil
       when "del"
	  ##sub_set_fields_from_allfields ###画面の内容をcommand_rへ
	  command_r[:sio_classname] = "plsql_blk_delete"
          sub_insert_sio_c command_r
       when "edit"
	 ###debugger
	 ##sub_set_fields_from_allfields ###画面の内容をcommand_rへ
         command_r[:sio_classname] = "plsql_blk_update"
         sub_insert_sio_c     command_r  ###p "tblfields[:id_tbl] : #{tblfields[:id_tbl]}"
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
      rcd_id_cache_key = "RCD_ID" + current_user[:id].to_s + @jqgrid_id 
      if Rails.cache.exist?(rcd_id_cache_key)   then  ### 
         strsql =  Rails.cache.read(rcd_id_cache_key)[:strsql]   ### 親からのidで子を表示
        else
         tmp_str = plsql.screens.first("where tcode = '#{screen_tcode}' and Expiredate > sysdate order by expiredate ")
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
     #get_screen_tcode 
     @command_r = {}
     command_r
     if show_data.empty? 
        render :text => "Create ScreenFields #{screen_tcode} by (crt_r_view_sql.rb  #{screen_tcode.split(/_/)[1]}) and restart rails "  and return
     end
     eval( show_data[:evalstr] ) unless   show_data[:evalstr]  == ""   ###既定値等セット　画面からの入力優先
     show_data[:allfields].each do |j|
	## nilは params[j] にセットされない。
        command_r[j] = params[j]  if params[j]  ##unless j.to_s  == "id"  ## sioのidとｖｉｅｗのｉｄが同一になってしまう
        ##command_r[:id_tbl] = params[j].to_i if j.to_s == "id"          
     end ##
    ##fprnt " class #{self} : LINE #{__LINE__}  show_data : #{  show_data }"
    ##char_to_number_data      ##parmsの文字型を数字・日付に
  end  
  def get_screen_tcode 
      ###debugger ## 画面の項目
      case 
          when params[:action]  == "index"   then 
               @jqgrid_id  = params[:id]   ## listからの初期画面の時 とcodeを求める時
	       @screen_tcode = params[:id]  if params[:id].split('_div_')[1].nil?    ##pop up無
	       @screen_tcode = params[:id].split("_div_")[1] if params[:id].split('_div_')[1] 
          when params[:q]   then ##disp
               @jqgrid_id   =  params[:q]
	       @screen_tcode = params[:q]  if params[:q].split('_div_')[1].nil?    ##子画面無
               @screen_tcode = params[:q].split('_div_')[1]  if params[:q].split('_div_')[1]    ##子画面
          when params[:nst_tbl_val] then
               @jqgrid_id   =  params[:nst_tbl_val]
               @screen_tcode =  params[:nst_tbl_val].split("_div_")[1]  ###chil_scree_tcode
	end
     screen_tcode
     @show_data = get_show_data(screen_tcode, @jqgrid_id )
     show_data
     @scriptopt = {}
     @scriptopt[:pare_contents] = ""
  end
  def screen_tcode
      @screen_tcode
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
      get_screen_tcode
      @command_r ={}
      command_r
      command_r[:sio_totalcount] = 0
      rdata =  []
      pdfscript = plsql.reports.first("where tCode = '#{params[:pdflist]}' and  Expiredate > sysdate")
      unless  pdfscript.nil? then
         reports_id = pdfscript[:id]
         strwhere = sub_pdfwhere(show_data[:screen_tcode_view] ,reports_id,command_r)
         set_fields_from_allfields ###画面の内容をcommand_rへ
         command_r[:sio_strsql] = " (select * from #{show_data[:screen_tcode_view]} " + strwhere + " ) a"
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
 def  view_item_set   
      ##debugger ## viewへの詳細項セット
      ### buttonの時は画面が変わるので
      ### 保持しているデータは削除
      # @session_data[:person_id] = plsql.persons.first(:email =>current_user[:email])[:id]   ###########   LOGIN USER  
      @options[:grp_search_form] = true if  screen_tcode =~ /^H\d_/
      @extbutton  = show_data[:extbutton] 
      @extdiv_id  = show_data[:extdiv_id]  
      ###@scriptopt[:scriptopt]  = show_data[:scriptopt] 
      @scriptopt[:aftershowform_add]  = show_data[:aftershowform_add] 
      @scriptopt[:aftershowform_edit]  = show_data[:aftershowform_edit] 
      @scriptopt[:pdf] = show_data[:pdf]   ###帳票名セット
      @gridcolumns =  show_data[:gridcolumns] 
      ##testx = "pdflist=custorder&initprnt=1"
      @scriptopt[:pdfdata] = %Q|function nWin() {var pdata = jQuery("##{@jqgrid_id}").getPostData(); 
      var strparam;jQuery.each(pdata, function(key, value) {strparam = strparam + key + "=" + value + "&" }); strparam = strparam + "q=#{@jqgrid_id}";
      var url = "/pdf/index?"+strparam;window.open(url);};jQuery(function() {jQuery(".#{@jqgrid_id}_filterbuttonclass").click(nWin);});|
      ##jQuery(".#{id}_filterbuttonclass").click(function(){var pdata; pdata = jQuery("##{id}").getPostData(); 
     ### @scriptopt[:test] = 'window.open("/pdf/index");jQuery.get("/pdf/index",pdata);|

  end  ## user_scree
   def set_aftershowform screen_tcode_view,show_data
      ###外部テーブルのリンクに関係ない項目は　enable == true and require == false
      ## 変更項目の修正不可は固定にはしないで、関数で対応
       	javascript_edit = %Q@function(formid) { 
                                jQuery("input",formid).change(function(){ 
      		                        var chgname = jQuery(this).attr("name");
     					var chgval  = jQuery(this).val();
      					if(chgname.match(/_code/i)){ if(chgname.match(/^#{screen_tcode_view.split(/_/,2)[1].chop}/i)){}
      					  else{ var newname = "#"+chgname.replace("_code","_name");
     					        jQuery.getJSON("/screen/code_to_name",{"chgname":chgname,"chgval":chgval},function(data){
      					  jQuery(newname,formid).val(data.name);
      						})
      					      }
      					}
      				});
	                        jQuery("input",formid).click(function(){ 
      		                        var chgname = jQuery(this).attr("name");
     					var viewval  = chgname.split("_");
					var newwin;
      					if(chgname.match(/_code/i)){ if(chgname.match(/^#{screen_tcode_view.split(/_/,2)[1].chop}/i)){}
      					  else{ url = "/screen/index?id="  + chgname + "_div_r_" + viewval[0] + "s";
					       if(!newwin||newwin.closed){
					           newwin = window.open(url,"blkpopup","width=800,height=300,menubar=no,toolbar=no,status=no,menubar=no,scrollbars=yes");}
						   else{
                                                       newwin.focus();}

					  }
      					}
      				})@
	##tmp = plsql.pobjects.all("where expiredate > sysdate and objecttype = '1' and code like '#{screen_tcode.split("_")[1].chop}%'  ")
	strtmp = ""
        keysfield = []
	##tmp.each do |i|
            ##javascript_edit << %Q|;jQuery("##{i[:code]}",formid).attr('disabled',true)|
	    ##javascript_add  << %Q|;jQuery("##{i[:code]}",formid).removeAttr('disabled')|
	    ##keysfield << i[:code]
	##end  tmp_columns
        show_data[:gridcolumns].each do |tmp_columns|
            ###debugger
            if tmp_columns[:field].split("_")[0] != screen_tcode_view.split("_")[1].chop  and tmp_columns[:editrules][:required] == false and  	 tmp_columns[:editable] == true   then 
               javascript_edit << %Q|;jQuery("##{tmp_columns[:field]}",formid).attr("disabled",true)|
	       ##javascript_add  << %Q|;jQuery("##{i.to_s}",formid).removeAttr("disabled")|
	    end
        end
	##javascript_add << "}" 
	javascript_edit << "}"  ## if javascript_edit !~ /}$/    ####addに}をセットしたらeditまでセットされた。
	{:aftershowform_add => javascript_edit,:aftershowform_edit => javascript_edit}
 end
end ## ScreenController
