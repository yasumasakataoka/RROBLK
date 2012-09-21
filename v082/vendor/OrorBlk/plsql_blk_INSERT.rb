  require "rubygems"
  require "ruby-plsql"
  plsql.connection = OCI8.new("rails","tq6t7rjx","xe")
  require 'drb/drb'

class Blkclass
  def initialize cmd_ts 
      p "a" + Time.now.to_s
      @chk_cmn = Hash.new 
      @r_isnr = Hash.new 
      @cmd_ts = Array.new 
      @cmd_ts = cmd_ts
      const = "C"
      @chk_cmn =  plsql.__send__(@cmd_ts[4]).first("where term_id = :1 and session_id = :2 
                                                    and session_counter = :3 
                                                    and command_response = :4",
                                                    @cmd_ts[1],@cmd_ts[2],@cmd_ts[3],const)
     p "b" + Time.now.to_s 
  end
  def chk_cmd
      @chk_cmn
  end  
  def plsql_  
    ## p "c-0" + Time.now.to_s  
    strwhere = ""   ###   未完成
    strorder = ""   ###  未完成
    @r_isnr = @chk_cmn     
    @r_isnr[:id] = nil
    @r_isnr[:command_response] = "R"
    inf_sym = "inf_#{@chk_cmn[:viewname]}".to_sym 
    tmp_inf = @chk_cmn[inf_sym]
#####  count のwhereはまだ
#####   strsqlにコーディングしてないときは、viewをしよう
    tmp_sql = if @chk_cmn[:strsql].nil? then @chk_cmn[:viewname] else @chk_cmn[:strsql] end
    cnt_strsql = "SELECT 1 FROM " + tmp_sql
    p "c-a #{cnt_strsql} " + Time.now.to_s  
    @r_isnr[:totalcount] =  plsql.select(:all,cnt_strsql).count
    p "c-b" + Time.now.to_s  
    
    strsql = "SELECT * FROM " + tmp_sql
    chk_fields = plsql.select(:first,strsql)
    p "c-c  #{chk_fields}" + Time.now.to_s  
    strfields = chk_fields.keys.join(',').to_s
    strsql = "select #{strfields} from (SELECT rownum cnt,a.* FROM #{tmp_sql} a) "
    r_cnt = 0
    
    p "strfields : #{strfields}"
    p "c-1" + Time.now.to_s  ### plsql.select(:all, "#{strsql}").each do |j|が遅い
    strsql  <<    " WHERE  cnt <= #{@r_isnr[:end_record]}  and  cnt >= #{@r_isnr[:start_record]} "
    tmp_seq = "#{@cmd_ts[4]}_seq"
    pagedata = plsql.select(:all, strsql)
    pagedata.each do |j|
        r_cnt += 1
         ##   @r_isnr.merge j なぜかうまく動かない。
         p "j : #{j}"
         j.each do |j_key,j_val|
           @r_isnr[j_key]   = j_val if j_key.to_s != "id"  ## sioのidとｖｉｅｗのｉｄが同一になってしまう
           @r_isnr[:id_tbl] = j_val if j_key.to_s == "id"
         end  
         @r_isnr[:recordcount] = r_cnt
         @r_isnr[:replay_time] = Time.now
         @r_isnr[:result_f] = "0" 
         p "tmp_seq : #{tmp_seq}"
         @r_isnr[:id] = plsql.__send__(tmp_seq).nextval
         p "@r_isnr : #{@r_isnr}"
         plsql.__send__(@cmd_ts[4]).insert @r_isnr
    end ##    plsql.select(:all, "#{strsql}").each do |j|
    p  "d" + Time.now.to_s 
    if   @r_isnr[:totalcount] == 0 or r_cnt == 0 then
         ######## no data 
         @r_isnr[:recordcount] = r_cnt
         @r_isnr[:replay_time] = Time.now
         @r_isnr[:result_f] = '1'
         @r_isnr[:id] = plsql.__send__(tmp_seq).nextval
         plsql.__send__(@cmd_ts[4]).insert @r_isnr
      else
         #####  ok 
     end       
     plsql.commit
     $ts.write(["R",@cmd_ts[1],@cmd_ts[2],@cmd_ts[3],@cmd_ts[4]])
 ###     p  "e" + Time.now.to_s 
  end   ###plsql_paging
  end 

DRb.start_service
$ts = DRbObject.new_with_uri('druby://localhost:12345')

######################################
### cmd_ts
### 1: term_id   2:session_id  3:session_counter  4:interface_tbl_name
######################################
#### irbしか動かない。
cmd_ts = ["C","S",nil,nil,nil]
begin
  while cmd_ts[1] != "E"
    cmd_ts  = $ts.take(["C",nil,nil,nil,nil])
##    t = Thread.new do
    subtask = Blkclass.new cmd_ts 
    subtask.__send__(subtask.chk_cmd[:classname])
##  end
###  t.join ####joinしないと動かない　なぜ?
  end
rescue Exception => e #例外を取得
  p e.backtrace
  p "thread error"  # => "unhandled exception"
 end 
