SELECT *
From [Portfolio Project].dbo.NashvilleHousing



SELECT SaleDateConverted, CONVERT(Date, SaleDate)
From [Portfolio Project].dbo.NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)






--Populate Property Address--






SELECT *
From [Portfolio Project].dbo.NashvilleHousing
--where PropertyAddress is null
Order By ParcelID



SELECT Alpha.ParcelID, Alpha.PropertyAddress, Delta.ParcelID, Delta.PropertyAddress, isnull(Alpha.PropertyAddress,Delta.PropertyAddress)
From [Portfolio Project].dbo.NashvilleHousing Alpha
Join [Portfolio Project].dbo.NashvilleHousing Delta
	on Alpha.ParcelID = Delta.ParcelID
	AND Alpha.[UniqueID ] <> Delta.[UniqueID ]
where Alpha.PropertyAddress is null


update Alpha
SET PropertyAddress = ISNULL (Alpha.PropertyAddress,Delta.PropertyAddress)
From [Portfolio Project].dbo.NashvilleHousing Alpha
Join [Portfolio Project].dbo.NashvilleHousing Delta
	on Alpha.ParcelID = Delta.ParcelID
	AND Alpha.[UniqueID ] <> Delta.[UniqueID ]






-- Breaking address into Individual Columns (Address, City, State)--





SELECT PropertyAddress
From [Portfolio Project].dbo.NashvilleHousing
--where PropertyAddress is null
--Order By ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
From [Portfolio Project].dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


Select *
From [Portfolio Project].dbo.NashvilleHousing


------------------------------------------------------------------


Select OwnerAddress
From [Portfolio Project].dbo.NashvilleHousing


Select 
PARSENAME(REPLACE(OwnerAddress,',','.') , 3)
, PARSENAME(REPLACE(OwnerAddress,',','.') , 2)
, PARSENAME(REPLACE(OwnerAddress,',','.') , 1)
From [Portfolio Project].dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') , 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.') , 1)



------------------------------------------------------------------



-- Change Y and N to Yes and No in "Sold as Vacant" Field --



Select Distinct (SoldAsVacant), COUNT(SoldAsVacant)
From [Portfolio Project].dbo.NashvilleHousing
Group by SoldAsVacant
order by 2



Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   ELSE SoldAsVacant
	   END
From [Portfolio Project].dbo.NashvilleHousing



Update NashvilleHousing 
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   ELSE SoldAsVacant
	   END
From [Portfolio Project].dbo.NashvilleHousing






--Removing the Duplicates--





WITH RowNumCTE AS(
Select *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					) row_num
From [Portfolio Project].dbo.NashvilleHousing
--order by ParcelID
)
Select*
From RowNumCTE 
where row_num > 1
--order by PropertyAddress





-- Delete Unused Columns --





Select*
From [Portfolio Project].dbo.NashvilleHousing


ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
DROP COLUMN SaleDate