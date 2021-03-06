SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VM_ReporteVisitadorMaterial_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VM_ReporteVisitadorMaterial_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[VM_ReporteVisitadorMaterial_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdReporteVisitador int = NULL
	,@IdCliente int = NULL
	,@IdMarca int = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
	SELECT M.[IdMaterial]
		  ,M.[IdCliente]
		  ,M.[Nombre]
		  ,M.[Activo]
		  ,VMR.Cantidad
		  ,VMR.IdMarca
  FROM [dbo].[VM_Material] M  
  LEFT JOIN VM_ReporteVisitadorMaterial VMR ON (VMR.[IdMaterial] =  M.[IdMaterial] AND VMR.IdMarca=@IdMarca AND VMR.IdReporteVisitador = @IdReporteVisitador)
  WHERE M.[IdCliente] = @IdCliente

	
	
	--SELECT VM.[IdMaterial]
	--	  ,VM.[IdCliente]
	--	  ,VM.[Nombre]
	--	  ,VM.[Activo]
	--	  ,VMR.Cantidad 
	--	  ,VMR.IdMarca		     
 --   FROM [VM_ReporteVisitadorMaterial] VMR  
	--INNER JOIN [dbo].[VM_Material] VM ON (VM.[IdMaterial] = VMR.[IdMaterial] AND VMR.IdReporteVisitador = @IdReporteVisitador AND @IdMarca = VMR.[IdMarca])    
	--WHERE  @IdCliente = VM.[IdCliente] 	   
	--ORDER BY VM.[Nombre]
		
END
GO
