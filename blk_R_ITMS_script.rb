###   start ###
##### /param = {:sheetname=>'R_ITMS',:page_size =>'A3',:page_layout =>:portrait,:max_rcnt => 8}/  ###
##### /order by itm_remark,itm_code / ###
##### /breakkey =  [:itm_remark] / ###
 dstart = ppdf.cursor
 if rcnt == 1 then
        ppdf.fill_color 'ffffff'
        ppdf. fill_rectangle [0.0,dstart - 274.5], 15.75,13.5  ##cell(13,1)
        ppdf.fill_color 'ffff00'
        ppdf. fill_rectangle [15.75,dstart - 274.5], 732.75,13.5  ##cell(13,2)
        ppdf.fill_color 'ffffff'
        ppdf. fill_rectangle [0.0,dstart - 288.0], 15.75,13.5  ##cell(14,1)
        ppdf.fill_color 'ffff00'
        ppdf. fill_rectangle [15.75,dstart - 288.0], 732.75,13.5  ##cell(14,2)
     ppdf.line_width = 4
     ppdf.stroke do 
         ppdf.stroke_color  '0066cc'
         ppdf.horizontal_line  39.75,165.75,:at=>dstart - 36.75  ## cell(2,4)
     end ##stroke
     ppdf.line_width = 2
     ppdf.stroke do 
         ppdf.stroke_color  '008000'
         ppdf.horizontal_line  496.5,717.0,:at=>dstart - 36.75  ## cell(2,34)
     end ##stroke
     ppdf.line_width = 4
     ppdf.stroke do 
         ppdf.stroke_color  '000000'
         ppdf.horizontal_line  496.5,717.0,:at=>dstart - 218.25  ## cell(8,34)
     end ##stroke
     ppdf.line_width = 0.5
     ppdf.stroke do 
         ppdf.stroke_color  'ff0000'
         ppdf.horizontal_line  15.75,244.5,:at=>dstart - 246.75  ## cell(10,2)
     end ##stroke
     ppdf.line_width = 2
     ppdf.stroke do 
         ppdf.stroke_color  '008000'
         ppdf.horizontal_line  244.5,528.0,:at=>dstart - 246.75  ## cell(10,18)
     end ##stroke
     ppdf.line_width = 0.5
     ppdf.stroke do 
         ppdf.stroke_color  '0066cc'
         ppdf.horizontal_line  528.0,748.5,:at=>dstart - 246.75  ## cell(10,36)
     end ##stroke
     ppdf.line_width = 2
     ppdf.stroke do 
         ppdf.stroke_color  '0066cc'
         ppdf.horizontal_line  15.75,244.5,:at=>dstart - 274.5  ## cell(12,2)
     end ##stroke
     ppdf.line_width = 0.5
     ppdf.stroke do 
         ppdf.stroke_color  'ff0000'
         ppdf.horizontal_line  244.5,528.0,:at=>dstart - 274.5  ## cell(12,18)
     end ##stroke
     ppdf.line_width = 0.5
     ppdf.stroke do 
         ppdf.stroke_color  '000000'
         ppdf.horizontal_line  528.0,748.5,:at=>dstart - 274.5  ## cell(12,36)
     end ##stroke
     ppdf.line_width = 0.5
     ppdf.stroke do 
         ppdf.stroke_color  '000000'
         ppdf.horizontal_line  15.75,748.5,:at=>dstart - 301.5  ## cell(14,2)
     end ##stroke
     ppdf.line_width = 0.5
     ppdf.stroke do 
         ppdf.stroke_color  '000000'
         ppdf.horizontal_line  15.75,244.5,:at=>dstart - 329.25  ## cell(16,2)
     end ##stroke
     ppdf.line_width = 4
     ppdf.stroke do 
         ppdf.stroke_color  '0000ff'
         ppdf.horizontal_line  244.5,528.0,:at=>dstart - 329.25  ## cell(16,18)
     end ##stroke
     ppdf.line_width = 0.5
     ppdf.stroke do 
         ppdf.stroke_color  '000000'
         ppdf.horizontal_line  528.0,748.5,:at=>dstart - 329.25  ## cell(16,36)
     end ##stroke
     ppdf.line_width = 0.5
     ppdf.stroke do 
         ppdf.stroke_color  '000000'
         ppdf.horizontal_line  15.75,748.5,:at=>dstart - 357.0  ## cell(18,2)
     end ##stroke
     ppdf.line_width = 0.5
     ppdf.stroke do 
         ppdf.stroke_color  '000000'
         ppdf.horizontal_line  15.75,748.5,:at=>dstart - 384.0  ## cell(20,2)
     end ##stroke
     ppdf.line_width = 0.5
     ppdf.stroke do 
         ppdf.stroke_color  '000000'
         ppdf.horizontal_line  15.75,748.5,:at=>dstart - 411.0  ## cell(22,2)
     end ##stroke
     ppdf.line_width = 0.5
     ppdf.stroke do 
         ppdf.stroke_color  '000000'
         ppdf.horizontal_line  15.75,748.5,:at=>dstart - 438.0  ## cell(24,2)
     end ##stroke
     ppdf.line_width = 0.5
     ppdf.stroke do 
         ppdf.stroke_color  '000000'
         ppdf.horizontal_line  15.75,748.5,:at=>dstart - 465.0  ## cell(26,2)
     end ##stroke
     ppdf.line_width = 0.5
     ppdf.stroke do 
         ppdf.stroke_color  '000000'
         ppdf.horizontal_line  15.75,748.5,:at=>dstart - 492.0  ## cell(28,2)
     end ##stroke
     ppdf.line_width = 0.5
     ppdf.stroke do 
         ppdf.stroke_color  '000000'
         ppdf.vertical_line dstart - 492.0,dstart - 246.75,:at=>15.75 ## cell(11,2)
     end ##stroke
     ppdf.line_width = 0.5
     ppdf.stroke do 
         ppdf.stroke_color  '333399'
         ppdf.vertical_line dstart - 492.0,dstart - 246.75,:at=>244.5 ## cell(11,18)
     end ##stroke
     ppdf.line_width = 2
     ppdf.stroke do 
         ppdf.stroke_color  '000000'
         ppdf.vertical_line dstart - 218.25,dstart - 36.75,:at=>496.5 ## cell(3,34)
     end ##stroke
     ppdf.line_width = 0.5
     ppdf.stroke do 
         ppdf.stroke_color  '333399'
         ppdf.vertical_line dstart - 492.0,dstart - 246.75,:at=>528.0 ## cell(11,36)
     end ##stroke
     ppdf.line_width = 2
     ppdf.stroke do 
         ppdf.stroke_color  'ff0000'
         ppdf.vertical_line dstart - 218.25,dstart - 36.75,:at=>717.0 ## cell(3,48)
     end ##stroke
     ppdf.line_width = 0.5
     ppdf.stroke do 
         ppdf.stroke_color  '000000'
         ppdf.vertical_line dstart - 492.0,dstart - 246.75,:at=>748.5 ## cell(11,50)
     end ##stroke
   end       ##if  rcnt == 1
       ppdf.fill_color '000000'
      ppdf.draw_text  'す',:at=>[543.75,dstart - 90.5 ],:size=>28.0 if rcnt == 1 ## cell(4,37)
       ppdf.fill_color '000000'
      ppdf.draw_text  '品目コード',:at=>[24.0,dstart - 262.25 ],:size=>11.0 if rcnt == 1 ## cell(11,3)
       ppdf.fill_color '000000'
      ppdf.draw_text  '品名',:at=>[323.25,dstart - 262.25 ],:size=>11.0 if rcnt == 1 ## cell(11,23)
       ppdf.fill_color '000000'
      ppdf.draw_text  '備考',:at=>[528.0,dstart - 262.25 ],:size=>11.0 if rcnt == 1 ## cell(11,36)
       ppdf.fill_color '000000'
      ppdf.draw_text  record[:itm_code],:at=>[15.75,dstart - 290.0 ],:size=>11.0 if rcnt == 1 ## cell(13,2)
       ppdf.fill_color '000000'
      ppdf.draw_text  record[:itm_remark],:at=>[528.0,dstart - 290.0 ],:size=>11.0 if rcnt == 1 ## cell(13,36)
       ppdf.fill_color '000000'
      ppdf.draw_text  record[:itm_code],:at=>[15.75,dstart - 317.0 ],:size=>11.0 if rcnt == 2 ## cell(15,2)
       ppdf.fill_color '000000'
      ppdf.draw_text  record[:itm_remark],:at=>[528.0,dstart - 317.0 ],:size=>11.0 if rcnt == 2 ## cell(15,36)
       ppdf.fill_color '000000'
      ppdf.draw_text  record[:itm_code],:at=>[15.75,dstart - 345.5 ],:size=>11.0 if rcnt == 3 ## cell(17,2)
       ppdf.fill_color '000000'
      ppdf.draw_text  record[:itm_remark],:at=>[528.0,dstart - 345.5 ],:size=>11.0 if rcnt == 3 ## cell(17,36)
       ppdf.fill_color '000000'
      ppdf.draw_text  record[:itm_code],:at=>[15.75,dstart - 372.5 ],:size=>11.0 if rcnt == 4 ## cell(19,2)
       ppdf.fill_color '000000'
      ppdf.draw_text  record[:itm_remark],:at=>[528.0,dstart - 372.5 ],:size=>11.0 if rcnt == 4 ## cell(19,36)
       ppdf.fill_color '000000'
      ppdf.draw_text  record[:itm_code],:at=>[15.75,dstart - 399.5 ],:size=>11.0 if rcnt == 5 ## cell(21,2)
       ppdf.fill_color '000000'
      ppdf.draw_text  record[:itm_remark],:at=>[528.0,dstart - 399.5 ],:size=>11.0 if rcnt == 5 ## cell(21,36)
       ppdf.fill_color '000000'
      ppdf.draw_text  record[:itm_code],:at=>[15.75,dstart - 426.5 ],:size=>11.0 if rcnt == 6 ## cell(23,2)
       ppdf.fill_color '000000'
      ppdf.draw_text  record[:itm_remark],:at=>[528.0,dstart - 426.5 ],:size=>11.0 if rcnt == 6 ## cell(23,36)
       ppdf.fill_color '000000'
      ppdf.draw_text  record[:itm_code],:at=>[15.75,dstart - 453.5 ],:size=>11.0 if rcnt == 7 ## cell(25,2)
       ppdf.fill_color '000000'
      ppdf.draw_text  record[:itm_remark],:at=>[528.0,dstart - 453.5 ],:size=>11.0 if rcnt == 7 ## cell(25,36)
       ppdf.fill_color '000000'
      ppdf.draw_text  record[:itm_code],:at=>[15.75,dstart - 480.5 ],:size=>11.0 if rcnt == 8 ## cell(27,2)
       ppdf.fill_color '000000'
      ppdf.draw_text  record[:itm_remark],:at=>[528.0,dstart - 480.5 ],:size=>11.0 if rcnt == 8 ## cell(27,36)
       ppdf.fill_color '000000'
      ppdf.text_box  record[:itm_name],:at=>[244.5 ,dstart - 274.5],:width => 283.5 ,:height => 27.0,:size=>11.0,:overflow => :shrink_to_fit,:align => :left,:valign=>:top if rcnt == 1 ## cell(13,18) 
       ppdf.fill_color '000000'
      ppdf.text_box  record[:itm_name],:at=>[244.5 ,dstart - 329.25],:width => 283.5 ,:height => 27.75,:size=>11.0,:overflow => :shrink_to_fit,:align => :left,:valign=>:center if rcnt == 3 ## cell(17,18) 
       ppdf.fill_color '000000'
      ppdf.text_box  record[:itm_name],:at=>[244.5 ,dstart - 357.0],:width => 283.5 ,:height => 27.0,:size=>11.0,:overflow => :shrink_to_fit,:align => :left,:valign=>:center if rcnt == 4 ## cell(19,18) 
       ppdf.fill_color '000000'
      ppdf.text_box  record[:itm_name],:at=>[244.5 ,dstart - 384.0],:width => 283.5 ,:height => 27.0,:size=>11.0,:overflow => :shrink_to_fit,:align => :left,:valign=>:center if rcnt == 5 ## cell(21,18) 
       ppdf.fill_color '000000'
      ppdf.text_box  record[:itm_name],:at=>[244.5 ,dstart - 411.0],:width => 283.5 ,:height => 27.0,:size=>11.0,:overflow => :shrink_to_fit,:align => :left,:valign=>:center if rcnt == 6 ## cell(23,18) 
       ppdf.fill_color '000000'
      ppdf.text_box  record[:itm_name],:at=>[244.5 ,dstart - 438.0],:width => 283.5 ,:height => 27.0,:size=>11.0,:overflow => :shrink_to_fit,:align => :left,:valign=>:center if rcnt == 7 ## cell(25,18) 
       ppdf.fill_color '000000'
      ppdf.text_box  record[:itm_name],:at=>[244.5 ,dstart - 465.0],:width => 283.5 ,:height => 27.0,:size=>11.0,:overflow => :shrink_to_fit,:align => :left,:valign=>:center if rcnt == 8 ## cell(27,18) 
