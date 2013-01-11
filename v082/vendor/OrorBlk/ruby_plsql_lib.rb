  require "rubygems"
  require "ruby-plsql"
  require 'json'


  plsql.connection = OCI8.new("rails","tq6t7rjx","xe")
  JSON.generate(data)

plsql.execute <<-SQL
 CREATE OR REPLACE FUNCTION  test_ref(str char)
 RETURN ref typperson
 as
----  person_ref NUMBER;
      person_ref REF typperson;
BEGIN 
  SELECT ref(p) INTO person_ref
    FROM mstpersons p 
    WHERE p.mstpersonscode = str
    AND Expiredate IS NULL; 
   RETURN     person_ref;
END;
SQL
# plsql.test_ref("RYO")
##################################################
########## cursor 
#################################
# plsql.execute <<-SQL
# CREATE OR REPLACE FUNCTION  all_purpose_cursor(str varchar2)
# RETURN SYS_REFCURSOR
# IS
#  l_cursor SYS_REFCURSOR;
# sqlstr varchar2(2000);
# BEGIN
# sqlstr :=   ' OPEN l_cursor FOR ' || str ;
# EXECUTE IMMEDIATE sqlstr;
# RETURN l_cursor;
# END;
# SQL

plsql.execute <<-SQL
CREATE OR REPLACE FUNCTION  allm_cursor(str varchar2)
RETURN SYS_REFCURSOR
IS
l_cursor SYS_REFCURSOR;
sqlstr varchar2(2000);
BEGIN
 OPEN l_cursor FOR  str ;
RETURN l_cursor;
END;
SQL

