SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Visitador_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Visitador_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Visitador_Update]
	  @IdVisitador int
	 ,@Nombre varchar(255) = NULL
     ,@IdSistema int = NULL
     ,@Activo bit = NULL
     
     
AS
BEGIN

	SET NOCOUNT ON;

    -- Insert statements for procedure here
 UPDATE [dbo].[CD_Visitador]
   SET [Nombre] = @Nombre
      ,[IdSistema] = @IdSistema
      ,[Activo] = @Activo
 WHERE @IdVisitador=[IdVisitador] 

END
GO
