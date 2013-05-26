DROP TABLE CustFrcs
;
CREATE TABLE CustFrcs
  ( id NUMBER(38)
  ,Locas_id_Cust NUMBER(38)
  ,itms_id NUMBER(38)
  ,Locas_id_SHPSCH NUMBER(38)
  ,FrcNo Varchar(40)
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
  , CONSTRAINT CustFrcs_id_pk PRIMARY KEY (id)
)
;
drop sequence CustFrcs_seq
;  
create sequence CustFrcs_seq
;  
DROP TABLE CustPlns
;
CREATE TABLE CustPlns
  ( id NUMBER(38)
  ,Locas_id_Cust NUMBER(38)
  ,itms_id NUMBER(38)
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
  , CONSTRAINT CustPlns_id_pk PRIMARY KEY (id)
)
;
drop sequence CustPlns_seq
;  
create sequence CustPlns_seq
;  
DROP TABLE CustOrds
;
CREATE TABLE CustOrds
  ( id NUMBER(38)
  ,Locas_id_Cust NUMBER(38)
  ,itms_id NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,Duedate timestamp
  ,ToDuedate timestamp
  ,IsuDate timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
  ,OrderNo Varchar(40)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,ConfUrl varchar(100)
  ,Expiredate date
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT CustOrds_id_pk PRIMARY KEY (id)
  , CONSTRAINT CustOrds_86_uk  UNIQUE (SNO,LINENO,ID)
  , CONSTRAINT CustOrds_88_uk  UNIQUE (ITMS_ID,Duedate,ID)
)
;
drop sequence CustOrds_seq
;  
create sequence CustOrds_seq
;  
; 
; 
DROP TABLE CustInsts
;
CREATE TABLE CustInsts
  ( id NUMBER(38)
  ,itms_id NUMBER(38)
  ,Locas_id_CustRCVPlc NUMBER(38)
  ,Duedate timestamp
  ,ToDuedate timestamp
  ,IsuDate timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,ConfUrl varchar(100)
  ,Persons_id_Chrg NUMBER(38)
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT CustInsts_id_pk PRIMARY KEY (id)
  , CONSTRAINT CustInsts_123_uk  UNIQUE (SNO,LINENO,ID)
  , CONSTRAINT CustInsts_124_uk  UNIQUE (Locas_id_CustRCVPlc,Duedate,ID)
)
;
drop sequence CustInsts_seq
;  
create sequence CustInsts_seq
;  
; 
; 
DROP TABLE CustActs
;
CREATE TABLE CustActs
  ( id NUMBER(38)
  ,itms_id NUMBER(38)
  ,Locas_id_CustRCVPlc NUMBER(38)
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
DROP TABLE ArvOrds
;
CREATE TABLE ArvOrds
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,StkHists_id NUMBER(38)
  ,IsuDate timestamp
  ,Duedate timestamp
  ,ToDuedate timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
  ,weight NUMBER(16,4)
  ,volume NUMBER(16,4)
  ,Carton NUMBER(4)
  ,Remark varchar(200)
  ,ConfUrl varchar(100)
  ,Persons_id_Chrg NUMBER(38)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT ArvOrds_id_pk PRIMARY KEY (id)
  , CONSTRAINT ArvOrds_83_uk  UNIQUE (SNO,LINENO,ID)
)
;
drop sequence ArvOrds_seq
;  
create sequence ArvOrds_seq
;  
; 
DROP TABLE ArvInsts
;
CREATE TABLE ArvInsts
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,StkHists_id NUMBER(38)
  ,IsuDate timestamp
  ,Duedate timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
  ,weight NUMBER(16,4)
  ,volume NUMBER(16,4)
  ,Carton NUMBER(4)
  ,Remark varchar(200)
  ,ConfUrl varchar(100)
  ,Transports_id NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT ArvInsts_id_pk PRIMARY KEY (id)
  , CONSTRAINT ArvInsts_114_uk  UNIQUE (SNO,LINENO,ID)
)
;
drop sequence ArvInsts_seq
;  
create sequence ArvInsts_seq
;  
; 
DROP TABLE ArvActs
;
CREATE TABLE ArvActs
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,Transports_id NUMBER(38)
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
  , CONSTRAINT ArvActs_144_uk  UNIQUE (SNO,LINENO,ID)
)
;
drop sequence ArvActs_seq
;  
create sequence ArvActs_seq
;  
; 
DROP TABLE ShpOrds
;
CREATE TABLE ShpOrds
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,StkHists_id NUMBER(38)
  ,IsuDate timestamp
  ,OrdNo Varchar(40)
  ,Duedate timestamp
  ,QTY NUMBER(16,4)
  ,ConfUrl varchar(100)
  ,Persons_id_Chrg NUMBER(38)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT ShpOrds_id_pk PRIMARY KEY (id)
  , CONSTRAINT ShpOrds_77_uk  UNIQUE (SNO,LINENO,ID)
)
;
drop sequence ShpOrds_seq
;  
create sequence ShpOrds_seq
;  
; 
DROP TABLE ShpInsts
;
CREATE TABLE ShpInsts
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,StkHists_id_shpinsts NUMBER(38)
  ,Duedate timestamp
  ,QTY NUMBER(16,4)
  ,Transports_id NUMBER(38)
  ,ConfUrl varchar(100)
  ,Persons_id_Chrg NUMBER(38)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT ShpInsts_id_pk PRIMARY KEY (id)
  , CONSTRAINT ShpInsts_101_uk  UNIQUE (SNO,LINENO,ID)
)
;
drop sequence ShpInsts_seq
;  
create sequence ShpInsts_seq
;  
; 
DROP TABLE ShpActs
;
CREATE TABLE ShpActs
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,StkHists_id NUMBER(38)
  ,Transports_id NUMBER(38)
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
  , CONSTRAINT ShpActs_130_uk  UNIQUE (SNO,LINENO,ID)
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
  ,Itms_id NUMBER(38)
  ,Locas_id_PrcSec NUMBER(38)
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
  , CONSTRAINT PrcPlns_id_pk PRIMARY KEY (id)
)
;
drop sequence PrcPlns_seq
;  
create sequence PrcPlns_seq
;  
DROP TABLE PrcOrds
;
CREATE TABLE PrcOrds
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,itms_id NUMBER(38)
  ,Locas_id_PrcSec NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,IsuDate timestamp
  ,Duedate timestamp
  ,ToDuedate timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
  ,Remark varchar(200)
  ,ConfUrl varchar(100)
  ,Persons_id_Chrg NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT PrcOrds_id_pk PRIMARY KEY (id)
  , CONSTRAINT PrcOrds_106_uk  UNIQUE (sno,lineno)
)
;
drop sequence PrcOrds_seq
;  
create sequence PrcOrds_seq
;  
; 
DROP TABLE PrcInsts
;
CREATE TABLE PrcInsts
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,itms_id NUMBER(38)
  ,Locas_id_PrcSec NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,Isudate timestamp
  ,Duedate timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
  ,Remark varchar(200)
  ,ConfUrl varchar(100)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT PrcInsts_id_pk PRIMARY KEY (id)
  , CONSTRAINT PrcInsts_132_uk  UNIQUE (sno,lineno)
)
;
drop sequence PrcInsts_seq
;  
create sequence PrcInsts_seq
;  
; 
DROP TABLE PrcActs
;
CREATE TABLE PrcActs
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,itms_id NUMBER(38)
  ,Locas_id_PrcSec NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,Actdate timestamp
  ,Inputdate timestamp
  ,QTY NUMBER(16,4)
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT PrcActs_id_pk PRIMARY KEY (id)
)
;
drop sequence PrcActs_seq
;  
create sequence PrcActs_seq
;  
DROP TABLE PurPlns
;
CREATE TABLE PurPlns
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,Locas_id_Dealer NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,dueday timestamp
  ,IsuDate timestamp
  ,QTY NUMBER(16,4)
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT PurPlns_id_pk PRIMARY KEY (id)
)
;
drop sequence PurPlns_seq
;  
create sequence PurPlns_seq
;  
DROP TABLE PurOrds
;
CREATE TABLE PurOrds
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,itms_id NUMBER(38)
  ,Locas_id_Dealer NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,QTY NUMBER(16,4)
  ,DUEDATE timestamp
  ,IsuDate timestamp
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,ConfUrl varchar(100)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT PurOrds_id_pk PRIMARY KEY (id)
  , CONSTRAINT PurOrds_102_uk  UNIQUE (sno,lineno)
)
;
drop sequence PurOrds_seq
;  
create sequence PurOrds_seq
;  
; 
DROP TABLE PurInsts
;
CREATE TABLE PurInsts
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,itms_id NUMBER(38)
  ,Locas_id_Dealer NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,IsuDATE timestamp
  ,QTY NUMBER(16,4)
  ,Duedate timestamp
  ,Infomation varchar(2000)
  ,Remark varchar(200)
  ,ConfUrl varchar(100)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT PurInsts_id_pk PRIMARY KEY (id)
  , CONSTRAINT PurInsts_127_uk  UNIQUE (sno,lineno)
)
;
drop sequence PurInsts_seq
;  
create sequence PurInsts_seq
;  
; 
DROP TABLE PurActs
;
CREATE TABLE PurActs
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,itms_id NUMBER(38)
  ,Locas_id_Dealer NUMBER(38)
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
  , CONSTRAINT PurActs_id_pk PRIMARY KEY (id)
)
;
drop sequence PurActs_seq
;  
create sequence PurActs_seq
;  
DROP TABLE WrkSCHs
;
CREATE TABLE WrkSCHs
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,orgtblname varchar(30)
  ,orgRcordid NUMBER(38)
  ,itms_id NUMBER(38)
  ,itms_id NUMBER(38)
  ,Locas_id NUMBER(38)
  ,DataFlg char(2)
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT WrkSCHs_id_pk PRIMARY KEY (id)
)
;
drop sequence WrkSCHs_seq
;  
create sequence WrkSCHs_seq
;  
DROP TABLE WrkInsts
;
CREATE TABLE WrkInsts
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,Start_Time timestamp
  ,End_Time timestamp
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT WrkInsts_id_pk PRIMARY KEY (id)
)
;
drop sequence WrkInsts_seq
;  
create sequence WrkInsts_seq
;  
DROP TABLE WrkActs
;
CREATE TABLE WrkActs
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,Start_Time timestamp
  ,End_Time timestamp
  ,Inputdate timestamp
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT WrkActs_id_pk PRIMARY KEY (id)
)
;
drop sequence WrkActs_seq
;  
create sequence WrkActs_seq
;  
DROP TABLE RstOrds
;
CREATE TABLE RstOrds
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,Persons_id_Chrg NUMBER(38)
  ,Start_Time timestamp
  ,End_Time timestamp
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT RstOrds_id_pk PRIMARY KEY (id)
)
;
drop sequence RstOrds_seq
;  
create sequence RstOrds_seq
;  
DROP TABLE RstInsts
;
CREATE TABLE RstInsts
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,Start_Time timestamp
  ,End_Time timestamp
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT RstInsts_id_pk PRIMARY KEY (id)
)
;
drop sequence RstInsts_seq
;  
create sequence RstInsts_seq
;  
DROP TABLE RstActs
;
CREATE TABLE RstActs
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,RstInst_id NUMBER(38)
  ,Start_Time timestamp
  ,End_Time timestamp
  ,Inputdate timestamp
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT RstActs_id_pk PRIMARY KEY (id)
)
;
drop sequence RstActs_seq
;  
create sequence RstActs_seq
;  
DROP TABLE CnsmOrds
;
CREATE TABLE CnsmOrds
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,Persons_id_Chrg NUMBER(38)
  ,itms_id NUMBER(38)
  ,locas_id NUMBER(38)
  ,Duedate timestamp
  ,QTY NUMBER(16,4)
  ,Remark varchar(200)
  ,PARETBLNAME Varchar(40)
  ,PARID Varchar(40)
  ,Expiredate date
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT CnsmOrds_id_pk PRIMARY KEY (id)
)
;
drop sequence CnsmOrds_seq
;  
create sequence CnsmOrds_seq
;  
DROP TABLE CnsmInsts
;
CREATE TABLE CnsmInsts
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,itms_id NUMBER(38)
  ,locas_id NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,Duedate timestamp
  ,QTY NUMBER(16,4)
  ,Remark varchar(200)
  ,Expiredate date
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT CnsmInsts_id_pk PRIMARY KEY (id)
)
;
drop sequence CnsmInsts_seq
;  
create sequence CnsmInsts_seq
;  
DROP TABLE CnsmActs
;
CREATE TABLE CnsmActs
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,CnsmInsts_id NUMBER(38)
  ,itms_id NUMBER(38)
  ,locas_id NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,ActDate timestamp
  ,QTY NUMBER(16,4)
  ,Remark varchar(200)
  ,Expiredate date
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
  , CONSTRAINT CnsmActs_id_pk PRIMARY KEY (id)
)
;
drop sequence CnsmActs_seq
;  
create sequence CnsmActs_seq
;  
DROP TABLE PayOrds
;
CREATE TABLE PayOrds
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,PurACTs_id NUMBER(38)
  ,Locas_id_From NUMBER(38)
  ,Locas_id_To NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,Duedate timestamp
  ,IsuDate timestamp
  ,Amt NUMBER(16,4)
  ,Tax NUMBER(16,4)
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE PayInsts
;
CREATE TABLE PayInsts
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,Duedate timestamp
  ,InstStamp timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
  ,Tax NUMBER(16,4)
  ,Remark varchar(200)
  ,CtlDataProcsTrees_id NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE PayActs
