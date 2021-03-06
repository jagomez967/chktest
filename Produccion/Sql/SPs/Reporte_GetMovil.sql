SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reporte_GetMovil]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Reporte_GetMovil] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Reporte_GetMovil]
	-- Add the parameters for the stored procedure here
	@IdUsuario int 
   ,@Fecha datetime =  NULL
		
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE  @ANO varchar(4)
	DECLARE  @MES varchar(2)
	
	DECLARE @FechaInicio DateTime
		
	IF (@Fecha  IS NULL)
	BEGIN
		SET @Fecha = CAST(DATEPART(year, GETDATE())+'-'+ DATEPART(month, GETDATE()) + '-01' AS DATETIME)	
	END
		
	SELECT R.[IdReporte]
		  ,R.[IdPuntoDeVenta]
		  ,R.[FechaCreacion]     
		  ,R.[IdEmpresa]	
		  ,R.[Precision]
		  ,R.[Vejez]
		  ,R.[FechaEnvio]
		  ,R.[FechaRecepcion]
		  ,C.IdCliente
  FROM [dbo].[Reporte] R
  INNER JOIN [dbo].[Cliente] C ON (C.IdEmpresa = R.IdEmpresa) 
  WHERE  @IdUsuario = R.[IdUsuario] AND 
         MONTH(R.[FechaCreacion]) = MONTH(GETDATE()) AND 
         Year(R.[FechaCreacion]) = Year(GETDATE()) AND 
         R.[FechaCreacion] >=  @Fecha
ORDER BY R.[FechaCreacion]  
                  
END
GO
