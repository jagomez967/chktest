SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Negocio_GetAllCliente2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Negocio_GetAllCliente2] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Negocio_GetAllCliente2]
	-- Add the parameters for the stored procedure here
	 @IdCliente int = NULL
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
	INNER JOIN		Empresa E --AGREGADO
	ON				N.IdNegocio = E.IdNegocio --AGREGADO
	INNER JOIN		Cliente C --AGREGADO
	ON				C.IdEmpresa = E.IdEmpresa --AGREGADO
	--INNER JOIN		@ListaClientes LC
	--ON				C.IdCliente = LC.IdCliente
	WHERE			(C.IdCliente = @IdCliente) AND
					(@Nombre IS NULL OR N.[Nombre] like '%' + @Nombre + '%')
	
END
GO