;
CREATE TABLE PayActs
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,PayInsts_id NUMBER(38)
  ,ActDate timestamp
  ,Inputdate timestamp
  ,Amt NUMBER(16,4)
  ,Tax NUMBER(16,4)
  ,Remark varchar(200)
  ,CtlDataProcsTrees_id NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE BillPlns
;
CREATE TABLE BillPlns
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,Persons_id_Chrg NUMBER(38)
  ,dueday timestamp
  ,IsuDate timestamp
  ,Amt NUMBER(16,4)
  ,Tax NUMBER(16,4)
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE BillSCHs
;
CREATE TABLE BillSCHs
  ( id NUMBER(38)
  ,orgtblname varchar(30)
  ,orgRcordid NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,Duedate timestamp
  ,AMT NUMBER(16,4)
  ,TAX NUMBER(16,4)
  ,DataFlg char(2)
  ,Remark varchar(200)
  ,Persons_id_Chrg NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE BillOrds
;
CREATE TABLE BillOrds
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,CustACTs_id NUMBER(38)
  ,Locas_id_From NUMBER(38)
  ,Locas_id_To NUMBER(38)
  ,Persons_id_Chrg NUMBER(38)
  ,Duedate timestamp
  ,IsuDate timestamp
  ,Amt NUMBER(16,4)
  ,Tax NUMBER(16,4)
  ,Remark varchar(200)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE BillInsts
;
CREATE TABLE BillInsts
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,Duedate timestamp
  ,InstStamp timestamp
  ,QTY NUMBER(16,4)
  ,Price NUMBER(16,4)
  ,Amt NUMBER(16,4)
  ,Tax NUMBER(16,4)
  ,Remark varchar(200)
  ,CtlDataProcsTrees_id NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE BillActs
;
CREATE TABLE BillActs
  ( id NUMBER(38)
  ,Sno Varchar(40)
  ,LineNo NUMBER(4)
  ,BillInsts_id NUMBER(38)
  ,ActDate timestamp
  ,Inputdate timestamp
  ,Amt NUMBER(16,4)
  ,Tax NUMBER(16,4)
  ,Remark varchar(200)
  ,CtlDataProcsTrees_id NUMBER(38)
  ,Update_IP Varchar(40)
  ,created_at timestamp
  ,Updated_at timestamp
)
;
DROP TABLE Persons
;
CREATE TABLE Persons
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
  , CONSTRAINT Persons_id_pk PRIMARY KEY (id)
  , CONSTRAINT Persons_16_uk  UNIQUE (Code,Expiredate)
)
;
drop sequence Persons_seq
;  
create sequence Persons_seq
;  
; 
DROP TABLE UserGroups
;
CREATE TABLE UserGroups
  ( id numeric(38)
  ,Code VARCHAR2(30)
  ,Name varchar(20)
  ,Remark VARCHAR(100)
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  ,Expiredate date
  , CONSTRAINT UserGroups_id_pk PRIMARY KEY (id)
  , CONSTRAINT UserGroups_41_uk  UNIQUE (Code,Expiredate)
)
;
drop sequence UserGroups_seq
;  
create sequence UserGroups_seq
;  
; 
DROP TABLE Currency
;
CREATE TABLE Currency
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
  , CONSTRAINT Currency_id_pk PRIMARY KEY (id)
)
;
drop sequence Currency_seq
;  
create sequence Currency_seq
;  
DROP TABLE Clndrs
;
CREATE TABLE Clndrs
  ( id numeric(38)
  ,Code varchar(10)
  ,Name VARCHAR(100)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT Clndrs_id_pk PRIMARY KEY (id)
  , CONSTRAINT Clndrs_89_uk  UNIQUE (Code,Expiredate)
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
DROP TABLE Units
;
CREATE TABLE Units
  ( id numeric(38)
  ,Code varchar(3)
  ,Name varchar(10)
  ,Remark VARCHAR(100)
  ,Persons_id_Upd numeric(38)
  ,ExpireDate date
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT Units_id_pk PRIMARY KEY (id)
  , CONSTRAINT Units_136_uk  UNIQUE (Code,ExpireDate)
)
;
drop sequence Units_seq
;  
create sequence Units_seq
;  
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
DROP TABLE Pobjects
;
CREATE TABLE Pobjects
  ( id numeric(38)
  ,ObjectType char(1)
  ,Code varchar(30)
  ,Fieldlength NUMBER(4) 
  ,DataPresion NUMBER(2) 
  ,DataScale NUMBER(2) 
  ,UKEYFLG CHAR(1)
  ,Contens VARCHAR(200)
  ,Remark VARCHAR(200)
  ,RubyCode VARCHAR(4000)
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Expiredate date
  ,Updated_at date
  , CONSTRAINT Pobjects_id_pk PRIMARY KEY (id)
  , CONSTRAINT Pobjects_69_uk  UNIQUE (code,ObjectType)
)
;
drop sequence Pobjects_seq
;  
create sequence Pobjects_seq
;  
; 
DROP TABLE POBJGrps
;
CREATE TABLE POBJGrps
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
  , CONSTRAINT POBJGrps_id_pk PRIMARY KEY (id)
)
;
drop sequence POBJGrps_seq
;  
create sequence POBJGrps_seq
;  
DROP TABLE BottonRules
;
CREATE TABLE BottonRules
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
  , CONSTRAINT BottonRules_id_pk PRIMARY KEY (id)
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
  , CONSTRAINT TblRelas_211_uk  UNIQUE (code,Expiredate)
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
  , CONSTRAINT fieldRelas_230_uk  UNIQUE (TblRelas_id,TargetField,Expiredate)
)
;
drop sequence fieldRelas_seq
;  
create sequence fieldRelas_seq
;  
; 
DROP TABLE Locas
;
CREATE TABLE Locas
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
  , CONSTRAINT Locas_id_pk PRIMARY KEY (id)
  , CONSTRAINT Locas_23_uk  UNIQUE (Code,Expiredate)
)
;
drop sequence Locas_seq
;  
create sequence Locas_seq
;  
; 
DROP TABLE InvPs
;
CREATE TABLE InvPs
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
  , CONSTRAINT InvPs_id_pk PRIMARY KEY (id)
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
DROP TABLE Billings
;
CREATE TABLE Billings
  ( id number(38)
  ,Locas_id_Billings number(38)
  ,Remark VARCHAR(200)
  ,Expiredate date
  ,Persons_id_Upd number(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT Billings_id_pk PRIMARY KEY (id)
)
;
drop sequence Billings_seq
;  
create sequence Billings_seq
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
  ,Locas_id_Billings number(38)
  ,Currencys_id number(38)
  ,PersonNameOfCust VARCHAR(30)
  ,Persons_id_Chrg number(38)
  ,Remark VARCHAR(100)
  ,CustType char(1)
  ,Expiredate date
  ,Persons_id_Upd number(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT Custs_id_pk PRIMARY KEY (id)
  , CONSTRAINT Custs_169_uk  UNIQUE (Locas_id_Custs,Locas_id_Billings,Locas_id_Billings)
)
;
drop sequence Custs_seq
;  
create sequence Custs_seq
;  
; 
DROP TABLE Dealers
;
CREATE TABLE Dealers
  ( id number(38)
  ,Locas_id_Dealer number(38)
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
DROP TABLE OpeItms
;
CREATE TABLE OpeItms
  ( id number(38)
  ,ProcessSeq number(3)
  ,Priority number(3)
  ,Locas_id number(38)
  ,Itms_id number(38)
  ,PackQTY number(10)
  ,MinQTY number(10,6)
  ,LT number(10,2)
  ,Units_id_LTTime number(38)
  ,ProPucr char(3)
  ,Expiredate date
  ,Persons_id_Upd number(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT OpeItms_id_pk PRIMARY KEY (id)
  , CONSTRAINT OpeItms_31_uk  UNIQUE (Itms_id,Locas_id,Expiredate)
  , CONSTRAINT OpeItms_32_uk  UNIQUE (Itms_id,ProcessSeq,Priority,Expiredate)
)
;
drop sequence OpeItms_seq
;  
create sequence OpeItms_seq
;  
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
DROP TABLE Itms
;
CREATE TABLE Itms
  ( id number(38)
  ,Code varchar(40)
  ,Name VARCHAR(50)
  ,ItmType CHAR(1)
  ,ConsumType CHAR(1)
  ,Units_id number(38)
  ,Std VARCHAR(50)
  ,Model VARCHAR(50)
  ,Material VARCHAR(50)
  ,Design VARCHAR(50)
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
  , CONSTRAINT Itms_id_pk PRIMARY KEY (id)
  , CONSTRAINT Itms_179_uk  UNIQUE (Code,Expiredate)
)
;
drop sequence Itms_seq
;  
create sequence Itms_seq
;  
; 
DROP TABLE FromToLTs
;
CREATE TABLE FromToLTs
  ( id number(38)
  ,Locas_id_From number(38)
  ,Locas_id_To number(38)
  ,LT number(10)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd number(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT FromToLTs_id_pk PRIMARY KEY (id)
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
DROP TABLE Transports
;
CREATE TABLE Transports
  ( id number(38)
  ,code varchar(30)
  ,name varchar(40)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd number(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT Transports_id_pk PRIMARY KEY (id)
)
;
drop sequence Transports_seq
;  
create sequence Transports_seq
;  
DROP TABLE Sects
;
CREATE TABLE Sects
  ( id number(38)
  ,Locas_id_sects number(38)
  ,Remark number(38)
  ,Expiredate varchar(40)
  ,Persons_id_Upd number(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT Sects_id_pk PRIMARY KEY (id)
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
  ,DataSEQ char(1)
  ,DataFlg char(5)
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
)
;
drop sequence StkHists_seq
;  
create sequence StkHists_seq
;  
DROP TABLE StkchkTbls
;
CREATE TABLE StkchkTbls
  ( id NUMBER(38)
  ,Locas_id number(38)
  ,Itms_id number(38)
  ,DataFlg char(5)
  ,MkAutoType CHAR(1)
  ,MkPrdType CHAR(1)
  ,MkQtyType NUMBER(8)
  ,MkAmtType NUMBER(8)
  ,MaxBalQty NUMBER(8)
  ,MaxBalAmt NUMBER(8)
  ,safestkqty NUMBER(8)
  ,safestkprd NUMBER(8)
  ,Expiredate date
  ,Remark VARCHAR(200)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT StkchkTbls_id_pk PRIMARY KEY (id)
  , CONSTRAINT StkchkTbls_32_uk  UNIQUE (itms_id,locas_id,dataflg,Expiredate)
)
;
drop sequence StkchkTbls_seq
;  
create sequence StkchkTbls_seq
;  
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
  , CONSTRAINT Ctlxxxxxx_id_pk PRIMARY KEY (id)
  , CONSTRAINT Ctlxxxxxx_50_uk  UNIQUE (PTBLID,id)
  , CONSTRAINT Ctlxxxxxx_51_uk  UNIQUE (CTBLName,CTBLID,id)
)
;
drop sequence Ctlxxxxxx_seq
;  
create sequence Ctlxxxxxx_seq
;  
; 
; 
DROP TABLE DetailFields
;
CREATE TABLE DetailFields
  ( id NUMBER(38)
  ,Code varchar(30)
  ,screens_id NUMBER(38)
  ,selection NUMBER(1, 0) 
  ,hideflg NUMBER(1, 0) 
  ,SeqNo NUMBER(4) 
  ,rowpos NUMBER(4) 
  ,colpos NUMBER(4) 
  ,paragraph NUMBER(1, 0) 
  ,width NUMBER(4,0) 
  ,Type VARCHAR2(12)
  ,DATAPRECISION NUMBER
  ,DATASCALE NUMBER
  ,Indisp NUMBER(1, 0) 
  ,SubIndisp NUMBER(1, 0) 
  ,editable NUMBER(1, 0) 
  ,maxvalue NUMBER
  ,minvalue NUMBER
  ,EdOptsize NUMBER
  ,EdOptMAXLENGTH NUMBER(4) 
  ,EdOptValue varchar(50)
  ,EdOptMultiple NUMBER(4) 
  ,EdOptRow NUMBER(4) 
  ,EdOptCols NUMBER(4) 
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
  , CONSTRAINT DetailFields_id_pk PRIMARY KEY (id)
  , CONSTRAINT DetailFields_40_uk  UNIQUE (Code,screens_id,Expiredate)
)
;
drop sequence DetailFields_seq
;  
create sequence DetailFields_seq
;  
; 
DROP TABLE Buttons
;
CREATE TABLE Buttons
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
  , CONSTRAINT Buttons_id_pk PRIMARY KEY (id)
  , CONSTRAINT Buttons_76_uk  UNIQUE (screens_id,Expiredate,icon)
)
;
drop sequence Buttons_seq
;  
create sequence Buttons_seq
;  
; 
DROP TABLE ChilScreen
;
CREATE TABLE ChilScreen
  ( id NUMBER(38)
  ,screens_id NUMBER(38)
  ,screens_id_chil NUMBER(38)
  ,Expiredate date
  ,Remark VARCHAR(200)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT ChilScreen_id_pk PRIMARY KEY (id)
  , CONSTRAINT ChilScreen_14_uk  UNIQUE (screens_id_chil,screens_id,Expiredate)
)
;
drop sequence ChilScreen_seq
;  
create sequence ChilScreen_seq
;  
; 
DROP TABLE Screens
;
CREATE TABLE Screens
  ( id NUMBER(38)
  ,Code varchar(30)
  ,Name varchar(30)
  ,ViewName varchar(30)
  ,POBJGrps_id NUMBER(38)
  ,strselect varchar(4000)
  ,strwhere varchar(4000)
  ,strgrouporder varchar(4000)
  ,YMLcode varchar(4000)
  ,CDRfLayout varchar(10)
  ,Expiredate date
  ,Remark varchar(200)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT Screens_id_pk PRIMARY KEY (id)
  , CONSTRAINT Screens_48_uk  UNIQUE (code,Expiredate)
)
;
drop sequence Screens_seq
;  
create sequence Screens_seq
;  
; 
/
