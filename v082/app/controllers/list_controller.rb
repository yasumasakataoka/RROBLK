class ListController < ApplicationController
before_filter :authenticate_user!  
## 全ユーザ共通
## グループ対応は必要
## 1 session 1 user が必須　今 no chk 
  def index
       ## debugger  ##debugger  の位置を変更するとエラーになる。???
       cache_key = "listindex" + current_user[:id].to_s
       @vlist = Rails.cache.read(cache_key)  ##
###       if  @vlist.nil? or @vlist.empty?
           @vlist = Hash.new
           crtcachelist
###       end 
   #    p "@vlist" + @vlist[0]
       ##  debugger # breakpoint
   end
  def crtcachelist
  ##         debugger # breakpoint
           selveiw =  plsql.r_screens.all
           selveiw.each do |i|
             @vlist[i[:screen_code].downcase.to_sym] = getblkpobj(i[:screen_code],"A") ## A:画面
             ### 画面の種類にかかわらずViewnameでユニークであること。
             # 将来はグループ分けが必要
           end 
            
#        debugger # breakpoint
           tmp_session_id = request.session_options[:id]
           tmp_session_id  ||= "1"
           Rails.cache.write("listindex" + current_user[:id].to_s, @vlist)
#         debugger # breakpoint
          
   end
end
