DROP TABLE CustFrcs
;
CREATE TABLE CustFrcs
  ( id NUMBER(38)
  ,Custs_id NUMBER(38)
  ,itms_id NUMBER(38)
  ,TblIndctPC CHAR(1)
  ,TblIndct1NTYPE CHAR(1)
  ,Locas_id_SHPSCH NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,Persons_id_Chrg NUMBER(38)
  ,Duedate timestamp
  ,IsuDate timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,Expiredate date
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE CustPlns
;
CREATE TABLE CustPlns
  ( id NUMBER(38)
  ,Custs_id NUMBER(38)
  ,itms_id NUMBER(38)
  ,TblIndctPC CHAR(1)
  ,TblIndct1NTYPE CHAR(1)
  ,Locas_id_SHPSCH NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,Persons_id_Chrg NUMBER(38)
  ,Duedate timestamp
  ,IsuDate timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,Expiredate date
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE CustOrds
;
CREATE TABLE CustOrds
  ( id NUMBER(38)
  ,itms_id NUMBER(38)
  ,TblIndctPC CHAR(1)
  ,TblIndct1NTYPE CHAR(1)
  ,Locas_id_ARVSCH NUMBER(38)
  ,Locas_id_SHPSCH NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,Duedate timestamp
  ,IsuDate timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,Expiredate date
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT CustOrds_id_pk PRIMARY KEY (id)
  , CONSTRAINT CustOrds_80_uk  UNIQUE (SNO,LINENO,ID)
  , CONSTRAINT CustOrds_81_uk  UNIQUE (Locas_id_ARVSCH,ID)
  , CONSTRAINT CustOrds_82_uk  UNIQUE (ITMS_ID,ID)
  , CONSTRAINT CustOrds_83_uk  UNIQUE (Locas_id_ARVSCHuedate,ID)
  , CONSTRAINT CustOrds_84_uk  UNIQUE (Duedate,Locas_id_ARVSCH,ID)
)
;
drop sequence CustOrds_seq
;  
create sequence CustOrds_seq
;  
; 
; 
; 
; 
; 
DROP TABLE CustInsts
;
CREATE TABLE CustInsts
  ( id NUMBER(38)
  ,itms_id NUMBER(38)
  ,TblIndctPC CHAR(1)
  ,TblIndct1NTYPE CHAR(1)
  ,Locas_id_ARVSCH NUMBER(38)
  ,Locas_id_SHPSCH NUMBER(38)
  ,Duedate timestamp
  ,IsuDate timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,Persons_id_Chrg NUMBER(38)
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT CustInsts_id_pk PRIMARY KEY (id)
  , CONSTRAINT CustInsts_114_uk  UNIQUE (SNO,LINENO,ID)
  , CONSTRAINT CustInsts_115_uk  UNIQUE (Cust_ID,Duedate,ID)
)
;
drop sequence CustInsts_seq
;  
create sequence CustInsts_seq
;  
; 
; 
DROP TABLE CustRplys
;
CREATE TABLE CustRplys
  ( id NUMBER(38)
  ,CustInsts_id NUMBER(38)
  ,Duedate timestamp
  ,IsuDate timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT CustRplys_id_pk PRIMARY KEY (id)
)
;
drop sequence CustRplys_seq
;  
create sequence CustRplys_seq
;  
DROP TABLE CustActs
;
CREATE TABLE CustActs
  ( id NUMBER(38)
  ,CustInsts_id NUMBER(38)
  ,Actdate timestamp
  ,Inputdate timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,Persons_id_Chrg NUMBER(38)
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE ArvSchs
;
CREATE TABLE ArvSchs
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,orgtblname varchar(30)
  ,orgRcordid NUMBER(38)
  ,tblname varchar(30)
  ,Rcordid NUMBER(38)
  ,itms_id NUMBER(38)
  ,locas_id NUMBER(38)
  ,Dueday timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE ArvOrds
;
CREATE TABLE ArvOrds
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,itms_id NUMBER(38)
  ,locas_id NUMBER(38)
  ,IsuDate timestamp
  ,Duedate timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
  ,weight NUMBER(16,4)
  ,volume NUMBER(16,4)
  ,Carton NUMBER(4)
  ,Remark varchar(200)
  ,Persons_id_Chrg NUMBER(38)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE ArvInsts
;
CREATE TABLE ArvInsts
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,itms_id NUMBER(38)
  ,locas_id NUMBER(38)
  ,IsuDate timestamp
  ,Duedate timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
  ,weight NUMBER(16,4)
  ,volume NUMBER(16,4)
  ,Carton NUMBER(4)
  ,Remark varchar(200)
  ,Transport_id varchar(200)
  ,Persons_id_Chrg NUMBER(38)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE ArvActs
;
CREATE TABLE ArvActs
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,ArvInsts_id NUMBER(38)
  ,itms_id NUMBER(38)
  ,locas_id NUMBER(38)
  ,Transport_id NUMBER(38)
  ,Actdate timestamp
  ,Inputdate timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
  ,Persons_id_Chrg NUMBER(38)
  ,weight NUMBER(16,4)
  ,volume NUMBER(16,4)
  ,Carton NUMBER(4)
  ,Remark varchar(200)
  ,Persons_id_Chrg NUMBER(38)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT ArvActs_id_pk PRIMARY KEY (id)
  , CONSTRAINT ArvActs_120_uk  UNIQUE (SNO,LINENO,ID)
)
;
drop sequence ArvActs_seq
;  
create sequence ArvActs_seq
;  
; 
DROP TABLE ShpSchs
;
CREATE TABLE ShpSchs
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,orgtblname varchar(30)
  ,orgRcordid NUMBER(38)
  ,itms_id NUMBER(38)
  ,locas_id NUMBER(38)
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
  ,DueDay timestamp
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE ShpOrds
;
CREATE TABLE ShpOrds
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,itms_id NUMBER(38)
  ,locas_id NUMBER(38)
  ,IsuDate timestamp
  ,OrdNo Varchar(40)
  ,Duedate timestamp
  ,QTY NUMBER(16,4)
  ,Persons_id_Chrg NUMBER(38)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE ShpInsts
;
CREATE TABLE ShpInsts
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,itms_id NUMBER(38)
  ,locas_id NUMBER(38)
  ,Duedate timestamp
  ,QTY NUMBER(16,4)
  ,Transport_id varchar(200)
  ,Persons_id_Chrg NUMBER(38)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE ShpActs
;
CREATE TABLE ShpActs
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,itms_id NUMBER(38)
  ,locas_id NUMBER(38)
  ,ShpInsts_id NUMBER(38)
  ,Transport_id NUMBER(38)
  ,Actdate timestamp
  ,Inputdate timestamp
  ,QTY NUMBER(16,4)
  ,Persons_id_Chrg NUMBER(38)
  ,weight NUMBER(16,4)
  ,volume NUMBER(16,4)
  ,Carton NUMBER(4)
  ,Remark varchar(200)
  ,Persons_id_Chrg NUMBER(38)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT ShpActs_id_pk PRIMARY KEY (id)
  , CONSTRAINT ShpActs_104_uk  UNIQUE (SNO,LINENO,ID)
)
;
drop sequence ShpActs_seq
;  
create sequence ShpActs_seq
;  
; 
DROP TABLE PrcPlns
;
CREATE TABLE PrcPlns
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,tblname varchar(30)
  ,Rcordid NUMBER(38)
  ,TblIndct1NTYPE CHAR(2)
  ,Locas_id_SHPSCH NUMBER(38)
  ,Locas_id_ARVSCH NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,Duedate timestamp
  ,Isudate timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
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
  ( id NUMBER(38)
  ,orgtblname varchar(30)
  ,orgRcordid NUMBER(38)
  ,orgtblname varchar(30)
  ,orgRcordid NUMBER(38)
  ,tblname varchar(30)
  ,Rcordid NUMBER(38)
  ,itms_id NUMBER(38)
  ,TblIndctPC CHAR(1)
  ,TblIndct1NTYPE CHAR(2)
  ,Locas_id_SHPSCH NUMBER(38)
  ,Locas_id_ARVSCH NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,Duedate timestamp
  ,QTY NUMBER(16,4)
  ,Remark varchar(200)
  ,Persons_id_Chrg NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE PrcOrds
;
CREATE TABLE PrcOrds
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,TblIndctPC CHAR(1)
  ,TblIndct1NTYPE CHAR(2)
  ,Locas_id_SHPSCH NUMBER(38)
  ,Locas_id_ARVSCH NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,IsuDate timestamp
  ,Duedate timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
  ,Remark varchar(200)
  ,Persons_id_Chrg NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE PrcInsts
;
CREATE TABLE PrcInsts
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,Opeitms_id NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,Isudate timestamp
  ,Duedate timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE PrcActs
;
CREATE TABLE PrcActs
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,Opeitms_id NUMBER(38)
  ,PrcInsts_id NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,Actdate timestamp
  ,Inputdate timestamp
  ,QTY NUMBER(16,4)
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE PurPlns
;
CREATE TABLE PurPlns
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,itms_id NUMBER(38)
  ,TblIndctPC CHAR(1)
  ,TblIndct1NTYPE CHAR(2)
  ,Locas_id_SHPSCH NUMBER(38)
  ,Locas_id_ARVSCH NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,dueday timestamp
  ,IsuDate timestamp
  ,QTY NUMBER(16,4)
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE PurSCHs
;
CREATE TABLE PurSCHs
  ( id NUMBER(38)
  ,tblname varchar(30)
  ,orgtblname varchar(30)
  ,orgRcordid NUMBER(38)
  ,Rcordid NUMBER(38)
  ,itms_id NUMBER(38)
  ,TblIndctPC CHAR(1)
  ,TblIndct1NTYPE CHAR(2)
  ,Locas_id_SHPSCH NUMBER(38)
  ,Locas_id_ARVSCH NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,Duedate timestamp
  ,QTY NUMBER(16,4)
  ,Remark varchar(200)
  ,Persons_id_Chrg NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE PurOrds
;
CREATE TABLE PurOrds
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,Custs_id NUMBER(38)
  ,itms_id NUMBER(38)
  ,TblIndctPC CHAR(1)
  ,TblIndct1NTYPE CHAR(2)
  ,Locas_id_SHPSCH NUMBER(38)
  ,Locas_id_ARVSCH NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,QTY NUMBER(16,4)
  ,DUEDATE timestamp
  ,IsuDate timestamp
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE PurInsts
;
CREATE TABLE PurInsts
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,Persons_id_Chrg NUMBER(38)
  ,IsuDATE timestamp
  ,QTY NUMBER(16,4)
  ,Duedate timestamp
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE PurRplys
;
CREATE TABLE PurRplys
  ( id NUMBER(38)
  ,PurInsts_id NUMBER(38)
  ,IsuDATE timestamp
  ,QTY NUMBER(16,4)
  ,Duedate timestamp
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE PurActs
;
CREATE TABLE PurActs
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,PurInsts_id NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,Actdate timestamp
  ,Inputdate timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
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
  ,ObjectType char(1)
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
DROP TABLE TblRelas
;
CREATE TABLE TblRelas
  ( id NUMBER(38)
  ,code varchar(40)
  ,BaseTblView varchar(30)
  ,TargetTbl varchar(30)
  ,Remark varchar(200)
  ,Expiredate date
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT TblRelas_id_pk PRIMARY KEY (id)
  , CONSTRAINT TblRelas_201_uk  UNIQUE (code,Expiredate)
)
;
drop sequence TblRelas_seq
;  
create sequence TblRelas_seq
;  
; 
DROP TABLE fieldRelas
;
CREATE TABLE fieldRelas
  ( id NUMBER(38)
  ,TblRelas_id NUMBER(38)
  ,TargetField varchar(30)
  ,Function varchar(256)
  ,Remark varchar(200)
  ,Expiredate date
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT fieldRelas_id_pk PRIMARY KEY (id)
  , CONSTRAINT fieldRelas_220_uk  UNIQUE (TblRelas_id,TargetField,Expiredate)
)
;
drop sequence fieldRelas_seq
;  
create sequence fieldRelas_seq
;  
; 
DROP TYPE TypLoca force 
; 
CREATE TYPE TypLoca AS OBJECT  
  ( id number(38)
  ,Code varchar(40)
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
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd number(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE Locas
;
CREATE TABLE Locas OF  TypLoca
  (  CONSTRAINT Locas_id_pk PRIMARY KEY (id)
  , CONSTRAINT Locas_27_uk  UNIQUE (Code,Expiredate)
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
  ( id number(38)
  ,Locas_id_InvP number(38)
  ,Persons_id_CHRG number(38)
  ,InvntMaxQTY number(10)
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
  ( id number(38)
  ,InvP_id_DELVCNTR number(38)
  ,Persons_id_CHRG number(38)
  ,DeliveryMaxQTY number(10)
  ,MaxWeight number(10)
  ,MaxPackQTY number(10)
  ,Clndrs_id number(38)
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
DROP TABLE Payees
;
CREATE TABLE Payees
  ( id number(38)
  ,Locas_id_PayeeS number(38)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd number(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT Payees_id_pk PRIMARY KEY (id)
)
;
drop sequence Payees_seq
;  
create sequence Payees_seq
;  
DROP TYPE TypEntpr force 
; 
CREATE TYPE TypEntpr AS OBJECT  
  ( id number(38)
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
DROP TYPE TypCustRCVPlc force 
; 
CREATE TYPE TypCustRCVPlc AS OBJECT  
  ( id number(38)
  ,Locas_id_CustRCVPlc number(38)
  ,PersonNameOfOutside VARCHAR(100)
  ,Persons_id_Chrg number(38)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd number(38)
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
DROP TABLE Custs
;
CREATE TABLE Custs
  ( id number(38)
  ,Locas_id_Custs number(38)
  ,Locas_id_Custs number(38)
  ,Locas_id_Entprs number(38)
  ,PersonNameOfCust VARCHAR(30)
  ,Persons_id_Chrg number(38)
  ,Currencys_id number(38)
  ,Remark VARCHAR(100)
  ,CustType char(1)
  ,Expiredate date
  ,Persons_id_Upd number(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT Custs_id_pk PRIMARY KEY (id)
)
;
drop sequence Custs_seq
;  
create sequence Custs_seq
;  
DROP TABLE Dealers
;
CREATE TABLE Dealers
  ( id number(38)
  ,Locas_id_Dealers number(38)
  ,Locas_id_AcctVenders number(38)
  ,Locas_id_Entprs number(38)
  ,MaxAMT number(10)
  ,MinAMT number(10)
  ,Currencys_id number(38)
  ,PersonNameOfOutside VARCHAR(30)
  ,Persons_id_Chrg number(38)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd number(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT Dealers_id_pk PRIMARY KEY (id)
)
;
drop sequence Dealers_seq
;  
create sequence Dealers_seq
;  
DROP TABLE PrcSecs
;
CREATE TABLE PrcSecs
  ( id number(38)
  ,Locas_id_PrcSecs number(38)
  ,Persons_id_Chrg number(38)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd number(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT PrcSecs_id_pk PRIMARY KEY (id)
)
;
drop sequence PrcSecs_seq
;  
create sequence PrcSecs_seq
;  
DROP TYPE TypOpeItm force 
; 
CREATE TYPE TypOpeItm AS OBJECT  
  ( id number(38)
  ,ProcessSeq number(3)
  ,Priority number(3)
  ,Locas_id number(38)
  ,Itms_id number(38)
  ,LT number(10,2)
  ,Units_id_LTTime number(38)
  ,Shptype char(1)
  ,Expiredate date
  ,Persons_id_Upd number(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE OpeItms
;
CREATE TABLE OpeItms OF  TypOpeItm
  (  CONSTRAINT OpeItms_id_pk PRIMARY KEY (id)
  , CONSTRAINT OpeItms_25_uk  UNIQUE (Itms_id,InvPs_id,ProcessSeq,Priority,Expiredate)
)
;
drop sequence OpeItms_seq
;  
create sequence OpeItms_seq
;  
; 
DROP TABLE NDItms
;
CREATE TABLE NDItms
  ( id number(38)
  ,OpeItms_id number(38)
  ,Itms_id_Chil number(38)
  ,ConsumType CHAR(1)
  ,PareNum number(10)
  ,ChiNum number(10)
  ,MinQty number(10)
  ,ConsumUnitQty number(10)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd number(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT NDItms_id_pk PRIMARY KEY (id)
)
;
drop sequence NDItms_seq
;  
create sequence NDItms_seq
;  
DROP TYPE TypGdsPrc force 
; 
CREATE TYPE TypGdsPrc AS OBJECT  
  ( id number(38)
  ,Itms_id number(38)
  ,Custs_id number(38)
  ,CustProdName varchar(40)
  ,Price number(10,4)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd number(38)
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
  ( id number(38)
  ,Code varchar(40)
  ,Name VARCHAR(100)
  ,ItmType CHAR(1)
  ,ConsumType CHAR(1)
  ,Units_id number(38)
  ,Std VARCHAR(100)
  ,Model VARCHAR(100)
  ,Material VARCHAR(100)
  ,Design VARCHAR(100)
  ,Weight number(10,6)
  ,Length number(10,6)
  ,Wide number(10,6)
  ,Deth number(10,6)
  ,PackQTY number(10)
  ,MinQTY number(10,6)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd number(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE Itms
;
CREATE TABLE Itms OF  TypItm
  (  CONSTRAINT Itms_id_pk PRIMARY KEY (id)
  , CONSTRAINT Itms_170_uk  UNIQUE (Code,Expiredate)
)
;
drop sequence Itms_seq
;  
create sequence Itms_seq
;  
; 
  ,id number(38)
  ,Locas_id_From number(38)
  ,Locas_id_To number(38)
  ,LT number(10)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd number(38)
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
  ( id number(38)
  ,Locas_id_ItmInvnts number(38)
  ,Itms_Id number(38)
  ,ShelfNo varchar(40)
  ,MaxQTY number(10)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd number(38)
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
  ( id number(38)
  ,code varchar(10)
  ,name varchar(40)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd number(38)
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
  ( id number(38)
  ,Locas_id_sects varchar(10)
  ,name varchar(40)
  ,Remark number(38)
  ,Expiredate varchar(40)
  ,Persons_id_Upd number(38)
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
DROP TABLE StkHists
;
CREATE TABLE StkHists
  ( id NUMBER(38)
  ,Locas_ID NUMBER(38)
  ,ITMS_ID NUMBER(38)
  ,Flg char(2)
  ,QTY NUMBER(38)
  ,AMT NUMBER(38)
  ,Remark VARCHAR(100)
  ,strdate date
  ,Expiredate date
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT StkHists_id_pk PRIMARY KEY (id)
  , CONSTRAINT StkHists_17_uk  UNIQUE (LOCAS_ID,ITMS_ID,flg,Expiredate)
)
;
drop sequence StkHists_seq
;  
create sequence StkHists_seq
;  
; 
DROP TABLE CNTSTKHISTS
;
CREATE TABLE CNTSTKHISTS
  ( ID NUMBER(38)
  ,StkHists_id NUMBER(38)
  ,TBLNAME varchar(30)
  ,Recordid NUMBER(38)
  ,QTY NUMBER(38)
  ,AMT NUMBER(38)
  ,Expiredate date
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT CNTSTKHISTS_id_pk PRIMARY KEY (id)
)
;
drop sequence CNTSTKHISTS_seq
;  
create sequence CNTSTKHISTS_seq
;  
DROP TABLE Ctlxxxxxx
;
CREATE TABLE Ctlxxxxxx
  ( id NUMBER(38)
  ,PTBLID NUMBER(38)
  ,CTBLName VARCHAR(30)
  ,CTBLID NUMBER(38)
  ,Expiredate date
  ,Remark VARCHAR(200)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE CtlPareChilTbls
;
CREATE TABLE CtlPareChilTbls
  ( id NUMBER(38)
  ,PareTBLNAME VARCHAR(30)
  ,ChilTBLNAME VARCHAR(30)
  ,YMLCode clob
  ,Expiredate date
  ,Remark VARCHAR(200)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT CtlPareChilTbls_id_pk PRIMARY KEY (id)
)
;
drop sequence CtlPareChilTbls_seq
;  
create sequence CtlPareChilTbls_seq
;  
DROP TABLE CtlAUTOCRTSHCfromhiss
;
CREATE TABLE CtlAUTOCRTSHCfromhiss
  ( id NUMBER(38)
  ,SchTBLName VARCHAR(30)
  ,RubyCode clob
  ,Expiredate date
  ,Remark VARCHAR(200)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TABLE CtlAutoCRTORDFrmSchs
;
CREATE TABLE CtlAutoCRTORDFrmSchs
  ( id NUMBER(38)
  ,SCHTBLNAME VARCHAR(30)
  ,ORDTBLName VARCHAR(30)
  ,RubyCode clob
  ,Expiredate date
  ,Remark VARCHAR(200)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
)
;
DROP TYPE TypField force 
; 
CREATE TYPE TypField AS OBJECT  
  ( id NUMBER(38)
  ,screens_id NUMBER(38)
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
  ,sumkey char(1)
  ,crtfield varchar(100)
  ,Expiredate date
  ,Remark VARCHAR(200)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,updated_at date
)
;
DROP TABLE DetailFields
;
CREATE TABLE DetailFields OF TypField
  (  CONSTRAINT DetailFields_id_pk PRIMARY KEY (id)
  , CONSTRAINT DetailFields_52_uk  UNIQUE (Code,screens_id,Expiredate)
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
  ( id NUMBER(38)
  ,screens_id NUMBER(38)
  ,ICON varchar(10)
  ,TITLE varchar(50)
  ,PROC varchar(10)
  ,Expiredate date
  ,Remark VARCHAR(200)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,updated_at date
)
;
DROP TABLE Buttons
;
CREATE TABLE Buttons OF  TypButton
  (  CONSTRAINT Buttons_id_pk PRIMARY KEY (id)
  , CONSTRAINT Buttons_75_uk  UNIQUE (screens_id,Expiredate,icon)
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
  ( id NUMBER(38)
  ,screens_id NUMBER(38)
  ,screens_id_chil NUMBER(38)
  ,Expiredate date
  ,Remark VARCHAR(200)
  ,Persons_id_Upd NUMBER(38)
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
DROP TABLE Screens
;
CREATE TABLE Screens
  ( id NUMBER(38)
  ,Code varchar(30)
  ,ViewName varchar(30)
  ,GrpNames_id NUMBER(38)
  ,strselect varchar(4000)
  ,strwhere varchar(4000)
  ,strgrouporder varchar(4000)
  ,CDRfLayout varchar(10)
  ,TblIndct1NTYPE CHAR(2)
  ,TblIndct1NPC CHAR(1)
  ,Expiredate date
  ,Remark varchar(200)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT Screens_id_pk PRIMARY KEY (id)
  , CONSTRAINT Screens_43_uk  UNIQUE (ViewName)
)
;
drop sequence Screens_seq
;  
create sequence Screens_seq
;  
; 
DROP TABLE Screens
;
CREATE TABLE Screens
  ( id NUMBER(38)
  ,Code varchar(30)
  ,GrpName varchar(30)
  ,Expiredate date
  ,Remark varchar(200)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT Screens_id_pk PRIMARY KEY (id)
  , CONSTRAINT Screens_36_uk  UNIQUE (ViewName)
)
;
drop sequence Screens_seq
;  
create sequence Screens_seq
;  
; 
/
