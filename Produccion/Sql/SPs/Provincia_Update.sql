SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Provincia_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Provincia_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Provincia_Update]
	
	@IdProvincia int
   ,@Nombre varchar(50)
   ,@IdCliente INT = NULL
   
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE [dbo].[Provincia] 
    SET [Nombre] = @Nombre
	WHERE IdProvincia = @IdProvincia AND IdCliente = @IdCliente
END
GO
