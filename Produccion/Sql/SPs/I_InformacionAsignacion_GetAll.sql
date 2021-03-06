SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_InformacionAsignacion_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_InformacionAsignacion_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[I_InformacionAsignacion_GetAll]

	@IdInformacion int
AS
BEGIN
	SET NOCOUNT ON;

    --Cliente
	SELECT IA.[IdInformacionAsignacion]	      
		  ,T.Nombre AS Tipo
		  ,C.Nombre AS Cliente
		  ,'' AS Usuario
		  ,'' AS PuntoDeVenta
		  ,'' AS Cadena		  
	  FROM [dbo].[I_InformacionAsignacion]  IA
	  INNER JOIN [dbo].[Cliente] C ON (IA.IdAsignacion1 = C.IdCliente)
	  INNER JOIN [dbo].[I_InformacionTipo] T ON (IA.[IdInformacionTipo] = T.[IdInformacionTipo])
	  WHERE [IdInformacion]=@IdInformacion AND 
	        IA.[IdInformacionTipo] = 1

	UNION
    
    --PuntoDeVenta/Cliente
	SELECT IA.[IdInformacionAsignacion]	      
		  ,T.Nombre AS Tipo
		  ,C.Nombre AS Cliente
		  ,'' AS Usuario
		  ,ISNULL(CONVERT(varchar(50),PDV.[Codigo]),'') + ' - ' + ISNULL(PDV.[Nombre],'') + ' - ' + ISNULL(PDV.[Direccion],'') COLLATE DATABASE_DEFAULT  As PuntoDeVenta
		  ,'' AS Cadena		  
	  FROM [dbo].[I_InformacionAsignacion]  IA
	  INNER JOIN [dbo].[Cliente] C ON (IA.IdAsignacion1 = C.IdCliente)
	  INNER JOIN PuntoDeVenta PDV ON  (IA.IdAsignacion2 = PDV.[IdPuntoDeVenta])
	  INNER JOIN [dbo].[I_InformacionTipo] T ON (IA.[IdInformacionTipo] = T.[IdInformacionTipo])
	  WHERE [IdInformacion]=@IdInformacion AND 
	        IA.[IdInformacionTipo] = 2
	        	        
	 UNION
	 --Usuario
	SELECT IA.[IdInformacionAsignacion]	      
		  ,T.Nombre AS Tipo
		  ,'' AS Cliente
		  ,ISNULL(U.[Apellido],'') + ', ' + ISNULL(U.[Nombre],'') COLLATE DATABASE_DEFAULT   AS Usuario
		  ,''  As PuntoDeVenta
		  ,'' AS Cadena		  
	  FROM [dbo].[I_InformacionAsignacion]  IA
	  INNER JOIN [dbo].[Usuario] U ON (IA.IdAsignacion1 = U.IdUsuario)
	  INNER JOIN [dbo].[I_InformacionTipo] T ON (IA.[IdInformacionTipo] = T.[IdInformacionTipo])
	  WHERE [IdInformacion]=@IdInformacion AND
	        IA.[IdInformacionTipo] = 3

    UNION
    --Cadena/Cliente
	SELECT IA.[IdInformacionAsignacion]	      
		  ,T.Nombre AS Tipo
		  ,C.Nombre AS Cliente
		  ,'' AS Usuario
		  ,'' As PuntoDeVenta
		  ,CA.Nombre AS Cadena		  
	  FROM [dbo].[I_InformacionAsignacion]  IA
	  INNER JOIN [dbo].[Cliente] C ON (IA.IdAsignacion1 = C.IdCliente)
	  INNER JOIN [dbo].[Cadena] CA ON  (IA.IdAsignacion2 = CA.[IdCadena])
	  INNER JOIN [dbo].[I_InformacionTipo] T ON (IA.[IdInformacionTipo] = T.[IdInformacionTipo])
	  WHERE [IdInformacion]=@IdInformacion AND 
	        IA.[IdInformacionTipo] = 4
	
	UNION
	    --Todo
	SELECT IA.[IdInformacionAsignacion]	      
		  ,T.Nombre AS Tipo
		  ,'' AS Cliente
		  ,'' AS Usuario
		  ,'' As PuntoDeVenta
		  ,'' AS Cadena		  
	  FROM [dbo].[I_InformacionAsignacion]  IA
	  INNER JOIN [dbo].[I_InformacionTipo] T ON (IA.[IdInformacionTipo] = T.[IdInformacionTipo])
	  WHERE [IdInformacion]=@IdInformacion AND 
	        IA.[IdInformacionTipo] = 5

	  
END
GO
