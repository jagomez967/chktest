IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.GetDifereciaHorariaCliente'))
   exec('CREATE PROCEDURE [dbo].[GetDifereciaHorariaCliente] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[GetDifereciaHorariaCliente] 	
(
	@IdCliente			int
)
as
BEGIN
	select isnull(DiferenciaHora,0) as DiferenciaHoararia from cliente where idCliente = @idCliente  
END
GO
