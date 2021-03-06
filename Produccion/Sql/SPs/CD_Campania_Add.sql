SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Campania_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Campania_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Campania_Add]
	-- Add the parameters for the stored procedure here
    @Codigo varchar(50) = NULL
   ,@Nombre varchar(255)= NULL
   ,@Decripcion varchar(255)= NULL
   ,@PorcDescuento decimal(18,2)= NULL
   ,@ValidaDesde datetime= NULL
   ,@ValidaHasta datetime= NULL
   ,@IdSistema int= NULL
   ,@Activo bit= NULL
   ,@IdCampania int Output
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[CD_Campania]
           ([Codigo]
           ,[Nombre]
           ,[Decripcion]
           ,[PorcDescuento]
           ,[ValidaDesde]
           ,[ValidaHasta]
           ,[IdSistema]
           ,[Activo])
     VALUES
           (@Codigo
           ,@Nombre
           ,@Decripcion
           ,@PorcDescuento
           ,@ValidaDesde
           ,@ValidaHasta
           ,@IdSistema
           ,@Activo)
           
      SET @IdCampania = @@IDENTITY

END
GO
