require '2dc_jqgrid/3dc_jqgrid'
module Jqgrid
include  JqgridFilter

   def jqgrid_stylesheets
      css  = stylesheet_link_tag("jqgrid/themes/default/jquery-ui-1.10.3.custom.css") + "\n"
      css << stylesheet_link_tag('jqgrid/ui.jqgrid.css') + "\n"
      css << stylesheet_link_tag('gantt/platform.css') + "\n"
   end
   def gantt_stylesheets
      css1 = stylesheet_link_tag('gantt/libs/dateField/jquery.dateField.css') + "\n"
      css1 << stylesheet_link_tag('gantt/gantt.css') + "\n"
      css1 << stylesheet_link_tag('gantt/gantt_compact.css') + "\n"
      css1 << stylesheet_link_tag('gantt/teamworkFont.css') + "\n"
   end
   def jqgrid_javascripts
      locale = I18n.locale rescue :en
      js = javascript_include_tag('jquery-1.7.2.min.js') + "\n"
      js << javascript_include_tag('jquery-ui.min1.8.js') + "\n"
      js << javascript_include_tag("jqgrid/i18n/grid.locale-#{locale}.js") + "\n"
      js << javascript_include_tag('jrails.js') + "\n"
      js << javascript_include_tag('rails.js') + "\n"
      js << javascript_include_tag('jqgrid/jquery.jqGrid.min.js') + "\n"
      js << javascript_include_tag('jqgrid/plugins/grid.addons.js') + "\n"    ###when upgrade v3.8 to v4.5 ,add this sentenc"
      js << javascript_include_tag('jqgrid/plugins/grid.postext.js') + "\n"    ###when upgrade v3.8 to v4.5 ,add this sentene
   end
   def gantt_javascripts
      js1 = javascript_include_tag('gantt/libs/jquery.livequery.min.js') + "\n"  
      js1 << javascript_include_tag('gantt/libs/jquery.timers.js') + "\n"  
      js1 << javascript_include_tag('gantt/libs/platform.js') + "\n"  
      js1 << javascript_include_tag('gantt/libs/date.js') + "\n"  
      js1 << javascript_include_tag('gantt/libs/i18nJs.js') + "\n"  
      js1 << javascript_include_tag('gantt/libs/dateField/jquery.dateField.js') + "\n"  
      js1 << javascript_include_tag('gantt/libs/JST/jquery.JST.js') + "\n"  
      js1 << javascript_include_tag('gantt/ganttUtilities.js') + "\n"  
      js1 << javascript_include_tag('gantt/ganttTask.js') + "\n"  
      js1 << javascript_include_tag('gantt/ganttDrawer.js') + "\n"  
      js1 << javascript_include_tag('gantt/ganttGridEditor.js') + "\n"  
      js1 << javascript_include_tag('gantt/ganttMaster.js') + "\n"  
   end
   def jqgrid( options = {},authenticity_token,ss_id)
		logger.debug " @screen_code  strart #{@scren_code} #{Time.now}" 
		strsql = "select * from r_screens where pobject_code_scr = '#{@screen_code}' and SCREEN_EXPIREDATE >current_date order by  screen_expiredate "  
        @r_screens = ActiveRecord::Base.connection.select_one(strsql)
      ## id ：screen_code又は親画面コード+(_div_)+子画面コード
      # Default options
          options = 
        { 
          :selection_handler   => 'handleSelection',
          :autowidth           => 'false',
          :autoheight           => 'false',
          :shrinkToFit          => 'false',
          :div_repl_id         => '',          ###別画面にリンクする時
          :text_indent         =>   '2',       ### footerの横位置
          :rownumbers          => 'false'                    
        }.merge(options)
      ss_id = ss_id ||""
      ##edit form_posion_size 
      #####form_ps = "top:100,left:50,width:1200,height:600,dataheight:500" ←
      init_jq = ''
      nst_div = ''
     ##if id =~ /^gantt/ then
     ##    nst_div  << ' ge = new GanttMaster(); ge.init(jQuery("#workSpace"));
     ##       var workSpace = jQuery("#workSpace"); workSpace.css({width:jQuery(window).width() - 10,heigt:jQuery(window).height() - 250}); 
     ##       function uploadOnServer(){var prj = ge.saveProject();prj.authenticity_token=p_authenticity_token;jQuery.post("/screen/uploadgantt",prj,function(rd){alert(rd.error)},"json");}'
     ## end
		if @scren_code =~ /^gantt/ 
			nst_div << %Q|ge = new GanttMaster(); function uploadOnServer(){var prj = ge.saveProject();prj.authenticity_token=p_authenticity_token;
					jQuery.post("/gantt/uploadgantt",prj,function(rd){if(rd.tasks){ge.loadProject(rd);jQuery("[name='appear_by_insert']").show();}
																	else{ jQuery("[name='appear_by_insert']").hide();var gsr = jQuery("##{@screen_code}").getGridParam("selrow");
																		if(gsr){jQuery.getJSON("/gantt/index",{id:gsr,screen_code:"#{@screen_code}",authenticity_token:p_authenticity_token},
																		function(ganttdata){ge.loadProject( ganttdata);})}}},"json");}|
		end
         nst_div <<  %Q|function getUrlVars()
                            {
                             var vars = [], hash;
                             var hashes = window.location.href.slice(window.location.href.indexOf("?") + 1).split("&");
                             for(var i = 0; i < hashes.length; i++)
                             {
                               hash = hashes[i].split("=");
                               vars.push(hash[0]);
                               vars[hash[0]] = hash[1];
                             }
                            return vars;
                            } |
      replace_end = ""
      unless options[:div_repl_id] == ''
             init_jq= %Q|jQuery("#div_#{options[:div_repl_id]}").replaceWith('<div id="div_#{options[:div_repl_id]}">|
             replace_end = "'); "
      end
     show_cache_key =  "show" + @screen_code +  sub_blkget_grpcode
     @show_data = Rails.cache.read(show_cache_key)
	 @show_data = set_detail(@screen_code ) if @show_data.nil?  ## set gridcolumns
     logger.debug "line #{__LINE__} create screen_code  '#{@screen_code}'" if @show_data.nil? 
     @gridcolumns = @show_data[:gridcolumns]
     id_cache_key =  "id_javascript" + @screen_code +  sub_blkget_grpcode
     id_data_javascript = Rails.cache.read(id_cache_key)
	 if id_data_javascript
        id_cache_key =  "id_html" + @screen_code +  sub_blkget_grpcode
	    id_data_html = Rails.cache.read(id_cache_key)
	   else	
        id_data_javascript,id_data_html = create_screen_field(options)
     end		
     screen = %Q% #{init_jq}  <script type="text/javascript"> var id = "#{@jqgrid_id}"; var p_authenticity_token = "#{authenticity_token}";var inLineFlg;var lno = 0;var addline;var p_ss_id = "#{ss_id}";%
       screen <<   nst_div
       screen << id_data_javascript
       screen << " });</script>" 
       screen << " <p> #{options[:pare_contents]}</p>   "
       screen << id_data_html
       screen <<  replace_end
       screen.gsub!(/\s+/," ")    if init_jq  =~ /replaceWith/  ###repacewithが \nだと変換してくれない。\s+ \nの変換も含む
	   	logger.debug " @screen_code  end #{@scren_code} #{Time.now}"
     return screen 
    end  ## 
   private
   def gen_columns
      # Generate columns data
      col_names = "[" # Labels
      col_model = "[" # Options
      cellnames = "var cellNames = ["
      @gridcolumns.each do |c|
        col_names << %Q|"#{c[:label]}",|
	    col_model << %Q|{name:"#{c[:field]}", index:"#{c[:field]}"#{get_attributes(c)} },|
	    cellnames << %Q|"#{c[:field]}",|
      end
      col_names.chop! << "]"
      col_model.chop! << "]"
      cellnames.chop! << "];"
      [col_names, col_model,cellnames]
    end
    # Generate a list of attributes for related column (align:'right', sortable:true, resizable:false, ...)
    def get_attributes(column)
      options = ","
      column.except(:field, :label,:formop).each do |couple|
        if couple[0] == :editoptions
          options << %Q%editoptions:#{get_sub_options(couple[1])},%
        elsif couple[0] == :formoptions
          options << "formoptions:#{get_sub_options(couple[1])},"
        elsif couple[0] == :searchoptions
          options << %Q|stype:"select",searchoptions:#{get_sub_searchoptions(couple[1])},|  ###日付の時 stype:"text"????
        elsif couple[0] == :editrules
          options << "editrules:#{get_sub_options(couple[1])},"  if @screen_code.split("_")[1].chop == column[:field].split("_")[0] or couple[1] =~ /required:true/
        elsif couple[0] == :formatter
          options << "formatter:" + if couple[1] =~ /Fmatter$/ then couple[1] else %Q%"#{couple[1]}"% end + ","
        else
          if couple[1].class == String
            options << %Q%#{couple[0]}:"#{couple[1]}",%
          else
            options << %Q%#{couple[0]}:#{couple[1]},%
          end
        end
      end
      options.chop!
    end
      # Generate options for editable fields (value, data, width, maxvalue, cols, rows, ...)
    def get_sub_options(editoptions)
        options = "{"
        editoptions.each do |couple|
        if couple[0] == :value # :value => [[],[1, "Rails"], [2, "Ruby"], [3, "jQuery"]]
            options << %Q/value:"/
            couple[1].each_with_index do |v,i|    ###  修正　入力内容をそのまま
                options << %Q%#{v[0]}:#{v[1]};%  ## if i >0 
            end
            options.chop! << %Q/",/
            elsif couple[0] == :data # :data => [Category.all, :id, :title])
                options << %Q/value:"/
                couple[1].first.each do |obj|
                    options << "%s:%s;" % [obj.send(couple[1].second), obj.send(couple[1].third)]
                end
                options.chop! << %Q/",/
                elsif   couple[0] == :date
                    options << "custom:true, custom_func:isValidDate,"
                  else # :size => 30, :rows => 5, :maxlength => 20, ...
                    if couple[1].instance_of?(Fixnum) || couple[1] == 'true' || couple[1] == 'false' || couple[1] == true || couple[1] == false || couple[1] =~ /function/
                        options << %Q/#{couple[0]}:#{couple[1]},/
                       else
                        options << %Q/#{couple[0]}:"#{couple[1]}",/          
                    end
                end
            end
      options.chop! << "}"
    end
    def get_sub_searchoptions(editoptions)
        options = "{"
        editoptions.each do |couple|
            if couple[0] == :value # :value => [[],[1, "Rails"], [2, "Ruby"], [3, "jQuery"]]
                options << %Q/value:"/
                couple[1].each do |v|    ###  修正　入力内容をそのまま
                    options << "#{v[0]}:#{v[1]};"
                end
                options.chop! << %Q/",/
              elsif couple[0] == :data # :data => [Category.all, :id, :title])
                options << %Q/value:"/
                couple[1].first.each do |obj|
                options << "%s:%s;" % [obj.send(couple[1].second), obj.send(couple[1].third)]
                end
                options.chop! << %Q/",/
              else # :size => 30, :rows => 5, :maxlength => 20, ...
                if couple[1].instance_of?(Fixnum) || couple[1] == 'true' || couple[1] == 'false' || couple[1] == true || couple[1] == false || couple[1] =~ /function/
                    options << %Q/#{couple[0]}:#{couple[1]},/
                   else
                    options << %Q/#{couple[0]}:"#{couple[1]}",/          
                end
            end
        end
        options.chop! << "}"
    end 
     ################
    def set_extbutton pare_screen_code     ### 子画面用のラジオボ タンセット
        ### 同じボタンで有効日が>sysdateのデータが複数あると複数ボタンがでる
        rad_screen = ActiveRecord::Base.connection.select_all("select pobject_code_scr,pobject_code_scr_ch from r_chilscreens where chilscreen_Expiredate > sysdate 
                                            and pobject_code_scr = '#{pare_screen_code}' group by  chilscreen_grp,pobject_code_scr,pobject_code_scr_ch")
            t_extbutton = ""
            t_extdiv_id = ""
            rad_screen.each_with_index do |i,k|     ###child tbl name sym
               ### view name set
                    t_extbutton << %Q|<input type="radio" id="radio#{pare_screen_code}#{k.to_s}"  name="nst_radio#{pare_screen_code}"|
                    t_extbutton << %Q| value="#{i["pobject_code_scr"]}_div_#{i["pobject_code_scr_ch"]}_div_| ### 親のview
                    t_extbutton << %Q|#{i["pobject_code_scr_ch"]}_div_1"/>|    #**
                    t_extbutton << %Q| <label for="radio#{pare_screen_code}#{k.to_s}">  #{sub_blkgetpobj(i["pobject_code_scr_ch"],"screen")} </label> |   ##"screen"画面
                    t_extdiv_id << %Q|<div id="div_#{i["pobject_code_scr"]}_div_#{i["pobject_code_scr_ch"]}"> </div> |   #**
            end   ### rad_screen.each
	    return  t_extbutton,t_extdiv_id
    end    ## set_extbutton pare_screen  
	def get_return_price_amt_val hprice
		%Q% jQuery("##{hprice[:price]}",formid).val(data.price);
			jQuery("##{hprice[:amt]}",formid).val(data.amt);
			jQuery("##{hprice[:contract_price]}",formid).val(data.contract_price);
			jQuery("##{hprice[:contract_price]}",formid).attr("disabled",true);
			if(data.pricef){jQuery("##{hprice[:price]}",formid).attr("disabled",true);} 
			if(data.amtf){jQuery("##{hprice[:amt]}",formid).attr("disabled",true);}%
	end
    def get_return_name_val scrfield,paragraph  ###paragrapf 検索key = pscreen_code + dlem
		tmp_val = ""
		pscreen_code,delm = paragraph.split(":")
		delm  ||= ""
		mktblname = if scrfield.split("_")[0] =~ /^mk/ then (scrfield.split("_")[0] + "_") else "" end
		begin
	        secgridc = get_show_data(pscreen_code)[:allfields]
		rescue  ###検索項目に指定しているviewがない。  ###画面でチェックすること　未実施
		   	raise  "shoud be seach_screen_code invalid ;screen_code is:#{pscreen_code} "   
		end
		@gridcolumns.each do |tcolm|  ###検索keyが変化したときはサーバーへ 
			case scrfield
				when /_code/
					if  secgridc.index(tcolm[:field].sub(delm,"").sub(mktblname,"").to_sym)  and  tcolm[:editable] == true
						tmp_val  << "if(data.#{tcolm[:field]}){"   
						tmp_val  << %Q%jQuery("##{tcolm[:field]}",formid).val(data.#{tcolm[:field]});%
						tmp_val  << "}"   
					end
				when /_sno_|_cno_/
					tblchop = scrfield.split("_")[0]
					notblchop = pscreen_code.split("_")[1].chop
					### snoのテーブルの内容と　残数　qty_bal
					if (secgridc.index(tcolm[:field].sub(tblchop,notblchop).to_sym) or tcolm[:field] =~ /_bal/) and tcolm[:editable] == true 
						tmp_val  << "if(data.#{tcolm[:field]}){"   
						tmp_val  << %Q%jQuery("##{tcolm[:field]}",formid).val(data.#{tcolm[:field]});%
						tmp_val  << "}"   
					end
			end
		end  ### secgridc.each do |tcolm| 
		fmfield = pscreen_code.split("_")[1].chop+"_id"
		tofield = @screen_code.split("_")[1].chop+"_"+fmfield
		if  delm 
            fmfield += delm
            tofield += delm
		end 
		tmp_val  << %Q% jQuery("##{tofield}",formid).val(data.#{fmfield});%
		return tmp_val
    end
    def set_aftershowform oper
		###外部テーブルのリンクに関係ない項目は　enable == true and require == false
		## 変更項目の修正不可は固定にはしないで、関数で対応
		## javascript_edit = %Q%(function($) {
		##                      jQuery.fn.pinCodeToName = function(formid) { 
		javascript_edit =  "function(formid) {"
		tmp_code_to_name = ""
		require_fields = ""  ###javascriptの中に'は使用できない。
		strsenddata = %Q% "jqgrid_id":"#{@r_screens["pobject_code_scr"]}","chgname":p_chgname,"code_to_name_oper":"#{oper}",%
		strkeydata = %Q% "jqgrid_id":"#{@r_screens["pobject_code_scr"]}","fieldname":keyname%
		hprice = {}
		@gridcolumns.each do |tcolm|
            if ( tcolm[:editable] == true and tcolm[:formop] == 2 )   
               javascript_edit << %Q% jQuery("##{tcolm[:field]}",formid).attr("disabled",true);%
                require_fields << %Q% var p_#{tcolm[:field]} =  jQuery("##{tcolm[:field]}",formid).val();%
                strsenddata << %Q% "#{tcolm[:field]}":p_#{tcolm[:field]},%
	        end
            if (tcolm[:field].split("_")[0] != @screen_code.split("_")[1].chop and tcolm[:editrules][:required]  == true) or
				  (tcolm[:field] =~ /_id|_sno|_cno|_ano|_prjno|_gno/ and  tcolm[:field].split("_")[0] == @screen_code.split("_")[1].chop) or
				  ( tcolm[:editable] == true and tcolm[:formop] == 1 )
				  ###################################
				  ### _id は自身のテーブル以外のidは必須以外セットしない。
				  ################改良項目
                require_fields << %Q% var p_#{tcolm[:field]} =  jQuery("##{tcolm[:field]}",formid).val();%
                strsenddata << %Q% "#{tcolm[:field]}":p_#{tcolm[:field]},%
				hprice[:itm] = true if tcolm[:field]  == "itm_code"
				hprice[:tblname] = tcolm[:field] if tcolm[:field]  == "loca_code_cust" or  tcolm[:field]  == "loca_code_dealer"
	        end
            if tcolm[:field].split("_")[0] == @screen_code.split("_")[1].chop and tcolm[:editrules][:required]  == true  then 
                if  oper != "add" and  oper != "copyandadd"  
					javascript_edit << ""  ### 中止　外部keyでチェックする。jQuery("##{tcolm[:field]}",formid).attr("disabled",true); 
					require_fields << %Q% var p_#{tcolm[:field]} =  jQuery("##{tcolm[:field]}",formid).val();%
                else  
					javascript_edit << %Q% jQuery("##{tcolm[:field]}",formid).attr("disabled",false);%
					require_fields << %Q% var p_#{tcolm[:field]} =  jQuery("##{tcolm[:field]}",formid).val();%
				end
				strsenddata << %Q% "#{tcolm[:field]}":p_#{tcolm[:field]},%
				hprice[:qty] = tcolm[:field] if tcolm[:field] =~ /_qty/
				hprice[:duedate] = tcolm[:field] if tcolm[:field]  == "#{@screen_code.split("_")[1].chop}_duedate"  ##2:納期ベース
				hprice[:isudate] = tcolm[:field] if tcolm[:field]  == "#{@screen_code.split("_")[1].chop}_isudate"	##1:発注日ベース　			
				hprice[:puract_rcptdate] = tcolm[:field] if tcolm[:field]  == "puract_rcptdate"  ####3:受入日ベース 予定の時は納期を使用する。	8:受入日までに決定する単価　				
				hprice[:shpact_depdate] = tcolm[:field] if tcolm[:field]  == "shpsch_depdate"    ### 4:出荷日ベース　							
				hprice[:shpsch_depdate] = tcolm[:field] if tcolm[:field]  =~ /_depdate/  ####			
				hprice[:acpact_acpdate] = tcolm[:field] if tcolm[:field]  == "acpact_acpdate"    ### 5:検収ベース　							
				hprice[:acpsch_acpdate] = tcolm[:field] if tcolm[:field]  =~ /_acpdate/  #### 5:検収ベース 予定の時
	        end
			hprice[:price] = tcolm[:field] if tcolm[:field]  == "#{@screen_code.split("_")[1].chop}_price"
			hprice[:amt] = tcolm[:field] if tcolm[:field]  == "#{@screen_code.split("_")[1].chop}_amt"
			hprice[:contract_price] = tcolm[:field] if tcolm[:field]  == "#{@screen_code.split("_")[1].chop}_contract_price"
			###7:出荷日までに決定する単価　9:単価決定=検収 submit後チェック
		end
		strprice = ""
		if  hprice[:itm] and hprice[:tblname] and hprice.size >= 3 ##hprice.size >= 3::気休め
			strprice << %Q% if((p_chgname=="itm_code"||p_chgname=="#{hprice[:qty]}"||p_chgname=="#{hprice[:price]}"||
								p_chgname=="#{hprice[:duedate]}"||
								p_chgname=="#{hprice[:isudate]}"||p_chgname=="puract_rcpdare"||
								p_chgname=="shpact_depdate"||p_chgname=="acpact_acpdate"||
								p_chgname=="acpsch_acpdate")
								&&btn == "#{oper}"){jQuery.getJSON("/screen/set_price_and_amt",
                                          {#{strsenddata.chop}},function(data){
											#{get_return_price_amt_val(hprice)}
																				})}%
		end
		javascript_edit << %Q% jQuery("#sData").show();% 
		###既定値等セット  ### jQuery("##{tcolm[:field]}",formid).val()にセットすべきもの
        strsql = "select screenfield_paragraph from r_screenfields where pobject_code_scr = '#{@screen_code}'  
			and screenfield_paragraph  is not null AND screenfield_expiredate > sysdate group by screenfield_paragraph"
		recs = ActiveRecord::Base.connection.select_all(strsql)
		recs.each do |rec|
			strsql = " select * from r_screenfields where pobject_code_scr = '#{@screen_code}'  and screenfield_paragraph  = '#{rec["screenfield_paragraph"]}' AND screenfield_expiredate > sysdate "
			seartbls = ActiveRecord::Base.connection.select_all(strsql)
			seartbls.each do |srtcolm|
				tmp_code_to_name << %Q% if(p_chgname=="#{srtcolm["pobject_code_sfd"]}"&&btn == "#{oper}"){jQuery.getJSON("/screen/code_to_name",
                                          {#{strsenddata.chop}},function(data){
											#{get_return_name_val(srtcolm["pobject_code_sfd"],srtcolm["screenfield_paragraph"])}
																				})}%
			end
		end
		tmp_code_to_name << ";"
		javascript_edit << %Q%
                           jQuery("input",formid).change(function(){ 
                                var p_chgname = jQuery(this).attr("name");
      	                        #{require_fields} 
      	                        #{tmp_code_to_name}
								#{strprice}
								                                    });
	                            jQuery("input",formid).dblclick(function(e){ 
									var keyname = jQuery(this).attr("name");
									var viewval;
									var newwin;
      					            if(keyname.match(/_code/i)){jQuery.getJSON("/screen/get_url_from_code",
										{#{strkeydata}},function(data){viewval=data.scrname;
																		if(!newwin||newwin.closed){
																		url = "/screen/index?jqgrid_id=" + viewval + "&grid_key="+keyname + "&grid_tbl=#{@screen_code.split("_",2)[1].chop}";
																		newwin = window.open(url,"blkpopup","width=800,height=350,menubar=no,toolbar=no,status=no,menubar=no,scrollbars=yes");}
																		else{
																		newwin.focus();}
																		}
								)}})%
		##
		javascript_edit << "}"
	end
	def set_onInitializeForm addorcopy
		require_fields =  "function(formid) {"
		@gridcolumns.each do |tcolm|
	        if (tcolm[:field].split("_")[0] == @screen_code.split("_")[1] and tcolm[:editable] == true ) or  (tcolm[:required] == true )
               require_fields << %Q% jQuery("##{tcolm[:field]}",formid).removeAttr("disabled");%
			end
			if addorcopy == "add"
				if respond_to?("proc_view_field_#{tcolm[:field]}_dflt_screen")
					##debugger ### tcolm[:field]でnil[]のエラーが発生した　上のifはokなのに　原因がわかるまで残しておく　2014/12/20
					dflt_val =  __send__("proc_view_field_#{tcolm[:field]}_dflt_screen",nil)
					require_fields << %Q% jQuery("##{tcolm[:field]}",formid).val("#{dflt_val}");% 
				 else 
					if respond_to?("proc_field_#{tcolm[:field].split('_')[1]}_dflt_screen")   ###tbl_field_xxxx_dfflt テーブル登録時
						   dflt_val = __send__("proc_field_#{tcolm[:field].split('_')[1]}_dflt_screen",nil)
			               require_fields << %Q% jQuery("##{tcolm[:field]}",formid).val("#{dflt_val}");%
					end
			   end
			end
        end
        require_fields << %Q% jQuery("#sData").show();% 
        require_fields << "}"
        return  require_fields
    end
    def del_fields_protect oper
        require_fields =  "function(formid) {"
        ##@gridcolumns.each do |tcolm|
            ##require_fields << %Q% jQuery("##{tcolm[:field]}",formid).attr("disabled",true);%
            require_fields << %Q% jQuery("input",formid).attr("disabled",true);%
        ##end
        require_fields << %Q% jQuery("#sData").hide();% if oper == "view"
        require_fields << %Q% jQuery("#sData").show();% if oper != "view"
        require_fields << "}"
        return  require_fields
        ##javascript_edit <<   ";}})(jQuery);
    end
    def create_screen_field( options)
        col_names, col_model,cellnames = gen_columns
		if @r_screens.nil?
		   ###使用期限切れ  listで抽出されないはず
		   logger.debug "使用期限切れ  listで抽出されないはず"
		   return 
		end
        ##p " line #{__LINE__} logic err screen_code = #{@screen_code} " and return if screen_options.nil?
     
        # Enable selection link, button
         extbutton = "" 
         extbutton,extdiv_id =  set_extbutton(@screen_code)
        # The javascript function created by the user (options[:selection_handler]) will be called with the selected row id as a parameter


        ###
        ### replaceのため「''」は使用できない
        ###
        selection_link = ""
        if  options[:selection_handler].present? && extbutton!= "" then
            selection_link = %Q|
            jQuery("##{@jqgrid_id}_select_button").buttonset();
            jQuery("##{@jqgrid_id}_select_button :radio").click( function(e){ 
            var getid = jQuery("##{@jqgrid_id}").getGridParam("selrow");          
            var nst_tbl_val = jQuery("##{@jqgrid_id}_select_button :checked").val(); 
            if (getid) { 
                     var rowdata = jQuery("##{@jqgrid_id}").getRowData(getid);           
                     jQuery.post("/screen/nst",{id:getid,nst_tbl_val:nst_tbl_val,authenticity_token:p_authenticity_token,ss_id:p_ss_id,data:rowdata} );   
                } else { 
                 alert("Please select a row");
                       }
                return false; 
            });|
        end
        # Enable direct selection (when a row in the table is clicked)
        # The javascript function created by the user (options[:selection_handler]) will be called with the selected row id as a parameter
        return_code = ""
        return_code = %Q%onCellSelect:function(rowid, iCol,value,e){ 
               var pare_cellname  = getUrlVars()["grid_key"];			    
               var pare_tblchop  = getUrlVars()["grid_tbl"];
	        if(pare_cellname){
                var cellname = cellNames[iCol];
                    if(cellname.match(/_code/i)){ 
                        if(window.opener){
                                var nameofcode = pare_cellname.replace("_code","_name");
                                var idofcode = pare_cellname.replace("_code","_id");
                                var rowdata = jQuery("##{@jqgrid_id}").getRowData(rowid);
                                var taskId = getUrlVars()["taskid"];
                                if(taskId)
                                    {
                                    jQuery("tr[taskId="+taskId+"] input[name="+pare_cellname+"]", window.opener.document).val(value).change();
									jQuery(".ganttTaskEditor input[name="+pare_cellname+"]" ,window.opener.document).val(value).change();
			                        }
                                  else
                                    {
                                    jQuery("#"+ pare_cellname, window.opener.document).val(value); 
                                    var tnamefields = nameofcode.split("_");
                                    var namefield = tnamefields[0]+"_"+tnamefields[1];
                                    var tidfields = idofcode.split("_");
                                    var idfield = tidfields[0]+"_"+tidfields[1];
									var scr_idofcode = pare_tblchop + "_" + idofcode;
			                    jQuery("#"+ nameofcode ,window.opener.document).val(rowdata[namefield]);
			                    jQuery("#"+ idofcode ,window.opener.document).val(rowdata[idfield]);
			                    jQuery("#" + scr_idofcode ,window.opener.document).val(rowdata[idfield]);
                                    }
			                window.close();}}}},%
        custom_func = %Q%
                     function isValidDate(value, colname)
                     {                                       
                      var isValid = true;
                      var formatYmd = "yy/mm/dd";
                      var ymd = [];
                      if(value){ymd = value.split(" ");}else{isValid = false;}
                      if(ymd[0].length==10){}else{isValid = false;}
                      var hi  = [];
                      if(ymd[1]){hi = ymd[1].split(":");}                      
                     try{
                         if(ymd[0]){jQuery.datepicker.parseDate(formatYmd, ymd[0], null);}else{isValid = false;}
                        }
                      catch(error){
                                   isValid = false;
                                  }
                      if(hi[0]){if(hi[0]<"00"||hi[0]>="24"||hi[0].length!=2){isValid = false;}}
                      if(hi[1]){if(hi[1]<"00"||hi[1]>="60"||hi[1].length!=2){isValid = false;}}
                      if(isValid){return [isValid,""];}else{return [isValid,"Please enter valid date :" + colname];}  
                     }% 
        #### #{set_aftershowform(screen_code_view,gridcolumns)}  ###コメントにした
        ### jQuery("[taskId="+taskId+"][name="+pare_cellname+"]"   は　NG スペースが必要
        str_set_navbutton = set_navbutton
        ##btn 押されたボタン
        screen_javascript = %Q%  var lastsel; var btn; 
	        #{cellnames}
            jQuery(document).ready(function(){ 
            #{custom_func}         
            function textHeightFmatter(cellvalue, options, rowObject) { if(cellvalue){return "<div style=max-height:30px>"+cellvalue+"</div>";}}   
            function untextHeightFmatter(cellvalue, options){if(cellvalue){return cellvalue.replace("<div style=max-height:30px>","").replace("</div>","");}}  
                var mygrid = jQuery("##{@jqgrid_id}").jqGrid({
                url:"/screen/disp?jqgrid_id=#{@jqgrid_id}&ss_id="+p_ss_id,
                editurl:"/addupddel/index",
                datatype: "xml",
                colNames:#{col_names},
                colModel:#{col_model},
                pager: jQuery("##{@jqgrid_id}_pager"),
                rowNum:#{@r_screens["screen_rows_per_page"]},
                rowList:[#{@r_screens["screen_rowlist"]}],
                imgpath: "/images/jqgrid",
                viewrecords: true,
                width:#{@r_screens["screen_width"] ||= 1900},
                height: #{@r_screens["screen_height"]},
                sortname: "#{@r_screens["screen_sort_column"]}",
                sortorder: "",
	            multiSort:true,
                shrinkToFit: #{options[:shrinkToFit]},
                scrollrows: true,
                autowidth: #{options[:autowidth]},
                autoheight: #{options[:autoheight]},
                rownumbers: #{options[:rownumbers]},
	            #{return_code}
                #{str_set_navbutton[1]} 
               caption: "#{@title}"
              })
            .navGrid("##{@jqgrid_id}_pager",
                {refresh:true,view:false,edit:false,add:false,del:false,search:false })
                #{str_set_navbutton[0]};
                jQuery("##{@jqgrid_id}").jqGrid("gridResize",{minWidth:350,maxWidth:1900,minHeight:80, maxHeight:900});
                #{selection_link}
                mygrid.filterToolbar();mygrid[0].toggleToolbar();%
        screen_html = %Q%
            <div id="#{@jqgrid_id}_cust_buttonA_id" class="cust_buttonA"></div>
            <p  id="grpsrc#{@jqgrid_id}"  ></p> 
            <p id="flash_alert" style="display:none;padding:0.7em;" class="ui-state-highlight ui-corner-all"></p>
            <table id="#{@jqgrid_id}" class="scroll" cellpadding="0" cellspacing="0 align=center"></table>
            <p id="#{@jqgrid_id}_pager" class="scroll" style="text-indent: #{options[:text_indent]}em;"></p>
            <p id="#{@jqgrid_id}_select_button">  #{extbutton} </p>
            #{extdiv_id}%
        ###screen_javascript.gsub!(/\s+/," ")
        id_cache_key =  "id_javascript" + @screen_code +  sub_blkget_grpcode
        Rails.cache.write(id_cache_key,screen_javascript)
        id_cache_key =  "id_html" + @screen_code +  sub_blkget_grpcode
        Rails.cache.write(id_cache_key,screen_html)
        return screen_javascript,screen_html
    end
    def set_navbutton
      buttons = ActiveRecord::Base.connection.select_all(" select * from  r_usebuttons where pobject_code_scr_ub = '#{@screen_code}' and  usebutton_Expiredate > sysdate order by  button_seqNo ")
      str_navbuttonadd = ""
      inline = %Q%onSelectRow: function(rowid){if(inLineFlg){
                    if( inLineFlg=="inlineedit" || rowid == addline){ 
                    jQuery("##{@jqgrid_id}").jqGrid("saveRow",rowid,{ extraparam : {jqgrid_id:id,copy:inLineFlg,authenticity_token :p_authenticity_token ,ss_id:p_ss_id}});
                    lastsel=rowid;%
		tmpinline = ""  ###jqgridマニュアルによるとformat共存しないほうがいい
		buttons.each do |button|
            if button["button_title"] == "navSeparatorAdd"  ###セパレータ
                str_navbuttonadd << %Q%.navSeparatorAdd("##{@jqgrid_id}_pager",{sepclass:"ui-separator",sepcontent:""})%
            else
                str_navbuttonadd << %Q%
                      .navSeparatorAdd("##{@jqgrid_id}_pager",{sepclass:"ui-separator",sepcontent:""})
                      .navButtonAdd
                        ("##{@jqgrid_id}_pager"
                          ,{title:"view"
                           ,caption:""
                           ,buttonicon:"ui-icon-note"
                           ,onClickButton:function()
                             {
                              btn = "view";                              
                              if(inLineFlg){alert(" Now inline mode ") } 
                              else{var gsr = jQuery("##{@jqgrid_id}").getGridParam("selrow");
                                   if(gsr){jQuery("##{@jqgrid_id}").editGridRow
                                            (
                                             gsr
                                             ,{#{@r_screens["screen_form_ps"]}
                                               ,editCaption:"view"
                                               ,saveicon:[false,,]
                                               ,editData:{jqgrid_id:"#{@jqgrid_id}",copy:"view",authenticity_token:p_authenticity_token,ss_id:p_ss_id}
                                               ,afterShowForm:#{del_fields_protect("view")}
                                              } 
                                            )
                                          }
                                   else { alert("Please select Row") } 
                                  }
                             }         
                           }
                        )% if str_navbuttonadd == ""
                str_navbuttonadd << %Q%
                    .navSeparatorAdd("##{@jqgrid_id}_pager",{sepclass:"ui-separator",sepcontent:""})
                    .navButtonAdd("##{@jqgrid_id}_pager"
                                    ,{caption:"#{button["button_caption"]}"
                                    ,title:"#{button["button_title"]}"
                                    ,buttonicon:"#{button["button_buttonicon"]}" % 
				case  button["button_code"]  ##テーブル操作コマンド
					when "add"     ##adderrorTextFormat 中止
								str_navbuttonadd << %Q%
								,onClickButton: function(){
								btn = "#{button["button_code"]}";
								if(inLineFlg){alert(" Now inline mode ") }
								else{jQuery("##{@jqgrid_id}").editGridRow(
                                                        "new"
                                                        ,{#{@r_screens["screen_form_ps"]}
                                                        ,editCaption:"#{button["button_title"]}"
                                                        ,bSubmit: "#{button["button_code"]}", recreateForm: true 
                                                        ,editData:{jqgrid_id:"#{@jqgrid_id}",copy:"#{ button["button_code"]}",authenticity_token:p_authenticity_token,ss_id:p_ss_id}
														,clearAfterAdd:false
                                                        ,afterShowForm:#{set_aftershowform("add")}
                                                        ,beforeShowForm:#{set_onInitializeForm("add")}
                                                        ,afterSubmit:#{set_aftersubmit}
														})}} 
														})%
					when "delete"
                                str_navbuttonadd << %Q%
								,onClickButton: function(){ btn = "#{ button["button_code"]}";var gsr = jQuery("##{@jqgrid_id}").getGridParam("selrow");
								if(gsr){ jQuery("##{@jqgrid_id}").editGridRow(gsr,{#{@r_screens["screen_form_ps"]},editCaption:"#{button["button_title"]}",
                                bSubmit: "#{button["button_code"]}", recreateForm: true ,modal:true,editData:{jqgrid_id:"#{@jqgrid_id}",copy:"#{button["button_code"]}",
                                authenticity_token:p_authenticity_token,ss_id:p_ss_id}
                                 ,checkOnSubmit:true  
                                 ,afterShowForm:#{del_fields_protect("delete")}})} else { alert("Please select Row") } } 
														})%                             
                    when "edit","copy_and_add"
                                str_navbuttonadd << %Q%
								,onClickButton:function(){
								btn = "#{button["button_code"]}";                              
								if(inLineFlg){alert(" Now inline mode ") } 
								else{var gsr = jQuery("##{@jqgrid_id}").getGridParam("selrow");
									if(gsr){ jQuery("##{@jqgrid_id}").editGridRow(
                                                                 gsr
                                                                ,{#{@r_screens["screen_form_ps"]}
                                                                ,editCaption:"#{button["button_title"]}"
                                                                ,bSubmit: "#{button["button_code"]}" ,recreateForm: true 
                                                                ,editData:{jqgrid_id:"#{@jqgrid_id}",copy:"#{button["button_code"]}",authenticity_token:p_authenticity_token,ss_id:p_ss_id}
                                                                ,afterShowForm:#{set_aftershowform(button["button_code"])}
                                                                ,beforeShowForm:#{set_onInitializeForm("copyandadd")}
                                                                ,afterSubmit:#{set_aftersubmit}})}
                                   else { alert("Please select Row") } }} 
														})%
                    when "inlineedit"
                                       str_navbuttonadd  << %Q%
                              ,onClickButton: function(){
                              btn = "#{ button["button_code"]}";
                              if(inLineFlg){inLineFlg=null;jQuery("##{@jqgrid_id}").trigger("reloadGrid");alert("inline end");}
                              else{ inLineFlg="inlineedit";alert("change to inline EDIT")}} 
														})%
                        tmpinline << %Q%if(inLineFlg=="inlineedit"){jQuery("##{@jqgrid_id}").jqGrid("editRow",rowid, {"keys" : true,"oneditfunc" : null,"successfunc" : null,
                                        extraparam : {copy:"#{ button["button_code"]}",jqgrid_id:id,authenticity_token :p_authenticity_token,ss_id:p_ss_id },
                                        "aftersavefunc" : null,	"errorfunc": null,"afterrestorefunc" : null, 	"restoreAfterError" : true,"mtype" : "POST"});} %
                    when "inlineadd"
                                      str_navbuttonadd  << %Q%
                             ,onClickButton: function(){
                             btn = "#{ button["button_code"]}";
                             if(inLineFlg){inLineFlg=null;jQuery("##{@jqgrid_id}").trigger("reloadGrid");alert("inline end");}
                             else{ inLineFlg="inlineadd";alert("change to inline ADD");lno += 1;addline="new_row"+lno;jQuery("##{@jqgrid_id}")
									.jqGrid("addRowData", addline,{},"first");jQuery("#"+addline).click();}}									 
														})%
                        tmpinline << %Q%if(inLineFlg=="inlineadd"){jQuery("##{@jqgrid_id}").jqGrid("editRow",addline,
                                                       {"keys" : true,"oneditfunc" : null,"successfunc" : null,extraparam :
                                                                                                          {copy:"#{ button["button_code"]}",jqgrid_id:id,authenticity_token :p_authenticity_token,ss_id:p_ss_id },
                                                                                                          "aftersavefunc" : function(){lno += 1;addline="new_row"+lno;jQuery("##{@jqgrid_id}").jqGrid("addRowData", addline,{},"first");
                                                                                                          jQuery("#"+addline).click();},"errorfunc": null,"afterrestorefunc" : null,"restoreAfterError" : true,"mtype" : "POST"});
                                                          }%
                    when "restorerow"
                                       str_navbuttonadd << %Q%
                                 ,onClickButton: function(){if(inLineFlg){jQuery("##{@jqgrid_id}").jqGrid("restoreRow",rowid);}else{inLineFlg=null;alert("Now not inline "); }} 
														})%
					else  ##button["button_code"]
						if button["button_onclickbutton"] 
							str_navbuttonadd << ",onClickButton: function() {"
							str_navbuttonadd << eval(button["button_onclickbutton"])
							str_navbuttonadd << %Q&}, position:"right" })&
						else
                             str_navbuttonadd << "})"
						end
                end ##button["button_code"]    
            end ##    button["button_title"] == "navSeparatorAdd"            
		end   ## buttons.each
		if tmpinline == "" then inline = "" else inline << (tmpinline + "}}}," ) end
		return str_navbuttonadd,inline
    end
    def set_beforesubmit
       ##javascript_edit =  "function(data) {"
       ##完全なチェックはできないので中止
    end
    def set_aftersubmit
      javascript_edit =  "function(xhr,postdata) {var txt = xhr.responseText; "
      javascript_edit << "if(txt.match(/err/i)){};return [true];}"
    end
end
