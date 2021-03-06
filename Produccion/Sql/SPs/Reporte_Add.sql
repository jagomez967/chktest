SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reporte_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Reporte_Add] AS' 
END
GO
ALTER PROCEDURE [dbo].[Reporte_Add]
	-- Add the parameters for the stored procedure here
    @IdPuntoDeVenta int
   ,@IdUsuario int
   ,@FechaCreacion datetime
   ,@FechaActualizacion datetime = NULL
   ,@IdEmpresa int 
   ,@AuditoriaNoAutorizada bit = NULL
   ,@Latitud Decimal(11,8) = NULL
   ,@Longitud Decimal(11,8) = NULL
   ,@Firma Varchar(Max) = NULL
   ,@Precision int = NULL
   ,@Vejez DATETIME = NULL
   ,@FechaEnvio DATETIME = NULL   
   ,@IdReporte int OUTPUT  
   ,@FechaCierre DATETIME = NULL
         
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[Reporte]
           ([IdPuntoDeVenta]
           ,[IdUsuario]
           ,[FechaCreacion]           
           ,[IdEmpresa]
           ,[AuditoriaNoAutorizada]
           ,[Latitud] 
           ,[Longitud]
           ,[Firma]
		   ,[Precision]
		   ,[Vejez]
		   ,[FechaEnvio]
		   ,[FechaRecepcion]
		   ,[FechaCierre]) 
     VALUES
           (@IdPuntoDeVenta
           ,@IdUsuario
           ,@FechaCreacion
           ,@IdEmpresa
           ,@AuditoriaNoAutorizada
           ,@Latitud
           ,@Longitud
           ,@Firma
		   ,@Precision
		   ,@Vejez
		   ,@FechaEnvio
		   ,GETDATE()
		   ,@FechaCierre)           
     
     SET @IdReporte = @@Identity
                    
END

GO
