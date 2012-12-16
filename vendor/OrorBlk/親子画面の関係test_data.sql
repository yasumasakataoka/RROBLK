INSERT INTO ChilScreens 
       (ID,SCREENS_ID,EXPIREDATE,REMARK,PERSONS_ID_UPD)
SELECT CHILSCREENS_SEQ.NEXTVAL,ID,'2030/12/31','AUTO_CRT',1
       FROM SCREENS A
WHERE NOT EXISTS(SELECT 1 FROM CHILSCREENS B
                 WHERE A.ID = B.SCREENS_ID)




UPDATE CHILSCREENS
SET SCREENS_ID_PARE = (SELECT ID FROM SCREENS WHERE VIEWNAME = 'R_ITMS')
WHERE SCREENS_ID = (SELECT ID FROM SCREENS WHERE VIEWNAME = 'R_OPEITMS')


SELECT * FROM r_prefields
PREFIELD_SCREENS_ID
,