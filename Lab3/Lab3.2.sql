ALTER TABLE Address
    Add [CountryRegionCode] nvarchar(3), [TaxRate] SMALLMONEY, [DiffMin] as [TaxRate] - 5.00;
GO

CREATE TABLE [dbo].[#Address]
(
    AddressID           INT          NOT NULL,
    AddressLine1        nvarchar(60) not null,
    AddressLine2        nvarchar(60),
    City                nvarchar(30) not null,
    StateProvinceID     int          not null,
    PostalCode          nvarchar(15) not null,
    ModifiedDate        datetime     not null,
    [CountryRegionCode] nvarchar(3),
    [TaxRate]           SMALLMONEY
        PRIMARY KEY CLUSTERED ([AddressID])
);
GO

WITH [ADR] AS (SELECT AddressID,
                      AddressLine1,
                      AddressLine2,
                      City,
                      Address.StateProvinceID,
                      PostalCode,
                      Address.ModifiedDate,
                      SP.CountryRegionCode,
                      STR.TaxRate
               FROM dbo.Address
                        JOIN AdventureWorks2012.Person.StateProvince as SP
                             ON Address.StateProvinceID = SP.StateProvinceID
                        JOIN AdventureWorks2012.Sales.SalesTaxRate as STR ON SP.StateProvinceID = STR.StateProvinceID
               WHERE STR.TaxRate > 5
)
INSERT
INTO dbo.#Address (AddressID, AddressLine1, AddressLine2, City, StateProvinceID, PostalCode, ModifiedDate,
                   CountryRegionCode, TaxRate)
SELECT AddressID,
       AddressLine1,
       AddressLine2,
       City,
       StateProvinceID,
       PostalCode,
       ModifiedDate,
       CountryRegionCode,
       TaxRate
FROM [ADR];
GO

SELECT *
FROM #Address;
GO


DELETE TOP (1)
FROM Address
WHERE StateProvinceID = 36;
GO

MERGE INTO dbo.Address AS base
USING dbo.#Address AS source
ON base.AddressID = source.AddressID
WHEN MATCHED THEN
    UPDATE
    SET CountryRegionCode = source.CountryRegionCode,
        TaxRate           = source.TaxRate
WHEN NOT MATCHED BY TARGET THEN
    INSERT (AddressID,
            AddressLine1,
            AddressLine2,
            City,
            StateProvinceID,
            PostalCode,
            ModifiedDate,
            CountryRegionCode,
            TaxRate)
    VALUES (source.AddressID,
            source.AddressLine1,
            source.AddressLine2,
            source.City,
            source.StateProvinceID,
            source.PostalCode,
            source.ModifiedDate,
            source.CountryRegionCode,
            source.TaxRate)
WHEN NOT MATCHED BY SOURCE THEN DELETE;
GO
