library(geogrid)
library(sf)
library(tmap)

#resources
#https://cran.r-project.org/web/packages/geogrid/readme/README.html

original_shapes <- st_read("Census_pop.shp") %>% st_set_crs(27700)
original_shapes$SNAME <- substr(original_shapes$NAME, 1, 6)
original_shapes$Pop_x = as.integer(original_shapes$Pop_x)

#simple plot
rawplot <- tm_shape(original_shapes) + 
  tm_polygons("Pop_x", title="Population", palette = "viridis")
rawplot
plot(rawplot)

#hexagonal shapes
par(mfrow = c(2, 3), mar = c(0, 0, 2, 0))
for (i in 1:6) {
  new_cells <- calculate_grid(shape = original_shapes, grid_type = "hexagonal", seed = i)
  plot(new_cells, main = paste("Seed", i, sep = " "))
}

#regular grid
par(mfrow = c(2, 3), mar = c(0, 0, 2, 0))
for (i in 1:6) {
  new_cells <- calculate_grid(shape = original_shapes, grid_type = "regular", seed = i)
  plot(new_cells, main = paste("Seed", i, sep = " "))
}

# hexseed 6
new_cells_hex6 <- calculate_grid(shape = original_shapes, grid_type = "hexagonal", seed = 6)
resulthex <- assign_polygons(original_shapes, new_cells_hex6)

# hexseed 5
new_cells_hex5 <- calculate_grid(shape = original_shapes, grid_type = "hexagonal", seed = 5)
resulthex2 <- assign_polygons(original_shapes, new_cells_hex5)

# regseed
new_cells_reg <- calculate_grid(shape = original_shapes, grid_type = "regular", seed = 3)
resultreg <- assign_polygons(original_shapes, new_cells_reg)

#plot hex6
hexplot <- tm_shape(resulthex) + 
  tm_polygons("Pop_x", title="Population", palette = "viridis")+
  tm_text("SNAME", size=0.6)
hexplot
plot(hexplot)

#plot hex5
hexplot2 <- tm_shape(resulthex2) + 
  tm_polygons("Pop_x", title="Population", palette = "viridis")+
  tm_text("SNAME", size=0.6)
hexplot2
plot(hexplot2)

regplot <- tm_shape(resultreg) + 
  tm_polygons("Pop_x", palette = "viridis") +
  tm_text("Population")

tmap_arrange(rawplot, hexplot, ncol = 2)
