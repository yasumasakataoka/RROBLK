# -*- coding: utf-8 -*-  
#### v084
## 同一login　userではviewとscreenは一対一
### show_data   画面の対するviewとその項目をユーザー毎にセット
class ScreenController < ApplicationController
  before_filter :authenticate_user!  
  respond_to :html ,:xml ##  将来　タイトルに変更
def index
      @pare_class = "online"
      @scriptopt = @options = {}
      @options[:div_repl_id] =   @ss_id = "" ###@ss_id 親画面から引き継いだid
      @screen_code,@jqgrid_id  = get_screen_code
      @disp_screenname_name = sub_blkgetpobj(@screen_code,"screen")
      ### set_detail screen_code => "",@div_id => "" ,sqlstr =>""  ###親の画面だからnst なし
      ##debugger ## 詳細項目の確認
  end  ##index
  def disp   ##  jqgrid返り
      ##debugger ## 詳細項目セット
      params[:page] ||= 1 
      params[:rows] ||= 50
      @screen_code,@jqgrid_id = get_screen_code
      ##fprnt "class #{self} : LINE #{__LINE__} screen_code #{screen_code}"
      show_data = get_show_data(@screen_code)
      command_r = set_fields_from_allfields(show_data) ###画面の内容をcommand_rへ
      command_r[:sio_strsql] = get_strsql if params[:ss_id] and  params[:ss_id] != ""  ##親画面情報引継
      rdata =  []
      ##fprnt "class #{self} : LINE #{__LINE__} command_r #{command_r}"
      command_r[:sio_classname] = "plsql_blk_paging"
      command_r[:sio_start_record] = (params[:page].to_i - 1 ) * params[:rows].to_i + 1
      command_r[:sio_end_record] = params[:page].to_i * params[:rows].to_i 
      command_r[:sio_sord] = params[:sord]
      command_r[:sio_search] = params[:_search] 
      command_r[:sio_sidx]  = params[:sidx]
      command_r[:sio_code]  = @screen_code
      rdata = subpaging(command_r)     ## rdata[データの中身,レコード件数]
      ##debugger ##fprnt "class #{self} : LINE #{__LINE__} @tbldata #{@tbldata}"
      plsql.commit
      @tbldata = rdata[0].to_jqgrid_xml(show_data[:allfields] ,params[:page], params[:rows],rdata[1]) 
      respond_with @tbldata
    end  ##disp
    def nst  ###子画面　
      pare_code =  params[:nst_tbl_val].split("_div_")[0]   ### 親のviewのcode
      chil_code =  params[:nst_tbl_val].split("_div_")[1]   ### 子のviewのcode
      @disp_screenname_name =  sub_blkgetpobj(params[:nst_tbl_val].split("_div_")[1],"screen")   ### 子の画面
      #####cnt_detail =  params[:nst_tbl_val].split(";")[3]   ### 子の画面位置
      @screen_code,@jqgrid_id = get_screen_code
      show_data = get_show_data(@screen_code)
      ##########
      @options ={}
      @options[:div_repl_id] = "#{pare_code}_div_#{chil_code}"  ### 親画面内の子画面表示のための　div のid
      @options[:autowidth] = "false"  
      chilf = plsql.r_chilscreens.first("where pobject_code_scr_ch = '#{chil_code}' and pobject_code_scr = '#{pare_code}' and chilscreen_Expiredate > sysdate order by chilscreen_expiredate ")
      ##debugger 
      rcd_id  =  params[:data][chilf[:pobject_code_sfd].to_sym]  ### 親画面テーブル内の子画面へのkeyとなるid
      @ss_id = user_parescreen_nextval( current_user[:id]).to_s   ###子画面に引き継ぐセッションid
      rcdkey = "RCD_ID" + current_user[:id].to_s + @jqgrid_id + @ss_id
      pkey = chilf[:pobject_code_sfd_ch]
      chil_view = chilf[:pobject_code_view_ch]
      hash_rcd = {}
      hash_rcd[:rcd_id_val] = rcd_id ##### rcd_id:親画面テーブル内の子画面へのkeyとなるid
      hash_rcd[:strsql] = "(select * from #{chil_view} where #{pkey} = #{rcd_id} )  a "  
      sub_parescreen_insert rcdkey,hash_rcd
      render :layout=>false 
      plsql.commit
    end   ### nst
