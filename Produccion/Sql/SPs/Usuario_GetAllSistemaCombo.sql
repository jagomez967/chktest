SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuario_GetAllSistemaCombo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Usuario_GetAllSistemaCombo] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Usuario_GetAllSistemaCombo]
	-- Add the parameters for the stored procedure here
	 @IdSistema int 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
  	
  		SELECT U.[IdUsuario]		 
			  ,U.[Nombre]
			  ,U.[Apellido]
			  ,ISNULL([Apellido],'') + ', ' + ISNULL([Nombre],'') COLLATE DATABASE_DEFAULT  As NombreApellido
			  ,U.[DiferenciaHora]
			  ,U.[DiferenciaMinutos]
  FROM [dbo].[Usuario] U 
  INNER JOIN UsuarioPerfil UP ON (U.[IdUsuario] = UP.[IdUsuario]) 
  INNER JOIN Perfil P ON (P.[IdPerfil] = UP.[IdPerfil] and P.IdSistema = @IdSistema) 
  GROUP BY U.[IdUsuario],U.[Nombre],U.[Apellido],U.[DiferenciaHora],U.[DiferenciaMinutos]
  ORDER BY U.[Apellido]
  
END
GO
