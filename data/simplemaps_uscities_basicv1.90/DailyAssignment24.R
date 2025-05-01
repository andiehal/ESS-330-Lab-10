# spatial data science
library(tidyverse)
library(sf)
library(units)

# Data
library(AOI)

# Visualization
library(gghighlight)
library(ggrepel)
library(knitr)

colorado_boundary <- st_as_sf(uscities, coords = c("lng", "lat"), crs = 4326)

larimer_boundary <- aoi_get(state = "CO", county = "Larimer")

larimer_cities <- st_filter(colorado_boundary, larimer_boundary)

top_3_cities <- larimer_cities |>
  arrange(-population) |>
  slice(1:3)

map_plot <- ggplot() +
  geom_sf(data = larimer_boundary, fill = "white", color = "black") +
  geom_sf(data = larimer_cities, color = "blue", size = 2) +
  geom_sf(data = top_3_cities, color = "red", size = 4) +
  ggrepel::geom_label_repel(
    data = top_3_cities,
    aes(label = city, geometry = geometry),
    stat = "sf_coordinates",
    size = 3,
    inherit.aes = FALSE
  ) +
  theme_minimal() +
  labs(title = "Cities in Larimer County, Colorado",
       subtitle = "Top 3 most populous cities highlighted",
       caption = "Data source: uscities & AOI package")

ggsave("larimer_cities_map.png", plot = map_plot, width = 8, height = 6, dpi = 300)
