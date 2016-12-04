Use AdventureWorks2014
GO

--unos podataka u novu tablicu
Select  Sales.Customer.CustomerID, 
		Sales.Customer.PersonID, 
		Person.Person.FirstName, 
		Person.Person.LastName, 
		Sales.Customer.ModifiedDate
Into TestCustomer
from Sales.Customer
join Person.Person
on Sales.Customer.PersonID=Person.BusinessEntityID
GO
--insert duplikata s novijim datumom
Insert into TestCustomer
Select top 1500 CustomerID, PersonID, FirstName, LastName, ModifiedDate=(getdate())
from TestCustomer
GO
-----------------
--traženje duplikata
Select CustomerID, FirstName, LastName, PersonID=count(*)
Into TestD
from TestCustomer
group by CustomerID, PersonID, FirstName, LastName
having count(*)>1
GO
--duplikati sa trenutnom godinom u datumu
Select distinct TestCustomer.*
Into TestDuplicateNew
From TestCustomer, TestD
Where TestCustomer.CustomerID=TestD.CustomerID
and year(ModifiedDate)=year(getdate())
GO
---------------------
--brisanje duplikata iz glavne tablice prema datumu
Delete TestCustomer
FROM TestCustomer, TestD
Where ModifiedDate in 
(Select min(ModifiedDate)
from TestCustomer)
and TestCustomer.CustomerID=TestD.CustomerID
GO
----------------------
--ispis PersonID koji su bili duplikati
Select TestCustomer.PersonID from TestCustomer,TestDuplicateNew
where TestCustomer.PersonID=TestDuplicateNew.PersonID
GO