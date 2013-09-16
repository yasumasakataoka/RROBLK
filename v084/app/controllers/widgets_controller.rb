class WidgetsController < ApplicationController
  class TestDocument < Prawn::Document
      def to_pdf 
	  yield
          render 
      end
  end

  def index
    ppdf = TestDocument.new
    output = ppdf.to_pdf do
	p_cnt = 0
	save_cursor = ppdf.cursor
	for i in 1..50
           ppdf.text ppdf.page_count.to_s if save_cursor <= ppdf.cursor
	   ppdf.text "#{i.to_s} yyyyyyyyyyyyyy"
	   ppdf.move_down 20
	end
    end
    send_data output, :filename => "hello.pdf", :type => "application/pdf"
    ### ng   send_data "R_CUSTORDS_10001.pdf", :filename => "R_CUSTORDS_10001.pdf", :type => "application/pdf"
  end
end
