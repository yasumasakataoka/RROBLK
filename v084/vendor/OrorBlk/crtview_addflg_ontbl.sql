create or replace view vaddflg_on_tbl as 
select ctltablEhasflgsrules.TABLENAME, NST_FLGS.CTLFLGSCODE ,Nst_FlgAliasNames.AliasName,
      Default_Value_CtlRule_id,AbbreviatedAliasName
from ctltablEhasflgsrules ,TABLE(ctltablEhasflgsrules.NST_FLGS) NST_FLGS,table(NST_FLGS.Nst_FlgAliasNames ) Nst_FlgAliasNames 
WHERE  AbbreviatedAliasName is not null


