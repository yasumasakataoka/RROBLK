class ListController < ApplicationController
before_filter :authenticate_user!  
## 全ユーザ共通
## グループ対応は必要
## 1 session 1 user が必須　今 no chk 
  def index
       ##debugger  ##debugger  の位置を変更するとエラーになる。???
	grpcode = sub_blkget_grpcode 
       if grpcode  then
	       crtcachelist(grpcode)
         else 
	       render :text => "add persons to your email "  and return 
       end
  end
  def crtcachelist grpcode
 ##          debugger # breakpoint
      if   Rails.cache.exit?("listindex" + grpcode) then
           @vlist = Rails.cache.read("listindex" + grpcode) 
	 else ##
	  allscreens = plsql.r_screens.all
	  allscreens.each do |i|
                   @vlist[i[:screen_code].downcase.to_sym] = sub_blkgetpobj(i[:screen_code],"A",grpcode) ## A:画面
             ### 画面の種類にかかわらずscreen_codeユニークであること。
             # 将来はグループ分けが必要
          end 
	  Rails.cache.write("listindex" + grpcode, @vlist)
#         debugger # breakpoint
          
     end
end
end
