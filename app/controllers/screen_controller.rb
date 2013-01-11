#### v081
## 同一login　userではviewとscreenは一対一
### @session_show_data   画面の対するviewとその項目をユーザー毎にセット
class ScreenController < ApplicationController
  before_filter :authenticate_user!  
  respond_to :html , :json
  def index
     ## debugger ### jqgridの初期画面
     screendetail = {}
     if  params[:id].split(';')[2].nil?   then ## listからの初期画面の時
         @nst_screenname_id   =  params[:id].split(';')[0].to_s.upcase 
         @disp_screenname_name = getblkpobj(@nst_screenname_id,"A")
         screen_code = @nst_screenname_id
       else    ###子画面の時
         @disp_screenname_name  =  params[:id].split(';')[2].to_s.upcase   ##parent user 定義の画面名
         @nst_screenname_id   =  params[:id].split(';')[0].to_s.upcase +  params[:id].split(';')[1].to_s.upcase
         screen_code = params[:id].split(';')[1].to_s.upcase
     end
     ###  @screenname_name  将来　タイトルに変更
     ## debugger
     @scriptopt = {}
     @options = {}
     @scriptopt[:pare_contents] = ""
     @options[:div_repl_id] = ''
     @options[:autowidth] = "true"
     strsql = "" 
     tmp_str = plsql.screens.first("where code = '#{@nst_screenname_id}' and Expiredate > sysdate order by expiredate ")
     unless tmp_str.nil? then
        strsql = " ( "  unless tmp_str[:strselect].nil?
        strsql << tmp_str[:strselect] unless tmp_str[:strselect].nil?
        strsql << tmp_str[:strwhere] unless tmp_str[:strwhere].nil?
        strsql << tmp_str[:strgrouporder] unless tmp_str[:strgrouporder].nil?
        strsql << " ) a "  unless tmp_str[:strselect].nil?
     end   
     strsql = nil if strsql == ""
     set_detail strsql,screen_code  ## set @gridcolumns 
     ### set_detail screen_code => "",@div_id => "" ,sqlstr =>""  ###親の画面だからnst なし
    fprnt " class #{self} : LINE #{__LINE__}  index  @disp_screenname_name  : #{  @disp_screenname_name }"
    fprnt " class #{self} : LINE #{__LINE__}  index  @gridcolumns : #{ @gridcolumns}"

     ##   debugger ## 詳細項目の確認
   end  ##index
  
  def set_detail strsql,screen_code
      @session_show_data  = {}
      show_cache_key = "show " + current_user[:id].to_s + @nst_screenname_id
      ## debugger ## 詳細項目セット
      ### buttonの時は画面が変わるので
      ### 保持しているデータは削除
      Rails.cache.clear   ## if @nst_screenname_id  == "r_buttons" 

      @session_show_data = Rails.cache.read(show_cache_key) 
      @session_show_data ||= {}
      if   @session_show_data .empty? then
           det_screen = plsql.r_detailfields.all(
                                "where screen_code = '#{screen_code}'
                                 and detailfield_selection = 1 order by detailfield_seqno ")
                                 
           ## when no_data 該当データ 「r_DetailFields」が無かった時の処理
           if det_screen.empty?
              ### debugger ## textは表示できないのでメッセージの変更要
              render :text => "Create DetailFields #{@nst_screenname_id} by crt_r_view_sql.rb"  and return 
           end   
           ###
           ### pare_screen = det_screen[0][:detailfield_screens_id]
           pare_screen = det_screen[0][:screen_id]
           screen_viewname = det_screen[0][:screen_viewname]
           ## debugger ## 詳細項目セット
           set_addbutton pare_screen     ### add  button セット script,gear,....
           set_radiobutton pare_screen     ### 子画面用のラジオボタンセット
           
           @gridcolumns = []
           ###  chkの時のみ
           @gridcolumns   << {:field => "msg_ok_ng",
                                        :label => "msg",
                                        :width => 37,
                                        :editable =>  false  } 
           allfields = []
           allfields << "msg_ok_ng".to_sym
           alltypes = {}
           @session_show_data[:person_id] = plsql.persons.first(:email =>current_user[:email])[:id]
           ###########   LOGIN USER  
           det_screen.each do |i|  
                ## lable名称はユーザ固有よりセット    editable はtblから持ってくるように将来はする。
                   p" i #{i}"
                   tmp_editrules = {}
                   tmp_editrules[:required] = true  if i[:detailfield_indisp] == 1
                   tmp_editrules[:number] = true if i[:detailfield_type] == "NUMBER"
                   tmp_editrules[:date] = true  if i[:detailfield_type] == "DATE"
                   tmp_editrules[:required] = false  if tmp_editrules == {} 
                   tmp_columns   = {:field => i[:detailfield_code].downcase,
                                        :label => getblkpobj(i[:detailfield_code],"1"),
                                        :hidden => if i[:detailfield_hideflg] == 1 then true else false end , 
                                        :editrules => tmp_editrules ,
                                        :width => i[:detailfield_width],
                                        :search => if i[:detailfield_paragraph]  == 0 and  @nst_screenname_id =~ /^H\d_/   then false else true end,
                                        :editable =>  if i[:detailfield_editable] == 1 then true else false end,
                                       :editoptions => {:size => i[:detailfield_inputsize],:maxlength => i[:detailfield_maxlength] }  }
                    tmp_columns[:formoptions] =  {:rowpos=>i[:detailfield_rowpos] ,:colpos=>i[:detailfield_colpos] } if i[:detailfield_rowpos] <= 99  
                   @gridcolumns << tmp_columns 
                   allfields << i[:detailfield_code].downcase.to_sym  
                   alltypes [i[:detailfield_code].downcase.to_sym] =  i[:detailfield_type] 
           end   ## detailfields.each
           @session_show_data[:radiobutton] = @extbutton
           @session_show_data[:extdiv_id]  = @extdiv_id
           @session_show_data[:scriptopt] = @scriptopt
           @session_show_data[:allfields] =  allfields  
           @session_show_data[:alltypes]  =  alltypes  
           @session_show_data[:screen_viewname] = screen_viewname
           @session_show_data[:gridcolumns] = @gridcolumns
           @options[:grp_search_form] = true if  @nst_screenname_id =~ /^H\d_/
         else
           @extbutton  = @session_show_data[:radiobutton] 
           @extdiv_id  = @session_show_data[:extdiv_id]  
           @scriptopt  = @session_show_data[:scriptopt] 
           @gridcolumns =  @session_show_data[:gridcolumns] 
      end    
      @session_show_data[:strsql] = strsql
      Rails.cache.write(show_cache_key, @session_show_data) 
  end    ##set_detail
  
  def set_addbutton pare_screen 
      add_button = plsql.r_buttons.select(:all,"where button_Expiredate > sysdate 
                                            and screen_id = :1",pare_screen)
      unless add_button.empty?
             buttonopt = []
             add_button.each do |x|
                 tmp_buttonopt = {}
                 tmp_buttonopt[:button_icon] = x[:button_icon]
                 tmp_buttonopt[:button_title] = x[:button_title]
                 tmp_buttonopt[:button_proc] = x[:button_proc]
                 buttonopt << tmp_buttonopt
             end 
             @scriptopt[:addbutton] = buttonopt
             fprnt "class #{self} : LINE #{__LINE__}  @scriptopt[:addbutton] :#{ @scriptopt[:addbutton] }"
             fprnt "class #{self} : LINE #{__LINE__}  add_button :#{ add_button }"
        end
  end   ### set_addbutton pare_screen 
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
      
        end   ### rad.each
  ###   delete @addopt_jqgrid
###### 親と子の　div idを追加　　子画面も同様     
     if k == 0 then 
        @extbutton = ""
        @extdiv_id = ""
       else 
        @extbutton = t_extbutton
        @extdiv_id = t_extdiv_id
        ### @scriptopt[:var_getid] = %Q| var nst_tbl_val = jQuery("##{@nst_screenname_id}_select_button :checked").val()|
        ## @var_extopt = %Q| var nst_tbl_val = jQuery( this ).val()  ;|
        ### JQERY.GET は将来 2dcに移行する。完了
        ## @scriptopt[:getid] = %Q| jQuery.get("/screen/nst",{"id":id,"nst_tbl_val":nst_tbl_val,"authenticity_token":"authenticity_token})|
        ####
     end
     @scriptopt[:pare_contents] = ""
  end    ## set_radiobutton pare_screen  
 ################
  def disp   ##  jqgrid返り
   ## debugger ## 詳細項目セット
   params[:page] ||= 1 
   params[:rows] ||= 10 
   ## get from cache
   get_session_showdata 
   ### subpaging delay
   subpaging            ## subpaging 
   ##  p " @tbldata  :  #{@tbldata}"
   ##  p " @session_show_data  :  #{@session_show_data}"
    fprnt  " class #{self} : LINE #{__LINE__} @record_count :  #{@record_count}"
   ### debugger
   respond_with @tbldata.to_jqgrid_json( @session_show_data[:allfields] ,params[:page], params[:rows],@record_count)
  end  ##disp

  def subinsertsio 
      ## debugger
      command_r[:sio_viewname] = @session_show_data[:screen_viewname].downcase
      command_r[:id] =  plsql.__send__("SIO_#{command_r[:sio_viewname]}_SEQ").nextval
      command_r[:sio_term_id] =  request.remote_ip
      command_r[:sio_session_id] = params[:q]
      command_r[:sio_command_response] = "C"
      command_r[:sio_session_counter] = plsql.sessioncounters_seq.nextval  ### user_id に変更
      command_r[:sio_add_time] = Time.now
      command_r.merge! sub_set_fields_from_allfields
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
  end   ## subinsertsio 
  def sub_params_set view_name
  #######  blk_class実施している where はこちらでstrsqlにセットして行う
  ###   日付と数字で<>の比較ができてない
      @session_show_data[:allfields].each do |i|
          unless params[i].nil? then 
             command_r[i] = params[i] 
             case @session_show_data[:alltypes][i]
                  when "DATE" then
                         command_r[i] = Time.parse(command_r[i]) 
                  when "NUMBER"
                         command_r[i] = command_r[i].to_f
             end
           end  ## unless
      end
      return command_r
  end ## def sub_params_set view_name
  def sub_add_upd_del_setsio tblfields
	   tblfields.each_key do |ii|     ### tblfields  paramsをsio用に変換したもの
           if !tblfields[ii].nil?   and ii.to_s != "id_tbl"   ###   sub_set_fields_from_allfields参照 
              tmp_type = plsql.DETAILFIELDS.first(" where code = '#{ii.to_s.upcase}' and Expiredate > sysdate order by expiredate ") 
          ##  debugger
              tmp_type = unless  tmp_type.nil? then  tmp_type[:type] else "" end
              case tmp_type
              when "DATE","TIMESTAMP(6)" then
                   command_r[ii] = Time.parse(tblfields[ii]) 
              when "NUMBER"
                   command_r[ii] = tblfields[ii].to_f
              else
                   command_r[ii] = tblfields[ii]
              end
           end  ## if    !params[ii].nil?  
           end   ## do |ii|
           render :nothing => true
      command_r[:sio_user_code] =   @session_show_data[:person_id] 
      return
  end
  def nst  ###子画面　link
     rcd_id  =  params[:id]  ### 親画面テーブル内の子画面へのkeyとなるid
     pare_view =  params[:nst_tbl_val].split(";")[0]   ### 親のview
     chil_view =  params[:nst_tbl_val].split(";")[1]   ### 子のview
     @disp_screenname_name =  getblkpobj(params[:nst_tbl_val].split(";")[2],"A")   ### 子の画面
     cnt_detail =  params[:nst_tbl_val].split(";")[3]   ### 子の画面位置
     ##########
     @nst_screenname_id = "#{pare_view}#{chil_view}" 
     strsql = " (select * from #{chil_view} where #{pare_view[2..-2]}_id = '#{rcd_id}' )  a "
     @scriptopt = {}
     @options ={}
     @options[:div_repl_id] = "#{@nst_screenname_id}"   ### 親画面内の子画面表示のための　div のid
     @options[:autowidth] = "true"  
     set_detail strsql,plsql.screens.first("where viewname = '#{chil_view}'")[:code]  ## set @gridcolumns 
     ## debugger 
     ## p "chil_view : #{chil_view.downcase}  : #{@nst_screenname_id} : "#{@disp_screenname_name} "
     ## p "{pare_view}{chil_view} : #{pare_view}#{chil_view}   :xxx: #{ params[:nst_tbl_val].split(";")[2]}" 
      rcd_id_cache_key = "RCD_ID" + current_user[:id].to_s + @nst_screenname_id 
      ### set_detail でセットされた@nst_screenname_id
      hash_rcd = {}
      hash_rcd["#{pare_view[2..-2]}_id".downcase.to_sym] = rcd_id 
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
     get_session_showdata
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
          subinsertsio  do
             command_r[:sio_classname] = "plsql_blk_insert"
             sub_add_upd_del_setsio(tmp_isnr)
             command_r[:id_tbl] = nil
          end
       when "del"
          subinsertsio  do
             command_r[:sio_classname] = "plsql_blk_delete"
             sub_add_upd_del_setsio( tblfields)
             command_r[:id_tbl] = tblfields[:id_tbl].to_i
          end
       when "edit"
	 ## debugger
         subinsertsio  do
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
 ##    $ts.write(["C",request.remote_ip,params[:q],command_r[:sio_session_counter],"SIO_#{command_r[:sio_viewname]}"])
 ##    Resque.enqueue(DbCud, command_r[:sio_session_counter],"SIO_#{command_r[:sio_viewname]}")
    dbcud = DbCud.new
    dbcud.perform(command_r[:sio_session_counter],"SIO_#{command_r[:sio_viewname]}")
 end  ## add_upd_del
 def get_session_showdata 
   ### debugger  
      show_cache_key = "show " + current_user[:id].to_s  +  params[:q]
      @session_show_data  = {}
      @session_show_data = Rails.cache.read(show_cache_key)
   ### debugger
  end
  def sub_set_fields_from_allfields 
      ### debugger  
     tmp_isnr = {}
     @session_show_data[:allfields].each do |j|
        tmp_isnr[j] = params[j]  unless j.to_s  == "id"  ## sioのidとｖｉｅｗのｉｄが同一になってしまう
        tmp_isnr[:id_tbl] = params[j] if j.to_s == "id"          
    end ##    
    return tmp_isnr
 end  
 #####
 def proc_add_button    ### 
     get_session_showdata 
     subinsertsio  do
           command_r[:sio_classname]  = params[:button_proc]
           command_r[:id_tbl] = sub_set_fields_from_allfields[:id_tbl].to_i
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
end ## ScreenController
