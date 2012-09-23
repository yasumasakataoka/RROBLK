#! ruby -Ks
# -*- coding: sjis -*-
require 'win32ole'
app = WIN32OLE.new('Excel.Application')
book = app.Workbooks.Open(app.GetOpenFilename)
for row in book.ActiveSheet.UsedRange.Rows do
  #取り出した行から、セルを一つづつ取り出す
  for i in 1..4
    
    p  row.cells(i).value
  end
end
