CREATE SCHEMA Production;

Create table Production.WorkOrderHst
(
    [id]           int IDENTITY (1,1) primary key,
    [ACTION]       CHAR(6)     NOT NULL CHECK (Action IN ('INSERT', 'UPDATE', 'DELETE')),
    [ModifiedDate] DATETIME    NOT NULL,
    [SourceID]     INT         NOT NULL,
    [UserName]     VARCHAR(50) NOT NULL
);
GO

CREATE TRIGGER Production.MYTrigger
    ON AdventureWorks2012.Production.WorkOrder
    AFTER INSERT, UPDATE, DELETE AS
    INSERT INTO Production.WorkOrderHst ([ACTION], [ModifiedDate], [SourceID], [UserName])
    SELECT CASE
               WHEN inserted.ProductID IS NULL THEN 'DELETE'
               WHEN deleted.ProductID IS NULL THEN 'INSERT'
               ELSE 'UPDATE' END,
           GETDATE(),
           COALESCE(inserted.ProductID, deleted.ProductID),
           USER_NAME()
    FROM inserted
             FULL OUTER JOIN [deleted] ON inserted.ProductID = deleted.ProductID;
GO;

USE AdventureWorks2012;

CREATE VIEW Production.MyView AS SELECT * FROM AdventureWorks2012.Production.WorkOrder;
GO

SET IDENTITY_INSERT Production.WorkOrder ON

INSERT INTO Production.MyView (WorkOrderID, ProductID, OrderQty, ScrappedQty, StartDate, EndDate, DueDate, ScrapReasonID)
VALUES (72599, 329, 39, 0, '2011-10-14 00:00:00.000', '2011-11-24 00:00:00.000', '2020-06-25 00:00:00.000', null);

SET IDENTITY_INSERT Production.WorkOrder OFF

UPDATE Production.MyView SET EndDate = '2020-10-14 00:00:00.000' WHERE WorkOrderID = 72599;

DELETE FROM Production.MyView WHERE WorkOrderID = 72599;

SELECT * FROM Production.WorkOrderHst;
Go