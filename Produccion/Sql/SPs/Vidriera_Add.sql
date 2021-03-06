SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Vidriera_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Vidriera_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Vidriera_Add]
	-- Add the parameters for the stored procedure here
	 
	@IdPuntoDeVenta int
   ,@IdDimension int 
   ,@IdVisibilidad int = NULL
   ,@IdEspacio int = NULL
   ,@Nombre varchar(50)
   ,@Comentarios varchar(200) = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[Vidriera]
           ([IdPuntoDeVenta]
           ,[IdDimension]
           ,[IdVisibilidad]
           ,[IdEspacio]
           ,[Nombre]
           ,[Comentarios])
     VALUES
           (@IdPuntoDeVenta
           ,@IdDimension
           ,@IdVisibilidad
           ,@IdEspacio
           ,@Nombre
           ,@Comentarios)

END
GO
