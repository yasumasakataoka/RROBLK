class DbCud  < ActionController::Base
 ## @queue = :default
 ## def self.perform(sio_id,sio_view_name)
    def perform(sio_session_counter,user_id)
      crt_def   unless respond_to?("dummy_def")
      begin
           ###plsql.execute "SAVEPOINT before_perform"
           plsql.connection.autocommit = false
           @pare_class = "batch"
           target_sio_tbl = plsql.__send__("userproc#{user_id.to_s}s").first("where id = #{sio_session_counter}")[:tblname]
           command_cs = plsql.__send__(target_sio_tbl).all("where sio_user_code = #{user_id} and  sio_session_counter = #{sio_session_counter} and sio_command_response = 'C' ")
           ##debugger
           strsql = "where sio_session_counter = #{sio_session_counter} and sio_command_response = 'C' and sio_user_code = #{user_id} "
           command_cs.each do |i|  ##テーブル、画面の追加処理
              ###commandは自分自身のテーブル内容
              ## before update
              sioarray = []
              (sioarray,i  = __send__("sub_tbl_"+i[:sio_viewname].split("_")[1],sioarray,i))  if  respond_to?("sub_tbl_"+i[:sio_viewname].split("_")[1])
              (sioarray =    __send__("sub_screen_"+i[:sio_code],sioarray,i))  if  respond_to?("sub_screen_"+i[:sio_code])
               ### command_cs.each do |i|  ##テーブル、画面の追加処理
               ##debugger
              sioarray.each  do |sio| ## before update
                 new_cmds =  plsql.__send__(sio).all(strsql)   
                 tblname = sio.split(/_/,3)[2]
                 new_cmds.each do |rec|
                     update_table rec,tblname
                 end
              end   ##sioarray.each
              update_table i ### 本体
              sioarray = []
              (sioarray  = __send__("sub_aftertbl_"+i[:sio_viewname].split("_")[1],sioarray,i))  if  respond_to?("sub_aftertbl_"+i[:sio_viewname].split("_")[1])
              (sioarray =    __send__("sub_afterscreen_"+i[:sio_code],sioarray,i))  if  respond_to?("sub_afterscreen_"+i[:sio_code])
               ### command_cs.each do |i|  ##テーブル、画面の追加処理
               ##debugger
              sioarray.each  do |sio| ## after update
                 new_cmds =  plsql.__send__(sio).all(strsql)   ###
                 tblname = sio.split(/_/,3)[2]
                 new_cmds.each do |rec|
                     update_table rec
                 end
              end   ##sioarray.each
           end ##command_r
      rescue
	      ###plsql.rollback_to "before_perform"  ### delay_jobが勝手にcommitしている模様
              plsql.rollback
	      p  $@
              p  " err     #{$!}"
	      fprnt"class #{self} : LINE #{__LINE__} $@: #{$@} " 
	      fprnt"class #{self} : LINE #{__LINE__} $!: #{$!} " 
              plsql.connection.autocommit = true
              ##debugger
            else
              plsql.__send__("userproc#{user_id.to_s}s").update :status=>if @errf == "" then "normal end" else "error" end,:updated_at=>Time.now,:where=>{ :id =>sio_session_counter}
	      plsql.commit   ##
              plsql.connection.autocommit = true         
      end   ## begin
    end   ##perform
      handle_asynchronously :perform  
    def reset_show_data_screen
      cache_key =  "show" 
      Rails.cache.delete_matched(cache_key) ###delay_jobからcallされるので、grp_codeはbatch
    end
    def reset_show_data_screenlist   ###casheは消えるけどうまくいかない　2013/11/2
      ##debugger
      cache_key = "listindex" 
      Rails.cache.delete_matched(cache_key) ###delay_jobからcallされるので、grp_codeはbat
      chcache_key =  "show+"
      Rails.cache.delete_matched(cache_key) ###delay_jobからcallされるので、grp_codeはbatch
    end
    def sub_set_inout  sioarray,command_c,reqtbl,locasid,strdate
       ##日付変更時は、 call する側で マイナスのデータも作成のこと。
       ##  親で　sub_get_ship_date(command_c[:custord_duedate],req_command_c[:shpsch_locas_id_asstwh] ,nil)を求めておくこと
      req_command_c = {}
      newtbl = reqtbl.chop
      oldtbl = command_c[:sio_viewname].split("_")[1].chop
      req_command_c[(newtbl+"_qty").to_sym] = command_c[(oldtbl+"_qty").to_sym]
      req_command_c[(newtbl+"_amt").to_sym] = command_c[(oldtbl+"_amt").to_sym]
      req_command_c[(newtbl+"_itm_id").to_sym] = command_c[(oldtbl+"_itm_id").to_sym]
      req_command_c[(newtbl+"_remark").to_sym] = "auto create from #{oldtbl}"
      req_command_c[(newtbl+"_tblid").to_sym] = command_c[(oldtbl+"_id").to_sym]
      req_command_c[(newtbl+"_loca_id").to_sym] = if locasid then command_c[locasid] else sub_get_ship_locas_frm_itm_id(command_c[(oldtbl+"_itm_id").to_sym]) end
      req_command_c[(newtbl+"_tblname").to_sym] = command_c[:sio_viewname].split("_")[1]
      req_command_c[(newtbl+"_id").to_sym] =  command_c[(oldtbl+"_id").to_sym] ###新規と更新または削除
      strdatesym = (newtbl + if newtbl =~ /^shp/ then "_depdate" else "_arvdate" end).to_sym
      req_command_c[strsymdate] = strdate
      sio_copy_insert req_command_c

      sioarray << "sio_r_#{reqtbl}"
      return sioarray,command_c
    end
    def sub_update_stkhists command_r
      tbl =    command_r[:sio_viewname].split("_")[1].chop 
      sub_update_schs command_c  if tbl !~ /sch$/
      lc_id = command_r[(tbl + "_loca_id").to_sym]
      it_id = command_r[(tbl + "_itm_id").to_sym]
      tm_time = command_r[(tbl + if  tbl =~ /^shp/ then "_depdate" else "_arvdate" end).to_sym]
      prevstk = plsql.stkhists.first("where locas_id =  #{lc_id} and  itms_id =  #{it_id} and strdate < #{tm_time}  order by strdate  desc ")
      nstk = plsql.stkhists.first("where locas_id =  #{lc_id} and  itms_id =  #{it_id} and strdate = #{tm_time} ")
      if  prevstk then
          new_stkhists_add(command_r,prevstk)  if nstk.nil? ####以前のデータの引き継ぎ
       else
          new_stkhists_add(command_r,nil) if nstk.nil? ####初期値
      end 
      fstk = plsql.stkhists.first("where locas_id =  #{lc_id} and  itms_id =  #{it_id} and strdate >= #{tm_time}  order by strdate ")
      fstk.each do |stk|
         update_stkhist_rec stk,command_r
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
    def undefined
      nil   
    end
    private
    ## linkの追加・削除機能が必要
    def update_schs_by_ord command_r,tbl
      schsid_sym = (tbl.sub("ords","schs")+"_id").to_sym
      if command_r[:schsid_sym] then  ### schs :ords = 1:n
           schrec = plsql.__send__(tbl.sub("ords","schs")).first("where id =  command_r[schsid_sym] ")
           ordrecs = plsql.__send__(tbl).all(%Q% where #{schsid_sym.to_s} =  command_r[schsid_sym] %)
           schsrec[:qty_act] = schsrec[:amt_act] = 0
           schsrec[:qty_inst] = schsrec[:amt_inst] = 0
           schsrec[:qty_ord] = schsrec[:amt_ord] = 0
           ordsrecs.each do |rec|
               schsrec[:qty_ord] += rec[:qty]
               schsrec[:amt_ord] += rec[:amt]
               schsrec[:qty_inst] += rec[:qty_inst]
               schsrec[:amt_inst] += rec[:amt_inst]
               schsrec[:qty_act] += rec[:qty_act]
               schsrec[:amt_act] += rec[:amt_act]
           end
           schsrec[:status] = set_sch_status schrec
           schsrec[:where] = {:id =>schsrec[:id]}
           plsql.__send__(tbl.sub("ords","schs")).update schsrec
           crt_sio_for_sch(tbl.sub("ords","schs"),schsrec[:id],command_r)
       else   ### schs :ords = n:1  n:mは認めない
          ordsid_sym = (tbl+"_id").to_sym
          schrecs =  plsql.__send__(tbl.sub("ords","schs")).first(%Q% where #{ordsid_sym} =  command_r[:id] %)
          qty_sum = command_r[(tbl.chop+"_qty").to_sym]
          amt_sum = command_r[(tbl.chop+"_amt").to_sym]
          schsrecs.each do |rec|
              schsrec[:qty_inst] = schsrec[:qty]
              schsrec[:amt_inst] = schsrec[:amt]
              schsrec[:qty_act] = schsrec[:qty]
              schsrec[:amt_act] = schsrec[:amt]
              schsrec[:where] = {:id =>rec[:id]}
              schsrec[:status] = set_sch_status schrec
              plsql.__send__(tbl.sub("ords","schs")).update rec
              crt_sio_for_sch(tbl.sub("ords","schs"),ordsrec[:id],command_r)
              qty_sum -=  ordsrec[:qty]
              amt_sum -=  ordsrec[:amt]
          end
          raise  if qty_sum < 0 or amt_sum <0
      end
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
    def update_schs_by_insts command_r,tbl
      ordsid_sym = (tbl.sub("insts","ords")+"_id").to_sym
      if command_r[:ordsid_sym] then  ### ords:insts = 1:n
           ordsrec = plsql.__send__(tbl.sub("insts","ords")).first("where id =  command_r[ordsid_sym] ")
           instsrecs = plsql.__send__(tbl).all("where #{ordsid_sym.to_s} =  command_r[ordsid_sym] ")
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
          instsid_sym = (tbl+"_id").to_sym
          ordrecs =  plsql.__send__(tbl.sub("insts","ords")).all(%Q% where #{instsid_sym.to_s} =  #{command_r[:id]} %)
          qty_sum = command_r[(tbl.chop+"_qty").to_sym]
          amt_sum = command_r[(tbl.chop+"_amt").to_sym]
          ordrecs.each do |rec|
              ordsrec[:qty_inst] = ordsrec[:qty]
              ordsrec[:amt_inst] = ordsrec[:amt]
              ordsrec[:qty_act] = ordsrec[:qty]
              ordsrec[:amt_act] = ordsrec[:amt]
              ordsrec[:where] = {:id =>rec[:id]}
              plsql.__send__(tbl.sub("insts","ords")).update rec
              update_schs_by_ords crt_sio_for_sch(tbl.sub("insts","ords"),ordsrec[:id],command_r)
              qty_sum -=  ordsrec[:qty]
              amt_sum -=  ordsrec[:amt]
          end
          raise  if qty_sum < 0 or amt_sum <0
      end
    end
    def update_schs_by_acts command_r,tbl
      instsid_sym = (tbl.sub("act","inst")+"_id").to_sym
      ### insts :acts = 1:n  n:1はない。
      instsrec = plsql.__send__(tbl.sub("acts","insts")).first("where id =  command_r[instsid_sym] ")
      actsrecs = plsql.__send__(tbl).all("where #{instsid_sym.to_s} =  command_r[instsid_sym] ")
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
    def update_table rec,tblname
      tmp_key = {}
      r_cnt = 0
      to_cr = {}   ###テーブル更新用
      rec.each do |j,k|
           j_to_s = j.to_s
           if   j_to_s.split("_")[0] == tblname.chop then  ##本体の更新
	      ###2013/3/25 追加覚書　 xxxx_id_yyyy   yyyy:自身のテーブルの追加  プラス _idをs_idに
	      to_cr[j_to_s.split(/_/,2)[1].sub("_id","s_id").to_sym] = k  if k  ###org tbl field name
              to_cr[j_to_s.split(/_/,2)[1].sub("_id","s_id").to_sym] = nil  if k  == '#{nil}'  ##画面項目クリアー
            end   ## if j_to_s.
      end ## rec.each
      to_cr[:persons_id_upd] = rec[:sio_user_code]
      if  to_cr[:sio_message_contents].nil?
          to_cr[:updated_at] = Time.now
          case rec[:sio_classname]
               when  /insert/ then
                    ##debugger
                    ##fprnt "class #{self} : LINE #{__LINE__} INSERT : to_cr = #{to_cr}"
                    to_cr[:created_at] = Time.now  
	            plsql.__send__(tblname).insert to_cr  
	       when /update/ then
                    to_cr[:where] = {:id => rec[:id]}             ##変更分のみ更新
                    ##fprnt "class #{self} : LINE #{__LINE__} update : to_cr = #{to_cr}"
	            ##debugger
                    to_cr[:updated_at] = Time.now
                    plsql.__send__(tblname).update  to_cr
                     ##raise
                when  /delete/ then 
                         plsql.__send__(tblname).delete(:id => rec[:id])
                        ### 2013/12 stop　unless  rec[:sio_ctltbl]  ##ctlを利用しての親子関係のときは、子の削除はしない。
	     end   ## case iud 
      end  ##to_cr[:sio_message_contents].nil?
      r_cnt += 1
      ##debugger 
      @errf = ""
      command_r = {}
      command_r = rec.dup
      command_r[:sio_recordcount] = r_cnt
      command_r[:sio_result_f] =  if  to_cr[:sio_message_contents] then "1" else  "0" end
      command_r[:sio_message_contents] = to_cr[:sio_message_contents]
      @errf = "1" if to_cr[:sio_message_contents]
      to_cr.each do |i,j| 
	   if i.to_s =~ /s_id/  and i.to_s != "persons_id_upd" then   ###変更は　sio_user_codeを使用
		     newi = (tblname.chop + "_" + i.to_s.sub("s_id","_id")).to_sym
		     command_r[newi] = j if j
	   end
              command_r[i] = j if i == :id
      end
      command_r[(command_r[:sio_viewname].split("_")[1].chop + "_id").to_sym] =  command_r[:id]
      sub_update_stkhists command_r if tblname =~ /^shp|^arv/   ###在庫の更新
      sub_insert_sio_r   command_r    ## 結果のsio書き込み
      reset_show_data_screen if sio =~ /screen/   ###キャッシュを削除
      reset_show_data_screenlist if tblname == "pobjgrps"   ###キャッシュを削除
      undef dummy_def if tblname == "pobjects" and respond_to?("dummy_def")
      ###raise   ### plsql.connection.autocommit = false   ##test 1/19 ok
    end
end ## class
