SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Ruteo_NuevoMasivo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Ruteo_NuevoMasivo] AS' 
END
GO
ALTER PROCEDURE [dbo].[Ruteo_NuevoMasivo]
	
AS
BEGIN
	SET NOCOUNT ON;

-- Modificar los parametros antes de usar. 
DECLARE @IdPuntoDeVenta int
DECLARE @IdUsuario int
DECLARE @IdCliente int


DECLARE	@return_value int

DECLARE ruteo_cursor CURSOR FOR
-------------------------------------------------
--Esta tabla despues cambiarla
SELECT [IdPuntoDeVenta]      
      ,[IdUsuario]
      ,3 as IdCliente
FROM dbo.RuteoEdding20141230$
-------------------------------------------------

OPEN ruteo_cursor

FETCH NEXT FROM ruteo_cursor
INTO  @IdPuntoDeVenta, @IdUsuario, @IdCliente

WHILE @@FETCH_STATUS = 0
BEGIN
   
    
EXEC	@return_value = [dbo].[Ruteo_Nuevo]
		@IdPuntoDeventa = @IdPuntoDeVenta,
		@IdCliente = @IdCliente,
		@IdUsuario = @IdUsuario
		
FETCH NEXT FROM ruteo_cursor
INTO  @IdPuntoDeVenta, @IdUsuario, @IdCliente
END 

CLOSE ruteo_cursor;
DEALLOCATE ruteo_cursor;


END
GO
