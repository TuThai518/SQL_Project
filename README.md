# 🏡 Nashville Housing Data Cleaning Project

This project focuses on cleaning and transforming the **Nashville Housing dataset** using **Microsoft SQL Server**. The primary goal is to prepare and structure the data for future analysis by addressing data quality issues such as inconsistent formats, missing values, and redundant fields.

---

## 🚀 Project Purpose
The main purpose of this project is **data cleaning**—to transform raw housing data into a clean, usable format for analysis and reporting.

---

## 📌 Key Cleaning Steps

1. **Standardizing Date Format**
   - Converted the `SaleDate` column to remove unnecessary time information.
   - Created a new column `SaleDateConverted` using `CONVERT()` function.

2. **Populating Missing Property Address**
   - Identified duplicate `ParcelID` records with missing `PropertyAddress`.
   - Used `JOIN` to fill in missing addresses based on matching `ParcelID`.

3. **Splitting Property Address into Columns**
   - Broke out `PropertyAddress` into:
     - `PropertySplitAddress` (Street)
     - `PropertySplitCity` (City)

4. **Splitting Owner Address into Columns**
   - Used `PARSENAME()` function to separate `OwnerAddress` into:
     - `OwnerSplitAddress1` (Street)
     - `OwnerSplitCity2` (City)
     - `OwnerSplitState3` (State)

5. **Standardizing "Sold As Vacant" Field**
   - Cleaned inconsistent values (`Y`, `N`, `Yes`, `No`) using `CASE` statements.

6. **Removing Unused Columns**
   - Dropped unnecessary columns such as:
     - `OwnerAddress`
     - `TaxDistrict`
     - `PropertyAddress`
     - Original `SaleDate` column

---

## 🛠️ Tools & Techniques Used
- Microsoft SQL Server
- SQL functions: `CONVERT()`, `SUBSTRING()`, `CHARINDEX()`, `PARSENAME()`, `CASE`, `JOIN`
- Data normalization and cleanup techniques

---

## ✅ Conclusion
These cleaning steps significantly improved the quality and structure of the Nashville Housing dataset, making it ready for accurate analysis, visualization, and reporting.
