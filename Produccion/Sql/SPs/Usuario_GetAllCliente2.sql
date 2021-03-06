SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuario_GetAllCliente2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Usuario_GetAllCliente2] AS' 
END
GO
ALTER PROCEDURE [dbo].[Usuario_GetAllCliente2]

	@IdCliente INT = NULL
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT U.[IdUsuario]
	      ,U.[IdGrupo]
		  ,U.[Nombre]
		  ,U.[Apellido]
		  ,U.[Usuario]
		  ,U.[Clave]
		  ,U.[Email]
          ,U.[Email]
          ,U.[Telefono]
          ,U.[Comentarios]		  
		  ,U.[CambioPassword]
		  ,U.[Activo]
		  ,ISNULL([Apellido],'') + ', ' + ISNULL([Nombre],'') COLLATE DATABASE_DEFAULT  As NombreApellido
		  ,U.[DiferenciaHora]
		  ,U.[DiferenciaMinutos]
		  ,CASE 
		   WHEN [Activo] = 1 THEN 'SI' 			
			ELSE 'NO' 
		   END ActivoTexto		  
	  FROM [dbo].[Usuario] U
	  INNER JOIN Usuario_Cliente UC ON (U.IdUsuario = UC.IdUsuario)
	  --INNER JOIN @ListaClientes LC ON (UC.IdCliente = LC.IdCliente)
	  WHERE (@IdCliente = UC.IdCliente)
	  GROUP BY u.idusuario, u.IdGrupo, u.Nombre, u.apellido, u.usuario, u.clave, u.email, u.Telefono, u.comentarios, u.CambioPassword, u.Activo, u.DiferenciaHora, u.DiferenciaMinutos
	  ORDER BY [Apellido] + ', ' + [Nombre] COLLATE DATABASE_DEFAULT
	  
	  
END
GO
