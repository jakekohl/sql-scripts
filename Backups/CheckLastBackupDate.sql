use master;
GO

SELECT
	d.[name] AS DatabaseName ,
			'Last backed up: '
			+ COALESCE(CAST(MAX(b.backup_finish_date) AS VARCHAR(25)),'never') AS Details
	FROM master.sys.databases d
		LEFT OUTER JOIN msdb.dbo.backupset b ON d.name COLLATE SQL_Latin1_General_CP1_CI_AS = b.database_name COLLATE SQL_Latin1_General_CP1_CI_AS
		AND b.type = 'D'
		AND b.server_name = SERVERPROPERTY('ServerName') /*Backupset ran on current server  */
	WHERE d.database_id <> 2  /* Bonus points if you know what that means */
		AND d.state NOT IN(1, 6, 10) /* Not currently offline or restoring, like log shipping databases */
		AND d.is_in_standby = 0 /* Not a log shipping target database */
		AND d.source_database_id IS NULL /* Excludes database snapshots */
	GROUP BY d.name

	/*	
	HAVING  MAX(b.backup_finish_date) <= DATEADD(dd,
										-7, GETDATE())
			OR MAX(b.backup_finish_date) IS NULL;
	*/
	
/* To check for if backups were done recently, uncomment out the below section and update the DATEADD for the appropriate amount of days */
