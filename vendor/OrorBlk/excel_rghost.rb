class Blklist
def initialize filename
#! ruby -Ks
# -*- coding: sjis -*-
require 'win32ole'
require "rubygems"
require 'time'
require "ruby-plsql"
plsql.connection = OCI8.new("rails","rails","xe")
app = WIN32OLE.new('Excel.Application')
@book = app.Workbooks.Open(app.filename)
@lists = {}
@listcolums = {}
@listruleskines = {}
@listdrows = {}
end  ##def initialize
def main_list
    @book.Worksheets.each do |ersheet|
    @lists[:code] = ersheet.Name.split(/@/)[0]
    @lists[:viewname] = ersheet.Name.split(/@/)[1]||ersheet.Name.split(/@/)[0]
    @lists[:excelpapersize] = ersheet.PageSetup.PaperSize 
    @lists[:landscape] =   if ersheet.PageSetup.Orientation == "xlLandscape" then 1 else 0 end
    @lists[:topmargin] = ersheet.PageSetup.TopMargin 
    @lists[:bottommargin] = ersheet.PageSetup.BottomMargin 
    @lists[:leftMargin] = ersheet.PageSetup.LeftMargin 
    @lists[:rightmargin] = ersheet.PageSetup.RightMargin
    columnwidth = 0
    rowheight = 0
    ersheet.UsedRange.Rows.each do |row|
        row.CoLumns.each do |cell|
        #取り出した行から、セルを一つづつ取り出す
            unless  cell.Value.nil?
                @listcolums[@lists[:code],:code] =  cell.Value
                @listcolums[@lists[:code],:excelfontname] =  cell.Font.Name
                @listcolums[@lists[:code],:fontsize] =  cell.Font.Size
                @listcolums[@lists[:code],:fontBlod] =   if cell.Font.Bold == True   then 1 else 0 end
            end 
            columnwidth += cell.ColumnWidth
        end  ## UsedRange.CoLumns
        columnwidth = 0
    end  ## UsedRange.Rows
end ## main_list
end  ##  Blklist

