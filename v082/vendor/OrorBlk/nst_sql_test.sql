CREATE TYPE zzzUseRsr AS OBJECT  
  ( id numeric(38)
  ,MstResourcesCode CHAR(10))


CREATE TYPE yyyUseRsrs AS TABLE  OF zzzUseRsr 




CREATE TYPE yyyOpeItem AS OBJECT  
  ( id numeric(38)
  ,MstLocasCode CHAR(10)
  ,yyy_Resources yyyUseRsrs
)
;

CREATE TYPE yyyOpeItems AS TABLE  OF yyyOpeItem 


CREATE TYPE xxxItem AS OBJECT  
  ( id numeric(38)
  ,MstItemsCode char(40)
  ,yyy_Opeitems yyyOpeitems
)

CREATE TABLE xxxItems OF  xxxItem
 NESTED TABLE  yyy_Opeitems STORE AS yyy_Opeitems_MstItems
( NESTED TABLE  yyy_Resources STORE AS yyy_Resources_MstItems)

insert into xxxItems values(5,'555',yyyOpeItems(
                                   (yyyOpeItem(null,null, yyyUseRsrs(zzzUseRsr(null,null)
                                                                     )
                                               )
                                    )
                                               )
                           )

insert into table (select yyy_Opeitems from  xxxItems where id = 3)
select 6,'L31', yyyUseRsrs()  from dual

INSERT INTO TABLE (SELECT yyy_Resources FROM TABLE(select yyy_Opeitems from  xxxItems where id = 3)
                   WHERE ID = 5)
SELECT 5,'MRC5' FROM DUAL

\
 
[/@-^E


SELECT * FROM TABLE (SELECT yyy_Resources FROM TABLE(select yyy_Opeitems from  xxxItems )
                    ) WHERE ID = 5

select c.* from xxxItems  a,table(a.yyy_Opeitems) b,table(b.yyy_Resources) c

select b.* from xxxItems  a,table(a.yyy_Opeitems) b,table(b.yyy_Resources) c


select * from xxxItems  a,table(a.yyy_Opeitems) b

update table(select yyy_Opeitems from  xxxItems  where id = 2) b
set b.id = 2 where b.id  is null




