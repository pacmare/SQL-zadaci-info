Use master
GO
IF Exists (Select * from sys.databases where name='TESTData')
begin
Drop database TESTData
end
--baza
Create database TESTData
GO

Use TESTData
GO
--tablica Titula
Create table TITULA
(TitulaID int  unique identity(1,1) not null,
TitulaNode hierarchyid primary key clustered,
TitulaLvl as TitulaNode.GetLevel(),
NazivTitule nvarchar(50) not null,
BrisanoTitula bit not null,
DatumPromjene datetime not null)
GO
--constraint na tablicu Titula za atribut Brisano
Alter table Titula Add constraint TitulaBrisano default 0 for BrisanoTitula
GO
--constraint na tablicu Titula za atribut DatumPromjene
Alter table Titula Add constraint TitulaDAtumPromjene default(getdate()) for DatumPromjene
GO
--index na tablici titula
Create unique index TitulaNodeLvl
on Titula(TitulaNode, TitulaLvl)
GO

--dodavanje hijerarhije
Insert into TITULA (TitulaNode,NazivTitule)
Values (hierarchyid::GetRoot(),'Uprava')
GO

---------------------------------
--procedura za unos podataka
Create PROC UnosTitula (@titulaNaziv nvarchar(50))
AS
Begin
Declare @levelRoot hierarchyid, @levelDesc hierarchyid
Select @levelRoot= TITULA.TitulaNode
From TITULA
Set transaction isolation level serializable
Begin transaction
Select @levelDesc=max(Titula.TitulaNode)
from TITULA
where TitulaNode.GetAncestor(1)=@levelRoot
Insert into TITULA(TitulaNode,NazivTitule)
Values(@levelRoot.GetDescendant(@levelDesc,Null),@titulaNaziv)
Commit transaction
End
GO


--unos podataka
Exec UnosTitula 'Team Owner'
Exec UnosTitula 'Team Leader'
Exec UnosTitula 'Inženjer'

Insert into TITULA (TitulaNode,NazivTitule)
Values ('/0/','Vanjski suradnik')
GO
------------------------------------------
--tablica Osoba
Create table OSOBA
(OsobaID int primary key identity(1,1) not null,
ImeOsobe nvarchar(50) not null,
PrezimeOsobe nvarchar(50) not null,
TitulaFK int foreign key references TITULA(TitulaID),
BrisanoOsoba bit not null,
DatumPromjene datetime not null)
GO
--dodavanje constraint na tablicu Osoba atribut Brisano
Alter table Osoba Add constraint OsobaBrisano default 0 for BrisanoOsoba
GO
--dodavanje constraint na tablicu Osoba atribut DatumPromjene
Alter table Osoba Add constraint OsobaDatumPromjene default(getdate()) for DatumPromjene
GO
--unos podataka u tablicu Osoba
Insert into OSOBA (ImeOsobe,PrezimeOsobe,TitulaFK)
Values ('Pero','Periæ',1),
		('Ivana','Iviæ',2),
		('Josipa','Josiæ',3),
		('Tomo','Tomiæ',4),
		('Petra','Perkoviæ',5)
GO
------------------------------------
Create proc Nadredeni (@osobaID int, @level int)
As
Begin
Declare @levelRoot hierarchyid
Select  @levelRoot= TITULA.TitulaNode
from TITULA
join OSOBA
on TITULA.TitulaID=OSOBA.TitulaFK
where OsobaID = @osobaID
Set transaction isolation level serializable
Begin transaction
Select TitulaID, TitulaNode.ToString() as TitulaNode_TEXT, 
TitulaNode, TitulaLvl, NazivTitule, OsobaID,
ImeOsobe, PrezimeOsobe
from Osoba
join Titula 
on Osoba.TitulaFK=Titula.TitulaID
where TitulaNode.IsDescendantOf(@levelRoot)=@level
Commit transaction
End
GO

Exec Nadredeni 1,1
-----------------------------------
Declare @osobe hierarchyid
Select @osobe = TITULA.TitulaNode
from TITULA
join OSOBA
on TITULA.TitulaID=OSOBA.TitulaFK
where OsobaID = 5

Select TitulaID, TitulaNode.ToString() as TitulaNode_TEXT, 
TitulaNode, TitulaLvl, NazivTitule, OsobaID,
ImeOsobe, PrezimeOsobe
from Osoba
join Titula 
on Osoba.TitulaFK=Titula.TitulaID
where TitulaNode.IsDescendantOf(@osobe)=1

------------------------------------
Create proc Podredeni(@osobaID int, @level int)
AS
Begin
Declare @levelRoot hierarchyid
Select @levelRoot=TITULA.TitulaNode
from TITULA
join OSOBA
on TITULA.TitulaID=OSOBA.TitulaFK
where OsobaID=@osobaID

Select TitulaID, TitulaNode.ToString() as TitulaNode_TEXT, 
TitulaNode, TitulaLvl, NazivTitule, OsobaID,
ImeOsobe, PrezimeOsobe
from OSOBA
join TITULA
on OSOBA.TitulaFK=TITULA.TitulaID
where TitulaNode.GetAncestor(@level)=@levelRoot
End
GO

exec Podredeni 2,2

Declare @osobe hierarchyid
Select @osobe = TITULA.TitulaNode
from TITULA
join OSOBA
on TITULA.TitulaID=OSOBA.TitulaFK
where OsobaID = 1

Select TitulaID, TitulaNode.ToString() as TitulaNode_TEXT, 
TitulaNode, TitulaLvl, NazivTitule, OsobaID,
ImeOsobe, PrezimeOsobe
from Osoba
join Titula 
on Osoba.TitulaFK=Titula.TitulaID
where TitulaNode.GetAncestor(1)=@osobe
--------------------------------------

Drop table OSOBA
Drop table Titula
Drop proc UnosTitula
Delete from Titula
Delete from Osoba
GO

Select * from Titula
Select * from Osoba

Select ImeOsobe, PrezimeOsobe, NazivTitule
from Osoba
join Titula 
on Osoba.TitulaFK=Titula.TitulaID


select TitulaID, TitulaNode.ToString() as TitulaNode_TEXT, 
TitulaNode, TitulaLvl, NazivTitule, BrisanoTitula, DatumPromjene
from Titula