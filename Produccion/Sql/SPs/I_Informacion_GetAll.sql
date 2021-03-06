SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_Informacion_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_Informacion_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[I_Informacion_GetAll]
	
	@IdInformacion int = NULL
   ,@FechaDesde DateTime = NULL
   ,@FechaHasta DateTime = NULL
   ,@IdPuntoDeVenta int = NULL
   ,@IdUsuario int = NULL
   ,@IdCadena int = NULL
   ,@IdCliente int = NULL
   ,@Titulo varchar(500) = NULL
   ,@Mensaje varchar(MAX) = NULL
   ,@Activo bit = NULL
   
AS
BEGIN
	SET NOCOUNT ON;

	SELECT I.[IdInformacion]
		  ,I.[Titulo]
		  ,I.[Mensaje]
		  ,I.[FechaAlta]
		  ,I.[FechaModificacion]
		  ,I.[Activo]
  FROM [dbo].[I_Informacion] I
  WHERE (@IdInformacion IS NULL OR @IdInformacion = I.[IdInformacion]) AND
        (@Titulo IS NULL OR I.[Titulo] like '%' + @Titulo + '%') AND
        (@Mensaje IS NULL OR I.[Mensaje] like '%'+ @Mensaje + '%') AND
        (@FechaDesde IS NULL OR [FechaAlta] Between @FechaDesde AND @FechaHasta) AND        
        (@IdPuntoDeVenta IS NULL OR EXISTS (SELECT * FROM I_InformacionAsignacion IA WHERE IA.IdInformacion = I.IdInformacion AND IA.IdInformacionTipo=2 AND IA.IdAsignacion2 = @IdPuntoDeVenta AND @IdCliente=IA.IdAsignacion1))  AND
        (@IdCadena IS NULL OR EXISTS (SELECT * FROM I_InformacionAsignacion IA WHERE IA.IdInformacion = I.IdInformacion AND IA.IdInformacionTipo=4 AND IA.IdAsignacion2 = @IdCadena AND @IdCliente=IA.IdAsignacion1))  AND       
        --((@IdCliente IS NULL AND NOT  @IdCadena IS NULL AND NOT @IdPuntoDeVenta  IS NULL)  OR EXISTS (SELECT * FROM I_InformacionAsignacion IA WHERE IA.IdInformacion = I.IdInformacion AND IA.IdInformacionTipo=1 AND @IdCliente=IA.IdAsignacion1))  --AND
	    (@IdUsuario IS NULL OR EXISTS (SELECT * FROM I_InformacionAsignacion IA WHERE IA.IdInformacion = I.IdInformacion AND IA.IdInformacionTipo=3 AND @IdUsuario=IA.IdAsignacion1)) AND
		(@IdCadena IS NOT NULL OR @IdPuntoDeVenta IS NOT NULL)  
  UNION
  
  SELECT I.[IdInformacion]
		  ,I.[Titulo]
		  ,I.[Mensaje]
		  ,I.[FechaAlta]
		  ,I.[FechaModificacion]
		  ,I.[Activo]
  FROM [dbo].[I_Informacion] I
  WHERE (@IdInformacion IS NULL OR @IdInformacion = I.[IdInformacion]) AND
        (@Titulo IS NULL OR I.[Titulo] like '%' + @Titulo + '%') AND
        (@Mensaje IS NULL OR I.[Mensaje] like '%'+ @Mensaje + '%') AND
        (@FechaDesde IS NULL OR [FechaAlta] Between @FechaDesde AND @FechaHasta) AND        
        (@IdCliente IS NULL OR EXISTS (SELECT * FROM I_InformacionAsignacion IA WHERE IA.IdInformacion = I.IdInformacion AND IA.IdInformacionTipo in (1,2,4) AND @IdCliente=IA.IdAsignacion1))  AND
	    (@IdUsuario IS NULL OR EXISTS (SELECT * FROM I_InformacionAsignacion IA WHERE IA.IdInformacion = I.IdInformacion AND IA.IdInformacionTipo=3 AND @IdUsuario=IA.IdAsignacion1)) AND
        (@IdCadena IS NULL AND @IdPuntoDeVenta IS NULL)
  ORDER BY I.[IdInformacion]  DESC
    
END
GO
