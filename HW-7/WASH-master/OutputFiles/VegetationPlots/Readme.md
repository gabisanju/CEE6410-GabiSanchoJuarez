This folder contains the R script to generate vegetation plots for Figures 6 and 10 in the manuscript. It also contains screen captures of the output.

## Folder Contents
1. PlotWASHvegetation.r : R script to plot Figures 6 and 10 in the mansucript from the GAMS gdx results
2. *.png : screen captures of the figures generated by the R script
3. *.pdf : screen captures pof the figures generated by the R script in pdf format
4. NodeNames.csv : list of names for WASH model schematic nodes to help in labeling reaches in plots

## To reproduce results
1. Open the PlotWASHVegetation.R script
2. If needed, edit line 89 of the script to point the R code to the location of the GDX file for the WASH results (WASH_1yr_OutputData.gdx in the folder OutputFiles)
3. Run the script to generate the figures
