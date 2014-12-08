class ImportfmxlsxController < ScreenController
  before_filter :authenticate_user!  
  ####  roo:char exlel数字だと 1.0になる。
  ####  rubyXL: 漢字が混在すると項目の位置がずれる。 2014/1 解決されている模様
  ###   public/rubyxl/  のrubyxlディレクトリーを作成済のこと。
  ###   入力がシートがフォーマット間違いの時、エラーで落ちる。　4/12
   ##  excelのタイプチェック　がまだできてない。　例　excel 日付　db char
   ##insertの時idは無視される
   ### 事前チックokかどうかexcelで返す
    def index
	   get_screen_code  ## set @screen_code,@jqgrid_id  
	  init_from_screen params
      @tblname =  sub_blkgetpobj("r_"+@screen_code.split("_")[1],"view")
      #dupchk
    end
###By default, cell load errors (ex. if a date cell contains the string 'hello')
### result in a SimpleXlsxReader::CellLoadError.
###If you would like to provide better error feedback to your users, you can set 
###SimpleXlsxReader.configuration.catch_cell_load_errors = true, and load errors will instead be inserted into Sheet#load_errors keyed by [rownum, colnum].
    def import
	  @rendererrmsg = []
	  @pare_class = "online"
	  get_screen_code
	  command_c = init_from_screen params
      ##SimpleXlsxReader.configuration.catch_cell_load_errors = true
      if params[:dump] then @screen_code = params[:dump][:screen_code] else render :index and return end
      if  params[:dump][:excel_file] then temp = params[:dump][:excel_file].tempfile else render :index and return end
      file = File.join("public/rubyxl",params[:dump][:excel_file].original_filename)
      FileUtils.cp temp.path, file
      ##debugger
      ws = RubyXL::Parser.parse file
      FileUtils.rm file 
      tblidsym = (@screen_code.split("_")[1].chop+"_id").to_sym
      for iws in 0..99
           break if ws[iws].nil?
           command_c[:sio_session_counter]  = user_seq_nextval(command_c[:sio_user_code] )   ###シート毎にCOMMIT
           ##maxj = sh.UsedRange.CoLumns.Count
           ##maxi = sh.UsedRange.Rows.Count
           dupchk  ws[iws].sheet_name
		   commit_flg = true
		   keys = set_keys_get_id_from_code(command_c)
           for count in 0..999999
		        @errmsg == ""
	            if  count == 0
	                 ##debugger
	                 nchk ws[iws][count] if count == 0  ###先頭は項目名
	                  ##debugger
                    break  unless  @errmsg == ""
                  else
                    ##debugger
                    break  if  ws[iws][count].nil?
                    break  if  ws[iws][count][0].nil?  ###RubyXL仕様？ nilが安定しない。
                    @inxrow0.each do |key,cnt|
                        if  ws[iws][count][cnt] then command_c[key] = ws[iws][count][cnt].value  else command_c[key] = nil end
	                end  ##column
					##debugger
					command_c = get_id_from_code keys,command_c
					command_c[:sio_recordcount] = command_c[:sio_session_id] = count
                    case ws[iws].sheet_name.upcase
	                    when /^ADD/ then
							updatechk_add command_c  ###同一レコード内での重複チェックができてない。
			                updatechk_foreignkey command_c  if  @errmsg == ""
                            if  @errmsg == "" then
                                command_c[:sio_classname] = "plsql_blk_add_"
                                command_c[:id] = plsql.__send__(command_c[:sio_viewname].split("_")[1] + "_seq").nextval 
                                command_c[(command_c[:sio_viewname].split("_")[1].chop + "_id").to_sym] =  command_c[:id]
                            end 
                        when  /^EDIT/ then
                            command_c[:sio_classname] = "plsql_blk_edit_"
                            command_c[:id] = command_c[tblidsym]
							##debugger
					        updatechk_edit command_c
			                updatechk_foreignkey command_c if  @errmsg == ""
	                    when /^DELETE/ then
                           command_c[:sio_classname] = "plsql_blk_delete_"
                           command_c[:id] = command_c[tblidsym]
						   updatechk_del command_c
        	            when nil then
                           break
                        else
		                   @rendererrmsg  << [ws[iws].sheet_name,"sheet name err must be add or edit or delete"]
			                break
	                 end  ##case
					 if @errmsg == "" and commit_flg
                        sub_insert_sio_c(command_c)
					   else
					     commit_flg = false
						 @rendererrmsg << [(count + 1).to_s,@errmsg]  if @errmsg != ""
						 @errmsg = ""
                     end
	             end  ## if count
           end ## row
           if  commit_flg
              sub_userproc_insert command_c
              plsql.commit
              dbcud = DbCud.new
              dbcud.perform(command_c[:sio_session_counter],command_c[:sio_user_code],"")
			  else
			   plsql.rollback
           end
      end  ##end sheet
      if  @rendererrmsg == []	then   @rendererrmsg  = nil end
      render :index
    end
    def dupchk  sheet_name
      @fields = {}
      @rfields = {}
      @errmsg = ""
      @nfields = []   ## 更新項目
      @indispfs = []   ## 項須項目
      @keyfs = []   ## key項須項目
      ##debugger
      show_cache_key =  "show " + @screen_code +  sub_blkget_grpcode
      show_data = get_show_data @screen_code
      tblidsym = (@screen_code.split("_")[1].chop+"_id").to_sym
      show_data[:gridcolumns].each do |i|
	   @fields[i[:label].to_sym] = i[:field] if i[:hidden] == false  and  i[:label]
	   @rfields[i[:field].to_sym] = i[:label] if i[:hidden] == false and  i[:label]
	   if  i[:editable] == true   ###更新可能項目
	       @nfields << i[:field].to_sym 
               @indispfs <<  i[:field].to_sym  if i[:editrules][:required]  == true
           end
      end
      if  sheet_name.downcase == "edit" or  sheet_name.downcase == "delete" then
           @fields[tblidsym] = @rfields[tblidsym] = tblidsym.to_s
           @nfields << tblidsym
           @indispfs << tblidsym
      end
    end
    def nchk spt
      errfield  = []
      @row0 = []
      @inxrow0 = {}
      for cellcnt in 0..(@fields.size-1)   ##一行目は項目
	   ##p cell
	   ##debugger
           if  spt[cellcnt] and @fields[spt[cellcnt].value.encode("utf-8").to_sym] then
              row0sym =  @fields[spt[cellcnt].value.encode("utf-8").to_sym].to_sym
              @row0 << row0sym
              @inxrow0[row0sym] = cellcnt 
           end
      end
      @indispfs.each do |i|
	   ##errfield << "項須項目な項".encode("utf-8")  + i  + ":" + @rfields[i].encode("utf-8") if @row0.index(i).nil? 
	   errfield << " #{i.to_s}  :  #{@rfields[i.to_sym]}" if @row0.index(i).nil? 
      end
      @errmsg = "#{errfield.join(',')}" unless errfield == []

    end
	def set_keys_get_id_from_code command_c
	      strsql = "select screenfield_paragraph,pobject_code_sfd from r_screenfields where pobject_code_scr = '#{@screen_code}' and screenfield_expiredate > current_date and "
		  strsql << "screenfield_paragraph is not null group by screenfield_paragraph,pobject_code_sfd"
	      tmpkeys = plsql.select(:all,strsql)
		  keys = {}
		  tmpkeys.each do |rec|
		    keys[rec[:screenfield_paragraph]] = [] if keys[rec[:screenfield_paragraph]].nil?
			keys[rec[:screenfield_paragraph]] << rec[:pobject_code_sfd] 
		  end
		  return keys
	end
	def get_id_from_code keys,command_c
	    keys.each do |key,vals|
		    strwhere = " where "
			tblnamechop,delm = key.split(":")
			tblnamechop = tblnamechop.split("_")[1].chop
			delm ||= ""
			vals.each do |val|
			    strwhere << " #{val.sub(delm,"")} = '#{command_c[val.to_sym]}' and "
			end
			##debugger
			strwhere << %Q% #{tblnamechop + "_expiredate" } > current_date %
			get_id = plsql.__send__(key.to_s.split(":_")[0]).first(strwhere)
			sym_key = (command_c[:sio_viewname].split("_")[1].chop+"_" + tblnamechop + "_id" + if key.to_s.split(":_")[1] then "_"+key.to_s.split(":_")[1] else "" end).to_sym
			if get_id then command_c[sym_key] = get_id[:id] else command_c[sym_key] = -1 end
		end
		return command_c
	end
end