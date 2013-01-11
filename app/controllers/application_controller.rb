class ApplicationController < ActionController::Base
  protect_from_forgery
##  def initialize
##   @command_r = Hash.new
##  end
  def subpaging
      ## debugger
      command_r[:sio_viewname]  = @session_show_data[:screen_viewname].downcase
      tmp_session_counter = subinsertsio  do
           command_r[:sio_start_record] = (params[:page].to_i - 1 ) * params[:rows].to_i + 1
           command_r[:sio_end_record] = params[:page].to_i * params[:rows].to_i 
           command_r[:sio_sord] = params[:sord]
           command_r[:sio_search] = params[:_search] 
           sub_params_set(command_r[:sio_viewname]) if params[:_search]  == "true" 
           command_r[:sio_sidx]  = params[:sidx]
           command_r[:sio_strsql]  =  @session_show_data[:strsql]
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
      
###     なぜか　eachが使用できない ?
##      rcd.each do |j|
##       @tbldata << j[inf_sym]
##      end 
      ## debugger
      
      for j in 0..rcd.size - 1
          tmp_data = {}
          @session_show_data[:allfields].each do |k|
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
  def plsql_blk_paging  
    command_r[:id] = nil
    #####   strsqlにコーディングしてないときは、viewをしよう
####     strdql はupdate insertには使用できない。
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
         ## insert_command_r recodcount,result_f,contents
         contents = "not find record"    ### 将来usergroup毎のメッセージへ
	 command_r[:sio_recordcount] = 0
         command_r[:sio_result_f] = "1"
         command_r[:sio_message_contents] = contents
         insert_command_r  command_r

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
           insert_command_r  command_r
	 end ##    plsql.select(:all, "#{strsql}").each do |j|
    end   ## case
  ### p  "e: " + Time.now.to_s 
  plsql.commit
  end   ###plsql_paging
  def  sub_strwhere
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

end  ## ApplicationController
