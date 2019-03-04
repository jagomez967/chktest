IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.GetPriceRequestHistory'))
   exec('CREATE PROCEDURE [dbo].[GetPriceRequestHistory] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[GetPriceRequestHistory]
(
	@ID uniqueidentifier
)
AS
BEGIN
	select p.fecha,
	       p.Comentario,
		   e.idEstado,
		   e.descripcion as estado,
		   u.apellido + ', ' + u.nombre collate database_default as usuario 
		   from PriceRequestHistory p
		   inner join PriceRequestEstados e on e.idEstado = p.Estado
		   inner join usuario u on u.idUsuario = p.IdUsuario
		where p.id = @ID
		order by fecha desc 
END

go

exec GetPriceRequestHistory '3B245C4E-4FDE-4F6B-8267-3ED45B08AAB0'
--@idCliente = 178 , @producto = 'EPSON L380'



