SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[imagenesTags_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[imagenesTags_Delete] AS' 
END
GO
ALTER procedure [dbo].[imagenesTags_Delete]
(
	@IdImagen int,
	@IdTag int,
	@IdUsuario int
)
as
begin	
	delete from imagenesTags where idtag=@IdTag and idimagen=@idimagen
end
GO
