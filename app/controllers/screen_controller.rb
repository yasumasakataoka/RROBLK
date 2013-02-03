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
     screen_code = sub_screen_code
     @disp_screenname_name = getblkpobj(screen_code,"A")
     view_item_set screen_code
     ### set_detail screen_code => "",@div_id => "" ,sqlstr =>""  ###親の画面だからnst なし
    fprnt " class #{self} : LINE #{__LINE__}  index  @disp_screenname_name  : #{  @disp_screenname_name }"
    fprnt " class #{self} : LINE #{__LINE__}  index  @gridcolumns : #{ @gridcolumns}"
    ##   debugger ## 詳細項目の確認
   end  ##index
  def sub_screen_code 
      ## debugger ## 画面の項目
       params[:q] = params[:id] if params[:action]  == "index"   ## listからの初期画面の時
      if  params[:q].split(';')[2].nil?   then ## 
         @nst_screenname_id   =  params[:q].split(';')[0].to_s.upcase 
	 screen_code = @nst_screenname_id
       else    ###子画面の時
	 @nst_screenname_id   =  params[:q].split(';')[0].to_s.upcase + ";" + params[:q].split(';')[1].to_s.upcase
         screen_code = params[:q].split(';')[1].to_s.upcase
     end
     return screen_code
  end

  def  view_item_set screen_code
       show_data = get_show_data  screen_code 
	##	  debugger ## 詳細項セット
      ### buttonの時は画面が変わるので
      ### 保持しているデータは削除
      session_data[:person_id] = plsql.persons.first(:email =>current_user[:email])[:id]   ###########   LOGIN USER  
      @options[:grp_search_form] = true if  screen_code =~ /^H\d_/
      @extbutton  = show_data[:radiobutton] ||= ""
      @exdiv_id  = show_data[:extdiv_id]  ||= ""
      @scriptopt[:scriptopt]  = show_data[:scriptopt] 
      @gridcolumns =  show_data[:gridcolumns] ||= {}

  end  ## user_screen
  
  def disp   ##  jqgrid返り
   ## debugger ## 詳細項目セット
   params[:page] ||= 1 
   params[:rows] ||= 10 
   ## get from cache
   #### subpaging delay
   show_data = get_show_data(sub_screen_code)  
   subpaging    show_data        ## subpaging 
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
     screen_code = plsql.screens.first("where viewname = '#{chil_view}' and Expiredate > sysdate order by expiredate ")[:code].upcase  ## set @gridcolumns 
     view_item_set screen_code
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
     tblfields = sub_set_fields_from_allfields sub_screen_code ,params
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
	 ## debugger
         sub_insert_sio_c   do
           command_r[:sio_classname] = "plsql_blk_update"
           sub_add_upd_del_setsio( tblfields)
           command_r[:id_tbl] = tblfields[:id_tbl].to_i
           ### p "tblfields[:id_tbl] : #{tblfields[:id_tbl]}"
         end
       else     
       ###debugger ## textは表示できないのでメッセージの変更要
       render :text => "return to menu because session loss params:#{params[:oper]} "
     end ## case parems[:oper]
     ## debugger
    dbcud = DbCud.new
    dbcud.perform(command_r[:sio_session_counter],"SIO_#{command_r[:sio_viewname]}")
 end  ## add_upd_del
 #####
 def proc_add_button    ### 
	 sub_insert_sio_c  do
           command_r[:sio_classname]  = params[:button_proc]
           command_r[:id_tbl] = sub_set_fields_from_allfields[:id_tbl].to_i sub_screen_code,params
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
 def set_radiobutton pare_screen     ### 子画面用のラジオボ タンセット
      ## debugger
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
	return {:radiobutton => t_extbutton, :extdiv_id => t_extdiv_id}
  end    ## set_radiobutton pare_screen  
  def subpaging show_data
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
      command_r[:sio_viewname]  = sub_screen_code.upcase
      command_r[:id] =  plsql.__send__("SIO_#{command_r[:sio_viewname]}_SEQ").nextval
      command_r[:sio_term_id] =  request.remote_ip
      command_r[:sio_session_id] = params[:q]
      command_r[:sio_command_response] = "C"
      command_r[:sio_session_counter] = plsql.sessioncounters_seq.nextval  ### user_id に変更
      command_r[:sio_add_time] = Time.now
      command_r.merge! sub_set_fields_from_allfields(sub_screen_code,params) 
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
      tmp_str = plsql.screens.first("where code = '#{sub_screen_code}' and Expiredate > sysdate order by expiredate ")
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

end ## ScreenController
