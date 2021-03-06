SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reporte_Copiar]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Reporte_Copiar] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Reporte_Copiar] 
	-- Add the parameters for the stored procedure here
	@IdReporte int

	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
  DECLARE @IdReporte1 int
    
  INSERT INTO [dbo].[Reporte]
           ([IdPuntoDeVenta]
           ,[IdUsuario]
           ,[FechaCreacion]           
           ,[IdEmpresa]
           ,[AuditoriaNoAutorizada])
    (SELECT [IdPuntoDeVenta]
  		   ,[IdUsuario]
		   ,'2013-15-03 00:00:00.000'		   
		   ,[IdEmpresa]
		   ,[AuditoriaNoAutorizada]
	 FROM [dbo].[Reporte]
	 WHERE [IdReporte] = @IdReporte)

	 SET @IdReporte1 = @@Identity
	 
	 --ReporteExhibicion
	 INSERT INTO [dbo].[ReporteExhibicion]
           ([IdReporte]
           ,[IdMarca]
           ,[IdExhibidor]
           ,[Cantidad])
     (SELECT @IdReporte1
			,[IdMarca]
			,[IdExhibidor]
		    ,[Cantidad]
		FROM [dbo].[ReporteExhibicion]
		WHERE [IdReporte] = @IdReporte)

	 -- ReporteMarcaPropiedad
	 INSERT INTO [dbo].[ReporteMarcaPropiedad]
           ([IdReporte]
           ,[IdMarcaPropiedad])
     (SELECT @IdReporte1
			,[IdMarcaPropiedad]
	  FROM [dbo].[ReporteMarcaPropiedad]
	  WHERE [IdReporte] = @IdReporte)

	  -- ReportePop
	  INSERT INTO [dbo].[ReportePop]
           ([IdReporte]
           ,[IdMarca]
           ,[IdPop]
           ,[Cantidad])
	 (SELECT @IdReporte1
		    ,[IdMarca]
			,[IdPop]
			,[Cantidad]
	  FROM [dbo].[ReportePop]
	  WHERE [IdReporte] = @IdReporte)

	 -- ReporteProducto
	 INSERT INTO [dbo].[ReporteProducto]
		   ([IdReporte]
           ,[IdProducto]
           ,[Cantidad]
           ,[Precio]
           ,[Stock]
           ,[NoTrabaja]
           ,[IdExhibidor]
           ,[Cantidad2]
           ,[IdExhibidor2])     
       (SELECT @IdReporte1
		  ,[IdProducto]
		  ,[Cantidad]
		  ,[Precio]
		  ,[Stock]
		  ,[NoTrabaja]
		  ,[IdExhibidor]
          ,[Cantidad2]
          ,[IdExhibidor2]
	  FROM [dbo].[ReporteProducto]
	  WHERE [IdReporte] = @IdReporte)

	 -- ReporteProductoCompetencia
	 INSERT INTO [dbo].[ReporteProductoCompetencia]
           ([IdReporte]
           ,[IdProducto]
           ,[Cantidad]
           ,[Precio]
           ,[IdExhibidor]
           ,[Cantidad2]
           ,[IdExhibidor2]
           ,[IdMarca])
     (SELECT @IdReporte1
            ,[IdProducto]
            ,[Cantidad]
            ,[Precio]
            ,[IdExhibidor]
            ,[Cantidad2]
            ,[IdExhibidor2]
            ,[IdMarca]
	  FROM [dbo].[ReporteProductoCompetencia]
	  WHERE [IdReporte] = @IdReporte)

	-- ReporteVidriera
	INSERT INTO [dbo].[ReporteVidriera]
			   ([IdReporte]
			   ,[IdMarca]
			   ,[Armada]
			   ,[NecesitaMantenimiento]
			   ,[IdCampania])
	(SELECT @IdReporte1
		   ,[IdMarca]
		   ,[Armada]
		   ,[NecesitaMantenimiento]
		   ,[IdCampania]
	  FROM [dbo].[ReporteVidriera]
	  WHERE [IdReporte] = @IdReporte)

END
GO
