class ImportfmxlsxController < ApplicationController
  before_filter :authenticate_user!  
  ####  roo:char exlel数字だと 1.0になる。
  ####  rubyXL: 漢字が混在すると項目の位置がずれる。
  def index
      @tblname =  sub_blkgetpobj( params[:q] ,"A",sub_blkget_grpcode)
      @screen_code = params[:q] 
      screen_code
      dupchk
  end
 def import
     @screen_code = params[:dump][:screen_code]
     screen_code
     dupchk 
     ##debugger
     render :index and exit unless @errmsg == ""
     temp = params[:dump][:excel_file].tempfile
     file = File.join("public",params[:dump][:excel_file].original_filename)
     FileUtils.cp temp.path, file
    ##debugger
     spt = SimpleXlsxReader.open file
     ##debugger
      FileUtils.rm file
      spt.sheets.each do |sh|
      s_cnt = nil               ####session_counter
         sh.rows.each_with_index do |rowdata,count|
	   if count == 0
	      ##debugger
	      nchk rowdata,sh.name if count == 0
	       ##debugger
               break  unless  @errmsg == ""
             else
	      @command_r = {}
              command_r
	      rowdata.each_with_index do |cell,cellcnt|
                 command_r[ @row0[cellcnt]] = cell  if @row0[cellcnt] and cell
	      end  ##column
	      ##debugger
	      command_r[:sio_session_counter]  = s_cnt
	      ##	 char_to_number_data  ####type 変換
        	case sh.name.upcase
	            when "INSERT"
                          sub_insert_sio_c  do    ###更新要???
                              command_r[:sio_classname] = "plsql_blk_insert"
                         end
         	   when "UPDATE"
			 sub_insert_sio_c    do
                            command_r[:sio_classname] = "plsql_blk_update"
			    command_r[:id] = get_id_from_code if command_r[:id].nil?
                         end
	           when "DELETE"
			 sub_insert_sio_c  do
                              command_r[:sio_classname] = "plsql_blk_delete"
			    command_r[:id] = get_id_from_code if command_r[:id].nil?
                         end
        	   else
			@errmsg = "sheet name err must be insert or update"
			break
	       end  ##case
	       s_cnt = command_r[:sio_session_counter]  
	    end  ## if count
         end ## row
      end  ##end sheet
     ##debugger
    if @errmsg == ""
       plsql.commit
       dbcud = DbCud.new
       dbcud.perform(command_r[:sio_session_counter],"SIO_#{command_r[:sio_viewname]}")
     end
    render :index
 end
  def dupchk
       @fields = {}
       @rfields = {}
       errfield  = []
       @errmsg = ""
       @nfields = []   ## 更新???目
       @indispfs = []   ## ???須???目
       @keyfs = []   ## key???須???目
       @show_data = get_show_data(screen_code)
       show_data
       show_data[:gridcolumns].each do |i|
	 if @fields.key?(i[:label].to_sym) then  ###既に???目が存在する???
	    errfield << i[:label]
	 else 
	    @fields[i[:label].to_sym] = i[:field] if i[:hidden] == false
	    @rfields[i[:field].to_sym] = i[:label] if i[:hidden] == false
	 end
	 if i[:editable] == true   ###更新可能???目
	     @nfields << i[:field].to_sym 
             @indispfs <<  i[:field].to_sym  if i[:editrules][:required]  == true
	     @keyfs <<  i[:field].to_sym  if show_data[:keysfield].index(i[:field])
          end
       end
     @errmsg = "#{errfield.join(',').encode('utf-8')}" unless errfield == []
  end
  def nchk spt,sheet_name
      errfield  = []
      @row0 = []
      spt.each do |cell|   ##一行目は???目
	   ##p cell
	   ##debugger
           @row0 <<  @fields[cell.encode("utf-8").to_sym].to_sym if cell and @fields[cell.encode("utf-8").to_sym]
      end
      if   sheet_name.upcase == "INSERT"
           @indispfs.each do |i|
	     ##errfield << "???須???目な???".encode("utf-8")  + i  + ":" + @rfields[i].encode("utf-8") if @row0.index(i).nil? 
	     errfield << " #{i.to_s}  :  #{@rfields[i.to_sym]}" if @row0.index(i).nil? 
           end
       end
       if   sheet_name.upcase == "UPDATE"
           @keyfs.each do |i|
	     ###errfield << "key???目な???" + i  + ":" + @rfields[i] if @row0.index(i).nil? 
	     errfield <<  i.to_s  + ":" + @rfields[i] if @row0.index(i).nil? 
           end
	   ###errfield << "更新???目な???"  if @row0.size <2
	   errfield << "no field for update "  if @row0.size <2
       end  
      @errmsg
      @errmsg = "#{errfield.join(',')}" unless errfield == []
  end
  def get_id_from_code
      ##debugger
      tbln_code_sym = (command_r[:sio_viewname].split("_")[1].chop.downcase + "_code").to_sym
      tbln_id_sym = (command_r[:sio_viewname].split("_")[1].downcase + "_id").to_sym
      ##debugger
      sub_code_to_id({tbln_code_sym=>command_r[tbln_code_sym]})[tbln_id_sym] if command_r[tbln_code_sym]
  end
  def screen_code
      @screen_code
  end
  def show_data
      @show_data
  end
  def command_r
      @command_r
  end
end
