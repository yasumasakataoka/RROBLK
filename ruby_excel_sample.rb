#! ruby -Ks
# -*- coding: sjis -*-
require 'win32ole'
app = WIN32OLE.new('Excel.Application')
book = app.Workbooks.Open(app.GetOpenFilename)
for row in book.ActiveSheet.UsedRange.Rows do
  #���o�����s����A�Z������Â��o��
  for i in 1..4
    
    p  row.cells(i).value
  end
end
