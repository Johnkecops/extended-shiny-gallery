points_from_polygons <- read.csv("data/points_from_polygons.csv")[c("Code", "lng", "lat")]

read_map_data <- function(path) {
  data <- read.csv(path, check.names = FALSE)
  merge(data[setdiff(names(data), c("lng", "lat"))], points_from_polygons, by = "Code")
}

polygon_data <- sf::st_read("data/countries.geojson", quiet = TRUE)
map_data_world_bank <- read_map_data("data/map_data_world_bank.csv")
map_data_oecd <- read_map_data("data/map_data_oecd.csv")

plot_data_world_bank <- read.csv("data/plot_data_world_bank.csv", check.names = FALSE)
plot_data_oecd <- read.csv("data/plot_data_oecd.csv", check.names = FALSE)
