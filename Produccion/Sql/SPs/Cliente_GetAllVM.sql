SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cliente_GetAllVM]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Cliente_GetAllVM] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Cliente_GetAllVM]
	-- Add the parameters for the stored procedure here
	 @IdCliente int = NULL
	,@Nombre varchar(50) =  NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT C.[IdCliente]
		  ,C.[Nombre]
		  ,C.[IdEmpresa]
		  ,C.[Transfer]
		  ,C.[Dermoestetica]
		  ,C.[Mantenimiento]
		  ,C.[VisitadorMedico]
		  ,C.[Capacitacion]
		  ,C.[Imagen]
		  ,C.[ImagenWeb]
		  ,C.[ImagenMovil]
		  ,C.[Latitud]
		  ,C.[Longitud]
		  ,C.[DiferenciaHora]
		  ,C.[DiferenciaMinutos]
		  ,E.[Nombre] AS Empresa
		  ,CASE WHEN C.[Transfer] = 1 THEN 'SI'							
				ELSE 'NO'
		   END AS TransferTexto
		  ,CASE WHEN C.[Dermoestetica] = 1 THEN 'SI'				
				ELSE 'NO'
		   END AS DermoesteticaTexto
  		  ,CASE WHEN C.[Mantenimiento] = 1 THEN 'SI'				
				ELSE 'NO'
		   END AS MantenimientoTexto
		   ,CASE WHEN C.[VisitadorMedico] = 1 THEN 'SI'				
				ELSE 'NO'
		   END AS VisitadorMedicoTexto
		   		   ,CASE WHEN C.[Capacitacion] = 1 THEN 'SI'				
				ELSE 'NO'
		   END AS CapacitacionTexto
	FROM [dbo].[Cliente] C
  	INNER JOIN [dbo].[Empresa] E ON (C.[IdEmpresa] = E.[IdEmpresa])
	WHERE (@IdCliente IS NULL OR @IdCliente = C.[IdCliente]) AND
	      (@Nombre IS NULL OR C.[Nombre] like '%' + @Nombre + '%') AND
	      C.[VisitadorMedico]=1
  
END
GO
