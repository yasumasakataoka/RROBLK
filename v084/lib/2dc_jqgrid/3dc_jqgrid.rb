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
          value.gsub!("\\\\","\\")  if value and value.is_a? String
          value.gsub!("\\n","\n")  if value and value.is_a? String
          value.gsub!("<","&lt;")   if value and value.is_a? String ###xml 禁止文字対策
          value.gsub!(">","&gt;")   if value and value.is_a? String ###xml 禁止文字対策
          value.gsub!("&","&amp;")   if value and value.is_a? String ###xml 禁止文字対策
          array << %Q(<cell>#{value}</cell>)
        end
        array << "</row>"
      end
      array << "</rows>"
    else
      array << "</rows>"
    end
    ##logger.debug array
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
			### とりあえず
			Blksdate  = Date.today - 1  ##在庫基準日　sch,ord,instのこれ以前の納期は許さない。
  def filter_by_conditions(columns)
    conditions = ""
    columns.each do |column|
      conditions << "#{column} LIKE '%#{params[column]}%' AND " unless params[column].nil?
    end
    conditions.chomp("AND ")
  end
	def get_show_data screen_code   ##popup画面もあるので@screen_codeは使用できない。
		show_cache_key =  "show" + (screen_code||=" coding err  :screen_code is nil") +  sub_blkget_grpcode
		show_data = Rails.cache.read(show_cache_key)
		if show_data.nil?
			logger.debug " JqgridJson line #{__LINE__} show_cache_key:#{show_cache_key}" 
			show_data = set_detail(screen_code) if show_data.nil? ## set gridcolumns
			##show_data = set_detail("r_#{screen_code.split("_")[1]}") if show_data.nil? 
			if show_data
				show_cache_key =  "show" + "r_#{screen_code.split("_")[1]}" +  sub_blkget_grpcode
				Rails.cache.write(show_cache_key,show_data)
			end
		end
		raise if show_data.nil? 
		return show_data  ###popup画面もあるのでここで@show_dataにはできない。
	end
	def set_detail screen_code
		show_data = {}  
		det_screen = ActiveRecord::Base.connection.select_all("select * from r_screenfields
                                 where pobject_code_scr = '#{screen_code}'  
                                 and screenfield_expiredate > sysdate 
                                 and screenfield_selection = '1' order by screenfield_seqno,screenfield_colpos ")  ###
                                 
           ## when no_data 該当データ 「r_screenfields」が無かった時の処理
        if det_screen.empty?  
			det_screen = ActiveRecord::Base.connection.select_all("select * from r_screenfields
                                 where pobject_code_scr = 'r_#{screen_code.split("_")[1]}'  
                                 and screenfield_expiredate > sysdate 
                                 and screenfield_selection = '1' order by screenfield_seqno,screenfield_colpos ")
			if det_screen.empty?
				logger.debug "line #{(__LINE__).to_s } coding err screen_code #{screen_code}  " 
				show_data = nil
				return show_data
			end
        end   
           ###
           ### pare_screen = det_screen[0][:screenfield_screens_id]
        pare_screen = det_screen[0]["screenfield_screen_id"]
        screen_code_view = det_screen[0]["pobject_code_view"]
	    3.times {logger.debug "error screen_id is null "} and return if pare_screen.nil?
		gridcolumns = []
		allfields = []
		alltypes =  {}
		paragraph = []
		icnt = 10000
	    det_screen.each do |i|  
            ## lable名称はユーザgroup固有よりセット    editable はtblから持ってくるように将来はする。
            ##logger.debug " i #{i}"
            tmp_editrules = {}
			tmp_columns = {}
			tmp_columns[:field] = ActiveRecord::Base.connection.select_value("select code from pobjects where id =  #{i["screenfield_pobject_id_sfd"]} ")   ##**
			tmp_columns[:label] = proc_blkgetpobj( tmp_columns[:field] ,"view_field")  ##:viewの項目
			case i["screenfield_hideflg"]
				when 1 
					tmp_columns[:hidden] = true 
				else
					tmp_columns[:hidden] = false
					tmp_columns[:width] = i["screenfield_width"]
					tmp_columns[:editoptions] = {:size => i["screenfield_edoptsize"],:maxlength => i["screenfield_maxlength"] ||= i["screenfield_edoptsize"] }
					case i["screenfield_type"]
						when "number"
							tmp_columns[:align] = "right"
							tmp_editrules[:number] = true
						when /^timestamp/ 
							tmp_editrules[:date] = true 
							tmp_columns[:datefmt] = "Y/m/d H:i:s" 
						when /^date/ 
							tmp_editrules[:date] = true 
							tmp_columns[:datefmt] = "Y/m/d"
							tmp_columns[:editoptions] = {:size => i["screenfield_edoptsize"],:maxlength => i["screenfield_maxlength"] ||= i["screenfield_edoptsize"] } 
						when /select|checkbox/ 
							strselect = i["screenfield_edoptvalue"]
							tmp_columns[:editoptions] = {:value => eval(strselect) } 
							tmp_columns[:searchoptions] = {:value => eval(strselect) }
							tmp_columns[:edittype]  =  i["screenfield_type"] 
						when /textarea/
							tmp_columns[:editoptions] =  {:rows =>"#{i["screenfield_edoptrow"]}",:cols =>"#{i["screenfield_edoptcols"]}"}
							tmp_columns[:edittype]  =  i["screenfield_type"]    
						when "text"
							tmp_columns[:edittype]  =  i["screenfield_type"] 
					end
					if i["screenfield_editable"] > 0 and    i["screenfield_rowpos"] and i["screenfield_colpos"]
						tmp_columns[:editable] = true
						tmp_columns[:formop] = i["screenfield_editable"]
						tmp_columns[:formoptions] =  {:rowpos=>i["screenfield_rowpos"] ,:colpos=>i["screenfield_colpos"] ,
															:maxlength => i["screenfield_maxlength"] ||= i["screenfield_edoptsize"]}
					end
					tmp_columns.delete(:editoptions)  if  tmp_columns[:editoptions].nil?
			end  	      ##
			tmp_columns[:formatter] = i["screenfield_formatter"]  if i["screenfield_formatter"]   
			if i["screenfield_indisp"] == 1 then tmp_editrules[:required] = true   else tmp_editrules[:required] = false end
		    if tmp_columns[:field] =~ /_id/
				tmp_columns[:editable] = true   ## テーブルのid として画面からの送信は必須
				tmp_columns[:formoptions] =  {:rowpos=> icnt += 1,:colpos=>1 }
				tmp_editrules[:number] = true
			end  
			tmp_columns[:editrules] = tmp_editrules
			gridcolumns << tmp_columns 
            allfields << i["pobject_code_sfd"].to_sym  #**
            alltypes [i["pobject_code_sfd"].to_sym] =  i["screenfield_type"].downcase
			if i["screenfield_paragraph"]
			   paragraph << {:pobject_code_sfd=>i["pobject_code_sfd"],:screenfield_paragraph=>i["screenfield_paragraph"]}
			end
        end   ## screenfields.each
	    show_data[:allfields] =  allfields  
        show_data[:alltypes]  =  alltypes  
        show_data[:screen_code_view] = screen_code_view
        show_data[:gridcolumns] = gridcolumns
		show_data[:paragraph] = paragraph
        show_cache_key =  "show" + screen_code +  sub_blkget_grpcode
	    ## logger.debug "line #{__LINE__} show_cache_key:#{show_cache_key}"
        Rails.cache.write(show_cache_key,show_data) 
	return show_data
    end    ##set_detai
 end
 