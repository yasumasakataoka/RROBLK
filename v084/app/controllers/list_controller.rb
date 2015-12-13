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
	   if ENV["RACK_ENV"] == "development" ###開発環境のみで動く
			logger.debug("start #{Time.now}")
			testlinks 
			crt_def_all
			Rails.cache.clear
		end
    end	
	#### code index　チッェクを入れる。
    def crtcachelist grpcode
          ##debugger # breakpoint
        if   Rails.cache.exist?("listindex" + grpcode) then
             @cate_list,@max_cnt = Rails.cache.read("listindex" + grpcode) 
	         Rails.cache.delete("listindex" + grpcode) if @cate_list.nil?
	       else ##
	         @cate_list = []
             @max_cnt = chk_cnt =  1
			 strsql = "select * from r_screens where screen_grpcodename != '#' and screen_expiredate >current_date order by screen_grpcodename"
	         ActiveRecord::Base.connection.select_all(strsql).each do |i|
                if   @cate_list[-1] then
                     if   @cate_list[-1][0] == i["screen_grpcodename"][0,1] then 
                          chk_cnt += 1
                          @max_cnt = chk_cnt if chk_cnt > @max_cnt 
                        else
                          @cate_list << [i["screen_grpcodename"][0,1],i["screen_grpcodename"][2..-1],{}]
                          chk_cnt = 1
                      end
                    else
                       @cate_list << [i["screen_grpcodename"][0,1],i["screen_grpcodename"][2..-1],{}]
                 end
                   @cate_list[-1][2][i["pobject_code_scr"].downcase.to_sym] = sub_blkgetpobj(i["pobject_code_scr"],"screen") ## 
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
	def testlinks	###開発環境のみで動く
	        recs = ActiveRecord::Base.connection.select_all("select * from r_tblinks where tblink_expiredate > current_date")  
			recs.each do |rec|
			        str_select = "select distinct a.id ,a.tblfield_seqno from r_tblfields a "
					str_select << "where tblfield_expiredate > current_date"
					str_select <<" and not exists(select 1 from (select * from r_tblinkflds where tblinkfld_tblink_id = #{rec["id"]}) b "
					str_select << " where a.id = b.tblinkfld_tblfield_id )"
					str_select << " and a.tblfield_blktb_id = #{rec["tblink_blktb_id_dest"]} "
				    fldrecs = ActiveRecord::Base.connection.select_all(str_select)
					##debugger
			        fldrecs.each do |fldrec|
			           fld = {}
		    	       fld[:tblinks_id] = rec["tblink_id"]
			           fld[:persons_id_upd] = 0
			           fld[:expiredate] = DateTime.parse("2099/12/31")
			           fld[:created_at] = Time.now
			           fld[:updated_at] = Time.now
		               fld[:remark] = "auto created "		   
			           fld[:id] = proc_get_nextval "tblinkflds_seq"
			           fld[:tblfields_id] = fldrec["id"]
			           fld[:seqno] = fldrec["tblfield_seqno"]
					   unless ActiveRecord::Base.connection.select_value("select id from tblinkflds where tblinks_id = #{rec["tblink_id"]} and tblfields_id = #{fldrec["id"]} ")
					      proc_tbl_add_arel("tblinkflds", fld)
					   end
			        end
			end
			strwhere = " id in (select id  from r_tblinkflds  a where not exists(select 1 from tblfields b where a.tblinkfld_tblfield_id = b.id "
			strwhere << " and tblink_blktb_id_dest = b.blktbs_id and b.expiredate > current_date))"
			proc_tbl_delete_arel("tblinkflds",strwhere)
	end
end
