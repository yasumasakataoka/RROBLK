# -*- coding: utf-8 -*-
################ -*- coding: utf-8 -*-
require 'win32ole'
require 'prawn'
require 'ruby-plsql'
plsql.connection = OCI8.new("rails","rails","xe")
class  ExcelConst
end
class  Test
def initialize
   @wline = []   ##横線 [セル縦,セル横,開始位置縦,横,長さ,線種,太さ] 
   @hline = []   ##縦線
   ##@merge_box = {}  ##box [key:セル縦_セル横 value[開始位置縦,横,横の長さ,縦の長さ,線種,太さ]] 　　上部の線種でbox作成
   @fields = []
   @box_fields = []
   @paper = {}
end
def blk_set_excel_info infile
 app = WIN32OLE.new('Excel.Application')
 WIN32OLE.const_load(app, ExcelConst)
 @books = app.Workbooks.Open(infile)
 sheet = @books.Worksheets.Item(1)
 savestyle = ExcelConst::XlLineStyleNone
 @books.Worksheets.each do |sheet|
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
      savestyle =   ExcelConst::XlLineStyleNone
      row.Columns.each do |cell|
      if cell.MergeCells	 
         ##@wline << [savecellrow,savecellcolumn,saverowpos,savecolumnpos,widthvalue,savestyle,saveweight] if  savestyle !=  ExcelConst::XlLineStyleNone
         ##savestyle = ExcelConst::XlLineStyleNone
         if  cell.MergeArea.Item(1,1).row == cell.row and  cell.MergeArea.Item(1,1).column == cell.column then
             ##@merge_box[cell.row.to_s + "_" + cell.column.to_s]  = [rowpos,columnpos,cell.MergeArea.Width,cell.MergeArea.Height, cell.MergeArea.Borders(ExcelConst::XlEdgeBottom).LineStyle,cell.MergeArea.Borders(ExcelConst::XlEdgeBottom).Weight] 
	    @box_fields << [cell.row,cell.column,rowpos,columnpos,cell.MergeArea.Font.size,cell.MergeArea.Item(1,1).Value.to_s, cell.MergeArea.Width,cell.MergeArea.Height] if cell.MergeArea.Item(1,1).Value
	     ##p "cell.MergeArea.Item(1,1).Value #{ cell.MergeArea.Item(1,1).Value}"
      	 end
        else
	  if  cell.Value then
	        ##@fields<<  [cell.row,cell.column,rowpos,columnpos,cell.Value] if  cell.Value.class == String 
		@fields<<  [cell.row,cell.column,rowpos,columnpos,cell.Font.size,cell.value.to_s]   ##if  cell.Value.class != String
	   end
	end  ##cell.MergeCells	
	if savestyle != cell.Borders(ExcelConst::XlEdgeBottom).LineStyle then 
	    if savestyle  !=  ExcelConst::XlLineStyleNone then
	       @wline << [savecellrow,savecellcolumn,saverowpos,savecolumnpos,widthvalue,savestyle,saveweight]
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
            end  ## if cell.Borders(ExcelConst::XlEdgeBottom).LineStyle == ExcelConst::XlLineStyleNone
	    savestyle = cell.Borders(ExcelConst::XlEdgeBottom).LineStyle 
            saveweight = cell.Borders(ExcelConst::XlEdgeBottom).Weight
	  end ##if saveboder != cell.Borders(ExcelConst::XlEdgeBottom).LineStyle then 
	   ##p  cell.column.to_s + "  : "   + cell.Borders(ExcelConst::XlEdgeBottom).LineStyle.to_s +  cell.Width.to_s   if cell.row == 12 
          widthvalue +=  cell.Width
          columnpos +=  cell.Width
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
           ##if cell.MergeCells	 
               ##@hline << [savecellrow,savecellcolumn,saverowpos,savecolumnpos,heightvalue,savestyle,saveweight] if  savestyle !=  ExcelConst::XlLineStyleNone
               ##savestyle = ExcelConst::XlLineStyleNone
           ##else
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
	 ##end
	  ##p rowpos if cell.column == 2
	  rowpos += cell.Height
          ##  cell.column.to_s + "  : "   + cell.Borders(ExcelConst::XlEdgeLeft).LineStyle.to_s  if cell.row == 12 
        end  ##row
      columnpos += column.Width
      end ##column
      if PLSQL::View.find(plsql, sheet.name).nil?
         p	 "not exists table #{sheet.name}"
         exit(0)
      end
    @sheetname = sheet.name
    fprnt "######## start #############","w"
    ##crt_prwan_pdf
    @subfields = plsql.__send__(sheet.name).column_names
    chng_tblfield 
    #p @fields
    crt_prwan_org_pdf
     crt_prwan_tst_pdf
  end   ##sheet
  @books.Close
