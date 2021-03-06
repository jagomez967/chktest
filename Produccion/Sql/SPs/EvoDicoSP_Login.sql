SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EvoDicoSP_Login]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EvoDicoSP_Login] AS' 
END
GO
ALTER PROCEDURE [dbo].[EvoDicoSP_Login]  (@Login  nvarchar(50),	@Password nvarchar(50))
AS

DECLARE @userid INT
SELECT @userid =  ID FROM [EVOL_User] WHERE login= @Login AND password= @Password and admin=1
IF (@userid>0)
  BEGIN
    	UPDATE [EVOL_User] SET lastvisit=getdate(), nbvisits=nbvisits+1  WHERE  ID= @userid
    	SELECT ID, login, firstname, 'Welcome ' + firstname AS welcome FROM [Evol_User]  WHERE  ID= @userid 
  END
GO
