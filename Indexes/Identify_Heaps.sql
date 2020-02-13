SELECT o.name,i.type_desc,o.type
FROM sys.indexes i
INNER JOIN sys.objects o
    ON i.object_id = o.object_id
WHERE i.type_desc = 'HEAP'