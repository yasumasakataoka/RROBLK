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
  def to_jqgrid_xml(attributes, current_page, per_page, total)
    array = "<rows>"
    array << %Q(<page>#{current_page}</page><total>#{total/per_page.to_i+1}</total><records>#{total}</records>)
    if total > 0
      each do |elem|
         array << %Q(<row id ="#{elem[:id]}">)
        attributes.each do |atr|
          value =elem[atr]
          value = escape_javascript(value) if value and value.is_a? String
          value.gsub!("\\n","\n")  if value and value.is_a? String
          value.gsub!("<","&lt;")   if value and value.is_a? String ###xml 禁止文字対策
          value.gsub!(">","&gt;")   if value and value.is_a? String ###xml 禁止文字対策
          array << %Q(<cell>#{value}</cell>)
        end
        array << "</row>"
      end
      array << "</rows>"
    else
      array << "</rows>"
    end
    ##fprnt array
    array
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
  def get_show_data screen_code   ##popup画面もある
     ##debugger
     show_cache_key =  "show " + screen_code +  sub_blkget_grpcode
     if Rails.cache.exist?(show_cache_key) then
           show_data = Rails.cache.read(show_cache_key)
          else 
           show_data = set_detail(screen_code)  ## set gridcolumns
     end
     return show_data  ###popup画面もあるのでここで@show_dataにはできない。
  end
  def set_detail screen_code
      show_data = {}  
      det_screen = plsql.r_screenfields.all(
                                "where pobject_code_scr = '#{screen_code}'  
                                 and screenfield_expiredate > sysdate 
                                 and screenfield_selection = '1' order by screenfield_seqno ")  ###
                                 
           ## when no_data 該当データ 「r_screenfields」が無かった時の処理
           if det_screen.empty?
              ###debugger ## textは表示できないのでメッセージの変更要
	         fprnt  "Create screenfields #{screen_code} "
              p      "Create screenfields #{screen_code} "
	          ##render :text =>"Create screenfields #{screen_code} by crt_r_view_sql.rb" 
	          show_data = nil
              return show_data 
           end   
           ###
           ### pare_screen = det_screen[0][:screenfield_screens_id]
           pare_screen = det_screen[0][:screenfield_screen_id]
           screen_code_view = det_screen[0][:pobject_code_view]
           ##debugger ## 詳細項目セット
	    3.times {fprnt "error screen_id is null "} and return if pare_screen.nil?
	   gridcolumns = []
           allfields = []
           alltypes = {} 
	   icnt = 0
	   evalstr = {} 
	   det_screen.each do |i|  
                ## lable名称はユーザgroup固有よりセット    editable はtblから持ってくるように将来はする。
                ##fprnt " i #{i}"
                   tmp_editrules = {}
                   tmp_columns = {}
                   tmp_editrules[:required] = true  if i[:screenfield_indisp] == 1
                   tmp_editrules[:number] = true if i[:screenfield_type] == "number"
                   if  i[:screenfield_type] == "date" or i[:screenfield_type]  =~ /^timestamp/ then
                       tmp_editrules[:date] = true 
                       tmp_columns[:datefmt] = "Y/m/d"  if  i[:screenfield_type] == "date" 
                       tmp_columns[:datefmt] = "Y/m/d H:i:s"  if  i[:screenfield_type]  =~ /^timestamp/ 
                       tmp_columns[:datefmt] = "Y/m/d H:i:s"  if  tmp_columns[:editable] = false  
                   end
		   tmp_editrules[:required] = false  if tmp_editrules == {} 
                   tmp_columns[:field] = plsql.pobjects.first("where id =  #{i[:screenfield_pobject_id_sfd]} ")[:code]   ##**
                   tmp_columns[:label] = sub_blkgetpobj( tmp_columns[:field] ,"view_field")  ##:viewの項目
                   ### tmp_columns[:label] ||=  i[:screenfield_code]
                   tmp_columns[:hidden] = if i[:screenfield_hideflg] == 1 then true else false end 
                   tmp_columns[:editrules] = tmp_editrules 
                   tmp_columns[:width] = i[:screenfield_width]
		   if i[:screenfield_editable] == 1 or tmp_columns[:field] =~ /_id/ then
		      tmp_columns[:editable] = true
		      tmp_columns[:editoptions] = {:size => i[:screenfield_edoptsize],:maxlength => i[:screenfield_maxlength] ||= i[:screenfield_edoptsize] }  
		     else
		      tmp_columns[:editable] = false
		   end
		   tmp_columns[:edittype]  =  i[:screenfield_type]  if  ["textarea","select","checkbox","text"].index(i[:screenfield_type]) 
		   if i[:screenfield_type] == "select" or  i[:screenfield_type] == "checkbox" then
		      strselect = i[:screenfield_edoptvalue]
		      tmp_columns[:editoptions] = {:value => eval(strselect) } 
		      tmp_columns[:formatter] = "select"
		      tmp_columns[:searchoptions] = {:value => eval(strselect) } 
		   end
		   if i[:screenfield_type] == "textarea" then
		      tmp_columns[:editoptions] =  {:rows =>"#{i[:screenfield_edoptrow]}",:cols =>"#{i[:screenfield_edoptcols]}"}
		   end
       if i[:screenfield_formatter]  then
		      tmp_columns[:formatter] = i[:screenfield_formatter] 
		   end
       if  tmp_columns[:editoptions].nil? then  tmp_columns.delete(:editoptions)  end 
                   ## tmp_columns[:edittype]  =  i[:screenfield_type]  if  ["textarea","select","checkbox"].index(i[:screenfield_type]) 
		   ##debugger
      if  i[:screenfield_rowpos]     then
			    if  i[:screenfield_rowpos]  < 999
              tmp_columns[:formoptions] =  {:rowpos=>i[:screenfield_rowpos] ,:colpos=>i[:screenfield_colpos] ,:size => i[:screenfield_edoptsize],:maxlength => i[:screenfield_maxlength] ||= i[:screenfield_edoptsize]}
			        icnt = i[:screenfield_rowpos] if icnt <  i[:screenfield_rowpos] 
		        else
			        tmp_columns[:formoptions] =  {:rowpos=> icnt += 1,:colpos=>1 }
			    end
		     else
              tmp_columns[:formoptions] =  {:rowpos=> icnt += 1,:colpos=>1 }
		   end 	      
		   gridcolumns << tmp_columns 
                   allfields << i[:pobject_code_sfd].to_sym  #**

                   alltypes [i[:pobject_code_sfd].to_sym] =  i[:screenfield_type].downcase
		               evalstr[i[:pobject_code_sfd].to_sym] = i[:screenfield_rubycode] if i[:screenfield_rubycode] 
           end   ## screenfields.each
	         show_data[:allfields] =  allfields  
           show_data[:alltypes]  =  alltypes  
           show_data[:screen_code_view] = screen_code_view
           show_data[:gridcolumns] = gridcolumns
           show_data[:evalstr] = evalstr
        show_cache_key =  "show " + screen_code +  sub_blkget_grpcode
        Rails.cache.write(show_cache_key,show_data) 
	return show_data
    end    ##set_detai
    def get_screen_code 
      ###debugger ## 画面の項目
      case
         when params[:q]   then ##disp
               @jqgrid_id   =  params[:q]
	           @screen_code = params[:q]  if params[:q].split('_div_')[1].nil?    ##子画面無
               @screen_code = params[:q].split('_div_')[1]  if params[:q].split('_div_')[1]    ##子画面
          when params[:action]  == "index"  then 
               @jqgrid_id  = @screen_code = params[:id]   ## listからの初期画面の時 とcodeを求める時
          when params[:nst_tbl_val] then
               @jqgrid_id   =  params[:nst_tbl_val]
               @screen_code =  params[:nst_tbl_val].split("_div_")[1]  ###chil_scree_code
		  when params[:dump] then  ### import by excel
               @screen_code = params[:dump][:screen_code]
	end
  end
 end
 