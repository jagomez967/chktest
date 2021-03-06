SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteTransferNumero_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteTransferNumero_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ReporteTransferNumero_Add]
	-- Add the parameters for the stored procedure here
      @IdReporte int
     ,@IdDrogueria int
     ,@Numero varchar(50)
     ,@VentaTelefonica bit = NULL
     
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[ReporteTransferNumero]
           ([IdReporte]
           ,[IdDrogueria]
           ,[Numero]
           ,[VentaTelefonica])
     VALUES
           (@IdReporte
           ,@IdDrogueria
           ,@Numero
           ,@VentaTelefonica)
           
           
END
GO
