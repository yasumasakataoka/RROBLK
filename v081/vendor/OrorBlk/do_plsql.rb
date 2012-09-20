  require "rubygems"
  require "ruby-plsql"

  plsql.connection = OCI8.new("rails","tq6t7rjx","xe")
  foo = File.open("D:/plsql/v00/CREATETBL.SQL","r")
   sql = ""
   foo.each_line {|xline| 
                  begin
                  sql << xline + "\n"
                  if xline =~ /^;/ then
                      sql.gsub!(/;/,'')
                      plsql.execute sql  
                      sql = ""
                   end
                  if xline =~ /^\// then
                      plsql.execute sql  
                      sql = ""
                   end
                    rescue OCIError
                      puts OCIError#code
                      puts sql
                      sql = ""
                    end
                  }  
