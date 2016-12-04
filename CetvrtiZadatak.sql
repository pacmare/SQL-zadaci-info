Use master
GO

IF Exists (Select * from sys.databases where name='TESTData')
begin
Drop database TESTData
end
--radna baza 
Create database TESTData
GO

Use TESTData
GO

Create proc CreateInsert
AS
Begin
Create table Test
(ID int unique,
Value tinyint)

Insert into Test(ID,Value)
Select MAX(BusinessEntityID), PayFrequency from AdventureWorks2014.HumanResources.EmployeePayHistory
Group by BusinessEntityID, PayFrequency

Select distinct Value 
From Test 


End
GO