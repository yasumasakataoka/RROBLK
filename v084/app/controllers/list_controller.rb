class ListController < ApplicationController
before_filter :authenticate_user!  
## 全ユーザ共通
## SCREENLEVELで表示画面を制限すること。
    def index
     ###debugger  ##debugger  の位置を変更するとエラーになる。???
	   grpcode = sub_blkget_grpcode 
       if grpcode  then
	        crtcachelist(grpcode)
        else
          render :text=>"error"
       end
    ##debugger
    end
    def crtcachelist grpcode
          ##debugger # breakpoint
        if   Rails.cache.exist?("listindex" + grpcode) then
             @cate_list,@max_cnt = Rails.cache.read("listindex" + grpcode) 
	     Rails.cache.delete("listindex" + grpcode) if @cate_list.nil?
	   else ##
	     @cate_list = []
             @max_cnt = chk_cnt =  1
	     plsql.r_screens.all("where screen_expiredate >sysdate order by screen_grpcodename").each do |i|
                if   @cate_list[-1] then
                     if   @cate_list[-1][0] == i[:screen_grpcodename][0,1] then 
                          chk_cnt += 1
                          @max_cnt = chk_cnt if chk_cnt > @max_cnt 
                        else
                          @cate_list << [i[:screen_grpcodename][0,1],i[:screen_grpcodename][2..-1],{}]
                          chk_cnt = 1
                      end
                    else
                       @cate_list << [i[:screen_grpcodename][0,1],i[:screen_grpcodename][2..-1],{}]
                 end
                   @cate_list[-1][2][i[:pobject_code_scr].downcase.to_sym] = sub_blkgetpobj(i[:pobject_code_scr],"screen") ## 
             ### 画面の種類にかかわらずscreen_codeユニークであること。
             # 将来はグループ分けが必要
             end 
	    Rails.cache.write("listindex" + grpcode, [@cate_list,@max_cnt]) if  @cate_list
          ##debugger # breakpoint
         end
     render :text => "no screen data "  and return   if @cate_list.nil?
     ####   if Rails.env == 'development' 開発環境の時のみ　rubycodeの変更は可能
    end
end
