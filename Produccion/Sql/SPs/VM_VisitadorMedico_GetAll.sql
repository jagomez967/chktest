SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VM_VisitadorMedico_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VM_VisitadorMedico_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[VM_VisitadorMedico_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdVisitadorMedico int = NULL
	,@IdCliente int = NULL	
	,@IdUsuario int = NULL
	,@Apellido varchar(50) = NULL 
	,@Activo int = NULL
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT V.[IdVisitadorMedico]
		  ,V.[IdCliente]
		  ,V.[Apellido]
		  ,V.[Nombre]
		  ,V.[IdUsuario]
		  ,V.[Activo]
		  ,ISNULL(U.[Apellido],'') + ', ' + ISNULL(U.[Nombre],'') COLLATE DATABASE_DEFAULT  As NombreUsuario
    FROM [dbo].[VM_VisitadorMedico] V
    LEFT JOIN Usuario U ON (U.[IdUsuario] = V.[IdUsuario])
    WHERE (@IdVisitadorMedico IS NULL OR @IdVisitadorMedico = V.[IdVisitadorMedico]) AND    
		  (@IdCliente IS NULL OR @IdCliente = V.[IdCliente]) AND		 
		  (@IdUsuario IS NULL OR @IdUsuario = V.[IdUsuario]) AND
		  (@Apellido IS NULL OR V.[Apellido] like + '%' + @Apellido + '%') AND 
		  (@Activo IS NULL OR @Activo = V.[Activo])
	ORDER BY V.[Apellido], V.[Nombre]		  

END
GO
