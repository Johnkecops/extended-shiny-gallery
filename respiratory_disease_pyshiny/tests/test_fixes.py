"""Regression check for data loading and circle sizing.

Run from any directory: python tests/test_fixes.py
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent))

from data import polygon_data, map_data_oecd, map_data_world_bank
from utils.map_utils import determine_circle_radius

# data loads independent of cwd, coordinates parsed into lists without eval
assert isinstance(polygon_data["coordinates"].iloc[0], list)
assert len(map_data_world_bank) and len(map_data_oecd)

# radius never shrinks as death rate grows
radii = [determine_circle_radius(x) for x in range(0, 300)]
assert all(a <= b for a, b in zip(radii, radii[1:])), radii

print("ok")
