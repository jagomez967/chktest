SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Medico_Sistema_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Medico_Sistema_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Medico_Sistema_Add]
	
    @IdMedico int
   ,@IdSistema int
   ,@IdVisitador1 int = NULL
   ,@IdVisitador2 int = NULL
   ,@Activo bit = NULL
   ,@FechaDesde datetime = NULL
   
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[CD_Medico_Sistema]
           ([IdMedico]
           ,[IdSistema]
           ,[IdVisitador1]
           ,[IdVisitador2]
           ,[Activo]
           ,[FechaDesde])
     VALUES
           (@IdMedico
           ,@IdSistema
           ,@IdVisitador1
           ,@IdVisitador2
           ,@Activo
           ,@FechaDesde)

END
GO
