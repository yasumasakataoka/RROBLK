  require "rubygems"
  require "ruby-plsql"
  plsql.connection = OCI8.new("rails","rails","xe")
  require File.dirname(__FILE__) +  "/blk_class.rb"
  require 'drb/drb'

######################################
### cmd_ts
### o:C R E 1: term_id   2:session_id  3:session_counter  4:interface_tbl_name
######################################

 DRb.start_service
$ts = DRbObject.new_with_uri('druby://localhost:12345')

cmd_ts = ["C","S",nil,nil,nil]
begin
  while cmd_ts[1] != "E"
    cmd_ts  = $ts.take(["C",nil,nil,nil,nil])
    subtask = Blkclass.new cmd_ts 
    subtask.__send__(subtask.command_r[:sio_classname]) 
    plsql.commit
    p " subtask.command_r[:sio_classname]  : #{subtask.command_r[:sio_classname]}"
    case subtask.command_r[:sio_classname]
         when "plsql_blk_paging"
              $ts.write(["R",cmd_ts[1],cmd_ts[2],cmd_ts[3],cmd_ts[4]])
              p "cmd_ts = #{cmd_ts}"
    end
  end   ### while cmd_ts[1] != "E"

rescue Exception => e #例外を取得
  p e.backtrace
  p "thread error"  # => "unhandled exception"
 end 
