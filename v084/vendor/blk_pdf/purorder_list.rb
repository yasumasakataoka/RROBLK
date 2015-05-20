###   start ###
##### /pdfparam = {:page_size =>'A4',:page_layout =>:landscape,:margin=>[2.792,3.351,0.558,3.351],:max_rcnt => 1}   /#
 dstart = ppdf.cursor
 if rcnt == 1 
     ppdf.line_width = 0.5
     ppdf.stroke do 
         ppdf.stroke_color  '000000'
         ppdf.horizontal_line  69.75,507.0,:at=>dstart - 4.5  ## cell(1,6)
         ppdf.horizontal_line  69.75,507.0,:at=>dstart - 30.0  ## cell(3,6)
         ppdf.horizontal_line  31.5,63.0,:at=>dstart - 55.5  ## cell(5,3)
         ppdf.horizontal_line  69.75,507.0,:at=>dstart - 55.5  ## cell(5,6)
         ppdf.horizontal_line  69.75,507.0,:at=>dstart - 81.0  ## cell(7,6)
         ppdf.horizontal_line  69.75,507.0,:at=>dstart - 106.5  ## cell(9,6)
         ppdf.horizontal_line  227.25,359.25,:at=>dstart - 122.25  ## cell(10,16)
         ppdf.horizontal_line  69.75,507.0,:at=>dstart - 138.0  ## cell(11,6)
         ppdf.horizontal_line  453.75,507.0,:at=>dstart - 147.75  ## cell(12,30)
         ppdf.horizontal_line  69.75,453.75,:at=>dstart - 161.25  ## cell(13,6)
         ppdf.horizontal_line  69.75,507.0,:at=>dstart - 188.25  ## cell(15,6)
         ppdf.horizontal_line  453.75,507.0,:at=>dstart - 198.0  ## cell(16,30)
         ppdf.horizontal_line  258.75,453.75,:at=>dstart - 211.5  ## cell(17,18)
         ppdf.horizontal_line  69.75,507.0,:at=>dstart - 238.5  ## cell(19,6)
         ppdf.horizontal_line  31.5,63.0,:at=>dstart - 251.25  ## cell(20,3)
         ppdf.horizontal_line  69.75,258.75,:at=>dstart - 270.75  ## cell(21,6)
         ppdf.horizontal_line  69.75,507.0,:at=>dstart - 306.75  ## cell(22,6)
         ppdf.horizontal_line  69.75,507.0,:at=>dstart - 332.25  ## cell(24,6)
         ppdf.horizontal_line  31.5,63.0,:at=>dstart - 357.75  ## cell(26,3)
         ppdf.horizontal_line  69.75,507.0,:at=>dstart - 357.75  ## cell(26,6)
         ppdf.horizontal_line  69.75,507.0,:at=>dstart - 383.25  ## cell(28,6)
         ppdf.horizontal_line  69.75,507.0,:at=>dstart - 408.75  ## cell(30,6)
         ppdf.horizontal_line  227.25,359.25,:at=>dstart - 424.5  ## cell(31,16)
         ppdf.horizontal_line  69.75,507.0,:at=>dstart - 440.25  ## cell(32,6)
         ppdf.horizontal_line  453.75,507.0,:at=>dstart - 450.0  ## cell(33,30)
         ppdf.horizontal_line  69.75,453.75,:at=>dstart - 463.5  ## cell(34,6)
         ppdf.horizontal_line  69.75,507.0,:at=>dstart - 490.5  ## cell(36,6)
         ppdf.horizontal_line  453.75,507.0,:at=>dstart - 500.25  ## cell(37,30)
         ppdf.horizontal_line  258.75,453.75,:at=>dstart - 513.75  ## cell(38,18)
         ppdf.horizontal_line  69.75,507.0,:at=>dstart - 540.75  ## cell(40,6)
         ppdf.horizontal_line  31.5,63.0,:at=>dstart - 550.5  ## cell(41,3)
         ppdf.horizontal_line  69.75,258.75,:at=>dstart - 567.0  ## cell(42,6)
         ppdf.vertical_line dstart - 251.25,dstart - 55.5,:at=>31.5 ## cell(6,3)
         ppdf.vertical_line dstart - 550.5,dstart - 357.75,:at=>31.5 ## cell(27,3)
         ppdf.vertical_line dstart - 251.25,dstart - 55.5,:at=>63.0 ## cell(6,5)
         ppdf.vertical_line dstart - 550.5,dstart - 357.75,:at=>63.0 ## cell(27,5)
         ppdf.vertical_line dstart - 238.5,dstart - 4.5,:at=>69.75 ## cell(2,6)
         ppdf.vertical_line dstart - 540.75,dstart - 306.75,:at=>69.75 ## cell(23,6)
         ppdf.vertical_line dstart - 138.0,dstart - 81.0,:at=>148.5 ## cell(8,11)
         ppdf.vertical_line dstart - 440.25,dstart - 383.25,:at=>148.5 ## cell(29,11)
         ppdf.vertical_line dstart - 55.5,dstart - 30.0,:at=>227.25 ## cell(4,16)
         ppdf.vertical_line dstart - 138.0,dstart - 106.5,:at=>227.25 ## cell(10,16)
         ppdf.vertical_line dstart - 357.75,dstart - 332.25,:at=>227.25 ## cell(25,16)
         ppdf.vertical_line dstart - 440.25,dstart - 408.75,:at=>227.25 ## cell(31,16)
         ppdf.vertical_line dstart - 81.0,dstart - 55.5,:at=>258.75 ## cell(6,18)
         ppdf.vertical_line dstart - 238.5,dstart - 138.0,:at=>258.75 ## cell(12,18)
         ppdf.vertical_line dstart - 383.25,dstart - 357.75,:at=>258.75 ## cell(27,18)
         ppdf.vertical_line dstart - 540.75,dstart - 440.25,:at=>258.75 ## cell(33,18)
         ppdf.vertical_line dstart - 55.5,dstart - 4.5,:at=>296.25 ## cell(2,20)
         ppdf.vertical_line dstart - 238.5,dstart - 138.0,:at=>296.25 ## cell(12,20)
         ppdf.vertical_line dstart - 357.75,dstart - 306.75,:at=>296.25 ## cell(23,20)
         ppdf.vertical_line dstart - 540.75,dstart - 440.25,:at=>296.25 ## cell(33,20)
         ppdf.vertical_line dstart - 238.5,dstart - 211.5,:at=>343.5 ## cell(18,23)
         ppdf.vertical_line dstart - 540.75,dstart - 513.75,:at=>343.5 ## cell(39,23)
         ppdf.vertical_line dstart - 138.0,dstart - 106.5,:at=>359.25 ## cell(10,24)
         ppdf.vertical_line dstart - 440.25,dstart - 408.75,:at=>359.25 ## cell(31,24)
         ppdf.vertical_line dstart - 238.5,dstart - 211.5,:at=>390.75 ## cell(18,26)
         ppdf.vertical_line dstart - 540.75,dstart - 513.75,:at=>390.75 ## cell(39,26)
         ppdf.vertical_line dstart - 238.5,dstart - 138.0,:at=>453.75 ## cell(12,30)
         ppdf.vertical_line dstart - 540.75,dstart - 440.25,:at=>453.75 ## cell(33,30)
         ppdf.vertical_line dstart - 138.0,dstart - 106.5,:at=>469.5 ## cell(10,31)
         ppdf.vertical_line dstart - 440.25,dstart - 408.75,:at=>469.5 ## cell(31,31)
         ppdf.vertical_line dstart - 238.5,dstart - 4.5,:at=>507.0 ## cell(2,33)
         ppdf.vertical_line dstart - 540.75,dstart - 306.75,:at=>507.0 ## cell(23,33)
     end ##stroke
   end       ##if  rcnt == 1
       ppdf.fill_color '000000'
      ppdf.draw_text  '発注者',:at=>[70.75,dstart - 13.25 ],:size=>8.0 if rcnt == 1 ## cell(2,6)
      ppdf.draw_text  '納品キー番号',:at=>[297.25,dstart - 13.25 ],:size=>8.0 if rcnt == 1 ## cell(2,20)
      ppdf.draw_text  (record[:loca_name_sect_chrg]||='') ,:at=>[70.75,dstart - 29.0 ],:size=>11.0 if rcnt == 1 ## cell(3,6)
      ppdf.draw_text  (record[:purord_sno]||='') ,:at=>[297.25,dstart - 29.0 ],:size=>11.0 if rcnt == 1 ## cell(3,20)
      ppdf.draw_text  '受渡場所名',:at=>[70.75,dstart - 38.75 ],:size=>8.0 if rcnt == 1 ## cell(4,6)
      ppdf.draw_text  '購買担当',:at=>[228.25,dstart - 38.75 ],:size=>8.0 if rcnt == 1 ## cell(4,16)
      ppdf.draw_text  '注文番号',:at=>[297.25,dstart - 38.75 ],:size=>8.0 if rcnt == 1 ## cell(4,20)
      ppdf.draw_text  '(3N)3'+(record[:purord_sno]||='') +' 001',:at=>[555.25,dstart - 38.75 ],:size=>11.0 if rcnt == 1 ## cell(4,36)
      ppdf.draw_text  (record[:loca_name_to]||='') ,:at=>[70.75,dstart - 54.5 ],:size=>11.0 if rcnt == 1 ## cell(5,6)
      ppdf.draw_text  (record[:person_name_chrg]||='') ,:at=>[228.25,dstart - 54.5 ],:size=>11.0 if rcnt == 1 ## cell(5,16)
      ppdf.draw_text  (record[:purord_sno]||='') ,:at=>[297.25,dstart - 54.5 ],:size=>11.0 if rcnt == 1 ## cell(5,20)
      ppdf.draw_text  '品目コード',:at=>[70.75,dstart - 64.25 ],:size=>8.0 if rcnt == 1 ## cell(6,6)
      ppdf.draw_text  '品名',:at=>[259.75,dstart - 64.25 ],:size=>8.0 if rcnt == 1 ## cell(6,18)
      ppdf.draw_text  (record[:itm_code]||='') ,:at=>[70.75,dstart - 80.0 ],:size=>11.0 if rcnt == 1 ## cell(7,6)
      ppdf.draw_text  (record[:itm_name]||='') ,:at=>[259.75,dstart - 80.0 ],:size=>11.0 if rcnt == 1 ## cell(7,18)
      ppdf.draw_text  '出荷日',:at=>[70.75,dstart - 89.75 ],:size=>8.0 if rcnt == 1 ## cell(8,6)
      ppdf.draw_text  '発注者用備考',:at=>[149.5,dstart - 89.75 ],:size=>8.0 if rcnt == 1 ## cell(8,11)
      ppdf.draw_text  '納期',:at=>[70.75,dstart - 121.25 ],:size=>8.0 if rcnt == 1 ## cell(10,6)
      ppdf.draw_text  '納入(予定)日',:at=>[149.5,dstart - 121.25 ],:size=>8.0 if rcnt == 1 ## cell(10,11)
      ppdf.draw_text  '注文数量',:at=>[228.25,dstart - 121.25 ],:size=>8.0 if rcnt == 1 ## cell(10,16)
      ppdf.draw_text  '納入数量',:at=>[360.25,dstart - 121.25 ],:size=>8.0 if rcnt == 1 ## cell(10,24)
      ppdf.draw_text  '単位',:at=>[470.5,dstart - 121.25 ],:size=>8.0 if rcnt == 1 ## cell(10,31)
      ppdf.draw_text   (if record[:purord_duedate] then record[:purord_duedate].strftime('%Y/%m/%d') else '' end) ,:at=>[70.75,dstart - 137.0 ],:size=>11.0 if rcnt == 1 ## cell(11,6)
      ppdf.draw_text  '納入指示数量',:at=>[228.25,dstart - 137.0 ],:size=>8.0 if rcnt == 1 ## cell(11,16)
      ppdf.draw_text  (record[:unit_name]||='') ,:at=>[470.5,dstart - 137.0 ],:size=>11.0 if rcnt == 1 ## cell(11,31)
      ppdf.draw_text  '受注者用備考',:at=>[70.75,dstart - 146.75 ],:size=>8.0 if rcnt == 1 ## cell(12,6)
      ppdf.draw_text  '受入数量',:at=>[259.75,dstart - 160.25 ],:size=>8.0 if rcnt == 1 ## cell(13,18)
      ppdf.draw_text  '単価',:at=>[70.75,dstart - 173.75 ],:size=>8.0 if rcnt == 1 ## cell(14,6)
      ppdf.draw_text   (if record[:purord_price] then number_with_precision(record[:purord_price], :precision =>4, :separator => '.', :delimiter => ',') else '' end) ,:at=>[118.0,dstart - 173.75 ],:size=>9.0 if rcnt == 1 ## cell(14,9)
      ppdf.draw_text  '税込額',:at=>[165.25,dstart - 173.75 ],:size=>8.0 if rcnt == 1 ## cell(14,12)
      ppdf.draw_text  '検査',:at=>[259.75,dstart - 173.75 ],:size=>8.0 if rcnt == 1 ## cell(14,18)
      ppdf.draw_text  '税額',:at=>[70.75,dstart - 187.25 ],:size=>8.0 if rcnt == 1 ## cell(15,6)
      ppdf.draw_text  '税込額',:at=>[165.25,dstart - 187.25 ],:size=>8.0 if rcnt == 1 ## cell(15,12)
      ppdf.draw_text  '合格数量',:at=>[259.75,dstart - 187.25 ],:size=>8.0 if rcnt == 1 ## cell(15,18)
      ppdf.draw_text  '発注者使用欄',:at=>[70.75,dstart - 197.0 ],:size=>8.0 if rcnt == 1 ## cell(16,6)
      ppdf.draw_text  '不良数量',:at=>[259.75,dstart - 210.5 ],:size=>8.0 if rcnt == 1 ## cell(17,18)
      ppdf.draw_text  '検査区分',:at=>[259.75,dstart - 237.5 ],:size=>8.0 if rcnt == 1 ## cell(19,18)
      ppdf.draw_text  '不合格区分',:at=>[344.5,dstart - 237.5 ],:size=>8.0 if rcnt == 1 ## cell(19,23)
      ppdf.draw_text  '受注者',:at=>[70.75,dstart - 250.25 ],:size=>8.0 if rcnt == 1 ## cell(20,6)
      ppdf.draw_text  '(Z)'+(record[:purord_sno]||='') ,:at=>[297.25,dstart - 250.25 ],:size=>11.0 if rcnt == 1 ## cell(20,20)
      ppdf.draw_text  (record[:loca_name_dealer]||='') ,:at=>[70.75,dstart - 269.75 ],:size=>11.0 if rcnt == 1 ## cell(21,6)
      ppdf.draw_text  '(Z)'+(record[:purord_sno]||='') ,:at=>[297.25,dstart - 269.75 ],:size=>11.0 if rcnt == 1 ## cell(21,20)
      ppdf.draw_text  (record[:loca_code_dealer]||='') ,:at=>[439.0,dstart - 269.75 ],:size=>11.0 if rcnt == 0 ## cell(21,29)
      ppdf.draw_text  '発注者',:at=>[70.75,dstart - 315.5 ],:size=>8.0 if rcnt == 1 ## cell(23,6)
      ppdf.draw_text  '納品キー番号',:at=>[297.25,dstart - 315.5 ],:size=>8.0 if rcnt == 1 ## cell(23,20)
      ppdf.draw_text  (record[:loca_name_sect_chrg]||='') ,:at=>[70.75,dstart - 331.25 ],:size=>11.0 if rcnt == 1 ## cell(24,6)
      ppdf.draw_text  (record[:purord_sno]||='') ,:at=>[297.25,dstart - 331.25 ],:size=>11.0 if rcnt == 1 ## cell(24,20)
      ppdf.draw_text  '受渡場所名',:at=>[70.75,dstart - 341.0 ],:size=>8.0 if rcnt == 1 ## cell(25,6)
      ppdf.draw_text  '購買担当',:at=>[228.25,dstart - 341.0 ],:size=>8.0 if rcnt == 1 ## cell(25,16)
      ppdf.draw_text  '注文番号',:at=>[297.25,dstart - 341.0 ],:size=>8.0 if rcnt == 1 ## cell(25,20)
      ppdf.draw_text  (record[:loca_name_to]||='') ,:at=>[70.75,dstart - 356.75 ],:size=>11.0 if rcnt == 1 ## cell(26,6)
      ppdf.draw_text  (record[:person_name_chrg]||='') ,:at=>[228.25,dstart - 356.75 ],:size=>11.0 if rcnt == 1 ## cell(26,16)
      ppdf.draw_text  (record[:purord_sno]||='') ,:at=>[297.25,dstart - 356.75 ],:size=>11.0 if rcnt == 1 ## cell(26,20)
      ppdf.draw_text  '品目コード',:at=>[70.75,dstart - 366.5 ],:size=>8.0 if rcnt == 1 ## cell(27,6)
      ppdf.draw_text  '品名',:at=>[259.75,dstart - 366.5 ],:size=>8.0 if rcnt == 1 ## cell(27,18)
      ppdf.draw_text  (record[:itm_code]||='') ,:at=>[70.75,dstart - 382.25 ],:size=>11.0 if rcnt == 1 ## cell(28,6)
      ppdf.draw_text  (record[:itm_name]||='') ,:at=>[259.75,dstart - 382.25 ],:size=>11.0 if rcnt == 1 ## cell(28,18)
      ppdf.draw_text  '出荷日',:at=>[70.75,dstart - 392.0 ],:size=>8.0 if rcnt == 1 ## cell(29,6)
      ppdf.draw_text  '発注者用備考',:at=>[149.5,dstart - 392.0 ],:size=>8.0 if rcnt == 1 ## cell(29,11)
      ppdf.draw_text  '納期',:at=>[70.75,dstart - 423.5 ],:size=>8.0 if rcnt == 1 ## cell(31,6)
      ppdf.draw_text  '納入(予定)日',:at=>[149.5,dstart - 423.5 ],:size=>8.0 if rcnt == 1 ## cell(31,11)
      ppdf.draw_text  '注文数量',:at=>[228.25,dstart - 423.5 ],:size=>8.0 if rcnt == 1 ## cell(31,16)
      ppdf.draw_text  '納入数量',:at=>[360.25,dstart - 423.5 ],:size=>8.0 if rcnt == 1 ## cell(31,24)
      ppdf.draw_text  '単位',:at=>[470.5,dstart - 423.5 ],:size=>8.0 if rcnt == 1 ## cell(31,31)
      ppdf.draw_text   (if record[:purord_duedate] then record[:purord_duedate].strftime('%Y/%m/%d') else '' end) ,:at=>[70.75,dstart - 439.25 ],:size=>11.0 if rcnt == 1 ## cell(32,6)
      ppdf.draw_text  '納入指示数量',:at=>[228.25,dstart - 439.25 ],:size=>8.0 if rcnt == 1 ## cell(32,16)
      ppdf.draw_text  (record[:unit_name]||='') ,:at=>[470.5,dstart - 439.25 ],:size=>11.0 if rcnt == 1 ## cell(32,31)
      ppdf.draw_text  '受注者用備考',:at=>[70.75,dstart - 449.0 ],:size=>8.0 if rcnt == 1 ## cell(33,6)
      ppdf.draw_text  '受入数量',:at=>[259.75,dstart - 462.5 ],:size=>8.0 if rcnt == 1 ## cell(34,18)
      ppdf.draw_text  '単価',:at=>[70.75,dstart - 476.0 ],:size=>8.0 if rcnt == 1 ## cell(35,6)
      ppdf.draw_text   (if record[:purord_price] then number_with_precision(record[:purord_price], :precision =>4, :separator => '.', :delimiter => ',') else '' end) ,:at=>[118.0,dstart - 476.0 ],:size=>9.0 if rcnt == 1 ## cell(35,9)
      ppdf.draw_text  '税込額',:at=>[165.25,dstart - 476.0 ],:size=>8.0 if rcnt == 1 ## cell(35,12)
      ppdf.draw_text  '検査',:at=>[259.75,dstart - 476.0 ],:size=>8.0 if rcnt == 1 ## cell(35,18)
      ppdf.draw_text  '税額',:at=>[70.75,dstart - 489.5 ],:size=>8.0 if rcnt == 1 ## cell(36,6)
      ppdf.draw_text  '税込額',:at=>[165.25,dstart - 489.5 ],:size=>8.0 if rcnt == 1 ## cell(36,12)
      ppdf.draw_text  '合格数量',:at=>[259.75,dstart - 489.5 ],:size=>8.0 if rcnt == 1 ## cell(36,18)
      ppdf.draw_text  '発注者使用欄',:at=>[70.75,dstart - 499.25 ],:size=>8.0 if rcnt == 1 ## cell(37,6)
      ppdf.draw_text  '不良数量',:at=>[259.75,dstart - 512.75 ],:size=>8.0 if rcnt == 1 ## cell(38,18)
      ppdf.draw_text  '検査区分',:at=>[259.75,dstart - 539.75 ],:size=>8.0 if rcnt == 1 ## cell(40,18)
      ppdf.draw_text  '不合格区分',:at=>[344.5,dstart - 539.75 ],:size=>8.0 if rcnt == 1 ## cell(40,23)
      ppdf.draw_text  '受注者',:at=>[70.75,dstart - 549.5 ],:size=>8.0 if rcnt == 1 ## cell(41,6)
      ppdf.draw_text  (record[:loca_name_dealer]||='') ,:at=>[70.75,dstart - 566.0 ],:size=>11.0 if rcnt == 1 ## cell(42,6)
 ppdf.bounding_box [554.25 ,dstart - 39.75- 25.5] , :width =>  204.75 do 
	                        barcode = Barby::Code39.new('3N3'+(record[:purord_sno]||='') +' 001')
                            barcode.annotate_pdf(ppdf, :height => 25.5)
                        end if rcnt == 1 ## cell(5,36) 
      ppdf.text_box  '納',:at=>[31.5 ,dstart - 55.5],:width => 31.5 ,:height => 25.5,
				                                      :size=>14.0,:overflow => :shrink_to_fit,:align => :center,
													  :valign=>:center if rcnt == 1 ## cell(6,3) 
      ppdf.text_box  '品',:at=>[31.5 ,dstart - 81.0],:width => 31.5 ,:height => 25.5,
				                                      :size=>14.0,:overflow => :shrink_to_fit,:align => :center,
													  :valign=>:center if rcnt == 1 ## cell(8,3) 
      ppdf.text_box  '書',:at=>[31.5 ,dstart - 106.5],:width => 31.5 ,:height => 31.5,
				                                      :size=>14.0,:overflow => :shrink_to_fit,:align => :center,
													  :valign=>:center if rcnt == 1 ## cell(10,3) 
       ppdf.fill_color '0070c0'
      ppdf.text_box   (if record[:purord_qty] then number_with_precision(record[:purord_qty], :precision =>2, :separator => '.', :delimiter => ',') else '' end) ,:at=>[296.25 ,dstart - 106.5],:width => 63.0 ,:height => 15.75,
				                                      :size=>11.0,:overflow => :shrink_to_fit,:align => :right,
													  :valign=>:center if rcnt == 1 ## cell(10,20) 
      ppdf.text_box   (if record[:purord_qty] then number_with_precision(record[:purord_qty], :precision =>2, :separator => '.', :delimiter => ',') else '' end) ,:at=>[296.25 ,dstart - 122.25],:width => 63.0 ,:height => 15.75,
				                                      :size=>11.0,:overflow => :shrink_to_fit,:align => :right,
													  :valign=>:center if rcnt == 1 ## cell(11,20) 
       ppdf.fill_color '000000'
      ppdf.text_box  '兼',:at=>[31.5 ,dstart - 138.0],:width => 31.5 ,:height => 23.25,
				                                      :size=>14.0,:overflow => :shrink_to_fit,:align => :center,
													  :valign=>:center if rcnt == 1 ## cell(12,3) 
       ppdf.fill_color '0070c0'
      ppdf.text_box  '検　　査',:at=>[453.75 ,dstart - 138.0],:width => 53.25 ,:height => 9.75,
				                                      :size=>8.0,:overflow => :shrink_to_fit,:align => :center,
													  :valign=>:center if rcnt == 1 ## cell(12,30) 
       ppdf.fill_color '000000'
      ppdf.text_box  '検',:at=>[31.5 ,dstart - 161.25],:width => 31.5 ,:height => 27.0,
				                                      :size=>14.0,:overflow => :shrink_to_fit,:align => :center,
													  :valign=>:center if rcnt == 1 ## cell(14,3) 
      ppdf.text_box  '査',:at=>[31.5 ,dstart - 188.25],:width => 31.5 ,:height => 23.25,
				                                      :size=>14.0,:overflow => :shrink_to_fit,:align => :center,
													  :valign=>:center if rcnt == 1 ## cell(16,3) 
       ppdf.fill_color '0070c0'
      ppdf.text_box  '受　　入',:at=>[453.75 ,dstart - 188.25],:width => 53.25 ,:height => 9.75,
				                                      :size=>8.0,:overflow => :shrink_to_fit,:align => :center,
													  :valign=>:center if rcnt == 1 ## cell(16,30) 
       ppdf.fill_color '000000'
      ppdf.text_box  '表',:at=>[31.5 ,dstart - 211.5],:width => 31.5 ,:height => 27.0,
				                                      :size=>14.0,:overflow => :shrink_to_fit,:align => :center,
													  :valign=>:center if rcnt == 1 ## cell(18,3) 
      ppdf.text_box  '納',:at=>[31.5 ,dstart - 357.75],:width => 31.5 ,:height => 25.5,
				                                      :size=>14.0,:overflow => :shrink_to_fit,:align => :center,
													  :valign=>:center if rcnt == 1 ## cell(27,3) 
      ppdf.text_box  '品',:at=>[31.5 ,dstart - 383.25],:width => 31.5 ,:height => 25.5,
				                                      :size=>14.0,:overflow => :shrink_to_fit,:align => :center,
													  :valign=>:center if rcnt == 1 ## cell(29,3) 
      ppdf.text_box  '書',:at=>[31.5 ,dstart - 408.75],:width => 31.5 ,:height => 31.5,
				                                      :size=>14.0,:overflow => :shrink_to_fit,:align => :center,
													  :valign=>:center if rcnt == 1 ## cell(31,3) 
       ppdf.fill_color '0070c0'
      ppdf.text_box   (if record[:purord_qty] then number_with_precision(record[:purord_qty], :precision =>2, :separator => '.', :delimiter => ',') else '' end) ,:at=>[296.25 ,dstart - 408.75],:width => 63.0 ,:height => 15.75,
				                                      :size=>11.0,:overflow => :shrink_to_fit,:align => :right,
													  :valign=>:center if rcnt == 1 ## cell(31,20) 
      ppdf.text_box   (if record[:purord_qty] then number_with_precision(record[:purord_qty], :precision =>2, :separator => '.', :delimiter => ',') else '' end) ,:at=>[296.25 ,dstart - 424.5],:width => 63.0 ,:height => 15.75,
				                                      :size=>11.0,:overflow => :shrink_to_fit,:align => :right,
													  :valign=>:center if rcnt == 1 ## cell(32,20) 
       ppdf.fill_color '000000'
      ppdf.text_box  '兼',:at=>[31.5 ,dstart - 440.25],:width => 31.5 ,:height => 23.25,
				                                      :size=>14.0,:overflow => :shrink_to_fit,:align => :center,
													  :valign=>:center if rcnt == 1 ## cell(33,3) 
       ppdf.fill_color '0070c0'
      ppdf.text_box  '検　　査',:at=>[453.75 ,dstart - 440.25],:width => 53.25 ,:height => 9.75,
				                                      :overflow => :shrink_to_fit,:align => :center,
													  :valign=>:center if rcnt == 1 ## cell(33,30) 
       ppdf.fill_color '000000'
      ppdf.text_box  '検',:at=>[31.5 ,dstart - 463.5],:width => 31.5 ,:height => 27.0,
				                                      :size=>14.0,:overflow => :shrink_to_fit,:align => :center,
													  :valign=>:center if rcnt == 1 ## cell(35,3) 
      ppdf.text_box  '査',:at=>[31.5 ,dstart - 490.5],:width => 31.5 ,:height => 23.25,
				                                      :size=>14.0,:overflow => :shrink_to_fit,:align => :center,
													  :valign=>:center if rcnt == 1 ## cell(37,3) 
       ppdf.fill_color '0070c0'
      ppdf.text_box  '受　　入',:at=>[453.75 ,dstart - 490.5],:width => 53.25 ,:height => 9.75,
				                                      :size=>8.0,:overflow => :shrink_to_fit,:align => :center,
													  :valign=>:center if rcnt == 1 ## cell(37,30) 
       ppdf.fill_color '000000'
      ppdf.text_box  '表',:at=>[31.5 ,dstart - 513.75],:width => 31.5 ,:height => 27.0,
				                                      :size=>14.0,:overflow => :shrink_to_fit,:align => :center,
													  :valign=>:center if rcnt == 1 ## cell(39,3) 
##### /@sum = [:purord_price, :purord_qty]  /###
##### /order by loca_code_dealer,itm_code,purord_duedate  /#
