SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuario_Cliente_GetAllUsuarioBusqueda]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Usuario_Cliente_GetAllUsuarioBusqueda] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Usuario_Cliente_GetAllUsuarioBusqueda]
	-- Add the parameters for the stored procedure here
	 @IdEmpresa int
    ,@IdGrupo int 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    SELECT U.[IdUsuario]		  
	 	   ,U.Nombre
		   ,U.Apellido
		   ,U.DiferenciaHora
		   ,U.DiferenciaMinutos
	  FROM [dbo].[Usuario_Cliente] UC
	  INNER JOIN Cliente C ON (C.[IdCliente] = UC.[IdCliente] and  @IdEmpresa = C.[IdEmpresa])
	  INNER JOIN Empresa E ON (C.[IdEmpresa] = E.[IdEmpresa] )
	  INNER JOIN Usuario U ON (U.[IdUsuario] = UC.[IdUsuario])
	  INNER JOIN UsuarioGrupo UG ON (U.[IdUsuario] = UG.[IdUsuario] AND UG.[IdGrupo] = @IdGrupo)
	  GROUP BY U.[IdUsuario],U.Nombre,U.Apellido,U.DiferenciaHora,U.DiferenciaMinutos
	  ORDER BY U.Apellido
	  	  
END
GO
