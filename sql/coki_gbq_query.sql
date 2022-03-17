WITH CR_TRUTHTABLE AS (

SELECT
UPPER(TRIM(doi)) as doi,
type,
IF(ARRAY_LENGTH(issued.date_parts) > 0, issued.date_parts[offset(0)], null) as published_year,
member,
CASE
WHEN (SELECT COUNT(1) FROM UNNEST(funder) AS funders WHERE funders.name is not null) > 0 THEN TRUE
ELSE FALSE
END
as has_funder_name,
CASE
WHEN (SELECT COUNT(1) FROM UNNEST(funder) AS funders WHERE funders.DOI is not null) > 0 THEN TRUE
ELSE FALSE
END
as has_funder_fundref,
CASE
WHEN (SELECT COUNT(1) FROM UNNEST(funder) AS funders WHERE funders.doi_asserted_by = 'publisher') > 0 THEN TRUE
ELSE FALSE
END
as has_funder_asserted_publisher,
CASE
WHEN (SELECT COUNT(1) FROM UNNEST(funder) AS funders WHERE funders.doi_asserted_by = 'crossref') > 0 THEN TRUE
ELSE FALSE
END
as has_funder_asserted_crossref,

FROM `academic-observatory.crossref.crossref_metadata20220207`
)

SELECT

member,
COUNT(DISTINCT doi) as dois

, COUNT(DISTINCT IF(has_funder_name, doi, null)) as has_funder_name
, COUNT(DISTINCT IF(has_funder_fundref, doi, null)) as has_funder_fundref
, COUNT(DISTINCT IF(has_funder_asserted_publisher, doi, null)) as has_funder_asserted_publisher
, COUNT(DISTINCT IF(has_funder_asserted_crossref, doi, null)) as has_funder_asserted_crossref

, ROUND((COUNT(DISTINCT IF(has_funder_name, doi, null))/COUNT(DISTINCT doi))*100, 1) as pc_has_funder_name
, ROUND((COUNT(DISTINCT IF(has_funder_fundref, doi, null))/COUNT(DISTINCT doi))*100, 1) as pc_has_funder_fundref
, ROUND((COUNT(DISTINCT IF(has_funder_asserted_publisher, doi, null))/COUNT(DISTINCT doi))*100, 1) as pc_has_funder_asserted_publisher
, ROUND((COUNT(DISTINCT IF(has_funder_asserted_crossref, doi, null))/COUNT(DISTINCT doi))*100, 1) as pc_has_funder_asserted_crossref

FROM CR_TRUTHTABLE
WHERE published_year in (2020, 2021, 2022)
AND type = 'journal-article'

GROUP BY member
ORDER BY dois DESC