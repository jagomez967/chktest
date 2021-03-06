SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Medico_Sistema_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Medico_Sistema_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Medico_Sistema_Update]

	@IdMedico_Sistemar int
   ,@IdMedico int
   ,@IdSistema int
   ,@IdVisitador1 int = NULL
   ,@IdVisitador2 int = NULL
   ,@Activo bit = NULL
   ,@FechaDesde datetime = NULL
   
AS
BEGIN
	SET NOCOUNT ON;

 UPDATE [dbo].[CD_Medico_Sistema]
   SET [IdMedico] = @IdMedico
      ,[IdSistema] = @IdSistema
      ,[IdVisitador1] = @IdVisitador1
      ,[IdVisitador2] = @IdVisitador2
      ,[Activo] = @Activo
      ,[FechaDesde] = @FechaDesde
 WHERE @IdMedico_Sistemar = [IdMedico_Sistemar]

END
GO
