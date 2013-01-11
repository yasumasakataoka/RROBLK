create view  vscreen as
select screenname from ctlscreenas
union
select screenname from ctlscreenbs



select * from vscreen