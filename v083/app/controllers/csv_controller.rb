class CsvController < ApplicationController
  before_filter :authenticate_user!  
  def index
      @gridcolumns =  get_show_data(params[:q])[:gridcolumns] 
      @tblname =  sub_blkgetpobj( params[:q] ,"A",sub_blkget_grpcode)
      @screen_code = params[:q] 
  end
  def export
     ##@fields =   plsql.__send__(params[:id]).column_names  ##show_dataのfieldに変更
     gridcolumns =  get_show_data(params[:export][:screen_code])[:gridcolumns] 
     fields = {}
     gridcolumns.each do |i|
	 fields[i[:field].to_sym] = i[:label] if i[:hidden] == false
     end
     fields.delete(:msg_ok_ng)    ####近いうちに  照会・修正の時はとる。　　確認の時のみ
     @alldatas =   plsql.__send__(params[:export][:screen_code]).all
     pkg = Axlsx::Package.new
     pkg.workbook do |wb|
      wb.add_worksheet(:name => 'export') do |ws|   # シート名の指定は省略可
         ws.add_row  fields.values
         @alldatas.each do  |i|
		 rowvalue = []
		 fields.keys.each do |key|
		    rowvalue << i[key.to_sym] if i.key?(key.to_sym)
                 end
		  ws.add_row rowvalue
         end
      end
    end
  send_data(pkg.to_stream.read, 
  :type => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
  :filename => "#{params[:id]}.xlsx")


 end
 def import
     temp = params[:dump][:excel_file].tempfile
     file = File.join("public",params[:dump][:excel_file].original_filename)
     FileUtils.cp temp.path, file
     ##debugger
     spt =  Roo::Excelx.new(file)
     ##debugger
     FileUtils.rm file
     render :text=> "import test"
  end
end
