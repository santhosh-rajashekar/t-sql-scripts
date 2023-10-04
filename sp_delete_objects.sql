CREATE PROCEDURE sp_delete_objects @tp CHARACTER , @sch_name VARCHAR(128), @sch_id INTEGER
AS
BEGIN
 DECLARE @name VARCHAR(128)
 DECLARE @SQLP VARCHAR(254)
 CREATE TABLE #D ( otype VARCHAR(1), nm VARCHAR(128));
 INSERT INTO #D VALUES ('P','Procedure');
 INSERT INTO #D VALUES ('V','View');
 INSERT INTO #D VALUES ('U','Table');

 SELECT @name = (SELECT TOP 1 [name] FROM sys.objects WHERE [schema_id] = @sch_id AND [type] = @tp AND [is_ms_shipped] = 0 ORDER BY [name]);

 WHILE @name is not null
 BEGIN
  SELECT @SQLP = 'DROP ' + ( SELECT nm from #D where [otype] = @tp ) +' ['+@sch_name+'].[' + RTRIM(@name) +']'
  EXECUTE (@SQLP)
  SELECT 'Dropped '+ ( SELECT nm from #D where [otype] = @tp ) + ': ' + @name
  SELECT @name = (SELECT TOP 1 [name] FROM sys.objects WHERE [schema_id] = @sch_id AND [type] = @tp AND [is_ms_shipped] = 0 AND [name] > @name
   ORDER BY [name])
 END;
 DROP TABLE #D
END;
GO