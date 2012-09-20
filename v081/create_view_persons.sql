create or replace view  r_persons as
select a.id,a.code person_code,a.name person_name,
   b.id usergroup_id,usergroup_code,usergroup_name,
   a.email person_email
from persons a,r_usergroups b
where a.expiredate > sysdate
and a.id = b.person_id_upd

select * from persons