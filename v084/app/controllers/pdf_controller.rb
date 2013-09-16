class PdfController < ApplicationController
##page 対応
##合計
##新規　変更
before_filter :authenticate_user!  
include ActionView::Helpers::NumberHelper
class PdfReport < Prawn::Document
  def to_pdf 
    yield
    render
  end
end
def index
      pdfparam = {}
      pagekey = []   ###定義してないとevalで消える
      if params[:pdflist]
         pdfscript = plsql.reports.first("where tCode = '#{params[:pdflist]}' and  Expiredate > sysdate")
	 if pdfscript
	    f = File.open(".#{pdfscript[:filename]}", "r:UTF-8")
	    if f
               str = ""###prawn ruby coding
               pdfparam = nil     
	       @sum = nil
               sqlstr = "" 
	       @command_r = {}
               command_r
	      while l = f.gets
               case
	         when l[0..14] == "##### /pdfparam"
                     eval(l.split("/")[1])  
		      get_pdfscreen_code  ###gridの選択項目をセットするため
		      sqlstr = sub_pdfwhere(pdfparam[:sheetname],pdfscript[:id],command_r)

	         when l[0..14] == "##### /order by"
	             sqlstr << l.split("/")[1]    
	         when l[0..13] == "##### /pagekey"
	            eval(l.split("/")[1])    
	         when l[0..10] == "##### /@sum"
	            eval(l.split("/")[1])  
	        else
                    str << l
	      end  ##case
	      end  ##while
              f.close 
	    end  ## f
	   filename = "#{pdfparam[:sheetname]}_#{current_user[:id].to_s}.pdf"
	   ppdf = PdfReport.new({:page_size =>pdfparam[:page_size],:page_layout =>pdfparam[:page_layout]})
	   ppdf.font "./vendor/font/ipaexm.ttf"
	   p "strsql #{sqlstr}"
           records = plsql.__send__(pdfparam[:sheetname]).all(sqlstr)  
	   output = ppdf.to_pdf do
	       rcnt = cnt = 1
               savebreakvalue = []
               sum998 = {}
               sum999 = {}
               @sum.each do |key|
                    sum999[key] = 0
               end
               sum999[:blk_reccnt] = 0
               sum999[:blk_pagecnt] = 0
               records.each do |record|
		  tmpbreakvalue = []
		  record.each_pair do |key,value|
	             record[key] = value.encode('utf-8') if value.class == String
	             tmpbreakvalue << value  if pagekey.index(key)
		  end
	          if savebreakvalue != tmpbreakvalue then
	             rcnt = 998
		     p sum998 if  savebreakvalue != []
		     eval(str) if  savebreakvalue != []
		     @sum.each do |key|
                         sum998[key] = 0
	             end
	             sum998[:blk_pagecnt] = 1 
		     sum999[:blk_pagecnt] += 1 
		     sum998[:blk_reccnt] = 0
		     ppdf.start_new_page  if  savebreakvalue != []
	             savebreakvalue = tmpbreakvalue
		     rcnt = cnt = 1
		  end                        ###ページ替えでない時
		  record.each_pair do |key,value|
	             if @sum.index(key) then
	                sum998[key] += value
	                sum999[key] += value
	             end
		  end
		  sum998[:blk_reccnt] += 1
                  sum999[:blk_reccnt] += 1
	          eval(str)
                  insert_hisofrprts pdfparam[:sheetname],record,pdfscript[:id]
	          ##ppdf.text " " if rcnt == pdfparam[:max_rcnt] ###TypeError (can't dup NilClass):  対策
	          if rcnt == pdfparam[:max_rcnt] then
		     ppdf.start_new_page 
                     sum998[:blk_pagecnt] += 1 
                     sum999[:blk_pagecnt] += 1 
                  end
                  cnt += 1
	          rcnt = if cnt.divmod(pdfparam[:max_rcnt])[1]  == 0 then pdfparam[:max_rcnt] else cnt.divmod(pdfparam[:max_rcnt])[1]  end
	       end ##record
	unless records.empty?
               rcnt = 998
               eval(str)
               rcnt = 999
               eval(str)
	end
      end ## to_pdf	   
      @text = ""
      ##   ppdf.render_file(filename)
  #  respond_to do |format|
  #     format.pdf {
  #      send_data output,:filename => "test.pdf",:type => "application/pdf"
  #      }
        send_data output,:filename => "#{pdfparam[:sheetname]}_#{current_user[:id].to_s}_#{Time.now.strftime("%y%m%d%H%M%S")}.pdf",:type => "application/pdf" 	unless records.empty?
        @text = " no record     --->click   here  close the window "
	render :action=>"index" and return if records.empty?
  #      format.html {
 #       render :text => "<h1>Use .pdf</h1>".html_safe
 #     }
 #  end  ##repond
   end  #pdfscript
   @text = " missing pdf scrit --->click   here  close the window "
   render :action=>"index" and return  unless  pdfscript
  end ##pdfscript
    @text = " pdf param missing      --->click   here  close the window "
   render :action=>"index" and return  unless params[:pdflist]
  end	##index
  def  insert_hisofrprts sheetname,record,reportid
	rec = {}
	rec[:id] = plsql.hisofrprts_seq.nextval
	rec[:tblname] = sheetname
	rec[:recordid] = record[:id]
	rec[:reports_id] = reportid
	rec[:issuedate] = Time.now
	rec[:expiredate] = Date.strptime("2099/12/31", "%Y/%m/%d")
	rec[:persons_id_upd] =  plsql.persons.first(:email =>current_user[:email])[:id]
	rec[:update_ip] = request.remote_ip
	rec[:created_at] = Time.now
	rec[:updated_at] = Time.now
	plsql.hisofrprts.insert rec
   end
   def command_r
      @command_r
   end
   def screen_code
      @screen_code
   end
   def show_data
      @show_data
   end
   def get_pdfscreen_code 
       @screen_code =  params[:q].to_s.upcase 
       screen_code
       @show_data = get_show_data(screen_code )
       show_data
   end
end  ###class
