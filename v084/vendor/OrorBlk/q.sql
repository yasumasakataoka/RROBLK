select * from mkords a where result_f = 's'
and expiredate > current_date
and to_char(runtime,'##') = substr(to_char(current_date,'yyyy/mm/dd hh24'),12,2)
and not exists (select 1 from mkords b
                where result_f = '0'
				and a.RUNTIME = b.RUNTIME
				and a.prdpurshp = b.PRDPURSHP)
				;
select substr(to_char(current_timestamp,'yyyy/mm/dd hh24'),12,2) from dual
;
select to_char(id,'00') from persons
;
