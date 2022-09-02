--Data Cleaning Project
select*
from NashvilleHousing

--Change Sale Date

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date

update NashvilleHousing
set SaleDateConverted = Convert(Date, SaleDate) 


--Populated Property Address Data
Select *
from NashvilleHousing
where PropertyAddress is Null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is NULL

update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is NULL

--Populate Address into Individual Columns(Adress, city, State)
select PropertyAddress
from NashvilleHousing

select substring(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1) as Address, 
substring(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) as City
from NashvilleHousing

alter table NashVilleHousing
Add PropertySplitAddress Nvarchar(255)

update NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1)

alter table NashVilleHousing
Add PropertySplitCity Nvarchar(255)

Update NashvilleHousing
set PropertySplitCity = substring(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))


--Populate Owner Address into Column (Address, City, State)

select OwnerAddress
from NashvilleHousing

select
parsename(REPLACE(OwnerAddress, ',','.') , 3),
parsename(REPLACE(OwnerAddress, ',','.') , 2),
parsename(REPLACE(OwnerAddress, ',','.') , 1)
from NashvilleHousing

alter table NashVilleHousing
Add OwnerSplitAddress Nvarchar(255)

Update NashvilleHousing
set OwnerSplitAddress = parsename(REPLACE(OwnerAddress, ',','.') , 3)

alter table NashVilleHousing
Add OwnerSplitCity Nvarchar(255)

Update NashvilleHousing
set OwnerSplitCity = parsename(REPLACE(OwnerAddress, ',','.') , 2)

alter table NashVilleHousing
Add OwnerSplitState Nvarchar(255)

Update NashvilleHousing
set OwnerSplitState = parsename(REPLACE(OwnerAddress, ',','.') , 1)


--Change Y and N to Yes and NO in "SoldAsVacant"

select Distinct(SoldAsVacant)
From NashvilleHousing

Select SoldAsVacant,
Case when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	END
from NashvilleHousing

Update NashvilleHousing
set SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	END

--Remove Duplicates
with RowNum1 AS(
select*,
	ROW_NUMBER() Over (
	partition by  ParcelID, 
				  PropertyAddress, 
				  SaleDate, 
				  LegalReference
				  order by
					UniqueID
					) row_num
from NashvilleHousing)


Delete
from RowNum1
Where row_num > 1

-- double check deleted rows
with RowNum1 AS(
select*,
	ROW_NUMBER() Over (
	partition by  ParcelID, 
				  PropertyAddress, 
				  SaleDate, 
				  LegalReference
				  order by
					UniqueID
					) row_num
from NashvilleHousing)


select *
from RowNum1
Where row_num > 1

--Delete Unused Columns
Alter Table NashvilleHousing
Drop Column  OwnerAddress, TaxDistrict, PropertyAddress,SaleDate

select*
from NashvilleHousing
