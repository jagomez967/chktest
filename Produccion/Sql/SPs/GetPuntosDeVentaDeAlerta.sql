SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPuntosDeVentaDeAlerta]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPuntosDeVentaDeAlerta] AS' 
END
GO
ALTER procedure [dbo].[GetPuntosDeVentaDeAlerta]
(
	@IdAlerta	int
)
as
begin
	--exec GetPuntosDeVentaDeAlerta 1
	select idpuntodeventa from alertaspuntosdeventas where idalerta=@idalerta

end
GO
