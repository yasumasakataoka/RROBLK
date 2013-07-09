# -*- coding: utf-8 -*-
################ -*- coding: utf-8 -*-
#セル結合した時の色　　結合した書式で色を判別している。excelの書式も結合した形式で行う。
require 'win32ole'
require "action_view"
require 'prawn'
require 'ruby-plsql'
plsql.connection = OCI8.new("rails","rails","xe")
include ActionView::Helpers::NumberHelper
class  ExcelConst
end
class  Test
def initialize
   @wline = []   ##横線 [セル縦,セル横,開始位置縦,横,長さ,線種,太さ,色] 
   @hline = []   ##縦線
   @fields = []
   @box_fields = []
   @paper = {}
   @fill_rectangle_color = []
end
def blk_set_excel_info infile
 app = WIN32OLE.new('Excel.Application')
 WIN32OLE.const_load(app, ExcelConst)
 @books = app.Workbooks.Open(infile)
 sheet = @books.Worksheets.Item(1)
 savestyle = ExcelConst::XlLineStyleNone
 saveweight = ExcelConst::XlThin  ##太さ
 savecolor = 0
 @books.Worksheets.each do |sheet|
     @paper[:bottom] = sheet.PageSetup.BottomMargin
     @paper[:left] = sheet.PageSetup.LeftMargin
     @paper[:right] = sheet.PageSetup.RightMargin
     @paper[:top] =  sheet.PageSetup.TopMargin 
     @paper[:orientation] = sheet.PageSetup.Orientation  ##縦1 横 2
     @paper[:size] = sheet.PageSetup.PaperSize.to_i ## A3:8, A4:9, A5:11
     #p @paper[:size]
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
      if cell.MergeCells	 
         ##@wline << [savecellrow,savecellcolumn,saverowpos,savecolumnpos,widthvalue,savestyle,saveweight] if  savestyle !=  ExcelConst::XlLineStyleNone
         ##savestyle = ExcelConst::XlLineStyleNone
         if  cell.MergeArea.Item(1,1).row == cell.row and  cell.MergeArea.Item(1,1).column == cell.column then
	     ##@box_fields[0:cell row,1:cell column,2:rowpos,3:rowcolumn,4:cell size,5:cell value,6:Width,7:Height,8:color,9:横文字位置,10:縦文字位置]
             @box_fields << [cell.row,cell.column,rowpos - row.Height,columnpos,cell.MergeArea.Font.size,cell.MergeArea.Item(1,1).Value.to_s, cell.MergeArea.Width,cell.MergeArea.Height,cell.MergeArea.Font.color,cell.MergeArea.HorizontalAlignment,cell.MergeArea.VerticalAlignment] if cell.MergeArea.Item(1,1).Value
	     ##p "cell.MergeArea.Item(1,1).Value #{ cell.MergeArea.Item(1,1).Value}"
      	 end
        else
	  if  cell.Value then
	        ##@fields<<  [cell.row,cell.column,rowpos,columnpos,cell.Value] if  cell.Value.class == String 
		@fields<<  [cell.row,cell.column,rowpos,columnpos,cell.Font.size,cell.value.to_s,cell.Font.color]   ##if  cell.Value.class != String
	   end
	end  ##cell.MergeCells	
	if savestyle != cell.Borders(ExcelConst::XlEdgeBottom).LineStyle or saveweight !=  cell.Borders(ExcelConst::XlEdgeBottom).Weight  or savecolor != cell.Borders(ExcelConst::XlEdgeBottom).Color then 
	    if savestyle  !=  ExcelConst::XlLineStyleNone or saveweight != ExcelConst::XlThin  or savecolor != 0 then
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
	   ##p  cell.column.to_s + "  : "   + cell.Borders(ExcelConst::XlEdgeBottom).LineStyle.to_s +  cell.Width.to_s   if cell.row == 12 
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
		  ##p "aa"
	       end   ## cell.Interior.Color == 
	   end ####rectsavecolor != cell.Interior.Color
	  end  ### cell.MergeCells
	     ##p cell.Interior.Color
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
      sheet.UsedRange.Columns.each do |column|
            heightvalue = 0.0
            rowpos = 0.0
	    @hline << [savecellrow,savecellcolumn,saverowpos,savecolumnpos,heightvalue,savestyle,saveweight,savecolor] if  savestyle !=  ExcelConst::XlLineStyleNone  or saveweight != ExcelConst::XlThin  or savecolor != 0
	    savestyle = column.Borders(ExcelConst::XlEdgeLeft).LineStyle
	    saveweight = column.Borders(ExcelConst::XlEdgeLeft).Weight
	    savecolor = column.Borders(ExcelConst::XlEdgeLeft).Color
        column.Rows.each do |cell|
           ##if cell.MergeCells	 
               ##@hline << [savecellrow,savecellcolumn,saverowpos,savecolumnpos,heightvalue,savestyle,saveweight] if  savestyle !=  ExcelConst::XlLineStyleNone
               ##savestyle = ExcelConst::XlLineStyleNone
           ##else
           if savestyle != cell.Borders(ExcelConst::XlEdgeLeft).LineStyle or saveweight != cell.Borders(ExcelConst::XlEdgeLeft).Weight  or savecolor != cell.Borders(ExcelConst::XlEdgeLeft).Color then 
	        if savestyle  !=  ExcelConst::XlLineStyleNone or saveweight != ExcelConst::XlThin  or savecolor != 0
 then
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
	 ##end
	  ##p rowpos if cell.column == 2
	  rowpos += cell.Height
          ##  cell.column.to_s + "  : "   + cell.Borders(ExcelConst::XlEdgeLeft).LineStyle.to_s  if cell.row == 12 
        end  ##row
	 @hline << [savecellrow,savecellcolumn,saverowpos,savecolumnpos,heightvalue,savestyle,saveweight,savecolor]  if savestyle  !=  ExcelConst::XlLineStyleNone
      columnpos += column.Width
      end ##column
      if PLSQL::View.find(plsql, sheet.name).nil?
         p	 "not exists table #{sheet.name}"
         exit(0)
      end
    @sheetname = sheet.name
    fprnt "###   start ###","w"
    ##crt_prwan_pdf
    @subfields = plsql.__send__(sheet.name).column_names
    chng_tblfield 
    #p @fields
    fprnt "##### /@sum = #{@sum}  /###" 
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
	 rcnt[i[0]] = i[5].to_i if i[1] == 1   ### nil.to_i --> 0
         @max_rcnt = rcnt[i[0]] if @max_rcnt  < (rcnt[i[0]]  ||= 1)  and  (rcnt[i[0]]  ||= 1)  < 900
     end
     #p rcnt
     #p "@fields :#{@fields}"
     tmp_fields = []
     @sortkey = {}
     @pagekey = []
     ##tmp = plsql.USER_TAB_COLUMNS.all("where table_name = '#{@sheetname}'")
     tmp = plsql.r_detailfields.all("where screen_code = '#{@sheetname}'")
     @rtype = {}
     @rscale = {}
     tmp.each do |k|
        ##@rtype[k[:column_name].downcase.to_sym] = k[:data_type] 
        @rtype[k[:detailfield_code].downcase.to_sym] = k[:detailfield_type]
        @rscale[k[:detailfield_code].downcase.to_sym] = k[:detailfield_datascale] if  k[:detailfield_type]  == "NUMBER"
     end
     @sum = []
     @fields.each do |i|
	i = set_i5(i,rcnt)
        tmpcnt = rcnt[i[0]]   ##### 何番目かセット
        tmpcnt =  1 if tmpcnt == 0
        tmp_fields << [tmpcnt,i]  if i[1] != 1
    end  ## @fields.each do |i|
    @fields = tmp_fields
    tmp_box_fields = []
    @box_fields.each do |i|
	i = set_i5(i,rcnt)
        tmpcnt = rcnt[i[0]]
        tmpcnt ||= 1
        tmp_box_fields << [tmpcnt,i]  if i[1] != 1
    end  ##@box_fields.each do |i|
     ## @box_fields.each
    @box_fields = tmp_box_fields
   ##p @box_fields
