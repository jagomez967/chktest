SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Zona_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Zona_GetAllCliente] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Zona_GetAllCliente]
	@IdCliente int
   ,@Nombre VARCHAR(100) = NULL	
	
AS
BEGIN
  SET NOCOUNT ON;

--IF (@IdEmpresa IS NOT NULL)
--BEGIN
--  Declare @IdCliente int	
--  SELECT @IdCliente =  IdCliente FROM Cliente WHERE IdEmpresa = @IdEmpresa 
    
SELECT Z.[IdZona]
      ,Z.[Nombre]
  FROM [dbo].[Zona] Z  
  --INNER JOIN dbo.Zona_Cliente ZC ON (Z.IdZona = ZC.IdZona AND ZC.IdCliente = @IdCliente)
  WHERE (@IdCLiente = Z.IdCliente) AND
		(@Nombre IS NULL OR Z.[Nombre] like '%' + @Nombre + '%')
  GROUP BY  Z.[IdZona], Z.[Nombre]
  ORDER BY Z.[Nombre]
--END
--ELSE
--BEGIN
--  SELECT Z.[IdZona]
--      ,Z.[Nombre]
--  FROM [dbo].[Zona] Z
--  WHERE (@Nombre IS NULL OR Z.[Nombre] like '%' + @Nombre + '%')
--END
END
GO
