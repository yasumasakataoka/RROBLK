class ExcelexportController < ApplicationController
  before_filter :authenticate_user!  
  ###   date_format = wb.styles.add_style :format_code => 'YYYY-MM-DD'
  ##   time_format = wb.styles.add_style :format_code => 'hh:mm:ss'
  ##   sheet.add_row ["Date", "Time", "String", "Boolean", "Float", "Integer"]
  ##  sheet.add_row [Date.today, Time.now, "value", true, 0.1, 1], :style => [date_format, time_format]
  ## sheet.add_row ['dont eat my zeros!', '0088'] , :types => [nil, :string]
  #   padded = s.add_style(:format_code => "00#", :border => Axlsx::STYLE_THIN_BORDER)
  #   sheet.add_row [Date::strptime('2012-01-19','%Y-%m-%d'), 0.2, 32], :style => [date, percent, padded]
  #   comma = wb.styles.add_style :num_fmt => 3
  #   sheet.add_row [1500, -122.34, 123456789, 594829], :style=> [currency, red_negative, comma, super_funk]
    def index
      screen_code,jqgrid_id = get_screen_code 
      show_cache_key =  "show " + screen_code +  sub_blkget_grpcode
      ##debugger
	  if Rails.cache.exist?(show_cache_key) then
         @show_data = Rails.cache.read(show_cache_key)
       else 
	       ### create_def screen_code
	     @show_data = set_detail(screen_code )  ## set gridcolumns
      end
      @gridcolumns  = @show_data[:gridcolumns] 
      @viewname =  sub_blkgetpobj("r_#{screen_code.split("_")[1]}","view")
    end
    def export
      ##@fields =   plsql.__send__(params[:id]).column_names  ##show_dataのfieldに変更
	  #該当データなしの時処理　
      screen_code = params[:export][:exportscreen_code]
      tblidsym = (screen_code.split("_")[1].chop + "_id").to_sym
      ##show_cache_key =  "show " + screen_code +  sub_blkget_grpcode
      ##if Rails.cache.exist?(show_cache_key) then
      ##   @show_data = Rails.cache.read(show_cache_key)
      ## else 
	       ### create_def screen_code
	  ##   @show_data = set_detail(screen_code )  ## set gridcolumns
      ##end
	  @show_data = get_show_data screen_code
      command_c = set_fields_from_params screen_code
       ##debugger
      fields = {}
      col_type =[]
      command_c[:sio_code] = screen_code
      command_c[:sio_start_record] =  1
      command_c[:sio_end_record] =  params[:export][:maxcount].to_i 
      command_c[:sio_session_id] = "export"
      command_c[:sio_classname] = "plsql_blk_export"
      ##@tbldata = []
      ##debugger
      rcd = subpaging(command_c,screen_code) 
      fields.delete(:msg_ok_ng)    ####近いうちに  照会・修正の時はとる。　　確認の時のみ
      ## @tbldata =   plsql.__send__(params[:export][:screen_code]).all
      pkg = Axlsx::Package.new
      pkg.workbook do |wb|
      wb.add_worksheet(:name => 'export') do |ws|   # シート名の指定は省略可
	      ### column毎に文字、数量、日付の指定をする。
	   fcolors = []
	   fcolors1 = []
           fields[tblidsym] = tblidsym.to_s
            fcolors << (wb.styles.add_style :bg_color =>  'ffc6b2')
	   @show_data[:gridcolumns].each do |i|
         if  i[:hidden] == false and i[:editrules]           ### omit :msg_ok_ng
	           fields[i[:field].to_sym] = if i[:label]  then i[:label] else "" end
		   if i[:editable] == true then
		      if i[:editrules][:required]  == true then
                     fcolors << (wb.styles.add_style :bg_color =>  'ffc6b2')
		       else
			         fcolors << (wb.styles.add_style :bg_color =>  'e5ffe5')
		      end
             else
                fcolors << nil
           end  ##if i[:editable] == true
		   case @show_data[:alltypes][i[:field].to_sym]
		       when    /^timestamp/
                            fcolors1 << (wb.styles.add_style :format_code => 'YYYY/MM/DD hh:mm:ss')
		       when "date"
                             fcolors1 << (wb.styles.add_style :format_code => 'YYYY/MM/DD')
		       when "number"
                            fcolors1 << (wb.styles.add_style :format_code => '#,##0')  ###小数点以下の対応ができてない。
			   else
			    fcolors1 << nil
	       end
		 end ##if  i[:hidden] == false and i[:editrules]
       end  ##show_data[:gridcolumns].each
         ws.add_row  fields.values,:style =>fcolors
	 ##debugger
         rcd[0].each do  |i|
		 rowvalue = []
		 fields.keys.each do |key|
		    rowvalue << i[key.to_sym] if i.key?(key.to_sym)
         end
		  ws.add_row rowvalue,:style =>fcolors1
         end
         ##debugger
      end
     end
  send_data(pkg.to_stream.read, 
  :type => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
  :filename => "#{screen_code + Time.now.strftime("%y%m%d%H%M")}.xlsx")
 end
 def set_fields_from_params screen_code  ###画面の内容をcommand_c
     command_c = {}
     if @show_data.nil? 
        render :text => "Create DetailFields #{screen_code} by (crt_r_view_sql.rb  #{screen_code.split(/_/)[1]}) and restart rails "  and return
     end
     command_c[:sio_search]  = "false"
     ##debugger
     @show_data[:allfields].each do |j|
        command_c[j] = params[:export][j]  ##     
	    command_c[:sio_search]  = "true" if command_c[j] and command_c[j] != ""
     end ##
	 return command_c
 end  
end
