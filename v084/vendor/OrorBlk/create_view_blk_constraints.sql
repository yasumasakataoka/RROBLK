create view blk_constraints as
select
 c.table_name, c.constraint_name, c.constraint_type,
 cc.position, cc.column_name
from user_constraints c, user_cons_columns cc
where c.table_name      = cc.table_name
  and c.constraint_name = cc.constraint_name
;






select * from blk_constraints where table_name ='SCREENFIELDS'
;
alter table screenfields drop constraint SCREENFIELDS_41_UK
;
