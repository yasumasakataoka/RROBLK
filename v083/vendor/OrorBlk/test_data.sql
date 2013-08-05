select * from persons

delete from persons

insert into persons(id,code,name,remark,expiredate,
                    persons_id_upd,USERGROUPS_ID)
values(1,1,'a','rm1','2020/12/31',1,1)

insert into persons(id,code,name,remark,expiredate,
                    persons_id_upd,USERGROUPS_ID)
values(2,2,'b','rm2','2020/12/31',1,1)

create or replace view r_persons as
select persons.id id,
       persons.code person_code,
       persons.name person_name,persons.remark person_remark,
       persons.expiredate,persons.update_ip,
       persons.created_at,persons.updated_at,
       persons_upd.code person_code_upd,
       persons_upd.name person_name_upd,
       persons_upd.remark remark_upd,
       persons_upd.expiredate expiredate_upd
from persons persons,persons persons_upd
where persons.id = persons_upd.id


create or replace view r_UserGroups as
select UserGroups.id id,
------- person_cod ‚É‚·‚é‚ÆŽ©“®omit‚³‚ê‚é‚Ì‚Å
       persons.code user_code,
       UserGroups.code UserGroup_code,
        UserGroups.name  UserGroup_name,
        UserGroups.remark  UserGroup_remark,
        UserGroups.expiredate UserGroups_expiredate
from persons persons,UserGroups UserGroups
where UserGroups.id = persons.UserGroups_id

select * from UserGroups

insert into USERGROUPS(id,code,name,remark,expiredate,
                    persons_id_upd)
values(1,000,'DEFAULT','rm2','2020/12/31',1)