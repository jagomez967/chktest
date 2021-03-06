SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Negocio_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Negocio_GetAllCliente] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Negocio_GetAllCliente]
	-- Add the parameters for the stored procedure here
	 @ListaClientes ListaClientes READONLY
	,@IdEmpresa int = NULL
	,@Nombre varchar(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT	N.IdNegocio
				   ,N.Nombre
	FROM			Negocio N
	INNER JOIN		Empresa E
	ON				N.IdNegocio = E.IdNegocio
	INNER JOIN		Cliente C
	ON				C.IdEmpresa = E.IdEmpresa
	INNER JOIN		@ListaClientes LC
	ON				C.IdCliente = LC.IdCliente
	WHERE			(@IdEmpresa IS NULL OR E.[IdEmpresa] = @IdEmpresa) AND
					(@Nombre IS NULL OR N.[Nombre] like '%' + @Nombre + '%')
	
END
GO
