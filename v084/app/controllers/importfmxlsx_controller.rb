class ImportfmxlsxController < ScreenController
  before_filter :authenticate_user!  
  ####  roo:char exlel数字だと 1.0になる。
  ####  rubyXL: 漢字が混在すると項目の位置がずれる。 2014/1 解決されている模様
  ###   public/rubyxl/  のrubyxlディレクトリーを作成済のこと。
  ###   入力がシートがフォーマット間違いの時、エラーで落ちる。　4/12
   ###   更新前のエラーチェックがまだ
   ##  excelのタイプチェック　がまだできてない。　例　excel 日付　db char
   ##insertの時idは無視される
    def index
     @screen_code,jqgrid_id = get_screen_code 
      #show_cache_key =  "show " + @screen_code +  sub_blkget_grpcode
      #@gridcolumns  = Rails.cache.read(show_cache_key)[:gridcolumns] 
      @tblname =  sub_blkgetpobj("r_"+@screen_code.split("_")[1],"view")
      #dupchk
    end
###By default, cell load errors (ex. if a date cell contains the string 'hello')
### result in a SimpleXlsxReader::CellLoadError.
###If you would like to provide better error feedback to your users, you can set 
###SimpleXlsxReader.configuration.catch_cell_load_errors = true, and load errors will instead be inserted into Sheet#load_errors keyed by [rownum, colnum].
    def import
      ##SimpleXlsxReader.configuration.catch_cell_load_errors = true
      @screen_code = params[:dump][:screen_code]
      if  params[:dump][:excel_file] then temp = params[:dump][:excel_file].tempfile else render :index and exit end
      file = File.join("public/rubyxl",params[:dump][:excel_file].original_filename)
      FileUtils.cp temp.path, file
      ##debugger
      ws = RubyXL::Parser.parse file
      FileUtils.rm file
      command_c = {}
      command_c[:sio_viewname]  = plsql.r_screens.first("where pobject_code_scr = '#{@screen_code}' and SCREEN_EXPIREDATE >sysdate")[:pobject_code_view]
      command_c[:sio_code] = @screen_code
      command_c[:sio_user_code] = plsql.persons.first(:email =>current_user[:email])[:id]  ||= 0 
      tblidsym = (@screen_code.split("_")[1].chop+"_id").to_sym
      for iws in 0..9
           break if ws[iws].nil?
           command_c[:sio_session_counter]  = user_seq_nextval(command_c[:sio_user_code] )   ###シート毎にCOMMIT
           ##maxj = sh.UsedRange.CoLumns.Count
           ##maxi = sh.UsedRange.Rows.Count
           dupchk  ws[iws].sheet_name
           render :index and exit unless @errmsg == ""
           for count in 0..99999
	            if  count == 0
	                 ##debugger
	                 nchk ws[iws][count] if count == 0
	                  ##debugger
                    break  unless  @errmsg == ""
                  else
                    ##debugger
                    break  if  ws[iws][count].nil?
                    break  if  ws[iws][count][0].nil?  ###RubyXL仕様？ nilが安定しない。
                    @inxrow0.each do |key,cnt|
                        command_c[key] = ws[iws][count][cnt].value  if  ws[iws][count][cnt]
	                  end  ##column
                    case ws[iws].sheet_name.upcase
	                  when "INSERT" then
                            command_c[:id] = plsql.__send__(command_c[:sio_viewname].split("_")[1] + "_seq").nextval 
                            command_c[(command_c[:sio_viewname].split("_")[1].chop + "_id").to_sym] =  command_c[:id]
                            command_c[:sio_classname] = "plsql_blk_insert_"
                    when "UPDATE" then
                            command_c[:sio_classname] = "plsql_blk_update_"
                            command_c[:id] = command_c[tblidsym]
	                  when "DELETE" then
                           command_c[:sio_classname] = "plsql_blk_delete_"
                           command_c[:id] = command_c[tblidsym]
        	          when nil then
                         break
                    else
		                    	@errmsg = "sheet name err must be insert or update"
			                    break
	                  end  ##case
                 ###   更新前のエラーチェックがまだ
	         ##debugger
	         ##	 char_to_number_data  ####type 変換
                 @hkeys.each do |inx,field|
                    viewname,delm = inx.to_s.split(":")
                    keys = {}
                    field.each do |f|  
                      keys[f] = command_c[f.to_sym]
                    end 
                    rec = get_item_from_code keys,viewname,delm
                    ##debugger
                    idsym = (@screen_code.split("_")[1].chop+ "_"+ viewname.split("_")[1].chop+"_id" + if delm then "_" + delm else "" end).to_sym
                    command_c[idsym] = rec[:id] if rec
                 end
                 sub_insert_sio_c(command_c)
	      end  ## if count
        end ## row
           if  @errmsg == ""
              sub_userproc_insert command_c
              plsql.commit
              dbcud = DbCud.new
              dbcud.perform(command_c[:sio_session_counter],command_c[:sio_user_code])
           end
      end  ##end sheet
      ##debugger
      render :index
    end
    def dupchk  sheet_name
      @fields = {}
      @rfields = {}
      @errmsg = ""
      @nfields = []   ## 更新項目
      @indispfs = []   ## 項須項目
      @keyfs = []   ## key項須項目
      show_cache_key =  "show " + @screen_code +  sub_blkget_grpcode
      show_data = get_show_data(@screen_code)
      tblidsym = (@screen_code.split("_")[1].chop+"_id").to_sym
      ##debugger
      show_data[:gridcolumns].each do |i|
	   @fields[i[:label].to_sym] = i[:field] if i[:hidden] == false  and  i[:label]
	   @rfields[i[:field].to_sym] = i[:label] if i[:hidden] == false and  i[:label]
	   if  i[:editable] == true   ###更新可能項目
	       @nfields << i[:field].to_sym 
               @indispfs <<  i[:field].to_sym  if i[:editrules][:required]  == true
           end
      end
      if  sheet_name.downcase == "update" or  sheet_name.downcase == "delete" then
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
      ##debugger
       @hkeys = {}
       @row0.each do |field|
          akeys,viewname,delm =  get_ary_search_field @screen_code,field
          delm ||= ""
          @hkeys[(viewname+":"+delm).to_sym] = akeys if viewname
       end
    end
end
