/* 

Cleaning Data In SQL

*/


SELECT
  *
FROM
  PortfolioProject..Nashvillehousing

-------------------------------------------------------------------------------------------------------

-- Standardize Date Format

ALTER table Nashvillehousing
Add saledate2 DATE

UPDATE Nashvillehousing
SET saledate2=CONVERT(date,saledate)

SELECT
  saledate2,
  CONVERT(date, saledate)
FROM
  PortfolioProject..Nashvillehousing

------------------------------------------------------------------------------------------


-- Populate property address date

SELECT
  *
FROM
  PortfolioProject..Nashvillehousing
--WHERE
    --Propertyaddress is null
ORDER BY 
  ParcelID


SELECT
  a.parcelid,
  a.Propertyaddress,
  b.parcelid,
  b.Propertyaddress,
  ISNULL(a.Propertyaddress,b.Propertyaddress)
FROM
  PortfolioProject..Nashvillehousing AS a
JOIN 
  PortfolioProject..Nashvillehousing AS b
ON
  a.parcelid=b.parcelid
AND a.[uniqueid]!=b.[uniqueid]
WHERE
  a.propertyaddress is NULL


UPDATE a
SET propertyaddress=ISNULL(a.Propertyaddress,b.Propertyaddress)
FROM
  PortfolioProject..Nashvillehousing AS a
JOIN 
  PortfolioProject..Nashvillehousing AS b
ON
  a.parcelid=b.parcelid
AND a.[uniqueid]!=b.[uniqueid]

---------------------------------------------------------------------------------------------------------------

-- Split Address into address, city, state

SELECT
  propertyaddress
FROM
  PortfolioProject..Nashvillehousing

SELECT
  SUBSTRING(propertyaddress, 1, CHARINDEX(',',propertyaddress)-1) AS address,
  SUBSTRING(propertyaddress, CHARINDEX(',',propertyaddress)+1, LEN(propertyaddress)) AS city
FROM
  PortfolioProject..Nashvillehousing


ALTER table Nashvillehousing
Add address_split nvarchar(255)

UPDATE Nashvillehousing
SET address_split=SUBSTRING(propertyaddress, 1, CHARINDEX(',',propertyaddress)-1)

ALTER table Nashvillehousing
Add city_split nvarchar(255)

UPDATE Nashvillehousing
SET city_split=SUBSTRING(propertyaddress, CHARINDEX(',',propertyaddress)+1, LEN(propertyaddress))


SELECT
  *
FROM
  PortfolioProject..Nashvillehousing




SELECT
  owneraddress
FROM
  PortfolioProject..Nashvillehousing


SELECT
PARSENAME(REPLACE(owneraddress,',','.'),3),
PARSENAME(REPLACE(owneraddress,',','.'),2),
PARSENAME(REPLACE(owneraddress,',','.'),1)
FROM
  PortfolioProject..Nashvillehousing 


ALTER table Nashvillehousing
Add Owner_address_split nvarchar(255)

UPDATE Nashvillehousing
SET Owner_address_split=PARSENAME(REPLACE(owneraddress,',','.'),3)

ALTER table Nashvillehousing
Add Owner_city_split nvarchar(255)

UPDATE Nashvillehousing
SET Owner_city_split=PARSENAME(REPLACE(owneraddress,',','.'),2)

ALTER table Nashvillehousing
Add Owner_state_split nvarchar(255)

UPDATE Nashvillehousing
SET Owner_state_split=PARSENAME(REPLACE(owneraddress,',','.'),1)


SELECT
  *
FROM
  PortfolioProject..Nashvillehousing

-------------------------------------------------------------------------------

-- Change Y and N to Yes and No in 'sold as vacant'

SELECT
  DISTINCT(SoldAsVacant),
  COUNT(SoldAsVacant)
FROM
  PortfolioProject..Nashvillehousing
GROUP BY
  SoldAsVacant


SELECT
  SoldAsVacant,
  CASE when SoldAsVacant ='Y' THEN 'Yes'
       when SoldAsVacant ='N' THEN 'No'
       ELSE SoldAsVacant
       END
FROM
  PortfolioProject..Nashvillehousing
GROUP BY
  SoldAsVacant


UPDATE Nashvillehousing
SET SoldAsVacant = CASE when SoldAsVacant ='Y' THEN 'Yes'
                        when SoldAsVacant ='N' THEN 'No'
                        ELSE SoldAsVacant
                        END


---------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY ParcelID,
                        PropertyAddress,
                        saleprice,
                        saledate,
                        LegalReference
           ORDER BY UniqueID
         ) AS Row_num
  FROM PortfolioProject..Nashvillehousing
)
SELECT *
FROM RowNumCTE
WHERE Row_num > 1
ORDER BY ParcelID;


---------------------------------------------------------------------------


-- Delete unused columns


 SELECT
  *
FROM
  PortfolioProject..Nashvillehousing


ALTER table PortfolioProject..Nashvillehousing
DROP COLUMN
  OwnerAddress,
  TaxDistrict,
  PropertyAddress,
  saledate






