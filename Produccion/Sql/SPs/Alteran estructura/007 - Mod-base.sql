alter table ReportingTableroObjeto add dataLabels bit default 0 not null
go
alter table ReportingTableroObjeto add stackLabels int default 0 not null
go
alter table ReportingObjeto add dataLabels bit default 0 not null
go
alter table ReportingObjeto add stackLabels int default 0 not null
go
--alter table ReportingTableroObjeto drop column dataLabels
--alter table ReportingTableroObjeto drop column stackLabels

--select * from ReportingTableroObjeto

update ReportingTableroObjeto set dataLabels=0, stackLabels=2
go