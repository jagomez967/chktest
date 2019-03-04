IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.GetAccountPhoto'))
   exec('CREATE PROCEDURE [dbo].[GetAccountPhoto] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[GetAccountPhoto]
(
	@IdCadena int
)
AS
BEGIN
	select isnull(Logo,'') as image64
	from cadena
	where idCadena = @idCadena
END