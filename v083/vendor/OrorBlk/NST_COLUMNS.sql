CREATE OR REPLACE FUNCTION o2r_get_nstfields (NST_TABLE_NAME VARCHAR)
RETURN SYS_REFCURSOR
IS
l_cursor SYS_REFCURSOR;
str_sql VARCHAR(256);

BEGIN
str_sql :=  'select * from USER_NESTED_TABLE_COLS where  table_name = :1';

OPEN l_cursor FOR str_sql using NST_TABLE_NAME ;
RETURN l_cursor;
END;

