﻿class CrtpdfscriptController < ScreenController
  before_filter :authenticate_user!  
### excelのセルのサイズが0.25単位なので微妙にpdfとずれる?
    def index
    end
### prawn barcode
### https://github.com/jabbrwcky/prawn-qrcode
### require 'barby'
### require 'barby/barcode/code_39'
### require 'barby/outputter/prawn_outputter'
### def barcode
###   pdf.bounding_box [450,700], :width => 100 do
###       barcode = Barby::Code39.new(@order.order_identifier)
###       barcode.annotate_pdf(pdf, :height => 30)
###   end
### outputter = Barby::PrawnOutputter.new(barcode)
### doc       = outputter.to_pdf(options)  #Creates a new `Prawn::Document` and annotates it
### Options:
### All values in PDF points.
### x: The starting X position (left) where the barcode will be drawn. (default: same as margin)
### y: The starting Y position (bottom) of the barcode to be drawn. (default: same as margin)
### xdim: (default: 1)
### ydim: (default: same as xdim)
### height: (default: 50)
### margin: (default: 0)
### document: (to_pdf only) Passed to Prawn::Document.new.
    def create_pdf_script
	    begin
		@text_data  = ""
	    if  params[:dump][:excel_file] then temp = params[:dump][:excel_file].tempfile else render :index and return end
        file = File.join("public/rubyxl",params[:dump][:excel_file].original_filename)
        FileUtils.cp temp.path, file
            ##debugger        app = WIN32OLE.new('Excel.Application')
		WIN32OLE.ole_initialize
        app = WIN32OLE.new('Excel.Application')
        WIN32OLE.const_load(app, ExcelConst)
        @books = app.Workbooks.Open(File.expand_path(file, ENV['RAILS_ROOT']))
        savestyle = ExcelConst::XlLineStyleNone
        saveweight = ExcelConst::XlThin  ##太さ
        savecolor = 0
		init_starrt
        @books.Worksheets.each do |sheet|
		    @report_code = sheet.name.downcase
			report = plsql.select(:first,"select * from r_reports where pobject_code_rep = '#{@report_code}' and report_expiredate > sysdate") 
			if report.nil?
                @books.Close
                logger.debug	 "line #{__LINE__} error : missing report_code #{@report_code}"
				@text_data << "<p>line #{__LINE__} error : missing report_code #{@report_code}</p>"
                render :text =>  @text_data and return
			end
			@viewname = report[:pobject_code_view]
            if PLSQL::View.find(plsql, @viewname).nil?
                @books.Close
				@text_data << "<p>line #{__LINE__} error : missing view #{@viewname}</p>"
                render :text =>  @text_data and return
            end
			@screencode = report[:pobject_code_scr]
			if sheet.cells(1,1).value.nil?
                @books.Close
                logger.debug	 "line #{__LINE__} error : cell(1,1) : must set some value   sheet_name:#{sheet.name}"
                @text_data << "<p>line #{__LINE__} error : cell(1,1) : must set some value   sheet_name:#{sheet.name}</p>" and return
                render :text =>  @text_data and return
			end
			@margin = []
            @margin << sprintf("%.3f",sheet.PageSetup.TopMargin * 0.394 /2).to_f
            @margin << sprintf("%.3f",sheet.PageSetup.RightMargin * 0.394/2).to_f
            @margin <<  sprintf("%.3f",sheet.PageSetup.BottomMargin * 0.394/2).to_f
            @margin <<  sprintf("%.3f",sheet.PageSetup.LeftMargin * 0.394/2).to_f
            @paper[:orientation] = sheet.PageSetup.Orientation  ##縦1 横 2
            @paper[:size] = sheet.PageSetup.PaperSize.to_i ## A3:8, A4:9, A5:11
            rowpos = 0.0  ##縦位置
            saverowpos = 0.0  #線種の始まり
            savecolumnpos = 0.0
            savecellrow = 0
            savecellcolumn = 0 
            rectsavecolor = 0
            rectsaverowpos = 0
            rectsavecolumnpos = 0
            rectwidthvalue  = 0
            rectheight = 0 
            rectsavecellrow = 0
            rectsavecellcolumn = 0
			rno_row = {}
			rno_column = {}
            ####  横線種　box　項目作成
            sheet.UsedRange.Rows.each do |row|
                widthvalue = 0.0  ##横線長さ
                columnpos = 0.0   ##横位置
                rowpos += row.Height
                ###背景色処理
                rectrowpos = 0.0  ##縦位置
                rectcolumnpos = 0.0  ##縦位置
                @fill_rectangle_color << [rectsavecellrow,rectsavecellcolumn,rectsaverowpos,rectsavecolumnpos,rectwidthvalue,rectheight,rectsavecolor] if  rectsavecolor != 0
                rectsavecellrow = 0
                rectsavecellcolumn = 0
                rectsavecolor = 0
                rectsaverowpos = 0
                rectsavecolumnpos = 0
                rectwidthvalue  = 0
                rectheight = 0
                @wline << [savecellrow,savecellcolumn,saverowpos,savecolumnpos,widthvalue,savestyle,saveweight,savecolor] if  savestyle !=  ExcelConst::XlLineStyleNone    or saveweight != ExcelConst::XlThin  or savecolor != 0
                savestyle =   ExcelConst::XlLineStyleNone
                saveweight = ExcelConst::XlThin  ##太さ
                savecolor = 0
                row.Columns.each do |cell|
				    if cell.column == 1 
					    if cell.value.to_s =~ /\d/  then rno_row[cell.row] = cell.value.to_i else rno_row[cell.row]  = 0 end
					end	
				    if cell.row == 1 
					    if cell.value.to_s =~ /\d/  then rno_column[cell.column] = cell.value.to_i else rno_column[cell.column]  = 0 end
					end	
                    if cell.MergeCells
                        if  cell.MergeArea.Item(1,1).row == cell.row and  cell.MergeArea.Item(1,1).column == cell.column and cell.column != 1 and cell.row != 1 
	                        @box_fields << [rno_row[cell.row]+rno_column[cell.column],
							                [cell.row,cell.column,rowpos - row.Height,columnpos,cell.MergeArea.Font.size,cell.MergeArea.Item(1,1).Value.to_s,
    										cell.MergeArea.Width,cell.MergeArea.Height,cell.MergeArea.Font.color,cell.MergeArea.HorizontalAlignment,
											cell.MergeArea.VerticalAlignment]] if cell.MergeArea.Item(1,1).Value
	                    end
                    else
	                    if  cell.Value and cell.column != 1 and cell.row != 1 
	                        @fields<<  [rno_row[cell.row]+rno_column[cell.column],
            							[cell.row,cell.column,rowpos,columnpos,cell.Font.size,cell.value.to_s,cell.Font.color]]   ##if  cell.Value.class != String
	                    end
	                end  ##cell.MergeCells	
	                if savestyle != cell.Borders(ExcelConst::XlEdgeBottom).LineStyle or saveweight !=  cell.Borders(ExcelConst::XlEdgeBottom).Weight  or savecolor != cell.Borders(ExcelConst::XlEdgeBottom).Color then 
	                    if savestyle  !=  ExcelConst::XlLineStyleNone or saveweight != ExcelConst::XlThin  or savecolor != 0 
	                        @wline << [savecellrow,savecellcolumn,saverowpos,savecolumnpos,widthvalue,savestyle,saveweight,savecolor]
	                    end  ##if saveborder  !=  ExcelConst::XlLineStyleNone
	                    widthvalue = 0.0
	                    if cell.Borders(ExcelConst::XlEdgeBottom).LineStyle ==  ExcelConst::XlLineStyleNone and  cell.Borders(ExcelConst::XlEdgeBottom).Weight == ExcelConst::XlThin  and  cell.Borders(ExcelConst::XlEdgeBottom).Color == 0 then
	                        saverowpos = 0.0
		                    savecolumnpos = 0.0
		                    else
		                        saverowpos =  rowpos 
		                        savecellcolumn =  cell.column
		                        savecellrow =  cell.row
		                        savecolumnpos =  columnpos
                            end  ## if cell.Borders(ExcelConst::XlEdgeBottom).LineStyle == ExcelConst::XlLineStyleNone
	                        savestyle = cell.Borders(ExcelConst::XlEdgeBottom).LineStyle 
                            saveweight = cell.Borders(ExcelConst::XlEdgeBottom).Weight
                            savecolor = cell.Borders(ExcelConst::XlEdgeBottom).Color
	                    end ##if saveboder != cell.Borders(ExcelConst::XlEdgeBottom).LineStyle then 
	                    widthvalue +=  cell.Width
	                    ################# 罫線処理終了
	                    #背景色処理開始
	                    if cell.MergeCells	 
	                        if  cell.MergeArea.Item(1,1).row == cell.row and  cell.MergeArea.Item(1,1).column == cell.column then
		                        if  rectsavecolor !=  cell.MergeArea.Interior.Color then
                                    if  rectsavecolor != 0 then
		                                @fill_rectangle_color << [rectsavecellrow,rectsavecellcolumn,rectsaverowpos,rectsavecolumnpos,rectwidthvalue,rectheight,rectsavecolor]
			                            rectwidthvalue = 0
                                    end
		                            if  cell.MergeArea.Interior.Color == 0  then 
                                        rectsavecellrow = rectsavecellcolumn = rectsaverowpos = rectsavecolumnpos = rectwidthvalue = rectheight = 0
	 	                            else
		                                rectsaverowpos =  rowpos -  cell.MergeArea.Height
		                                rectsavecellcolumn =  cell.column
		                                rectsavecellrow =  cell.row
		                                rectsavecolumnpos =  columnpos
		                                rectsavecolor =  cell.MergeArea.Interior.Color
		                                rectheight = cell.MergeArea.Height
	                                end   ## cell.Interior.Color == 
		                        end
	                        end  ##cell.MergeArea.Item(1,1).row == cell.row and  cell.MergeArea.Item(1,1).column == cell.column
	                    else
	                        if  rectsavecolor != cell.Interior.Color then
	                            if  rectsavecolor != 0 then  
		                            @fill_rectangle_color << [rectsavecellrow,rectsavecellcolumn,rectsaverowpos,rectsavecolumnpos,rectwidthvalue,rectheight,rectsavecolor]
		                            rectwidthvalue = 0
                                end
	                            if cell.Interior.Color == 0  then 
                                    rectsavecellrow = rectsavecellcolumn = rectsaverowpos = rectsavecolumnpos = rectwidthvalue = rectheight = 0
		                        else
		                            rectsaverowpos =  rowpos - cell.Height
		                            rectsavecellcolumn =  cell.column
		                            rectsavecellrow =  cell.row
		                            rectsavecolumnpos =  columnpos
		                            rectsavecolor = cell.Interior.Color
		                            rectheight = cell.Height
	                            end   ## cell.Interior.Color == 
	                        end ####rectsavecolor != cell.Interior.Color
	                    end  ### cell.MergeCells
	                    rectwidthvalue += cell.Width  ##色の幅
                        columnpos +=  cell.Width
                end  ##column
             end ##row
            @fill_rectangle_color << [rectsavecellrow,rectsavecellcolumn,rectsaverowpos,rectsavecolumnpos,rectwidthvalue,rectheight,rectsavecolor] if  rectsavecolor != 0
            @wline << [savecellrow,savecellcolumn,saverowpos,savecolumnpos,widthvalue,savestyle,saveweight,savecolor] if  savestyle !=  ExcelConst::XlLineStyleNone
            rowpos = 0.0
            columnpos = 0.0
            saverowpos = 0.0
            savecolumnpos = 0.0
            saveheight = 0 
            savecellrow = 0
            savecellcolumn = 0
            sheet.UsedRange.Columns.each do |column|  ###縦の罫線
                heightvalue = 0.0
                rowpos = 0.0
	            @hline << [savecellrow,savecellcolumn,saverowpos,savecolumnpos,heightvalue,savestyle,saveweight,savecolor] if  savestyle !=  ExcelConst::XlLineStyleNone  or saveweight != ExcelConst::XlThin  or savecolor != 0
	            savestyle = column.Borders(ExcelConst::XlEdgeLeft).LineStyle
	            saveweight = column.Borders(ExcelConst::XlEdgeLeft).Weight
	            savecolor = column.Borders(ExcelConst::XlEdgeLeft).Color
                column.Rows.each do |cell|
                    if savestyle != cell.Borders(ExcelConst::XlEdgeLeft).LineStyle or saveweight != cell.Borders(ExcelConst::XlEdgeLeft).Weight  or savecolor != cell.Borders(ExcelConst::XlEdgeLeft).Color then 
	                    if savestyle  !=  ExcelConst::XlLineStyleNone or saveweight != ExcelConst::XlThin  or savecolor != 0  then
	                        @hline << [savecellrow,savecellcolumn,saverowpos,savecolumnpos,heightvalue,savestyle,saveweight,savecolor]
	                    end  ##if saveborder  !=  ExcelConst::XlLineStyleNone
	                    heightvalue = 0.0
	                    if cell.Borders(ExcelConst::XlEdgeLeft).LineStyle ==  ExcelConst::XlLineStyleNone and saveweight == ExcelConst::XlThin  and  savecolor == 0 then
	                        saverowpos = 0.0
		                    savecolumnpos = 0.0
		                else
		                    saverowpos =  rowpos 
		                    savecellcolumn =  cell.column
		                    savecellrow =  cell.row
		                    savecolumnpos =  columnpos
                        end  ## if cell.Borders(ExcelConst::XlEdgeLeft).LineStyle == -4142 
	                    savestyle = cell.Borders(ExcelConst::XlEdgeLeft).LineStyle 
                        saveweight = cell.Borders(ExcelConst::XlEdgeLeft).Weight
	                    savecolor = cell.Borders(ExcelConst::XlEdgeLeft).Color
	                end ##if saveboder != cell.Borders(ExcelConst::XlEdgeLeft).LineStyle then 
                    heightvalue +=  cell.Height
	                rowpos += cell.Height
                end  ##row
	            @hline << [savecellrow,savecellcolumn,saverowpos,savecolumnpos,heightvalue,savestyle,saveweight,savecolor]  if savestyle  !=  ExcelConst::XlLineStyleNone
                columnpos += column.Width
            end ##column
            @prwanstr =  "###   start ###\n"
            ##crt_prwan_pdf
            @subfields = plsql.__send__(@viewname).column_names
            chng_tblfield 
            crt_prwan_org_pdf
            @prwanstr <<  "##### /@sum = #{@sum}  /###\n" 
            strorderby = ""
            @sortkey.sort.each do |key,value|
	            strorderby <<  value + ","
            end
            @prwanstr <<  "##### /order by #{strorderby.chop}  /#\n" if @sortkey.size>0
            @prwanstr <<  "##### /pagekey =  #{@pagekey}  /#\n" if @pagekey.size>0
            ###crt_prwan_tst_pdf		
            foo = File.open("#{Rails.root}/vendor/blk_pdf/#{@report_code}.rb", "w:UTF-8") # 書き込みモード
            foo.puts @prwanstr
            foo.close
			replace_rep = {}
			replace_rep[:filename] = "/vendor/blk_pdf/#{@report_code}.rb"
			replace_rep[:where] = {:id=>report[:id]}
			plsql.reports.update replace_rep
		    @text_data << "<br><P>create pdf script #{@screencode}</p></br>"
        end   ##sheet
        @books.Close		
		render :text =>  @text_data
		rescue
            logger.debug"class #{self} : LINE #{__LINE__} $@: #{$@} " 
            ##logger.debug"class #{self} : LINE #{__LINE__} $!: #{$!} "
		    if @books
			   @books.Close  if respond_to?("@books.Close")
			end
			@text_data << "error  check log " 
			render :text =>  @text_data and return
		end ##beigin
    end
    ###format 日付　yyyy/mm/dd  数値 zzz9.0等
    def  chng_tblfield  
        @max_rcnt = 1   ####一ページに印刷する件数
        @fields.each do |i|  
	       next if i[0].to_s !~ /\d/
           @max_rcnt = i[0] if @max_rcnt  < i[0] and  i[0]  < 900
        end
        #p rcnt
        #p "@fields :#{@fields}"
        @sortkey = {}
        @pagekey = []
        ##tmp = plsql.USER_TAB_COLUMNS.all("where table_name = '#{@screencode}'")
        tmp = plsql.select(:all,"select * from r_screenfields where pobject_code_scr = '#{@screencode}' and screenfield_expiredate > sysdate ")
        @rtype = {}
        @rscale = {}
        tmp.each do |k|
            @rtype[k[:pobject_code_sfd].to_sym] = k[:screenfield_type]
            @rscale[k[:pobject_code_sfd].to_sym] = k[:screenfield_datascale] if  k[:screenfield_type]  == "number"
        end		
        @sum = []
        ##p @box_fields
    end
    def crt_prwan_org_pdf
        begin
            ###サポートしてないタイプは明確に
            #p cpaper_s
            paper_size = @cpaper_s[@paper[:size]]
            paper_size ||= "A4"
            orientation = [nil,:portrait,:landscape]
            fill_rectangle_color = @fill_rectangle_color
            @prwanstr <<  "##### /pdfparam = {:page_size =>'#{paper_size}',:page_layout =>:#{orientation[@paper[:orientation]]},:margin=>[#{@margin.join(",")}],:max_rcnt => #{@max_rcnt}}   /#\n"
			@prwanstr <<  " dstart = ppdf.cursor\n"  
            @prwanstr <<  " if rcnt == 1 \n"
            xset_tcolor = ""
            @fill_rectangle_color.each  do |i|   ##最初に持ってこないと罫線等消える。
               @prwanstr <<  "        ppdf.fill_color '#{set_tcolor(i[6])}'\n" if set_tcolor(i[6])  !=  xset_tcolor and  set_tcolor(i[6]) != "ffffff"
               @prwanstr <<  "        ppdf. fill_rectangle [#{i[3]},dstart - #{i[2]}], #{i[4]},#{i[5]}  ##cell(#{i[0]},#{i[1]})\n" if  set_tcolor(i[6]) != "ffffff"
	           xset_tcolor =  set_tcolor(i[6])
            end 
            xweight_s = 0
            xset_tcolor = ""
            @wline.each do |i|
               @prwanstr <<  "     end ##stroke\n"  if  xweight_s != @cweight_s[i[6]] and xweight_s != 0
               @prwanstr <<  "     ppdf.line_width = #{@cweight_s[i[6]]}\n"  if  xweight_s != @cweight_s[i[6]]
	           @prwanstr <<  "     ppdf.stroke do \n" if  xweight_s != @cweight_s[i[6]]
	           @prwanstr <<  "         ppdf.stroke_color  '#{set_tcolor(i[7])}'\n" if set_tcolor(i[7])  !=  xset_tcolor
               @prwanstr <<  "         ppdf.horizontal_line  #{i[3]},#{i[3] + i[4]},:at=>dstart - #{i[2]}  ## cell(#{i[0]},#{i[1]})\n"
	           xset_tcolor =  set_tcolor(i[7])
               xweight_s = @cweight_s[i[6]]
            end
            @hline.each do |i|
	            @prwanstr <<  "     end ##stroke\n"  if  xweight_s != @cweight_s[i[6]] and xweight_s != 0
	            @prwanstr <<  "     ppdf.line_width = #{@cweight_s[i[6]]}\n" if  xweight_s != @cweight_s[i[6]]
	            @prwanstr <<  "     ppdf.stroke do \n" if  xweight_s != @cweight_s[i[6]]
	            @prwanstr <<  "         ppdf.stroke_color  '#{set_tcolor(i[7])}'\n" if set_tcolor(i[7])  !=  xset_tcolor
                @prwanstr <<  "         ppdf.vertical_line dstart - #{i[2] + i[4]},dstart - #{i[2]},:at=>#{i[3]} ## cell(#{i[0]},#{i[1]})\n"   ##i[2] + i[4]  だよ
                xset_tcolor =  set_tcolor(i[7])
                xweight_s = @cweight_s[i[6]]
            end  
            @prwanstr <<  "     end ##stroke\n"
            @prwanstr <<  "   end       ##if  rcnt == 1\n"
            xset_tcolor = ""
            @fields.each do |x|
			    next if x[1][0] == 1 or  x[1][1] == 1   ## 左端　最上段は　印刷対象外　一ページ内のレコードの何件目かに使用している。 
	            i = set_i5(x) 
	            @prwanstr <<   "       ppdf.fill_color '#{set_tcolor (i[8])}'\n" if xset_tcolor != set_tcolor(i[8])
                @prwanstr <<  %Q|      ppdf.draw_text  #{i[5]},:at=>[#{i[3] + 1},dstart - #{i[2] -1} ],:size=>#{i[4]} if rcnt == #{x[0]} ## cell(#{i[0]},#{i[1]})\n|
	            xset_tcolor = set_tcolor (i[8])
            end
            @box_fields.each do |x|
			    next if x[1][0] == 1 or x[1][1] == 1   ## 左端　最上段は　印刷対象外　一ページ内のレコードの何件目かに使用している。
	            i = set_i5(x) 
	            @prwanstr <<   "       ppdf.fill_color '#{set_tcolor (i[8])}'\n"  if xset_tcolor != set_tcolor(i[8])
				case i[11]
				    when /code39/ 
					    @prwanstr <<  %Q| ppdf.bounding_box [#{i[3]} ,dstart - #{i[2]}- #{i[7]}] , :width =>  #{i[6]} do 
	                        barcode = Barby::Code39.new(#{ i[5] })
                            barcode.annotate_pdf(ppdf, :height => #{i[7]})
                        end if rcnt == 1 ## cell(5,36) \n|
					when /qrcode/
					else
	                    @prwanstr <<  %Q|      ppdf.text_box  #{ i[5] },:at=>[#{i[3]} ,dstart - #{i[2] }],:width => #{i[6]} ,:height => #{i[7]},
				                                      #{if i[4] then ":size=>"+i[4].to_s+"," else "" end}:overflow => :shrink_to_fit,:align => #{i[9]},
													  :valign=>#{i[10]} if rcnt == #{x[0]} ## cell(#{i[0]},#{i[1]}) \n|
				end
	            xset_tcolor = set_tcolor (i[8])
            end
        rescue 
	        ##@books.Close
	        p  $!
            ##p  $@
		    if @books
			   @books.Close  if respond_to?("@books.Close")
			end
        end  ##begin   
    end
	def init_starrt
	    @rendererrmsg = []
	    @pare_class = "online"
        @wline = []   ##横線 [セル縦,セル横,開始位置縦,横,長さ,線種,太さ,色] 
        @hline = []   ##縦線
        @fields = []
        @box_fields = []
        @paper = {}
        @fill_rectangle_color = []		
        @chorichar_s = {"#{ExcelConst::XlCenter}".to_i =>":center",
                "#{ExcelConst::XlGeneral}".to_i => ":right",
                "#{ExcelConst::XlLeft}".to_i => ":left",
                "#{ExcelConst::XlRight}".to_i => ":right"}
        @cvertchar_s = {"#{ExcelConst::XlCenter}".to_i => ":center",
                "#{ExcelConst::XlTop}".to_i => ":top",
                "#{ExcelConst::XlBottom}".to_i => ":bottom"}
            ## A3:8, A4:9, A5:11
            ##dstart = 770 ### 縦開始位置 A4 縦
        @cpaper_s = {"#{ExcelConst::XlPaperA4}".to_i => "A4",
                "#{ExcelConst::XlPaperA5}".to_i => "A5",
                "#{ExcelConst::XlPaperB5}".to_i => "B5",
				
                "#{ExcelConst::XlPaperEnvelopeB4}".to_i => "B4",
                "#{ExcelConst::XlPaperEnvelopeB6}".to_i => "B6",
                "#{ExcelConst::XlPaperEnvelopeC6}".to_i => "C6",
                "#{ExcelConst::XlPaperA3}".to_i => "A3",
                "#{ExcelConst::XlPaperA4Small}".to_i => "A4",
                "#{ExcelConst::XlPaperB4}".to_i => "B4",
                "#{ExcelConst::XlPaperEnvelopeB5}".to_i => "B5",
                "#{ExcelConst::XlPaperEnvelopeC3}".to_i => "C3",
                "#{ExcelConst::XlPaperEnvelopeC5}".to_i => "C5",
                "#{ExcelConst::XlPaperExecutive}".to_i => "EXECUTIVE",
                "#{ExcelConst::XlPaperFolio}".to_i => "FOLIO",
                "#{ExcelConst::XlPaperLegal}".to_i => "LEGAL",
                "#{ExcelConst::XlPaperLetterSmall}".to_i => "LETTER",
                "#{ExcelConst::XlPaperTabloid}".to_i => "TABLOID"}
        @cweight_s = {"#{ExcelConst::XlThin}".to_i => 0.5,
                "#{ExcelConst::XlMedium}".to_i => 2,
                "#{ExcelConst::XlThick}".to_i => 4}
  
	end
    def set_i5 x
	    rcnt = x[0]
		i = x[1] 
		opt = nil
	            ###  日付の編集　duedate.strftime("%Y/%m/%d")
	            ##number_with_precision(1111.2345, :precision => 2, :separator => ',', :delimiter => '.')
		i5 = i[5]
		i[5] = ""
		i5.split(/\+/).each do |field|
            if field =~ /^:/
			    field.split("#").each_with_index do |fieldname,indx|
                    if indx == 0
					    fieldnamesym = fieldname[1..-1].to_sym
					    if 	@subfields.index(fieldnamesym) or fieldname =~ /^:blk_/  
	                        if rcnt < 990  and fieldname !~ /^:blk_/
							    case  @rtype[fieldnamesym] 
							        when /time|date/
								        i[5] << " (if record[#{fieldname}] then record[#{fieldname}].strftime('%Y/%m/%d') else '' end) +"
								    when "number"
									    i[5] << " (if record[#{fieldname}] then number_with_precision(record[#{fieldname}], :precision =>#{@rscale[fieldnamesym]}, :separator => '.', :delimiter => ',') else '' end) +" if  rcnt < 900
								else
									    i[5] << "(record[#{fieldname}]||='') +"
								end
							end
	                        i[5] <<  "sum998[:blk_pagecnt].to_s +" if  fieldnamesym == :blk_pagecnt  and rcnt  == 998
                            i[5] <<  "sum999[:blk_pagecnt].to_s +" if  fieldnamesym == :blk_pagecnt and rcnt  == 999
	                        i[5] <<  "sum998[:blk_reccnt].to_s +" if  fieldnamesym == :blk_reccnt and rcnt  == 998
                            i[5] <<  "sum999[:blk_reccnt].to_s +" if  fieldnamesym == :blk_treccnt  and rcnt  == 999
	                        if  @rtype[fieldnamesym] == "number" and rcnt == 998 
		                         i[5] = " (if sum998[#{fieldname}] then number_with_precision(sum998[#{fieldname}], :precision =>#{@rscale[fieldnamesym]}, :separator => '.', :delimiter => ',')  else '' end)  +"
	                        end
	                        if  @rtype[fieldnamesym] == "number" and rcnt == 999 
		                        i[5] = " (if sum999[#{fieldname}] then number_with_precision(sum999[#{fieldname}], :precision =>#{@rscale[fieldnamesym]}, :separator => '.', :delimiter => ',')  else '' end)  +"
	                        end
	                        @sum <<  fieldnamesym  if @rtype[fieldnamesym] == "number" and @sum.index(fieldnamesym).nil?
                                ###i << (i[5][(i[5] =~ /[a-z]/)..-1]).split(",")[1]    ###i[9] 編集 使用中止
					        opt = fieldname
						else
						    i[5] <<  field + "+" if field != ""	
						end
                    else
                        if  opt 			
	                        case fieldname 
	                            when /^sort/
								    checksort = fieldname.sub(/sort\s{0,}/,"")
							        if  checksort =~  /\d/  
		                                @sortkey[ checksort ] =  opt[1..-1] + (if checksort[1..-1] then checksort[1..-1]  else "" end)   ### i[5][1] 
								    end
                                when /^page/									 
                                    @pagekey  <<  opt[1..-1]
                                when /code39/
								     i[11] = "code39"
                                when /qrcode/
								     i[11] = "qrcode"
								else
								    @text_data << "<br><p>line #{__LINE__} error : option error  #{@report_code} cell(#{i[0]},#{i[1]}) </p></br>"
                            end ### case
						else
						    i[5] <<  field + "+" if field != ""	
						end	
	                end ##   
	            end   ## field + option
            else            
	            if i5.class == String then
		           i[5] << "'" + field.encode("utf-8") + "'+"   if field != ""	
	            else
	               i[5] << field.to_s + "+"  if field != ""	
                end		  
			end	
	    end  ##@subfields.index(fieldname)
        i[5].chop!	
        i[9] = @chorichar_s[i[9]]  ###数字項目の右づめはセルで指定する。
        ##i[9] ||=  if @rtype[fieldname] == "number" then ":right" else  ":left" end  ###i[9] 右詰左詰め
        i[10] = @cvertchar_s[i[10]]
        i[10] ||= ":center"
        return i
    end
    def set_tcolor tc
        tcolor = "0"*(6 - tc.to_i.to_s(16).size) +  tc.to_i.to_s(16) 
        tcolor = tcolor[4..5] + tcolor[2..3] + tcolor[0..1]
        return tcolor
    end
end
class  ExcelConst
end
### i[0] excel row
### i[1] excel column
### i[2] pdf 縦位置
### i[3] pdf 横位置
### i[4]
### i[5] cell の値
### i[9] 縦横　中央
### i[10] 上下　中央