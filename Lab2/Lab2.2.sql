USE master;

CREATE TABLE [dbo].[Address]
(
    AddressID        INT          NOT NULL,
    AddressLine1     nvarchar(60) not null,
    AddressLine2     nvarchar(60),
    City             nvarchar(30) not null,
    StateProvinceID int          not null,
    PostalCode       nvarchar(15) not null,
    ModifiedDate     datetime not null
)
GO

ALTER TABLE [dbo].[Address]
ADD CONSTRAINT PK_Address Primary Key (PostalCode, StateProvinceID);
GO

ALTER TABLE [dbo].[Address]
ADD CONSTRAINT CHK_Address_PostalCode_Is_Digit CHECK (LOWER(PostalCode) not like '%[a-z]%');
GO

ALTER TABLE [dbo].[Address]
ADD CONSTRAINT DF_Address_ModifiedDate DEFAULT GETDATE() FOR ModifiedDate;
GO

INSERT INTO dbo.Address
(AddressID,
 AddressLine1,
 AddressLine2,
 City,
 StateProvinceID,
 PostalCode,
 ModifiedDate)
SELECT T.AddressID,
       T.AddressLine1,
       T.AddressLine2,
       T.City,
       T.StateProvinceID,
       T.PostalCode,
       T.ModifiedDate
FROM (
         SELECT AddressID,
                MAX(AddressID) OVER ( PARTITION BY PostalCode, Address.StateProvinceID) as MaxAddressId,
                Address.AddressLine1,
                Address.AddressLine2,
                Address.City,
                Address.StateProvinceID,
                PostalCode,
                Address.ModifiedDate
         FROM AdventureWorks2012.Person.Address) T
         JOIN AdventureWorks2012.Person.StateProvince as A on T.StateProvinceID = A.StateProvinceID
    AND A.CountryRegionCode = 'US' AND (LOWER(T.PostalCode) not like '%[a-z]%') AND MaxAddressId = AddressID;
GO

ALTER TABLE Address
    ALTER COLUMN City NVARCHAR(20) NOT NULL;
GO
