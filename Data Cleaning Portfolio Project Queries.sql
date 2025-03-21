/*

Cleaning Data in SQL Queries

*/


select *
From Portfolio_file.dbo.NashvilleHousing






--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

select SaleDateConverted, CONVERT(Date, SaleDate)
From Portfolio_file.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------
 --populate property address data

 select *
From Portfolio_file.dbo.NashvilleHousing
---where PropertyAddress is Null
order by ParcelID

-----JOINING A TABLE TO ITSELF---

 select a. ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Portfolio_file.dbo.NashvilleHousing a
JOIN Portfolio_file.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b. [UniqueID ]
Where a.propertyAddress is Null


Update a
SET propertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From Portfolio_file.dbo.NashvilleHousing a
JOIN Portfolio_file.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b. [UniqueID ]
Where a.propertyAddress is Null



--------------------------------------------------------------------------------------------------------------------------
--Breaking out Address into Individual columns ( Address, City, State)

select PropertyAddress
From Portfolio_file.dbo.NashvilleHousing
---where PropertyAddress is Null
---order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', propertyAddress) -1) AS Address
 , SUBSTRING(PropertyAddress, CHARINDEX(',', propertyAddress) +1, LEN(PropertyAddress)) AS Address


From Portfolio_file.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', propertyAddress) -1) 


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity =   SUBSTRING(PropertyAddress, CHARINDEX(',', propertyAddress) +1, LEN(PropertyAddress))

select*
From Portfolio_file.dbo.NashvilleHousing


select OwnerAddress
From Portfolio_file.dbo.NashvilleHousing


----PARSENAME DOES THINGS BACKWARDS---
Select
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)

From Portfolio_file.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', propertyAddress) -1) 










--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field







-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates





---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



















-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

--- Importing Data using OPENROWSET and BULK INSERT	

--  More advanced and looks cooler, but have to configure server appropriately to do correctly
--  Wanted to provide this in case you wanted to try it


--sp_configure 'show advanced options', 1;
--RECONFIGURE;
--GO
--sp_configure 'Ad Hoc Distributed Queries', 1;
--RECONFIGURE;
--GO


--USE PortfolioProject 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1 

--GO 


---- Using BULK INSERT

--USE PortfolioProject;
--GO
--BULK INSERT nashvilleHousing FROM 'C:\Temp\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv'
--   WITH (
--      FIELDTERMINATOR = ',',
--      ROWTERMINATOR = '\n'
--);
--GO


---- Using OPENROWSET
--USE PortfolioProject;
--GO
--SELECT * INTO nashvilleHousing
--FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
--    'Excel 12.0; Database=C:\Users\alexf\OneDrive\Documents\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv', [Sheet1$]);
--GO


