end
def crt_prwan_org_pdf
    begin
     ## A3:8, A4:9, A5:11
    ##dstart = 770 ### 縦開始位置 A4 縦
    cpaper_s = {"#{ExcelConst::XlPaperA4}".to_i => "A4",
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
    cweight_s = {"#{ExcelConst::XlThin}".to_i => 0.5,
                "#{ExcelConst::XlMedium}".to_i => 2,
                "#{ExcelConst::XlThick}".to_i => 4}
  
    ###サポートしてないタイプは明確に
    #p cpaper_s
    paper_size = cpaper_s[@paper[:size]]
    paper_size ||= "A4"
    orientation = [nil,:portrait,:landscape]
    fill_rectangle_color = @fill_rectangle_color
    fprnt "##### /pdfparam = {:sheetname=>'#{@sheetname}',:page_size =>'#{paper_size}',:page_layout =>:#{orientation[@paper[:orientation]]},:max_rcnt => #{@max_rcnt}}   /#"
    strorderby = ""
    @sortkey.sort.each do |key,value|
	strorderby <<  value + ","
    end
    fprnt "##### /order by #{strorderby.chop}  /#" if @sortkey.size>0
    fprnt "##### /pagekey =  #{@pagekey}  /#" if @pagekey.size>0
    fprnt " dstart = ppdf.cursor"  
    fprnt " if rcnt == 1 then"
    xset_tcolor = ""
    @fill_rectangle_color.each  do |i|   ##最初に持ってこないと罫線等消える。
          fprnt "        ppdf.fill_color '#{set_tcolor(i[6])}'" if set_tcolor(i[6])  !=  xset_tcolor and  set_tcolor(i[6]) != "ffffff"
          fprnt "        ppdf. fill_rectangle [#{i[3]},dstart - #{i[2]}], #{i[4]},#{i[5]}  ##cell(#{i[0]},#{i[1]})" if  set_tcolor(i[6]) != "ffffff"
	  xset_tcolor =  set_tcolor(i[6])
    end 
   xweight_s = 0
   xset_tcolor = ""
   @wline.each do |i|
          fprnt "     end ##stroke"  if  xweight_s != cweight_s[i[6]] and xweight_s != 0
          fprnt "     ppdf.line_width = #{cweight_s[i[6]]}"  if  xweight_s != cweight_s[i[6]]
	  fprnt "     ppdf.stroke do " if  xweight_s != cweight_s[i[6]]
	  fprnt "         ppdf.stroke_color  '#{set_tcolor(i[7])}'" if set_tcolor(i[7])  !=  xset_tcolor
          fprnt "         ppdf.horizontal_line  #{i[3]},#{i[3] + i[4]},:at=>dstart - #{i[2]}  ## cell(#{i[0]},#{i[1]})"
	  xset_tcolor =  set_tcolor(i[7])
          xweight_s = cweight_s[i[6]]
   end
    @hline.each do |i|
	  fprnt "     end ##stroke"  if  xweight_s != cweight_s[i[6]] and xweight_s != 0
	  fprnt "     ppdf.line_width = #{cweight_s[i[6]]}" if  xweight_s != cweight_s[i[6]]
	  fprnt "     ppdf.stroke do " if  xweight_s != cweight_s[i[6]]
	  fprnt "         ppdf.stroke_color  '#{set_tcolor(i[7])}'" if set_tcolor(i[7])  !=  xset_tcolor
          fprnt "         ppdf.vertical_line dstart - #{i[2] + i[4]},dstart - #{i[2]},:at=>#{i[3]} ## cell(#{i[0]},#{i[1]})"   ##i[2] + i[4]  だよ
          xset_tcolor =  set_tcolor(i[7])
          xweight_s = cweight_s[i[6]]
    end  
          fprnt "     end ##stroke"
    fprnt "   end       ##if  rcnt == 1"
     xset_tcolor = ""
     @fields.each do |x|
	   i = x[1]  
	   fprnt  "       ppdf.fill_color '#{set_tcolor (i[8])}'" if xset_tcolor != set_tcolor(i[8])
           fprnt %Q|      ppdf.draw_text  #{set_fields x},:at=>[#{i[3] + 1},dstart - #{i[2] -1} ],:size=>#{i[4]} if rcnt == #{x[0]} ## cell(#{i[0]},#{i[1]})|
	   xset_tcolor = set_tcolor (i[8])
     end
     @box_fields.each do |x|
	   i = x[1] 
	  fprnt  "       ppdf.fill_color '#{set_tcolor (i[8])}'"  if xset_tcolor != set_tcolor(i[8])
	  ###fprnt %Q|      ppdf.text_box  #{ set_fields x },:at=>[#{i[3]} ,dstart - #{i[2]}],:width => #{i[6]} ,:height => #{i[7]},:size=>#{i[4]},:overflow => :shrink_to_fit,:align => #{i[9]} if rcnt == #{x[0]} ## cell(#{i[0]},#{i[1]}) |
	  fprnt %Q|      ppdf.text_box  #{ set_fields x },:at=>[#{i[3]} ,dstart - #{i[2] }],:width => #{i[6]} ,:height => #{i[7]},:size=>#{i[4]},:overflow => :shrink_to_fit,:align => #{i[9]},:valign=>#{i[10]} if rcnt == #{x[0]} ## cell(#{i[0]},#{i[1]}) |
	  xset_tcolor = set_tcolor (i[8])
     end
     rescue => exc
	 ##@books.Close
	 p exc
	 p  $!
         p  $@
	 @books.Close
         exit(0)
    end  ##begin   
end
def crt_prwan_tst_pdf
    begin
    foo = File.open("blk_#{@sheetname}_script.rb","r:UTF-8")
    ##lines = 1
    str = ""
    pdfparam = nil
    @sum = nil
   sqlstr = "where rownum < 100 " 
   while l = foo.gets
	    case
	     when l[0..14] == "##### /pdfparam"
         	eval(l.split("/")[1])  
	     when l[0..14] == "##### /order by"
	        sqlstr << l.split("/")[1] 
	     when l[0..13] == "##### /pagekey"
	   	eval(l.split("/")[1])
	     when l[0..10] == "##### /@sum"
	   	eval(l.split("/")[1])  
	     else
                  str << l
	   end
	  ##lines += 1
     end
    foo.close 
    pagekey ||= []
    ppdf = TestDocument.new({:page_size =>pdfparam[:page_size],:page_layout =>pdfparam[:page_layout]})
    records = plsql.__send__(@sheetname).all(sqlstr)
    rcnt = cnt = 1
    ppdf.font "C:/plsql/v082/vendor/font/ipaexm.ttf"
####test print
    #ppdf.to_pdf record = {},rcnt,{},{} do
    #    eval(str)
    #end
    #ppdf.render_file("test_#{param[:sheetname]}_org.pdf") 
#####
    savebreakvalue = []
    sum998 = {}
    sum999 = {}
    @sum.each do |key|
	sum998[key] = 0
	sum999[key] = 0
    end
    sum998[:blk_reccnt] = 0
    sum999[:blk_reccnt] = 0
    sum998[:blk_pagecnt] = 1
    sum999[:blk_pagecnt] = 1
    records.each do |record|
	  tmpbreakvalue = []
	  record.each_pair do |key,value|
	     record[key] = value.encode('utf-8') if value.class == String
	     ##p  value.encoding if value.class == String
	     tmpbreakvalue << value  if pagekey.index(key)
	     if @sum.index(key) then
	        sum998[key] += value
		sum999[key] += value
	     end
             sum998[:blk_reccnt] += 1
             sum999[:blk_reccnt] += 1
	  end
	  ##p record
	  if savebreakvalue != tmpbreakvalue then
	     if savebreakvalue != []  then ###初回ではない時
		rcnt = 998
		ppdf.to_pdf record,rcnt,sum998,sum999 do
  	             eval(str)
                end
		@sum.each do |key|
                    sum998[key] = 0
	        end
		sum998[:blk_reccnt] = 1
		ppdf.start_new_page if cnt >1
	        ##sum998[:startpage] = ppdf.page_count
		savebreakvalue = tmpbreakvalue
		rcnt = cnt = 1
	     end 
	     ###ページ替えでない時
	      ppdf.to_pdf record,rcnt,sum998,sum999 do
  	        eval(str.encode)
              end
	  end
	  break if cnt > @max_rcnt * 2     ###テスト印刷では3ページ迄
	  ppdf.start_new_page if rcnt == pdfparam[:max_rcnt]
	  cnt += 1
	  rcnt = if cnt.divmod(pdfparam[:max_rcnt])[1]  == 0 then pdfparam[:max_rcnt] else cnt.to_i.divmod(pdfparam[:max_rcnt])[1] end
    end
    rcnt = 999
    ppdf.to_pdf record = {},rcnt,sum998,sum999 do
        eval(str)
    end
    ppdf.render_file("test_#{pdfparam[:sheetname]}_tst.pdf") 
    rescue => exc
	 ##@books.Close
	 p exc
	 p  $!
         p  $@
    end  ##begin   
end  ##crt_prwan_tst_pdf
def fprnt str,aw = "a"
    foo = File.open("blk_#{@sheetname}_script.rb","#{aw}:utf-8") # 書き込みモード
    foo.puts str
    foo.close
end   ##fprnt str
def set_i5 i,rcnt
    chorichar_s = {"#{ExcelConst::XlCenter}".to_i =>":center",
                "#{ExcelConst::XlGeneral}".to_i => nil,
                "#{ExcelConst::XlLeft}".to_i => ":left",
                "#{ExcelConst::XlRight}".to_i => ":right"}
    cvertchar_s = {"#{ExcelConst::XlCenter}".to_i => ":center",
                "#{ExcelConst::XlTop}".to_i => ":top",
                "#{ExcelConst::XlBottom}".to_i => ":bottom"}
    if  i[5] =~ /:/ then
        fieldname = i[5].split(":")[1].split(/\W/)[0].to_sym  ###一つのcellに複数の項目はng
	sortf =  i[5].split(";")[1]
        if @subfields.index(fieldname) or fieldname =~ /^blk_/ then
	     if sortf then
	        if sortf =~ /\d/  or ((sortf[0] == "-"  or sortf[0] == "+"  )and  sortf[1] =~ /\d/)  then
		    @sortkey[ sortf[0] ] =  fieldname.to_s + (if sortf[0] == "-"  then "desc" else "" end)   ### i[5][1] sort順
		   if sortf =~ /#/ then 
                      @pagekey  <<  fieldname
                   end ### "#"
	        end ##  i[5][1] =~ /\d/ 
	     end   ##sortf
	     i[5] = i[5].split(";")[0].gsub(":#{fieldname}","record[:#{fieldname}]") if (rcnt[i[0]] ||= 1 ) < 990  and fieldname !~ /^blk_/
	     i[5] = i[5].gsub(":#{fieldname}","sum998[:blk_pagecnt].to_s") if  fieldname == :blk_pagecnt 
             i[5] = i[5].gsub(":#{fieldname}","sum999[:blk_pagecnt].to_s") if  fieldname == :blk_tpagecnt 
	     i[5] = i[5].gsub(":#{fieldname}","sum998[:blk_reccnt].to_s") if  fieldname == :blk_reccnt 
             i[5] = i[5].gsub(":#{fieldname}","sum999[:blk_reccnt].to_s") if  fieldname == :blk_treccnt 
	     i[5] = i[5].split(";")[0].gsub(":#{fieldname}","sum998[:#{fieldname}]") if (rcnt[i[0]] ||= 1)  == 998
	     i[5] = i[5].split(";")[0].gsub(":#{fieldname}","sum999[:#{fieldname}]") if (rcnt[i[0]] ||= 1)  == 999
             ###i << (i[5][(i[5] =~ /[a-z]/)..-1]).split(",")[1]    ###i[9] 編集 使用中止
             if (@rtype[fieldname] == "DATE" or @rtype[fieldname] =~ /TIMESTAMP/) and i[5] == "record[:#{fieldname}]" then 
	         i[5] = "record[:#{fieldname}].strftime('%Y/%m/%d')"
	     end
	     if  @rtype[fieldname] == "NUMBER" and i[5] == "record[:#{fieldname}]"   then 
		 i[5] = "number_with_precision(record[:#{fieldname}], :precision =>#{@rscale[fieldname]}, :separator => '.', :delimiter => ',')"
	     end
	     if  @rtype[fieldname] == "NUMBER" and i[5] == "sum998[:#{fieldname}]"   then 
		 i[5] = "number_with_precision(sum998[:#{fieldname}], :precision =>#{@rscale[fieldname]}, :separator => '.', :delimiter => ',')"
	     end
	     if  @rtype[fieldname] == "NUMBER" and i[5] == "sum999[:#{fieldname}]"   then 
		 i[5] = "number_with_precision(sum999[:#{fieldname}], :precision =>#{@rscale[fieldname]}, :separator => '.', :delimiter => ',')"
	     end
	     ###  日付の編集　duedate.strftime("%Y/%m/%d")
	     #数の編集　p sprintf("%10.5f", 1)   # => "   1.00000"
	     ##number_with_precision(1111.2345, :precision => 2, :separator => ',', :delimiter => '.')	 
	     @sum <<  fieldname  if @rtype[fieldname] == "NUMBER" and @sum.index(fieldname).nil?
	 end  ##@subfields.index(fieldname) 
      end  ##i[5] =~ /^:/ 
      i[9] = chorichar_s[i[9]]
      i[9] ||=  if @rtype[fieldname] == "NUMBER" then ":right" else  ":left" end  ###i[9] 右詰左詰め
      i[10] = cvertchar_s[i[10]]
      i[10] ||= ":center"
      return i
end
def set_fields x 
    i = x[1]
       i5 = ""
       if i[5] =~ /record\[:/ or i[5] =~ /sum99/ then 
	       i5 = i[5] 
            else
	       if i[5].class == String then
		   i5 = "'" + i[5].encode("utf-8") + "'" 
	         else
	           i5 = i[5].to_s
               end		   
       end
           return i5	
  end
  def set_tcolor tc
    tcolor = "0"*(6 - tc.to_i.to_s(16).size) +  tc.to_i.to_s(16) 
    tcolor = tcolor[4..5] + tcolor[2..3] + tcolor[0..1]
    return tcolor
  end
end
class TestDocument < Prawn::Document
      def to_pdf  record,rcnt,sum998,sum999
	  yield
      end
end
 t = Test.new
 t.blk_set_excel_info ARGV[0]

