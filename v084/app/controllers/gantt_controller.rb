# -*- coding: utf-8 -*-  
class   GanttController  <  ScreenController
###同一priorityのもののみ抽出
  before_filter :authenticate_user!  
  respond_to :html ,:xml ##  将来　タイトルに変更
   def index
     sub_gantt_chart(params[:screen_code],params[:id])  ##@ganttdata 作成
     @xnum1 = "parent_number"
     @xnum1witdth = 30   
     ##debugger
     ##fprnt("@ganttdata :#{@ganttdata}")
     render :json =>@ganttdata
   end
   def sub_gantt_chart screen_code,id
      ngantts = []
      time_now =  Time.now 
      ## {n0[:itm_id]} and locas_id = #{n0[:loca_id]} and processseq = #{n0[:processseq]} and priority = #{n0[:priority]}
      case screen_code
        when /^gantt_itms/   ##r_opeitm とcpo　procordがまだ
            itm = plsql.itms.first("where id = '#{id}'  ")
            rec = plsql.opeitms.first("where itms_id = #{id} and Expiredate > sysdate   order by priority desc, processseq desc,Expiredate ")
      end
       ##debugger
      if rec then 
        ngantts << {:seq=>"001",:mlevel=>1,:itm_id=>rec[:itms_id],:loca_id=>rec[:locas_id],:processseq=>rec[:processseq],:priority=>rec[:priority],:endtime=>time_now,:id=>"opeitms_"+rec[:id].to_s}
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
     prv_resch  ####再計算
     @bgantts[:"000"][:endtime] = @bgantts[:"001"][:endtime] 
     @bgantts[:"000"][:opeitm_duration] = " #{(@bgantts[:"000"][:endtime]  - @bgantts[:"000"][:starttime] ).divmod(24*60*60)[0]}"
     strgantt = '{"tasks":['
     @bgantts.sort.each  do|key,value|
        strgantt << %Q%{"id":"#{value[:id]}","itm_code":"#{value[:itm_code]}","itm_name":"#{value[:itm_name]}","loca_code":"#{value[:loca_code]}","loca_name":"#{value[:loca_name]}",
        "nditm_parenum":"#{value[:nditm_parenum]}","nditm_chilnum":"#{value[:nditm_chilnum]}","start":#{value[:starttime].to_i.*1000},"opeitm_duration":"#{value[:opeitm_duration]}",
        "end":#{value[:endtime].to_i.*1000},"assigs":[],"depends":"#{value[:depends]}","level":#{if value[:mlevel] == 0 then 0 else 1 end},"mlevel":#{value[:mlevel]},"subtblid":"#{value[:subtblid]}","paretblcode":""},%
     end
     ## opeitmのsubtblidのopeitmは子のinsert用
     ##debugger
     ##fprnt("#{__LINE__} strgantt :#{strgantt}")
     @ganttdata = strgantt.chop + %Q|],"selectedRow":0,"deletedTaskIds":[],"canWrite":true,"canWriteOnParent":true }|
   end  

   def psub_get_itms_locas ngantts ### bgantt 表示内容　ngantt treeスタック
     ##ngantts[:seq,:mlevel,:loca_id,:itm_id]
     ##@bgantts{seq=>{:itm_code,:itm_name,:loca_code,:loca_name,:mlevel,:nditm_parenum,:nditm_chilnum,:opeitm_duration,:assigs,}}
     n0 = ngantts.shift
     ##debugger
	 if n0.size > 0  ###子部品がいなかったとき{}になる。
        r0 =  plsql.opeitms.first("where itms_id = #{n0[:itm_id]}  and processseq = #{n0[:processseq] ||= 999} and priority = #{n0[:priority] ||= 999} and Expiredate > sysdate")
        if r0 then
           strtime = psub_get_contents(n0,r0)
           tmp = sub_get_chil_itms(n0,r0,strtime)
           ngantts.concat(tmp) if tmp.size > 0 
           tmp = sub_get_prev_process(n0,r0,strtime)
           ngantts.concat(tmp) if tmp.size > 0 
        else
           psub_get_contents(n0,{})
          #p "where itms_id = #{n0[:itm_id]} and locas_id = #{n0[:loca_id]} and processseq = #{n0[:processseq]} and priority = #{n0[:priority]} and Expiredate > sysdate"
        end
	 end	
     return ngantts
   end  ##  psub_get_itms_locas に登録されたitmsは削除

   def psub_get_contents(n0,r0)   ##n0→子の内容　r0→opeitm
     bgantt = {}
     ##debugger  ###opeitmsに登録さ
     itm = plsql.itms.first("where id = #{n0[:itm_id]} ")
	 if n0[:loca_id]
        loca = plsql.locas.first("where id = #{n0[:loca_id]} ")
	  else
	    rec = plsql.opeitms.first("where itms_id = #{r0[:itms_id]} and Expiredate > sysdate and Priority = #{r0[:priority]}   order by   processseq desc")
	    loca = plsql.locas.first("where id = #{rec[:locas_id]} ")
     end
     bgantt[n0[:seq].to_sym] = {:mlevel=>n0[:mlevel],:itm_code=>itm[:code],:itm_name=>itm[:name],:loca_code=>loca[:code],:loca_name=>loca[:name],:opeitm_duration=>(r0[:duration]||=1),
                                 :assigs=>"",:endtime=>n0[:endtime],:starttime=>n0[:endtime]-(r0[:duration]||=1)*24*60*60,:depends=>"",:nditm_parenum=>n0[:nditm_parenum],:nditm_chilnum=>n0[:nditm_chilnum],
                                 :subtblid=>"opeitms_"+r0[:id].to_s,:id=>n0[:id]}
    ##p " Line #{__LINE__} #{bgantt}"
     @bgantts.merge! bgantt
     return bgantt[n0[:seq].to_sym][:starttime]
   end

   def set_fields_from_gantt tblid,value ,command_r ###画面の内容をcommand_r for gantt screen     
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
                command_r[:loca_code] = value[:loca_code]
                command_r[:itm_code_nditm] = value[:itm_code]
                ###command_r[:loca_code_nditm] = value[:loca_code]   ===>opeitmsの作成
                command_r[:nditm_opeitm_id] = value[:paretblcode].split("_")[1].to_i if  value[:paretblcode].split("_")[0] == "opeitms"
                command_r[:nditm_expiredate] = Time.parse("2099/12/31")
      end
     return command_r
   end  
   def uploadgantt
        sio_user_code = plsql.persons.first(:email =>current_user[:email])[:id]  ||= 0   ###########   LOGIN USER
		sio_session_counter =   user_seq_nextval(sio_user_code) 
		command_r = {}
        params[:tasks].each do |key,value|
            command_r = {}
            command_r[:sio_user_code] = sio_user_code
		    command_r[:sio_session_counter] =   sio_session_counter
            tblid = value[:id].split("_")[0]
            case tblid 
                when  "0" then
                ##top record
                   next
                when "gantttmp"  then ### レコード追加
                    tblid = value[:id].split("_")[1]
                    command_r = set_fields_from_gantt(tblid,value,command_r)
                    command_r[:sio_classname] = "plsql_blk_insert"
                else
                    command_r = set_fields_from_gantt(tblid, value,command_r)
                    command_r[:sio_classname] = "plsql_blk_update"
            end
            @screen_code  = jqgrid_id = "r_" + tblid
            command_r[:sio_viewname]  = command_r[:sio_code] = @screen_code
			command_r.merge!(init_from_screen) 
            sub_insert_sio_c     command_r  ##
            unless  value[:subtblid].empty?  then
                command_r = {}
                command_r[:sio_user_code] = sio_user_code
		        command_r[:sio_session_counter] =   sio_session_counter
                subtblname = value[:subtblid].split("_")[0] 
                @screen_code  = jqgrid_id = "r_" + subtblname
               	command_r.merge!(init_from_screen)
                value[:id] = value[:subtblid]
                command_r = set_fields_from_gantt(subtblname, value,command_r)
                if  value[:subtblid].split("_")[1] then command_r[:sio_classname] = "plsql_blk_update"   else command_r[:sio_classname] = "plsql_blk_insert" end 
                command_r[:sio_viewname]  = command_r[:sio_code] = @screen_code
                command_r[:sio_user_code] = sio_user_code  
			    ##fprnt command_r
                sub_insert_sio_c     command_r  
            end
        end
        sub_userproc_insert command_r
        plsql.commit
        dbcud = DbCud.new
        dbcud.perform(command_r[:sio_session_counter],command_r[:sio_user_code])
        @ganttreturn = "retrurn ok"
   end

   
   def prv_resch   ##本日を起点に再計算
        dp_id = 1
        @bgantts.sort.each  do|key,value|    ###set dependon
           if key.to_s.size > 3 then
             @bgantts[key.to_s[0..-4].to_sym][:depends] << dp_id.to_s + "," 
           end
           dp_id += 1
        end

        today = Time.now
        @bgantts.sort.reverse.each  do|key,value|  ###計算
		  if key.to_s.size > 3
            if  value[:depends] == ""
		    	if @bgantts[key][:starttime]  <  today
                   @bgantts[key][:starttime]  =  today		   
                   @bgantts[key][:endtime]  =   @bgantts[key][:starttime] + value[:opeitm_duration]*24*60*60    ###稼働日考慮今なし
                end					  
			end
            if  (@bgantts[key.to_s[0..-4].to_sym][:starttime] ) < @bgantts[key][:endtime]
                 @bgantts[key.to_s[0..-4].to_sym][:starttime]  =   @bgantts[key][:endtime]   ###稼働日考慮今なし
                 @bgantts[key.to_s[0..-4].to_sym][:endtime] =  @bgantts[key.to_s[0..-4].to_sym][:starttime]  + @bgantts[key.to_s[0..-4].to_sym][:opeitm_duration] *24*60*60
				 ##p key
				 ##p @bgantts[key]
			end
          end
        end
		
        @bgantts.sort.each  do|key,value|  ###topから再計算
		  if key.to_s.size > 3
             if  (@bgantts[key.to_s[0..-4].to_sym][:starttime]  ) > @bgantts[key][:endtime]  			   
                      @bgantts[key][:endtime]  =   @bgantts[key.to_s[0..-4].to_sym][:starttime]    ###稼働日考慮今なし
                      @bgantts[key][:starttime] =  @bgantts[key][:endtime]  - value[:opeitm_duration] *24*60*60
             end					  
          end
        end
      return 
   end
end ## ganttController

