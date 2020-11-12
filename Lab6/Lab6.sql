IF OBJECT_ID (N'[Production].[AveragePriceInCategory]') IS NOT NULL
    DROP PROCEDURE  [Production].[AveragePriceInCategory];
GO


CREATE PROCEDURE [Production].[AveragePriceInCategory](@ProductClassName NVARCHAR(300)) AS
	DECLARE @SQLQuery NVARCHAR(900);
BEGIN
	SET @SQLQuery = '
        SELECT [Name], ' + @ProductClassName + '
        FROM (
            SELECT [ListPrice], [Class], [SC].[Name] FROM [Production].[Product] [PP]
            JOIN [Production].[ProductSubcategory] [SC]
            ON [PP].[ProductSubcategoryID] = [SC].[ProductSubcategoryID]
        ) AS [pol]
        PIVOT (AVG([ListPrice]) FOR [pol].[Class] IN(' + @ProductClassName + ')) AS [pvt]';

    Execute sp_executesql @SQLQuery
END;


EXECUTE Production.AveragePriceInCategory '[H],[L],[M]';
