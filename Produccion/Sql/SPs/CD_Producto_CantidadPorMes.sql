SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Producto_CantidadPorMes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Producto_CantidadPorMes] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Producto_CantidadPorMes]
	-- Add the parameters for the stored procedure here
	@Mes int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT C.Nombre AS Franquicia
      --,P.[IdProducto]      
      ,P.Nombre As Producto
      ,dbo.CD_CantidadPorductosRecetadosMes(P.[IdProducto],@Mes)      
	  FROM CD_Producto P  
	  LEFT JOIN CD_Producto_Campania PC ON(PC.[IdProducto] = P.[IdProducto])
	  LEFT JOIN CD_Campania C ON (C.IdCampania = PC.IdCampania)
	  ORDER BY C.Nombre, P.Nombre

END
GO
