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
   def jqgrid(title, id, screen_code,options = {},authenticity_token,ss_id)
      ## id ：screen_code又は親画面コード+(_div_)+子画面コード
      # Default options
          options = 
        { 
          :selection_handler   => 'handleSelection',
          :autowidth           => 'false',
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
      if id =~ /^gantt/ then
         nst_div  << ' ge = new GanttMaster(); ge.init(jQuery("#workSpace"));
            var workSpace = jQuery("#workSpace"); workSpace.css({width:jQuery(window).width() - 10,heigt:jQuery(window).height() - 250}); 
            function uploadOnServer(){var prj = ge.saveProject();prj.authenticity_token=p_authenticity_token;jQuery.post("/screen/uploadgantt",prj,function(rd){alert(rd.error)},"json");}'
       end      
         nst_div <<  '});function getUrlVars()
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
                            }</script> ' 
      replace_end = ""
      unless options[:div_repl_id] == ''
             init_jq= %Q|jQuery("#div_#{options[:div_repl_id]}").replaceWith('<div id="div_#{options[:div_repl_id]}">|
             nst_div  = " });</script>"
             replace_end = "'); "
      end
     
     show_cache_key =  "show " + screen_code +  sub_blkget_grpcode
     ##debugger


     if Rails.cache.exist?(show_cache_key) then
         @show_data = Rails.cache.read(show_cache_key)
       else 
	       ### create_def screen_code
	       @show_data = set_detail(screen_code )  ## set gridcolumns
     end
     render :text =>"Create ScreenFields #{screen_code} by crt_r_view_sql.rb" and return   if @show_data.nil?
     @gridcolumns = @show_data[:gridcolumns]
     @evalstr = @show_data[:evalstr]
     id_cache_key =  "id " + screen_code +  sub_blkget_grpcode
     if Rails.cache.exist?(id_cache_key) then
         id_data = Rails.cache.read(id_cache_key)
        else
          id_data = create_screen_field(screen_code,title, id, options )
      end
     ##debugger
     screen = %Q% #{init_jq}  <script type="text/javascript"> var id = "#{id}"; var p_authenticity_token = "#{authenticity_token}";var ge;var inLineFlg;var lno = 0;var addline;var p_ss_id = "#{ss_id}";%
       screen << id_data[:screen_javascript]
       screen << nst_div
       screen << " <p> #{options[:pare_contents]}</p>   "
       screen << id_data[:screen_html]
       screen <<  replace_end
       ##fprnt screen
       screen.gsub!(/\s+/," ")    if init_jq  =~ /replaceWith/  ###repacewithが \nだと変換してくれない。\s+ \nの変換も含む
     return screen 
    end  ## 
    ##def sub_get_select_list_value edoptvalue   ##固定文字を個別文字に
    ## edoptvalue.scan(/'\w*'/).each do |i|
    ##	 j = i.gsub("'","")
    ##	 edoptvalue =  edoptvalue.sub(j,sub_blkgetpobj(j,"fix_char"))
    ## end
    ## return edoptvalue
    ##end 
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
      column.except(:field, :label).each do |couple|
        if couple[0] == :editoptions
          options << "editoptions:#{get_sub_options(couple[1])},"
        
        elsif couple[0] == :formoptions
          options << "formoptions:#{get_sub_options(couple[1])},"
        elsif couple[0] == :searchoptions
          options << %Q|stype:"select",searchoptions:#{get_sub_searchoptions(couple[1])},|  ###日付の時 stype:"text"????
        elsif couple[0] == :editrules
          options << "editrules:#{get_sub_options(couple[1])},"
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
            options << "#{v[0]}:#{v[1]};" if i >0 
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
    def fprnt str
      foo = File.open("#{Rails.root}/log/blk#{Process::UID.eid.to_s}.log", "a") # 書き込みモード
      foo.puts "#{Time.now.to_s}  #{str}"
      foo.close
    end   ##fprnt str
     ################
    def set_extbutton pare_screen_code     ### 子画面用のラジオボ タンセット
      ##debugger
      ### 同じボタンで有効日が>sysdateのデータが複数あると複数ボタンがでる
      rad_screen = plsql.r_chilscreens.all("where chilscreen_Expiredate > sysdate 
                                            and pobject_code_scr = '#{pare_screen_code}' ")
           t_extbutton = ""
           t_extdiv_id = ""
           rad_screen.each_with_index do |i,k|     ###child tbl name sym
               ### view name set
                  t_extbutton << %Q|<input type="radio" id="radio#{pare_screen_code}#{k.to_s}"  name="nst_radio#{pare_screen_code}"|
                  t_extbutton << %Q| value="#{i[:pobject_code_scr]}_div_#{i[:pobject_code_scr_ch]}_div_| ### 親のview
                  t_extbutton << %Q|#{i[:pobject_code_scr_ch]}_div_1"/>|    #**
                  t_extbutton << %Q| <label for="radio#{pare_screen_code}#{k.to_s}">  #{sub_blkgetpobj(i[:pobject_code_scr_ch],"screen")} </label> |   ##"screen"画面
                  t_extdiv_id << %Q|<div id="div_#{i[:pobject_code_scr]}_div_#{i[:pobject_code_scr_ch]}"> </div> |   #**
           end   ### rad_screen.each
	    return  t_extbutton,t_extdiv_id
    end    ## set_extbutton pare_screen  
    def get_return_name_val scrfield,screen_code
       ##debugger
      tmp_val = ""
      viewname = nil
      delm ||= (scrfield.split("_",3)[2]) 
      v = plsql.r_screenfields.first("where pobject_code_scr = '#{screen_code}' and pobject_code_sfd = '#{scrfield}' and screenfield_paragraph  is not null AND screenfield_expiredate > sysdate")
      if  v then  viewname,delm =  v[:screenfield_paragraph].split(":_") end
      if  viewname.nil? or viewname == ""  then viewname = ("r_"+scrfield.split("_")[0]+"s") end 
       ##p "viewname #{viewname}"
      secgridc = get_show_data(viewname)[:allfields]
      sfields  = @show_data[:allfields]
      ##if  delm then
      ##     sfields = []
      ##     @show_data[:allfields].each do |f|
      ##         sfields << f.to_s.sub("_#{delm}","").to_sym
      ##    end
      ##end
      secgridc.each do |tcolm|
          field = tcolm.to_s
          if  sfields.index(tcolm)  and  field !~ /^id/ then 
              ##if  delm.nil? then  field = tcolm.to_s    else   field = tcolm.to_s+ "_"+delm  end   ###delm.nil?
              tmp_val  << "if(data.#{field}){"   if screen_code.split("_")[1] == viewname.split("_")[1]
              tmp_val  << %Q%jQuery("##{field}",formid).val(data.#{field});%
              tmp_val  << "}"   if screen_code.split("_")[1] == viewname.split("_")[1]
           end
      end  ### secgridc.each do |tcolm|
      fmfield = viewname.split("_")[1].chop+"_id"
      tofield = screen_code.split("_")[1].chop+"_"+fmfield
      if  delm then
             fmfield += ("_"+delm)
             tofield += ("_"+delm)
      end    
       ##debugger
      if  @show_data[:allfields].index(tofield.to_sym) then  
             tmp_val  << %Q% jQuery("##{tofield}",formid).val(data.#{fmfield});%
      end
      tmp_val << %Q%if(data.errmsg){alert(data.errmsg);}%
      return tmp_val
    end
    def set_aftershowform screen_code,oper
      ###外部テーブルのリンクに関係ない項目は　enable == true and require == false
      ## 変更項目の修正不可は固定にはしないで、関数で対応
      ## javascript_edit = %Q%(function($) {
      ##                      jQuery.fn.pinCodeToName = function(formid) { 
      javascript_edit =  "function(formid) {"
      tmp_code_to_name = ""
      require_fields = ""
      strsenddata = %Q% "q":"#{screen_code}","chgname":p_chgname,"code_to_name_oper":"#{oper}",%
      strkeydata = %Q% "q":"#{screen_code}","fieldname":keyname%
      @gridcolumns.each do |tcolm|
            ###debugger
            if (tcolm[:field].split("_")[0] != screen_code.split("_")[1].chop  and 
                tcolm[:editable] == true and  tcolm[:editrules][:required] == false)  or  tcolm[:field] =~ /_id/ then 
               javascript_edit << %Q% jQuery("##{tcolm[:field]}",formid).attr("disabled",true);%
	          end
            if (tcolm[:field].split("_")[0] != screen_code.split("_")[1].chop and tcolm[:editrules][:required]  == true) or  tcolm[:field] =~ /_id/ then 
               require_fields << %Q% var p_#{tcolm[:field]} =  jQuery("##{tcolm[:field]}",formid).val();%
               strsenddata << %Q% "#{tcolm[:field]}":p_#{tcolm[:field]},%
	          end
            if tcolm[:field].split("_")[0] == screen_code.split("_")[1].chop and tcolm[:editrules][:required]  == true  then 
               if  oper != "add" and  oper != "copyandadd"  then javascript_edit << ""  ### 中止　外部keyでチェックする。jQuery("##{tcolm[:field]}",formid).attr("disabled",true); 
                   else  javascript_edit << %Q%
                                                           jQuery("##{tcolm[:field]}",formid).attr("disabled",false);%
                                            require_fields << %Q% var p_#{tcolm[:field]} =  jQuery("##{tcolm[:field]}",formid).val();%
                                            strsenddata << %Q% "#{tcolm[:field]}":p_#{tcolm[:field]},%  end
	          end
      end

     javascript_edit << %Q% jQuery("#sData").show();% 
      ###既定値等セット  ### jQuery("##{tcolm[:field]}",formid).val()にセットすべきもの
     @gridcolumns.each do |tcolm|
         if tcolm[:editrules][:required]  == true  and  
    
            (tcolm[:field].split("_")[0] != screen_code.split("_")[1].chop or ( tcolm[:field].split("_")[0] == screen_code.split("_")[1].chop and oper == "add")) then 
               tmp_code_to_name << %Q% if(p_chgname=="#{tcolm[:field]}"&&btn == "#{oper}"){jQuery.getJSON("/screen/code_to_name",
                                          {#{strsenddata.chop}},function(data){
      					  #{get_return_name_val(tcolm[:field],screen_code)}});}%
        end
     end
     javascript_edit << %Q%
                                                           jQuery("input",formid).change(function(){ 
                                                                   var p_chgname = jQuery(this).attr("name");
      		                                                   #{require_fields} 
      					                           #{tmp_code_to_name}});
	                                                           jQuery("input",formid).keydown(function(e){ 
      		                                                   var keyname = jQuery(this).attr("name");
     					                           var viewval  ;
					                           var newwin;
      					                           if(keyname.match(/_code/i)&&e.keyCode==34){jQuery.getJSON("/screen/get_url_from_code",
                                                                      {#{strkeydata}},function(data){viewval=data.viewname;
					                                if(!newwin||newwin.closed){
                                                                            url = "/screen/index?id=" + viewval + "&grid_key="+keyname;
					                                    newwin = window.open(url,"blkpopup","width=800,height=350,menubar=no,toolbar=no,status=no,menubar=no,scrollbars=yes");}
						                       else{
                                                                           newwin.focus();}

					  }
)}})%
	##
      javascript_edit << "}"
      
       ##javascript_edit <<   ";}})(jQuery);"
   end
   def set_onInitializeForm
       require_fields =  "function(formid) {"
       @gridcolumns.each do |tcolm|
            require_fields << %Q% jQuery("##{tcolm[:field]}",formid).removeAttr("disabled");%
      end
      require_fields << %Q% jQuery("#sData").show();% 
      require_fields << "}"
      return  require_fields
   end
   def del_fields_protect oper
       require_fields =  "function(formid) {"
       @gridcolumns.each do |tcolm|
            require_fields << %Q% jQuery("##{tcolm[:field]}",formid).attr("disabled",true);%
      end
      require_fields << %Q% jQuery("#sData").hide();% if oper == "view"
      require_fields << %Q% jQuery("#sData").show();% if oper != "view"
      require_fields << "}"
      return  require_fields
       ##javascript_edit <<   ";}})(jQuery);
   end

   def set_pdf_item screen_code
      pdflist = plsql.r_reports.all("where pobject_code_scr = '#{screen_code}' and REPORT_EXPIREDATE >sysdate")                 ##**
      pdfvalue = ""
      pdflist.each do |i|
	      pdfvalue = i[:pobject_code_rep] + ":" + sub_blkgetpobj(i[:pobject_code_rep],"report") + ";"              ##**
      end
      pdfvalue.chop if pdfvalue.size > 0
      return pdfvalue
   end
   def get_screenoptions screen_code
      screenoptions = plsql.r_screens.first("where pobject_code_scr = '#{screen_code}' and REPORT_EXPIREDATE >sysdate  order by  REPORT_EXPIREDATE  ")                 ##**
      pdfvalue = ""
      pdflist.each do |i|
	      pdfvalue = i[:pobject_code_rep] + ":" + sub_blkgetpobj(i[:pobject_code_rep],"report") + ";"              ##**
      end
      pdfvalue.chop if pdfvalue.size > 0
      return pdfvalue
   end
   def create_screen_field(screen_code,title, id, options)
      ##id columns options  authenticity_token
      # Generate columns dat
       col_names, col_model,cellnames = gen_columns

      # Enable filtering (by default)
      screen_options = plsql.r_screens.first("where pobject_code_scr = '#{screen_code}' and SCREEN_EXPIREDATE >sysdate")  
      p " line #{__LINE__} logic err screen_code = #{screen_code} " and return if screen_options.nil?
     
      # Enable selection link, button
         extbutton = "" 
         extbutton,extdiv_id =  set_extbutton(screen_code)
      # The javascript function created by the user (options[:selection_handler]) will be called with the selected row id as a parameter


      ###
      ### replaceのため「''」は使用できない
      ###
      selection_link = ""
      if  options[:selection_handler].present? && extbutton!= "" then
        selection_link = %Q|
        jQuery("##{id}_select_button").buttonset();
        jQuery("##{id}_select_button :radio").click( function(e){ 
          var getid = jQuery("##{id}").getGridParam("selrow");          
          var nst_tbl_val = jQuery("##{id}_select_button :checked").val(); 
          if (getid) { 
                     var rowdata = jQuery("##{id}").getRowData(getid);           
                     jQuery.post("/screen/nst",{id:getid,nst_tbl_val:nst_tbl_val,authenticity_token:p_authenticity_token,ss_id:p_ss_id,data:rowdata} );   
          } else { 
            alert("Please select a row");
          }
          return false; 
        });|
      end
   ###pdf
      pdf_opt = ""
      pdf_opt = set_pdf_item id
      pdf_link = %Q|jQuery("##{id}_printid").append("<b>screen has nopdf_list</b>");| 

      if pdf_opt.size>0 then 
         pdfdata = %Q%function nWin() {var pdata = jQuery("##{id}").getPostData(); 
                      var strparam;jQuery.each(pdata, function(key, value) {strparam = strparam + key + "=" + value + "&" }); strparam = strparam + "q=#{id}";
                      var url = "/pdf/index?"+strparam;window.open(url);};
                      jQuery(function() {jQuery(".#{id}_filterbuttonclass").click(nWin);});%
         pdf_link = %Q% jQuery("##{id}_printid").filterGrid("##{id}",
                     {formclass:"##{id}_filterformclass",buttonclass:"#{id}_filterbuttonclass",enableSearch:true,searchButton:"pdf",autosearch:true,url:"/screen/preview_prnt?q=#{id}",
                     filterModel:[{label:'.  pdf list', name: 'pdflist', stype: 'select', sopt:{value:"#{pdf_opt}"}},
                      {label:'  Nobody print records?', name: 'initprnt', stype: 'select', sopt:{value:"1:yes init_new_record_print;2:yes init_update_record_print;9:no all_print"}},
                      {label:'  You update records?', name: 'whoupdate', stype: 'select',sopt:{value:"1:yes My_Records;9:no all_Records"}}]}); #{pdfdata}%
     end
     # Enable direct selection (when a row in the table is clicked)
      # The javascript function created by the user (options[:selection_handler]) will be called with the selected row id as a parameter
      return_cod = ""
     return_code = %Q%onCellSelect:function(rowid, iCol,value,e){ 
         var pare_cellname  = getUrlVars()["grid_key"];
	 if(pare_cellname){
            var cellname = cellNames[iCol];
            if(cellname.match(/_code/i)){ 
              if(window.opener){
                                 var nameofcode = pare_cellname.replace("_code","_name");
                                 var rowdata = jQuery("##{id}").getRowData(rowid);
                                 var taskId = getUrlVars()["taskid"];
                                 if(taskId)
                                    {
                                     jQuery("tr[taskId="+taskId+"] input[name="+pare_cellname+"]", window.opener.document).val(value).change();
			            }
                                  else
                                    {
                                     jQuery("#"+ pare_cellname, window.opener.document).val(value); 
                                     var tnamefields = nameofcode.split("_");
                                     var namefield = tnamefields[0]+"_"+tnamefields[1];
			             jQuery("#"+ nameofcode ,window.opener.document).val(rowdata[namefield]);
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
    str_set_navbutton = set_navbutton(screen_code,id)
    ##btn 押されたボタン
    screen_javascript = %Q%  var lastsel; var btn; 
	     #{cellnames}
          jQuery(document).ready(function(){ 
          #{custom_func}         
          function textHeightFmatter(cellvalue, options, rowObject) { if(cellvalue){return "<div style=max-height:30px>"+cellvalue+"</div>";}}   
          function untextHeightFmatter(cellvalue, options){if(cellvalue){return cellvalue.replace("<div style=max-height:30px>","").replace("</div>","");}}  
          var mygrid = jQuery("##{id}").jqGrid({
              url:"/screen/disp?q=#{id}&ss_id="+p_ss_id,
              editurl:"/addupddel/index",
              datatype: "xml",
              colNames:#{col_names},
              colModel:#{col_model},
              pager: jQuery("##{id}_pager"),
              rowNum:#{screen_options[:screen_rows_per_page]},
              rowList:[#{screen_options[:screen_rowlist]}],
              imgpath: "/images/jqgrid",
              viewrecords: true,
              width:#{screen_options[:screen_width] ||= 1800},
              height: #{screen_options[:screen_height]},
              sortname: "#{screen_options[:screen_sort_column]}",
              sortorder: "",
	            multiSort:true,
              shrinkToFit: #{options[:shrinkToFit]},
              scrollrows: true,
              autowidth: #{options[:autowidth]},
              rownumbers: #{options[:rownumbers]},
	            #{return_code}
              #{str_set_navbutton[1]} 
              caption: "#{title}"
              })
            .navGrid("##{id}_pager",
            {refresh:true,view:false,edit:false,add:false,del:false,search:false })
            #{str_set_navbutton[0]};
            jQuery("##{id}").jqGrid("gridResize",{minWidth:350,maxWidth:1800,minHeight:80, maxHeight:900});
            #{selection_link}
            #{pdf_link }
            mygrid.filterToolbar();mygrid[0].toggleToolbar();%
    screen_html = %Q%
        <div id="#{screen_code}_printid" class="prntclass"></div>
       <p  id="grpsrc#{id}"  ></p> 
        <p id="flash_alert" style="display:none;padding:0.7em;" class="ui-state-highlight ui-corner-all"></p>
        <table id="#{id}" class="scroll" cellpadding="0" cellspacing="0 align=center"></table>
        <p id="#{id}_pager" class="scroll" style="text-indent: #{options[:text_indent]}em;"></p>
        <p id="#{id}_select_button">  #{extbutton} </p>
        #{extdiv_id}%
     ##screen_javascript.gsub!(/\s+/," ")
      ##debugger
      ##fprnt " jqgrid #{a} "
      id_cache_key =  "id " + screen_code +  sub_blkget_grpcode
      id_data = {}
      id_data[:screen_javascript] = screen_javascript
      id_data[:screen_html] = screen_html
      Rails.cache.write(id_cache_key,id_data) 

      return id_data
    end
    def set_navbutton screen_code,id
      person =  plsql.r_persons.first(:person_email =>current_user[:email])
      buttons = plsql.r_usebuttons.all("where pobject_code_scr_ub = '#{screen_code}' and  usebutton_Expiredate > sysdate order by  button_seqNo ")
      str_navbuttonadd = ""
      br_screen = {}
      inline = %Q%onSelectRow: function(rowid){if(inLineFlg){
                    if( inLineFlg=="inlineedit" || rowid == addline){ 
                    jQuery("##{id}").jqGrid("saveRow",rowid,{ extraparam : {q:id,copy:inLineFlg,authenticity_token :p_authenticity_token ,ss_id:p_ss_id}});
                    lastsel=rowid;%
      tmpinline = ""  ###jqgridマニュアルによるとformat共存しないほうがいい
      ##debugger

      buttons.each do |button|
             br_screen = plsql.r_screens.first("where pobject_code_scr = '#{screen_code}' and screen_expiredate > sysdate  order by  screen_expiredate ") if  br_screen == {}
             if button[:button_title] == "navSeparatorAdd"  then    ###セパレータ
                   str_navbuttonadd << %Q%.navSeparatorAdd("##{id}_pager",{sepclass:"ui-separator",sepcontent:""})%
                else
                    str_navbuttonadd << %Q%
                      .navSeparatorAdd("##{id}_pager",{sepclass:"ui-separator",sepcontent:""})
                      .navButtonAdd
                        ("##{id}_pager"
                          ,{title:"view"
                           ,caption:""
                           ,buttonicon:"ui-icon-note"
                           ,onClickButton:function()
                             {
                              btn = "view";                              
                              if(inLineFlg){alert(" Now inline mode ") } 
                              else{var gsr = jQuery("##{id}").getGridParam("selrow");
                                   if(gsr){jQuery("##{id}").editGridRow
                                            (
                                             gsr
                                             ,{#{br_screen[:screen_form_ps]}
                                               ,editCaption:"view"
                                               ,saveicon:[false,,]
                                               ,editData:{q:"#{id}",copy:"view",authenticity_token:p_authenticity_token,ss_id:p_ss_id}
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
                       .navSeparatorAdd("##{id}_pager",{sepclass:"ui-separator",sepcontent:""})
                       .navButtonAdd("##{id}_pager"
                                     ,{caption:"#{button[:button_caption]}"
                                     ,title:"#{button[:button_title]}"
                                     ,buttonicon:"#{button[:button_buttonicon]}" %
                   if button[:button_editgridrow] then   ##テーブル操作コマンド
                      case  button[:button_editgridrow]
                           when "add"     ##adderrorTextFormat 中止
                                str_navbuttonadd << %Q%
                              ,onClickButton: function(){
                              btn = "#{button[:button_editgridrow]}";
                              if(inLineFlg){alert(" Now inline mode ") }
                              else{jQuery("##{id}").editGridRow(
                                                        "new"
                                                        ,{#{br_screen[:screen_form_ps]}
                                                        ,editCaption:"#{button[:button_title]}"
                                                        ,editData:{q:"#{id}",copy:"#{ button[:button_editgridrow]}",authenticity_token:p_authenticity_token,ss_id:p_ss_id}
                                                        ,afterShowForm:#{set_aftershowform(screen_code,"add")}
                                                        ,beforeShowForm:#{set_onInitializeForm}
                                                        ,afterSubmit:#{set_aftersubmit}})}} %
                           when "delete"
                                      str_navbuttonadd << %Q%
                             ,onClickButton: function(){ btn = "#{ button[:button_editgridrow]}";var gsr = jQuery("##{id}").getGridParam("selrow");
                              if(gsr){ jQuery("##{id}").editGridRow(gsr,{#{br_screen[:screen_form_ps]},editCaption:"#{button[:button_title]}",
                                bSubmit: "Delete",modal:true,editData:{q:"#{id}",copy:"#{button[:button_editgridrow]}",
                                authenticity_token:p_authenticity_token,ss_id:p_ss_id}
                                 ,checkOnSubmit:true  
                                 ,afterShowForm:#{del_fields_protect("delete")}})} else { alert("Please select Row") } }%                             
                           when "edit","copyandadd"
                                      str_navbuttonadd << %Q%
                             ,onClickButton:function(){
                              btn = "#{ button[:button_editgridrow]}";                              
                              if(inLineFlg){alert(" Now inline mode ") } 
                              else{var gsr = jQuery("##{id}").getGridParam("selrow");
                                   if(gsr){ jQuery("##{id}").editGridRow(
                                                                 gsr
                                                                ,{#{br_screen[:screen_form_ps]}
                                                                ,editCaption:"#{button[:button_title]}"
                                                                ,editData:{q:"#{id}",copy:"#{button[:button_editgridrow]}",authenticity_token:p_authenticity_token,ss_id:p_ss_id}
                                                                ,afterShowForm:#{set_aftershowform(screen_code,button[:button_editgridrow])}
                                                                ,beforeShowForm:#{set_onInitializeForm}
                                                                ,afterSubmit:#{set_aftersubmit}})}
                                   else { alert("Please select Row") } }}%
                           when "inlineedit"
                                       str_navbuttonadd  << %Q%
                              ,onClickButton: function(){
                              btn = "#{ button[:button_editgridrow]}";
                              if(inLineFlg){inLineFlg=null;jQuery("##{id}").trigger("reloadGrid");alert("inline end");}
                              else{ inLineFlg="inlineedit";alert("change to inline EDIT")}}%
                                       tmpinline << %Q%if(inLineFlg=="inlineedit"){jQuery("##{id}").jqGrid("editRow",rowid, {"keys" : true,"oneditfunc" : null,"successfunc" : null,
                                        extraparam : {copy:"#{ button[:button_editgridrow]}",q:id,authenticity_token :p_authenticity_token,ss_id:p_ss_id },
                                        "aftersavefunc" : null,	"errorfunc": null,"afterrestorefunc" : null, 	"restoreAfterError" : true,"mtype" : "POST"});} %
                           when "inlineadd"
                                      str_navbuttonadd  << %Q%
                             ,onClickButton: function(){
                             btn = "#{ button[:button_editgridrow]}";
                             if(inLineFlg){inLineFlg=null;jQuery("##{id}").trigger("reloadGrid");alert("inline end");}
                             else{ inLineFlg="inlineadd";alert("change to inline ADD");lno += 1;addline="new_row"+lno;jQuery("##{id}").jqGrid("addRowData", addline,{},"first");jQuery("#"+addline).click();}}%
                                      tmpinline << %Q%if(inLineFlg=="inlineadd"){jQuery("##{id}").jqGrid("editRow",addline,
                                                       {"keys" : true,"oneditfunc" : null,"successfunc" : null,extraparam :
                                                                                                          {copy:"#{ button[:button_editgridrow]}",q:id,authenticity_token :p_authenticity_token,ss_id:p_ss_id },
                                                                                                          "aftersavefunc" : function(){lno += 1;addline="new_row"+lno;jQuery("##{id}").jqGrid("addRowData", addline,{},"first");
                                                                                                          jQuery("#"+addline).click();},"errorfunc": null,"afterrestorefunc" : null,"restoreAfterError" : true,"mtype" : "POST"});
                                                          }%
                            when "restorerow"
                                       str_navbuttonadd << %Q%
                                 ,onClickButton: function(){if(inLineFlg){jQuery("##{id}").jqGrid("restoreRow",rowid);}else{inLineFlg=null;alert("Now not inline "); }}%
                          end    ##case button[:button_editgridrow]         
                        str_navbuttonadd <<  %Q%
                         ,position:"right" })%
                    else  ##button[:button_editgridrow]
                      if button[:button_onclickbutton] then
                          str_navbuttonadd << %Q%
                         ,onClickButton: function() {#{button[:button_onclickbutton]};}, position:"right" })% 
                         else
                             str_navbuttonadd << "})"
                      end
                   end ##button[:button_editgridrow]    
              end ##    button[:button_title] == "navSeparatorAdd"            
      end   ## buttons.each
      if tmpinline == "" then inline = "" else inline << (tmpinline + "}}}," ) end
      ##debugger
      return str_navbuttonadd,inline
    end
    def set_beforesubmit
       ##javascript_edit =  "function(data) {"
       ##完全なチェックはできないので中止
    end
    def set_aftersubmit
      javascript_edit =  "function(xhr,postdata) {var txt = xhr.responseText; "
      javascript_edit << "if(txt.match(/err/i)){alert(txt);};return [true];}"
    end
end
