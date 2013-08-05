  require "rubygems"
  require 'time'
  require "ruby-plsql"
  plsql.connection = OCI8.new("rails","rails","xe")
  require File.dirname(__FILE__) +  "/screen_names_set.rb"
### R_view を作成するプログラム
### 重要　init_usergroup_person.sql　は実行済であること。
###    その後 
###       ruby X:\YYY\vendor\OrorBlk\crt_r_view_sql.rb detailfields,POBJGRPS,FOBJGRPS,screens,buttons,chilscreens 
####      の実行　
###  r_personが循環になる。
###  リンク先のnameが入力項目かつ必須になっている。
 def subprint str
    foo = File.open("crt_view.log","a")
    foo.puts str
    foo.close 
 end 
 def addmain i   ###  i=tblname
##    p "addmain1"
##  対象となるテーブルは　idをフィールドに持つこと
##  R_Persons　と　r_UserGroups のVIEWは必ず存在すること。　将来チェックを入れる。
##  有効日の対応ができてない。

    ##tblarea = []  
    recrtsel = {} ## _id からviewを作成できなかったテーブル
    notextview = {}
    #### Hx_,Dx_も抜くこと。
    ##strsql = " where table_name not like 'R_%' and table_name not like 'V_%' "
    ##strsql << " and TABLE_NAME = :1 and column_name = 'ID' "
    ##fields = plsql.USER_TAB_COLUMNS.all(strsql,tblname.downcase)
    ### p "addmain2"
    ##fields.each  do |tbldata|
    ##      tblarea << tbldata[:table_name]  
    ##end
    ##if   tblarea == []  then
    ##		p " not find #{tblname}"
    ##		subprint " not find #{tblname}"
    ##		exit
    ##end
    ## tblname.each  do |i|
        ##subfields = plsql.USER_TAB_COLUMNS.all("WHERE TABLE_NAME = :1",i)
    if PLSQL::Table.find(plsql, i.to_sym).nil?
       p	 "not exists table #{i}"
       exit(0)
    end
    subfields = plsql.__send__(i).column_names
    selectstr = " select "
        wherestr = "\n where "   ##joinが条件
        fromstr = "\n from " + i + " " + i.chop + " ,"   ## 最後のSはとる。
        sub_rtbl = "r_" + i   ##create view name
        subfields.each do |j|
	   js = j.to_s
           if  js =~ /_id/  then
               ### join_rtbl : view for join
               join_rtbl = "r_" + js.split(/_id/)[0]   ##JOINするテーブル名
               subprint "join_rtbl  = '#{join_rtbl}' "
               rtblname =  js.sub(/s_id/,"")
               fromstr << join_rtbl + "  " + rtblname + ','    ### from r_xxxxs xxxxx 
               ##if rtblname.scan(js.split(/s_d/)[0]) then
               wherestr << " #{rtblname}.#{rtblname.split("_")[0]}_id = " 
               ##  else  
               ##    wherestr << rtblname + "." +  js.split(/s_id/)[0]  + "_id = " 
               ##end   
	       wherestr << i.chop + "." + js  + " and " 
               selectstr << i.chop + "." +  js + " " + i.chop + "_" +  js.sub("s_id","_id") + " ,"
               subtblcrt  js,rtblname do |k|
                 selectstr << k
               end
             else
               fprnt "table:" + i + " field:" +  js + " length:" + (i.chop.length + js.length).to_s if  (i.chop.length + js.length) > 30
               ###if js == 'id'  then
                  selectstr << i.chop + "." +  js  + " ,"   if js == 'id' 
               ###else
                  selectstr << i.chop + "." +  js + " " + i.chop + "_" +  js + " ," 
               ###end 
               ###  p  j[:column_name]
           end      ## if tbldata[:column_name] =~ /_ID/
        end   ##subfields
        ##  p "rtblw: " + i
        strsql = "create or replace view  r_" + i + " as "   
        strsql << selectstr[0..-3] +  fromstr[0..-2] + wherestr[0..-5]
        subprint strsql
        plsql.execute  strsql  
     ## end    ## tblarea do 
 end  #end addmain 
 def  subtblcrt  subrtbl ,rtblname   ## sub_rtbl:テーブル名,rtblname:省略形
        k = ""
        join_rtbl = "r_" + subrtbl.split(/_id/)[0] 
        ##subfields = plsql.USER_TAB_COLUMNS.all("WHERE TABLE_NAME = :1",join_rtbl)
	if PLSQL::View.find(plsql, join_rtbl.to_sym).nil?
           p	 "create view #{ join_rtbl }"
           addmain subrtbl.split(/_id/)[0] 
	end  

	subfields = plsql.__send__(join_rtbl).column_names
        #if subfields.empty?
        #   a_join_rtbl = []
        #   a_join_rtbl << join_rtbl
        #   until a_join_rtbl.empty?  
        #     i = a_join_rtbl[0].sub(/^r_/,"")
        #     x = subcrtrtbl i
        #     a_join_rtbl.unshift  x if x != ""
        #     a_join_rtbl.shift  if x == ""
        #   end
           ##subfields = plsql.USER_TAB_COLUMNS.all("WHERE TABLE_NAME = :1",join_rtbl)
         #  subfields  = plsql.__send__(join_rtbl).column_names
        #end  
        ##subprint " #{__LINE__} subfields #{subfields}"
        subfields.each do |j|
          js = j.to_s
          xfield =  js  
          if join_rtbl == "r_persons"
                 xfield  = "" if js.match("_upd")
                else
                 xfield  = "" if js.match("person")
           end   ## if join_rtbl  
            ["USERGROUP_ID","EXPIREDATE","UPDATE_IP","CREATED_AT","UPDATED_AT","USERGROUP_CODE_UPD","USERGROUP_NAME_UPD","USERGROUP_CODE_CHRG","USERGROUP_NAME_CHRG","ID"].each do |x|
                     xfield = "" if js.upcase.match(x)
               end
               if   xfield  != "" then 
                    sfx = ""
                    ##sfx = subrtbl.split(/s_id/)[0] + "_" if xfield == "id" 

                    xfield = rtblname + "." + xfield + " " + sfx + xfield +  subrtbl.split(/_id/)[1] if subrtbl.split(/_id/)[1]
                    xfield = rtblname + "." + xfield + " "  + sfx + xfield  if subrtbl.split(/_id/)[1].nil?
                    k <<  " " +  xfield   + ",\n" 
                    lngerrfield = xfield.split(" ")[1]
                    p "sub table:" + join_rtbl + " field:" + lngerrfield  + " length:" + (lngerrfield.length).to_s if (lngerrfield.length) > 29
               end  
            end  ## subfields.each
            ### p "subtblcrt " + k
         yield k           
 end 
 ## ナマテーブルの時
 def  subcrtrtbl  i   
        ##subfields = plsql.USER_TAB_COLUMNS.all("WHERE TABLE_NAME = :1",i)
	subfields = plsql__send__(i).column_names
        ## p " subcrtrtbl  i :" + i
        selectstr = " select "
        wherestr = " where "   ##joinが条件
        fromstr = " from " + i + " " + i.chop + " ,"   ## 最後のSはとる。
        subfields.each do |j|
           js = j.to_s
           if  js =~ /_id/ then
               ### join_rtbl : view for join
               join_rtbl = "r_" + js.split(/_id/)[0]   ##JOINするテーブル名
               ##  p "sub_rtblx: " + join_rtbl
               rtblname =  js.sub(/s_id/,"")
               fromstr << join_rtbl + "  " + rtblname + ','
               if rtblname.scan(js.split(/s_id/)[0]) then
                   wherestr << rtblname + ".id = " 
                 else  
                   wherestr << rtblname + "." +  js.split(/s_id/)[0]  + "_id = " 
               end   
               wherestr << i.chop + "." + js  + " and " 
               selectstr << i.chop + "." +  js + " " + i.chop + "_" +  js + "," 
               ### rtblname    alter sub_rtbl view
               ## joinfields = plsql.USER_TAB_COLUMNS.all("WHERE TABLE_NAME = :1",join_rtbl)
	       joinfields  = plsql.__send__(join_rtbl).column_names
               ## p "joinfields.empty?"
               if joinfields.empty?
                  return join_rtbl
               end  
               ## p "x join_rtbl " + join_rtbl                                                                                        
               joinfields.each do |k|
		  xfield = k.to_s
		  ks     = k.to_s
                  ["EXPIREDATE","UPDATE_IP","CREATED_AT","UPDATED_AT"].each do |x|
                     xfield = "" unless ks.upcase.match(x).nil?
                  end
                  if join_rtbl == "r_persons" then
                     xfield = "" if ks.match("_upd")
                    else
                     xfield = "" if ks.match("person")
                  end   
                 if xfield != "" then
                    ###  p j[:column_name] 
                    sfx = ""
                    sfx = rtblname.split("_")[0] + "_" if rtblname.split("_")[0] != xfield.split("_")[0]
                    xfield = rtblname + "." + xfield + " " + sfx + xfield 
                    xfield <<   js.split(/s_id/)[1]  if js.split(/s_id/)[1]
                    selectstr <<  " " +  xfield  + ",\n" 
                    lngerrfield = xfield.split(" ")[1]
                    p "sub table:" + join_rtbl + " field:" + lngerrfield  + " length:" + (lngerrfield.length).to_s if (lngerrfield.length) > 29
                 end    
               end  ## joinfields.each
           ##  p "subtblcrt "
            else 
               p "table:" + i + " field:" +  js + " length:" + (i.chop.length + js.length).to_s if  (i.chop.length + js.length) > 30
               if js == 'id'  then
                  selectstr << i.chop + "." +  js  + " ,"
	         else
	 	  selectstr << i.chop + "." +  js + " " + i.chop + "_" +  js + " ," 
	        end 
               ## p  j[:column_name]
              end      ## if tbldata[:column_name] =~ /_ID/
        end  ## subfields.each  
        p "subcrtrtbl a_rtblw: " + i
        strsql = "create  view  R_" + i + " AS "   
        strsql << selectstr.chop +  fromstr.chop + wherestr[0..-5]
        subprint strsql
        ### ERRORを拾えてない。
        plsql.execute  strsql 
        return join_rtbl = ""
  end  ##subcrtrtbl
 p "start"
 doaddsrn = AddScreen.new 
 ARGV.each do |x|
    addmain x.downcase
    doaddsrn.addmain ("r_" + x).downcase
    ##doaddsrn.crt_chil_screen ("r_" + x).downcase ###子画面作成
    plsql.commit
 end
