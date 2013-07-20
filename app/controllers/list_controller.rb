class ListController < ApplicationController
before_filter :authenticate_user!  
## 全ユーザ共通
## SCREENLEVELで表示画面を制限すること。
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
           ##debugger # breakpoint
      if   Rails.cache.exist?("listindex" + grpcode) then
           @vlist = Rails.cache.read("listindex" + grpcode) 
	   Rails.cache.delete("listindex" + grpcode) if @vlist.nil?
	 else ##
	  @vlist = {}
	  plsql.r_screens.all.each do |i|
                   @vlist[i[:screen_tcode].downcase.to_sym] = sub_blkgetpobj(i[:screen_tcode],"screen") ## 
             ### 画面の種類にかかわらずscreen_codeユニークであること。
             # 将来はグループ分けが必要
          end 
	  Rails.cache.write("listindex" + grpcode, @vlist) if  @vlist
          ##debugger # breakpoint
      end
     render :text => "no screen data "  and return   if @vlist.nil?
     ####   if Rails.env == 'development' 開発環境の時のみ　rubycodeの変更は可能
end
end
