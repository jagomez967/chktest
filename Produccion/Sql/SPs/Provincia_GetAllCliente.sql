SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Provincia_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Provincia_GetAllCliente] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Provincia_GetAllCliente]
	-- Add the parameters for the stored procedure here
	 @IdCliente int = NULL
	,@Nombre varchar(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
--IF (@IdCliente IS NOT NULL)
--BEGIN
	SELECT P.[IdProvincia]
	      ,P.[Nombre]
	FROM  [dbo].[Provincia] P
	--INNER JOIN dbo.Provincia_Cliente PC
	--ON (PC.IdCliente = @IdCliente)
	WHERE	(@IdCliente = P.IdCLiente) AND
			(@Nombre IS NULL OR [Nombre] like '%' + @Nombre + '%')
	ORDER BY P.[Nombre]
--END
--ELSE
--BEGIN
--    SELECT	IdProvincia
--		   ,Nombre
--	FROM	dbo.Provincia
--	WHERE (@Nombre IS NULL OR [Nombre] like '%' + @Nombre + '%')
--END

END
GO
