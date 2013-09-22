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
  def fprnt str
    foo = File.open("#{Rails.root}/log/blk#{Process::UID.eid.to_s}.log", "a") # 書き込みモード
    foo.puts str
    foo.close
  end   ##fprnt str
  
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
  def set_detail screen_code
      show_data = {}  
      det_screen = plsql.r_screenfields.all(
                                "where pobject_code_scr = '#{screen_code}'  
                                 and screenfield_expiredate > sysdate 
                                 and screenfield_selection = 1 order by screenfield_seqno ")  ###
                                 
           ## when no_data 該当データ 「r_screenfields」が無かった時の処理
           if det_screen.empty?
              ###debugger ## textは表示できないのでメッセージの変更要
	      fprnt  "Create screenfields #{screen_code} by crt_r_view_sql.rb"
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
	   evalstr = ""
	   det_screen.each do |i|  
                ## lable名称はユーザgroup固有よりセット    editable はtblから持ってくるように将来はする。
                ##fprnt " i #{i}"
                   tmp_editrules = {}
                   tmp_columns = {}
                   tmp_editrules[:required] = true  if i[:screenfield_indisp] == 1
                   tmp_editrules[:number] = true if i[:screenfield_type] == "number"
                   tmp_editrules[:date] = true  if i[:screenfield_type] == "date" or i[:screenfield_type]  =~ /^timestamp/
		   tmp_editrules[:required] = false  if tmp_editrules == {} 
                   tmp_columns[:field] = plsql.pobjects.first("where id =  #{i[:screenfield_pobject_id_sfd]} ")[:code]   ##**
                   tmp_columns[:label] = sub_blkgetpobj( tmp_columns[:field] ,"view_field")  ##:viewの項目
                   ### tmp_columns[:label] ||=  i[:screenfield_code]
                   tmp_columns[:hidden] = if i[:screenfield_hideflg] == 1 then true else false end 
                   tmp_columns[:editrules] = tmp_editrules 
                   tmp_columns[:width] = i[:screenfield_width]
                   tmp_columns[:search] = if i[:screenfield_paragraph]  == 0 and  screen_code =~ /^H\d_/   then false else true end 
		   if i[:screenfield_editable] == 1 then
		      tmp_columns[:editable] = true
		      tmp_columns[:editoptions] = {:size => i[:screenfield_edoptsize],:maxlength => i[:screenfield_maxlength] ||= i[:screenfield_edoptsize] }  if i[:screenfield_type] == "text"
		     else
		      tmp_columns[:editable] = false
		   end
		   tmp_columns[:edittype]  =  i[:screenfield_type]  if  ["textarea","select","checkbox","text"].index(i[:screenfield_type]) 
		   if i[:screenfield_type] == "select" or  i[:screenfield_type] == "checkbox" then
		      strselect = get_select_list_value(i[:screenfield_edoptvalue])
		      tmp_columns[:editoptions] = {:value => eval(strselect) } 
		      tmp_columns[:formatter] = "select"
		      tmp_columns[:searchoptions] = {:value => eval(strselect) } 
		   end
		   if i[:screenfield_type] == "textarea" then
		      tmp_columns[:editoptions] =  {:rows =>"#{i[:screenfield_edoptrow]}",:cols =>"#{i[:screenfield_edoptcols]}"}
		   end
                   if  tmp_columns[:editoptions].nil? then  tmp_columns.delete(:editoptions)  end 
                   ## tmp_columns[:edittype]  =  i[:screenfield_type]  if  ["textarea","select","checkbox"].index(i[:screenfield_type]) 
		   ##debugger
                   if  i[:screenfield_rowpos]     then
			if  i[:screenfield_rowpos]  < 999
                            tmp_columns[:formoptions] =  {:rowpos=>i[:screenfield_rowpos] ,:colpos=>i[:screenfield_colpos] }
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
		   evalstr << i[:screenfield_rubycode] if i[:screenfield_rubycode] 
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
               jqgrid_id   =  params[:q]
	       screen_code = params[:q]  if params[:q].split('_div_')[1].nil?    ##子画面無
               screen_code = params[:q].split('_div_')[1]  if params[:q].split('_div_')[1]    ##子画面
          when params[:action]  == "index"   
               jqgrid_id  = params[:id]   ## listからの初期画面の時 とcodeを求める時
	       screen_code = params[:id]  if params[:id].split('_div_')[1].nil?    ##pop up無
	       screen_code = params[:id].split("_div_")[1] if params[:id].split('_div_')[1] 
          when params[:nst_tbl_val] then
               jqgrid_id   =  params[:nst_tbl_val]
               screen_code =  params[:nst_tbl_val].split("_div_")[1]  ###chil_scree_code
	end
     return screen_code,jqgrid_id
  end
  def get_select_list_value edoptvalue 
     edoptvalue.scan(/'\w*'/).each do |i|
	 j = i.gsub("'","")
	 edoptvalue =  edoptvalue.sub(j,sub_blkgetpobj(j,"fix_char"))
     end
     return edoptvalue
<<<<<<< HEAD
  end
  def sub_gantt_chart screen_code,id
      ngantts = []
      time_now =  Time.now 
      ## {n0[:itm_id]} and locas_id = #{n0[:loca_id]} and processseq = #{n0[:processseq]} and priority = #{n0[:priority]}
      case screen_code
      when /^r_itms/
          itm = plsql.itms.first("where id = '#{id}'  ")
          r = plsql.opeitms.first("where itms_id = #{id} and Expiredate > sysdate   order by processseq desc,priority desc")
      end
     ##debugger
     if r then 
        ngantts << {:seq=>"001",:mlevel=>1,:itm_id=>r[:itms_id],:loca_id=>r[:locas_id],:processseq=>r[:processseq],:priority=>r[:priority],:endtime=>time_now}
        cnt = 0
        @bgantts = {}
        @bgantts[:"000"] = {:mlevel=>0,:itm_code=>itm[:code],:itm_name=>itm[:name],:loca_code=>"",:loca_name=>"",:duration=>"",:assigs=>"",:endtime=>time_now,:starttime=>nil,:depends=>""}
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
     @bgantts.sort.each  do|key,value|
        id += 1
        @bgantts[key].merge! :id=>id,:level=>1   
        if key.to_s.size > 3 then
           @bgantts[key.to_s[0..-4].to_sym][:depends] << id.to_s + "," 
           @bgantts[key.to_s[0..-4].to_sym][:level] += 1 if @bgantts[key.to_s[0..-4].to_sym][:level] <= @bgantts[key][:level]
        end
        min_starttime = @bgantts[key][:starttime] if  min_starttime > (@bgantts[key][:starttime]||= time_now)
     end
     @bgantts[:"000"][:starttime] = min_starttime 
     @bgantts[:"000"][:duration] =   ((@bgantts[:"000"][:endtime]  - min_starttime).divmod(24*60*60))[0]
     strgantt = %Q|{"tasks":[|
     @bgantts.sort.each  do|key,value|
     strgantt << %Q|{"id":"#{value[:id]}","itm_code":"#{value[:itm_code]}","itm_name":"#{value[:itm_name]}","loca_code":"#{value[:loca_code]}","loca_name":"#{value[:loca_name]}","pare_num":"#{value[:pare_num]}","chil_num":"#{value[:chil_num]}","start":#{value[:starttime].to_i.*1000},"duration":#{value[:duration]},"end":#{value[:endtime].to_i.*1000},"assigs":[],"depends":"#{value[:depends]}","level":"#{value[:level]}","mlevel":"#{value[:mlevel]}"},|
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
    p " Line #{__LINE__} #{bgantt}"
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
=======
  end 
>>>>>>> 30f97172d06078e511be82b23917b4cf8fafaf24
end
