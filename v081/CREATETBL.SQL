DROP TABLE CustFrcs
;
CREATE TABLE CustFrcs
  ( id numeric(38)
  ,Custs_id numeric(38)
  ,itms_id numeric(38)
  ,Sno Varchar(40)
  ,LineNo numeric(4)
  ,Persons_id_Chrg numeric(38)
  ,Duedate timestamp
  ,Frcdate timestamp
  ,QTY numeric(16,4)
  ,Price numeric(16,4)
  ,Amt numeric(16,4)
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE CustPlns
;
CREATE TABLE CustPlns
  ( id numeric(38)
  ,Custs_id numeric(38)
  ,itms_id numeric(38)
  ,Sno Varchar(40)
  ,LineNo numeric(4)
  ,Persons_id_Chrg numeric(38)
  ,Duedate timestamp
  ,Plndate timestamp
  ,QTY numeric(16,4)
  ,Price numeric(16,4)
  ,Amt numeric(16,4)
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE CustOrds
;
CREATE TABLE CustOrds
  ( id numeric(38)
  ,Custs_id numeric(38)
  ,itms_id numeric(38)
  ,Persons_id_Chrg numeric(38)
  ,Duedate timestamp
  ,OrdsDate timestamp
  ,QTY numeric(16,4)
  ,Price numeric(16,4)
  ,Amt numeric(16,4)
  ,Sno Varchar(40)
  ,LineNo numeric(4)
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT CustOrds_id_pk PRIMARY KEY (id)
  , CONSTRAINT CustOrds_70_uk  UNIQUE (SNO,LINENO,ID)
  , CONSTRAINT CustOrds_71_uk  UNIQUE (CUSTS_ID,ID)
  , CONSTRAINT CustOrds_72_uk  UNIQUE (ITMS_ID,ID)
  , CONSTRAINT CustOrds_73_uk  UNIQUE (Duedate,ID)
)
;
drop sequence CustOrds_seq
;  
create sequence CustOrds_seq
;  

; 
DROP TABLE CustInsts
;
CREATE TABLE CustInsts
  ( id numeric(38)
  ,CustOrds_id numeric(38)
  ,CustRCVPlcs_id numeric(38)
  ,Duedate timestamp
  ,Instdate timestamp
  ,QTY numeric(16,4)
  ,Price numeric(16,4)
  ,Amt numeric(16,4)
  ,Sno Varchar(40)
  ,LineNo numeric(4)
  ,Persons_id_Chrg numeric(38)
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,Persons_id_Upd numeric(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT CustInsts_id_pk PRIMARY KEY (id)
  , CONSTRAINT CustInsts_99_uk  UNIQUE (SNO,LINENO,ID)
  , CONSTRAINT CustInsts_100_uk  UNIQUE (CustOrds_ID,ID)
  , CONSTRAINT CustInsts_101_uk  UNIQUE (Duedate,ID)
)
;
drop sequence CustInsts_seq
;  
create sequence CustInsts_seq
;  
; 
; 
; 
DROP TABLE CustActs
;
CREATE TABLE CustActs
  ( id numeric(38)
  ,CustInsts_id numeric(38)
  ,Actdate timestamp
  ,Inputdate timestamp
  ,QTY numeric(16,4)
  ,Price numeric(16,4)
  ,Amt numeric(16,4)
  ,Sno Varchar(40)
  ,LineNo numeric(4)
  ,Persons_id_Chrg numeric(38)
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,Persons_id_Upd numeric(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE ShpSchs
;
CREATE TABLE ShpSchs
  ( id numeric(38)
  ,CustIns_id_PARE numeric(38)
  ,PurOrds_id_PARE numeric(38)
  ,PrcOrds_id_PARE numeric(38)
  ,PurSCHs_id_PARE numeric(38)
  ,PrcSCHs_id_PARE numeric(38)
  ,ShpOrds_id numeric(38)
  ,Depdate timestamp
  ,Arrdate timestamp
  ,locas_id_from numeric(38)
  ,locas_id_to numeric(38)
  ,QTY numeric(16,4)
  ,Carton numeric(4)
  ,weight numeric(16,4)
  ,volume numeric(16,4)
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE ShpOrds
;
CREATE TABLE ShpOrds
  ( id numeric(38)
  ,Sno Varchar(40)
  ,LineNo numeric(4)
  ,OrdsDate timestamp
  ,OrdNo Varchar(40)
  ,Duedate timestamp
  ,QTY numeric(16,4)
  ,weight numeric(16,4)
  ,volume numeric(16,4)
  ,Carton numeric(4)
  ,Remark varchar(200)
  ,Persons_id_Chrg numeric(38)
  ,Persons_id_Upd numeric(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE ShpInsts
;
CREATE TABLE ShpInsts
  ( id numeric(38)
  ,Sno Varchar(40)
  ,LineNo numeric(4)
  ,ShpOrds_id numeric(38)
  ,Duedate timestamp
  ,QTY numeric(16,4)
  ,weight numeric(16,4)
  ,volume numeric(16,4)
  ,Carton numeric(4)
  ,Remark varchar(200)
  ,Transport_id varchar(200)
  ,Persons_id_Chrg numeric(38)
  ,Persons_id_Upd numeric(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE ShpActs
;
CREATE TABLE ShpActs
  ( id numeric(38)
  ,Sno Varchar(40)
  ,LineNo numeric(4)
  ,ShpInsts_id numeric(38)
  ,Transport_id numeric(38)
  ,Actdate timestamp
  ,Inputdate timestamp
  ,QTY numeric(16,4)
  ,Persons_id_Chrg numeric(38)
  ,weight numeric(16,4)
  ,volume numeric(16,4)
  ,Carton numeric(4)
  ,Remark varchar(200)
  ,Persons_id_Chrg numeric(38)
  ,Persons_id_Upd numeric(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE PrcFrcs
;
CREATE TABLE PrcFrcs
  ( id numeric(38)
  ,Opeitms_id numeric(38)
  ,Sno Varchar(40)
  ,LineNo numeric(4)
  ,Persons_id_Chrg numeric(38)
  ,Duedate timestamp
  ,Frcdate timestamp
  ,QTY numeric(16,4)
  ,Price numeric(16,4)
  ,Amt numeric(16,4)
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE PrcPlns
;
CREATE TABLE PrcPlns
  ( id numeric(38)
  ,Opeitms_id numeric(38)
  ,PrcSchs_id numeric(38)
  ,Sno Varchar(40)
  ,LineNo numeric(4)
  ,Persons_id_Chrg numeric(38)
  ,Duedate timestamp
  ,Plndate timestamp
  ,QTY numeric(16,4)
  ,Price numeric(16,4)
  ,Amt numeric(16,4)
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE PrcSCHs
;
CREATE TABLE PrcSCHs
  ( id numeric(38)
  ,CustORDs_id_PARE numeric(38)
  ,PurOrds_id_PARE numeric(38)
  ,PrcOrds_id_PARE numeric(38)
  ,ShpOrds_id_PARE numeric(38)
  ,PurSCHs_id_PARE numeric(38)
  ,ShpSCHs_id_PARE numeric(38)
  ,PrcSCHs_id_PARE numeric(38)
  ,PrcOrds_id numeric(38)
  ,Persons_id_Chrg numeric(38)
  ,Duedate timestamp
  ,QTY numeric(16,4)
  ,Remark varchar(200)
  ,Persons_id_Chrg numeric(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE PrcOrds
;
CREATE TABLE PrcOrds
  ( id numeric(38)
  ,Sno Varchar(40)
  ,LineNo numeric(4)
  ,Opeitms_id numeric(38)
  ,Persons_id_Chrg numeric(38)
  ,OrdsDate timestamp
  ,Duedate timestamp
  ,QTY numeric(16,4)
  ,Price numeric(16,4)
  ,Amt numeric(16,4)
  ,Remark varchar(200)
  ,Persons_id_Chrg numeric(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE PrcInsts
;
CREATE TABLE PrcInsts
  ( id numeric(38)
  ,Sno Varchar(40)
  ,LineNo numeric(4)
  ,PrcOrds_id numeric(38)
  ,Persons_id_Chrg numeric(38)
  ,INSTdate timestamp
  ,Duedate timestamp
  ,QTY numeric(16,4)
  ,Price numeric(16,4)
  ,Amt numeric(16,4)
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE PrcActs
;
CREATE TABLE PrcActs
  ( id numeric(38)
  ,Sno Varchar(40)
  ,LineNo numeric(4)
  ,PrcInsts_id numeric(38)
  ,Persons_id_Chrg numeric(38)
  ,Actdate timestamp
  ,Inputdate timestamp
  ,QTY numeric(16,4)
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TYPE TypPerson force 
; 
CREATE TYPE TypPerson AS OBJECT  
  ( id numeric(38)
  ,Code varchar(10)
  ,Name VARCHAR(50)
  ,UserGroups_id numeric(38)
  ,Sects_id numeric(38)
  ,Email VARCHAR(50)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE Persons
;
CREATE TABLE Persons OF  TypPerson
  (  CONSTRAINT Persons_id_pk PRIMARY KEY (id)
  , CONSTRAINT Persons_22_uk  UNIQUE (Code,Expiredate)
)
;
drop sequence Persons_seq
;  
create sequence Persons_seq
;  
; 
DROP TYPE TypUserGroup force 
; 
CREATE TYPE TypUserGroup AS OBJECT  
  ( id numeric(38)
  ,Code numeric(38)
  ,Name varchar(20)
  ,Remark VARCHAR(100)
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  ,Expiredate date
)
;
DROP TABLE UserGroups
;
CREATE TABLE UserGroups OF  TypUserGroup
  (  CONSTRAINT UserGroups_id_pk PRIMARY KEY (id)
  , CONSTRAINT UserGroups_45_uk  UNIQUE (Code,Expiredate)
)
;
drop sequence UserGroups_seq
;  
create sequence UserGroups_seq
;  
; 
DROP TYPE TypCurrency force 
; 
CREATE TYPE TypCurrency AS OBJECT  
  ( id numeric(38)
  ,Code varchar(3)
  ,Name varchar(10)
  ,PriceDecimal numeric(1)
  ,AmtDecimal numeric(1)
  ,Remark VARCHAR(100)
  ,Persons_id_Upd numeric(38)
  ,ExpireDate date
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE Currencys
;
CREATE TABLE Currencys OF  TypCurrency
  (  CONSTRAINT Currencys_id_pk PRIMARY KEY (id)
)
;
drop sequence Currencys_seq
;  
create sequence Currencys_seq
;  
DROP TYPE TypClndr force 
; 
CREATE TYPE TypClndr AS OBJECT  
  ( id numeric(38)
  ,Code varchar(10)
  ,Name VARCHAR(100)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE Clndrs
;
CREATE TABLE Clndrs OF  TypClndr
  (  CONSTRAINT Clndrs_id_pk PRIMARY KEY (id)
  , CONSTRAINT Clndrs_91_uk  UNIQUE (Code,Expiredate)
)
;
drop sequence Clndrs_seq
;  
create sequence Clndrs_seq
;  
; 
DROP TYPE TypCalendarDetail force 
; 
CREATE TYPE TypCalendarDetail AS OBJECT  
  ( id numeric(38)
  ,Clndrs_id numeric(38)
  ,FromHM date
  ,ToHM date
  ,Persons_id_Upd numeric(38)
  ,Remark VARCHAR(100)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE CalendarDetails
;
CREATE TABLE CalendarDetails OF  TypCalendarDetail
  (  CONSTRAINT CalendarDetails_id_pk PRIMARY KEY (id)
  , CONSTRAINT CalendarDetails_114_uk  UNIQUE (Clndrs_id,FromHM)
)
;
drop sequence CalendarDetails_seq
;  
create sequence CalendarDetails_seq
;  
; 
DROP TYPE TypUnit force 
; 
CREATE TYPE TypUnit AS OBJECT  
  ( id numeric(38)
  ,Code varchar(3)
  ,Name varchar(10)
  ,Remark VARCHAR(100)
  ,Persons_id_Upd numeric(38)
  ,ExpireDate date
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE Units
;
CREATE TABLE Units OF  TypUnit
  (  CONSTRAINT Units_id_pk PRIMARY KEY (id)
  , CONSTRAINT Units_136_uk  UNIQUE (Code,ExpireDate)
)
;
drop sequence Units_seq
;  
create sequence Units_seq
;  
; 
DROP TYPE TypLang force 
; 
CREATE TYPE TypLang AS OBJECT  
  ( id numeric(38)
  ,Code varchar(3)
  ,Name varchar(10)
  ,Remark VARCHAR(100)
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  ,Expiredate date
)
;
DROP TABLE Langs
;
CREATE TABLE Langs OF  TypLang
  (  CONSTRAINT Langs_id_pk PRIMARY KEY (id)
)
;
drop sequence Langs_seq
;  
create sequence Langs_seq
;  
DROP TYPE TypNameUnit force 
; 
CREATE TYPE TypNameUnit AS OBJECT  
  ( id numeric(38)
  ,Units_id numeric(38)
  ,Langs_id numeric(38)
  ,UnitName varchar(10)
  ,Remark VARCHAR(100)
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  ,Expiredate date
)
;
DROP TABLE NameUnits
;
CREATE TABLE NameUnits OF  TypNameUnit
  (  CONSTRAINT NameUnits_id_pk PRIMARY KEY (id)
)
;
drop sequence NameUnits_seq
;  
create sequence NameUnits_seq
;  
DROP TYPE TypResource force 
; 
CREATE TYPE TypResource AS OBJECT  
  ( id numeric(38)
  ,ResourceName varchar(40)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
)
;
DROP TABLE ProcNames
;
CREATE TABLE ProcNames OF  TypProcName
  (  CONSTRAINT ProcNames_id_pk PRIMARY KEY (id)
)
;
drop sequence ProcNames_seq
;  
create sequence ProcNames_seq
;  
DROP TYPE TypProcname force 
; 
CREATE TYPE TypProcname AS OBJECT  
  ( id numeric(38)
  ,Code varchar(5)
  ,Name varchar(20)
  ,Remark VARCHAR(100)
  ,Persons_id_Upd numeric(38)
  ,ExpireDate date
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE ProcNames
;
CREATE TABLE ProcNames OF  TypProcName
  (  CONSTRAINT ProcNames_id_pk PRIMARY KEY (id)
)
;
drop sequence ProcNames_seq
;  
create sequence ProcNames_seq
;  
DROP TYPE TypTransport force 
; 
CREATE TYPE TypTransport AS OBJECT  
  ( id numeric(38)
  ,Code varchar(3)
  ,Name varchar(20)
  ,Remark VARCHAR(100)
  ,Persons_id_Upd numeric(38)
  ,ExpireDate date
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE Transports
;
CREATE TABLE Transports OF  TypTransport
  (  CONSTRAINT Transports_id_pk PRIMARY KEY (id)
)
;
drop sequence Transports_seq
;  
create sequence Transports_seq
;  
DROP TYPE TypFObject force 
; 
CREATE TYPE TypFObject AS OBJECT  
  ( id numeric(38)
  ,PObjects_id numeric(38)
  ,Fieldlength NUMBER(4) 
  ,DataPresion NUMBER(2) 
  ,DataScale NUMBER(2) 
  ,Persons_id_Upd numeric(38)
  ,FieldDenomination varchar(40)
  ,Contens VARCHAR(200)
  ,Remark VARCHAR(200)
  ,Update_IP varchar(40)
  ,created_at date
  ,Expiredate date
  ,updated_at date
)
;
DROP TABLE FObjects
;
CREATE TABLE FObjects OF  TypFObject
  (  CONSTRAINT FObjects_id_pk PRIMARY KEY (id)
)
;
drop sequence FObjects_seq
;  
create sequence FObjects_seq
;  
DROP TYPE TypFOBJGrp force 
; 
CREATE TYPE TypFOBJGrp AS OBJECT  
  ( id numeric(38)
  ,FObjects_id numeric(38)
  ,Name varchar(30)
  ,UserGroups_id numeric(38)
  ,Remark VARCHAR(200)
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Expiredate date
  ,updated_at date
)
;
DROP TABLE FOBJGrpS
;
CREATE TABLE FOBJGrpS OF  TypFOBJGrp
  (  CONSTRAINT FOBJGrpS_id_pk PRIMARY KEY (id)
)
;
drop sequence FOBJGrpS_seq
;  
create sequence FOBJGrpS_seq
;  
DROP TYPE TypPObject force 
; 
CREATE TYPE TypPObject AS OBJECT  
  ( id numeric(38)
  ,ObjectType varchar(20)
  ,Code varchar(30)
  ,Contens VARCHAR(200)
  ,Remark VARCHAR(200)
  ,RubyCode clob
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Expiredate date
  ,Updated_at date
)
;
DROP TABLE PObjects
;
CREATE TABLE PObjects OF  TypPObject
  (  CONSTRAINT PObjects_id_pk PRIMARY KEY (id)
  , CONSTRAINT PObjects_69_uk  UNIQUE (code,ObjectType,Expiredate)
)
;
drop sequence PObjects_seq
;  
create sequence PObjects_seq
;  
; 
DROP TYPE TypPOBJGrp force 
; 
CREATE TYPE TypPOBJGrp AS OBJECT  
  ( id numeric(38)
  ,PObjects_id numeric(38)
  ,UserGroups_id numeric(38)
  ,Name varchar(30)
  ,Remark VARCHAR(200)
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Expiredate date
  ,Updated_at date
)
;
DROP TABLE POBJGrpS
;
CREATE TABLE POBJGrpS OF  TypPOBJGrp
  (  CONSTRAINT POBJGrpS_id_pk PRIMARY KEY (id)
)
;
drop sequence POBJGrpS_seq
;  
create sequence POBJGrpS_seq
;  
DROP TYPE TypBottonRule force 
; 
CREATE TYPE TypBottonRule AS OBJECT  
  ( id numeric(38)
  ,Object_id_Upd numeric(38)
  ,Code varchar(30)
  ,Name varchar(30)
  ,RuleComment VARCHAR(100)
  ,Remark VARCHAR(100)
  ,ExpireDate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,updated_at date
)
;
DROP TABLE BottonRules
;
CREATE TABLE BottonRules OF  TypBottonRule
  (  CONSTRAINT BottonRules_id_pk PRIMARY KEY (id)
)
;
drop sequence BottonRules_seq
;  
create sequence BottonRules_seq
;  
DROP TYPE TypOptionAiasName force 
; 
CREATE TYPE TypOptionAiasName AS OBJECT  
  ( id numeric(38)
  ,UserGroups_id numeric(38)
  ,Code varchar(30)
  ,AliasName VARCHAR(100)
  ,Remark VARCHAR(100)
  ,ExpireDate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,updated_at date
)
;
DROP TABLE OptionAiasNames
;
CREATE TABLE OptionAiasNames OF  TypOptionAiasName
  (  CONSTRAINT OptionAiasNames_id_pk PRIMARY KEY (id)
)
;
drop sequence OptionAiasNames_seq
;  
create sequence OptionAiasNames_seq
;  
DROP TYPE TypFlg force 
; 
CREATE TYPE TypFlg AS OBJECT  
  ( id numeric(38)
  ,TblHasFlgsRules_id numeric(38)
  ,Code varchar(10)
  ,FlgsGroup varchar(10)
  ,RubyCode clob
  ,Remark VARCHAR(100)
  ,ExpireDate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,updated_at date
)
;
DROP TABLE Flgs
;
CREATE TABLE Flgs OF  TypFlg
  (  CONSTRAINT Flgs_id_pk PRIMARY KEY (id)
)
;
drop sequence Flgs_seq
;  
create sequence Flgs_seq
;  
DROP TYPE TypTblHasFlgsRule force 
; 
CREATE TYPE TypTblHasFlgsRule AS OBJECT  
  ( id numeric(38)
  ,TableName varchar(30)
  ,Contens VARCHAR(200)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
)
;
DROP TABLE TblHasFlgsRules
;
CREATE TABLE TblHasFlgsRules OF  TypTblHasFlgsRule
  (  CONSTRAINT TblHasFlgsRules_id_pk PRIMARY KEY (id)
)
;
drop sequence TblHasFlgsRules_seq
;  
create sequence TblHasFlgsRules_seq
;  
DROP TYPE TypLoca force 
; 
CREATE TYPE TypLoca AS OBJECT  
  ( id numeric(38)
  ,Code varchar(10)
  ,Name VARCHAR(100)
  ,ABBR varchar(50)
  ,zip varchar(10)
  ,country varchar(20)
  ,PRFCT varchar(20)
  ,addr1 VARCHAR(50)
  ,addr2 VARCHAR(50)
  ,Tel varchar(20)
  ,Fax varchar(20)
  ,mail varchar(20)
  ,ProPucr char(1)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE Locas
;
CREATE TABLE Locas OF  TypLoca
  (  CONSTRAINT Locas_id_pk PRIMARY KEY (id)
  , CONSTRAINT Locas_28_uk  UNIQUE (Code,Expiredate)
)
;
drop sequence Locas_seq
;  
create sequence Locas_seq
;  
; 
DROP TYPE TypInvP force 
; 
CREATE TYPE TypInvP AS OBJECT  
  ( id numeric(38)
  ,Locas_id_InvP numeric(38)
  ,Persons_id_Owner numeric(38)
  ,InvntMaxQTY numeric(10)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd varchar(10)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE InvPs
;
CREATE TABLE InvPs OF  TypInvP
  (  CONSTRAINT InvPs_id_pk PRIMARY KEY (id)
)
;
drop sequence InvPs_seq
;  
create sequence InvPs_seq
;  
DROP TYPE TypDELVCNTR force 
; 
CREATE TYPE TypDELVCNTR AS OBJECT  
  ( id numeric(38)
  ,InvP_id_DELVCNTR numeric(38)
  ,Persons_id_Owner numeric(38)
  ,DeliveryMaxQTY numeric(10)
  ,MaxWeight numeric(10)
  ,MaxPackQTY numeric(10)
  ,Clndrs_id numeric(38)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd varchar(10)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE DELVCNTRS
;
CREATE TABLE DELVCNTRS OF  TypDELVCNTR
  (  CONSTRAINT DELVCNTRS_id_pk PRIMARY KEY (id)
)
;
drop sequence DELVCNTRS_seq
;  
create sequence DELVCNTRS_seq
;  
DROP TYPE TypEntpr force 
; 
CREATE TYPE TypEntpr AS OBJECT  
  ( id numeric(38)
  ,Locas_id_Entpr varchar(10)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd varchar(10)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE Entprs
;
CREATE TABLE Entprs OF  TypEntpr
  (  CONSTRAINT Entprs_id_pk PRIMARY KEY (id)
)
;
drop sequence Entprs_seq
;  
create sequence Entprs_seq
;  
DROP TABLE EntprCusts
;
CREATE TABLE EntprCusts
  ( id numeric(38)
  ,Entprs_id numeric(38)
  ,Custs_id numeric(38)
  ,Expiredate date
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TYPE TypCustRCVPlc force 
; 
CREATE TYPE TypCustRCVPlc AS OBJECT  
  ( id numeric(38)
  ,Locas_id_CustRCVPlcs numeric(38)
  ,PersonNameOfOutside VARCHAR(100)
  ,Persons_id_Chrg numeric(38)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE CustRCVPlcs
;
CREATE TABLE CustRCVPlcs OF  TypCustRCVPlc
  (  CONSTRAINT CustRCVPlcs_id_pk PRIMARY KEY (id)
)
;
drop sequence CustRCVPlcs_seq
;  
create sequence CustRCVPlcs_seq
;  
DROP TYPE TypCust force 
; 
CREATE TYPE TypCust AS OBJECT  
  ( id numeric(38)
  ,Locas_id_Custs numeric(38)
  ,PersonNameOfCust VARCHAR(30)
  ,Persons_id_Chrg numeric(38)
  ,Currencys_id numeric(38)
  ,Remark VARCHAR(100)
  ,CustType char(1)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE Custs
;
CREATE TABLE Custs OF  TypCust
  (  CONSTRAINT Custs_id_pk PRIMARY KEY (id)
)
;
drop sequence Custs_seq
;  
create sequence Custs_seq
;  
DROP TYPE TypDealer force 
; 
CREATE TYPE TypDealer AS OBJECT  
  ( id numeric(38)
  ,Locas_id_Dealers numeric(38)
  ,Locas_id_Enterprise numeric(38)
  ,MaxAMT numeric(10)
  ,MinAMT numeric(10)
  ,Currencys_id numeric(38)
  ,PersonNameOfOutside VARCHAR(30)
  ,Persons_id_Chrg numeric(38)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE Dealers
;
CREATE TABLE Dealers OF  TypDealer
  (  CONSTRAINT Dealers_id_pk PRIMARY KEY (id)
)
;
drop sequence Dealers_seq
;  
create sequence Dealers_seq
;  
DROP TYPE TypOpeItm force 
; 
CREATE TYPE TypOpeItm AS OBJECT  
  ( id numeric(38)
  ,ProcessSeq numeric(4)
  ,Priority numeric(4)
  ,InvPs_id numeric(38)
  ,Itms_id numeric(38)
  ,LT numeric(10,2)
  ,Units_id_LTTime numeric(38)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE OpeItms
;
CREATE TABLE OpeItms OF  TypOpeItm
  (  CONSTRAINT OpeItms_id_pk PRIMARY KEY (id)
  , CONSTRAINT OpeItms_23_uk  UNIQUE (ProcessSeq,Priority,Itms_id,Expiredate)
)
;
drop sequence OpeItms_seq
;  
create sequence OpeItms_seq
;  
; 
DROP TYPE TypChilItm force 
; 
CREATE TYPE TypChilItm AS OBJECT  
  ( id numeric(38)
  ,OpeItms_id numeric(38)
  ,OpeItms_id_Chil numeric(38)
  ,PareNum numeric(10)
  ,ChiNum numeric(10)
  ,MinQty numeric(10)
  ,ConsumUnitQty numeric(10)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE ChilItms
;
CREATE TABLE ChilItms OF  TypChilItm
  (  CONSTRAINT ChilItms_id_pk PRIMARY KEY (id)
)
;
drop sequence ChilItms_seq
;  
create sequence ChilItms_seq
;  
DROP TYPE TypUseRsr force 
; 
CREATE TYPE TypUseRsr AS OBJECT  
  ( id numeric(38)
  ,OpeItms_id numeric(38)
  ,SeqNo numeric(2)
  ,Priority numeric(4)
  ,Resources_id numeric(38)
  ,ProcNames_id numeric(38)
  ,LoadTime numeric(10)
  ,Units_id_Time numeric(38)
  ,LoadTimeUnit numeric(10)
  ,PreLoadTime numeric(10)
  ,Units_id_Pre_Time numeric(38)
  ,PreLoadTimeUnit numeric(10)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE UseRsrs
;
CREATE TABLE UseRsrs OF  TypUseRsr
  (  CONSTRAINT UseRsrs_id_pk PRIMARY KEY (id)
)
;
drop sequence UseRsrs_seq
;  
create sequence UseRsrs_seq
;  
DROP TYPE TypManRsr force 
; 
CREATE TYPE TypManRsr AS OBJECT  
  ( id numeric(38)
  ,OpeItms_id numeric(38)
  ,Rsrname VARCHAR(100)
  ,LoadTime numeric(10)
  ,Units_id_Time numeric(38)
  ,LoadTimeUnit numeric(10)
  ,PreLoadTime numeric(10)
  ,Units_id_PreTime numeric(38)
  ,PreLoadTimeUnit numeric(10)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE ManRsrs
;
CREATE TABLE ManRsrs OF  TypManRsr
  (  CONSTRAINT ManRsrs_id_pk PRIMARY KEY (id)
)
;
drop sequence ManRsrs_seq
;  
create sequence ManRsrs_seq
;  
DROP TYPE TypPurchasePrc force 
; 
CREATE TYPE TypPurchasePrc AS OBJECT  
  ( id numeric(38)
  ,Itms_id numeric(38)
  ,Dealers_id numeric(38)
  ,Dealeritm varchar(40)
  ,Price numeric(10,4)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE PurchasePrcs
;
CREATE TABLE PurchasePrcs OF  TypPurchasePrc
  (  CONSTRAINT PurchasePrcs_id_pk PRIMARY KEY (id)
)
;
drop sequence PurchasePrcs_seq
;  
create sequence PurchasePrcs_seq
;  
DROP TYPE TypGdsPrc force 
; 
CREATE TYPE TypGdsPrc AS OBJECT  
  ( id numeric(38)
  ,Itms_id numeric(38)
  ,Custs_id numeric(38)
  ,Persons_id_Chrg numeric(38)
  ,CustProdName varchar(40)
  ,Price numeric(10,4)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE GdsPrcs
;
CREATE TABLE GdsPrcs OF  TypGdsPrc
  (  CONSTRAINT GdsPrcs_id_pk PRIMARY KEY (id)
)
;
drop sequence GdsPrcs_seq
;  
create sequence GdsPrcs_seq
;  
DROP TYPE TypItm force 
; 
CREATE TYPE TypItm AS OBJECT  
  ( id numeric(38)
  ,Code varchar(40)
  ,Name VARCHAR(100)
  ,Units_id numeric(38)
  ,Std VARCHAR(100)
  ,Model VARCHAR(100)
  ,Material VARCHAR(100)
  ,Design VARCHAR(100)
  ,Weight numeric(10,6)
  ,Length numeric(10,6)
  ,Wide numeric(10,6)
  ,Deth numeric(10,6)
  ,PackQTY numeric(10)
  ,MinQTY numeric(10,6)
  ,Remark VARCHAR(100)
  ,CustType char(1)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE Itms
;
CREATE TABLE Itms OF  TypItm
  (  CONSTRAINT Itms_id_pk PRIMARY KEY (id)
  , CONSTRAINT Itms_186_uk  UNIQUE (Code,Expiredate)
)
;
drop sequence Itms_seq
;  
create sequence Itms_seq
;  
; 
  ,id numeric(38)
  ,Locas_id_From numeric(38)
  ,Locas_id_To numeric(38)
  ,LT numeric(10)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE FromToLTs
;
CREATE TABLE FromToLTs OF  TypFromToLT
  (  CONSTRAINT FromToLTs_id_pk PRIMARY KEY (id)
)
;
drop sequence FromToLTs_seq
;  
create sequence FromToLTs_seq
;  
DROP TYPE TypItmInvnt force 
; 
CREATE TYPE TypItmInvnt AS OBJECT  
  ( id numeric(38)
  ,Locas_id_InvP numeric(38)
  ,Itms_Id numeric(38)
  ,ShelfNo varchar(40)
  ,MaxQTY numeric(10)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE ItmInvnts
;
CREATE TABLE ItmInvnts OF  TypItmInvnt
  (  CONSTRAINT ItmInvnts_id_pk PRIMARY KEY (id)
)
;
drop sequence ItmInvnts_seq
;  
create sequence ItmInvnts_seq
;  
DROP TYPE TypTransport force 
; 
CREATE TYPE TypTransport AS OBJECT  
  ( id numeric(38)
  ,code varchar(10)
  ,name varchar(40)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE Transports
;
CREATE TABLE Transports OF  TypTransport
  (  CONSTRAINT Transports_id_pk PRIMARY KEY (id)
)
;
drop sequence Transports_seq
;  
create sequence Transports_seq
;  
DROP TYPE TypSect force 
; 
CREATE TYPE TypSect AS OBJECT  
  ( id numeric(38)
  ,Locas_id_sect varchar(10)
  ,Code varchar(10)
  ,name varchar(40)
  ,Remark numeric(38)
  ,Expiredate varchar(40)
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE Sects
;
CREATE TABLE Sects OF  TypSect
  (  CONSTRAINT Sects_id_pk PRIMARY KEY (id)
)
;
drop sequence Sects_seq
;  
create sequence Sects_seq
;  
DROP TYPE TypStkHist force 
; 
CREATE TYPE TypStkHist AS OBJECT  
  ( id numeric(38)
  ,Locas_ID numeric(38)
  ,ITMS_ID numeric(38)
  ,FRCQTY numeric(38)
  ,FRCAMT numeric(38)
  ,PLANQTY numeric(38)
  ,PLANAMT numeric(38)
  ,SHCQTY numeric(38)
  ,SHCAMT numeric(38)
  ,ORDTQTY numeric(38)
  ,ORDTAMT numeric(38)
  ,INSTQTY numeric(38)
  ,INSTAMT numeric(38)
  ,ACTQTY numeric(38)
  ,ACTAMT numeric(38)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE StkHists
;
CREATE TABLE StkHists OF  TypStkHist
  (  CONSTRAINT StkHists_id_pk PRIMARY KEY (id)
  , CONSTRAINT StkHists_30_uk  UNIQUE (LOCAS_ID,Expiredate)
)
;
drop sequence StkHists_seq
;  
create sequence StkHists_seq
;  
; 
DROP TABLE STKTBLS
;
CREATE TABLE STKTBLS
  ( ID numeric(38)
  ,StkHists_ID numeric(38)
  ,TBLNAME varchar(30)
  ,record_id numeric(38)
  ,STKHISTFLG char(1)
  ,Expiredate date
  , CONSTRAINT STKTBLS_id_pk PRIMARY KEY (id)
  , CONSTRAINT STKTBLS_58_uk  UNIQUE (StkHist_ID,ID)
  , CONSTRAINT STKTBLS_59_uk  UNIQUE (TBLRCD_ID,ID)
)
;
drop sequence STKTBLS_seq
;  
create sequence STKTBLS_seq
;  
; 
; 
DROP TABLE CNTSTKHISTS
;
CREATE TABLE CNTSTKHISTS
  ( ID numeric(38)
  ,TBLNAME varchar(30)
  ,IdName varchar(30)
  ,InOutFLG char(3)
  ,Expiredate date
  ,SchCtl NUMERIC(3)
  ,locas_id_to numeric(38)
  , CONSTRAINT CNTSTKHISTS_id_pk PRIMARY KEY (id)
)
;
drop sequence CNTSTKHISTS_seq
;  
create sequence CNTSTKHISTS_seq
;  
DROP TYPE TypAmtHist force 
; 
CREATE TYPE TypAmtHist AS OBJECT  
  ( id numeric(38)
  ,Locas_ID numeric(38)
  ,FRCAMT numeric(38)
  ,PLANAMT numeric(38)
  ,ORDTAMT numeric(38)
  ,INSTAMT numeric(38)
  ,ACTAMT numeric(38)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE AmtHists
;
CREATE TABLE AmtHists OF  TypAmtHist
  (  CONSTRAINT AmtHists_id_pk PRIMARY KEY (id)
  , CONSTRAINT AmtHists_23_uk  UNIQUE (LOCAS_ID,Expiredate)
)
;
drop sequence AmtHists_seq
;  
create sequence AmtHists_seq
;  
; 
DROP TABLE CNTAMTHISTS
;
CREATE TABLE CNTAMTHISTS
  ( ID numeric(38)
  ,TBLNAME varchar(30)
  ,IdName varchar(30)
  ,InOutFLG char(3)
  ,Expiredate date
  , CONSTRAINT CNTAMTHISTS_id_pk PRIMARY KEY (id)
)
;
drop sequence CNTAMTHISTS_seq
;  
create sequence CNTAMTHISTS_seq
;  
DROP TYPE TypField force 
; 
CREATE TYPE TypField AS OBJECT  
  ( id numeric(38)
  ,screens_id numeric(38)
  ,selection NUMBER(1, 0) 
  ,hideflg NUMBER(1, 0) 
  ,SeqNo NUMBER(4) 
  ,rowpos NUMBER(4) 
  ,colpos NUMBER(4) 
  ,paragraph NUMBER(1, 0) 
  ,Code varchar(30)
  ,width NUMBER(4,0) 
  ,Type VARCHAR2(106)
  ,Length NUMBER
  ,DATAPRECISION NUMBER
  ,DATASCALE NUMBER
  ,DefaultValue varchar(40)
  ,Indisp NUMBER(1, 0) 
  ,SubIndisp NUMBER(1, 0) 
  ,editable NUMBER(1, 0) 
  ,InputSize NUMBER(4) 
  ,MAXLENGTH NUMBER(4) 
  ,editablehide VARCHAR(12)
  ,listoptions varchar(40)
  ,tblkey char(1)
  ,crtfield varchar(100)
  ,Expiredate date
  ,Remark VARCHAR(200)
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,updated_at date
)
;
DROP TABLE DetailFields
;
CREATE TABLE DetailFields OF TypField
  (  CONSTRAINT DetailFields_id_pk PRIMARY KEY (id)
  , CONSTRAINT DetailFields_51_uk  UNIQUE (Code,screens_id,Expiredate)
)
;
drop sequence DetailFields_seq
;  
create sequence DetailFields_seq
;  
; 
DROP TYPE TypButton force 
; 
CREATE TYPE TypButton AS OBJECT  
  ( id numeric(38)
  ,screens_id numeric(38)
  ,ICON varchar(10)
  ,TITLE varchar(50)
  ,PROC varchar(10)
  ,Expiredate date
  ,Remark VARCHAR(200)
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,updated_at date
)
;
DROP TABLE Buttons
;
CREATE TABLE Buttons OF  TypButton
  (  CONSTRAINT Buttons_id_pk PRIMARY KEY (id)
  , CONSTRAINT Buttons_74_uk  UNIQUE (screens_id,Expiredate,icon)
)
;
drop sequence Buttons_seq
;  
create sequence Buttons_seq
;  
; 
DROP TYPE TypChilScreen force 
; 
CREATE TYPE TypChilScreen AS OBJECT  
  ( id numeric(38)
  ,screens_id numeric(38)
  ,screens_id_chil numeric(38)
  ,Expiredate date
  ,Remark VARCHAR(200)
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE ChilScreens
;
CREATE TABLE ChilScreens OF  TypChilScreen
  (  CONSTRAINT ChilScreens_id_pk PRIMARY KEY (id)
  , CONSTRAINT ChilScreens_20_uk  UNIQUE (screens_id_chil,screens_id,Expiredate)
)
;
drop sequence ChilScreens_seq
;  
create sequence ChilScreens_seq
;  
; 
DROP TYPE TypScreen force 
; 
CREATE TYPE TypScreen AS OBJECT  
  ( id numeric(38)
  ,Code varchar(30)
  ,ViewName varchar(30)
  ,GrpName varchar(30)
  ,strselect varchar(4000)
  ,strwhere varchar(4000)
  ,strgrouporder varchar(4000)
  ,CDRfLayout varchar(10)
  ,Expiredate date
  ,Remark varchar(200)
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE Screens
;
CREATE TABLE Screens OF  TypScreen
  (  CONSTRAINT Screens_id_pk PRIMARY KEY (id)
  , CONSTRAINT Screens_46_uk  UNIQUE (ViewName)
)
;
drop sequence Screens_seq
;  
create sequence Screens_seq
;  
; 
/
