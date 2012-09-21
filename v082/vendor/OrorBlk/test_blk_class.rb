  require "rubygems"
  require "ruby-plsql"
  plsql.connection = OCI8.new("rails","tq6t7rjx","xe")
  require "D:/plsql/v07/vendor/OrorBlk/blk_class.rb"

######################################
### cmd_ts
### o:C R E 1: term_id   2:session_id  3:session_counter  4:interface_tbl_name
######################################
    cmd_ts = []
    cmd_ts[0] = "C"
    cmd_ts[1] = "127.0.0.1"
    cmd_ts[2] = "b0bc8819ac89823ebc12cfa16bd667ea"
    cmd_ts[3] = 303
    cmd_ts[4] = "SIO_R_SCREENS"
    subtask = Blkclass.new cmd_ts 
    subtask.__send__(subtask.chk_cmd[0][:classname])


     plsql.commit
 ###    $ts.write(["R",@cmd_ts[1],@cmd_ts[2],@cmd_ts[3],@cmd_ts[4]])