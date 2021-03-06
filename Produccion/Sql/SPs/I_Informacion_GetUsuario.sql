SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_Informacion_GetUsuario]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_Informacion_GetUsuario] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[I_Informacion_GetUsuario]
	-- Add the parameters for the stored procedure here
	@IdUsuario int
   ,@FechaDesde DateTime = NULL
  
   
AS
BEGIN
SET NOCOUNT ON;

DECLARE @IdCliente int
-- Primero saco los Clientes del usuario    

CREATE TABLE #Info([IdInformacion] [int]  NOT NULL,[IdPuntoDeVenta] [int] NULL,[IdUsuario] [int] NULL,
	[IdCadena] [int] NULL,[IdCliente] [int] NULL,[Titulo] [varchar](500) NOT NULL,[Mensaje] [varchar](max) NULL,
	[FechaAlta] [datetime] NULL,[FechaModificacion] [datetime] NULL,[Activo] [bit] NOT NULL,[FechaRelacion] [datetime] NULL)

DECLARE cliente_cursor CURSOR FOR
SELECT UC.[IdCliente]		  
FROM [dbo].[Usuario_Cliente] UC	
WHERE UC.[IdUsuario] = @IdUsuario    

OPEN cliente_cursor
        
FETCH NEXT FROM cliente_cursor
INTO  @IdCliente

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @IdCliente
    --Informacion PDV
    --1 Obtengo Informacion por los PDV y IdCliente.    
    INSERT INTO #Info([IdInformacion],[IdPuntoDeVenta],[IdUsuario],[IdCadena],[IdCliente],[Titulo],[Mensaje],[FechaAlta],[FechaModificacion],[Activo],[FechaRelacion])
   (SELECT I.[IdInformacion],IA.IdAsignacion2,NULL,NULL,IA.IdAsignacion1,I.[Titulo],I.[Mensaje],I.[FechaAlta],I.[FechaModificacion],I.[Activo],IA.FechaAlta
	FROM [dbo].[I_Informacion] I
	INNER JOIN [dbo].[I_InformacionAsignacion] IA ON (IA.IdInformacionTipo =2 AND IA.IdInformacion = I.[IdInformacion] AND IA.IdAsignacion1 =@IdCliente)
	WHERE dbo.PuntoDeVenta_Cliente_Usuario_GetActivo(@IdCliente, IA.IdAsignacion2,@IdUsuario) =1)

 --   --2 Obtengo Informacio por Cadena y Cliente.
    INSERT INTO #Info([IdInformacion],[IdPuntoDeVenta],[IdUsuario],[IdCadena],[IdCliente],[Titulo],[Mensaje],[FechaAlta],[FechaModificacion],[Activo],[FechaRelacion])
   (SELECT I.[IdInformacion],PDV.[IdPuntoDeVenta] ,NULL,IA.IdAsignacion2,IA.IdAsignacion1,I.[Titulo],I.[Mensaje],I.[FechaAlta],I.[FechaModificacion],I.[Activo],IA.FechaAlta
	FROM [dbo].[I_Informacion] I
	INNER JOIN [dbo].[I_InformacionAsignacion] IA ON (IA.IdInformacionTipo =4 AND IA.IdInformacion = I.[IdInformacion] AND IA.IdAsignacion1 =@IdCliente)
	INNER JOIN [dbo].[PuntoDeVenta] PDV ON (PDV.[IdCadena] = IA.IdAsignacion2)
	INNER JOIN [dbo].[Cliente_PuntoDeVenta] CPDV ON (CPDV.[IdPuntoDeVenta] = PDV.[IdPuntoDeVenta] AND CPDV.IdCliente = @IdCliente)
	WHERE dbo.PuntoDeVenta_Cliente_Usuario_GetActivo(@IdCliente, PDV.[IdPuntoDeVenta],@IdUsuario) =1)          
   
    --Informacion General
   --3 Por Cliente
	 INSERT INTO #Info([IdInformacion],[IdPuntoDeVenta],[IdUsuario],[IdCadena],[IdCliente],[Titulo],[Mensaje],[FechaAlta],[FechaModificacion],[Activo],[FechaRelacion])
	(SELECT I.[IdInformacion],0 ,NULL,NULL,0,I.[Titulo],I.[Mensaje],I.[FechaAlta],I.[FechaModificacion],I.[Activo],IA.FechaAlta
	 FROM [dbo].[I_Informacion] I
	 INNER JOIN [dbo].[I_InformacionAsignacion] IA ON (IA.IdInformacionTipo =1 AND IA.IdInformacion = I.[IdInformacion] AND IA.IdAsignacion1 =@IdCliente))



FETCH NEXT FROM cliente_cursor
INTO  @IdCliente
END

CLOSE cliente_cursor;
DEALLOCATE cliente_cursor;

--Informacion General
--4 Por Usuario	   
INSERT INTO #Info([IdInformacion],[IdPuntoDeVenta],[IdUsuario],[IdCadena],[IdCliente],[Titulo],[Mensaje],[FechaAlta],[FechaModificacion],[Activo],[FechaRelacion])
(SELECT I.[IdInformacion],0 ,NULL,NULL,0,I.[Titulo],I.[Mensaje],I.[FechaAlta],I.[FechaModificacion],I.[Activo],IA.FechaAlta
FROM [dbo].[I_Informacion] I
INNER JOIN [dbo].[I_InformacionAsignacion] IA ON (IA.IdInformacionTipo =3 AND IA.IdInformacion = I.[IdInformacion] AND IA.IdAsignacion1 =@IdUsuario))


--5 A Todos
INSERT INTO #Info([IdInformacion],[IdPuntoDeVenta],[IdUsuario],[IdCadena],[IdCliente],[Titulo],[Mensaje],[FechaAlta],[FechaModificacion],[Activo],[FechaRelacion])
(SELECT I.[IdInformacion],0 ,NULL,NULL,0,I.[Titulo],I.[Mensaje],I.[FechaAlta],I.[FechaModificacion],I.[Activo],IA.FechaAlta
FROM [dbo].[I_Informacion] I
INNER JOIN [dbo].[I_InformacionAsignacion] IA ON (IA.IdInformacionTipo =5 AND IA.IdInformacion = I.[IdInformacion]))



-- Devuelvo la lista de Informacion por un lado.
-- Maestros de Mensajes. 
SELECT [IdInformacion], [Titulo], [Mensaje],[FechaAlta]
FROM #Info
WHERE [Activo]=1 AND ([FechaAlta] > @FechaDesde OR [FechaRelacion] > @FechaDesde)
GROUP BY [IdInformacion], [Titulo], [Mensaje],[FechaAlta]
ORDER BY [FechaAlta] DESC

-- Devuelvo la relacion de la Informacion y las distintas alternativas.         
-- Relacion de los Mensajes.
SELECT [IdInformacion], [IdPuntoDeVenta], [IdCliente]
FROM #Info
WHERE [Activo]=1 AND [FechaRelacion] > @FechaDesde
GROUP BY [IdInformacion], [IdPuntoDeVenta], [IdCliente]

END
GO
