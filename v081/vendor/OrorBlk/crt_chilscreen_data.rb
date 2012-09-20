  require "rubygems"
  require "ruby-plsql"
  require "time"
  plsql.connection = OCI8.new("rails","tq6t7rjx","xe")
## ｃｈｉｌｓｃｒｅｅｎｓにデータ作成  
 def addmain tblname
##    p "addmain1"
##  対象となるテーブルは　idをフィールドに持つこと
## tablenameS_ID_xxx_xxxのレイアウトであること。
## viewの名前は R_xxxx のようにすること。
    tblarea = {}  
    notextview = {}
    strsql = " where table_name not like 'R_%' and table_name not like 'V_%'  and SUBSTR(TABLE_NAME,1,4) != 'BIN$'"
    if tblname == "ALL" then
       strsql << " and column_name like '%S_ID%' "
       strsql << " and table_name not like '%PERSONS%' "
      else 
       strsql << " and column_name like '%#{tblname.upcase}_ID%' "
     end   
       fields = plsql.USER_TAB_COLUMNS.all(strsql)
       ## p "strsql : #{strsql}"
    ## p fields   
##    p "addmain2"
    fields.each  do |tbldata|
       if tbldata[:column_name]  =~ /_ID/ then
          pare_tbl_sym = tbldata[:column_name].split(/_ID/)[0].to_sym
          chil_tbl_sym = tbldata[:table_name].to_sym
          tmp_area = tblarea[pare_tbl_sym]
          tmp_area ||= {}
          tmp_area[chil_tbl_sym] = "1"
         tblarea[pare_tbl_sym] = tmp_area
       end
    end
    tblarea.each_key  do |i|
        x = plsql.screens.first("WHERE ViewName = 'R_#{i.to_s}' ")
        next if x.nil?
        ## p "i " + "WHERE ViewName like '%#{i.to_s.upcase}' "
        tmp_area = tblarea[i] 
        tmp_area.each_key do |j|
              p " j : #{j}"
              y = plsql.screens.first("WHERE ViewName = 'R_#{j.to_s}' ")
              next if y.nil?
              ## p "WHERE ViewName like '%#{j.to_s.upcase}' "
                 chil_r = plsql.ChilScreens.first("where screens_id = :1 and screens_id_chil = :2",x[:id],y[:id])
                 ##  p  "where screens_id_Pare = :1 and screens_id = :2"
                 if chil_r.nil? then
                    val_chil = {
                    :id => plsql.chilscreens_seq.nextval,
                    :screens_id => x[:id],
                    :screens_id_chil => y[:id],
                    :expiredate => Time.parse("2099/12/31"),
                    :remark => "auto_create", 
                    :persons_id_upd => 1, 
                    :update_ip =>  "1",
                    :created_at => Time.now,
                    :updated_at => Time.now
                    }
                  plsql.chilscreens.insert val_chil
                  ## p "insert"
                  end ## if
             end ##j
    end    ## i
    plsql.commit 
 end  #end addmain 

 p "start"
 addmain "screens".upcase