end
###format 日付　yyyy/mm/dd  数値 zzz9.0等
def  chng_tblfield  
     rcnt = {}  ###その行は何番目のレコード
     @max_rcnt = 1
      @fields.each do |i|  
	 rcnt[i[0]] = i[5].to_i if i[1] == 1
         @max_rcnt = rcnt[i[0]] if @max_rcnt  < rcnt[i[0]]
      end
      p rcnt
      #p "@fields :#{@fields}"
     tmp_fields = []
     @fields.each do |i|
      if  i[5] =~ /^:/ then
           fieldname = i[5][(i[5] =~ /[a-z]/)..-1].to_sym
	  if @subfields.index(fieldname) then
	     i[5] = "record[:#{fieldname}]"
	  end
      end
      tmpcnt = rcnt[i[0]]   ##### 何番目かセット
      tmpcnt ||= 1
      tmp_fields << [tmpcnt,i]  if i[1] != 1
    end
    @fields = tmp_fields
    tmp_box_fields = []
     @box_fields.each do |i|
      if  i[5] =~ /^:/ then
           fieldname = i[5][(i[5] =~ /[a-z]/)..-1].to_sym
	  if @subfields.index(fieldname) then
	     i[5] = "record[:#{fieldname}]"
	  end
      end
      tmpcnt = rcnt[i[0]]
      tmpcnt ||= 1
      tmp_box_fields << [tmpcnt,i]  if i[1] != 1
    end
    @box_fields = tmp_box_fields
end
def crt_prwan_org_pdf
     ## A3:8, A4:9, A5:11
    ##dstart = 770 ### 縦開始位置 A4 縦
    cpaper_s = {8=>"A3",9=>"A4",11=>"A5"}  ###サポートしてないタイプは明確に
    paper_size = cpaper_s[@paper[:size]]
    paper_size ||= "A4"
    orientation = [nil,:portrait,:landscape]
    wline = @wline
    hline = @hline
    fields = @fields
    box_fields = @box_fields
    fprnt "##### /param = {:sheetname=>'#{@sheetname}',:page_size =>'#{paper_size}',:page_layout =>:#{orientation[@paper[:orientation]]},:max_rcnt => #{@max_rcnt}}/  ###"
    Prawn::Document.generate("test_#{@sheetname}_org.pdf",:page_size => "#{paper_size}",:page_layout => orientation[@paper[:orientation]]) do 
     font "C:/plsql/v082/vendor/font/ipaexm.ttf"
     dstart = cursor
     stroke do
       self.line_width = 0.5
       wline.each do |i|
           horizontal_line  i[3],i[3] + i[4],:at=>dstart - i[2]
       end
       hline.each do |i|
           vertical_line dstart - i[2] - i[4],dstart - i[2],:at=>i[3]
       end  
     end ##stroke
     fields.each do |i|
       i.each do |j|	    
         draw_text  j[5].to_s.encode("utf-8"),:at=>[j[3],dstart - j[2] + 2 ],:size=>j[4]
       end
     end
     box_fields.each do |i|
       i.each do |j|
         text_box  j[5].to_s.encode("utf-8"),:at=>[j[3] ,dstart - j[2]],:width => j[6] ,:height => j[7],:size=>j[4],:overflow => :shrink_to_fit,:align => :center 
       end
     end 
    end  ### Prawn::Document.generate

    fprnt " dstart = ppdf.cursor"  
    fprnt " if rcnt == 1 then"
    fprnt "    ppdf.stroke do"
    fprnt "   ppdf.line_width = 0.5"
    @wline.each do |i|
          fprnt "     ppdf.horizontal_line  #{i[3]},#{i[3] + i[4]},:at=>dstart - #{i[2]}  ## cell(#{i[0]},#{i[1]})"
       end
       @hline.each do |i|
          fprnt "     ppdf.vertical_line dstart - #{i[2] + i[4]},dstart - #{i[2]},:at=>#{i[3]} ## cell(#{i[0]},#{i[1]})"   ##i[2] + i[4]  だよ
       end  
    fprnt " end ##stroke"
    fprnt "end"
     @fields.each do |x|
       i = x[1]    ##x[0] ヘッダレコードに対しての相対位置　1:ヘッダレコード　2:次のレコード　・・・・
       i5 = ""
       if i[5] =~ /^record/ then 
	       i5 = i[5].encode("utf-8") 
            else
	       if i[5].class == String then
		   i5 = "'" + i[5].encode("utf-8") + "'" 
	         else
	           i5 = i[5].to_s
               end		   
       end
       fprnt %Q|      ppdf.draw_text  #{i5},:at=>[#{i[3]},dstart - #{i[2] + 2} ],:size=>#{i[4]} if rcnt == #{x[0]} ## cell(#{i[0]},#{i[1]})|
     end
     @box_fields.each do |x|
       i = x[1]
       i5 = ""
       if i[5] =~ /^record/ then 
	       i5 = i[5] 
            else
	       if i[5].class == String then
		   i5 = "'" + i[5].encode("utf-8") + "'" 
	         else
	           i5 = i[5].to_s
               end		   
       end
       fprnt %Q|      ppdf.text_box  #{i5},:at=>[#{i[3]} ,dstart - #{i[2]}],:width => #{i[6]} ,:height => #{i[7]},:size=>#{i[4]},:overflow => :shrink_to_fit,:align => :center if rcnt == #{x[0]} ## cell(#{i[0]},#{i[1]}) |
     end
