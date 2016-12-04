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
Create table Users
(UsersID int unique identity(1,1) not null,
UsersOIB int primary key clustered not null,
FirstName nvarchar(50) not null,
LastName nvarchar(50) not null,
Deleted bit not null,
ModifiedDate datetime not null)
GO
Create table City
(CityID int unique identity(1,1) not null,
PostNumber int primary key clustered not null,
CityName nvarchar(50) not null,
Deleted bit not null,
ModifiedDate datetime not null
)
GO
Create table Addresses
(Addresses int primary key identity(1,1) not null,
AddressName nvarchar(100) not null,
PostNumber int foreign key references City(PostNumber),
UsersOIB int foreign key references Users(UsersOIB),
Deleted bit not null,
ModifiedDate datetime not null
)
GO

Create table BankAccounts
(BankAccountsID int unique identity(1,1) not null,
BankAccountNumber int primary key clustered not null,
BankAccountType nvarchar(50) not null,
UsersOIB int foreign key references Users(UsersOIB),
DateCreated datetime not null,
DateClosed datetime null,
Deleted bit not null,
ModifiedDate datetime not null
)
GO


--kreiranje baze Archive
Use master
GO
IF Exists (Select * from sys.databases where name='TestArchive')
begin
Drop database TestArchive
end
GO
Create database TestArchive
GO

Use TestArchive
GO

Create schema Archive
GO

Create table Archive.Users
(UsersID int unique identity(1,1) not null,
UsersOIB int primary key clustered not null,
FirstName nvarchar(50) not null,
LastName nvarchar(50) not null,
Deleted bit not null,
ModifiedDate datetime not null)
GO
Create table Archive.City
(CityID int unique identity(1,1) not null,
PostNumber int primary key clustered not null,
CityName nvarchar(50) not null,
Deleted bit not null,
ModifiedDate datetime not null
)
GO
Create table Archive.Addresses
(Addresses int primary key identity(1,1) not null,
AddressName nvarchar(100) not null,
PostNumber int foreign key references Archive.City(PostNumber),
UsersOIB int foreign key references Archive.Users(UsersOIB),
Deleted bit not null,
ModifiedDate datetime not null
)
GO

Create table Archive.BankAccounts
(BankAccountsID int unique identity(1,1) not null,
BankAccountNumber int primary key clustered not null,
BankAccountType nvarchar(50) not null,
UsersOIB int foreign key references Archive.Users(UsersOIB),
DateCreated datetime not null,
DateClosed datetime null,
Deleted bit not null,
ModifiedDate datetime not null
)
GO

 --drop table city
 --drop table users


