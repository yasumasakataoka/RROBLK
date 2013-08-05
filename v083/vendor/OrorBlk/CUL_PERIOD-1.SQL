------ KUBUN 1-> 日　2-> 時間  3->分
CREATE OR REPLACE FUNCTION DATE_CAL  (P_CODE VARCHAR,INPUT_D DATE,KUBUN VARCHAR,PERIOD INT)
 RETURN DATE AS R_DATE DATE;
   W1_DATE DATE;
   W_CODE CHAR(8);
   TYPE DATE_CRTYP IS REF CURSOR;
   DATE_CR DATE_CRTYP;
   STRSQL  VARCHAR(100);
   STRSQL1 VARCHAR(100);
   STRSQL2 VARCHAR(100);
   STRSQL3 VARCHAR(100);
   DATE_rec CUL_PERIOD%ROWTYPE;
   i INT;
   W_PERIOD INT;
BEGIN
   W_CODE := P_CODE;  ------ 上位部署に対する対応は未
   STRSQL1 := 'SELECT MIN(APP_STA_D)  FROM CUL_PERIOD WHERE POS_COD = :1 AND APP_STA_D >= :2';
   STRSQL2 := 'SELECT MAX(APP_END_D)  FROM CUL_PERIOD WHERE POS_COD = :1 AND APP_END_D <= :2';
   STRSQL3 := 'SELECT *               FROM CUL_PERIOD WHERE POS_COD = :1 AND ';
   R_DATE := NULL;
   CASE
    WHEN KUBUN = '1'  THEN
           i := PERIOD;
           CASE
           WHEN   PERIOD < 0 THEN
                  SELECT MAX(APP_END_D) INTO W1_DATE FROM CUL_PERIOD WHERE POS_COD = W_CODE AND APP_END_D <= INPUT_D;
                  STRSQL := STRSQL3 || ' APP_END_D <= :2 ORDER BY APP_END_D desc';
                  OPEN DATE_CR FOR STRSQL USING W_CODE,W1_DATE;
                  LOOP
                      FETCH DATE_CR INTO DATE_rec;
                      EXIT WHEN DATE_CR%NOTFOUND OR DATE_CR%NOTFOUND IS NULL; -- exit when last row is fetched
                      IF TO_CHAR(DATE_rec.APP_END_D,'YYYY/MM/DD') <   TO_CHAR(W1_DATE,'YYYY/MM/DD')  THEN
                         i := i + 1;
                         W1_DATE :=  DATE_rec.APP_END_D;
                      END IF;
                      EXIT WHEN   i >=0;
                  END LOOP;
                  CLOSE DATE_CR;
                  R_DATE := TO_DATE(TO_CHAR(W1_DATE,'YYYY/MM/DD')|| ' ' ||  TO_CHAR(INPUT_D,'HH24:MI:SS'),'YYYY/MM/DD HH24:MI:SS');
                  CASE
                   WHEN DATE_rec.APP_END_D <= R_DATE AND  DATE_rec.APP_END_D >= R_DATE THEN
                           R_DATE :=R_DATE;   ------  求めたまま
                      WHEN  DATE_rec.APP_END_D < W1_DATE THEN
                             R_DATE :=W1_DATE;   ------  その日の最終就業時間
                      WHEN  DATE_rec.APP_STA_D > R_DATE THEN
                             SELECT MAX(APP_END_D) INTO R_DATE FROM CUL_PERIOD WHERE POS_COD = W_CODE AND APP_END_D < R_DATE;
                             --------  朝の就業時間前に指定すると前日になる。
                    END CASE;
           WHEN  PERIOD = 0 THEN
                    R_DATE := INPUT_D;
           WHEN   PERIOD > 0 THEN
                  SELECT MIN(APP_END_D) INTO W1_DATE FROM CUL_PERIOD WHERE POS_COD = W_CODE AND APP_STA_D >= INPUT_D;
                  STRSQL := STRSQL3 || ' APP_STA_D >= :2 ORDER BY APP_STA_D ';
                  OPEN DATE_CR FOR STRSQL USING W_CODE,W1_DATE;
                  LOOP
                      FETCH DATE_CR INTO DATE_rec;
                      EXIT WHEN DATE_CR%NOTFOUND OR DATE_CR%NOTFOUND IS NULL; -- exit when last row is fetched
                      IF TO_CHAR(DATE_rec.APP_STA_D,'YYYY/MM/DD') >   TO_CHAR(W1_DATE,'YYYY/MM/DD')  THEN
                         i := i - 1;
                         W1_DATE :=  DATE_rec.APP_STA_D;
                      END IF;
                      EXIT WHEN   i <=0;
                  END LOOP;
                  CLOSE DATE_CR;
                  R_DATE := TO_DATE(TO_CHAR(W1_DATE,'YYYY/MM/DD')|| ' ' ||  TO_CHAR(INPUT_D,'HH24:MI:SS'),'YYYY/MM/DD HH24:MI:SS');
                  CASE
                   WHEN DATE_rec.APP_STA_D <= R_DATE AND  DATE_rec.APP_END_D >= R_DATE THEN
                           R_DATE :=R_DATE;   ------  求めたまま
                      WHEN  DATE_rec.APP_END_D > W1_DATE THEN
                             R_DATE :=W1_DATE;   ------  その日の開始就業時間
                      WHEN  DATE_rec.APP_END_D < R_DATE THEN
                             SELECT MIN(APP_STA_D) INTO R_DATE FROM CUL_PERIOD WHERE POS_COD = W_CODE AND APP_STA_D > R_DATE;
                             --------  朝の就業時間前に指定すると前日になる。
                  END CASE;
           END CASE;
    WHEN KUBUN = '2' OR KUBUN = '3' THEN     -------  時間または分
           IF KUBUN = '2' THEN
              i := PERIOD * 60;
             ELSE
              i := PERIOD;
           END IF;
           CASE
           WHEN   PERIOD < 0 THEN
                  SELECT MAX(APP_END_D) INTO W1_DATE FROM CUL_PERIOD WHERE POS_COD = W_CODE AND APP_END_D <= INPUT_D;
                  STRSQL := STRSQL3 || ' APP_END_D <= :2 ORDER BY APP_END_D desc';
                  OPEN DATE_CR FOR STRSQL USING W_CODE,W1_DATE;
                  LOOP
                      FETCH DATE_CR INTO DATE_rec;
                      EXIT WHEN DATE_CR%NOTFOUND OR DATE_CR%NOTFOUND IS NULL; -- exit when last row is fetched
                      IF DATE_rec.APP_STA_D <= INPUT_D AND   DATE_rec.APP_END_D >= INPUT_D  THEN
                         IF (DATE_rec.APP_END_D - i /1440) >= DATE_rec.APP_STA_D THEN
                            R_DATE :=  (DATE_rec.APP_END_D - i /1440);
                            i := 0;
                          ELSE
                            i := i - (INPUT_D - DATE_rec.APP_STA_D );
                         END IF;
                        ELSE
                         IF DATE_rec.P_Minute  >=   i  THEN
                            R_DATE :=  (DATE_rec.APP_END_D - i /1440);
                            i := 0;
                           ELSE
                           i := i -  DATE_rec.P_Minute  ;
                         END IF;
                      END IF;
                      EXIT WHEN   i <=0;
                  END LOOP;
                  CLOSE DATE_CR;
          WHEN   PERIOD = 0 THEN
                    R_DATE := INPUT_D;
          WHEN   PERIOD > 0 THEN
                  SELECT MIN(APP_END_D) INTO W1_DATE FROM CUL_PERIOD WHERE POS_COD = W_CODE AND APP_STA_D >= INPUT_D;
                  STRSQL := STRSQL3 || ' APP_STA_D >= :2 ORDER BY APP_STA_D ';
                  OPEN DATE_CR FOR STRSQL USING W_CODE,W1_DATE;
                  LOOP
                      FETCH DATE_CR INTO DATE_rec;
                      EXIT WHEN DATE_CR%NOTFOUND OR DATE_CR%NOTFOUND IS NULL; -- exit when last row is fetched
                      IF DATE_rec.APP_STA_D < INPUT_D AND   DATE_rec.APP_END_D > INPUT_D   THEN
                            IF (DATE_rec.APP_STA_D + i /1440) <= DATE_rec.APP_END_D THEN
                            R_DATE :=  (DATE_rec.APP_STA_D + i /1440);
                            i := 0;
                          ELSE
                            i := i - (DATE_rec.APP_END_D - INPUT_D );
                          END IF;
                        ELSE
                         IF DATE_rec.P_Minute  >=   i  THEN
                            R_DATE :=  (DATE_rec.APP_STA_D + i /1440);
                            i := 0;
                           ELSE
                           i := i -  DATE_rec.P_Minute  ;
                         END IF;
                      END IF;
                      EXIT WHEN   i <=0;
                  END LOOP;
                  CLOSE DATE_CR;
         END CASE;
   END CASE;
   RETURN R_DATE;
END;
/
