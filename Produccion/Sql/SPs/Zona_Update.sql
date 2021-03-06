SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Zona_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Zona_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Zona_Update]
	
	@IdZona int
   ,@Nombre varchar(100)
   ,@IdCliente INT = NULL
   
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE [dbo].[Zona]
    SET [Nombre] = @Nombre
	WHERE IdZona = @IdZona AND IdCliente = @IdCLiente
END
GO
