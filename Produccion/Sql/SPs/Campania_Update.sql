SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Campania_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Campania_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Campania_Update]
	-- Add the parameters for the stored procedure here
    @IdCampania int
   ,@Nombre char(50)
   ,@Fecha datetime
   ,@IdMarca int
   ,@Activo bit =  NULL
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
   UPDATE [dbo].[Campania]
   SET [Nombre] = @Nombre
      ,[Fecha] = @Fecha
      ,[IdMarca] = @IdMarca
      ,[Activo] = @Activo
   WHERE [IdCampania] = @IdCampania
   
   
END
GO
