RESTORE FILELISTONLY FROM DISK = '/var/opt/mssql/backup/AW2012.bak'

RESTORE DATABASE AdventureWorks2012 FROM DISK = '/var/opt/mssql/backup/AW2012.bak'
WITH MOVE 'AdventureWorks2012_Data' TO '/var/opt/mssql/data/AdventureWorks2012_Data.mdf',
    MOVE 'AdventureWorks2012_Log' TO '/var/opt/mssql/AdventureWorks2012_log.ldf'

-- check connection to database
SELECT *
FROM AdventureWorks2012.HumanResources.Department

CREATE DATABASE NewDatabase;

USE NewDatabase;

CREATE SCHEMA sales;
CREATE SCHEMA person;

CREATE TABLE sales.Orders (OrderNum INT NULL);

BACKUP DATABASE NewDatabase TO DISK='/var/opt/mssql/backup/NewDatabase.bak';

USE master;

DROP DATABASE NewDatabase;

RESTORE DATABASE NewDatabase FROM DISK = '/var/opt/mssql/backup/NewDatabase.bak';

-- come in container using powershell
-- docker exec -it mssql_db "bash"
-- /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "Password123"