SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Producto_Campania_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Producto_Campania_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Producto_Campania_Add]
	-- Add the parameters for the stored procedure here
    @IdProducto int
   ,@IdCampania int
   ,@Orden int = NULL
   ,@Activo bit
   
AS
BEGIN
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[CD_Producto_Campania]
           ([IdProducto]
           ,[IdCampania]
           ,[Orden]
           ,[Activo])
     VALUES
           (@IdProducto
           ,@IdCampania
           ,@Orden
           ,@Activo)

END
GO
