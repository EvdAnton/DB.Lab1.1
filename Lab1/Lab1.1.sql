CREATE DATABASE NewDatabase;

USE NewDatabase;

CREATE SCHEMA sales;
CREATE SCHEMA person;

CREATE TABLE sales.Orders (OrderNum INT NULL);

BACKUP DATABASE NewDatabase TO DISK='/var/opt/mssql/backup/NewDatabase.bak';

USE master;

DROP DATABASE NewDatabase;

RESTORE DATABASE NewDatabase FROM DISK = '/var/opt/mssql/backup/NewDatabase.bak';