SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cliente_DeleteMasivo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Cliente_DeleteMasivo] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Cliente_DeleteMasivo]
	
AS
BEGIN
	SET NOCOUNT ON;

DECLARE @IdEmpresa int

--Este valor despues cambiar
SET @IdEmpresa = 1

--01 Datos eliminar Productos
--Eliminar Productos Competencia
DELETE FROM [dbo].[ProductoCompetencia]
FROM [dbo].[ProductoCompetencia] PC
INNER JOIN [dbo].[Producto] P ON (PC.IdProducto = P.IdProducto)
INNER JOIN [dbo].[Marca] M  ON (M.IdMarca = P.IdMarca)
WHERE M.[IdEmpresa]=@IdEmpresa


--Eliminar Productos Competencia
DELETE FROM [dbo].[ProductoCompetencia]
FROM [dbo].[ProductoCompetencia] PC1
INNER JOIN [dbo].[Producto] P ON (PC1.IdProductoCompetencia = P.IdProducto)
INNER JOIN [dbo].[Marca] M  ON (M.IdMarca = P.IdMarca)
WHERE M.[IdEmpresa]=@IdEmpresa



--Eliminar Productos
DELETE FROM [dbo].[Producto]
FROM [dbo].[Producto] P
INNER JOIN [dbo].[Marca] M  ON (M.IdMarca = P.IdMarca)
WHERE M.[IdEmpresa]=@IdEmpresa


-- 02 Eliminar Marcas
--Eliminar Marca Competencia
DELETE FROM [dbo].[MarcaCompetencia]
FROM [dbo].[MarcaCompetencia] MC
INNER JOIN [dbo].[Marca] M ON (M.IdMarca = MC.IdMarca)  
WHERE M.[IdEmpresa]=@IdEmpresa


--Eliminar Marca Competencia
DELETE FROM [dbo].[MarcaCompetencia]
FROM [dbo].[MarcaCompetencia] MC1
INNER JOIN [dbo].[Marca] M ON (M.IdMarca = MC1.[IdMarcaCompetencia])  
WHERE M.[IdEmpresa]=@IdEmpresa


DELETE FROM [dbo].[Marca]
FROM [dbo].[Marca] M  
WHERE M.[IdEmpresa]=@IdEmpresa


END
GO
