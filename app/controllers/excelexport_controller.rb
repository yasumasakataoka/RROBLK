class ExcelexportController < ApplicationController
  before_filter :authenticate_user!  
  def index
      @gridcolumns =  get_show_data(params[:q])[:gridcolumns] 
      @tblname =  sub_blkgetpobj( params[:q] ,"A",sub_blkget_grpcode)
      @screen_code = params[:q] 
  end
  def export
     ##@fields =   plsql.__send__(params[:id]).column_names  ##show_dataのfieldに変更
	  #該当データなしの時処理　
     @screen_code = params[:export][:exportscreen_code]
     screen_code 
     @show_data = get_show_data screen_code
     show_data
     @xparams = {}
     params[:export].each do |i,j|   ###jqgridと入力無の時の送られるデータがことなる。 jqgrid field nothing  rails fieldx= ""
	@xparams[i] = j if j != ""
     end
     xparams
     set_fields_from_params 
     ##debugger
     fields = {}
     col_type =[]
     show_data[:gridcolumns].each do |i|
       if  i[:hidden] == false and i[:editrules]              ### omit :msg_ok_ng
	   fields[i[:field].to_sym] = i[:label] 
	   tmpcol_type = nil
	   tmpcol_type = "input" if i[:editable] == true
	   tmpcol_type = "indisp" if i[:editrules][:required]  == true
	   tmpcol_type = "key" if show_data[:keysfield].index(i[:field])
	   col_type << tmpcol_type 
       end
     end
    command_r[:sio_start_record] =  1
    command_r[:sio_end_record] =  params[:export][:maxcount].to_i 
    command_r[:sio_sord] = params[:sord]  
    command_r[:sio_sidx]  = params[:sidx]
    command_r[:sio_session_id] = "export"

    command_r[:sio_classname] = "plsql_blk_export"
    @alldatas = []
    ##debugger
    subpaging  command_r  do   	  |tmp_data|    ## subpaging 
	 @alldatas << tmp_data 
    end 
     fields.delete(:msg_ok_ng)    ####近いうちに  照会・修正の時はとる。　　確認の時のみ
     ##@alldatas =   plsql.__send__(params[:export][:screen_code]).all
     pkg = Axlsx::Package.new
     pkg.workbook do |wb|
      wb.add_worksheet(:name => 'export') do |ws|   # シート名の指定は省略可
	      ### column毎に文字、数量、日付の指定をする。
	 key_color = ws.styles.add_style  :bg_color => 'FF0000'
	 indisp_color = ws.styles.add_style  :bg_color => 'FF8C00'
	 input_color = ws.styles.add_style  :bg_color => '00FF00'
	 fcolors = []
         col_type.each do  |j|
	   fcolors <<  key_color if j == "key"
	   fcolors <<  indisp_color if j == "indisp"
	   fcolors <<  input_color if j == "input"
	   fcolors <<  nil if j.nil?
         end
         ws.add_row  fields.values,:style =>fcolors
	 ##debugger
         @alldatas.each do  |i|
		 rowvalue = []
		 fields.keys.each do |key|
		    rowvalue << i[key.to_sym] if i.key?(key.to_sym)
                 end
		  ws.add_row rowvalue,:style =>fcolors
         end
         ##debugger
      end
     end
  send_data(pkg.to_stream.read, 
  :type => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
  :filename => "#{params[:id]}.xlsx")


 end
 def set_fields_from_params ###画面の内容をcommand_r
     @command_r = {}
     command_r
     if show_data.empty? 
        render :text => "Create DetailFields #{screen_code} by (crt_r_view_sql.rb  #{screen_code.split(/_/)[1]}) and restart rails "  and return
     end
     command_r[:sio_search]  = "false"
     show_data[:allfields].each do |j|
        command_r[j] = params[:export][j]  ##     
	command_r[:sio_search]  = "true" if command_r[j]
     end ##
 end  
 def command_r
     @command_r
 end
 def show_data
     @show_data
 end
 def screen_code
     @screen_code
 end
 def xparams
     @xparams
 end

end
