# -*- coding: utf-8 -*-
################ -*- coding: utf-8 -*-
require 'win32ole'
require 'prawn'
class  ExcelConst
end
class  Test
def initialize
   @wline = []   ##横線 [セル縦,セル横,開始位置縦,横,長さ,線種,太さ] 
   @hline = []   ##縦線
   @merge_box = {}  ##box [key:セル縦_セル横 value[開始位置縦,横,横の長さ,縦の長さ,線種,太さ]] 　　上部の線種でbox作成
   @fields = []
   @box_fields = {}
   @paper = {}
end
def blk_set_excel_info infile
 app = WIN32OLE.new('Excel.Application')
 WIN32OLE.const_load(app, ExcelConst)
 books = app.Workbooks.Open(infile)
 sheet = books.Worksheets.Item(1)
 savestyle = ExcelConst::XlLineStyleNone
 books.Worksheets.each do |sheet|
     @paper[:bottom] = sheet.PageSetup.BottomMargin
     @paper[:left] = sheet.PageSetup.LeftMargin
     @paper[:right] = sheet.PageSetup.RightMargin
     @paper[:top] =  sheet.PageSetup.TopMargin 
     @paper[:orientation] = sheet.PageSetup.Orientation  ##縦1 横 2
     @paper[:size] = sheet.PageSetup.PaperSize ## A3:8, A4:9, A5:11
      rowpos = 0.0  ##縦位置
      saverowpos = 0.0  #線種の始まり
      savecolumnpos = 0.0
      saveweight = 0 ##太さ
      savecellrow = 0
      savecellcolumn = 0
####  横線種　box　項目作成
      sheet.UsedRange.Rows.each do |row|
      widthvalue = 0.0  ##横線長さ
      columnpos = 0.0   ##横位置
      rowpos += row.Height
      @wline << [savecellrow,savecellcolumn,saverowpos,savecolumnpos,widthvalue,savestyle,saveweight] if  savestyle !=  ExcelConst::XlLineStyleNone
      savestyle =  row.Borders(ExcelConst::XlEdgeBottom).LineStyle
      row.Columns.each do |cell|
      if cell.MergeCells	 
         @wline << [savecellrow,savecellcolumn,saverowpos,savecolumnpos,widthvalue,savestyle,saveweight] if  savestyle !=  ExcelConst::XlLineStyleNone
         savestyle = ExcelConst::XlLineStyleNone
        if  cell.MergeArea.Item(1,1).row == cell.row and  cell.MergeArea.Item(1,1).column == cell.column then
            @merge_box[cell.row.to_s + "_" + cell.column.to_s]  = [rowpos,columnpos,cell.MergeArea.Width,cell.MergeArea.Height, cell.MergeArea.Borders(ExcelConst::XlEdgeBottom).LineStyle,cell.MergeArea.Borders(ExcelConst::XlEdgeBottom).Weight] 
	    @box_fields[cell.row.to_s + "_" + cell.column.to_s]  = cell.MergeArea.Item(1,1).Value
	 end
	 else
	 if savestyle != cell.Borders(ExcelConst::XlEdgeBottom).LineStyle then 
	    if savestyle  !=  ExcelConst::XlLineStyleNone then
	       @wline << [savecellrow,savecellcolumn,saverowpos,savecolumnpos,widthvalue,savestyle,saveweight]
	       widthvalue = 0.0 
	    end  ##if saveborder  !=  ExcelConst::XlLineStyleNone
	    widthvalue = 0.0
	    if cell.Borders(ExcelConst::XlEdgeBottom).LineStyle ==  ExcelConst::XlLineStyleNone then
	          saverowpos = 0.0
		  savecolumnpos = 0.0
		 else
		  saverowpos =  rowpos 
		  savecellcolumn =  cell.column
		  savecellrow =  cell.row
		  savecolumnpos =  columnpos
            end  ## if cell.Borders(ExcelConst::XlEdgeBottom).LineStyle == -4142 
	    savestyle = cell.Borders(ExcelConst::XlEdgeBottom).LineStyle 
            saveweight = cell.Borders(ExcelConst::XlEdgeBottom).Weight
	  end ##
	      ###if saveboder != cell.Borders(ExcelConst::XlEdgeBottom).LineStyle then 
           widthvalue +=  cell.Width
	    if  cell.Value then
	        @fields<<  [cell.row,cell.column,rowpos,columnpos,cell.Value] if  cell.Value.class == String 
		@fields<<  [cell.row,cell.column,rowpos,columnpos,cell.value.to_s] if  cell.Value.class != String
	    end
	    columnpos +=  cell.Width
	  end
       end  ##column
      end ##row
      rowpos = 0.0
      columnpos = 0.0
      saverowpos = 0.0
      savecolumnpos = 0.0
      saveheight = 0 
      savecellrow = 0
      savecellcolumn = 0
      sheet.UsedRange.Columns.each do |column|
            heightvalue = 0.0
            rowpos = 0.0
	    @hline << [savecellrow,savecellcolumn,saverowpos,savecolumnpos,heightvalue,savestyle,saveweight] if  savestyle !=  ExcelConst::XlLineStyleNone
	    savestyle = column.Borders(ExcelConst::XlEdgeLeft).LineStyle
        column.Rows.each do |cell|
           if cell.MergeCells	 
               @hline << [savecellrow,savecellcolumn,saverowpos,savecolumnpos,heightvalue,savestyle,saveweight] if  savestyle !=  ExcelConst::XlLineStyleNone
               savestyle = ExcelConst::XlLineStyleNone
           else
           if savestyle != cell.Borders(ExcelConst::XlEdgeLeft).LineStyle then 
	        if savestyle  !=  ExcelConst::XlLineStyleNone then
	           @hline << [savecellrow,savecellcolumn,saverowpos,savecolumnpos,heightvalue,savestyle,saveweight]
	        end  ##if saveborder  !=  ExcelConst::XlLineStyleNone
	      heightvalue = 0.0
	      if cell.Borders(ExcelConst::XlEdgeLeft).LineStyle ==  ExcelConst::XlLineStyleNone then
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
	  end ##if saveboder != cell.Borders(ExcelConst::XlEdgeLeft).LineStyle then 
           heightvalue +=  cell.Height
	 end
	  p rowpos if cell.column == 2
	  rowpos += cell.Height
        end  ##row
      columnpos += column.Width
      end ##column

