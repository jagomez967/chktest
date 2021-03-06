SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_Reporte_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_Reporte_Add] AS' 
END
GO
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_Reporte_Add]

   
    @IdPuntoDeVenta int
   ,@IdUsuario int
   ,@FechaCreacion datetime
   ,@FechaActualizacion datetime = NULL
   ,@IdEmpresa int
   ,@AuditoriaNoAutorizada bit = NULL
   ,@ResponsableDermo1 varchar(100) = NULL
   ,@IdResponsableDermo1 int = NULL
   ,@ResponsableDermo2 varchar(100) = NULL
   ,@IdResponsableDermo2 int = NULL
   ,@IdReporte2 int OUTPUT  
   
      
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[R2_Reporte]
           ([IdPuntoDeVenta]
           ,[IdUsuario]
           ,[FechaCreacion]           
           ,[IdEmpresa]
           ,[AuditoriaNoAutorizada]
           ,[ResponsableDermo1]
           ,[IdResponsableDermo1]
           ,[ResponsableDermo2]
           ,[IdResponsableDermo2])
     VALUES
           (@IdPuntoDeVenta
           ,@IdUsuario
           ,@FechaCreacion
           ,@IdEmpresa
           ,@AuditoriaNoAutorizada
           ,@ResponsableDermo1
           ,@IdResponsableDermo1
           ,@ResponsableDermo2
           ,@IdResponsableDermo2)           
     
     SET @IdReporte2 = @@Identity
             
       
END
GO
