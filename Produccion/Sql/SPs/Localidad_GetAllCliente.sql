SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Localidad_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Localidad_GetAllCliente] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Localidad_GetAllCliente]
	@IdCliente int = NULL
   ,@Nombre varchar(50) =  NULL
AS
BEGIN
  SET NOCOUNT ON;

--IF (@IdEmpresa IS NOT NULL)
BEGIN
  --Declare @IdCliente int	
  --SELECT @IdCliente =  IdCliente FROM Cliente WHERE IdEmpresa = @IdEmpresa 
    
  SELECT LO.[IdLocalidad]      
      ,LO.[Nombre]
      ,P.Nombre AS NombreProvincia
  FROM [dbo].[Localidad] LO  
  INNER JOIN Provincia P ON (P.IdProvincia = LO.IdProvincia)
  --INNER JOIN Localidad_Cliente LC
  --ON LC.IdCliente = @IdCliente AND LO.IdLocalidad = LC.IdLocalidad  
  WHERE (@IdCliente = P.IdCliente) AND
		(@Nombre IS NULL OR LO.[Nombre] like '%' + @Nombre + '%')
  GROUP BY  LO.[IdLocalidad], LO.[Nombre], P.Nombre
  ORDER BY LO.[Nombre]
END
--ELSE
--BEGIN
--  SELECT LO.[IdLocalidad]      
--      ,LO.[Nombre]
--      ,P.Nombre AS NombreProvincia
--  FROM [dbo].[Localidad] LO  
--  INNER JOIN Provincia P ON (P.IdProvincia = LO.IdProvincia)
--  WHERE (@Nombre IS NULL OR P.[Nombre] like '%' + @Nombre +'%')
--END
END
GO
