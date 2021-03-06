SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_InformacionAsignacion_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_InformacionAsignacion_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[I_InformacionAsignacion_Add]

    @IdInformacion int
   ,@IdInformacionTipo int
   ,@IdAsignacion1 int = NULL
   ,@IdAsignacion2 int = NULL
   ,@IdAsignacion3 int = NULL
   ,@IdAsignacion4 int = NULL
   
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[I_InformacionAsignacion]
           ([IdInformacion]
           ,[IdInformacionTipo]
           ,[IdAsignacion1]
           ,[IdAsignacion2]
           ,[IdAsignacion3]
           ,[IdAsignacion4]
           ,[FechaAlta])
     VALUES
           (@IdInformacion
           ,@IdInformacionTipo
           ,@IdAsignacion1
           ,@IdAsignacion2
           ,@IdAsignacion3
           ,@IdAsignacion4
           ,GETDATE())
           
END
GO
