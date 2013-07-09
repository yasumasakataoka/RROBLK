module Jqgrid

    def jqgrid_stylesheets(theme="default")
      css  = stylesheet_link_tag("jqgrid/themes/#{theme}/jquery-ui-1.10.3.custom.css") + "\n"
      css << stylesheet_link_tag('jqgrid/ui.jqgrid.css') + "\n"
    end

    def jqgrid_javascripts
      locale = I18n.locale rescue :en
      js = javascript_include_tag('jqgrid/jquery-ui-1.10.3.custom.min.js') + "\n"
      js << javascript_include_tag("jqgrid/i18n/grid.locale-#{locale}.js") + "\n"
      js << javascript_include_tag('jqgrid/jquery.jqGrid.min.js') + "\n"
      # Don't know if we need it, if smth not working, just uncomment it
    end 
    def jqgrid(title, id, action, columns = [], options = {},scriptopt = {},extbutton,extdiv_id,authenticity_token)
      ## editGridRow 追加　for add ,edit 中止　静的使用はできない。
      ## extbutton extdiv_id 自分のレコードｉｄをkeyにして別画面にlink
      ## scriptopt edit add等以外のボタンを追加
      # Default options
          options = 
        { 
          :rows_per_page       => '10',
          :sort_column         => '',
          :sort_order          => '',
          :height              => '200',  ## update
          :edit_url            => '/screen/add_upd_del' ,
          :selection_handler   => 'handleSelection',
          :gridview            => 'false',
          :error_handler       => 'null',
          :inline_edit_handler => 'null',
          :add                 => 'true',
          :delete              => 'true',
          :search              => 'true',
          :view                => 'true',
          :edit                => 'true',  
          :inline_edit         => 'false',
          :autowidth           => 'false',
          :shrinkToFit          => 'false',
          :div_repl_id         => '',          ###別画面にリンクする時
          :grp_search_form     => 'false',          ###group seach_form
          :max_width           =>  '1500',     ### resize 幅
          :max_height          =>  '700',      ###  reize 高さ
          :text_indent         =>   '2',       ### footerの横位置
          :rownumbers          => 'false'                    
        }.merge(options)
        
      # Stringify options values
      options.inject({}) do |options, (key, value)|
        options[key] = (key != :subgrid) ? value.to_s : value
        options
      end
      
      options[:error_handler_return_value] = (options[:error_handler] == 'null') ? 'true;' : options[:error_handler]
      edit_button = (options[:edit].to_s == 'true' && options[:inline_edit].to_s == 'false').to_s
