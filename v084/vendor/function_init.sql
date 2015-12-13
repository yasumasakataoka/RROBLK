CREATE OR REPLACE FUNCTION STRTOKEN(
	P_STRING VARCHAR2, P_DELIMIT VARCHAR2,
	P_POS POSITIVEN := 1, P_NTH POSITIVEN := 1,
	P_EOD VARCHAR2 := NULL)
RETURN VARCHAR2
IS
	vStartPos	PLS_INTEGER;
	vEndPos		PLS_INTEGER;
BEGIN
	IF (P_POS = 1) THEN
		vStartPos := 1;
	ELSE
		vStartPos := INSTR(P_STRING, P_DELIMIT, 1, P_POS - 1);
		IF (vStartPos = 0) THEN
			RETURN P_EOD;
		END IF;
		vStartPos := vStartPos + 1;
	END IF;
	vEndPos := INSTR(P_STRING, P_DELIMIT, vStartPos, P_NTH);
	IF (vEndPos = 0) THEN
		RETURN SUBSTR(P_STRING, vStartPos);
	END IF;
	RETURN SUBSTR(P_STRING, vStartPos, vEndPos - vStartPos);
END;
