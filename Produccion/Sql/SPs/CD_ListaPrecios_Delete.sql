SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_ListaPrecios_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_ListaPrecios_Delete] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_ListaPrecios_Delete]
	
    @Codigo varchar(50)
   ,@FechaDesde datetime
      
AS
BEGIN
	SET NOCOUNT ON;

	 DELETE FROM [dbo].[CD_ListaPrecios]
	 WHERE @Codigo = [Codigo] AND @FechaDesde = [FechaDesde]

END
GO
