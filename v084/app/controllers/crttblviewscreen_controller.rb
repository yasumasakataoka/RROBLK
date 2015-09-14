class CrttblviewscreenController < ImportfieldsfromoracleController
#### 残作業
### 開発環境でしか動かないようにすること。
### テーブルに項目を追加すると　railsの再起動が必要　　plsqlのlogoff connnectで解決　2014/6/25
### id等の必須key check
###  xxx_idの重複チェック

	before_filter :authenticate_user!  
	def index
		if  rec = plsql.r_blktbs.first("where id = #{params[:jqgrid_id]}  ") then 
			if rec[:blktb_expiredate] > Time.now then
				plsql.logoff
				plsql.connect! "rails", "rails", :host => "localhost", :port => 1521, :database => "xe"
				sub_crt_tbl_view_screen rec[:pobject_code_tbl],rec[:id]
				##Rails.cache.clear(nil)
            else
             @errmsg = "out of expiredate"
			end
        else
             @errmsg = " id not correct"
		end
	end
	def sub_crt_tbl_view_screen  pobject_code_tbl,rec_id
		begin
			@errmsg = ""
			if rec_id.nil? then 
				tmp_rec_id = plsql.r_blktbs.first("where pobject_code_tbl = '#{pobject_code_tbl}' and pobject_objecttype_tbl = 'tbl' and blktb_expiredate > sysdate ")
				if  tmp_rec_id then
					rec_id = tmp_rec_id[:id]
				else
					@errmsg = " id not found"
				end
			end
			##allrecs = plsql.blktbsfieldcodes.all("where blktbs_id = #{rec_id}   and  expiredate > sysdate order by connectseq")
			allrecs = plsql.blktbsfieldcodes.all("where blktbs_id = #{rec_id}   and  expiredate > sysdate ")
			if allrecs.size>0 then
				if proc_chk_tble_exist(pobject_code_tbl) 
					add_modify = "modify"
					@strsql0 = ""
					columns = proc_blk_columns(pobject_code_tbl)
					prv_modify_tbl_field pobject_code_tbl,allrecs,columns
				else
					add_modify = "add"
					prv_add_tbl_field pobject_code_tbl,allrecs
				end
			else  ##if allrecs
				@errmsg << "table #{pobject_code_tbl} missing or  blktbsfieldcodes not exists "
				raise
			end   ##if allrecs
			allrecs = plsql.blktbsfieldcodes.all("where blktbs_id = #{rec_id}   and  expiredate > sysdate")
			create_or_replace_view   rec_id,pobject_code_tbl
			Rails.cache.clear(nil)
			create_screenfields "r_"+pobject_code_tbl
			proc_set_search_code_of_screen        "r_"+pobject_code_tbl
			chk_index  pobject_code_tbl,columns if columns
		rescue
			plsql.rollback
			@errmsg << $!.to_s
			@errmsg << $@.to_s
			fprnt"class #{self} : LINE #{__LINE__} @errmsg: #{@errmsg} " 
		else
			@errmsg << "  nothing "  
			plsql.commit  
		end   ##begin
	end
	def proc_set_search_code_of_screen   pobject_code_scr    
		##keys = plsql.user_ind_columns.all("  where table_name = '#{pobject_code_tbl}' and  column_position = 1")
		### 以下　blkukysに変更して　全面コーディングし直した　2014/12/26
		strsql = "select * from r_screenfields where pobject_code_scr = '#{pobject_code_scr}' "
		screenfields = ActiveRecord::Base.connection.select_all(strsql)
		screenfields.each do |key|
			tgtblchop = key["pobject_code_sfd"].split("_")[0].chop
			if key["pobject_code_sfd"] =~ /_code/ and key["screenfield_indisp"] == "1" and  tgtblchop != pobject_code_scr.split("_",2)[1]
				strsql = "select * from r_blkukys 
				           where pobject_code_tbl = '#{tgtblchp}s'  and pobject_code_fld = '#{key["pobject_code_sfd"].split("_")[1]}'"
				ukygrp = ActiveRecord::Base.connection.select_one(strsql)
				dlm = ""
				if ukysgrp.nil?  ###_xxxを使用していた時
					strsql = "select * from r_blkukys 
				           where pobject_code_tbl = '#{tgtblchop}s'  and pobject_code_fld = '#{tgtblchop}_code}'"
					ukygrp = ActiveRecord::Base.connection.select_one(strsql)
					dlm = key["pobject_code_sfd"].split("_code",2)[1]
				end
				strsql = "select * from r_blkukys 
				           where pobject_code_tbl = '#{pobject_code_scr.split("_",2)[1]}'  and blkuky_grp = '#{ukygrp["blkuky_grp"]}'"
				ukys = ActiveRecord::Base.connection.select_one(strsql)
				ukys.each do|ukey|
					strsql = "select * from r_screenfields where pobject_code_scr = '#{pobject_code_scr}' and 
					                                             pobject_code_sfd = '#{ukey["pobject_code_sfd"]+dlm}'"  ###dlm = "_xxxx"
					screenfield = ActiveRecord::Base.connection.select_one(strsql)
					if screenfield["screenfield_paragraph"].nil?
						updatestr = ""
						if   screenfield["screenfield_remark"] !~ /by proc_set_search_code_of_screen/  
							updatestr << if screenfield["screenfield_remark"].size <  50  then %Q& remark = '#{screenfield["screenfield_remark"]} _ by proc_set_search_code_of_screen'  & else ""  end
						end
						updatestr << %Q&,paragraph = '#{pobject_code_scr + if dlm == "" then "" else ":" + dlm end}' &
						Screenfield.where(:id=>screenfield["id"]).update_all(updatestr)
					end
                end	
			end
			if key["pobject_code_sfd"] =~ /_sno_/ and key["screenfield_indisp"] == "1" and key["pobject_code_sfd"].split("_")[0] == pobject_code_scr.split("_",2)[1].chop
				if screenfield[:screenfield_paragraph].nil?
					updatestr = %Q& paragraph = 'r_#{pobject_code_scr.split("_")[1][3..-1]}#{key["pobject_code_sfd"].split("_sno_")[1]}s'&  ## xxxords,xxxinsts  xxx は3桁
					Screenfield.where(:id=>key["id"]).update_all(updatestr)
				end
            end	
		end
	end
	def prv_add_tbl_field tblname,allrecs
		mandatory_field =  prv_init
		@strsql0 = "create table #{tblname} ("
		tmpstrsql ={}
		allrecs.each do |rec|
			frec = ActiveRecord::Base.connection.select_one("select * from r_fieldcodes where id = #{rec[:fieldcodes_id]} and fieldcode_ftype not like 'vf%' ")  ### vfield は登録しない
			next if frec.nil?		  
			tmpstrsql[frec["pobject_code_fld"].to_sym]= frec["pobject_code_fld"] + " " + frec["fieldcode_ftype"] + 
                case frec["fieldcode_ftype"]
                    when /char/ then
                        "(#{frec["fieldcode_fieldlength"]}) ,"
                    when "number" then
                        %Q%(#{if frec["fieldcode_dataprecision"] == 0  or frec["fieldcode_dataprecision"].nil? then "38),\n" 
								else frec["fieldcode_dataprecision"].to_s + "," + (frec["fieldcode_datascale"]||0).to_s + " ) ,\n" end }%
					else
                             ","
                 end
			mandatory_field.delete( frec["pobject_code_fld"].to_sym) 
         end
		rec0 = allrecs[0]
		rec0[:expiredate]=Time.parse("2099/12/31")
		rec0[:created_at] = Time.now
		rec0[:updated_at] = Time.now
		mandatory_field.each do |key,value|
			tmpstrsql[value[0].to_sym] = value[1] +  value[2]
			rec0[:id] = proc_get_nextval("blktbsfieldcodes_seq")
			id = ActiveRecord::Base.connection.select_one("select * from fieldcodes where pobjects_id_fld = (select id from pobjects where code = '#{value[1]}' 
                                                   and objecttype = 'tbl_field' and expiredate  > current_date)")
			if id
				rec0[:fieldcodes_id]  = id["id"] 
				##rec0[:seqno] = value[0]
				###plsql.blktbsfieldcodes.insert rec0 
				Blktbsfieldcode.create(rec0)
			end
		end
		tmpstrsql.sort.each do |key,value|
			@strsql0 << value         
		end
		@strsql0 <<  " CONSTRAINT #{tblname}_id_pk PRIMARY KEY (id),"
		##  primkey key対応
		@strsql0 = @strsql0.chop + ")"
		###plsql.execute @strsql0
		ActiveRecord::Base.connection.execute @strsql0
	end
	def prv_modify_tbl_field tblname,allrecs,columns
		keys = []
		mandatory_field =  prv_init
		allrecs.each do |rec|
			frec = ActiveRecord::Base.connection.select_one("select * from r_fieldcodes where id = #{rec[:fieldcodes_id]}  and fieldcode_ftype not like 'vf%' ")  ### vfield は登録しない
			next if frec.nil?		  
			key = frec["pobject_code_fld"]
			keys << key
			if columns[key] then 
				if columns[key][:data_type].downcase == frec["fieldcode_ftype"]
					case frec["fieldcode_ftype"]
						when /char/
							if columns[key][:char_length] != frec["fieldcode_fieldlength"]
							### サイズが小さくなりデータがあるとエラー
								##varchar2 100 バイトを超えると data_length *4 になる？
								@strsql0 << "alter table #{tblname} modify #{frec["pobject_code_fld"]} #{frec["fieldcode_ftype"]}(#{frec["fieldcode_fieldlength"] });\n"
							end
						when "number"
							frec["fieldcode_dataprecision"] = 38 if  frec["fieldcode_dataprecision"] == 0 or frec["fieldcode_dataprecision"].nil?
							if (columns[key][:data_precision]||=38)  != (frec["fieldcode_dataprecision"]||=38) or  \
								(columns[key][:data_scale]||=0) != (frec["fieldcode_datascale"]||=0) 
								@strsql0 << "alter table #{tblname} modify #{frec["pobject_code_fld"]} #{frec["fieldcode_ftype"]}(#{frec["fieldcode_dataprecision"]},#{frec["fieldcode_datascale"]});\n"
							end
					end
				else 
					if columns[key][:data_type].downcase =~ /date|timestamp/ and frec["fieldcode_ftype"]  =~ /date|timestamp/ 
						@strsql0 << "alter table #{tblname} modify #{frec["pobject_code_fld"]} #{frec["fieldcode_ftype"]};\n" if columns[key][:data_type].downcase[0,4] != frec["fieldcode_ftype"][0,4]
                    else
						@strsql0 << "alter table #{tblname} drop (#{frec["pobject_code_fld"]});\n"
						prv_add_field tblname,frec
					end
				end ##if columns[key][:data_type].downcase == frec[:ftype
            else
                   prv_add_field tblname,frec
			end ###if columns[key]
		end  ##allrecs.each do |rec|
		columns.each do |k,j|
			unless keys.index(k) then
				unless mandatory_field.key?(k) then
                    @strsql0 << "alter table #{tblname} drop (#{k.to_s});\n"
				end
			end
		end 
		if  @strsql0.size > 1 then
			###同一日のbkは一回のみ
			bk_sql = "create table bk_#{tblname}_#{Time.now.strftime("%m%d")} as select * from #{tblname}"
			ActiveRecord::Base.connection.execute(bk_sql)  if (proc_chk_tble_exist(%Q&bk_#{tblname}_#{Time.now.strftime("%m%d")}&)).nil? 
		end
		proc_drop_index tblname   ###importffieldsfromoracle  でも同様処理有
		@strsql0.split(";").each do |i|
			fprnt "line #{__LINE__} \n plsql.execute #{i}"
			ActiveRecord::Base.connection.execute(i) if i =~ /\w/
		end
	end
	def proc_drop_index tblname
		### ＯＲＡＣＬＥの時	
		constr = plsql.blk_constraints.all("where table_name = '#{tblname.upcase}'  and  constraint_type = 'U' order by  constraint_name,position")
		orakeyarray = []
		constr.each do |rec|
           unless  orakeyarray.index(rec[:constraint_name]) then  orakeyarray << rec[:constraint_name]   end  
		end 
        prv_drop_constr tblname,orakeyarray if orakeyarray.size > 0
	end
  def prv_add_field tblname,frec
      case frec["fieldcode_ftype"] 
           when "varchar2","char"
                @strsql0 << "alter table #{tblname} add #{frec["pobject_code_fld"]} #{frec["fieldcode_ftype"]}(#{frec["fieldcode_fieldlength"] });\n"
           when "number"
                if  frec["fieldcode_dataprecision"] then 
                    @strsql0 << "alter table #{tblname} add #{frec["pobject_code_fld"]} #{frec["fieldcode_ftype"]}
                                                           (#{if frec["fieldcode_dataprecision"] == 0 then 38 else frec["fieldcode_dataprecision"] end },#{frec["fielcode_datascale"]||0});\n"
                  else
                    @strsql0 << "alter table #{tblname} add #{frec["pobject_code_fld"]} #{frec["fieldcode_ftype"]};\n"
                end
		   when "vf"
           else
               @strsql0 << "alter table #{tblname} add #{frec["pobject_code_fld"]} #{frec["fieldcode_ftype"]};\n"
       end
  end
## def crt_chil_screen viewname
##    p "addmain1"
##  対象となるテーブルは　idをフィールドに持つこと　　
### id create
## tablenameS_ID_xxx_xxxのレイアウトであること。
## viewの名前は R_xxxx になる
## 全テーブルに対応は中止した。
##    tblarea = {}  
##    notextview = {}
##    strsql = " where pobject_code_view =  '#{viewname}' and screenfield_Expiredate > sysdate "
##       fields = plsql.R_screenfields.all(strsql)
##       ## p "strsql : #{strsql}"
    ## p fields   
##    p "addmain2"
##    fields.each  do |tbldata|
##       if tbldata[:object_code_sfd]  =~ /_id/ then
##          pare_tbl_sym = (tbldata[:object_code_sfd].split(/_id/)[0] + "S").to_sym
##          tblarea[pare_tbl_sym] = viewname
##      end
##    end
    
##    y = plsql.r_screens.first("WHERE pobject_code_view = '#{viewname}' ")
##    tblarea.each_key  do |i|
##        x = plsql.screens.first("WHERE pobject_code_view = 'r_#{i.to_s}' ")
##        next if x.nil?
##        tmp_area = tblarea[i] 
##              next if x.nil?
##                 chil_r = plsql.ChilScreens.first("where screens_id = :1 and screens_id_chil = :2",x[:id],y[:id])
##                 ##  p  "where screens_id_Pare = :1 and screens_id = :2"
##                 if chil_r.nil? then
##                    val_chil = {
##                    :id => plsql.chilscreens_seq.nextval,
##                    :screens_id => x[:id],
##                    :screens_id_chil => y[:id],
##                    :expiredate => Time.parse("2099/12/31"),
##                    :remark => "auto_create", 
##                    :persons_id_upd => 0, 
##                    :update_ip =>  "1",
##                    :created_at => Time.now,
##                    :updated_at => Time.now
##                    }
##                  plsql.chilscreens.insert val_chil
##                  ## p "insert"
 ##                 end ## if
##    end    ## i
##    plsql.commit 
## end  #end crt_chil_screen 
 def create_or_replace_view  tblid,tblname   ### 
    subfields = plsql.r_blktbsfieldcodes.all("where blktbsfieldcode_blktb_id = #{tblid} and blktbsfieldcode_expiredate > sysdate")
	tmp_union_tbl = plsql.blktbs.first("where id  = #{tblid} ")
	union_tbls =  if tmp_union_tbl[:seltbls] and tmp_union_tbl[:seltbls] != "undefined" then eval(tmp_union_tbl[:seltbls])  else [""] end ##tblname対応
	### tmp_union_tbl[:seltbls]はarrayであること。　　checkが必要
	selectstr = ""
	fromstr = ""
	wherestr = ""
	union_tbls.each_with_index do |utbl,idx|
        selectstr <<  if idx == 0 then  " select " else "\n union \n select " end
        wherestr << if utbl == "" then "\n where "  else  "\n where #{tblname.chop}.tblid = #{utbl.to_s.split("_")[1].chop}.id  and 
		                                 #{tblname.chop}.tblname = '#{utbl.to_s}' and " end ##join条件
        fromstr << "\n from " + tblname + " " + tblname.chop + " ,"   ## 最後のSはとる。
		fromstr << if utbl == "" then "" else  utbl.to_s + " " + utbl.to_s.split("_")[1].chop + " ," end
        subfields.each do |rec|
           js = rec[:pobject_code_fld]
           if  js =~ /_id/  then
              case  js
                  when /persons_id_upd/ then  ##person は特殊
                        join_rtbl = "upd_persons" 
                   else
                       join_rtbl = "r_" + js.split(/_id/)[0]  ##JOINするテーブル名
              end 
              rtblname =  js.sub(/s_id/,"")
              fromstr << join_rtbl + "  " + rtblname + ','    ### from r_xxxxs xxxxx 
              wherestr << " #{rtblname}.id = "  ##相手側のテーブルのid
	          wherestr << tblname.chop + "." + js  + " and "   ## 自分のテーブル内の相手がわを示すid
			  delm = js.split("_")[-1]   ###idにdelm識別子を付けたとき
			  if delm == tblname.chop and js !~ /_id/
				new_js = js.sub("_#{tblname.chop}","")    ###ヘッダーと同じものは除く
				selectstr << tblname.chop + "." +  js + " " + tblname.chop + "_" +  new_js.sub("s_id","_id") + " ,"
			  else
				selectstr << tblname.chop + "." +  js + " " + tblname.chop + "_" +  js.sub("s_id","_id") + " ,"
			  end
              subtblcrt  join_rtbl,rtblname do |k|   ###相手側の項目セット
                      selectstr << k
              end
             else ##not _id
               @errmsg << "length over table:" + tblname + " field:" +  js + " length:" + (tblname.chop.length + js.length).to_s if  (tblname.chop.length + js.length) > 30
               selectstr << tblname.chop + "." +  js  + " id,"   if js == 'id' 
			   case rec[:blktbsfieldcode_viewflmk]
				    when nil			
			             selectstr << tblname.chop + "." +  js + " " + tblname.chop + "_" +  js + " ," 
				    when /^tblnamefields/  ##vfield対応　union
					     tblnamefields = eval(rec[:blktbsfieldcode_viewflmk])
						 selectstr << utbl.to_s.split("_")[1].chop + "." +  tblnamefields[utbl] + "  vf" + tblname.chop + "_" +  js + " ," 
               end 								   
			end      ##if  js =~ /_id/   
        end   ##subfields
		selectstr = selectstr.chop +  fromstr.chop + wherestr[0..-5]
		fromstr = ""
		wherestr = ""
	end
    sub_rtbl = "r_" + tblname   ##create view name  tbl:view=1:1  自動作成されるviewはr_xxxxで固定
    @strsql1 = "create or replace view  " + sub_rtbl + " as "   
    @strsql1 << selectstr.chop 
    plsql.execute  @strsql1   
	#### sql実行時のエラー表示　がまだできてない。
 end  #end create_or_replace_view  


	def  subtblcrt  join_rtbl ,rtblname   ## :view名,rtblname:省略形
        k = ""
	      if PLSQL::View.find(plsql, join_rtbl.to_sym).nil?
           @errmsg << "create view #{ join_rtbl }"
           raise 
           ### create_or_replace_view  tblid,tblname
	      end
		join_tblchop = join_rtbl.split("_")[1].chop
	    subfields = plsql.__send__(join_rtbl).column_names
        subfields.each do |j|
        js = xfield =  j.to_s  
			xfield = "" if js.upcase == "ID" 
			xfield = "" if js.upcase =~ /_UPD|UPDATED_AT|CREATED|UPDATE_IP|EXPIREDATE/ and  join_rtbl  !=  "upd_persons"
			##xfield = "" if join_rtbl != sub_rtbl  and  join_rtbl  =~ /upd_person/
			##if js.upcase =~ /_ID/
			##	tblchop = js.upcase.split("_")[1]
			##	if tblchop != join_tblchop
			##		xfield = ""
			##	end
			##end
            if   xfield  != "" then 
                xfield = rtblname + "." + xfield + " " + xfield + if rtblname.split(/_/,2)[1] and join_rtbl != "upd_persons"  then  "_" + rtblname.split(/_/,2)[1] else "" end 
                k <<  " " +  xfield   + "," 
                lngerrfield = xfield.split(" ")[1]
                ##p " 127 #{xfield}"
                if ( lngerrfield.length) > 30 then  @errmsg << "sub table: #{join_rtbl}   field: #{lngerrfield}  length: #{(lngerrfield.length).to_s}"  end
            end  
        end  ## subfields.each           
        yield k           
	end 
end

