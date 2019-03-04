IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.GetPriceRequestSimpleData'))
   exec('CREATE PROCEDURE [dbo].[GetPriceRequestSimpleData] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[GetPriceRequestSimpleData]
(
	@ID uniqueidentifier
)
AS
BEGIN
	select Convert(varchar(10),CONVERT(date,r.fecha,106),103) as fecha,
		    c.nombre as pais,
			r.idNumeric as id,
			isnull(u.apellido + ', ' + u.nombre collate database_default,'n/a') as usuario,
			r.id as [GUID]
	from priceRequest r 
	inner join cliente c on c.idCliente = r.idCliente
	left join usuario u on u.idUsuario = r.idUsuario 
	where r.id= @ID
END



