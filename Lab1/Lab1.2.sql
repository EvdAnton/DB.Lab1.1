SELECT DepartmentID, Name FROM AdventureWorks2012.HumanResources.Department
WHERE (Name like 'P%');

SELECT BusinessEntityID, JobTitle, Gender, VacationHours, SickLeaveHours FROM AdventureWorks2012.HumanResources.Employee
WHERE VacationHours >= 10 and VacationHours <=13;

SELECT * FROM AdventureWorks2012.HumanResources.Employee
WHERE DAY(HireDate) = '1' and MONTH(HireDate) = '7'
ORDER BY BusinessEntityID
OFFSET 3 ROWS FETCH NEXT 5 ROWS ONLY;