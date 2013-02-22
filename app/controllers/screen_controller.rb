#### v081
## 同一login　userではviewとscreenは一対一
### show_data   画面の対するviewとその項目をユーザー毎にセット
class ScreenController < ApplicationController
  before_filter :authenticate_user!  
  respond_to :html , :json
  def index
      ###  @screenname_name  将来　タイトルに変更
     ## debugger
     @scriptopt ={}
     @options = {}
     @scriptopt[:pare_contents] = ""
     @options[:div_repl_id] = ""
     @options[:autowidth] = "true"
     get_screen_code
     @disp_screenname_name = getblkpobj(screen_code,"A")
     view_item_set
     ### set_detail screen_code => "",@div_id => "" ,sqlstr =>""  ###親の画面だからnst なし
    fprnt " class #{self} : LINE #{__LINE__}  index  @disp_screenname_name  : #{  @disp_screenname_name }"
    fprnt " class #{self} : LINE #{__LINE__}  index  @gridcolumns : #{ @gridcolumns}"
    ## debugger ## 詳細項目の確認
   end  ##index

  def  view_item_set   
      ##  debugger ## 詳細項セット
      ### buttonの時は画面が変わるので
      ### 保持しているデータは削除
      # @session_data[:person_id] = plsql.persons.first(:email =>current_user[:email])[:id]   ###########   LOGIN USER  
      @options[:grp_search_form] = true if  screen_code =~ /^H\d_/
      @extbutton  = show_data[:extbutton] 
      @extdiv_id  = show_data[:extdiv_id]  
      @scriptopt[:scriptopt]  = show_data[:scriptopt] 
      @gridcolumns =  show_data[:gridcolumns] 

  end  ## user_screen
  
  def disp   ##  jqgrid返り
   ## debugger ## 詳細項目セット
   params[:page] ||= 1 
   params[:rows] ||= 10
   ## get from cache
   #### subpaging delay
   get_screen_code
   subpaging           ## subpaging 
   ##  p " @tbldata  :  #{@tbldata}"
   #fprnt  " class #{self} : LINE #{__LINE__} @record_count :  #{@record_count}"
   ### debugger
   respond_with @tbldata.to_jqgrid_json( show_data[:allfields] ,params[:page], params[:rows],@record_count) 
  end  ##disp

  def sub_params_set view_name  ###   日付と数字で<>の比較ができてない
      show_data[:allfields].each do |i|
          unless params[i].nil? then 
             command_r[i] = params[i] 
             case show_data[:alltypes][i]
                  when "DATE" then
                         command_r[i] = Time.parse(command_r[i]) 
                  when "NUMBER"
                         command_r[i] = command_r[i].to_f
             end
           end  ## unless
      end
      return command_r
  end ## def sub_params_set view_name

  def nst  ###子画面　link
     rcd_id  =  params[:id]  ### 親画面テーブル内の子画面へのkeyとなるid
     pare_view =  params[:nst_tbl_val].split(";")[0]   ### 親のview
     chil_view =  params[:nst_tbl_val].split(";")[1]   ### 子のview
     @disp_screenname_name =  getblkpobj(params[:nst_tbl_val].split(";")[2],"A")   ### 子の画面
     cnt_detail =  params[:nst_tbl_val].split(";")[3]   ### 子の画面位置
     ##########
     @nst_screenname_id = "#{pare_view};#{chil_view}"
     @scriptopt = {}
     @options ={}
     @options[:div_repl_id] = "#{@nst_screenname_id}"   ### 親画面内の子画面表示のための　div のid
     @options[:autowidth] = "true"  
     @screen_code = plsql.screens.first("where viewname = '#{chil_view}' and Expiredate > sysdate order by expiredate ")[:code].upcase  ## set @gridcolumns 
     screen_code
     view_item_set 
     ## debugger 
     ## p "chil_view : #{chil_view.downcase}  : #{@nst_screenname_id} : "#{@disp_screenname_name} "
     ## p "{pare_view}{chil_view} : #{pare_view}#{chil_view}   :xxx: #{ params[:nst_tbl_val].split(";")[2]}" 
      rcd_id_cache_key = "RCD_ID" + current_user[:id].to_s + @nst_screenname_id 
      ### set_detail でセットされた@nst_screenname_id
      hash_rcd = {}
      hash_rcd["#{pare_view[2..-2]}_id".downcase.to_sym] = rcd_id 
      hash_rxd[:strsql] = "(select * from #{chil_view} where #{pare_view[2..-2]}_id = '#{rcd_id}' )  a "
      Rails.cache.write(rcd_id_cache_key,hash_rcd)   ### add で受け取るための親　id save
      set_pare_contents pare_view,rcd_id      ## 
     ##  debugger 
     ## render :nst
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
          unless dispfields.nil? then
             dispfields.each do |i|
                if i[:detailfield_code] =~ /CODE/ then
                  fprnt "class #{self} : LINE #{__LINE__}  i[:detailfield_code] : #{i[:detailfield_code] } " 
                   @scriptopt[:pare_contents] << pare_data[i[:detailfield_code].downcase.to_sym] 
                   tname =i[:detailfield_code].gsub(/CODE/,"NAME").downcase.to_sym
                   @scriptopt[:pare_contents] << " (" + pare_data[tname]  + ")     "
                end
             end 
             dispfields.each do |i|
                unless i[:detailfield_code] =~ /CODE/ then
                   @scriptopt[:pare_contents] << getblkpobj(i[:detailfield_code],"1")  ### LOGIN_USER_ID
                   @scriptopt[:pare_contents] << " (" + pare_data[i[:detailfield_code].downcase.to_sym].to_s  + ")   "
                end
             end
          end  ### unless dispfields.nil? then
     end  ### if   @scriptopt[:pare_contents].empty?
  fprnt " class #{self} : LINE #{__LINE__}  nst @scriptopt[:pare_contents]  : #{@scriptopt[:pare_contents]}"
 end    ### def set_pare_contents pare_view,rcd_id
 ### formで矢印がきかない
 def add_upd_del    ##  add update delete
     params[:oper] = "add" if  params[:copy] == "yes"   ### copy and add
     tblfields = sub_set_fields_from_allfields
     case params[:oper] 
       when "add"
          rcd_id_cache_key = "RCD_ID" + current_user[:id].to_s +  params[:q]  ### :q -->@nst_screenname_id
          hash_rcd = Rails.cache.read(rcd_id_cache_key)  
          tmp_isnr =  tblfields
          fprnt " class #{self} : LINE #{__LINE__}  hash_rcd  #{hash_rcd}"  unless hash_rcd.nil?
          fprnt " class #{self} : LINE #{__LINE__} hash_rcd  nil nil"  if hash_rcd.nil?
          tmp_isnr.merge! hash_rcd unless hash_rcd.nil?
          sub_insert_sio_c  do 
             command_r[:sio_classname] = "plsql_blk_insert"
             sub_add_upd_del_setsio(tmp_isnr)
             command_r[:id_tbl] = nil
          end
       when "del"
          sub_insert_sio_c   do
             command_r[:sio_classname] = "plsql_blk_delete"
             sub_add_upd_del_setsio( tblfields)
             command_r[:id_tbl] = tblfields[:id_tbl].to_i
          end
       when "edit"
	 ### debugger
         sub_insert_sio_c   do
           command_r[:sio_classname] = "plsql_blk_update"
           sub_add_upd_del_setsio( tblfields)
           command_r[:id_tbl] = tblfields[:id_tbl].to_i
           ### p "tblfields[:id_tbl] : #{tblfields[:id_tbl]}"
         end
       else     
       ##debugger ## textは表示できないのでメッセージの変更要
       render :text => "return to menu because session loss params:#{params[:oper]} "
     end ## case parems[:oper]
     ### debugger
    dbcud = DbCud.new
    dbcud.perform(command_r[:sio_session_counter],"SIO_#{command_r[:sio_viewname]}")
 end  ## add_upd_del
 #####
 def proc_add_button    ### 
     sub_insert_sio_c  do
	   command_r[:id_tbl] = sub_set_fields_from_allfields[:id_tbl].to_i 
           command_r[:sio_classname]  = params[:button_proc]
           rowdata = {}
           ####  なぜ　iはsymでないの?
           params[:rowdata].except("msg_ok_ng","id").each_key do |i|
             rowdata[i.to_sym] =  params[:rowdata][i] 
           end  
           sub_add_upd_del_setsio(rowdata)  
           ### screenの時は画面が変わるので
           ### 保持しているデータは削除
           ##  Rails.cache.clear if  command_r[:sio_viewname]  == "r_screens"       

        end   ###proc_add_button  
 end   ## proc_add_button  
 def set_extbutton pare_screen     ### 子画面用のラジオボ タンセット
      ##  debugger
      ### 同じボタンで有効日が>sysdateのデータが複数あると複数ボタンがでる
      rad_screen = plsql.r_chilscreens.select(:all,"where chilscreen_Expiredate > sysdate 
                                            and screen_id = :1",pare_screen)
           t_extbutton = ""
           t_extdiv_id = ""
           k = 0
           rad_screen.each do |i|     ###child tbl name sym
               ### view name set
               hash_key = "#{i[:screen_viewname].downcase}".to_sym 
                  k += 1
                  t_extbutton << %Q|<input type="radio" id="radio#{k.to_s}"  name="nst_radio#{@nst_screenname_id}"|
                  t_extbutton << %Q| value="#{i[:screen_viewname]};#{i[:screen_viewname_chil]};| ### 親のview
                  t_extbutton << %Q|#{i[:screen_code_chil]};1"/>|  
                  t_extbutton << %Q| <label for="radio#{k.to_s}">  #{getblkpobj(i[:screen_code_chil],"A")} </label> |
                  t_extdiv_id << %Q|<div id="div_#{i[:screen_viewname]}#{i[:screen_viewname_chil]}"> </div>|
      
        end   ### rad_screen.each
	@scriptopt = {}
        @scriptopt[:pare_contents] = ""
        show_data[:extbutton] =  t_extbutton
	show_data[:extdiv_id] =  t_extdiv_id
	
  end    ## set_extbutton pare_screen  
  def subpaging
      ### debugger
           tmp_session_counter = sub_insert_sio_c  do
           command_r[:sio_start_record] = (params[:page].to_i - 1 ) * params[:rows].to_i + 1
           command_r[:sio_end_record] = params[:page].to_i * params[:rows].to_i 
           command_r[:sio_sord] = params[:sord]
           command_r[:sio_search] = params[:_search] 
           sub_params_set(command_r[:sio_viewname]) if params[:_search]  == "true" 
           command_r[:sio_sidx]  = params[:sidx]
	   command_r[:sio_classname] = "plsql_blk_paging"
      end
      plsql_blk_paging
##      debugger # breakpoint   
##      $ts.take(["R",request.remote_ip,params[:q],tmp_session_counter,"SIO_#{command_r[:sio_viewname]}"])
###      $ts.take(["R",request.remote_ip,params[:q],command_r[:session_counter],"sio_#{command_r[:sio_viewname]}"],10)
      const = "R"
      
      ##  debugger # breakpoint
      rcd =  plsql.__send__("SIO_#{command_r[:sio_viewname]}").all("where sio_term_id = :1 and sio_session_id = :2
                                                        and sio_session_counter = :3
                                                        and sio_command_response = :4",
                                                        request.remote_ip,params[:q],
                                                        tmp_session_counter,const)
      @tbldata = []
      
       #### debugger
      
      for j in 0..rcd.size - 1
          tmp_data = {}
          show_data[:allfields].each do |k|
           k_to_s =  k.to_s 
           tmp_data[k] = rcd[j][k] if k_to_s != "id"        ## 2dcのidを修正したほうがいいのかな
           tmp_data[k] = rcd[j][:id_tbl] if k_to_s == "id"  ##idは2dcでは必須
           tmp_data[k] = rcd[j][k].strftime("%Y-%m-%d") if k_to_s =~ /expiredate/ and  !rcd[j][k].nil?
          end 
          @tbldata << tmp_data
      end ## for
      @record_count = 0
      @record_count = rcd[0][:sio_totalcount] unless rcd.empty?
  end  ##subpaging
  def sub_insert_sio_c  
      ## debugger
      sub_set_fields_from_allfields 
      command_r[:person_id_upd] = plsql.persons.first(:email =>current_user[:email])[:id]  ||= 1  ###########   LOGIN USER  
      command_r[:sio_viewname]  = plsql.screens.first("where code = '#{screen_code}' and Expiredate > sysdate order by expiredate ")[:viewname]
      command_r[:sio_code]  = screen_code
      command_r[:id] =  plsql.__send__("SIO_#{command_r[:sio_viewname]}_SEQ").nextval
      command_r[:sio_term_id] =  request.remote_ip
      command_r[:sio_session_id] = params[:q]
      command_r[:sio_command_response] = "C"
      command_r[:sio_session_counter] = plsql.sessioncounters_seq.nextval  ### user_id に変更
      command_r[:sio_add_time] = Time.now
      command_r.delete(:msg_ok_ng)  ## sioに照会・更新依頼時は更新結果は不要
      yield
      ### remark とcodeがnumberになっていた。原因不明　2011-09-19
      fprnt " class #{self} : LINE #{__LINE__} sio_\#{ command_r[:sio_viewname] } :sio_#{command_r[:sio_viewname]}"
      fprnt " class #{self} : LINE #{__LINE__} command_r #{command_r}"
      ## debugger
      plsql.__send__("SIO_#{command_r[:sio_viewname]}").insert command_r
      plsql.commit 
##    p Time.now
##      $ts.write(["C",request.remote_ip,params[:q],command_r[:sio_session_counter],"SIO_#{command_r[:sio_viewname]}"])
       return  command_r[:sio_session_counter]
  end   ## sub_insert_sio_c 
  def sub_strsql 
      tmp_str = plsql.screens.first("where code = '#{screen_code}' and Expiredate > sysdate order by expiredate ")
      unless tmp_str.nil? then
        strsql = " ( "  unless tmp_str[:strselect].nil?
        strsql << tmp_str[:strselect] unless tmp_str[:strselect].nil?
        strsql << tmp_str[:strwhere] unless tmp_str[:strwhere].nil?
        strsql << tmp_str[:strgrouporder] unless tmp_str[:strgrouporder].nil?
        strsql << " ) a "  unless tmp_str[:strselect].nil?
      end   
     strsql = nil if strsql == ""
     return strsql
  end
  def sub_set_fields_from_allfields 
      get_screen_code 
     ### debugger  
     @command_r = {}
     show_data[:allfields].each do |j|
        @command_r[j] = params[j]  unless j.to_s  == "id"  ## sioのidとｖｉｅｗのｉｄが同一になってしまう
        @command_r[:id_tbl] = params[j] if j.to_s == "id"          
    end ##
    command_r
  end  
  def command_r
      @command_r
  end
   def get_screen_code 
      ## debugger ## 画面の項目
      if params[:action]  == "index"  then  ## listからの初期画面の時
         @screen_code = @nst_screenname_id  = params[:id].upcase
      else
        if  params[:q].split(';')[2].nil?   then ## 
            @screen_code = @nst_screenname_id   =  params[:q].split(';')[0].to_s.upcase 
        else    ###子画面の時
	 @nst_screenname_id   =  params[:q].split(';')[0].to_s.upcase + ";" + params[:q].split(';')[1].to_s.upcase
         @screen_code = params[:q].split(';')[1].to_s.upcase
        end
      end
     screen_code
     get_show_data
  end
  def screen_code
      @screen_code
  end
    def  sub_getfield
       strfields = []
       command_r.each  do |i,j|
          tmp_field = i.to_s 
          unless  tmp_field =~ /^sio_/  then
             unless  tmp_field == "id_tbl" then
               strfields <<  tmp_field
             end 
          end  ## unless  unless i.to_s =~ /^sio_/ 
       end   ## command_r.each
       strfields =  strfields.join(",") 
       return strfields
  end   ##  sub_getfield

  def plsql_blk_paging  
    command_r[:id] = nil
    #####   strsqlにコーディングしてないときは、viewをしよう
####     strdql はupdate insertには使用できない。
    
	command_r[:sio_strsql] = sub_strsql

    tmp_sql = if command_r[:sio_strsql].nil? then command_r[:sio_viewname]  + " a " else command_r[:sio_strsql] end
          
    strsql = "SELECT * FROM " + tmp_sql
    fprnt "class #{self} : LINE #{__LINE__}  strsql = '#{strsql}"
    tmp_sql << sub_strwhere  if command_r[:sio_search]  == "true"
    tmp_sql << "  order by " +  command_r[:sio_sidx] + " " +  command_r[:sio_sord]  unless command_r[:sio_sidx].nil? or command_r[:sio_sidx] == ""
    cnt_strsql = "SELECT 1 FROM " + tmp_sql 
    fprnt "class #{self} : LINE #{__LINE__}   cnt_strsql = '#{cnt_strsql}'"
    ## debugger
    command_r[:sio_totalcount] =  plsql.select(:all,cnt_strsql).count  
    case  command_r[:sio_totalcount]
    when nil,0   ## 該当データなし
         ## insert_sio_r recodcount,result_f,contents
         contents = "not find record"    ### 将来usergroup毎のメッセージへ
	 command_r[:sio_recordcount] = 0
         command_r[:sio_result_f] = "1"
         command_r[:sio_message_contents] = contents
         insert_sio_r  command_r

    else      
         strsql = "select #{sub_getfield} from (SELECT rownum cnt,a.* FROM #{tmp_sql} ) "
         r_cnt = 0
         strsql  <<    " WHERE  cnt <= #{command_r[:sio_end_record]}  and  cnt >= #{command_r[:sio_start_record]} "
         fprnt " class #{self} : LINE #{__LINE__}   strsql = '#{ strsql}' "
         pagedata = plsql.select(:all, strsql)
         pagedata.each do |j|
           r_cnt += 1
           ##   command_r.merge j なぜかうまく動かない。
           j.each do |j_key,j_val|
             command_r[j_key]   = j_val unless j_key.to_s == "id" ## sioのidとｖｉｅｗのｉｄが同一になってしまう
             command_r[:id_tbl] = j_val if j_key.to_s == "id"
           end  
           ## debugger
             command_r[:sio_recordcount] = r_cnt
             command_r[:sio_result_f] = "0"
             command_r[:sio_message_contents] = nil
           insert_sio_r  command_r
	 end ##    plsql.select(:all, "#{strsql}").each do |j|
    end   ## case
  ### p  "e: " + Time.now.to_s 
  plsql.commit
  end   ###plsql_paging
  def  sub_strwhere
       command_r[:sio_strsql] = sub_strsql
       unless command_r[:sio_strsql].nil? then
          strwhere = unless command_r[:sio_strsql].upcase.split(")")[-1] =~ /WHERE/ then  " WHERE "  else " and " end
          else
           strwhere = " WHERE "
       end
       command_r.each  do |i,j|
          unless i.to_s =~ /^sio_/ then
             unless j.to_s.empty? then             
               tmpwhere = " #{i.to_s} = '#{j}'  AND " 
               tmpwhere = " #{i.to_s} like '#{j}'  AND " if j =~ /^%/ or j =~ /%$/ 
               if j =~ /^<=/  or j =~ /^>=/ then 
                  tmpwhere = " #{i.to_s} #{j}[0..1] '#{j}[2..-1]'  AND "
                else
                if j =~ /^</   or  j =~ /^>/ then 
                   tmpwhere = " #{i.to_s}  #{j}[0]  '#{j}[1..-1]'  AND "
                end  ## else
            end   ## if j
            strwhere << tmpwhere 
           end ## unless empty 
          end  ## unless  unless i.to_s =~ /^sio_/ 
       end   ## command_r.each
       return strwhere[0..-7]
  end   ## sub_strwhere


 def set_addbutton pare_screen 
      buttonopt = []
      add_button = plsql.r_buttons.select(:all,"where button_Expiredate > sysdate 
                                            and screen_id = :1",pare_screen)
      unless add_button.empty?
	      add_button.each do |x|
                 tmp_buttonopt = {}
                 tmp_buttonopt[:button_icon] = x[:button_icon]
                 tmp_buttonopt[:button_title] = x[:button_title]
                 tmp_buttonopt[:button_proc] = x[:button_proc]
                 buttonopt << tmp_buttonopt
             end 
	     fprnt "class #{self} : LINE #{__LINE__}   buttonopt :#{  buttonopt }"
             fprnt "class #{self} : LINE #{__LINE__}  add_button :#{ add_button }"
        end
      return  buttonopt 
  end   ### set_addbutton pare_screen 
  ################
  
  def set_detail 
      @show_data = {}
      show_data
      det_screen = plsql.r_detailfields.all(
                                "where screen_code = '#{screen_code}'
                                 and detailfield_selection = 1 order by detailfield_seqno ")  ###有効日の考慮
                                 
           ## when no_data 該当データ 「r_DetailFields」が無かった時の処理
           if det_screen.empty?
              ### debugger ## textは表示できないのでメッセージの変更要
	      p  "Create DetailFields #{screen_code} by crt_r_view_sql.rb"
              render :text => "Create DetailFields #{screen_code} by crt_r_view_sql.rb"  and return 
           end   
           ###
           ### pare_screen = det_screen[0][:detailfield_screens_id]
           pare_screen = det_screen[0][:screen_id]
           screen_viewname = det_screen[0][:screen_viewname].upcase
           ### debugger ## 詳細項目セット
           show_data[:scriptopt] = set_addbutton(pare_screen)     ### add  button セット script,gear,....
	   gridcolumns = []
           ###  chkの時のみ
           gridcolumns   << {:field => "msg_ok_ng",
                                        :label => "msg",
                                        :width => 37,
                                        :editable =>  false  } 
           allfields = []
           allfields << "msg_ok_ng".to_sym
           alltypes = {} 
	   icnt = 0
	   det_screen.each do |i|  
                ## lable名称はユーザ固有よりセット    editable はtblから持ってくるように将来はする。
                ##    fprnt " i #{i}"
                   tmp_editrules = {}
                   tmp_columns = {}
                   tmp_editrules[:required] = true  if i[:detailfield_indisp] == 1
                   tmp_editrules[:number] = true if i[:detailfield_type] == "NUMBER"
                   tmp_editrules[:date] = true  if i[:detailfield_type] == "DATE"
                   tmp_editrules[:required] = false  if tmp_editrules == {} 
                   tmp_columns[:field] = i[:detailfield_code].downcase
                   tmp_columns[:label] = getblkpobj(i[:detailfield_code],"1") 
                   tmp_columns[:label] ||=  i[:detailfield_code]
                   tmp_columns[:hidden] = if i[:detailfield_hideflg] == 1 then true else false end 
                   tmp_columns[:editrules] = tmp_editrules 
                   tmp_columns[:width] = i[:detailfield_width]
                   tmp_columns[:search] = if i[:detailfield_paragraph]  == 0 and  screen_code =~ /^H\d_/   then false else true end
                   if i[:detailfield_editable] == 1 then
		      tmp_columns[:editable] = true
		      tmp_columns[:editoptions] = {:size => i[:detailfield_edoptsize],:maxlength => i[:detailfield_maxlength] ||= i[:detailfield_edoptsize] }
		     else
		      tmp_columns[:editable] = false
		   end
		   tmp_columns[:edittype]  =  i[:detailfield_type]  if  ["textarea","select","checkbox"].index(i[:detailfield_type]) 
		   if i[:detailfield_type] == "SELECT" or  i[:detailfield_type] == "CHECKBOX" then
		      tmp_columns[:editoptions] = {:value => i[:detailfield_value] } 
		   end
		   if i[:detailfield_type] == "textarea" then
		      tmp_columns[:editoptions] =  {:rows =>"#{i[:detailfield_edoptrow]}",:cols =>"#{i[:detailfield_edoptcols]}"}
		   end
                   if  tmp_columns[:editoptions].nil? then  tmp_columns.delete(:editoptions)  end 
                   ## tmp_columns[:edittype]  =  i[:detailfield_type]  if  ["textarea","select","checkbox"].index(i[:detailfield_type]) 
		   ## debugger
                   unless  i[:detailfield_rowpos].nil?    then
                        tmp_columns[:formoptions] =  {:rowpos=>i[:detailfield_rowpos] ,:colpos=>i[:detailfield_colpos] }
		        if  i[:detailfield_rowpos] = 999 then
                            tmp_columns[:formoptions] =  {:rowpos=> icnt += 1,:colpos=>1 }
			end
		   end 	      
		   gridcolumns << tmp_columns 
                   allfields << i[:detailfield_code].downcase.to_sym  
                   alltypes [i[:detailfield_code].downcase.to_sym] =  i[:detailfield_type].downcase 
           end   ## detailfields.each
	   show_data[:allfields] =  allfields  
           show_data[:alltypes]  =  alltypes  
           show_data[:screen_viewname] = screen_viewname.upcase
           show_data[:gridcolumns] = gridcolumns
	   set_extbutton(pare_screen) 
        show_cache_key =  "show " + screen_code
        Rails.cache.write(show_cache_key,show_data) 
  end    ##set_detai
  def sub_add_upd_del_setsio tblfields
	   tblfields.each_key do |ii|     ### tblfields  paramsをsio用に変換したもの
           if !tblfields[ii].nil?   and ii.to_s != "id_tbl"   ###   sub_set_fields_from_allfields参照 
              tmp_type = plsql.DETAILFIELDS.first(" where code = '#{ii.to_s.upcase}' and Expiredate > sysdate order by expiredate ") 
          ##  debugger
              tmp_type = unless  tmp_type.nil? then  tmp_type[:type] else "" end
              case tmp_type
	      ### 日付項目が画面から入力されなければ当日をセット　いやなら必須項目にする。
              when "DATE","TIMESTAMP(6)" then
		      command_r[ii] =  if tblfields[ii] == "" then Time.now else Time.parse(tblfields[ii])  end
              when "NUMBER"
                   command_r[ii] = tblfields[ii].to_f
              else
                   command_r[ii] = tblfields[ii]
              end
           end  ## if    !params[ii].nil?  
           end   ## do |ii|
           render :nothing => true
     tmp_isnr = {}
     show_data[:allfields].each do|j|
        tmp_isnr[j] = params[j]  unless j.to_s  == "id"  ## sioのidとｖｉｅｗのｉｄが同一になってしまう
        tmp_isnr[:id_tbl] = params[j] if j.to_s == "id"          
    end ##    
    ### debugger
    return tmp_isnr
 end  
  def get_show_data 
     show_cache_key =  "show " + screen_code
     ## debugger
     if Rails.cache.exist?(show_cache_key) then 
         @show_data = Rails.cache.read(show_cache_key)
	 show_data
     else 
	 set_detail   ## set @gridcolumns 
     end
     ##  debugger
 end
 def show_data
     @show_data
 end

end ## ScreenController
