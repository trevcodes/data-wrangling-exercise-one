library (dplyr)
library (reshape2)

refineorig <- read.csv("refine_original.csv", header = TRUE) #Is the header arugment necessary for this data set?

str(refineorig)

#Step 1: Cleaning up brand names

refineorig$company[grepl('ps$',refineorig$company,ignore.case = TRUE)] <- 'phillips'

#str(refineorig$company)

refineorig$company[grepl('^A', refineorig$company, ignore.case = TRUE)] <- 'akzo'

#str(refineorig$company)

refineorig$company[grepl('^van', refineorig$company, ignore.case = TRUE)] <- 'van houten'

#str(refineorig$company)

refineorig$company[grepl('ver$', refineorig$company, ignore.case = TRUE)] <- 'unilever'

#str(refineorig$company)

#summarise(refineorig)?????

#Step 2: Separate product code and number

refineorigp <- colsplit(refineorig$Product.code...number, "-", c("product_code", "product_number"))
refineorig$product_code <- c(refineorigp$product_code)
refineorig$product_number <- c(refineorigp$product_number)
refineorig$Product.code...number <- NULL

#Step 3: Add product categories

refineorig$product_category[grepl('p', refineorig$product_code, ignore.case = TRUE)] <- 'Smartphone'
refineorig$product_category[grepl('q', refineorig$product_code, ignore.case = TRUE)] <- 'Tablet'
refineorig$product_category[grepl('v', refineorig$product_code, ignore.case = TRUE)] <- 'TV'
refineorig$product_category[grepl('x', refineorig$product_code, ignore.case = TRUE)] <- 'Laptop'

#Step 4: Add full address for geocoding

full_address <- with(refineorig, paste(address, city, country, sep = ","))
refineorig$full_address <- full_address
refineorig$full_address <- as.factor(refineorig$full_address)

#Step 5: Create dummy variables for company and product category
refineorig$company_phillips <- as.factor(ifelse(refineorig$company == 'phillips', 1, 0))
refineorig$company_akzo <- as.factor(ifelse(refineorig$company == 'akzo', 1, 0))
refineorig$company_van_houten <- as.factor(ifelse(refineorig$company == 'van houten', 1, 0))
refineorig$company_unilever <- as.factor(ifelse(refineorig$company == 'unilever', 1, 0))

refineorig$product_Smartphone <- as.factor(ifelse(refineorig$product_code == 'p', 1, 0))
refineorig$product_TV <- as.factor(ifelse(refineorig$product_code == 'v', 1, 0))
refineorig$product_Tablet <- as.factor(ifelse(refineorig$product_code == 'q', 1, 0))
refineorig$product_Laptop <- as.factor(ifelse(refineorig$product_code == 'x', 1, 0))

write.table(refineorig, "refine_clean.csv")
