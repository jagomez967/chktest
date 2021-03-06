SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Cadena_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Cadena_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Cadena_Update]
	
	 @IdCadena int
	,@Nombre varchar(255) = NULL
	,@Activo bit = NULL
		
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE [dbo].[CD_Cadena]
   SET [Nombre] = @Nombre
      ,[Activo] = @Activo
	WHERE @IdCadena = [IdCadena]

END
GO
