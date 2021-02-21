library(tidyverse)
forestSpecies = read_csv("input/species.csv") %>% pull(Code)
speciesNames = read_csv("input/species.csv") %>% pull(Common_name)

sink('si_maps.Rmd')

cat('
---
title: "Species Intactness"
Author: "P Vernier"
date: January 19, 2021
output:  
  html_document:  
    code_folding: hide
    toc: true
    toc_float:
      toc_collapsed: true
    css: input/styles.css
---

```{r echo=FALSE, message=FALSE, warning=FALSE}
library(sf)
library(tmap)
library(raster)
library(tidyverse)
library(fasterize)
forestSpecies = read_csv("input/species.csv") %>% pull(Code)
speciesNames = read_csv("input/species.csv") %>% pull(Common_name)
ecoregions <- st_read("data/vector/ecoregions37.gpkg", quiet=T)
canada <- st_read("data/vector/canada.gpkg", quiet=T)
hb12 = st_read("data/vector/hbasins12.gpkg", quiet=T)
```\n')

cat(paste0('\n<br>\n\n# Forest-associated Species\n\n<br>\n'))

for (i in 1:length(forestSpecies)) {
cat(paste0('\n---\n\n## ', speciesNames[i]),'\n')
cat('
```{r echo=FALSE, message=FALSE, warning=FALSE, fig.width=12, fig.height=9}
load(paste0("output/latest/si-",forestSpecies[',i,'],".RData"))
si <- right_join(hb12, out)
si1 = fasterize(sf=si, raster=raster(si, res=1000), field="SIoption1")
si2 = fasterize(sf=si, raster=raster(si, res=1000), field="SIoption2")
si3 = fasterize(sf=si, raster=raster(si, res=1000), field="SIoption3")
si4 = fasterize(sf=si, raster=raster(si, res=1000), field="SIoption4")
tm1 <- tm_shape(ecoregions) + tm_borders() +
	tm_shape(si1) + tm_raster(palette="YlGn", style="quantile", title = paste0(forestSpecies[',i,'], " - SI1")) + 
	tm_shape(ecoregions) + tm_borders(col="blue") +
    tm_shape(canada) + tm_borders() +
	tm_legend(position = c("right", "top"), frame = TRUE)

tm2 <- tm_shape(ecoregions) + tm_borders() +
	tm_shape(si2) + tm_raster(palette="YlGn", style="quantile", title = paste0(forestSpecies[',i,'], " - SI2")) + 
	tm_shape(ecoregions) + tm_borders(col="blue") +
    tm_shape(canada) + tm_borders() +
	tm_legend(position = c("right", "top"), frame = TRUE)

tm3 <- tm_shape(ecoregions) + tm_borders() +
	tm_shape(si3) + tm_raster(palette="YlGn", style="quantile", title = paste0(forestSpecies[',i,'], " - SI3")) + 
	tm_shape(ecoregions) + tm_borders(col="blue") +
    tm_shape(canada) + tm_borders() +
	tm_legend(position = c("right", "top"), frame = TRUE)

tm4 <- tm_shape(ecoregions) + tm_borders() +
	tm_shape(si4) + tm_raster(palette="YlGn", style="quantile", title = paste0(forestSpecies[',i,'], " - SI4")) + 
	tm_shape(ecoregions) + tm_borders(col="blue") +
    tm_shape(canada) + tm_borders() +
	tm_legend(position = c("right", "top"), frame = TRUE)


print(tmap_arrange(tm1, tm2, tm3, tm4))

```\n', sep="")
}

sink()


rmarkdown::render('si.Rmd')

file.remove('si.Rmd')
