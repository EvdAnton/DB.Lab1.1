SELECT EmployeeDepartmentHistory.BusinessEntityID,
       Employee.JobTitle,
       EmployeeDepartmentHistory.DepartmentID,
       Department.Name
FROM AdventureWorks2012.HumanResources.EmployeeDepartmentHistory
         JOIN AdventureWorks2012.HumanResources.Employee
              ON EmployeeDepartmentHistory.BusinessEntityID = Employee.BusinessEntityID AND
                 EmployeeDepartmentHistory.EndDate is NULL
         JOIN AdventureWorks2012.HumanResources.Department
              ON EmployeeDepartmentHistory.DepartmentID = Department.DepartmentID;
GO

SELECT Department.DepartmentID,
       Department.Name,
       COUNT(*) AS EmpCount
FROM AdventureWorks2012.HumanResources.Department
         JOIN AdventureWorks2012.HumanResources.EmployeeDepartmentHistory
              ON Department.DepartmentID = EmployeeDepartmentHistory.DepartmentID
         JOIN AdventureWorks2012.HumanResources.Employee
              ON EmployeeDepartmentHistory.BusinessEntityID =
                 AdventureWorks2012.HumanResources.Employee.BusinessEntityID
                  AND EndDate is null
GROUP BY Department.Name, Department.DepartmentID;
GO

SELECT JobTitle,
       Rate,
       RateChangeDate,
       'The rate for' + JobTitle + 'was set to ' + LTRIM(CAST(Rate as char(20))) + ' at ' +
       FORMAT(RateChangeDate, 'dd MMM yyyy') as Date
FROM AdventureWorks2012.HumanResources.Employee
         JOIN AdventureWorks2012.HumanResources.EmployeePayHistory
              ON Employee.BusinessEntityID = EmployeePayHistory.BusinessEntityID;
GO
