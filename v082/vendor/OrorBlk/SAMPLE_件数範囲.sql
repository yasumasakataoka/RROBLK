SELECT * FROM (SELECT * FROM (SELECT * FROM SIO_CTLOBJECTS ORDER BY ID
                              )  
                        where rownum < 20
               ) A
         WHERE NOT  EXISTS (SELECT 1 FROM (SELECT * FROM (SELECT * FROM SIO_CTLOBJECTS ORDER BY ID
                                                          )  
                                                    WHERE ROWNUM <10
                                           ) B
                                      WHERE  A.ID = B.ID
                            )
          AND ROWNUM <10

 