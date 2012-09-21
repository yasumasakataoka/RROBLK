truncate table ctltablEhasflgsrules ;


INSERT INTO ctltablEhasflgsrules (tablename,nst_flgs)
values ('MSTITEMS',nstflgs(typflg(null,null,null,null,null,null,null,null,null,null,null)))
;

INSERT INTO 
  TABLE (select nst_flgS from ctltablEhasflgsrules WHERE TABLENAME = 'MSTITEMS') 
 (ID, CTLFLGSCODE,flgsgroup,Nst_Options,nst_flgaliasnames ) 
 VALUES(null,'10',null,null
  ,nstflgaliasnames(TypFlgAliasName(null,null,null,null,null,null,null,null,null,null )))
; 

INSERT INTO 
  TABLE (select nst_flgS from ctltablEhasflgsrules WHERE TABLENAME = 'MSTITEMS') 
 (ID, CTLFLGSCODE,flgsgroup,Nst_Options,nst_flgaliasnames )
  VALUES(null,'20',null,null
  ,nstflgaliasnames(TypFlgAliasName(null,null,null,null,null,null,null,null,null,null )))
; 

INSERT INTO 
  TABLE (select nst_flgS from ctltablEhasflgsrules WHERE TABLENAME = 'MSTITEMS') 
 (ID, CTLFLGSCODE,flgsgroup,Nst_Options,nst_flgaliasnames )
 VALUES(null,'30',null,null
  ,nstflgaliasnames(TypFlgAliasName(null,null,null,null,null,null,null,null,null,null )))
; 


INSERT INTO 
  table(select Nst_FlgAliasNames from 
        TABLE (select nst_flgS from ctltablEhasflgsrules WHERE TABLENAME = 'MSTITEMS')
        where ctlflgscode = '10') 
 (MstUserGroupsCode,AliasName,AbbreviatedAliasName) 
  VALUES(null,'stock taking yes or not','stk_flg')
;
INSERT INTO 
  table(select Nst_FlgAliasNames from 
        TABLE (select nst_flgS from ctltablEhasflgsrules WHERE TABLENAME = 'MSTITEMS')
        where ctlflgscode = '20') 
 (MstUserGroupsCode,AliasName,AbbreviatedAliasName) 
  VALUES(null,'name can be change or not','name_flex')
;
INSERT INTO 
  table(select Nst_FlgAliasNames from 
        TABLE (select nst_flgS from ctltablEhasflgsrules WHERE TABLENAME = 'MSTITEMS')
        where ctlflgscode = '30') 
 (MstUserGroupsCode,AliasName,AbbreviatedAliasName) 
  VALUES(null,'picking list need or not','picking')
;

