SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VM_Zona_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VM_Zona_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[VM_Zona_Add]
	-- Add the parameters for the stored procedure here
	
    @IdCliente int
   ,@Nombre varchar(50) = NULL
   ,@Activo	bit = NULL
    
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    INSERT INTO [dbo].[VM_Zona]
           ([IdCliente]
           ,[Nombre]
           ,[Activo])
     VALUES
           (@IdCliente
           ,@Nombre
           ,@Activo)
           
  
END
GO
