# RorBlk
 module Ror_blk

   def getblkpobj code,ptype     ## fieldsの名前
       tmp_person =  plsql.r_persons.first(:person_email =>current_user[:email])
       ##  p " current_user[:email] #{current_user[:email]}"
       if tmp_person.nil?
          render :text => "add persons to your email "  and return 
            else
          user_code = tmp_person[:person_code]
       end 
      if code =~ /_ID/ or   code == "ID" then
         oragname = code
        else
         orgname = ""      
         basesql = "select pobjgrp_name from R_POBJGRPS where USERGROUP_CODE = '#{user_code}' and   "
         fstrsql  =  basesql  +  " POBJECT_CODE = '#{code}' and POBJECT_OBJECTTYPE = '#{ptype}' "
         ###  フル項目で指定しているとき
         orgname = plsql.select(:first,fstrsql)[:pobjgrp_name]  unless plsql.select(:first,fstrsql).nil?
         ## p "orgname #{orgname}"
         ## p "code #{code}"
         if orgname.empty? or orgname.nil? then
            orgname = ""
            code.split('_').each do |i|
              fstrsqly =  basesql +  "   POBJECT_CODE = '#{i}' "
              # p pstrsqly
              unless plsql.select(:first,fstrsqly).nil? then   ## tbl name get
                  orgname << plsql.select(:first,fstrsqly)[:pobjgrp_name]
               end   
            end   ## do code. 
         end ## iforgname
            orgname = code if orgname == "" or orgname.nil?
      end  ## if ocde
      return orgname 
  end  ## def getpobj
  def fprnt str
    foo = File.open("blk#{Process::UID.eid.to_s}.log", "a") # 書き込みモード
    foo.puts str
    foo.close
  end   ##fprnt str
  def insert_sio_r tmp_sio_record_r
      tmp_sio_record_r[:sio_replay_time] = Time.now
      tmp_sio_record_r[:sio_command_response] = "R"
      tmp_seq = "SIO_#{tmp_sio_record_r[:sio_viewname]}_seq"
      tmp_sio_record_r.each_key do |j_key|  
             tmp_sio_record_r.delete(j_key) if tmp_sio_record_r[j_key].nil?
      end
      ## fprnt "class #{self} LINE :#{__LINE__} tmp_sio_record_r[:sio_viewname] =  #{tmp_sio_record_r[:sio_viewname]}  command_r #tmp_{to_command_r}  "
      tmp_sio_record_r[:id] = plsql.__send__(tmp_seq).nextval
      plsql.__send__("SIO_#{tmp_sio_record_r[:sio_viewname]}").insert tmp_sio_record_r
  end   ##insert_sio_r  
  def get_show_data screen_code 
     show_cache_key =  "show " + screen_code
     ## debugger
     if Rails.cache.exist?(show_cache_key) then
	 ## create_def(screen_code)  unless respond_to?("process_scrs_#{screen_code}")
         show_data = Rails.cache.read(show_cache_key)
     else 
	 ### create_def screen_code
	 show_data = set_detail  screen_code  ## set gridcolumns
     end
     ## debugger
     return show_data
 end
 def set_detail screen_code
      show_data = {}
      det_screen = plsql.r_detailfields.all(
                                "where screen_code = '#{screen_code}'
                                 and detailfield_selection = 1 order by detailfield_seqno ")  ###有効日の考慮
                                 
           ## when no_data 該当データ 「r_DetailFields」が無かった時の処理
           if det_screen.empty?
              ### debugger ## textは表示できないのでメッセージの変更要
	      p  "Create DetailFields #{screen_code} by crt_r_view_sql.rb"
              render :text => "Create DetailFields #{screen_code} by crt_r_view_sql.rb"  and return 
           end   
           ###
           ### pare_screen = det_screen[0][:detailfield_screens_id]
           pare_screen = det_screen[0][:screen_id]
           screen_viewname = det_screen[0][:screen_viewname].upcase
           ### debugger ## 詳細項目セット
           show_data[:scriptopt] = set_addbutton(pare_screen)     ### add  button セット script,gear,....
	   gridcolumns = []
           ###  chkの時のみ
           gridcolumns   << {:field => "msg_ok_ng",
                                        :label => "msg",
                                        :width => 37,
                                        :editable =>  false  } 
           allfields = []
           allfields << "msg_ok_ng".to_sym
           alltypes = {} 
	   icnt = 0
	   det_screen.each do |i|  
                ## lable名称はユーザ固有よりセット    editable はtblから持ってくるように将来はする。
                ##    fprnt " i #{i}"
                   tmp_editrules = {}
                   tmp_columns = {}
                   tmp_editrules[:required] = true  if i[:detailfield_indisp] == 1
                   tmp_editrules[:number] = true if i[:detailfield_type] == "NUMBER"
                   tmp_editrules[:date] = true  if i[:detailfield_type] == "DATE"
                   tmp_editrules[:required] = false  if tmp_editrules == {} 
                   tmp_columns[:field] = i[:detailfield_code].downcase
                   tmp_columns[:label] = getblkpobj(i[:detailfield_code],"1") 
                   tmp_columns[:label] ||=  i[:detailfield_code]
                   tmp_columns[:hidden] = if i[:detailfield_hideflg] == 1 then true else false end 
                   tmp_columns[:editrules] = tmp_editrules 
                   tmp_columns[:width] = i[:detailfield_width]
                   tmp_columns[:search] = if i[:detailfield_paragraph]  == 0 and  screen_code =~ /^H\d_/   then false else true end
                   if i[:detailfield_editable] == 1 then
		      tmp_columns[:editable] = true
		      tmp_columns[:editoptions] = {:size => i[:detailfield_edoptsize],:maxlength => i[:detailfield_maxlength] ||= i[:detailfield_edoptsize] }
		     else
		      tmp_columns[:editable] = false
		   end
		   tmp_columns[:edittype]  =  i[:detailfield_type]  if  ["textarea","select","checkbox"].index(i[:detailfield_type]) 
		   if i[:detailfield_type] == "SELECT" or  i[:detailfield_type] == "CHECKBOX" then
		      tmp_columns[:editoptions] = {:value => i[:detailfield_value] } 
		   end
		   if i[:detailfield_type] == "textarea" then
		      tmp_columns[:editoptions] =  {:rows =>"#{i[:detailfield_edoptrow]}",:cols =>"#{i[:detailfield_edoptcols]}"}
		   end
                   if  tmp_columns[:editoptions].nil? then  tmp_columns.delete(:editoptions)  end 
                   ## tmp_columns[:edittype]  =  i[:detailfield_type]  if  ["textarea","select","checkbox"].index(i[:detailfield_type]) 
		   ## debugger
                   if  i[:detailfield_rowpos]     then
			if  i[:detailfield_rowpos]  < 999
                            tmp_columns[:formoptions] =  {:rowpos=>i[:detailfield_rowpos] ,:colpos=>i[:detailfield_colpos] }
			    icnt = i[:detailfield_rowpos] if icnt <  i[:detailfield_rowpos] 
		          else
			    tmp_columns[:formoptions] =  {:rowpos=> icnt += 1,:colpos=>1 }
			end
		       else
                           tmp_columns[:formoptions] =  {:rowpos=> icnt += 1,:colpos=>1 }
		   end 	      
		   gridcolumns << tmp_columns 
                   allfields << i[:detailfield_code].downcase.to_sym  
                   alltypes [i[:detailfield_code].downcase.to_sym] =  i[:detailfield_type].downcase 
           end   ## detailfields.each
	   show_data[:allfields] =  allfields  
           show_data[:alltypes]  =  alltypes  
           show_data[:screen_viewname] = screen_viewname.upcase
           show_data[:gridcolumns] = gridcolumns
	show_data =  set_extbutton(pare_screen,show_data,screen_code) 
        show_cache_key =  "show " + screen_code
        Rails.cache.write(show_cache_key,show_data) 
	return show_data
  end    ##set_detai
  def set_extbutton pare_screen,show_data,screen_code     ### 子画面用のラジオボ タンセット
      ##  debugger
      ### 同じボタンで有効日が>sysdateのデータが複数あると複数ボタンがでる
      rad_screen = plsql.r_chilscreens.select(:all,"where chilscreen_Expiredate > sysdate 
                                            and screen_id = :1",pare_screen)
           t_extbutton = ""
           t_extdiv_id = ""
           k = 0
           rad_screen.each do |i|     ###child tbl name sym
               ### view name set
               hash_key = "#{i[:screen_viewname].downcase}".to_sym 
                  k += 1
                  t_extbutton << %Q|<input type="radio" id="radio#{k.to_s}"  name="nst_radio#{screen_code}"|
                  t_extbutton << %Q| value="#{i[:screen_viewname]};#{i[:screen_viewname_chil]};| ### 親のview
                  t_extbutton << %Q|#{i[:screen_code_chil]};1"/>|  
                  t_extbutton << %Q| <label for="radio#{k.to_s}">  #{getblkpobj(i[:screen_code_chil],"A")} </label> |
                  t_extdiv_id << %Q|<div id="div_#{i[:screen_viewname]}#{i[:screen_viewname_chil]}"> </div>|
      
        end   ### rad_screen.each
	show_data[:extbutton] =  t_extbutton
	show_data[:extdiv_id] =  t_extdiv_id
	return show_data
  end    ## set_extbutton pare_screen  
  end   ##module Ror_blk

 
