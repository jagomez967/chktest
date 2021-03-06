SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VM_Reporte_Relevados]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VM_Reporte_Relevados] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[VM_Reporte_Relevados]
	-- Add the parameters for the stored procedure here
	  @IdVisitadorMedico int
     ,@IdCliente int
     ,@Mes int
     ,@Ano int 
     ,@Categoria int = NULL
     
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here


CREATE TABLE #Table1 (IdVisitadorMedico int
                     ,IdMedico int
                     ,MedicoNombre varchar(200)
                     ,MedicoDomicilio varchar(200)
                     ,MedicoCategoria varchar(200)
                     ,MedicoZona varchar(200)                     
                     ,FechaVisita DateTime
                     ,CantidadVisitas int)
INSERT INTO #Table1     
SELECT VMM.[IdVisitadorMedico]
      ,VMM.[IdMedico]
      ,M.Nombre AS MedicoNombre
      ,M.Domicilio AS MedicoDomicilio
	  ,M.Categoria AS MedicoCategoria
      ,VMZ.Nombre AS MedicoZona
      ,dbo.VM_MedicoRelevado(@IdVisitadorMedico,@IdCliente,VMM.[IdMedico],@Mes,@Ano) AS FechaVisita
      ,dbo.VM_MedicoRelevadoCantidad(@IdVisitadorMedico,@IdCliente,VMM.[IdMedico],@Mes,@Ano) AS CantidadVisitas
  FROM [dbo].[VM_VisitadorMedicoMedico] VMM
  INNER JOIN VM_Medico M ON (M.[IdMedico] = VMM.[IdMedico] AND M.IdCliente=@IdCliente AND (@Categoria IS NULL OR @Categoria = M.Categoria))   
  LEFT JOIN VM_Zona VMZ ON (VMZ.IdZona = M.IdZona AND VMZ.IdCliente = @IdCliente)
  WHERE (@IdVisitadorMedico = VMM.[IdVisitadorMedico] )
		
    
  SELECT count(1) as Cantidad
  FROM #Table1   
  
  SELECT count(1) as Cantidad
  FROM #Table1
  WHERE FechaVisita IS NULL
    
  SELECT count(1) as Cantidad
  FROM #Table1
  WHERE NOT FechaVisita  IS NULL
  
  SELECT IdVisitadorMedico
        ,IdMedico
        ,MedicoNombre
        ,MedicoDomicilio
        ,MedicoCategoria
        ,MedicoZona        
        ,CONVERT(nvarchar(30), FechaVisita,103) +  ' ' + CONVERT(nvarchar(30), FechaVisita,108) AS FechaVisita     
        ,CantidadVisitas
         ,CASE 
			WHEN FechaVisita IS NULL THEN 'Pendiente'
		ELSE 'Relevado' 
		END Estado
  FROM #Table1  
      
      
  SELECT VMR.[IdReporteVisitador]
        ,M.IdMedico
		,M.Nombre AS MedicoNombre
        ,CONVERT(nvarchar(30), VMR.Fecha,103) +  ' ' + CONVERT(nvarchar(30), VMR.Fecha,108) AS FechaVisita
        ,CONVERT(nvarchar(30), VMR.[FechaAlta],103) +  ' ' + CONVERT(nvarchar(30), VMR.[FechaAlta],108) AS FechaAlta                 
  FROM [dbo].[VM_ReporteVisitador] VMR  
  INNER JOIN VM_Medico M ON (M.IdMedico = VMR.IdMedico)  
  WHERE VMR.IdVisitadorMedico = @IdVisitadorMedico AND
		VMR.[IdCliente] = @IdCliente AND  
		DATEPART (month, VMR.Fecha) = @Mes AND 
		DATEPART (year,  VMR.Fecha) = @Ano    
 ORDER BY VMR.Fecha
     
END
GO
