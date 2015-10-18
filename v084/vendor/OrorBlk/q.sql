select * from r_screenfields where pobject_code_scr = 'r_rubycodings'
;
select * from screenfields where blktbsfieldcodes_id is null
;

select * from pobjects
where id in(
select pobjects_id_sfd from screenfields where blktbsfieldcodes_id is null)
;



update screenfields a
set  blktbsfieldcodes_id = (select m.id from r_blktbsfieldcodes m ,sfd_pobjects b
                          where pobject_code_tbl = STRTOKEN(b.pobject_code,'_',1)||'s'
						  and pobject_code_fld = STRTOKEN(b.pobject_code,'_',2)
						  and a.pobjects_id_sfd = b.id)
where blktbsfieldcodes_id is null
;

update screenfields a
set  blktbsfieldcodes_id = (select m.id from r_blktbsfieldcodes m ,sfd_pobjects b
                          where pobject_code_tbl = STRTOKEN(b.pobject_code,'_',1)||'s'
						  and pobject_code_fld = STRTOKEN(b.pobject_code,'_',2)||'_'||STRTOKEN(b.pobject_code,'_',3)
						  and a.pobjects_id_sfd = b.id)
where blktbsfieldcodes_id is null
;

update screenfields a
set  blktbsfieldcodes_id = (select m.id from r_blktbsfieldcodes m ,sfd_pobjects b
                          where pobject_code_tbl = STRTOKEN(b.pobject_code,'_',1)||'s'
						  and pobject_code_fld = STRTOKEN(b.pobject_code,'_',2)||'_'||STRTOKEN(b.pobject_code,'_',3)
						  and a.pobjects_id_sfd = b.id)
where blktbsfieldcodes_id is null
;

update screenfields a
set  blktbsfieldcodes_id = (select m.id from r_blktbsfieldcodes m ,sfd_pobjects b
                          where pobject_code_tbl = STRTOKEN(b.pobject_code,'_',1)||'s'
						  and pobject_code_fld = STRTOKEN(b.pobject_code,'_',2)||'s_'||STRTOKEN(b.pobject_code,'_',3)
						  and a.pobjects_id_sfd = b.id)
where blktbsfieldcodes_id is null
;

update screenfields a
set  blktbsfieldcodes_id = (select m.id from r_blktbsfieldcodes m ,sfd_pobjects b
                          where pobject_code_tbl = STRTOKEN(b.pobject_code,'_',1)||'s'
						  and pobject_code_fld = STRTOKEN(b.pobject_code,'_',2)||'s_'||STRTOKEN(b.pobject_code,'_',3)||'_'||STRTOKEN(b.pobject_code,'_',4)
						  and a.pobjects_id_sfd = b.id)
where blktbsfieldcodes_id is null
;



update screenfields a
set  blktbsfieldcodes_id = (select m.id from r_blktbsfieldcodes m ,sfd_pobjects b
                          where pobject_code_tbl = STRTOKEN(b.pobject_code,'_',1)||'s'
						  and pobject_code_fld = STRTOKEN(b.pobject_code,'_',2)||'s_'||STRTOKEN(b.pobject_code,'_',3)||'_'||STRTOKEN(b.pobject_code,'_',4)||'_'||STRTOKEN(b.pobject_code,'_', 5)
						  and a.pobjects_id_sfd = b.id)
where blktbsfieldcodes_id is null
;
update screenfields a
set  blktbsfieldcodes_id = (select m.id from r_blktbsfieldcodes m 
                          where pobject_code_tbl = 'screenfields'
						  and pobject_code_fld = 'id' )
where blktbsfieldcodes_id is null
and (select code from pobjects where id = a.pobjects_id_sfd) = 'id'
;

