# -*- coding: utf-8 -*-  
require "rubygems"
  require 'time'
  require "ruby-plsql"
  plsql.connection = OCI8.new("rails","rails","xe")
  def  fprnt str
    foo = File.open("gantt.log","a")
    foo.puts str
    foo.close 
 end 
 def psub_get_itms_locas ngantts ### bgantt 表示内容　ngantt treeスタック
     ##ngantts[:seq,:level,:loca_id,:itm_id]
     ##@bgantts{seq=>{:itm,:loca,:level,:duration,:assigs,}}
     n0 = ngantts.shift
     p "n0:#{n0}"
     r0 =  plsql.opeitms.first("where itms_id = #{n0[:itm_id]} and locas_id = #{n0[:loca_id]} and processseq = #{n0[:processseq] ||= 999} and priority = #{n0[:priority]} and Expiredate > sysdate")
     if r0 then
         endtime = psub_get_contents(n0,r0)
         ngantts.concat(psub_get_chil_itms(n0,r0,endtime))
         ngantts.concat(psub_get_next_process(n0,r0,endtime))
        else
           psub_get_contents(n0,{})
          p "where itms_id = #{n0[:itm_id]} and locas_id = #{n0[:loca_id]} and processseq = #{n0[:processseq]} and priority = #{n0[:priority]} and Expiredate > sysdate"
     end
     return ngantts
 end  ##  psub_get_itms_locas 
 def psub_get_contents(n0,r0)
     bgantt = {}
     itm = plsql.itms.first("where id = #{n0[:itm_id]} ")
     loca = plsql.locas.first("where id = #{n0[:loca_id]} ")
     bgantt[n0[:seq].to_sym] = {:leveL=>n0[:level],:itm=>"#{itm[:code]}（ #{itm[:name]} ）",:loca=>"#{loca[:code]} （#{loca[:name]} ）",:during=>r0[:lt],:assigs=>"",:endtime=>n0[:endtime],:starttime=>n0[:endtime]-(r0[:lt]||=0)*24*60*60,:depends=>[]}
    ###p " Line #{__LINE__} #{bgantt}"
     @bgantts.merge! bgantt
     return n0[:endtime]-(r0[:lt]||=0)*24*60*60
 end
 def psub_get_chil_itms(n0,r0,endtime)
     ngantts = []
     rnditms = plsql.nditms.all("where opeitms_id = #{r0[:id]} and Expiredate > sysdate ")
     if rnditms.size > 0 then
        level = n0[:level]
        level += 1
        rnditms.each.with_index(1)  do |i,cnt|
           ngantts << {:seq=>n0[:seq] + sprintf("%03d", cnt),:level=>level,:itm_id=>i[:itms_id_nditm],:loca_id=>i[:locas_id_nditm],:priority=>r0[:priority],:endtime=>endtime}
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
           ngantts << {:seq=>(nseq + sprintf("%02d", cnt)),:level=>n0[:level],:itm_id=>i[:itms_id],:loca_id=>i[:locas_id],:endtime=>endtime}
        end         
     end
     return ngantts
 end
  p "start"
   ngantts = []
  ## {n0[:itm_id]} and locas_id = #{n0[:loca_id]} and processseq = #{n0[:processseq]} and priority = #{n0[:priority]}
  itm = plsql.itms.first("where code = '#{ARGV[0]}' and Expiredate > sysdate AND ROWNUM <2 ")
  r = plsql.opeitms.first("where itms_id = '#{itm[:id]}' and Expiredate > sysdate AND ROWNUM <2   order by processseq desc,priority desc")
  if r then 
     ngantts << {:seq=>"001",:level=>1,:itm_id=>r[:itms_id],:loca_id=>r[:locas_id],:processseq=>r[:processseq],:priority=>r[:priority],:endtime=>Time.now}
     cnt = 0
     @bgantts = {}
     @bgantts[:"000"] = {:leveL=>0,:itm=>"#{itm[:code]}（ #{itm[:name]} ）",:loca=>"",:during=>"",:assigs=>"",:endtime=>Time.now,:starttime=>nil,:depends=>[]}

     until ngantts.size == 0
          cnt += 1
          ngantts = psub_get_itms_locas ngantts
          break if cnt >= 5
     end
  end
  id = 0
  min_starttime = Time.now
  @bgantts.sort.each  do|key,value|
     id += 1
     @bgantts[key].merge! :id=>id   
     @bgantts[key.to_s[0..-4].to_sym][:depends] <<id if key.to_s.size > 3
     min_starttime = @bgantts[key][:starttime] if  min_starttime > (@bgantts[key][:starttime]||=Time.now)
  end
  ntime = ( Time.now -  min_starttime )
  strgantt = %Q|{"#{ARGV[0]}":[|
  @bgantts.sort.each  do|key,value|
     strgantt << %Q|{"id":"#{value[:id]}","name":"#{value[:itm]}","code":"#{value[:loca]}","level":#{value[:level]},"start":#{(value[:starttime]+ntime).to_i.*1000},"duration":#{value[:during]},"end":#{(value[:endtime]+ntime).to_i.*1000},"assigs":[],"depends":"#{value[:depends].join(':')}"},|
  end
   strgantt = strgantt.chop + %Q|],"selectedRow":0,"deletedTaskIds":[],"canWrite":true,"canWriteOnParent":true }|

  p "gantt  #{@bgantts}"
  fprnt strgantt
