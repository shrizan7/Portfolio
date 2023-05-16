/*

Cleaning Data

*/

Select *
From PortfolioProject.dbo.NashvilleHousing


-- Standardize the Date format

Select SaleDateConverted,Convert(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
SET saledate= CONVERT(Date,Saledate)

Alter table NashvilleHousing
Add SaledateConverted Date;

Update PortfolioProject.dbo.NashvilleHousing
SET saleDateConverted= CONVERT(Date,Saledate)

--Populate Property Address ( Updating the address using self join)

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelId

Select a.ParcelId,a.PropertyAddress,b.ParcelId,b.PropertyAddress, Isnull(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelId = b.ParcelId
	and a.[UniqueId]<>b.[UniqueId]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = Isnull(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelId = b.ParcelId
	and a.[UniqueId]<>b.[UniqueId]

Where a.PropertyAddress is null


---Breaking out Address into individual columns (Address, Cty, State )

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

Select 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) AS address
,SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing

Alter table PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress= SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

Alter table PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity= SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

Select * 
From PortfolioProject.dbo.NashvilleHousing

--using Parsename

Select 
PARSENAME(OwnerAddress,1) 
From PortfolioProject.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From PortfolioProject.dbo.NashvilleHousing


Alter table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress= PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)


Alter table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitState= PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select * 
From PortfolioProject.dbo.NashvilleHousing


-- Change Y and N to Yes and No in "Sold as Vancant" field


Select Distinct(SoldasVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group BY SoldAsVacant
Order by 2

Select SoldAsVacant,
Case when SoldasVacant ='Y' Then 'Yes'
	 when SoldasVacant ='N' Then 'No'
	 Else SoldAsVacant
	 END
From PortfolioProject.dbo.NashvilleHousing


Update PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = Case when SoldasVacant ='Y' Then 'Yes'
	 when SoldasVacant ='N' Then 'No'
	 Else SoldAsVacant
	 END




--Removing Duplicates
/* 
Creating temp table to contain the duplicates
*/

WITH RowNumCTE AS (

Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelId,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueId
					)row_num
From PortfolioProject.dbo.NashvilleHousing
--Order BY ParcelID
)
Select *
From RowNumCTE
Where row_num >1
Order By PropertyAddress

/*
Deleting the duplicates
*/
--Delete
--From RowNumCTE
--Where row_num >1
--Order By PropertyAddress



Select * 
From PortfolioProject.dbo.NashvilleHousing


-- Deleting Unused Columns


Select * 
From PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

Alter Table PortfolioProject.dbo.NashvilleHousing
DROP COLUMN Saledate
