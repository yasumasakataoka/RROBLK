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
 def subprint str
    foo = File.open("crt_view.log","a")
    foo.puts str
    foo.close 
 end 
 def addmain tblname
##    p "addmain1"
##  対象となるテーブルは　idをフィールドに持つこと
##  R_Persons　と　r_UserGroups のVIEWは必ず存在すること。　将来チェックを入れる。
##  有効日の対応ができてない。

    tblarea = []  
    recrtsel = {} ## _id からviewを作成できなかったテーブル
    notextview = {}
    #### Hx_,Dx_も抜くこと。
    strsql = " where table_name not like 'R_%' and table_name not like 'V_%' "
    strsql << " and TABLE_NAME = :1 and column_name = 'ID' "
    fields = plsql.USER_TAB_COLUMNS.all(strsql,tblname.upcase)
     ### p "addmain2"
    fields.each  do |tbldata|
          tblarea << tbldata[:table_name]  
    end
    if   tblarea == []  then
		p " not find #{tblname}"
		subprint " not find #{tblname}"
		exit
    end
    tblarea.each  do |i|
        subfields = plsql.USER_TAB_COLUMNS.all("WHERE TABLE_NAME = :1",i)
        selectstr = " select "
        wherestr = " where "   ##joinが条件
        fromstr = " from " + i + " " + i[0..-2] + " ,"   ## 最後のSはとる。
        sub_rtbl = "R_" + i   ##create view name
        subfields.each do |j|
           if  j[:column_name] =~ /_ID/  then
               ### join_rtbl : view for join
               join_rtbl = "R_" + j[:column_name].split(/_ID/)[0]   ##JOINするテーブル名
               subprint "join_rtbl  = '#{join_rtbl}' "
               rtblname =  j[:column_name].sub(/S_ID/,"")
               fromstr << join_rtbl + "  " + rtblname + ','
               if rtblname.scan(j[:column_name].split(/S_ID/)[0]) then
                   wherestr << rtblname + ".ID = " 
                 else  
                   wherestr << rtblname + "." +  j[:column_name].split(/S_ID/)[0]  + "_ID = " 
               end   
               wherestr << i[0..-2] + "." + j[:column_name]  + " AND " 
               ## selectstr << i[0..-2] + "." +  j[:column_name] + " " + i[0..-2] + "_" +  j[:column_name] + " ,"
               subtblcrt  j[:column_name],rtblname do |k|
                 selectstr << k
               end
             else
               p "table:" + i + " field:" +  j[:column_name] + " length:" + (i[0..-2].length + j[:column_name].length).to_s if  (i[0..-2].length + j[:column_name].length) > 30
               if j[:column_name] == 'ID'  then
                  selectstr << i[0..-2] + "." +  j[:column_name]  + " ,"
               else
                  selectstr << i[0..-2] + "." +  j[:column_name] + " " + i[0..-2] + "_" +  j[:column_name] + " ," 
               end 
               ###  p  j[:column_name]
           end      ## if tbldata[:column_name] =~ /_ID/
        end   ##subfields
        ##  p "rtblw: " + i
        strsql = "create or replace view  R_" + i + " as "   
        strsql << selectstr[0..-3] +  fromstr[0..-2] + wherestr[0..-5]
        subprint strsql
        plsql.execute  strsql  
     end    ## tblarea do 
 end  #end addmain 
 def  subtblcrt  subrtbl ,rtblname   ## sub_rtbl:テーブル名,rtblname:省略形
        k = ""
        join_rtbl = "R_" + subrtbl.split(/_ID/)[0] 
        subfields = plsql.USER_TAB_COLUMNS.all("WHERE TABLE_NAME = :1",join_rtbl)
        if subfields.empty?
           a_join_rtbl = []
           a_join_rtbl << join_rtbl
           until a_join_rtbl.empty?  
             i = a_join_rtbl[0].sub(/^R_/,"")
             x = subcrtrtbl i
             a_join_rtbl.unshift  x if x != ""
             a_join_rtbl.shift  if x == ""
           end
           subfields = plsql.USER_TAB_COLUMNS.all("WHERE TABLE_NAME = :1",join_rtbl)
          end  
           subprint " #{__LINE__} subfields #{subfields}"
           subfields.each do |j|
              xfield =  j[:column_name]  
              if join_rtbl == "R_PERSONS"
                 xfield  = "" if j[:column_name].match("_UPD")
                else
                 xfield  = "" if j[:column_name].match("PERSON")
               end   ## if join_rtbl  
               ["_ID","EXPIREDATE","UPDATE_IP","CREATED_AT","UPDATED_AT","USERGROUP_CODE_UPD","USERGROUP_NAME_UPD","USERGROUP_CODE_CHRG","USERGROUP_NAME_CHRG"].each do |x|
                     xfield = "" if j[:column_name].match(x)
               end
               if   xfield  != "" then 
                    sfx = ""
                    sfx = subrtbl.split(/S_ID/)[0] + "_" if xfield == "ID" 
                    xfield = rtblname + "." + xfield + " " + sfx + xfield +  subrtbl.split(/_ID/)[1] if !subrtbl.split(/_ID/)[1].nil?
                    xfield = rtblname + "." + xfield + " "  + sfx + xfield  if subrtbl.split(/_ID/)[1].nil?
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
        subfields = plsql.USER_TAB_COLUMNS.all("WHERE TABLE_NAME = :1",i)
        ## p " subcrtrtbl  i :" + i
        selectstr = " select "
        wherestr = " where "   ##joinが条件
        fromstr = " from " + i + " " + i[0..-2] + " ,"   ## 最後のSはとる。
        subfields.each do |j|
           if  j[:column_name] =~ /_ID/ then
               ### join_rtbl : view for join
               join_rtbl = "R_" + j[:column_name].split(/_ID/)[0]   ##JOINするテーブル名
               ##  p "sub_rtblx: " + join_rtbl
               rtblname =  j[:column_name].sub(/S_ID/,"")
               fromstr << join_rtbl + "  " + rtblname + ','
               if rtblname.scan(j[:column_name].split(/S_ID/)[0]) then
                   wherestr << rtblname + ".ID = " 
                 else  
                   wherestr << rtblname + "." +  j[:column_name].split(/S_ID/)[0]  + "_ID = " 
               end   
               wherestr << i[0..-2] + "." + j[:column_name]  + " AND " 
               selectstr << i[0..-2] + "." +  j[:column_name] + " " + i[0..-2] + "_" +  j[:column_name] + " ," 
               ### rtblname    alter sub_rtbl view
               joinfields = plsql.USER_TAB_COLUMNS.all("WHERE TABLE_NAME = :1",join_rtbl)
               p "joinfields.empty?"
               if joinfields.empty?
                  return join_rtbl
               end  
               ## p "x join_rtbl " + join_rtbl                                                                                        
               joinfields.each do |k|
                  xfield =  k[:column_name]
                  ["_ID","EXPIREDATE","UPDATE_IP","CREATED_AT","UPDATED_AT"].each do |x|
                     xfield = "" if !k[:column_name].match(x).nil?
                  end
                  if join_rtbl == "R_PERSONS" then
                     xfield = "" if k[:column_name].match("_UPD")
                    else
                     xfield = "" if k[:column_name].match("PERSON")
                  end   
                 if xfield != "" then
                    ###  p j[:column_name] 
                    sfx = ""
                    sfx = rtblname.split("_")[0] + "_" if rtblname.split("_")[0] != xfield.split("_")[0]
                    xfield = rtblname + "." + xfield + " " + sfx + xfield 
                    xfield <<   j[:column_name].split(/S_ID/)[1] if !j[:column_name].split(/S_ID/)[1].nil?
                    selectstr <<  " " +  xfield  + ",\n" 
                    lngerrfield = xfield.split(" ")[1]
                    p "sub table:" + join_rtbl + " field:" + lngerrfield  + " length:" + (lngerrfield.length).to_s if (lngerrfield.length) > 29
                 end    
               end  ## joinfields.each
           ##  p "subtblcrt "
            else 
               p "table:" + i + " field:" +  j[:column_name] + " length:" + (i[0..-2].length + j[:column_name].length).to_s if  (i[0..-2].length + j[:column_name].length) > 30
               if j[:column_name] == 'ID'  then
                  selectstr << i[0..-2] + "." +  j[:column_name]  + " ,"
                 else
                  selectstr << i[0..-2] + "." +  j[:column_name] + " " + i[0..-2] + "_" +  j[:column_name] + " ," 
                end 
               ## p  j[:column_name]
           end      ## if tbldata[:column_name] =~ /_ID/
        end  ## subfields.each  
        p "subcrtrtbl a_rtblw: " + i
        strsql = "create  view  R_" + i + " AS "   
        strsql << selectstr[0..-2] +  fromstr[0..-2] + wherestr[0..-5]
        subprint strsql
        ### ERRORを拾えてない。
        plsql.execute  strsql 
        return join_rtbl = ""
  end  ##subcrtrtbl
 p "start"
 doaddsrn = AddScreen.new 
 ARGV.each do |x|
    addmain x.upcase
    doaddsrn.addmain ("R_" + x).upcase
    doaddsrn.crt_chil_screen ("R_" + x).upcase
    plsql.commit
 end
