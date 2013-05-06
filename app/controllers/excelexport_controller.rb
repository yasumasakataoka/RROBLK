class ExcelexportController < ApplicationController
  before_filter :authenticate_user!  
  def index
      @gridcolumns =  get_show_data(params[:q])[:gridcolumns] 
      @tblname =  sub_blkgetpobj( params[:q] ,"A",sub_blkget_grpcode)
      @screen_code = params[:q] 
  end
  def export
     ##@fields =   plsql.__send__(params[:id]).column_names  ##show_data��field�ɕύX
     gridcolumns =  get_show_data(params[:export][:screen_code])[:gridcolumns] 
     fields = {}
     gridcolumns.each do |i|
	 fields[i[:field].to_sym] = i[:label] if i[:hidden] == false
     end
     fields.delete(:msg_ok_ng)    ####�߂�������  �Ɖ�E�C���̎��͂Ƃ�B�@�@�m�F�̎��̂�
     @alldatas =   plsql.__send__(params[:export][:screen_code]).all
     pkg = Axlsx::Package.new
     pkg.workbook do |wb|
      wb.add_worksheet(:name => 'export') do |ws|   # �V�[�g���̎w��͏ȗ���
      ### column���ɕ����A���ʁA���t�̎w�������B
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
end
