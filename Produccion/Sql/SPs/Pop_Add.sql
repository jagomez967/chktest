SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pop_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Pop_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Pop_Add]
	-- Add the parameters for the stored procedure here
    @Nombre varchar(100)
   ,@Descripcion varchar(200) = NULL
   ,@IdCliente INT
   ,@Activo	BIT = 1
   ,@CodigoSap VARCHAR(50) = NULL
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[Pop]
           ([Nombre]
           ,[Descripcion]
           ,[IdCliente]
		   ,[Activo]
		   ,[CodigoSap])
     VALUES
           (@Nombre
           ,@Descripcion
           ,@IdCliente
		   ,@Activo
		   ,@CodigoSap)
           
     --SELECT @IdPop = @@IDENTITY

END
GO
