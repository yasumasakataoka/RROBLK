drop sequence Nst_PreFields_Screen_seq
;  
create sequence Nst_PreFields_Screen_seq
;  
CREATE OR REPLACE  function BLK_SEQ(STR_SEQ varchar)
          RETURN NUMBER IS
          W_ID NUMBER;
          SQL_STR VARCHAR(256);
BEGIN
     SQL_STR := 'select ' || STR_SEQ || '_SEQ.nextval from dual ' ;
     EXECUTE IMMEDIATE SQL_STR into W_ID;
     RETURN W_ID;
end;
/ 

select * from USER_NESTED_TABLE_COLS
where TABLE_NAME like  'NST_PREFIELDS_SCREEN%'
USER_NESTED_TABLES,TABLE_NAME,PARENT_TABLE_NAME,parent_table_name
select BLK_SEQ('Nst_PreFields_Screen') from dual
select Nst_PreFields_Screen_SEQ.nextval  W_ID from dual 

drop TRIGGER  TRISEQ_NST_PREFIELDS_SCREEN

plsql.o2r_get_nstfields("NST_PREFIELDS_SCREEN")

pare_tbl_name = plsql.USER_NESTED_TABLES.first("where TABLE_NAME = :1","NST_PREFIELDS_SCREEN")[:parent_table_name]