###          edit_button = (options[:edit].to_s == 'true' ).to_s


      
      # Return error messgge 
      error_handler=""
      unless options[:error_handler]=="null"
        error_handler=%Q/function #{options[:error_handler]}(r, data, action) {
          var resText=JSON.parse(r.responseText);
          if (resText[0]==true) {
            $('#flash_alert').html("<span class='ui-icon ui-icon-info' style='float:left; margin-right:.3em;'><\/span>"+resText[1]);
            $('#flash_alert').slideDown();
            window.setTimeout(function() {
              $('#flash_alert').slideUp();
              }, 3000);
              return [resText[0]]
            }else{
              return [resText[0],resText[1]]
            }
        }/
      end
      
      # Generate columns data
      col_names, col_model = gen_columns(columns)
       ##edir form_posion_size 
      form_ps = "top:100,left:50,width:1200,height:600,dataheight:500"
      # nest screen 
      init_jq = ''
      nst_div  = '</script> <div id="pare_div">' 
      replace_end = ""
      unless options[:div_repl_id] == ''
             init_jq= %Q|jQuery("#div_#{options[:div_repl_id]}").replaceWith(' <div id="div_#{options[:div_repl_id]}">|
             nst_div  = "</script>"
             replace_end = "'); "
      end
      # Enable filtering (by default)
      search = ""
      filter_toolbar = ""
      if options[:search] == 'true'
        search = %Q/.navButtonAdd("##{id}_pager",{caption:"",title:$.jgrid.nav.searchtitle, buttonicon :"ui-icon-search", onClickButton:function(){mygrid[0].toggleToolbar() } })/
	##search = %Q/.navButtonAdd("##{id}_pager",{caption:"",title:$.jgrid.nav.searchtitle, buttonicon :"ui-icon-search", onClickButton:function(){var sgrid = jQuery("##{id}")[0]; sgrid.toggleToolbar();jQuery("##{id}").jqGrid('filterToolbar',{});}})/
        filter_toolbar = "mygrid.filterToolbar();"
        filter_toolbar << "mygrid[0].toggleToolbar()"
        #filter_toolbar << ";mygrid[0].triggerToolbar()"

      end
     
      # Enable sortableRows
      sortableRows=""
      
   
      # Enable multi-selection (checkboxes)
      multiselect = "multiselect: false,"
      if options[:multi_selection]
        multiselect = "multiselect: true,"
        multihandler = %Q/
          jQuery("##{id}_select_button").click(function() { 
            var s; s = jQuery("##{id}").getGridParam('selarrrow'); 
            #{options[:selection_handler]}(s); 
            return false;
          });/
      end

      # Enable master-details  not support
      # Enable selection link, button
      # The javascript function created by the user (options[:selection_handler]) will be called with the selected row id as a parameter
      selection_link = ""
      if  options[:selection_handler].present? && extbutton!= "" then
        selection_link = %Q|
        jQuery("##{id}_select_button").click( function(){ 
          var getid = jQuery("##{id}").getGridParam("selrow"); 
          var nst_tbl_val = jQuery("##{id}_select_button :checked").val(); 
          if (getid) { 
           jQuery.get("/screen/nst",{id:getid,nst_tbl_val:nst_tbl_val,authenticity_token:"#{authenticity_token}"} );   
          } else { 
            alert("Please select a row");
          }
          return false; 
        });|
      end

      # Enable direct selection (when a row in the table is clicked)
      # The javascript function created by the user (options[:selection_handler]) will be called with the selected row id as a parameter
      direct_link = ""
      if options[:direct_selection] && options[:selection_handler].present? && options[:multi_selection].blank?
        direct_link = %Q/
        onSelectRow: function(id){ 
          if(id){ 
            #{options[:selection_handler]}(id); 
          } 
        },/
      end

      # Enable grid_loaded callback
      # When data are loaded into the grid, call the Javascript function options[:grid_loaded] (defined by the user)
      grid_loaded = ""
      if options[:grid_loaded].present?
        grid_loaded = %Q/
        loadComplete: function(){ 
          #{options[:grid_loaded]}();
        },
        /
      end
      ### group search form 
           grp_search_form = %Q| jQuery("#grpsrc#{id}").filterGrid("##{id}",{ gridModel:true, gridNames:true, formtype:"vertical", enableSearch: true, enableClear: true, autosearch: false });|
      ###      
      # When a row is selected, all fields are transformed to input types
      editable = ""
      if options[:edit] && options[:inline_edit] == 'true'
        editable = %Q/
        onSelectRow: function(id){ 
          if(id && id!==lastsel){ 
            jQuery("##{id}").restoreRow(lastsel);
            jQuery("##{id}").editRow(id, true, #{options[:inline_edit_handler]}, #{options[:error_handler]});
            lastsel=id; 
          } 
        },/
      end
      str_addbutton = ""
      scriptopt[:addbutton] ||= {}
      scriptopt[:addbutton].each do |buttonopt| 
         unless ["script","gear","cart","wrench","star"].index( buttonopt[:button_icon]).nil? then
            str_addbutton << %Q|.navButtonAdd("##{id}_pager",{ caption:"",title:"#{buttonopt[:button_title]}",buttonicon:"ui-icon-#{buttonopt[:button_icon]}",
              onClickButton: function(){ var button_proc = "#{buttonopt[:button_proc]}";
                                         var q = "#{id}";
                                         var script_id = "#{scriptopt[:script_id]}";
                                         var gsr = jQuery("##{id}").getGridParam("selrow");
                                         var rowdata = jQuery("##{id}").getRowData(gsr);
                               if(gsr){jQuery.post("/screen/proc_add_button",{"q":q,"button_proc":button_proc,"id":gsr,"rowdata":rowdata,"authenticity_token":"#{authenticity_token}"},null,"script");} else {alert("Please select Row") }
                           }, position:"right" })|
         end
      end                   
      # not Enable subgrids

      # Generate required Javascript & html to create the jqgrid
      ##
      %Q(
          #{init_jq}
           <script type="text/javascript">
          #{error_handler}
             var lastsel;
          #{'jQuery(document).ready(function(){' unless options[:omit_ready]=='true'}
          var mygrid = jQuery("##{id}").jqGrid({
              url:"#{action}?q=#{id}",
              editurl:"#{options[:edit_url]}",
              datatype: "json",
              colNames:#{col_names},
              colModel:#{col_model},
              pager: jQuery("##{id}_pager"),
              rowNum:#{options[:rows_per_page]},
              rowList:[10,100,1000,10000,100000],
              imgpath: "/images/jqgrid",
              viewrecords: true,
              height: #{options[:height]},
              sortname: "#{options[:sort_column]}",
              sortorder: "#{options[:sort_order]}",
              gridview: #{options[:gridview]},
              shrinkToFit: #{options[:shrinkToFit]},
              scrollrows: true,
              autowidth: #{options[:autowidth]},
              rownumbers: #{options[:rownumbers]},
              #{multiselect}
              #{grid_loaded}
              #{direct_link}
              #{editable}
	      caption: "#{title}"             
            })
            .navGrid("##{id}_pager",
              {refresh:true,view:#{options[:view]},edit:#{edit_button},add:#{options[:add]},del:#{options[:delete]},search:false },
{editCaption:"edit  #{title}",#{form_ps},afterShowForm:#{scriptopt[:aftershowform_edit]},editData:{q:"#{id}",authenticity_token:"#{authenticity_token}"}},
{addCaption:"add  #{title}",#{form_ps},afterShowForm:#{scriptopt[:aftershowform_add]},editData:{q:"#{id}",authenticity_token:"#{authenticity_token}"}},
{caption:"delete  #{title}",#{form_ps},delData:{q:"#{id}",authenticity_token:"#{authenticity_token}"}})
            #{search}
            .navButtonAdd("##{id}_pager",{ caption:"",title:"copy and add",buttonicon:"ui-icon-copy",
              onClickButton: function(){ var gsr = jQuery("##{id}").getGridParam("selrow");
                              if(gsr){ jQuery("##{id}").editGridRow(gsr,{editCaption:"COPY & ADD",editData:{q:"#{id}",copy:"yes",authenticity_token:"#{authenticity_token}"}}); } else { alert("Please select Row") } } , position:"right" })
	   .navButtonAdd("##{id}_pager",{ caption:"",title:"export_to_xlsx",buttonicon:"ui-icon-arrowthickstop-1-s",
              onClickButton: function() { document.location = "/excelexport/index?q=#{id}"; } , position:"right" })
	              #{str_addbutton}
           .navButtonAdd("##{id}_pager",{ caption:"",title:"import_from_xlsx",buttonicon:"ui-icon-arrowthickstop-1-n",
              onClickButton: function() { document.location = "/importfmxlsx/index?q=#{id}"; } , position:"right" })
	              #{str_addbutton}
           .navButtonAdd("##{id}_pager",{ caption:"",title:"check",buttonicon:"ui-icon-check",
              onClickButton: function(){ var q = "#{id}";
                            jQuery.get("/screen/chk",{q:q,authenticity_token:"#{authenticity_token}"},null,"script");
                           }, position:"right" });
            jQuery("##{id}").jqGrid("gridResize",{minWidth:350,maxWidth:#{options[:max_width]},minHeight:80, maxHeight:#{options[:max_height]}});
	    #{multihandler}
            #{selection_link}
	    #{filter_toolbar}
            #{'})' unless options[:omit_ready]=='true'}; 
            #{grp_search_form  if  options[:grp_search_form] == true} 
	    #{nst_div}
        <p> <span> #{scriptopt[:pare_contents]}</span></p>        
        <p  id="grpsrc#{id}"  ></p> 
        <p id="flash_alert" style="display:none;padding:0.7em;" class="ui-state-highlight ui-corner-all"></p>
        <table id="#{id}" class="scroll" cellpadding="0" cellspacing="0"></table>
        <p id="#{id}_pager" class="scroll" style="text-indent: #{options[:text_indent]}em;"></p>
        <p id="#{id}_select_button">  #{extbutton} </p>
        </div>
     #{extdiv_id}
     #{replace_end} 
      ).gsub(/\n/,"")
    end
##    def blk_gantt_plumb ganttdata,options
##      %Q|
##         jQuery("#div_#{options[:div_repl_id]}").replaceWith(" <div id='div_#{options[:div_repl_id]}'>
##         <script type='text/javascript'>
##         $(function () {var ganttData = #{ganttdata});
##        $("#ganttChart").ganttView({
##            showWeekends: true,
##            data: ganttData,
##            cellWidth: 21,
##            start: new Date(2011,00,01),
##            end: new Date(2011,05,15),
##            slideWidth: 600,
##            excludeWeekends: true,
##            showDayOfWeek: true,
##            showHolidays: true,
##            excludeHolidays: true
##        });</script> </div>")
 ##    |.gsub(/\n/,"")
 ##   end 
    private
    def gen_columns(columns)
      # Generate columns data
      col_names = "[" # Labels
      col_model = "[" # Options
      columns.each do |c|
        col_names << %Q|"#{c[:label]}",|
	col_model << %Q|{name:"#{c[:field]}", index:"#{c[:field]}"#{get_attributes(c)} },|
      end
      col_names.chop! << "]"
      col_model.chop! << "]"
      [col_names, col_model]
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
          options << "searchoptions:#{get_sub_options(couple[1])},"
        elsif couple[0] == :editrules
          options << "editrules:#{get_sub_options(couple[1])},"
        else
          if couple[1].class == String
            options << %Q|#{couple[0]}:"#{couple[1]}",|
          else
            options << %Q|#{couple[0]}:#{couple[1]},|
          end
        end
      end
      options.chop!
    end

    # Generate options for editable fields (value, data, width, maxvalue, cols, rows, ...)
    def get_sub_options(editoptions)
      options = "{"
      editoptions.each do |couple|
        if couple[0] == :value # :value => [[1, "Rails"], [2, "Ruby"], [3, "jQuery"]]
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
end


module JqgridJson
  include ActionView::Helpers::JavaScriptHelper

  def to_jqgrid_json(attributes, current_page, per_page, total)
    json = %Q({"page":"#{current_page}","total":#{total/per_page.to_i+1},"records":"#{total}")
    if total > 0
      json << %Q(,"rows":[)
      each do |elem|
         json << %Q({"id":"#{elem[:id]}","cell":[)
        attributes.each do |atr|
          value =elem[atr]
          value = escape_javascript(value) if value and value.is_a? String
          json << %Q("#{value}",)
        end
        json.chop! << "]},"
      end
      json.chop! << "]}"
    else
      json << "}"
    end
  end
  
  private
  
  def get_atr_value(elem, atr, couples)
    if atr.instance_of?(String) && atr.to_s.include?('.')
      value = get_nested_atr_value(elem, atr.to_s.split('.').reverse) 
    else
      value = couples[atr]
      value = _resolve_value(atr, elem)
     # value = elem.send(atr.to_sym) if value.blank? && elem.respond_to?(atr) # Required for virtual attributes
    end
    value
  end
  def _resolve_value(value, record)
    case value
    when Symbol
      if record.respond_to?(value)
        record.send(value) 
      else 
        value.to_s
      end
    when Proc
      value.call(record)
    else
      value
    end
  end
  def get_nested_atr_value(elem, hierarchy)
    return nil if hierarchy.size == 0
    atr = hierarchy.pop
    raise ArgumentError, "#{atr} doesn't exist on #{elem.inspect}" unless elem.respond_to?(atr)
    nested_elem = elem.send(atr)
    return "" if nested_elem.nil?
    value = get_nested_atr_value(nested_elem, hierarchy)
    value.nil? ? nested_elem : value
  end
end

module JqgridFilter
  def filter_by_conditions(columns)
    conditions = ""
    columns.each do |column|
      conditions << "#{column} LIKE '%#{params[column]}%' AND " unless params[column].nil?
    end
    conditions.chomp("AND ")
  end
end
