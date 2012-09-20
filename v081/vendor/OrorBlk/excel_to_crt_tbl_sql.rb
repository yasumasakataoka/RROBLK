require "rubygems"
require "win32ole"
foo = File.open("CREATETBL.SQL","w")
app = WIN32OLE.new("Excel.Application")
### app["Visible"]  =  TRUE   ### 1.9.2p0 (2010-08-18) [i386-mswin32_100] not support
app.Workbooks.open(ARGV[0])
####   app.Workbooks.open(ARGV[0]);
tablname = "TABLE"
app.Worksheets.each do |ersheet|
maxj = ersheet.UsedRange.CoLumns.Count
maxi = ersheet.UsedRange.Rows.Count
crttbl = []
crtproc = []
crtnst = []
nstflg = []
kakkoflg = []
### for j in 1..maxj
for j in [1,6,11]
   for i in 1..maxi
      case   ersheet.cells(i,j).value
         when "<TABLE>"
             tblname =  ersheet.cells(i,j+1).value
             nstflg.unshift(tblname)
             crttbl << "DROP TABLE " + tblname   
             crttbl << ";" 
             chrfield = "  ( "
             kakkoflg << "("  
             case   ersheet.cells(i,j+2).value  
                 when "OF"
                      if ersheet.cells(i,j+3).value.nil?  then
                         crttbl << "CREATE TABLE " + tblname  + " OF " + " Typ" +  tblname[0..tblname.length - 2]                         
                        else       
                         crttbl << "CREATE TABLE " + tblname  + " OF " + ersheet.cells(i,j+3).value
                        end                       
                 else 
                      crttbl << "CREATE TABLE " + tblname 
             end         
       when "<TYPE>"
             kakkoflg = []
             tblname =  ersheet.cells(i,j+1).value
             crttbl << "DROP TYPE " + tblname  + " force "
             crttbl <<  "; "      
             case   ersheet.cells(i,j+2).value  
                 when "AS OBJECT"
                      crttbl << "CREATE TYPE " + tblname  + " AS OBJECT  "   
                      chrfield = "  ( "                
                      kakkoflg << "("            
                 when "AS TABLE"
                      chrfield = "   "                
                      kakkoflg << ""            
                      crttbl << "CREATE TYPE " + tblname  + " AS TABLE  OF " + "Typ" +  tblname[3..tblname.length - 2] + " "  
                 else 
                      crttbl << "CREATE TYPE " + tblname  + " AS OBJECT  "
                      chrfield = "  ( "               
                      kakkoflg << "("             
              end              
       when "<ITEM>" 
             fldtyp = ersheet.cells(i,j+2).value
             case   fldtyp
                 when "REF"
                      crttbl << chrfield + ersheet.cells(i,j+1).value  + " REF " + ersheet.cells(i,j+3).value 
                 when "PKY"
                      crttbl << chrfield + " CONSTRAINT " + 
                                 tblname + "_id_pk PRIMARY KEY (id)" 
                      crtproc << "drop sequence " + tblname + "_seq"
                      crtproc << ";  "
                      crtproc << "create sequence " + tblname + "_seq" 
                      crtproc << ";  "     
                 when "UKY"
                      crttbl << chrfield + " CONSTRAINT " + \
                                 tblname + "_#{i.to_s}_uk  UNIQUE (#{ersheet.cells(i,j+1).value})" 
                      crtproc << "; "
                 when "FKY"
                      crttbl << chrfield + " CONSTRAINT " + \
                                 tblname + "_#{i.to_s}_fk  FOREIGN  KEY (#{ersheet.cells(i,j+1).value})" +
                                 " REFERENCES  #{ersheet.cells(i,j+3).value} " 
                      crtproc << ";  " 
                 else
                      p "i j " + i.to_s + " " + j.to_s  if ersheet.cells(i,j+1).value.nil?
                      crttbl <<  chrfield + ersheet.cells(i,j+1).value  + " "  +  ersheet.cells(i,j+2).value
             end
             chrfield = "  ,"
                 
       when "<END>"
           if crttbl.length > 1 then 
              crttbl.each  do |sqlline|
                foo.puts  sqlline
              end
              foo.puts ")" if  kakkoflg[0] == "("  
              foo.puts ";" if   crtnst.length <= 0
           end
           if   crtnst.length > 0 then  
                crtnst.each  do |sqlline|
                   foo.puts  sqlline
                 end
                nstflg.shift
                 while  !nstflg.empty? 
                    foo.puts ")" 
                    nstflg.shift
                 end 
           foo.puts ";" 
           end 
           if crtproc.length > 2 
              crtproc.each  do |sqlline|
                foo.puts  sqlline
              end
            end  
           crttbl = []
           crtproc = []
           crtnst = []
           nstflg = []
       else  
     end   # case
   end     # i
end        # j
end
app.ActiveWorkbook.Close(0) if !app.ActiveWorkbook.nil?
app.Quit()
foo.puts "/" 
foo.close