#####
    def get_strsql 
       strsql = ""
       hash_rcd = plsql.__send__("parescreen#{current_user[:id].to_s}s").first("where id = #{params[:ss_id]} and expiredate > sysdate")
      ##debugger
      ##if Rails.cache.exist?(rcdkey)   then  ### 
      if hash_rcd   then   strsql =  hash_rcd[:strsql]  end  ### 親からのidで子を表示
     strsql = nil if strsql == ""
     return strsql
  end
  def set_fields_from_allfields show_data ###画面の内容をcommand_rへ
     command_r = {}
     show_data[:evalstr].each do |key,rubycode|   ###既定値等セット　画面からの入力優先
         ##debugger
         command_r[key] = eval(rubycode)
     end
     show_data[:allfields].each do |j|
	## nilは params[j] にセットされない。
        command_r[j] = params[j]  if params[j]  ##unless j.to_s  == "id"  ## sioのidとｖｉｅｗのｉｄが同一になってしまう
        ##command_r[:id_tbl] = params[j].to_i if j.to_s == "id"          
     end ##
    return command_r
  end  
    def screen_code
      @screen_code
    end
    def  get_url_from_code  ###params[:q]  screen_code   ,params[:fieldname] page downが押された項目
      akeyfs,viewname,delm =  get_ary_search_field params[:q],params[:fieldname]
      if   viewname then   
          @getname = {:viewname => viewname}
          render :json => @getname
         else
           render :nothing => true
      end
    end
    def  code_to_name  ### 必須keyとして登録された_codeが変化したときcall
      ##debugger
      keyfields = {}
      tblnamechop,field,delm = params[:chgname].split("_",3)
      exit if  tblnamechop == params[:q].split("_")[1].chop and params[:code_to_name_oper] != "add" and params[:code_to_name_oper] != "copyandadd" 
      ###既定値のセット
      d_valuefms =  plsql.r_screenfields.all("where  pobject_code_scr = '#{params[:q]}'  and  screenfield_rubycode is not null AND screenfield_expiredate > sysdate")
      d_valuefms.each do |rec|             
            if  params[rec[:pobject_code_sfd].to_sym].nil? then params[rec[:pobject_code_sfd].to_sym] = eval(rec[:screenfield_rubycode])  end
      end
      case tblnamechop
           when params[:q].split("_")[1].chop  ###同一テーブル新規のときのチェック
                sw = same_tbl_code_to_name tblnamechop,field
           else
                sw = oth_tbl_code_to_name tblnamechop
      end
      if sw == "ON" then render :json => @getname else   render :nothing => true end
    end
    def get_ary_search_field screen_code,field   ###excel importでも使用
      strwhere = "where pobject_code_sfd = '#{field}' and screenfield_paragraph > '0'  "    ##検索元のテーブルを求める。
      strwhere  << " and pobject_code_scr = '#{screen_code}' AND screenfield_expiredate > sysdate" 
      v = plsql.r_screenfields.first(strwhere)
      viewname =  rec = delm = nil
      akeyfs = []
      if   v then   ###グループを求める。
           viewname,delm =  v[:screenfield_paragraph].split(":_")
           strwhere = "where screenfield_paragraph = '#{v[:screenfield_paragraph]}' "
           strwhere  << " and pobject_code_scr = '#{screen_code}' AND screenfield_expiredate > sysdate" 
           keyfs = plsql.r_screenfields.all(strwhere)
           keyfs.each do |rec|
              akeyfs << rec[:pobject_code_sfd]
           end
      end
      return akeyfs,viewname,delm
    end	
    def    oth_tbl_code_to_name tblnamechop
      akeyfs,viewname,delm =  get_ary_search_field params[:q],params[:chgname]
      if   viewname.nil? or viewname == ""  then 
         sw = "OFF"
         exit
      end
      keyfields = {}
      sw = "ON"
      params.each do |key,val|
           if  akeyfs.index(key.to_s) then
               if  params[key] and params[key] != "" then keyfields[key] = val else sw = "OFF" end
           end
      end
       ##debugger
      rec = get_item_from_code keyfields,viewname,delm  if sw == "ON" 
      @getname ={}
      if   rec then
             mytbl = params[:q].split("_")[1].chop
             rec.each do |key,val|
                  if  delm then nkey = (key.to_s+"_"+delm).to_sym else nkey = key end
                  if  nkey.to_s != "id" then  @getname[nkey] = rec[key].to_s end  ### 
             end
           else
      end
       ##debugger
      return sw
    end

    def  same_tbl_code_to_name tblnamechop,field
      sw = "ON"
      strwhere = %Q%where pobject_code_tbl = '#{tblnamechop+"s"}' and pobject_code_fld = '#{field}' and blkuky_expiredate > sysdate%
      grp = plsql.r_blkukys.first strwhere
      if  grp then
          strwhere = %Q%where pobject_code_tbl = '#{tblnamechop+"s"}' and blkuky_grp = '#{grp[:blkuky_grp]}' and blkuky_expiredate > sysdate%
          keyfs = plsql.r_blkukys.all strwhere
          akeyfs = []
          keyfs.each do |rec|
             akeyfs << rec[:pobject_code_fld]
          end
          keyfields = {}
          params.each do |key,val|
             if  key.to_s.split("_")[0]  == tblnamechop and akeyfs.index(key.to_s.split("_")[1]) then
                 if  params[key] and params[key] != "" then keyfields[key] = val else sw = "OFF" end
             end
          end
         else
           sw = "OFF"
       end 
       ##debugger
       rec = nil
       rec = get_item_from_code keyfields,"r_"+tblnamechop+"s",nil  if sw == "ON" 
       @getname ={}
       if rec then
             rec.each do |key,val|
                  if  key.to_s != "id" then  @getname[key] = rec[key].to_s end  ### 
             end
             @getname[:errmsg] = " #{keyfields.values.join(',')}.....already exists"
          else
             @getname.delete(params[:chgname].to_sym)
                 ##debugger
        end
        return sw
 end
    def get_item_from_code keys,viewname,delm
      strwhere = " where "
      tblname = viewname.split("_")[1].chop
      keys.each do |key,val|
           if  delm then nkey = key.to_s.sub("_#{delm}","") else nkey = key.to_s end
           strwhere << nkey + " = '" + val  + "'    and "
      end
      strwhere << "#{tblname}_expiredate > sysdate order by #{tblname}_expiredate "
      ##debugger
      rec = plsql.__send__(viewname).first(strwhere)
    end
 def preview_prnt
      screen_code,jqgrid_id = get_screen_code
      show_data = get_show_data(screen_code)
      command_r ={}
      command_r[:sio_totalcount] = 0
      rdata =  []
      pdfscript = plsql.r_reports.first("where pobject_Code_lst = '#{params[:pdflist]}' and  report_Expiredate > sysdate")
      unless  pdfscript.nil? then
         reports_id = pdfscript[:id]
         strwhere = sub_pdfwhere(show_data[:screen_code_view] ,reports_id,command_r)
         command_r = set_fields_from_allfields(show_data) ###画面の内容をcommand_rへ
         command_r[:sio_strsql] = " (select * from #{show_data[:screen_code_view]} " + strwhere + " ) a"
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
end ## ScreenController

