SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tags_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[tags_Delete] AS' 
END
GO
ALTER procedure [dbo].[tags_Delete]
(
	@IdTag int = null
)
as
begin
	
	DELETE FROM dbo.tags
	WHERE idTag = @IdTag
end
GO
