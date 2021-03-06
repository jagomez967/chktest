SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Drogueria_GetAll_Cliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Drogueria_GetAll_Cliente] AS' 
END
GO
ALTER PROCEDURE [dbo].[Drogueria_GetAll_Cliente]

   @IdEmpresa int = NULL

AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @IdCliente int
	
	SELECT @IdCliente = C.IdCliente FROM CLiente C WHERE C.IdEmpresa = @IdEmpresa 
	
	SELECT D.IdDrogueria
	      ,D.Nombre
	FROM [dbo].[Drogueria] D	
	INNER JOIN [Drogueria_Cliente]  DC ON (DC.IdDrogueria = D.IdDrogueria AND DC.IdCliente = @IdCliente)	
	Order By D.Nombre

END
GO
