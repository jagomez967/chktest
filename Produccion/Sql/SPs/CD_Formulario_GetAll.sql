SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Formulario_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Formulario_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Formulario_GetAll]
	
	@IdFormulario int = NULL
   ,@IdCampania int = NULL
   ,@FechaCargaDesde datetime = NULL
   ,@FechaCargaHasta datetime = NULL
   ,@FechaRecetaDesde datetime = NULL
   ,@FechaRecetaHasta datetime = NULL
   ,@IdPuntoDeVenta int = NULL
   ,@NroTicket varchar(50)=NULL
   ,@IdMedico int = NULL
   ,@IdUsuario int = NULL
   ,@FechaTicketDesde datetime = NULL
   ,@FechaTicketHasta datetime = NULL
   ,@IdSistema int 
   
AS
BEGIN
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT F.[IdFormulario]
		  ,F.[IdCampania]
		  ,F.[IdPuntoDeVenta]
		  ,F.[IdMedico]
		  ,F.[FechaReceta]
		  ,F.[FechaTicket]
		  ,F.[FechaCarga]
		  ,F.[FechaActualizacion]
		  ,F.[IdUsuario]
		  ,F.[NroTicket]
		  ,F.[Activo]
		  ,F.[Vencido]
          ,F.[SinTicket]
          ,F.[SinRecetaOriginal]
		  ,C.Nombre AS NombreCampania
		  ,PDV.Nombre AS NombrePDV
		  ,M.Nombre AS NombreMedico
		  --,U.Nombre AS NombreUsuario
		  ,ISNULL(U.[Apellido],'') + ', ' + ISNULL(U.[Nombre],'') COLLATE DATABASE_DEFAULT  As NombreUsuario
  FROM [CD_Formulario] F
  INNER JOIN [CD_Campania] AS C ON (C.[IdCampania] = F.[IdCampania] AND  C.[IdSistema] = @IdSistema)
  LEFT JOIN [CD_PuntoDeVenta] AS PDV ON (PDV.[IdPuntoDeVenta] = F.[IdPuntoDeVenta] )
  LEFT JOIN [CD_Medico] AS M ON (M.[IdMedico] = F.[IdMedico])
  LEFT JOIN [Usuario] AS U ON (U.[IdUsuario] = F.[IdUsuario])
  --LEFT JOIN [CD_Usuario] AS U ON (U.[IdUsuario] = F.[IdUsuario])
  WHERE (@IdFormulario IS NULL OR @IdFormulario =  F.[IdFormulario])
    AND (@IdCampania IS NULL OR @IdCampania = F.[IdCampania])
    AND (@IdPuntoDeVenta IS NULL OR @IdPuntoDeVenta = F.[IdPuntoDeVenta])
    AND (@IdMedico IS NULL OR @IdMedico = F.[IdMedico])
    AND (@NroTicket IS NULL OR @NroTicket = F.[NroTicket])
    AND (@IdUsuario IS NULL OR @IdUsuario = F.[IdUsuario])
	--AND (@FechaCargaDesde IS NULL OR  (F.[FechaCarga] between @FechaCargaDesde AND  @FechaCargaHasta))
	AND (@FechaCargaDesde IS NULL OR  (CONVERT(varchar(8), F.[FechaCarga], 112)  between CONVERT(varchar(8), @FechaCargaDesde, 112)  AND  CONVERT(varchar(8), @FechaCargaHasta, 112)))
	AND (@FechaRecetaDesde IS NULL OR  (F.[FechaReceta] between @FechaRecetaDesde AND  @FechaRecetaHasta))	
	AND (@FechaTicketDesde IS NULL OR  (F.[FechaTicket] between @FechaTicketDesde AND  @FechaTicketHasta))
	
END
GO
