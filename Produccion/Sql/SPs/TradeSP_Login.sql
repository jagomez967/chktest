SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TradeSP_Login]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[TradeSP_Login] AS' 
END
GO
-- Create procedures section -------------------------------------------------

ALTER PROCEDURE [dbo].[TradeSP_Login]
(@Login  varchar(20), @Password varchar(20))

AS
DECLARE @userid INT
SELECT @userid =  IdUsuario FROM Usuario WHERE Usuario= @Login AND Clave= @Password
IF (@userid>0)
  BEGIN
        SELECT IdUsuario as ID, Usuario as login,Usuario as  firstname, 'Bienvenido ' + Usuario AS welcome FROM Usuario  WHERE  IdUsuario= @userid
  END
GO
