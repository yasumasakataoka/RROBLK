  CREATE OR REPLACE FUNCTION  test_ref(str char)
   RETURN ref typperson
   as
  ----  person_ref NUMBER;
        person_ref REF typperson;
  BEGIN
    SELECT ref(p) INTO person_ref
      FROM mstpersons p
      WHERE p.mstpersonscode = str
      AND Expiredate IS NULL;
     RETURN     person_ref;
  END;
  
