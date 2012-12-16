  require "rubygems"
  require "ruby-plsql"
  plsql.connection = OCI8.new("rails","tq6t7rjx","xe")
  require 'drb/drb'

class Blkclass
  def initialize cmd_ts 
      @chk_cmn = Hash.new 
      @@r_isnr = Hash.new 
      @cmd_ts = Array.new 
      @cmd_ts = cmd_ts
      const = "C"
      @chk_cmn =  plsql.__send__(@cmd_ts[4]).first("where term_id = :1 and session_id = :2 and session_counter = :3 and command_response = :4",@cmd_ts[1],@cmd_ts[2],@cmd_ts[3],const)
  end
  def chk_cmd
      @chk_cmn
  end  
  def plsql_paging  
    strwhere = ""   ###   未完成
    strorder = ""   ###  未完成
    @@r_isnr = @chk_cmn     
    @@r_isnr[:id] = nil
    @@r_isnr[:command_response] = "R"
    inf_sym = "inf_#{@chk_cmn[:viewname]}".downcase.to_sym 
    tmp_inf = @chk_cmn[inf_sym]
#####  count のwhereはまだ
    @@r_isnr[:totalcount] =  plsql.__send__(@chk_cmn[:viewname]).count
    r_cnt = 0
    plsql.o2r_cursor(@chk_cmn[:viewname],strwhere,strorder ) do |cursor|
        rec = cursor.fetch_hash
        until rec.nil?
              r_cnt += 1
              if r_cnt >= @chk_cmn[:start_record] and r_cnt <= @chk_cmn[:end_record] then
                 tmp_inf.keys.each do |k|
                    @@r_isnr[inf_sym][k] = rec[k]
                 end   
                 @@r_isnr[:recordcount] = r_cnt
                 @@r_isnr[:replay_time] = Time.now
                 @@r_isnr[:result_f] = '0'
                 plsql.__send__(@cmd_ts[4]).insert @@r_isnr
              end  ##if
        rec = cursor.fetch_hash
        end ## until   
    end ##cursor  
    if   @@r_isnr[:totalcount] == 0 or r_cnt == 0 then
         ######## no data 
         @@r_isnr[:recordcount] = r_cnt
         @@r_isnr[:replay_time] = Time.now
         @@r_isnr[:result_f] = '1'
         plsql.__send__(@cmd_ts[4]).insert @@r_isnr
      else
         #####  ok 
     end       
     plsql.commit
     $ts.write(["R",@cmd_ts[1],@cmd_ts[2],@cmd_ts[3],@cmd_ts[4]])
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
rescue
  p "thread error"  # => "unhandled exception"
end 


 (?h(?h� 