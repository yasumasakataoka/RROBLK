CREATE TABLE "RAILS"."SIO_R_PERSONS" 
   (	"SIO_ID" NUMBER(38,0), 
	"SIO_USER_CODE" NUMBER(38,0), 
	"SIO_TERM_ID" VARCHAR2(30), 
	"SIO_SESSION_ID" NUMBER, 
	"SIO_COMMAND_RESPONSE" CHAR(1), 
	"SIO_SESSION_COUNTER" NUMBER(38,0), 
	"SIO_CLASSNAME" VARCHAR2(50), 
	"SIO_VIEWNAME" VARCHAR2(30), 
	"SIO_CODE" VARCHAR2(30), 
	"SIO_STRSQL" VARCHAR2(4000), 
	"SIO_TOTALCOUNT" NUMBER(38,0), 
	"SIO_RECORDCOUNT" NUMBER(38,0), 
	"SIO_START_RECORD" NUMBER(38,0), 
	"SIO_END_RECORD" NUMBER(38,0), 
	"SIO_SORD" VARCHAR2(256), 
	"SIO_SEARCH" VARCHAR2(10), 
	"SIO_SIDX" VARCHAR2(256), 
	"SCRLV_CODE" VARCHAR2(50), 
	"SCRLV_NAME" VARCHAR2(100),
	"PERSON_USRGRP_ID" NUMBER, 
	"USRGRP_ID" NUMBER, 
	"USRGRP_REMARK" VARCHAR2(400), 
	"USRGRP_CODE" VARCHAR2(50), 
	"USRGRP_NAME" VARCHAR2(50), 
	"USRGRP_CONTENTS" VARCHAR2(4000), 
	"ID" NUMBER, 
	"PERSON_ID" NUMBER, 
	"PERSON_REMARK" VARCHAR2(100), 
	"PERSON_EXPIREDATE" DATE, 
	"PERSON_UPDATE_IP" VARCHAR2(40), 
	"PERSON_CREATED_AT" TIMESTAMP (6), 
	"PERSON_UPDATED_AT" TIMESTAMP (6), 
	"PERSON_PERSON_ID_UPD" NUMBER, 
	"UPDPERSON_ID_UPD" NUMBER, 
	"UPDPERSON_CODE_UPD" VARCHAR2(50), 
	"UPDPERSON_NAME_UPD" VARCHAR2(100), 
	"PERSON_CODE" VARCHAR2(50), 
	"PERSON_NAME" VARCHAR2(100), 
	"PERSON_SECT_ID" NUMBER, 
	"SECT_ID" NUMBER, 
	"SECT_REMARK" VARCHAR2(200), 
	"SECT_LOCA_ID" NUMBER, 
	"LOCA_CODE_SECT" VARCHAR2(50), 
	"LOCA_ABBR_SECT" VARCHAR2(50), 
	"LOCA_PRFCT_SECT" VARCHAR2(20), 
	"LOCA_TEL_SECT" VARCHAR2(20), 
	"LOCA_COUNTRY_SECT" VARCHAR2(20), 
	"LOCA_NAME_SECT" VARCHAR2(100), 
	"LOCA_REMARK_SECT" VARCHAR2(100), 
	"LOCA_MAIL_SECT" VARCHAR2(20), 
	"LOCA_ADDR1_SECT" VARCHAR2(50), 
	"LOCA_ZIP_SECT" VARCHAR2(10), 
	"LOCA_FAX_SECT" VARCHAR2(20), 
	"LOCA_ADDR2_SECT" VARCHAR2(50), 
	"LOCA_ID_SECT" NUMBER, 
	"PERSON_EMAIL" VARCHAR2(50), 
	"PERSON_SCRLV_ID" NUMBER, 
	"SCRLV_LEVEL1" CHAR(1), 
	"SCRLV_ID" NUMBER, 
	"SCRLV_REMARK" VARCHAR2(100), 
	"SIO_ERRLINE" VARCHAR2(4000), 
	"SIO_ORG_TBLNAME" VARCHAR2(30), 
	"SIO_ORG_TBLID" NUMBER(38,0), 
	"SIO_ADD_TIME" DATE, 
	"SIO_REPLAY_TIME" DATE, 
	"SIO_RESULT_F" CHAR(1), 
	"SIO_MESSAGE_CODE" CHAR(10), 
	"SIO_MESSAGE_CONTENTS" VARCHAR2(4000), 
	"SIO_CHK_DONE" CHAR(1), 
	 CONSTRAINT "SIO_R_PERSONS_ID_PK" PRIMARY KEY ("SIO_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"
  ;
  
  CREATE TABLE "RAILS"."SIO_R_SECTS" 
   (	"SIO_ID" NUMBER(38,0), 
	"SIO_USER_CODE" NUMBER(38,0), 
	"SIO_TERM_ID" VARCHAR2(30), 
	"SIO_SESSION_ID" NUMBER, 
	"SIO_COMMAND_RESPONSE" CHAR(1), 
	"SIO_SESSION_COUNTER" NUMBER(38,0), 
	"SIO_CLASSNAME" VARCHAR2(50), 
	"SIO_VIEWNAME" VARCHAR2(30), 
	"SIO_CODE" VARCHAR2(30), 
	"SIO_STRSQL" VARCHAR2(4000), 
	"SIO_TOTALCOUNT" NUMBER(38,0), 
	"SIO_RECORDCOUNT" NUMBER(38,0), 
	"SIO_START_RECORD" NUMBER(38,0), 
	"SIO_END_RECORD" NUMBER(38,0), 
	"SIO_SORD" VARCHAR2(256), 
	"SIO_SEARCH" VARCHAR2(10), 
	"SIO_SIDX" VARCHAR2(256), 
	"ID" NUMBER(22,0), 
	"SECT_ID" NUMBER(22,0), 
	"SECT_REMARK" VARCHAR2(100), 
	"SECT_EXPIREDATE" DATE, 
	"SECT_UPDATE_IP" VARCHAR2(40), 
	"SECT_CREATED_AT" TIMESTAMP (6), 
	"SECT_UPDATED_AT" TIMESTAMP (6), 
	"SECT_PERSON_ID_UPD" NUMBER(22,0), 
	"UPDPERSON_ID_UPD" NUMBER(22,0), 
	"PERSON_CODE_UPD" VARCHAR2(50), 
	"PERSON_NAME_UPD" VARCHAR2(100), 
	"SECT_LOCA_ID_SECT" NUMBER(22,0), 
	"LOCA_ID_SECT" NUMBER(22,0), 
	"LOCA_CODE_SECT" VARCHAR2(50), 
	"LOCA_NAME_SECT" VARCHAR2(100), 
	"LOCA_ABBR_SECT" VARCHAR2(50), 
	"LOCA_ZIP_SECT" VARCHAR2(10), 
	"LOCA_COUNTRY_SECT" VARCHAR2(20), 
	"LOCA_PRFCT_SECT" VARCHAR2(20), 
	"LOCA_ADDR1_SECT" VARCHAR2(50), 
	"LOCA_ADDR2_SECT" VARCHAR2(50), 
	"LOCA_TEL_SECT" VARCHAR2(20), 
	"LOCA_FAX_SECT" VARCHAR2(20), 
	"LOCA_MAIL_SECT" VARCHAR2(20), 
	"LOCA_REMARK_SECT" VARCHAR2(100), 
	"SIO_ERRLINE" VARCHAR2(4000), 
	"SIO_ORG_TBLNAME" VARCHAR2(30), 
	"SIO_ORG_TBLID" NUMBER(38,0), 
	"SIO_ADD_TIME" DATE, 
	"SIO_REPLAY_TIME" DATE, 
	"SIO_RESULT_F" CHAR(1), 
	"SIO_MESSAGE_CODE" CHAR(10), 
	"SIO_MESSAGE_CONTENTS" VARCHAR2(4000), 
	"SIO_CHK_DONE" CHAR(1), 
	 CONSTRAINT "SIO_R_SECTS_ID_PK" PRIMARY KEY ("SIO_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"
  ;
