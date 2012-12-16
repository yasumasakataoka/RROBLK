truncate table ctltablEhasflgsrules ;


INSERT INTO ctltablEhasflgsrules (tablename,nst_flgs)
values ('MSTITEMS',nstflgs(typflg(null,null,null,null,null,null,null,null,null,null,null,null)))
;

INSERT INTO 
  TABLE (select nst_flgS from ctltablEhasflgsrules WHERE TABLENAME = 'MSTITEMS') 
 (ID, CTLFLGSCODE,flgsgroup,Nst_Options,Default_Value_CtlRule_id,nst_flgaliasnames ) 
 VALUES(null,'10',null,null,1
  ,nstflgaliasnames(TypFlgAliasName(null,null,null,null,null,null,null,null,null,null )))
; 

INSERT INTO 
  TABLE (select nst_flgS from ctltablEhasflgsrules WHERE TABLENAME = 'MSTITEMS') 
 (ID, CTLFLGSCODE,flgsgroup,Nst_Options,Default_Value_CtlRule_id,nst_flgaliasnames )
  VALUES(null,'20',null,null,1
  ,nstflgaliasnames(TypFlgAliasName(null,null,null,null,null,null,null,null,null,null )))
; 

INSERT INTO 
  TABLE (select nst_flgS from ctltablEhasflgsrules WHERE TABLENAME = 'MSTITEMS') 
 (ID, CTLFLGSCODE,flgsgroup,Nst_Options,Default_Value_CtlRule_id,nst_flgaliasnames )
 VALUES(null,'30',null,null,1
  ,nstflgaliasnames(TypFlgAliasName(null,null,null,null,null,null,null,null,null,null )))
; 


INSERT INTO 
  table(select Nst_FlgAliasNames from 
        TABLE (select nst_flgS from ctltablEhasflgsrules WHERE TABLENAME = 'MSTITEMS')
        where ctlflgscode = '10') 
 (MstUserGroupsCode,AliasName,AbbreviatedAliasName) 
  VALUES(null,'stock taking yes or not','stk flg')
;
INSERT INTO 
  table(select Nst_FlgAliasNames from 
        TABLE (select nst_flgS from ctltablEhasflgsrules WHERE TABLENAME = 'MSTITEMS')
        where ctlflgscode = '20') 
 (MstUserGroupsCode,AliasName,AbbreviatedAliasName) 
  VALUES(null,'name can be change or not','name flex')
;


INSERT INTO 
  table(select Nst_FlgAliasNames from 
        TABLE (select nst_flgS from ctltablEhasflgsrules WHERE TABLENAME = 'MSTITEMS')
        where ctlflgscode = '30') 
 (MstUserGroupsCode,AliasName,AbbreviatedAliasName) 
  VALUES(null,'picking list need or not','picking')
;



select ctltablEhasflgsrules.TABLENAME, NST_FLGS.CTLFLGSCODE ,Nst_FlgAliasNames.AliasName
from ctltablEhasflgsrules ,TABLE(ctltablEhasflgsrules.NST_FLGS) NST_FLGS,table(NST_FLGS.Nst_FlgAliasNames ) Nst_FlgAliasNames 
WHERE  aliasname is not null

create or replace view v_test1 as
select ctltablEhasflgsrules.ID, ctltablEhasflgsrules.TABLENAME,
 NST_FLGS.CTLFLGSCODE ,Nst_FlgAliasNames.AliasName
from ctltablEhasflgsrules ,TABLE(ctltablEhasflgsrules.NST_FLGS) NST_FLGS,table(NST_FLGS.Nst_FlgAliasNames ) Nst_FlgAliasNames 

 SELECT * FROM v_test1 

insert into v_test1 values(NULL,'MSTITEM','10','TEST')  ---- NG

INSERT INTO ctltablEhasflgsrules (tablename) values ('YYYY')
UPDATE  ctltablEhasflgsrules 
 SET NST_FLGS = nstflgs(typflg(null,NULL,null,null,null,null,null,null,null,null,null))
WHERE TABLENAME = 'YYYY'


