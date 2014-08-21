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
	   testlinks
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
			 ##sub_define_default_methods
             ##debugger # breakpoint
         end
     render :text => "no screen data "  and return   if @cate_list.nil?
     ####   if Rails.env == 'development' 開発環境の時のみ　rubycodeの変更は可能
    end
	def testlinks	###開発環境のみで動くようにすること。
	        recs = plsql.r_tblinks.all  
			recs.each do |rec|
			        str_select = "select distinct a.id from r_blktbsfieldcodes a ,r_tblinks x "
					str_select << "where blktbsfieldcode_blktb_id = #{rec[:blktb_id_dest]}  and blktbsfieldcode_expiredate > sysdate"
					str_select <<" and  a.blktb_id = x.blktb_id_dest"
					str_select <<" and not exists(select 1 from r_tblinkflds b where a.id = b.tblinkfld_blktbsfieldcode_id "
					str_select <<" and x.pobject_id_view_src = b.pobject_id_view_src )"
				    fldrecs = plsql.select(:all,str_select)
					##debugger
			        fldrecs.each do |fldrec|
			           fld = {}
		    	       fld[:tblinks_id] = rec[:tblink_id]
			           fld[:persons_id_upd] = 0
			           fld[:expiredate] = DateTime.parse("2099/12/31")
			           fld[:created_at] = Time.now
			           fld[:updated_at] = Time.now
		               fld[:remark] = "auto created "		   
			           fld[:id] = plsql.tblinkflds_seq.nextval
			           fld[:blktbsfieldcodes_id] = fldrec[:id]
					   plsql.tblinkflds.insert fld
			        end
			end
			plsql.tblinkflds.delete("where id in (select id  from tblinkflds  a where not exists(select 1 from blktbsfieldcodes b where a.blktbsfieldcodes_id = b.id and b.expiredate > sysdate))")
	end
end

