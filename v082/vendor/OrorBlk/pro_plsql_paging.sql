CREATE OR REPLACE FUNCTION O2R_PAGING (viewname varchar,strwhere varchar,strorder varchar,
                                       str_r number,end_r number)
RETURN SYS_REFCURSOR
IS
l_cursor SYS_REFCURSOR;
strwhere1 varchar(256);
strwhere2 varchar(256);
strwhere3 varchar(256);
str_sql varchar(2000);
BEGIN
IF trim(strwhere) is null then
   strwhere1 := ' where rownum <= ' || to_char(end_r);
   strwhere2 := ' where rownum <= ' || to_char(end_r - str_r + 1);
   strwhere3 := ' where rownum <  ' || to_char(str_r);

  else
   strwhere1 := strwhere || ' and  rownum <= ' || to_char(end_r);
   strwhere2 := strwhere || ' and rownum <= ' || to_char(end_r - str_r + 1);
   strwhere3 := strwhere || ' and  rownum <  ' || to_char(str_r);
end if;
str_sql :=  'SELECT * FROM (SELECT * FROM (SELECT * FROM ' || viewname || ' ' || strorder
                                 ||      '  ) ' || strwhere1
                       || '  ) A '
          || strwhere2
          || ' AND NOT  EXISTS (SELECT 1 FROM (SELECT * FROM (SELECT * FROM '  || viewname || ' ' || strorder
                                                  ||        ' ) ' || strwhere3
                                          ||  ' ) B '
                                   || ' WHERE  A.ID = B.ID '
                           ||' ) ' ;

OPEN l_cursor FOR str_sql;
RETURN l_cursor;
END;