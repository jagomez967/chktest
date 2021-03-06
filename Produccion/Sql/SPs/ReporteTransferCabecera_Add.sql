SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteTransferCabecera_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteTransferCabecera_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ReporteTransferCabecera_Add]
	-- Add the parameters for the stored procedure here
        @IdEmpresa int
       ,@IdPuntoDeVenta int
       ,@IdUsuario int
       ,@FechaCreacion datetime
       ,@IdReporteTransferCabecera int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[ReporteTransferCabecera]
           ([IdEmpresa]
           ,[IdPuntoDeVenta]
           ,[IdUsuario]
           ,[FechaCreacion])
     VALUES
           (@IdEmpresa
           ,@IdPuntoDeVenta
           ,@IdUsuario
           ,@FechaCreacion)
           
       Set @IdReporteTransferCabecera = @@identity

END
GO
