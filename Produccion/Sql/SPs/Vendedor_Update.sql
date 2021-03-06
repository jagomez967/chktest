SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Vendedor_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Vendedor_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Vendedor_Update]
	-- Add the parameters for the stored procedure here
    @IdVendedor int
   ,@IdEquipo int
   ,@Nombre varchar(50)
   ,@Telefono varchar(50) = NULL
   ,@Email varchar(50) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[Vendedor]
    SET [IdEquipo] = @IdEquipo
       ,[Nombre] = @Nombre
       ,[Telefono] = @Telefono
       ,[Email] = @Email
      WHERE @IdVendedor = [IdVendedor]
      
      
END
GO
