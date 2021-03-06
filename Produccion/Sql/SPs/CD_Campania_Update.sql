SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Campania_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Campania_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Campania_Update]
	-- Add the parameters for the stored procedure here
    @IdCampania int 
   ,@Codigo varchar(50) = NULL
   ,@Nombre varchar(255)= NULL
   ,@Decripcion varchar(255)= NULL
   ,@PorcDescuento decimal(18,2)= NULL
   ,@ValidaDesde datetime= NULL
   ,@ValidaHasta datetime= NULL
   ,@IdSistema int= NULL
   ,@Activo bit= NULL
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[CD_Campania]
   SET [Codigo] = Codigo
      ,[Nombre] = @Nombre
      ,[Decripcion] = @Decripcion
      ,[PorcDescuento] = @PorcDescuento
      ,[ValidaDesde] = @ValidaDesde
      ,[ValidaHasta] = @ValidaHasta
      ,[IdSistema] = @IdSistema
      ,[Activo] = @Activo
 WHERE @IdCampania = [IdCampania]
 
END
GO
