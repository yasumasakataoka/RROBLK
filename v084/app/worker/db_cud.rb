class DbCud  < ActionController::Base
 ## @queue = :default
 ## def self.perform(sio_id,sio_view_name)
 ## def update_table rec,tblname で重複エラーが検出されてない。　importと 画面でエラー検出すること。
 ##  shp,arvの更新条件がまだできてない。
    def perform(sio_session_counter,user_id)
      begin
           ###plsql.execute "SAVEPOINT before_perform"
           plsql.connection.autocommit = false
           crt_def  unless respond_to?("dummy_def")
           @pare_class = "batch"
           target_sio_tbl = plsql.__send__("userproc#{user_id.to_s}s").first("where id = #{sio_session_counter}")[:tblname]
           command_cs = plsql.__send__(target_sio_tbl).all("where sio_user_code = #{user_id} and  sio_session_counter = #{sio_session_counter} and sio_command_response = 'C' ")
           ##debugger
           strsql = "where sio_session_counter = #{sio_session_counter} and sio_command_response = 'C' and sio_user_code = #{user_id} "
           r_cnt0 = 1
           command_cs.each do |i|  ##テーブル、画面の追加処理
              ###commandは自分自身のテーブル内容
              ##debugger ## before update
              sioarray = []
              (sioarray,i  = __send__("sub_tbl_"+i[:sio_viewname].split("_")[1],sioarray,i))  if  respond_to?("sub_tbl_"+i[:sio_viewname].split("_")[1])
              (sioarray =    __send__("sub_screen_"+i[:sio_code],sioarray,i))  if  respond_to?("sub_screen_"+i[:sio_code])
              ### command_cs.each do |i|  ##テーブル、画面の追加処理
              ##debugger
              sioarray.each  do |sio| ## before update
                 new_cmds =  plsql.__send__(sio).all(strsql)   
                 tblname = sio.split(/_/,3)[2]
                 r_cnt = 1
                 new_cmds.each do |rec|
                     update_table(rec,tblname,r_cnt)
                     r_cnt += 1
                 end
              end   ##sioarray.each
              tblname = i[:sio_viewname].split(/_/,3)[1]
              update_table i,tblname,r_cnt0 ### 本体
              r_cnt0 += 1
              reset_show_data_screen if tblname =~ /screen|pobjgrps/   ###キャッシュを削除
              ##reset_show_data_screenlist if tblname == "pobjgrps"   ###キャッシュを削除
              
              sioarray = []
              (sioarray  = __send__("sub_aftertbl_"+i[:sio_viewname].split("_")[1],sioarray,i))  if  respond_to?("sub_aftertbl_"+i[:sio_viewname].split("_")[1])
              (sioarray =    __send__("sub_afterscreen_"+i[:sio_code],sioarray,i))  if  respond_to?("sub_afterscreen_"+i[:sio_code])
               ### command_cs.each do |i|  ##テーブル、画面の追加処理
               ##debugger
              sioarray.each  do |sio| ## after update
                 new_cmds =  plsql.__send__(sio).all(strsql)   ###
                 tblname = sio.split(/_/,3)[2]
                 r_cnt = 1
                 new_cmds.each do |rec|
                     update_table(rec,tblnameend,r_cnt)
                     r_cnt += 1
                 end   
              end   ##sioarray.each           end ##command_r
	      ###plsql.rollback_to "before_perform"  ### 
        ##debugger
          end
          rescue 
		      plsql.rollback
              p  $@
              p  " err     #{$!}"
              fprnt"class #{self} : LINE #{__LINE__} $@: #{$@} " 
              fprnt"class #{self} : LINE #{__LINE__} $!: #{$!} " 		  
              plsql.__send__("userproc#{user_id.to_s}s").update :status=> "error " ,:updated_at=>Time.now,:where=>{ :id =>sio_session_counter}
          else
              plsql.__send__("userproc#{user_id.to_s}s").update :status=> "normal end" ,:updated_at=>Time.now,:where=>{ :id =>sio_session_counter}
          ensure
	          plsql.commit   ##
              plsql.connection.autocommit = true         
          end  #begin  
    end   ##perform
      handle_asynchronously :perform  
    def reset_show_data_screen
      ##cache_key =  "show" 
      ##Rails.cache.delete_matched(cache_key) ###delay_jobからcallされるので、grp_codeはbatch
	  Rails.cache.clear(nil) ###delay_jobからcallされるので、grp_codeはbatch
    end
    def reset_show_data_screenlist   ###casheは消えけどうまくいかない　2013/11/2
      ##debugger
      cache_keys =["listindex","show","id"] 
      cache_keys.each do |key|
         Rails.cache.delete_matched(key) ###delay_jobからcallされるので、grp_codeはbat
      end
    end
    def sub_set_inout  sioarray,command_c,reqtbl,locasid,fm_or_to_locaid,strdate
       ##  親で　sub_get_ship_date(command_c[:custord_duedate],req_command_c[:shpsch_locas_id_asstwh] ,nil)を求めておくこと
      req_command_c = {}
      req_command_c = command_c.dup
      newtbl = reqtbl.chop
      oldtbl = command_c[:sio_viewname].split("_")[1].chop
      req_command_c[:sio_viewname] = req_command_c[:sio_code] =  "r_#{reqtbl}"
      req_command_c[(newtbl+"_qty").to_sym] = command_c[(oldtbl+"_qty").to_sym]
      req_command_c[(newtbl+"_amt").to_sym] = command_c[(oldtbl+"_amt").to_sym]
      req_command_c[(newtbl+"_price").to_sym] = command_c[(oldtbl+"_price").to_sym]
      req_command_c[(newtbl+"_tax").to_sym] = command_c[(oldtbl+"_tax").to_sym]
      req_command_c[(newtbl+"_itm_id").to_sym] = command_c[(oldtbl+"_itm_id").to_sym]
      req_command_c[(newtbl+"_remark").to_sym] = "auto create from #{oldtbl}"
      req_command_c[(newtbl+"_tblid").to_sym] = command_c[(oldtbl+"_id").to_sym]
      req_command_c[(newtbl+"_loca_id").to_sym] = locasid 
      loca_id_from_or_to = (newtbl+"_loca_id_" + if newtbl =~ /^shp/ then "to" else "from" end).to_sym
      req_command_c[loca_id_from_or_to] = fm_or_to_locaid
      req_command_c[(newtbl+"_tblname").to_sym] = command_c[:sio_viewname].split("_")[1]
      ###req_command_c[(newtbl+"_id").to_sym] =  command_c[(oldtbl+"_id").to_sym] ###新規と更新または削除
      strdatesym = (newtbl + if newtbl =~ /^shp/ then "_depdate" else "_arvdate" end).to_sym
      req_command_c[strdatesym] = strdate
      fmtolocasym = (newtbl + if newtbl =~ /^shp/ then "_loca_id_to" else "_loca_id_from" end).to_sym
      req_command_c[fmtolocasym] = fm_or_to_locaid
      case req_command_c[:sio_classname]
          when  /_insert_/ then
               req_command_c[(newtbl+"_id").to_sym] =  nil
               req_command_c[:id] =  nil
               sio_copy_insert req_command_c
               sioarray << "sio_r_#{reqtbl}"
	        when /_update_/ then
               ##debugger ##  shp,arvの更新条件がまだできてない。
               old_command_c = {}
               old_command_c = req_command_c.dup
               old_command_c[(newtbl+"_qty").to_sym] = 0
               old_command_c[(newtbl+"_amt").to_sym] = 0
               ###sio_copy_insert old_command_c
               old_command_c[:sio_classname] = "shparv_update_chgupdold"
               oldrec = plsql.__send__(reqtbl).first("where tblid = #{command_c[:id]} and tblname = '#{oldtbl}s' for update ")             
               old_command_c[strdatesym] = oldrec[strdatesym.to_s.split("_",2)[1].to_sym]
               old_command_c[:id] = oldrec[:id]
               req_command_c[:sio_classname] = "shparv_insert_chgupdnew"
               rec_cnt = plsql.__send__(reqtbl).count("where tblid = #{req_command_c[(newtbl+"_tblid").to_sym]} and tblname like '#{oldtbl}s%' ")
               old_command_c[(newtbl+"_tblname").to_sym] = req_command_c[(newtbl+"_tblname").to_sym] + "_upd" + rec_cnt.to_s
               sio_copy_insert old_command_c
               req_command_c[:id] = nil
               sio_copy_insert req_command_c
               sioarray << "sio_r_#{reqtbl}"
          when   /_delete_/ then 
               ##debugger
               req_command_c[(newtbl+"_qty").to_sym] = 0
               req_command_c[(newtbl+"_amt").to_sym] = 0
               req_command_c[(newtbl+"_tblname").to_sym] += "_del"
               oldrec = plsql.__send__(reqtbl).first("where tblid = #{command_c[:id]} and tblname = '#{oldtbl}s' for update ")
               req_command_c[:id] =  oldrec[:id]
               req_command_c[:sio_classname] = "shparv_update_chgdel"
               sio_copy_insert req_command_c
               sioarray << "sio_r_#{reqtbl}"
         end   ## case iud 
      return sioarray,command_c
    end
    def sub_update_stkhists command_r
      tbl =    command_r[:sio_viewname].split("_")[1].chop 
      sub_update_schs command_c  if tbl !~ /sch$/
      lc_id = command_r[(tbl + "_loca_id").to_sym]
      it_id = command_r[(tbl + "_itm_id").to_sym]
      tm_time = command_r[(tbl + if  tbl =~ /^shp/ then "_depdate" else "_arvdate" end).to_sym].strftime("%Y/%m/%d %H:%M:%S")
      pstk = plsql.stkhists.first("where locas_id =  #{lc_id} and  itms_id =  #{it_id} and to_char(strdate,'yyyy/mm/dd hh24:mi:ss') < '#{tm_time}'  order by strdate  desc  ")
      stk = plsql.stkhists.first("where locas_id =  #{lc_id} and  itms_id =  #{it_id} and to_char(strdate,'yyyy/mm/dd hh24:mi:ss') = '#{tm_time}'  order by strdate  desc ")
      if stk.nil? then  stk = new_stkhist(command_r) end
      while stk
            pstk = update_stkhist_rec(stk,pstk)
            tm_time = stk[:strdate].strftime("%Y/%m/%d %H:%M:%S")
            stk = plsql.stkhists.first("where locas_id =  #{lc_id} and  itms_id =  #{it_id} and to_char(strdate,'yyyy/mm/dd hh24:mi:ss') > '#{tm_time}'  order by strdate for update ")
      end
    end
    def sub_update_schs command_r
      ## status schedule: sch > ord  ,  order:odr > inst,instructions insts >act ,それ以外 cmpl
      tbl =    command_r[:sio_viewname].split("_")[1]
      case tbl
          when /acts$/ then
              update_schs_by_act command_r,tbl
          when /insts$/ then
              update_schs_by_inst command_r,tbl
          when /ords$/ then
              update_schs_by_ord command_r,tbl
      end
    end   
    ##private
    ## linkの追加・削除機能が必要 2014/2/8 不要　 snoで対応
    def  new_stkhist command_r
      stk = {}
      tblname = command_r[:sio_viewname].split("_")[1].chop
      command_r.each do|key,val|
          if key.to_s =~ /^#{tblname}/ then
             case key.to_s
               when /loca_id$/
                    stk[:locas_id] = val
               when /itm_id/
                     stk[:itms_id] = val
               when /depdate/
                     stk[:strdate] = val
                when /arvdate/
                     stk[:strdate] = val
               when /person_id_upd/
                     stk[:persons_id_upd] = val
             end
          end
      end
      stk[:qty] = 0
      stk[:qty_sch] = 0 
      stk[:qty_ord] = 0
      stk[:qty_inst] = 0
      stk[:amt] = 0
      stk[:amt_sch] = 0 
      stk[:amt_ord] = 0
      stk[:amt_inst] = 0
      stk[:id] =  plsql.stkhists_seq.nextval
      plsql.stkhists.insert stk
      return stk
    end
    def  update_stkhist_rec stk,prevstk
      ##debugger
      tm_time = stk[:strdate].strftime("%Y/%m/%d %H:%M:%S")
      if prevstk then
         prevstk.each do |key,val|
            stk[key] = val if key.to_s =~ /qty|amt/
         end
        else  
         stk.each do |key,val|
            stk[key] = 0 if key.to_s =~ /qty|amt/
         end
      end
      ##debugge
      ["shpschs","shpords","shpinsts","shpacts","arvschs","arvords","arvinsts","arvacts"].each do |tblname|
         strtime = if   tblname =~ /^shp/ then  "depdate" else "arvdate" end
         inoutrecs = plsql.__send__(tblname).all("where itms_id = #{stk[:itms_id]} and locas_id = #{stk[:locas_id]} and 
                                                  to_char(#{strtime},'yyyy/mm/dd hh24:mi:ss') = '#{tm_time}' ")
         inoutrecs.each do |rec| 
          if  tblname =~ /^arv/ then
              case tblname 
                    when /schs$/
                         stk[:qty_sch] +=  rec[:qty]
                         stk[:amt_sch] +=  rec[:amt] 
                    when /ords$/
                         stk[:qty_ord] += rec[:qty]
                         stk[:amt_ord] +=  rec[:amt] 
                    when /insts$/
                        stk[:qty_inst] +=  rec[:qty]
                        stk[:amt_inst] += rec[:amt] 
                    when /acts$/
                        stk[:qty] += rec[:qty]
                        stk[:amt] += rec[:amt]
              end
            else
              case tblname 
                    when /schs$/
                         stk[:qty_sch] -=  rec[:qty]
                         stk[:amt_sch] -=  rec[:amt] 
                    when /ords$/
                         stk[:qty_ord] -= rec[:qty]
                         stk[:amt_ord] -=  rec[:amt] 
                    when /insts$/
                        stk[:qty_inst] -=  rec[:qty]
                        stk[:amt_inst] -= rec[:amt] 
                    when /acts$/
                        stk[:qty] -= rec[:qty]
                        stk[:amt] -= rec[:amt]
              end
          end
         end
      end    
      stk[:where] = {:id =>stk[:id]}
      ##debugger
      plsql.stkhists.update stk
      return stk
    end

    def  set_sch_status schsrec
      case
         when  schsrec[:qty] >0
             case
                 when schsrec[:qty] <= schsrec[:qty_act] 
                  "9:complete"
                  when schsrec[:qty] <= schsrec[:qty_inst] 
                  "7:insts"
                  when schsrec[:qty] <= schsrec[:qty_ord] 
                  "5:ords"
                  else
                  "0:schs"
             end
        when  schsrec[:amt] >0
             case
                 when schsrec[:amt] <= schsrec[:amt_act] 
                  "9:complete"
                  when schsrec[:amt] <= schsrec[:amt_inst] 
                  "7:insts"
                  when schsrec[:amt] <= schsrec[:amt_ord] 
                  "5:ords"
                  else
                  "0:schs"
             end
      end
    end
    
    def update_schs_by_ord command_r,tbl
      schsno_sym = ("sno_#{tbl.sub('ords','sch')}").to_sym
      if command_r[:schsno_sym] then  ### schs :ords = 1:n
           schrec = plsql.__send__(tbl.sub("ords","schs")).first("where sno =  '#{command_r[schsno_sym]}' ")
           ordsrecs = plsql.__send__(tbl).all(%Q% where sno_#{schsno_sym.to_s} =  '#{command_r[schsno_sym]}' %)
           schrec[:qty_act] = schrec[:amt_act] = 0
           schrec[:qty_inst] = schrec[:amt_inst] = 0
           schrec[:qty_ord] = schrec[:amt_ord] = 0
           ordsrecs.each do |rec|
               schrec[:qty_ord] += rec[:qty]
               schrec[:amt_ord] += rec[:amt]
               schrec[:qty_inst] += rec[:qty_inst]
               schrec[:amt_inst] += rec[:amt_inst]
               schrec[:qty_act] += rec[:qty_act]
               schrec[:amt_act] += rec[:amt_act]
           end
           schrec[:status] = set_sch_status schrec
           schsrec[:where] = {:id =>schrec[:id]}
           plsql.__send__(tbl.sub("ords","schs")).update schrec
           crt_sio_for_sch(tbl.sub("ords","schs"),schrec[:id],command_r)
       else   ### schs :ords = n:1  n:mは認めない
          sno_sym = ("sno_#{tbl.chop}").to_sym
          schrecs =  plsql.__send__(tbl.sub("ords","schs")).first(%Q% where sno_#{tbl} =  '#{command_r[sno_sym]}' order by lineno_#{tbl} %)
          qty_sum = command_r[(tbl.chop+"_qty").to_sym]
          amt_sum = command_r[(tbl.chop+"_amt").to_sym]
          qty_insts_sum = command_r[(tbl.chop+"_qty_inst").to_sym]
          amt_insts_sum = command_r[(tbl.chop+"_amt_inst").to_sym]
          qty_acts_sum = command_r[(tbl.chop+"_qty_act").to_sym]
          amt_acts_sum = command_r[(tbl.chop+"_amt_act").to_sym]
          schrecs.each do |schrec|
              if  qty_insts_sum >=  schrec[:qty] then
                 schrec[:qty_inst] =  schrec[:qty]
                  qty_insts_sum   -=  schrec[:qty]
                else 
                  schrec[:qty_inst] =  qty_insts_sum
                  qty_insts_sum     = 0
              end
              if  amt_insts_sum >=  schrec[:amt] then
                 schrec[:amt_inst] =  schrec[:amt]
                 amt_insts_sum   -=  schrec[:amt]
                else 
                  schrec[:amt_inst] =  amt_insts_sum
                  amt_insts_sum     = 0
              end
              if  qty_act_sum >=  schrec[:qty] then
                 schrec[:qty_act] =  schrec[:qty]
                  qty_acts_sum   -=  schrec[:qty]
                else 
                  schrec[:qty_act] =  qty_act_sum
                  qty_acts_sum     = 0
              end
              if  amt_insts_sum >=  schrec[:amt] then
                 schrec[:amt_act] =  schrec[:amt]
                 amt_acts_sum   -=  schrec[:amt]
                else 
                  schrec[:amt_inst] =  amt_acts_sum
                  amt_acts_sum     = 0
              end

              schrec[:where] = {:id =>rec[:id]}
              schrec[:status] = set_sch_status schrec
              plsql.__send__(tbl.sub("ords","schs")).update schrec
              crt_sio_for_sch(tbl.sub("ords","schs"),schrec[:id],command_r)
              qty_sum -=  schrec[:qty]
              amt_sum -=  schrec[:amt]
          end
          raise  if qty_sum < 0 or amt_sum <0
      end
    end

    def update_schs_by_insts command_r,tbl
      ordssno_sym = ("sno_#{tbl.sub('insts','ord')}").to_sym
      if command_r[:ordssno_sym] then  ### ords:insts = 1:n
           ordsrec = plsql.__send__(tbl.sub("insts","ords")).first("where  sno =  '#{command_r[ordssno_sym]}' ")
           instsrecs = plsql.__send__(tbl).all("where  sno_#{ordssno_sym.to_s} =  '#{command_r[ordssno_sym]}' ")
           ordsrec[:qty_act] = ordsrec[:amt_act] = 0
           ordsrec[:qty_inst] = ordsrec[:amt_inst] = 0
           instsrecs.each do |rec|
               ordsrec[:qty_inst] += rec[:qty]
               ordsrec[:amt_inst] += rec[:amt]
               ordsrec[:qty_act] += rec[:qty_act]
               ordsrec[:amt_act] += rec[:amt_act]
           end
           ordsrec[:where] = {:id =>ordsrec[:id]}
           plsql.__send__(tbl.sub("insts","ords")).update ordsrec
           update_schs_by_ords crt_sio_for_sch(tbl.sub("insts","ords"),ordsrec[:id],command_r)
       else   ### ords:insts = n:1  n:mは認めない
          sno_sym = ("sno_#{tbl.chop}").to_sym
          ordrecs =  plsql.__send__(tbl.sub("insts","ords")).all(%Q% where sno_#{tbl} =  '#{command_r[sno_sym]}' %)
          qty_sum = command_r[(tbl.chop+"_qty").to_sym]
          amt_sum = command_r[(tbl.chop+"_amt").to_sym]
          qty_acts_sum = command_r[(tbl.chop+"_qty_act").to_sym]
          amt_acts_sum = command_r[(tbl.chop+"_amt_act").to_sym]
          ordrecs.each do |ordrec|
              if  qty_act_sum >=  ordrec[:qty] then
                 ordrec[:qty_act] =  ordrec[:qty]
                  qty_acts_sum   -=  ordrec[:qty]
                else 
                  ordrec[:qty_act] =  qty_act_sum
                  qty_acts_sum     = 0
              end
              if  amt_insts_sum >=  ordrec[:amt] then
                 ordrec[:amt_act] =  ordrec[:amt]
                 amt_acts_sum   -=  ordrec[:amt]
                else 
                  ordrec[:amt_inst] =  amt_acts_sum
                  amt_acts_sum     = 0
              end
              plsql.__send__(tbl.sub("insts","ords")).update rec
              update_schs_by_ords crt_sio_for_sch(tbl.sub("insts","ords"),ordsrec[:id],command_r)
              qty_sum -=  ordsrec[:qty]
              amt_sum -=  ordsrec[:amt]
          end
          raise  if qty_sum < 0 or amt_sum <0
      end
    end

    def update_schs_by_acts command_r,tbl
      actssno_sym = ("sno_#{tbl.sub('acts','inst')}").to_sym
      ### insts :acts = 1:n  n:1はない。
      instsrec = plsql.__send__(tbl.sub("acts","insts")).first("where sno =  #{command_r[actssno_sym]}' ")
      actsrecs = plsql.__send__(tbl).all("where sno_#{actssno_sym.to_s} =  '#{command_r[actssno_sym]}' ")
      instsrec[:qty_act] = instsrec[:amt_act] = 0
      actsrecs.each do |rec|
         instsrec[:qty_act] = rec[:qty]
         instsrec[:amt_act] = rec[:amt]
      end
      instsrec[:where] = {:id =>instsrec[:id]}
      plsql.__send__(tbl.sub("acts","insts")).update instsrec
      update_schs_by_insts crt_sio_for_sch(tbl.sub("acts","insts"),instsrec[:id],command_r)
    end

    def crt_sio_for_sch tbl,id,org_command_r
      command_r = org_command_r.dup
      show_data = get_show_data("r_#{tbl}")
      strsql = %Q% select #{sub_getfield(show_data)} from  r_#{tbl} where id = #{id} %
      pagedata = plsql.select(:all, strsql)
      pagedata.each do |j|
           j.each do |j_key,j_val|
             command_r[j_key]   = j_val ## 
           end  
      command_r[:sio_recordcount] = 1
      command_r[:sio_result_f] = "0"
      command_r[:sio_message_contents] = nil
      command_r[:sio_classname] = "stk_update"
      command_r[:sio_viewname]  = show_data[:screen_code_view] 
      sub_insert_sio_r(command_r)     ###回答
      end  ##pagedata
      return command_r, command_r[:sio_viewname].split("_")[1]
    end
    def update_table rec,tblname,r_cnt0
      begin
           tmp_key = {}
           @to_cr = {}   ###テーブル更新用
           rec.each do |j,k|
             j_to_stbl,j_to_sfld = j.to_s.split("_",2)		    
              if   j_to_stbl == tblname.chop   ##本体の更新
	              ###2013/3/25 追加覚書　 xxxx_id_yyyy   yyyy:自身のテーブルの追加  プラス _idをs_idに
	              @to_cr[j_to_sfld.sub("_id","s_id").to_sym] = k  if k  ###org tbl field name
                  @to_cr[j_to_sfld.to_sym] = nil  if k  == "#{nil}"  ##画面項目クリアー
				  if respond_to?("sub_field_#{j_to_sfld}")
				     __send__("sub_field_#{j_to_sfld}",j.to_s)
				  end
              end   ## if j_to_s.
           end ## rec.each
           @to_cr[:persons_id_upd] = rec[:sio_user_code]
           if  @to_cr[:sio_message_contents].nil?
               @to_cr[:updated_at] = Time.now
               case rec[:sio_classname]
                    when  /_insert_/ then
                        ##debugger
                        ##fprnt "class #{self} : LINE #{__LINE__} INSERT : @to_cr = #{@to_cr}"
                        @to_cr[:created_at] = Time.now  
	                    plsql.__send__(tblname).insert @to_cr  
	                  when /_update_/ then
                         @to_cr[:where] = {:id => rec[:id]}             ##変更分のみ更新
                         ##fprnt "class #{self} : LINE #{__LINE__} update : @to_cr = #{@to_cr}"
	                       ##debugger
                         @to_cr[:updated_at] = Time.now
                         plsql.__send__(tblname).update  @to_cr
                         ##raise
                    when  /_delete_/ then 
                         plsql.__send__(tblname).delete(:id => rec[:id])
	             end   ## case iud 
           end  ##@to_cr[:sio_message_contents].nil
           rescue  
                plsql.rollback
                command_r = {}
                command_r = rec.dup
                ##debugger
                command_r[:sio_recordcount] = r_cnt0
                command_r[:sio_result_f] =   "1" 
                command_r[:sio_message_contents] =  "class #{self} : LINE #{__LINE__} $!: #{$!} "    ###evar not defined
                command_r[:sio_errline] =  "class #{self} : LINE #{__LINE__} $@: #{$@} "[0..3999]
                @to_cr.each do |i,j| 
                   if i.to_s =~ /s_id/  
                      newi = (tblname.chop + "_" + i.to_s.sub("s_id","_id")).to_sym
                      command_r[newi] = j if j 
                   end
                   command_r[i] = j if i == :id
                end
                command_r[(command_r[:sio_viewname].split("_")[1].chop + "_id").to_sym] =  command_r[:id]
                p  $@
                p  " err     #{$!}"
               fprnt"class #{self} : LINE #{__LINE__} $@: #{$@} " 
               fprnt"class #{self} : LINE #{__LINE__} $!: #{$!} " 
           else 
            command_r = {}
            command_r = rec.dup
            command_r[:sio_recordcount] = r_cnt0
            command_r[:sio_result_f] =  "0"
            command_r[:sio_message_contents] = nil
            @to_cr.each do |i,j| 
	             if i.to_s =~ /s_id/  
		              newi = (tblname.chop + "_" + i.to_s.sub("s_id","_id")).to_sym
		              command_r[newi] = j if j 
                 end
               command_r[i] = j if i == :id
            end
			##debugger
            command_r[(command_r[:sio_viewname].split("_")[1].chop + "_id").to_sym] =  command_r[:id]
            crt_def if  tblname == "pobjects"  
            sub_update_stkhists command_r if tblname =~ /^shp|^arv/   ###在庫の更新
          ensure
            sub_insert_sio_r   command_r    ## 結果のsio書き込み
            ###raise   ### plsql.connection.autocommit = false   ##test 1/19 ok
          end ##begin
          raise if command_r[:sio_result_f] ==   "1" 
    end
    def undefined
      nil   
    end
    def crt_def
      eval("def dummy_def \n end")
      crt_defs = plsql.pobjects.all("where rubycode is not null and expiredate > sysdate")
      crt_defs.each do |i|
           eval(i[:rubycode])
      end
    end

end ## class
