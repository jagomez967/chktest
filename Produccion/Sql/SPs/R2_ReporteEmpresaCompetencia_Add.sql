SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_ReporteEmpresaCompetencia_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_ReporteEmpresaCompetencia_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_ReporteEmpresaCompetencia_Add]
	-- Add the parameters for the stored procedure here
    @IdReporte2 int
   ,@IdEmpresa int
   ,@Comentarios varchar(MAX) =  NULL
   
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [R2_ReporteEmpresaCompetencia]
           ([IdReporte2]
           ,[IdEmpresa]
           ,[Comentarios])
     VALUES
           (@IdReporte2
           ,@IdEmpresa
           ,@Comentarios)

END
GO
