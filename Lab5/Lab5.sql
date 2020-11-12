IF OBJECT_ID (N'[Purchasing].GetSumOfOrders') IS NOT NULL
    DROP FUNCTION [Purchasing].GetSumOfOrders
GO

CREATE FUNCTION [Purchasing].GetSumOfOrders(@PurchaseOrderID INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @result MONEY
	SELECT @result = SUM([AdventureWorks2012].[Purchasing].[PurchaseOrderDetail].[LineTotal])
	FROM [AdventureWorks2012].[Purchasing].[PurchaseOrderDetail]
	WHERE [PurchaseOrderDetail].[PurchaseOrderID] = @PurchaseOrderID
	RETURN @result
END;
GO

PRINT [Purchasing].GetSumOfOrders(1);

IF OBJECT_ID (N'[Sales].GetBestOrdersByCustomerID') IS NOT NULL
    DROP FUNCTION [Sales].GetBestOrdersByCustomerID
GO

CREATE FUNCTION [Sales].GetBestOrdersByCustomerID(@CustomerID INT, @CountOfRow INT)
RETURNS TABLE AS RETURN (
	SELECT TOP(@CountOfRow)
		[SalesOrderID],
		[RevisionNumber],
		[OrderDate],
		[DueDate],
		[ShipDate],
		[Status],
		[OnlineOrderFlag],
		[SalesOrderNumber],
		[PurchaseOrderNumber],
		[AccountNumber],
		[CustomerID],
		[SalesPersonID],
		[TerritoryID],
		[BillToAddressID],
		[ShipToAddressID],
		[ShipMethodID],
		[CreditCardID],
		[CreditCardApprovalCode],
		[CurrencyRateID],
		[SubTotal],
		[TaxAmt],
		[Freight],
		[TotalDue],
		[Comment],
		[rowguid],
		[ModifiedDate]
	FROM [AdventureWorks2012].[Sales].[SalesOrderHeader]
	WHERE [CustomerID] = @CustomerID and SubTotal is not null
	ORDER BY [TotalDue] DESC
);
GO

SELECT * FROM [AdventureWorks2012].[Sales].[Customer] CROSS APPLY [AdventureWorks2012].[Sales].[GetBestOrdersByCustomerID]([CustomerID], 3);
SELECT * FROM [AdventureWorks2012].[Sales].[Customer] OUTER APPLY [AdventureWorks2012].[Sales].[GetBestOrdersByCustomerID]([CustomerID], 3);


IF OBJECT_ID (N'[Sales].GetBestOrdersByCustomerID') IS NOT NULL
    DROP FUNCTION [Sales].GetBestOrdersByCustomerID
GO

CREATE FUNCTION [Sales].GetBestOrdersByCustomerID(@CustomerID INT, @CountOfRow INT)
RETURNS @result TABLE(
	[SalesOrderID] INT NOT NULL,
	[RevisionNumber] TINYINT NOT NULL,
	[OrderDate] DATETIME NOT NULL,
	[DueDate] DATETIME NOT NULL,
	[ShipDate] DATETIME NULL,
	[Status] TINYINT NOT NULL,
	[OnlineOrderFlag] dbo.Flag NOT NULL,
	[SalesOrderNumber] NVARCHAR(23),
	[PurchaseOrderNumber] dbo.OrderNumber NULL,
	[AccountNumber] dbo.AccountNumber NULL,
	[CustomerID] INT NOT NULL,
	[SalesPersonID] INT NULL,
	[TerritoryID] INT NULL,
	[BillToAddressID] INT NOT NULL,
	[ShipToAddressID] INT NOT NULL,
	[ShipMethodID] INT NOT NULL,
	[CreditCardID] INT NULL,
	[CreditCardApprovalCode] VARCHAR(15) NULL,
	[CurrencyRateID] INT NULL,
	[SubTotal] MONEY NOT NULL ,
	[TaxAmt] MONEY NOT NULL,
	[Freight] MONEY NOT NULL,
	[TotalDue] INT NOT NULL,
	[Comment] NVARCHAR(128) NULL,
	[rowguid] UNIQUEIDENTIFIER ROWGUIDCOL  NOT NULL,
	[ModifiedDate] DATETIME NOT NULL
) AS BEGIN
	INSERT INTO @result
	SELECT TOP(@CountOfRow)
		[SalesOrderID],
		[RevisionNumber],
		[OrderDate],
		[DueDate],
		[ShipDate],
		[Status],
		[OnlineOrderFlag],
		[SalesOrderNumber],
		[PurchaseOrderNumber],
		[AccountNumber],
		[CustomerID],
		[SalesPersonID],
		[TerritoryID],
		[BillToAddressID],
		[ShipToAddressID],
		[ShipMethodID],
		[CreditCardID],
		[CreditCardApprovalCode],
		[CurrencyRateID],
		[SubTotal],
		[TaxAmt],
		[Freight],
		[TotalDue],
		[Comment],
		[rowguid],
		[ModifiedDate]
	FROM [AdventureWorks2012].[Sales].[SalesOrderHeader]
	WHERE [CustomerID] = @CustomerID
	ORDER BY [TotalDue] DESC
	RETURN
END;