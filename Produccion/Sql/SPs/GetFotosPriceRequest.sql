SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFotosPriceRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFotosPriceRequest] AS' 
END
GO
ALTER procedure [dbo].[GetFotosPriceRequest]
(
@GUID UNIQUEIDENTIFIER
)
AS
BEGIN

create table #Fotos(idFoto varchar(max))

insert #Fotos(idFoto)
select distinct item
FROM PriceRequestDetail 
    CROSS APPLY dbo.Split(FotoPropia, ';') 
where id = @GUID
union
SELECT distinct item
FROM PriceRequestDetail 
    CROSS APPLY dbo.Split(FotoCompetencia, ';') 
where id = @GUID

select  STUFF((select ',' + t.leyenda
		from tags t
		inner join imagenesTags i
		on i.idTag = t.idTag
		where i.idImagen = f.idFoto
		for XML PATH('')
		),1,1,'') as nombrePuntoDeVenta,
	f.idFoto as IdPuntoDeVentaFoto,
	row_number()over(order by f.idFoto) as IdPuntoDeVenta,
	'' as comentarios,
	getdate() fechaCreacion
from #Fotos F
where isnumeric(f.idFoto) = 1

drop table #fotos

END
GO


