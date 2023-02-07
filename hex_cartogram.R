library(geogrid)
library(sf)
library(tmap)
library(tidyr)
library(dplyr)
library(cartogram)

#resources
#https://cran.r-project.org/web/packages/geogrid/readme/README.html
#https://bookdown.org/nicohahn/making_maps_with_r5/docs/tmap.html

# load shapefile & projection
original_shapes <- st_read("./Coucils/pub_las.shp") %>% st_set_crs(27700)

# load and merge csv
data <- read.csv("domestic_abuse.csv", header = TRUE, sep = ",")
data_merge <- merge(original_shapes, data, by.x = "local_auth", by.y="Reference.Area")

#drop NA
data_merge <- data_merge %>% drop_na("Ratio")
#add short names column
data_merge$SNAME <- substr(data_merge$local_auth, 1, 6)

#simple plot
rawplot <- tm_shape(data_merge) + 
  tm_polygons("Count", title="Domestic Abuse", n = 4, palette = "viridis")
rawplot
#plot(rawplot)


### cartogram ###
# construct a cartogram using the population in 2005
cartogram <- cartogram_cont(data_merge, "Count", itermax=5)
tm_shape(cartogram) + tm_polygons("Count", style = "pretty", title="Domestic Abuse", n = 4, palette = "viridis")

# This is a new geospatial object, we can visualise it!
plot(cartogram)

### hex bin###
# create hex map shape
new_cells <- calculate_grid(shape = data_merge, grid_type = 'hexagonal', seed = 1)
grid_shapes <- assign_polygons(data_merge, new_cells)
#plot(grid_shapes)

#create hex map with data
hexplot <- tm_shape(grid_shapes) + 
  tm_polygons("Count", title="Domestic Abuse", palette = "viridis") + tm_text("SNAME", size=0.6)
hexplot
#plot(hexplot)

par(mfrow = c(1, 2))
plot(rawplot)
plot(hexplot)
