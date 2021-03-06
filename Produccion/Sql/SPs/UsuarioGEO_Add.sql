SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UsuarioGEO_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UsuarioGEO_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[UsuarioGEO_Add]
	-- Add the parameters for the stored procedure here
    @IdUsuario int
   ,@Fecha datetime
   ,@Latitud decimal(11,8) = NULL
   ,@Longitud decimal(11,8) = NULL
   ,@EsFirebase int = 0
   
AS
BEGIN
	SET NOCOUNT ON;

	declare @idPuntoDeVenta int
	declare @idCliente int
	declare @idAlerta int
	DECLARE @FechaDif	DATETIME

	INSERT INTO [dbo].[UsuarioGEO]
           ([IdUsuario]
           ,[Fecha]
           ,[Latitud]
           ,[Longitud]
		   ,[FechaRecepcion]
		   ,[esFireBase])
     VALUES
           (@IdUsuario
           ,@Fecha
           ,@Latitud
           ,@Longitud
		   ,Getdate()
		   ,@EsFirebase)


	DECLARE alerta_cursor CURSOR FOR  
	select pcu.idCliente,
	       pcu.idPuntodeventa ,
		   a.id
	From puntodeventa_cliente_usuario pcu
	inner join alertas a on a.idCliente = pcu.idCliente
	INNER JOIN Cliente c ON pcu.idCliente = c.idCliente
	where pcu.activo = 1
	and pcu.idUsuario = @idUsuario  --PARAMETRO
	and fecha = (select max(mpcu.fecha) from puntodeventa_cliente_usuario mpcu
					where mpcu.idUsuario = pcu.idUsuario	
					and mpcu.activo = 1
					and mpcu.idCliente = a.idCliente )
--	and exists (select 1 from alertas where idCliente = pcu.idCliente)
	and a.TipoReporteSeleccionado = 'alertadistancia'
	and a.eliminado = 0

	OPEN alerta_cursor  
	
	FETCH NEXT FROM alerta_cursor   
	INTO @idCliente,@idPuntodeventa,@idAlerta

	WHILE @@FETCH_STATUS = 0  
	BEGIN  

		if not exists(
		select  1
		from alertas a
		cross apply [dbo].fnSplitString(a.puntosdeventa, ',') s
		where a.id = @idAlerta
		and s.clave = @idPuntodeventa)
		BEGIN
			insert logABM_Reporting(mensaje,fecha)
			values('NO EXISTE PDV EN ALERTA. ALERTA/USUARIO/PDV' + isnull(str(@idAlerta),'-') +'/'+isnull(str(@idUsuario),'-')+'/'+isnull(str(@idPuntodeventa),'-'), getdate())

			FETCH NEXT FROM alerta_cursor   
			INTO @idCliente,@idPuntodeventa,@idAlerta

			CONTINUE
		END
		if (isnull(@idAlerta,-1) !=-1)
		BEGiN
			BEGIN TRY

			SELECT @FechaDif = DATEADD(HH,(SELECT ISNULL(DiferenciaHora,0) FROM Cliente WHERE idCliente = @idCliente), GETDATE())

			exec [AlertaProximidad_add]
				 @IdUsuario = @idUSuario
				,@Fecha = @FechaDif
				,@Latitud = @latitud
				,@Longitud = @longitud
				,@idAlerta = @idAlerta
				,@idPuntoDeVenta = @idPuntoDeVenta
			END TRY
			BEGIN CATCH
			--PERDON
				insert logABM_Reporting(mensaje,fecha)
				values(ERROR_MESSAGE() + ' _ERROR AL GENERAR ALERTA. ALERTA/USUARIO' + str(isnull(@idAlerta,0)) +'/'+str(isnull(@idUsuario,-1))+' ' ,getdate())
			END CATCH
		END
	
		FETCH NEXT FROM alerta_cursor   
		INTO @idCliente,@idPuntodeventa,@idAlerta

	END

	close alerta_cursor
	deallocate alerta_cursor
END
GO