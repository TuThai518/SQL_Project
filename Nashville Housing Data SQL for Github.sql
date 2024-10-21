/*
Cleaning the data in SQL queries
*/


SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

----------------------------------------------------------------

-- Standardize Date Format --

/* In here, I notice that the date SaleDate column is not formatted in the date format, and including time that isn't useful.
Therefore, I create a column called SaleDateConverted to have the date formatted correctly. */

SELECT SaleDate
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing  -- Add the column converted date -- 
Add SaleDateConverted Date; 

UPDATE PortfolioProject.dbo.NashvilleHousing  -- update the table with new column --
SET SaleDateConverted = CONVERT(Date, SaleDate);  -- Remove the time from date column--

SELECT SaleDateConverted
FROM PortfolioProject.dbo.NashvilleHousing

------------------------------------------------------------------------
-- Populate Property Address Data

/* I see that there's a lot of ID are the same, and have the same property address (after doing the ORDER BY ParcelID function below.
So I notice  if a parcel ID has the property address, and the same parcel ID doesn't. Then we can put them as the same */
SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b. [UniqueID ] -- because Unique ID are unique
WHERE a.PropertyAddress is null  -- check where property address is null and ParcelID are equal, but UniqueID are different
--> can see that same ParcelID should have same Property Address

UPDATE a  -- update the null property address where it is null and have the same ParcelID
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b. [UniqueID ]
WHERE a.PropertyAddress is null

SELECT ParcelID, PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress is null
--> Test again and it works, no more null

------------------------------------------------------------------------

-- Breaking out Property Address Into Individual Column (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing
-- notice that the address street name and city is separated by a comma, the demiliter

SELECT 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Street_Address, 
	SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City 
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);
Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) 
-- add the column PropertySplitAddress = to the substring before the comma

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);
Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))
-- add the column PropertySplitCity = to the substring after the comma

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing


------------------------------------------------------------------------

-- Breaking out Owner Address Into Individual Column
SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.' ), 3)	AS Address,  -- replace the comma with the period and separate into columns
PARSENAME(REPLACE(OwnerAddress, ',', '.' ), 2)	AS City,
PARSENAME(REPLACE(OwnerAddress, ',', '.' ), 1)	AS State
FROM PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress1 Nvarchar(255), 
	OwnerSplitCity2 Nvarchar(255), 
	OwnerSplitState3 Nvarchar(255); -- has to run this column first

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress1 = PARSENAME(REPLACE(OwnerAddress, ',', '.' ), 3), 
	OwnerSplitCity2 = PARSENAME(REPLACE(OwnerAddress, ',', '.' ), 2),
	OwnerSplitState3 = PARSENAME(REPLACE(OwnerAddress, ',', '.' ), 1)

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant),
COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing   
GROUP BY SoldAsVacant
ORDER BY 2	-- has N, No, Y, Yes


UPDATE PortfolioProject.dbo.NashvilleHousing   -- Set Y to Yes and N to No in SoldAsVacant column
SET SoldAsVacant = 
CASE When SoldAsVacant = 'Y' THEN 'Yes'
		 When SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
FROM PortfolioProject.dbo.NashvilleHousing 

SELECT DISTINCT(SoldAsVacant)    -- Check again and it is correct
FROM PortfolioProject.dbo.NashvilleHousing   

------------------------------------------------------------------------

--  Delete unused column

SELECT*
FROM PortfolioProject.dbo.NashvilleHousing  -- owner split address is more useful than original owner address

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerSplitAddress, OwnerSplitCity, OwnerSplitState