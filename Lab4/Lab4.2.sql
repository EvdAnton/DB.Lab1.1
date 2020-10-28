DROP VIEW Production.WorkOrderView

CREATE VIEW Production.WorkOrderView
            (
             [WorkOrderId],
             [ProductId],
             [OrderQty],
             [StockedQty],
             [ScrappedQty],
             [StartDate],
             [EndDate],
             [DueDate],
             [ScrapReasonID],
             [ModifiedDate],
             [SRName],
             [SRModifiedDate]
                ) WITH ENCRYPTION, SCHEMABINDING
AS
SELECT [WO].[WorkOrderId],
       [WO].[ProductId],
       [WO].[OrderQty],
       [WO].[StockedQty],
       [WO].[ScrappedQty],
       [WO].[StartDate],
       [WO].[EndDate],
       [WO].[DueDate],
       [WO].[ScrapReasonID],
       [WO].[ModifiedDate],
       [SR].[Name],
       [SR].[ModifiedDate]
FROM Production.WorkOrder AS WO
         JOIN Production.ScrapReason as SR ON WO.ScrapReasonID = SR.ScrapReasonID
GO

CREATE UNIQUE CLUSTERED INDEX [AK_WorkOrderIdView_WorkOrderId] ON Production.WorkOrderView ([WorkOrderId]);

CREATE TRIGGER Production.WorkOrderViewInsteadInsertTrigger
    ON Production.WorkOrderView
    INSTEAD OF INSERT AS
BEGIN
    BEGIN
        INSERT INTO Production.ScrapReason ([Name], [ModifiedDate])
        SELECT [SRName], [SRModifiedDate]
        from inserted
    end;

    BEGIN
        INSERT INTO Production.WorkOrder (ProductID, OrderQty, ScrappedQty, StartDate, EndDate, DueDate, ScrapReasonID,
                                          ModifiedDate)
        SELECT [ProductID],
               [OrderQty],
               [ScrappedQty],
               [StartDate],
               [EndDate],
               [DueDate],
               [SR].[ScrapReasonID],
               GETDATE()
        from inserted
                 JOIN Production.ScrapReason AS SR
                      On SR.Name = inserted.SRName
    end;
END;


DROP TRIGGER Production.WorkOrderViewInsteadUpdateTrigger;

CREATE TRIGGER Production.WorkOrderViewInsteadUpdateTrigger
    ON Production.WorkOrderView
    INSTEAD OF UPDATE AS
BEGIN
    BEGIN
        UPDATE Production.ScrapReason
        SET [Name]         = [inserted].[SRName],
            [ModifiedDate] = [inserted].[SRModifiedDate]
        FROM inserted
        where inserted.ScrapReasonID = Production.ScrapReason.ScrapReasonID
    END;

    BEGIN
        UPDATE Production.WorkOrder
        SET [ProductID]     = [inserted].[ProductId],
            [ScrappedQty]   = [inserted].[ScrappedQty],
            [StartDate]     = [inserted].[StartDate],
            [EndDate]       = [inserted].[EndDate],
            [DueDate]       = [inserted].[DueDate],
            [ScrapReasonID] = [inserted].[ScrapReasonID],
            [ModifiedDate]  = [inserted].[ModifiedDate]
        from inserted

    END;
end;
GO

CREATE TRIGGER Production.WorkOrderScrapReasonVIEW_Update
    ON Production.WorkOrderView
    INSTEAD OF UPDATE AS
BEGIN
    UPDATE Production.ScrapReason
    SET Name         = inserted.SRName,
        ModifiedDate = inserted.SRModifiedDate
    FROM inserted
    WHERE Production.ScrapReason.ScrapReasonID = inserted.ScrapReasonID

    UPDATE Production.WorkOrder
    SET DueDate      = inserted.DueDate,
        EndDate      = inserted.EndDate,
        ModifiedDate = inserted.ModifiedDate,
        ScrappedQty  = inserted.ScrappedQty,
        StartDate    = inserted.StartDate
    FROM inserted
    WHERE Production.WorkOrder.ProductID = inserted.ProductID
END;
GO

CREATE TRIGGER Production.WorkOrderViewInsteadDeleteTrigger
    ON Production.WorkOrderView
    INSTEAD OF DELETE AS
BEGIN
    DELETE FROM Production.WorkOrder WHERE WorkOrderID IN (SELECT WorkOrderId from deleted)
    DELETE FROM Production.ScrapReason WHERE ScrapReasonID IN (SELECT ScrapReasonID from deleted)
end;
GO

INSERT INTO Production.WorkOrderView(ProductId, OrderQty, ScrappedQty, StartDate, EndDate, DueDate, ModifiedDate,
                                     SRName, SRModifiedDate)
VALUES (316, 97, 3, '2014-05-31 00:00:00.000', '2020-06-10 00:00:00.000', '2014-06-11 00:00:00.000',
        '2014-06-10 00:00:00.000', 'Trim length too long again 25', '2008-04-30 00:00:00.000');

SELECT *
FROM Production.WorkOrderView
where SRName = 'new reason';

SELECT *
FROM Production.ScrapReason
where Name = 'new reason';

UPDATE Production.WorkOrderView
SET SRName = 'new reason'
WHERE SRName = 'Trim length too long again 7';

DELETE
FROM Production.WorkOrderView
WHERE SRName = 'new reason'

