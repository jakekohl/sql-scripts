SELECT
OBJECT_NAME(i.OBJECT_ID) AS TableName,
i.name AS IndexName,
i.index_id AS IndexID,
8 * SUM(a.used_pages) AS 'Indexsize(KB)',
fill_factor,
'ALTER INDEX ['+i.name+'] ON [dbo].['+OBJECT_NAME(i.OBJECT_ID)+'] REBUILD PARTITION = ALL WITH (PAD_INDEX=OFF, STATISTICS_NORECOMPUTE=OFF, SORT_IN_TEMPDB=OFF, ONLINE=?, ALLOW_ROW_LOCKS=ON, ALLOW_PAGE_LOCKS=ON, FILLFACTOR=100);' AS 'ALTER INDEX Command'
FROM sys.indexes AS i
JOIN sys.partitions AS p ON p.OBJECT_ID = i.OBJECT_ID AND p.index_id = i.index_id
JOIN sys.allocation_units AS a ON a.container_id = p.partition_id
WHERE i.fill_factor > 0
    and i.fill_factor < 100
GROUP BY i.OBJECT_ID,i.index_id,i.name,fill_factor
ORDER BY 'Indexsize(KB)' desc;