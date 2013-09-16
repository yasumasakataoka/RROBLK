##definde_method process_scrs_code do  |tmp_sio_record_r|
##  record_auto tmp_sio_record_r,totbl,field
###end
#:table=>"aaa"
#:field=>{:aaaa=> fa + fb,:bbbb=>xxxx(zzzz)}	
# fa,zzzzはtmp_sio_record_rのレコード名
### 必須　文法チェックは画面でする。
def create_def
save_code = ""
rs = plsql.r_processscrs.select(:all,"where PROCESSSCR_EXPIREDATE> sysdate order by screen_code,PROCESSSCR_EXPIREDATE")
cmdstr = " def process_scrs_#{r[:screen_code]} tmp_sio_record_rn "
    rs .each do |r|
	 if save_code != r[:screen_code] then
		r[:ymlcode].split.each do |yml|
		case 
                when yml =~ /^:table/
		     cmdstr << "\n" + "reord_auto tmp_sio_record_r,"
                when yml  =~ /^:field/
		     cmdstr << "," + yml.split(/=>/,2)[1]
                when yml  =~ /^:subcmd/
		     cmdstr << "\n" + yml.split(/=>/,2)[1] 
		end	
	    end
	    cmdstr << "\n end"
	    eval(cmnstr)
	    save_code = r[:screen_code] 
         end  ## if
    end  ##rs
end
def record_auto tmp_sio_record_r,totbl,fields = {}
    orgtbl = tmp_sio_record_r[:sio_viewname].split(/_/,3)[2].chop
    totbl.chop!
    to_command_r = {} 
    show_cache_key =  "show R_" +  totbl.upcase
    if  Rails.cache.exist?(show_cache_key) then 
         show_data = Rails.cache.read(show_cache1_key)
     else 
         show_data = set_detail(screen_code)  ## set @gridcolumns 
     end	
     tmp_sio_record_r.each do |k,val| 
	key = k.to_s
	j = key.sub(orgtbl,totbl).to_sym
	if key =~ /^sio_/  or show_data[:allfield].key?(j) 
		to_command_r[j] = val if fields[j].nil?
		to_command_r[j] = eval(fields[j]) unless fields[j].nil?
        end
    end
    if to_command_r[:sio_classname] =~ /insert/ then
	to_command_r[:sio_org_tblid]  = to_command_r[:id_tbl] 
        to_command_r[:sio_org_tblname]  =  orgtbl
        to_command_r[:sio_classname] = "plsql_blk_copy_insert"
    end	
    to_command_r[:sio_viewname] = "R_" +  totbl.upcase
    to_command_r[:id] =  plsql.__send__("SIO_#{command_r[:sio_viewname]}_SEQ").nextval
    to_command_r[:sio_session_counter] = plsql.sessioncounters_seq.nextval  ### user_id に変更
    to_command_r[:sio_add_time] = Time.now
    to_command_r.delete(:msg_ok_ng)  ## sioに照会・更新依頼時は更新結果は不要
    fprnt " class #{self} : LINE #{__LINE__} sio_\#{ command_r[:sio_viewname] } :sio_#{command_r[:sio_viewname]}"
    fprnt " class #{self} : LINE #{__LINE__} to_command_r #{to_command_r}"
      ## debugger
    plsql.__send__("SIO_#{command_r[:sio_viewname]}").insert to_command_r
    plsql.commit 
    dbcud = DbCud.new
    dbcud.perform(to_command_r[:sio_session_counter],"SIO_#{to_command_r[:sio_viewname]}")
  end   ## subcopyinsertsio 