end
def crt_prwan_tst_pdf
    begin
    foo = File.open("blk_#{@sheetname}_script.rb","r:UTF-8")
    lines = 1
    str = ""
    param = nil
    while l = foo.gets
          case lines
	     when 2
		p "param err "  if l.split("/")[1].nil?
		eval(l.split("/")[1])  if l.split("/")[1] =~ /^param/
		##p  l.split("/")[1]  if l.split("/")[1] =~ /^param/	
	     when 1
	     else
                  str << l
	   end
	  lines += 1
    end
    foo.close 
    ppdf = TestDocument.new({:page_size =>param[:page_size],:page_layout =>param[:page_layout]})
    #p ppdf.methods.sort
    #options = {:page_layout => :landscape}
    #options = {:page_layout =>param[:page_layout]}
    #ppdf = TestDocument.new(options)
    options = {:page_size =>param[:page_size],:page_layout =>param[:page_layout]}
    p options
    records = plsql.__send__(@sheetname).all
    rcnt = cnt = 1
    ppdf.font "C:/plsql/v082/vendor/font/ipaexm.ttf" 
    records.each do |record|
	  record.each_pair do |key,value|
	     record[key] = value.encode('utf-8') if value.class == String
	     ##p  value.encoding if value.class == String
	  end
	  ##p record
	  ppdf.to_pdf record,rcnt do
  	        eval(str.encode('utf-8'))
          end
	  ppdf.start_new_page if rcnt == param[:max_rcnt]
	  cnt += 1
	  rcnt = if cnt.divmod(param[:max_rcnt])[1]  == 0 then param[:max_rcnt] else cnt.divmod(param[:max_rcnt])[1]  end
	  break if cnt > 100
    end
    #ppdf.start_new_page(:size => param[:paper_size], :layout => param[:page_layout]) if rcnt != 1
    ##ppdf.render_file("test_#{param[:sheetname]}_tst.pdf",:page_size => "#{param[:paper_size]}",:page_layout =>"#{param[:page_layout]}") do
    ppdf.render_file("test_#{param[:sheetname]}_tst.pdf") 
 
    rescue => exc
	 ##@books.Close
	 p exc
    end  ##begin   
end
end
def fprnt str,aw = "a"
    foo = File.open("blk_#{@sheetname}_script.rb","#{aw}:utf-8") # 書き込みモード
    foo.puts str
    foo.close
end   ##fprnt str
class TestDocument < Prawn::Document
      def to_pdf  record,rcnt
	  yield
      end
end

 t = Test.new
 t.blk_set_excel_info ARGV[0]

