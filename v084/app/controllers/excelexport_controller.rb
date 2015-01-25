class ExcelexportController < ScreenController
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
    end
    def export
	    #該当データなしの時処理　
	    get_screen_code 
        tblidsym = (@screen_code.split("_")[1].chop + "_id").to_sym
	    command_c = init_from_screen params
        fields = {}
        col_type =[]
        command_c[:sio_start_record] =  1
        command_c[:sio_end_record] =  params[:maxcount].to_i 
        command_c[:sio_session_id] = 1
        command_c[:sio_search] = if params[:_search] == "true" or params[:undefined_search] == "true" then "true" else "false" end
        command_c[:sio_classname] = "blk_export_"
        rcds = subpaging(command_c,@screen_code) 
        ##fields.delete(:msg_ok_ng)    ####近いうちに  照会・修正の時はとる。　　確認の時のみ
        pkg = Axlsx::Package.new
        pkg.workbook do |wb|
            wb.add_worksheet(:name => 'export') do |ws|   # シート名の指定は省略可
	        ### column毎に文字、数量、日付の指定をする。
	            fcolors = []
	            fcolors1 = []
                fields[tblidsym] = tblidsym.to_s
                fcolors << (wb.styles.add_style :bg_color =>  'ffc6b2')
                fcolors1 << (wb.styles.add_style :format_code => '#,##0')
	            @show_data[:gridcolumns].each do |i|
                    if  i[:hidden] == false         ### omit :msg_ok_ng
	                    fields[i[:field].to_sym] = if i[:label]  then i[:label] else "" end
		                if i[:editable] == true 
		                    if i[:editrules][:required]  == true 
                                fcolors << (wb.styles.add_style :bg_color =>  'ffc6b2')
		                    else
					            if @screen_code.split("_")[1].chop ==   i[:field].split("_")[0]
			                        fcolors << (wb.styles.add_style :bg_color =>  'e5ffe5')
								  else
                                    fcolors << nil								  
								end  
		                    end
                        else
                            fcolors << nil
                        end  ##if i[:editable] == true
		                case @show_data[:alltypes][i[:field].to_sym]
		                    when    /timestamp/
                                fcolors1 << (wb.styles.add_style :format_code => 'YYYY/MM/DD hh:mm:ss')
		                    when /date/
                                fcolors1 << (wb.styles.add_style :format_code => 'YYYY/MM/DD')
		                    when /number/
                                fcolors1 << (wb.styles.add_style :format_code => '#,##0')  ###小数点以下の対応ができてない。
			                else
			                    fcolors1 << (wb.styles.add_style :format_code => '@') 
	                    end
		            end ##if  i[:hidden] == false and i[:editrules]
                end  ##show_data[:gridcolumns].each
                ws.add_row  fields.values,:style =>fcolors
                rcds[0].each do  |i|  ###rcds[0] :全レコード　　rcds[1]:件数
		            rowvalue = []
		            fields.keys.each do |key|
		                rowvalue << if i[key] =~ /^@/ and key.to_s =~ /rubycode/ then "(" + i[key] + ")" else i[key] end #### if i.key?(key)
                    end
		            ws.add_row rowvalue,:style =>fcolors1
                end
            ##debugger
            end
        end
        send_data(pkg.to_stream.read,:type => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                 :filename => "#{@screen_code + Time.now.strftime("%y%m%d%H%M")}.xlsx")
        end  
    end
