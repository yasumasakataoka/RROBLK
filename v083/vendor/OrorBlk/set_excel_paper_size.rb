# -*- coding: utf-8 -*-
################ -*- coding: utf-8 -*-
require 'win32ole'
class  ExcelConst
end
class  Test
def blk_set_excel_paper_size infile
 app = WIN32OLE.new('Excel.Application')
 WIN32OLE.const_load(app, ExcelConst)
 @books = app.Workbooks.Open(infile)
 sheet = @books.Worksheets.Item(1)
 @books.Worksheets.each do |sheet|
 sheet.UsedRange.Rows.each do |row|
      next if row.Columns(1).value !~ /^x/
      next if  row.Columns(7).value.nil?
      xpaper = row.Columns(1).value.split(".")[0]
      fprnt  %Q|"\#{ExcelConst::#{xpaper[0].upcase + xpaper[1..-1] }}".to_i => "#{row.Columns(7).value}",|
  end ##row
 end  #sheeet
 @books.Close
end ## blk_set_excel_paper_size 
def fprnt str,aw = "a"
    foo = File.open("blk_#{@sheetname}_paper_size.txt","#{aw}:utf-8") # 書き込みモード
    foo.puts str
    foo.close
end   ##fprnt str
end ##class
 t = Test.new
 t.blk_set_excel_paper_size ARGV[0]

