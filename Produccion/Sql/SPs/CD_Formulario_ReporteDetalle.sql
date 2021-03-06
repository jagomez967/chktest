SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Formulario_ReporteDetalle]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Formulario_ReporteDetalle] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Formulario_ReporteDetalle]
	-- Add the parameters for the stored procedure here
	@FechaCargaDesde datetime = NULL
   ,@FechaCargaHasta datetime = NULL   
   ,@IdSistema int 
   ,@IdPuntoDeVenta int = NULL
   ,@IdVisitador int = NULL
   ,@IdCampania int = NULL
   ,@Vencido bit = NULL
   ,@SinRecetaOriginal bit = NULL
   ,@SinTicket bit = NULL
   ,@NroTicket varchar(50) = NULL
   ,@IdMedico int = NULL
   ,@IdUsuario int = NULL
   
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  P.[Codigo] AS ProductoCodigo
       ,P.[Nombre] AS ProductoNombre
       ,FI.Cantidad 
       ,V.[Nombre] AS VisitadorNombre
       ,R.[Nombre] AS RepresentanteNombre 
       ,C.[IdCampania] CampaniaId       
       ,C.Nombre AS CampaniaNombre
       ,PDV.[Codigo] AS PDVCodigo
       ,PDV.[Nombre] AS PDVNombre       
       ,F.[IdFormulario]       
       ,F.[IdMedico] AS MedicoId
       ,M.Nombre AS MedicoNombre
       ,F.[FechaReceta]
       ,F.[FechaTicket]
       ,F.[FechaCarga]
       ,F.[FechaActualizacion]
       --,[IdUsuario]
       ,F.[NroTicket]
       ,F.[Activo]
       ,F.[Vencido]
       ,F.[SinTicket]
       ,F.[SinRecetaOriginal]
  FROM [dbo].[CD_FormularioItem] FI
  INNER JOIN CD_Formulario AS F ON (F.[IdFormulario] = FI.[IdFormulario])   
  INNER JOIN CD_Producto AS P ON (P.[IdProducto] =  FI.[IdProducto]) 
  INNER JOIN CD_PuntoDeVenta AS PDV ON (PDV.[IdPuntoDeVenta] = F.[IdPuntoDeVenta] )
  INNER JOIN  CD_PuntoDeVenta_Sistema PDVS ON ( PDVS.IdPuntoDeVenta = PDV.IdPuntoDeVenta AND PDVS.IdSistema = @IdSistema)
  INNER JOIN CD_Campania AS C ON (C.[IdCampania] = F.[IdCampania] AND C.IdSistema = @IdSistema)
  --LEFT  JOIN CD_Visitador AS V ON (V.[IdVisitador] = PDVS.[IdVisitador])   
  LEFT JOIN CD_Representante AS R ON (R.IdRepresentante = PDVS.IdRepresentante)
  LEFT JOIN CD_Medico AS M ON (M.IdMedico = F.[IdMedico])
  LEFT JOIN CD_Medico_Sistema AS MS ON (MS.IdMedico = M.IdMedico AND MS.IdSistema = @IdSistema)  
  LEFT JOIN CD_Visitador AS V ON (V.[IdVisitador] = MS.[IdVisitador1]) 

  WHERE    @FechaCargaDesde IS NULL OR  (CONVERT(varchar(8), F.[FechaCarga], 112)  between CONVERT(varchar(8), @FechaCargaDesde, 112)  AND  CONVERT(varchar(8), @FechaCargaHasta, 112) ) 
	 AND  (@IdPuntoDeVenta IS NULL OR @IdPuntoDeVenta = F.[IdPuntoDeVenta])
	 --AND  (@IdVisitador IS NULL OR @IdVisitador = PDVS.[IdVisitador])	 
	 AND  (@IdVisitador IS NULL OR @IdVisitador = V.[IdVisitador])	 
	 AND  (@IdMedico IS NULL OR @IdMedico = F.[IdMedico])
	 AND (@IdUsuario IS NULL OR @IdUsuario = F.[IdUsuario])
     AND (@IdCampania IS NULL OR @IdCampania = F.[IdCampania])
     AND (@Vencido IS NULL OR F.[Vencido]=1) 
     AND (@SinTicket IS NULL OR F.[SinTicket]=1)
     AND (@SinRecetaOriginal IS NULL OR F.[SinRecetaOriginal]=1)
     AND (@NroTicket IS NULL OR @NroTicket = F.[NroTicket])
  ORDER BY F.[FechaCarga]


END
GO
