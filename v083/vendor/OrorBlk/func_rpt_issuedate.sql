CREATE OR REPLACE FUNCTION rep_issuedate(tblname IN VARCHAR,
                                                inrecordid IN NUMBER,
												inreport_code in VARCHAR) 
												RETURN VARCHAR IS
rep_issuedate VARCHAR(10);
inreports_id NUMBER;
BEGIN
 if inreport_code = 'ReportCode' then
    rep_issuedate := '0000/00/00';
	else
	 select a.id into inreports_id from Reports a
	  where a.code = inreport_code and Expiredate > sysdate and rownum <2;
      select to_char(b.issuedate,'yyyy/mm/dd') into rep_issuedate from HisOfRprts b
	       where b.id = inreports_id and b.recordid = inrecordid and rownum <2
	      and  b.Expiredate > sysdate;	 
  end if;
  return rep_issuedate;
  EXCEPTION  -- exception handlers begin
   WHEN OTHERS THEN  -- handles all other errors
      rep_issuedate := '0000/00/00';
	  return rep_issuedate;
  END;




