require 'win32ole'
require "rubygems"
require 'time'
require "ruby-plsql"
class Blklist
def initialize filename
plsql.connection = OCI8.new("rails","rails","xe")
app = WIN32OLE.new('Excel.Application')
@book = app.Workbooks.Open(app.filename)
@lists = {}   ##���[���@�g�pview �c���@�㉺���E�̃}�[�W��
@listruleskines = {}
@listdrows = {}
class Excel
end
WIN32OLE.const_load(app, Excel)
@edge       =  [Excel::XlEdgeLeft,Excel::XlEdgeTop ,Excel::XlEdgeBottom ,Excel::XlEdgeRight]  ##[7,8,9,10] 
end  ##def initialize
def main_list
    @book.Worksheets.each do |ersheet|
    @lists[:code] = [ersheet.Name.split(/@/)[0]]
    @lists[:code] << {:viewname => ersheet.Name.split(/@/)[1]||ersheet.Name.split(/@/)[0]}
    @lists[:code] << {:excelpapersize => ersheet.PageSetup.PaperSize} 
    @lists[:code] << {:landscape =>   if ersheet.PageSetup.Orientation == "xlLandscape" then 1 else 0 end}
    @lists[:code] << {:topmargin => ersheet.PageSetup.TopMargin} 
    @lists[:code] << {:bottommargin => ersheet.PageSetup.BottomMargin} 
    @lists[:code] << {:leftMargin => ersheet.PageSetup.LeftMargin} 
    @lists[:code] << {:rightmargin => ersheet.PageSetup.RightMargin}
    columnwidth = 0
    rowheight = 0
    @tmplistcolums = {}
    ersheet.UsedRange.Rows.each do |row|
	 symrow = row.row.to_sym
	 @tmplistcolums[symrow] = {}
         row.CoLumns.each do |cell|
		#���o�����s����A�Z������Â��o��
	    symcell = cell.Column.to_sym
            @tmplistcolums[symrow][symcell] = {}	
            unless  cell.Value.nil?
		@tmplistcolums[symrow][symcell][:value] =  cell.Value
                @tmplistcolums[symrow][symcell][:excelfontname] =  cell.Font.Name
		@tmplistcolums[symrow][symcell][:fontsize] =  cell.Font.Size
                @tmplistcolums[symrow][symcell][:fontBlod] =   if cell.Font.Bold == True   then 1 else 0 end
            end
	    @edge.each do |edge|   ### ghost�p�ɕϊ��v�@�㉺�@���E���_�u���Ă���
	        unless cell.Borders.Item(edge).LineStyle = "Excel::XlLineStyleNone"
		    symedge = edge.to_sym
                    @tmplistcolums[symrow][symcell][symedge]  ={}
	            @tmplistcolums[symrow][symcell][symedge][:linestyle] =  cell.Borders.LineStyle
	            @tmplistcolums[symrow][symcell][symedge][:weight] =  cell.Borders.Weight
	        end  ## UsedRange.CoLumns
           end		
		columnwidth += cell.ColumnWidth
        columnwidth = 0
	 end ##cell
    end  ## UsedRange.Rows
  end   ###sheet
end ## main_list
end  ##  Blklist

