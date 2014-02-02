# -*- coding: utf-8 -*-  
class   GanttController  <  ScreenController
  before_filter :authenticate_user!  
  respond_to :html ,:xml ##  将来　タイトルに変更
   def index
     @ganttdata = sub_gantt_chart(params[:screen_code],params[:id])
     @xnum1 = "parent_number"
     @xnum1witdth = 30   
     ###debugger
     #fprnt("@ganttdata :#{@ganttdata}")
     render :json =>@ganttdata
   end

   def set_fields_from_gantt tblid,value ###画面の内容をcommand_r for gantt screen     
      command_r = {}
      rid = if value[:id].split("_")[1] then value[:id].split("_")[1].to_i else nil end
      command_r[:id] = rid
      command_r[(tblid.chop+"_id").to_sym] = rid
      case tblid
           when "opeitms" then
                command_r[:opeitm_duration] = value[:opeitm_duration]
                command_r[:loca_code] = value[:loca_code]
                command_r[:itm_code] = value[:itm_code]
                command_r[:opeitm_priority] = 999
                command_r[:opeitm_processseq] = 999
                command_r[:opeitm_expiredate] = Time.parse("2099/12/31")
                if value[:paretblcode] then
                   if value[:paretblcode].split("_")[0] == "opeitms" then
                        paretbl = plsql.opeitms.first("where id = #{ value[:paretblcode].split("_")[1]} ")
                        command_r[:opeitm_priority] = paretbl[:priority]
                        command_r[:opeitm_unit_id_lttime] = paretbl[:units_id_lttime]
                        expiredate = plsql.r_opeitms.first("where loca_code = '#{value[:loca_code]}' and itm_code = '#{value[:itm_code]}' and opeitm_expiredate > sysdate  and opeitm_priority =  #{paretbl[:priority]} order by opeitm_expiredate")
                        command_r[:opeitm_expiredate] =  if expiredate then expiredate[:opeitm_expiredate]  else Time.parse("2099/12/31") end 
                   end
               end
           when "nditms" then
                command_r[:nditm_parenum] = value[:nditm_parenum]
                command_r[:nditm_chilnum] = value[:nditm_chilnum]
                command_r[:loca_code_nditm] = value[:loca_code]
                command_r[:itm_code_nditm] = value[:itm_code]
                command_r[:loca_code_nditm] = value[:loca_code]
                command_r[:nditm_opeitm_id] = value[:paretblcode].split("_")[1].to_i if  value[:paretblcode].split("_")[0] == "opeitms"
                command_r[:nditm_expiredate] = Time.parse("2099/12/31")
      end
     return command_r
   end  
   def uploadgantt
     ##debugger
      sio_session_counter =   user_seq_nextval(command_c[:sio_user_code])
      params[:tasks].each do |key,value|
         tblid = value[:id].split("_")[0]
         case tblid 
           when  "0" then
                ##top record
               next
           when "gantttmp"  then ### レコード追加
                tblid = value[:id].split("_")[1]
                command_r = set_fields_from_gantt(tblid,value)
                command_r[:sio_classname] = "plsql_blk_insert"
             else
              command_r = set_fields_from_gantt(tblid, value)
              command_r[:sio_classname] = "plsql_blk_update"
         end
      screen_code  = jqgrid_id = "r_" + tblid
      command_r[:sio_viewname]  = screen_code
      command_r[:sio_user_code] = plsql.persons.first(:email =>current_user[:email])[:id]  ||= 0   ###########   LOGIN USER  
      command_r[:sio_code] = screen_code
      command_c[:sio_session_counter] =   sio_session_counter   ##
      sub_insert_sio_c     command_r  ##
      unless  value[:subtblid].empty?  then
         subtblname = value[:subtblid].split("_")[0] 
         screen_code  = jqgrid_id = "r_" + subtblname
         value[:id] = value[:subtblid]
         command_r = set_fields_from_gantt(subtblname, value)
         if  value[:subtblid].split("_")[1] then command_r[:sio_classname] = "plsql_blk_update"   else command_r[:sio_classname] = "plsql_blk_insert" end 
            command_r[:sio_viewname]  = screen_code
            command_r[:sio_user_code] = plsql.persons.first(:email =>current_user[:email])[:id]  ||= 0   ###########   LOGIN USER  
            command_r[:sio_code] = screen_code
            sub_insert_sio_c     command_r  
         end
      end
      sub_userproc_insert command_c
      plsql.commit
      dbcud = DbCud.new
      dbcud.perform(command_r[:sio_session_counter],command_r[:sio_user_code])

      @ganttreturn = "retrurn ok"
   end
   def sub_gantt_chart screen_code,id
      ngantts = []
      time_now =  Time.now 
      ## {n0[:itm_id]} and locas_id = #{n0[:loca_id]} and processseq = #{n0[:processseq]} and priority = #{n0[:priority]}
      case screen_code
      when /^r_itms/   ##r_opeitm とcpo　procordがまだ
          itm = plsql.itms.first("where id = '#{id}'  ")
          r = plsql.opeitms.first("where itms_id = #{id} and Expiredate > sysdate   order by processseq desc,priority desc, Expiredate ")
      end
     ##debugger
     if r then 
        ngantts << {:seq=>"001",:mlevel=>1,:itm_id=>r[:itms_id],:loca_id=>r[:locas_id],:processseq=>r[:processseq],:priority=>r[:priority],:endtime=>time_now,:id=>"opeitms_"+r[:id].to_s}
        cnt = 0
        @bgantts = {}
        @bgantts[:"000"] = {:mlevel=>0,:itm_code=>"",:itm_name=>"全行程",:loca_code=>"",:loca_name=>"",:opeitm_duration=>"",:assigs=>"",:endtime=>time_now,:starttime=>nil,:depends=>"",:id=>0}
        until ngantts.size == 0
          cnt += 1
          ngantts = psub_get_itms_locas ngantts
          break if cnt >= 500
        end
      else
         return ""
     end
     
     @bgantts[:"000"][:starttime] = Time.now
     @bgantts[:"000"][:endtime] = prv_resch  ####再計算
     @bgantts[:"000"][:opeitm_duration] =   (@bgantts[:"000"][:endtime]  - @bgantts[:"000"][:starttime] ).divmod(24*60*60)[0]
     strgantt = '{"tasks":['
     @bgantts.sort.each  do|key,value|
        strgantt << %Q%{"id":"#{value[:id]}","itm_code":"#{value[:itm_code]}","itm_name":"#{value[:itm_name]}","loca_code":"#{value[:loca_code]}","loca_name":"#{value[:loca_name]}","nditm_parenum":"#{value[:nditm_parenum]}","nditm_chilnum":"#{value[:nditm_chilnum]}","start":#{value[:starttime].to_i.*1000},"opeitm_duration":#{value[:opeitm_duration]},"end":#{value[:endtime].to_i.*1000},"assigs":[],"depends":"#{value[:depends]}","level":#{if value[:mlevel] == 0 then 0 else 1 end},"mlevel":#{value[:mlevel]},"subtblid":"#{value[:subtblid]}","paretblcode":""},%
     end
     ## opeitmのsubtblidのopeitmは子のinsert用
     ##debugger
     ##fprnt("#{__LINE__} strgantt :#{strgantt}")
     strgantt = strgantt.chop + %Q|],"selectedRow":0,"deletedTaskIds":[],"canWrite":true,"canWriteOnParent":true }|
     return strgantt
   end  
   def psub_get_itms_locas ngantts ### bgantt 表示内容　ngantt treeスタック
     ##ngantts[:seq,:mlevel,:loca_id,:itm_id]
     ##@bgantts{seq=>{:itm_code,:itm_name,:loca_code,:loca_name,:mlevel,:nditm_parenum,:nditm_chilnum,:opeitm_duration,:assigs,}}
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
   def psub_get_contents(n0,r0)   ##n0→子の内容　r0→opeitm
     bgantt = {}
     itm = plsql.itms.first("where id = #{n0[:itm_id]} ")
     loca = plsql.locas.first("where id = #{n0[:loca_id]} ")
     bgantt[n0[:seq].to_sym] = {:mlevel=>n0[:mlevel],:itm_code=>itm[:code],:itm_name=>itm[:name],:loca_code=>loca[:code],:loca_name=>loca[:name],:opeitm_duration=>(r0[:duration]||=1),:assigs=>"",:endtime=>n0[:endtime],:starttime=>n0[:endtime]-(r0[:duration]||=1)*24*60*60,:depends=>"",:nditm_parenum=>n0[:nditm_parenum],:nditm_chilnum=>n0[:nditm_chilnum],:subtblid=>"opeitms_"+r0[:id].to_s,:id=>n0[:id]}
    ##p " Line #{__LINE__} #{bgantt}"
     @bgantts.merge! bgantt
     return bgantt[n0[:seq].to_sym][:starttime]
   end
   def psub_get_chil_itms(n0,r0,endtime)
     ngantts = []
     rnditms = plsql.nditms.all("where opeitms_id = #{r0[:id]} and Expiredate > sysdate ")
     if rnditms.size > 0 then
        mlevel = n0[:mlevel] + 1
        rnditms.each.with_index(1)  do |i,cnt|
           ngantts << {:seq=>n0[:seq] + sprintf("%03d", cnt),:mlevel=>mlevel,:itm_id=>i[:itms_id_nditm],:loca_id=>i[:locas_id_nditm],:priority=>r0[:priority],:endtime=>endtime,:nditm_parenum=>i[:parenum],:nditm_chilnum=>i[:chilnum],:id=>"nditms_"+i[:id].to_s}
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
           ngantts << {:seq=>(nseq + sprintf("%02d", cnt)),:mlevel=>n0[:mlevel],:itm_id=>i[:itms_id],:loca_id=>i[:locas_id],:endtime=>endtime,:id=>"opeitms_"+i[:id].to_s}
           endtime = endtime - i[:duration]*24*60*60
        end         
     end
     return ngantts
   end
   def prv_resch   ##本日を起点に再計算
      min_starttime = time_now = Time.now
      dp_id = 1
      @bgantts.sort.each  do|key,value|
         if key.to_s.size > 3 then
           @bgantts[key.to_s[0..-4].to_sym][:depends] << dp_id.to_s + "," 
         end
         min_starttime = @bgantts[key][:starttime] if  min_starttime > (@bgantts[key][:starttime]||= time_now)
         dp_id += 1
         end

         for_serch_par_key =[]
         @bgantts.each  do|key,value|
               if  min_starttime >=  @bgantts[key][:starttime] then
                   @bgantts[key][:starttime] = time_now  ###稼働日考慮今なし
                   @bgantts[key][:endtime] =  @bgantts[key][:starttime]   +  value[:opeitm_duration] *24*60*60
                   for_serch_par_key << [key , @bgantts[key][:endtime]]
            end
         end
         max_time = Time.now
         for_serch_par_key.each do |i|
            key = i[0].to_s[0..-4].to_sym
            if @bgantts[key][:starttime] < i[1]-24*60*60 then
               @bgantts[key][:starttime] = i[1]-24*60*60  ###カレンダー計算なし
               @bgantts[key][:endtime] =  @bgantts[key][:starttime] +@bgantts[key][:opeitm_duration]*24*60*60
               max_time =  @bgantts[key][:endtime]  if  @bgantts[key][:endtime] > max_time
               if   key.to_s.size > 3 then
                  for_serch_par_key << [key,@bgantts[key][:endtime] ]
               end
            end
         end
         @bgantts.sort.each  do|key,value|  ###topから再計算
         if  time_now  >  @bgantts[key][:starttime] then
            @bgantts[key][:endtime] = @bgantts[key.to_s[0..-4].to_sym][:starttime] -24*60*60 ###稼働日考慮今なし
            @bgantts[key][:starttime] =  @bgantts[key][:endtime]  -  value[:opeitm_duration] *24*60*60
         end
      end
      return max_time
   end
end ## ganttController

