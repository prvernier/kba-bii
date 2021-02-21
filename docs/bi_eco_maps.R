library(tidyverse)

sink('bi_eco_maps.Rmd')

cat('
---
title: "Biotic Intactness by Ecoregion"
Author: "P Vernier"
date: February 15, 2021
output:  
  html_document:  
    code_folding: hide
    toc: true
    toc_float:
      toc_collapsed: true
    css: report/styles.css
---

```{r echo=FALSE, message=FALSE, warning=FALSE}
library(sf)
library(tmap)
library(raster)
library(tidyverse)
library(fasterize)
ecoregions <- st_read("data/vector/ecoregions37.gpkg", quiet=T)
ecoNames <- ecoregions %>% pull(ECO_NAME) %>% unique()
ecoIDs <- ecoregions %>% pull(ECO_ID) %>% unique()
canada <- st_read("data/vector/canada.gpkg", quiet=T)
eco_slivers = c(51103,51104,51108,51114,51118)
eco_grasslands = c(50810,50811,50808,50812,50813)
hb12 = st_read("data/vector/hbasins12_covars.gpkg", quiet=T) %>%
    filter(!eco_id %in% c(eco_grasslands, eco_slivers)) %>% # remove sliver & grassland ecoregions
    filter(!is.na(eco_id)) # remove catchments that do not have an ecoregion label
load("output/latest/bi.RData")
```\n')

cat(paste0('\n<br>\n\n# Forest-associated Species\n\n<br>\n'))

for (i in 1:length(ecoIDs)) {
cat(paste0('\n---\n\n## ', ecoNames[i]),'\n')
cat('
```{r echo=FALSE, message=FALSE, warning=FALSE, fig.width=12, fig.height=9}
eco <- filter(hb12, eco_id==ecoIDs[',i,'])
bi <- left_join(eco, BI)
bi1 = fasterize(sf=bi, raster=raster(bi, res=1000), field="BIoption1")
bi2 = fasterize(sf=bi, raster=raster(bi, res=1000), field="BIoption2")
bi3 = fasterize(sf=bi, raster=raster(bi, res=1000), field="BIoption3")
bi4 = fasterize(sf=bi, raster=raster(bi, res=1000), field="BIoption4")
tm1 <- tm_shape(bi1) + tm_raster(palette="YlGn", style="quantile", title = "BI1") + 
	tm_shape(ecoregions) + tm_borders(col="blue") +
    #tm_shape(canada) + tm_borders() +
	tm_legend(position = c("right", "top"), frame = TRUE)

tm2 <- tm_shape(bi2) + tm_raster(palette="YlGn", style="quantile", title = "BI2") + 
	tm_shape(ecoregions) + tm_borders(col="blue") +
    #tm_shape(canada) + tm_borders() +
	tm_legend(position = c("right", "top"), frame = TRUE)

tm3 <- tm_shape(bi3) + tm_raster(palette="YlGn", style="quantile", title = "BI3") + 
	tm_shape(ecoregions) + tm_borders(col="blue") +
    #tm_shape(canada) + tm_borders() +
	tm_legend(position = c("right", "top"), frame = TRUE)

tm4 <- tm_shape(bi4) + tm_raster(palette="YlGn", style="quantile", title = "BI4") + 
	tm_shape(ecoregions) + tm_borders(col="blue") +
    #tm_shape(canada) + tm_borders() +
	tm_legend(position = c("right", "top"), frame = TRUE)

print(tmap_arrange(tm1, tm2, tm3, tm4))

```\n', sep="")
}

sink()

rmarkdown::render('bi_eco_maps.Rmd', output_dir='report')

file.remove('bi_eco_maps.Rmd')
