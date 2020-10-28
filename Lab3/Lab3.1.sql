USE master

ALTER TABLE Address
    Add [AddressType] nvarchar(50);
Go

DECLARE @Var TABLE
             (
                 AddressID       INT          NOT NULL,
                 AddressLine1    nvarchar(60) not null,
                 AddressLine2    nvarchar(60),
                 City            nvarchar(20) not null,
                 StateProvinceID int          not null,
                 PostalCode      nvarchar(15) not null,
                 ModifiedDate    datetime     not null,
                 AddressType     nvarchar(50)
             );

INSERT INTO @Var (AddressID, AddressLine1, AddressLine2, City, StateProvinceID, PostalCode, ModifiedDate, AddressType)
SELECT Address.AddressID,
       Address.AddressLine1,
       Address.AddressLine2,
       Address.City,
       Address.StateProvinceID,
       Address.PostalCode,
       Address.ModifiedDate,
       (Select AddressType.Name
        FROM AdventureWorks2012.Person.AddressType
                 JOIN AdventureWorks2012.Person.BusinessEntityAddress as A
                      ON AddressType.AddressTypeID = A.AddressTypeID
        where Address.AddressID = A.AddressID)
FROM Address;

UPDATE Address
SET Address.AddressType = [Var].AddressType
FROM @Var as [Var]
WHERE Address.AddressID = [Var].AddressID;

UPDATE Address
SET Address.AddressLine2 = Address.AddressLine1
FROM Address
WHERE Address.AddressLine2 is null

SELECT * FROM @Var;

DELETE
FROM Address
WHERE AddressID not in (select max(AddressID) from Address GROUP BY Address.AddressType);
Go

SELECT * FROM Address

ALTER TABLE [dbo].[Address]
    DROP COLUMN [AddressType];
Go

ALTER TABLE [dbo].[Address]
    DROP CONSTRAINT [PK_Address];
Go

ALTER TABLE [dbo].[Address]
    DROP CONSTRAINT [CHK_Address_PostalCode_Is_Digit];
Go

ALTER TABLE [dbo].[Address]
    DROP CONSTRAINT [DF_Address_ModifiedDate];
Go

DROP TABLE Address;
Go
