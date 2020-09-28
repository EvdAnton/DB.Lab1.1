CREATE DATABASE NewDatabase;

USE NewDatabase;
GO

CREATE SCHEMA sales;
GO

CREATE SCHEMA person;
GO

CREATE TABLE sales.Orders (OrderNum INT NULL);
GO

BACKUP DATABASE NewDatabase TO DISK='/var/opt/mssql/backup/NewDatabase.bak';
GO

USE master;

DROP DATABASE NewDatabase;
GO

RESTORE DATABASE NewDatabase FROM DISK = '/var/opt/mssql/backup/NewDatabase.bak';
GO