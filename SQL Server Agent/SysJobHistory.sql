USE msdb;
GO


SELECT sj.name
	,sjh.step_name
	,sjh.message
	,sjh.run_date,STUFF(STUFF(RIGHT(REPLICATE('0', 6) +  CAST(sjh.run_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':') 'run_time'
	,STUFF(STUFF(STUFF(RIGHT(REPLICATE('0', 8) + CAST(sjh.run_duration as varchar(8)), 8), 3, 0, ':'), 6, 0, ':'), 9, 0, ':') 'run_duration (DD:HH:MM:SS)'
FROM sysjobhistory  sjh
JOIN sysjobs sj ON sj.job_id = sjh.job_id
WHERE sjh.job_id IN (SELECT job_id FROM sysjobs WHERE NAME LIKE '%JOBNAME%') AND step_id = 0
ORDER BY sjh.job_id asc, run_date asc, run_time asc