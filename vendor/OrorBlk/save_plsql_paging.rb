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
      @chk_cmn =  plsql.__send__(@cmd_ts[4]).first("where term_id = :1 and session_id = :2 and session_counter = :3 and command_response = :4",@cmd_ts[1],@cmd_ts[2],@cmd_ts[3],const)
      p "b" + Time.now.to_s 
  end
  def chk_cmd
      @chk_cmn
  end  
  def plsql_paging  
    p "c" + Time.now.to_s 
    strwhere = ""   ###   未完成
    strorder = ""   ###  未完成
    @r_isnr = @chk_cmn     
    @r_isnr[:id] = nil
    @r_isnr[:command_response] = "R"
    inf_sym = "inf_#{@chk_cmn[:viewname]}".downcase.to_sym 
    tmp_inf = @chk_cmn[inf_sym]
#####  count のwhereはまだ
    @r_isnr[:totalcount] =  plsql.__send__(@chk_cmn[:viewname]).count
    r_cnt = 0
    
    p "c-1" + Time.now.to_s
    sqlstr = "SELECT A.* FROM " 
    sqlstr  <<    " (SELECT A.* FROM #{@chk_cmn[:viewname]} A #{strwhere} #{strorder}) A " 
    sqlstr  <<    "       WHERE ROWNUM  < = #{@chk_cmn[:end_record]} "
    sqlstr  <<    "        AND NOT EXISTS(SELECT 1 FROM ( "
    sqlstr  <<    "                       SELECT B1.* FROM "
    sqlstr  <<    "                          (SELECT B.* FROM #{@chk_cmn[:viewname]}  B #{strwhere} #{strorder}) B1 "
    sqlstr  <<    "                              WHERE ROWNUM < #{@chk_cmn[:start_record]}) B2 "
    sqlstr  <<    "                     WHERE   A.ID = B2.ID) "
    
    p "c-2" + Time.now.to_s 
    plsql.select(:all, "#{sqlstr}").each do |j|
        r_cnt += 1
        tmp_inf.keys.each do |k|
            @r_isnr[inf_sym][k] = j[k]
         end   
         @r_isnr[:recordcount] = r_cnt
         @r_isnr[:replay_time] = Time.now
         @r_isnr[:result_f] = '0'
         plsql.__send__(@cmd_ts[4]).insert @r_isnr
         p "c-3" + Time.now.to_s 
    end ## until   
    p  "d" + Time.now.to_s 
    if   @r_isnr[:totalcount] == 0 or r_cnt == 0 then
         ######## no data 
         @r_isnr[:recordcount] = r_cnt
         @r_isnr[:replay_time] = Time.now
         @r_isnr[:result_f] = '1'
         plsql.__send__(@cmd_ts[4]).insert @r_isnr
      else
         #####  ok 
     end       
     plsql.commit
     $ts.write(["R",@cmd_ts[1],@cmd_ts[2],@cmd_ts[3],@cmd_ts[4]])
      p  "e" + Time.now.to_s 
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
      p "f" + Time.now.to_s
##    t = Thread.new do
    subtask = Blkclass.new cmd_ts 
    p "g" + Time.now.to_s
    subtask.__send__(subtask.chk_cmd[:classname])
    p "h" + Time.now.to_s
##  end
###  t.join ####joinしないと動かない　なぜ?
  end
rescue
  p "thread error"  # => "unhandled exception"
end 
