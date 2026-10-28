import json
from pathlib import Path
from pandas import read_csv

data_dir = Path(__file__).parent

polygon_data = read_csv(data_dir / "countries.csv")
polygon_data["coordinates"] = polygon_data["coordinates"].apply(json.loads)
points_from_polygons = read_csv(data_dir / "points_from_polygons.csv")

map_data_world_bank = (
    read_csv(data_dir / "map_data_world_bank.csv")
    .drop(["lng", "lat"], axis=1)
    .merge(points_from_polygons, on="Code")
)
map_data_oecd = (
    read_csv(data_dir / "map_data_oecd.csv")
    .drop(["lng", "lat"], axis=1)
    .merge(points_from_polygons, on="Code")
)

plot_data_world_bank = read_csv(data_dir / "plot_data_world_bank.csv")
plot_data_oecd = read_csv(data_dir / "plot_data_oecd.csv")
