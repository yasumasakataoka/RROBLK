class CrtextviewscreenController < CrttblviewscreenController
#### 残作業
### 開発環境でしか動かないようにすること。
### テーブルに項目を追加すると　railsの再起動が必要

  before_filter :authenticate_user!  
  def index
      recid  = params[:q].to_i
      if  viewrec = plsql.r_screens.first("where id = #{recid}  ") then 
          if viewrec[:screen_expiredate] > Time.now then
		     ##Rails.cache.clear(nil)
			 plsql.logoff
			 plsql.connect! "rails", "rails", :host => "localhost", :port => 1521, :database => "xe"
             create_screenfields viewrec[:pobject_code_view]
			 ##Rails.cache.clear(nil)
             @errmsg = "created screen_fields of  #{viewrec[:pobject_code_view]}"
            else
             @errmsg = "out of expiredate"
          end
         else
             @errmsg = " id not correct"
      end 
  end
 
end