end   ##sheet
  p @wline
  #p @fields
  p @hline
  #p @merge_box
  #p "xlPaperA4 #{ExcelConst::XlPaperA4}"
  crt_prwan_pdf @wline,@hline,@fields,@paper
    books.Close
end
def crt_prwan_pdf wline,vline,fields,paper
     ## A3:8, A4:9, A5:11
    dstart = 770 ### 縦開始位置 A4 縦
    cpaper_s = {8=>"A3",9=>"A4",11=>"A5"}  ###サポートしてないタイプは明確に
    paper_size = cpaper_s[paper[:size]]
    paper_size ||= "A4"
    orientation = [nil,:portrait,:landscape]
    Prawn::Document.generate("implicit.pdf",:page_size => "#{paper_size}",:page_layout => orientation[paper[:orientation]]) do
     font "C:/plsql/v082/vendor/font/ipaexm.ttf"
     dstart = cursor
     stroke do
       self.line_width = 0.5
       wline.each do |i|
           horizontal_line  i[3],i[3] + i[4],:at=>dstart - i[2]
       end
       vline.each do |i|
           vertical_line dstart - i[2] - i[4],dstart - i[2],:at=>i[3]
       end  
     end
     fields.each do |i|
       draw_text  i[4].encode("utf-8"),:at=>[i[3].to_i,dstart - i[2] + 2]
     end  
    end
    fields.each do |i|
      fprnt " draw_text  #{i[4].encode("utf-8")},:at=>[#{i[2].to_i},#{i[3].to_i}]"
     end  

end 
#blk_set_excel_info

# p @valuehach
# p @rulehacht
#p @rulehachr
#p @rulehachl
#p @rowheight
#p @columnwidth
  def fprnt str
    foo = File.open("blk#{Process::UID.eid.to_s}.script", "a") # 書き込みモード
    foo.puts str
    foo.close
  end   ##fprnt str
end
