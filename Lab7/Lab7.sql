DECLARE @Xml XML;
SET @Xml = (
    SELECT Person.BusinessEntityID AS "@ID", Person.FirstName AS "@FirstName", Person.LastName AS "@LastName"
    FROM AdventureWorks2012.Person.Person
    FOR XML PATH ('Person'), ROOT ('Persons'))

select @Xml

IF OBJECT_ID('tempdb..#resultTable') IS NOT NULL
    DROP TABLE #resultTable;

CREATE TABLE #resultTable
(
    BusinessEntityID int not null,
    FirstName        nvarchar(20),
    LastName         nvarchar(20)
)


INSERT #resultTable
SELECT x.value('@ID', 'int')           AS BusinessEntityID,
       x.value('@FirstName', 'nvarchar(20)')     AS FirstName,
       x.value('@LastName', 'nvarchar(20)') AS LastName
FROM @Xml.nodes('/Persons/Person') XmlData(x)

SELECT *
FROM #resultTable;