require "rubyXL"
def testprint1
  @valuehach = {}
  @rulehacht  = {}
  @rulehachl  = {}
  @rulehachb  = {}
  @rulehachr  = {}
  @rowheight = {}
  @columnwidth = {}
   @maxcolumn = 0
spt = RubyXL::Parser.parse ARGV[0]
   tests = spt[0]
      spt.each do |sh|
         sh.each_with_index do |rowdata,rcount|
	      rowdata.each_with_index do |cell,cellcnt|
		 if cell
                    #@valuehach[(rcount.to_s + "_" + cellcnt.to_s).to_sym]  = cell.value.encode("sjis")  if cell.value
		    ##@rulehach[(rcount.to_s + "_" + cellcnt.to_s).to_sym]  = 1 unless cell.horizontal_alignment == ""
		    @rulehacht[(rcount.to_s + "_" + cellcnt.to_s).to_sym]  = cell.border_top if cell.border_top 
		    @rulehachl[(rcount.to_s + "_" + cellcnt.to_s).to_sym]  = cell.border_left if cell.border_left 
		    @rulehachb[(rcount.to_s + "_" + cellcnt.to_s).to_sym]  = cell.border_bottom if cell.border_bottom 
		    @rulehachr[(rcount.to_s + "_" + cellcnt.to_s).to_sym]  = cell.border_right if cell.border_right 
		    @maxcolumn = cellcnt if  @maxcolumn < cellcnt
		 end 
	      end  ##column
	      @maxrow = rcount
	 end ### rowdata
	 heightvalue = 0.0
	 p @maxrow
	 0.upto(@maxrow) do |i|
	     heightvalue += sh.get_row_height(i) if  sh.get_row_height(i)
	     @rowheight[i] = heightvalue 
	 end
	 widthvalue = 0.0
	 p @maxcolumn
	 0.upto(@maxcolumn) do |j|
	   ##  p "aa #{tests.get_column_width(0)}" 
	   widthvalue +=   tests.get_column_width(j).to_f
	   @columnwidth[j] = widthvalue
	   #  p j
        end ## sheet
      end ##sheet  
  end ##testprint1
testprint1
# p @valuehach
# p @rulehacht
#p @rulehachr
p @rulehachl
p @rowheight
p @columnwidth
