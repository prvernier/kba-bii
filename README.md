February 21, 2021

The KBA Project directory contains the following files and folders:


DATA FOLDER
-----------

The data folder contains all input data required to develop the biotic intactness index for individual species (SI index) and groups of species (BI index). Note that some of the raw data needed to run the gendata1.R script are not available in the shared folder due to space limitations.
  - the "density" folder contains the predicted species density rasters in geotif format
  - the "raster300" folder contains 300m rasters
  - the "raster1000" folder contains 1000m rasters
  - the "vector" folder contains vector datasets in open source geopackage format

OUTPUT FOLDER
-------------

The output folder contain the latest output files containing parameters needed to generate SI and BI maps. The app.R file can be run [ shiny::runApp('output/app.R') ] view some of the maps in a shiny app.

REPORT FOLDER
-------------

The report folder contains various rmarkdown (and html) files describing the methods used to develop the SI and BI indices.


SCRIPTS FOLDER
--------------

Scripts to prepare data
  - gendata1.R
  - gendata2.R
  - gendata3.R

Scripts to develop models & calculate SI/BI
  - sppRasters.R
  - sumRasters.R
  - testmod1.R
  - testmod2.R
  - testmod3.R


SLIDES FOLDER
-------------

The slides folder contains the slide deck presented to the KBA working group on January 21, 2021. The folder also contains several image files, some of which were inserted in the slide deck.
