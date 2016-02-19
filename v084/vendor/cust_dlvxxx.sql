create or replace view  cust_dlvschs as
select  cust.custs_id,cust.cno,cust.custrcvplcs_id,cust.asstwhs_id,cust.itms_id,cust.duedate,dlv.depdate,cust.qty qty,dlv.qty bal_qty
from dlvschs dlv,custords cust
where cust.id = dlv.tblid 
and dlv.tblname = 'custinsts' and dlv.qty > 0
;
create or replace view  cust_dlvords as
select  cust.custs_id,cust.cno_ord,cust.custrcvplcs_id,cust.asstwhs_id,cust.itms_id,cust.duedate,dlv.depdate,cust.qty qty,dlv.qty bal_qty
from dlvords dlv,custinsts cust
where cust.id = dlv.tblid 
and dlv.tblname = 'custinsts' and dlv.qty > 0
;

create or replace view  cust_dlvinsts as
select  cust.custs_id,cust.cno_ord,cust.custrcvplcs_id,cust.asstwhs_id,cust.itms_id,cust.duedate,dlv.depdate,cust.qty qty,dlv.qty bal_qty
from dlvinsts dlv,custinsts cust
where cust.id = dlv.tblid 
and dlv.tblname = 'custinsts' and dlv.qty > 0
;
create or replace view  cust_dlvacts as
select  cust.custs_id,cust.cno_ord,cust.custrcvplcs_id,cust.asstwhs_id,cust.itms_id,cust.duedate,dlv.depdate,cust.qty qty,dlv.qty bal_qty
from dlvacts dlv,custinsts cust
where cust.id = dlv.tblid 
and dlv.tblname = 'custacts' and dlv.qty > 0
;