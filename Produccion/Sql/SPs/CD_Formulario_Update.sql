SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Formulario_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Formulario_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Formulario_Update]
	-- Add the parameters for the stored procedure here
    @IdFormulario int
   ,@IdCampania int = NULL
   ,@IdPuntoDeVenta int = NULL
   ,@IdMedico int = NULL
   ,@FechaReceta datetime = NULL
   ,@FechaTicket datetime = NULL   
   ,@FechaActualizacion datetime = NULL
   ,@IdUsuario int = NULL
   ,@NroTicket varchar(50)=NULL 
   ,@Activo bit = NULL
   ,@Vencido bit = NULL
   ,@SinTicket bit = NULL
   ,@SinRecetaOriginal bit = NULL
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
UPDATE [CD_Formulario]
   SET [IdCampania] = @IdCampania
      ,[IdPuntoDeVenta] = @IdPuntoDeVenta
      ,[IdMedico] = @IdMedico
      ,[FechaReceta] = @FechaReceta
      ,[FechaTicket] = @FechaTicket
      ,[FechaActualizacion] = @FechaActualizacion
      --,[IdUsuario] = @IdUsuario
      ,[NroTicket] = @NroTicket
      ,[Activo] = @Activo
      ,[Vencido] = @Vencido
      ,[SinTicket] = @SinTicket
      ,[SinRecetaOriginal] = @SinRecetaOriginal
 WHERE [IdFormulario] = @IdFormulario

	
END
GO
