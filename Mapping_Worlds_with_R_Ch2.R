
#---Script: Chapter 2_explore_sf.R---

#Step 1: Load necessary packages 
#We need sf for spatial observations, rnaturalearth for data, and tidyverse for data viewing/manipulation

print("Loading packages . . ")
pacman::p_load(sf, rnaturalearth, tidyverse)
print("Packages ready")

#Step 2: get world countries data as an sf object
#This is vector data (polygons)
print("Getting world countries sf object . . .")
world_countries <- rnaturalearth::ne_countries(scale = 'medium', returnclass = 'sf')
print("Data loaded into world_countries")
    
#Step 3: Get world cities data as an sf object
#This is vector data (points)

print("Getting world cities sf object . . .")
world_cities <- rnaturalearth::ne_download(
  scale = 'medium',
  type = 'populated_places',
  category = 'cultural',
  returnclass = 'sf'
)

print("Data loaded into 'world_cities'")

#Now to inspect the sf Object Structure

#Step 4: Print the whole object - see the table and geometry 
print("---Full sf object (first few rows)---")
print(world_countries)

#Step 5: Check the class - What kind of object is it? 
print("---Object Class---")
print(class(world_countries))

#Step 6: Use glimpse() for a compact summary of attributes
print("---Attribute Summary (glimpse)---")
#glimpse is from dplyr, great for seeing column names and types
dplyr::glimpse(world_countries)

#Step 7: Look at the JUST attribute table (like a regular data frame)
print("---Attribute Table Only (st_drop_geometry)---")
#sf::drop_geometry() removes the special geometry column
world_attributes_only <- sf::st_drop_geometry(world_countries)
print(head(world_attributes_only)) #Shows the first few rows of the plain table
print(class(world_attributes_only)) #Should now just be "data frame"

#Step 8: Look at JUST the geometry column
print("---Geometry column Only (st_geometry)---")
#sf::geometry() extracts only the geometry list-column
world_geometry_only <- sf::st_geometry(world_countries)
print(world_geometry_only[1:3])#Show geometry for the first 3 countries

#Step 9: Check the CRS again!
print("---Coordinate Reference System (st_crs) ---")
print(sf::st_crs(world_countries)) #confirm it's likely EPSG 4326 (WGS84 Lat/Lon)

#Step 10: Transform world_countries to Robinson projection again 
print("Transforming countries to Robinson...")
target_crs_robinson <- "ESRI:54030" # Robinson code
world_countries_robinson <- world_countries |>
  sf::st_transform(crs = target_crs_robinson)
print("Transformation complete.")

#Step 11: Check the NEW CRS
print("---CRS of Transformed Data---")
print(sf::st_crs(world_countries_robinson))

#Plot comparison (using ggplot2 this time)
print("Plotting comparison with ggplot2 . . ")
pacman::p_load(tidyverse) #make sure ggplot2 is loaded

plot_original <- ggplot() +
  geom_sf(
    data = world_countries, linewidth = .2
  ) + ggtitle("Original (EPSG: 4326)") + 
  theme_minimal()

plot_transformed <- ggplot() + 
  geom_sf(
    data = world_countries_robinson, linewidth = 0.2
  ) + 
  ggtitle("Transformed (Robinson)") + 
  theme_minimal()

#Arrange side by side (requires 'patchwork' package)
pacman::p_load(patchwork)
print(plot_original/plot_transformed)
print("Comparison Plot Displayed")
