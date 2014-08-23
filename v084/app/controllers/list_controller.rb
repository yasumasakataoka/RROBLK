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
	def testlinks	###開発環境のみで動くようにすること。  ###項目が削除されているときの対応、現在項目を削除している。
	        recs = plsql.r_tblinks.all("where tblink_expiredate > sysdate")  
			recs.each do |rec|
			        str_select = "select distinct a.id from r_blktbsfieldcodes a "
					str_select << "where blktbsfieldcode_expiredate > sysdate"
					str_select <<" and not exists(select 1 from (select * from r_tblinkflds where tblinkfld_tblink_id = #{rec[:id]}) b "
					str_select << " where a.id = b.tblinkfld_blktbsfieldcode_id )"
					str_select << " and a.blktbsfieldcode_blktb_id = #{rec[:tblink_blktb_id_dest]} "
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
					   unless plsql.tblinkflds.first("where tblinks_id = #{rec[:tblink_id]} and blktbsfieldcodes_id = #{fldrec[:id]} ")
					      plsql.tblinkflds.insert fld
					   end
			        end
			end
			strwhere = "where id in (select id  from r_tblinkflds  a where not exists(select 1 from blktbsfieldcodes b where a.tblinkfld_blktbsfieldcode_id = b.id "
			strwhere << " and tblink_blktb_id_dest = b.blktbs_id and b.expiredate > sysdate))"
			plsql.tblinkflds.delete(strwhere)
	end
end

