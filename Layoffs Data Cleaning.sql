-- data cleaning

select * 
from layoffs
;

select count(*)
from layoffs
;

select *,
row_number () over(
partition by company, industry, total_laid_off,percentage_laid_off, 'date') as row_num
from layoffs
;



with duplicate_cte as 
(
select *,
row_number () over(
partition by company,location, industry, total_laid_off,percentage_laid_off, 'date',stage, country, funds_raised_millions) as row_num
from layoffs)

select *
from duplicate_cte
where row_num> 1
;

select * 
from layoffs
where company = 'casper'
;

CREATE TABLE `layoffs_staging2` (
  `company` varchar(100) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `industry` varchar(100) DEFAULT NULL,
  `total_laid_off` bigint unsigned DEFAULT NULL,
  `percentage_laid_off` decimal(5,2) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `stage` varchar(50) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `funds_raised_millions` decimal(12,2) DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs_staging2
;

Insert into layoffs_staging2
select *,
row_number () over(
partition by company,location, industry, total_laid_off,percentage_laid_off, 'date',stage, country, funds_raised_millions) as row_num
from layoffs
;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM layoffs_staging2 WHERE row_num > 1;

SET SQL_SAFE_UPDATES = 1;


select *
from layoffs_staging2
where row_num >1
;
SET SQL_SAFE_UPDATES = 0;

select company, trim(company)
from layoffs_staging2
;

update layoffs_staging2
set company = trim(company)
;

select * 
from layoffs_staging2
;
select *
from layoffs_staging2
where industry like 'crypto%'
;

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%'
;

select distinct(country)
from layoffs_staging2
order by 1
;

update layoffs_staging2
set country = 'United States'
where country = 'United States.'
;

select distinct(country)
from layoffs_staging2
order by 1
;

select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company= t2.company
where (t1.industry is null)
and t2.industry is not null
;

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company= t2.company
set t1.industry= t2.industry
where (t1.industry is null)
and t2.industry is not null
;

select *
from layoffs_staging2
where company like 'bally%'
;

delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null
;

select *
from layoffs_staging2
where total_laid_off is null
or percentage_laid_off is null
;

alter table layoffs_staging2
drop column row_num
;

select *
from layoffs_staging2
;