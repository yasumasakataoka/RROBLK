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
      @screen_code,jqgrid_id = get_screen_code 
      show_cache_key =  "show " + @screen_code +  sub_blkget_grpcode
      ##debugger
      @gridcolumns  = Rails.cache.read(show_cache_key)[:gridcolumns] 
      @tblname =  sub_blkgetpobj( plsql.r_screens.first("where pobject_code_scr = '#{@screen_code}' and pobject_objecttype_view = 'view' and screen_expiredate > sysdate order by  screen_expiredate")[:pobject_code_view] ,"view")
  end
  def export
     ##@fields =   plsql.__send__(params[:id]).column_names  ##show_dataのfieldに変更
	  #該当データなしの時処理　
     @screen_code = params[:export][:exportscreen_code]
     screen_code 
     show_cache_key =  "show " + screen_code +  sub_blkget_grpcode
     @show_data =  Rails.cache.read(show_cache_key)
     show_data
     @xparams = {}
     params[:export].each do |i,j|   ###jqgridと入力無の時の送られるデータがことなる。 jqgrid field nothing  rails fieldx= ""
	@xparams[i.to_sym] = j if j != ""
     end
     xparams
     set_fields_from_params 
     ##debugger
    fields = {}
    col_type =[]
    command_r[:sio_code] = screen_code
    command_r[:sio_start_record] =  1
    command_r[:sio_end_record] =  params[:export][:maxcount].to_i 
    command_r[:sio_session_id] = "export"
    command_r[:sio_classname] = "plsql_blk_export"
    ##@tbldata = []
    ##debugger
    rcd = subpaging(command_r) 
     fields.delete(:msg_ok_ng)    ####近いうちに  照会・修正の時はとる。　　確認の時のみ
     ## @tbldata =   plsql.__send__(params[:export][:screen_code]).all
     pkg = Axlsx::Package.new
     pkg.workbook do |wb|
      wb.add_worksheet(:name => 'export') do |ws|   # シート名の指定は省略可
	      ### column毎に文字、数量、日付の指定をする。
	   fcolors = []
	   fcolors1 = []
	   show_data[:gridcolumns].each do |i|
               if  i[:hidden] == false and i[:editrules]              ### omit :msg_ok_ng
	           fields[i[:field].to_sym] = i[:label] 
		   if i[:editable] == true then
		      if i[:editrules][:required]  == true then
                          fcolors << (wb.styles.add_style :bg_color =>  'ffc6b2')
		       else
			  fcolors << (wb.styles.add_style :bg_color =>  'e5ffe5')
		      end
                    else
                          fcolors << nil
                   end  ##if i[:editable] == true
		   case show_data[:alltypes][i[:field].to_sym]
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
  :filename => "#{@screen_code + Time.now.strftime("%y%m%d%H%M")}.xlsx")
 end
 def set_fields_from_params ###画面の内容をcommand_r
     @command_r = {}
     command_r
     if show_data.empty? 
        render :text => "Create DetailFields #{screen_code} by (crt_r_view_sql.rb  #{screen_code.split(/_/)[1]}) and restart rails "  and return
     end
     command_r[:sio_search]  = "false"
     ##debugger
     show_data[:allfields].each do |j|
        command_r[j] = xparams[j]  ##     
	command_r[:sio_search]  = "true" if command_r[j]
	##debugger
     end ##
 end  
 def command_r
     @command_r
 end
 def show_data
     @show_data
 end
 def screen_code
     @screen_code
 end
 def xparams
     @xparams
 end

end
