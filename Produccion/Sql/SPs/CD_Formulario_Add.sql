SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Formulario_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Formulario_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Formulario_Add]
	-- Add the parameters for the stored procedure here
    @IdCampania int = NULL
   ,@IdPuntoDeVenta int = NULL
   ,@IdMedico int = NULL
   ,@FechaReceta datetime = NULL
   ,@FechaTicket datetime = NULL
   ,@FechaCarga datetime = NULL
   ,@FechaActualizacion datetime = NULL
   ,@IdUsuario int = NULL
   ,@NroTicket varchar(50)=NULL 
   ,@Activo bit = NULL
   ,@Vencido bit = NULL
   ,@SinTicket bit = NULL
   ,@SinRecetaOriginal bit = NULL
   ,@IdFormulario int OUTPUT
   
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[CD_Formulario]
           ([IdCampania]
           ,[IdPuntoDeVenta]
           ,[IdMedico]
           ,[FechaReceta]
           ,[FechaTicket]
           ,[FechaCarga]
           ,[FechaActualizacion]
           ,[IdUsuario]
           ,[NroTicket]
           ,[Activo] 
           ,[Vencido]
           ,[SinTicket]
           ,[SinRecetaOriginal])
     VALUES
           (@IdCampania
           ,@IdPuntoDeVenta
           ,@IdMedico
           ,@FechaReceta
           ,@FechaTicket
           ,@FechaCarga
           ,@FechaActualizacion
           ,@IdUsuario
           ,@NroTicket
           ,@Activo
           ,@Vencido
		   ,@SinTicket
		   ,@SinRecetaOriginal)

	SET @IdFormulario = @@identity
	
END
GO
