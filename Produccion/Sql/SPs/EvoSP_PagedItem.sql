SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EvoSP_PagedItem]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EvoSP_PagedItem] AS' 
END
GO
/* **  (c) 2010 Olivier Giulieri - www.evolutility.org   ** */
/*    SQL script for generic pagin with Evolutility     */ 
/*
	This file is part of Evolutility CRUD Framework.
	Source link <http://www.evolutility.org/download/download.aspx>

	Evolutility is free software: you can redistribute it and/or modify
	it under the terms of the GNU Affero General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	Evolutility is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU Affero General Public License
	along with Evolutility. If not, see <http://www.fsf.org/licensing/licenses/agpl-3.0.html>.
*/

ALTER PROCEDURE [dbo].[EvoSP_PagedItem]
	(
	@Select  varchar(1000),
	@Table varchar(200),
	@TableS varchar(800),
	@WhereClause  varchar(2000),
	@OrderBy  varchar(200),
	@pk varchar(50), 
	@Page int,
	@RecsPerPage int	
	)
AS

SET NOCOUNT ON
CREATE TABLE #TempItems ( IDt int IDENTITY, IDo int)
IF (@WhereClause='')
  	INSERT INTO #TempItems (IDo) EXEC('SELECT T.'+@pk+' FROM '+@TableS+'  ORDER BY ' +@OrderBy)
ELSE
	EXEC( 'INSERT INTO #TempItems (IDo) SELECT T.'+@pk+' FROM '+@TableS+'  WHERE ' + @WhereClause+ ' ORDER BY '+@OrderBy)
DECLARE @FirstRec int, @LastRec int
SELECT @FirstRec = (@Page - 1) * @RecsPerPage
SELECT @LastRec = (@Page * @RecsPerPage + 1)
IF (@WhereClause='')
	EXEC( 'SELECT '+@Select + ', MoreRecords = ( SELECT COUNT(*)  FROM #TempItems Temp  WHERE Temp.IDt >= ' 
+ @LastRec + ')  FROM #TempItems Temp,  ' + @TableS  
	+ ' WHERE T.'+@pk+' = Temp.IDo AND Temp.IDt > '+ @FirstRec + ' AND Temp.IDt < '+ @LastRec + '  ORDER BY '+  @OrderBy)
ELSE
	EXEC( 'SELECT '+@Select + ', MoreRecords = ( SELECT COUNT(*)  FROM #TempItems Temp  WHERE Temp.IDt >= ' 
+ @LastRec + ')  FROM #TempItems Temp,  ' + @TableS  
	+ ' WHERE T.'+@pk+' = Temp.IDo AND Temp.IDt > '+ @FirstRec + ' AND Temp.IDt < '+ @LastRec + ' AND ' + @WhereClause+ ' ORDER BY '+  @OrderBy)
SET NOCOUNT OFF
GO
