class ImportfmxlsxController < ApplicationController
  before_filter :authenticate_user!  
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
     spt = RubyXL::Parser.parse file
     ##debugger
      FileUtils.rm file
      spt.each do |sh|
      s_cnt = nil               ####session_counter
         sh.each_with_index do |rowdata,count|
	   if count == 0
	      nchk rowdata,sh.sheet_name if count == 0
	       ##debugger
               break  unless  @errmsg == ""
             else
	      @command_r = {}
              command_r
	      rowdata.each_with_index do |cell,cellcnt|
                 command_r[ @row0[cellcnt]] = cell.value  if @row0[cellcnt] and cell
	      end  ##column
	      command_r[:sio_session_counter]  = s_cnt
	      ##	 char_to_number_data  ####type 変換
        	case sh.sheet_name.upcase
	            when "INSERT"
                          sub_insert_sio_c  do    ###更新要求
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
       @nfields = []   ## 必須(更新)項目
       @show_data = get_show_data(screen_code)
       show_data
       show_data[:gridcolumns].each do |i|
	 if @fields.key?(i[:label].to_sym) then  ###既にkeyが存在する。
	    errfield << i[:label]
	 else 
	    @fields[i[:label].to_sym] = i[:field] if i[:hidden] == false
	    @rfields[i[:field].to_sym] = i[:label] if i[:hidden] == false
	 end
	 @nfields << i[:field].to_sym  if i[:editable] == true   ###更新可能項目
       end
     @errmsg = "#{errfield.join(',').encode('utf-8')}" unless errfield == []
  end
  def nchk spt,s
       errfield  = []
       @row0 = []
       spt.each do |cell|   ##一行目は項目
           @row0 <<  @fields[cell.value.to_sym].to_sym if cell
      end
      @nfields.each do |i|
	  errfield << i.to_s  + ":" + @rfields[i] unless @row0.index(i)
      end
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
