"""
Comprehensive test suite for FastNoiseLite procedural noise engine.
Validates all noise types, 2D/3D evaluation, fractals, cellular distance/return types,
domain warping, output bounds [-1.0, 1.0], and deterministic repeatability.
"""

import math
import unittest
from eldoria_py.procgen.noise import (
    FastNoiseLite,
    FnlNoiseType,
    FnlFractalType,
    FnlCellularDistanceFunction,
    FnlCellularReturnType,
    FnlDomainWarpType,
)


class TestFastNoiseLite(unittest.TestCase):
    def setUp(self):
        self.fnl = FastNoiseLite(seed=1337)
        self.fnl.set_frequency(0.05)

    def test_determinism(self):
        """Noise generation must produce identical results given the same seed and coordinates."""
        fnl1 = FastNoiseLite(seed=42)
        fnl2 = FastNoiseLite(seed=42)
        fnl1.set_noise_type(FnlNoiseType.OpenSimplex2)
        fnl2.set_noise_type(FnlNoiseType.OpenSimplex2)

        for x in range(-5, 6):
            for y in range(-5, 6):
                val1 = fnl1.get_noise(x * 1.5, y * 1.5)
                val2 = fnl2.get_noise(x * 1.5, y * 1.5)
                self.assertEqual(val1, val2, f"Determinism mismatch at ({x}, {y})")

    def test_different_seeds_produce_different_values(self):
        fnl1 = FastNoiseLite(seed=100)
        fnl2 = FastNoiseLite(seed=200)

        differences = 0
        for x in range(10):
            if fnl1.get_noise(x * 2.0, 5.0) != fnl2.get_noise(x * 2.0, 5.0):
                differences += 1
        self.assertGreater(differences, 7)

    def test_all_noise_types_2d_and_3d(self):
        """All 6 noise types must evaluate in 2D and 3D within [-1.05, 1.05]."""
        noise_types = [
            FnlNoiseType.OpenSimplex2,
            FnlNoiseType.OpenSimplex2S,
            FnlNoiseType.Cellular,
            FnlNoiseType.Perlin,
            FnlNoiseType.ValueCubic,
            FnlNoiseType.Value,
        ]

        for nt in noise_types:
            self.fnl.set_noise_type(nt)
            for x in range(-3, 4):
                for y in range(-3, 4):
                    val_2d = self.fnl.get_noise(x * 3.7, y * 3.7)
                    self.assertFalse(math.isnan(val_2d), f"NaN in 2D for {nt.name}")
                    self.assertGreaterEqual(val_2d, -1.05, f"Underflow in 2D for {nt.name}: {val_2d}")
                    self.assertLessEqual(val_2d, 1.05, f"Overflow in 2D for {nt.name}: {val_2d}")

                    val_3d = self.fnl.get_noise(x * 2.1, y * 2.1, 1.5)
                    self.assertFalse(math.isnan(val_3d), f"NaN in 3D for {nt.name}")
                    self.assertGreaterEqual(val_3d, -1.05, f"Underflow in 3D for {nt.name}: {val_3d}")
                    self.assertLessEqual(val_3d, 1.05, f"Overflow in 3D for {nt.name}: {val_3d}")

    def test_fractal_modes(self):
        """Validates FBm, Ridged, and PingPong fractal modes."""
        fractals = [FnlFractalType.FBm, FnlFractalType.Ridged, FnlFractalType.PingPong]
        self.fnl.set_noise_type(FnlNoiseType.Perlin)
        self.fnl.set_fractal_octaves(4)
        self.fnl.set_fractal_gain(0.5)
        self.fnl.set_fractal_lacunarity(2.0)

        for frac in fractals:
            self.fnl.set_fractal_type(frac)
            for x in range(5):
                val_2d = self.fnl.get_noise(x * 5.0, 10.0)
                self.assertFalse(math.isnan(val_2d), f"NaN in fractal {frac.name}")
                self.assertGreaterEqual(val_2d, -1.1)
                self.assertLessEqual(val_2d, 1.1)

                val_3d = self.fnl.get_noise(x * 5.0, 10.0, 5.0)
                self.assertFalse(math.isnan(val_3d), f"NaN in 3D fractal {frac.name}")
                self.assertGreaterEqual(val_3d, -1.1)
                self.assertLessEqual(val_3d, 1.1)

    def test_cellular_distance_functions_and_return_types(self):
        """Validates all cellular distance functions and return types."""
        self.fnl.set_noise_type(FnlNoiseType.Cellular)
        dist_funcs = [
            FnlCellularDistanceFunction.Euclidean,
            FnlCellularDistanceFunction.EuclideanSq,
            FnlCellularDistanceFunction.Manhattan,
            FnlCellularDistanceFunction.Hybrid,
        ]
        ret_types = [
            FnlCellularReturnType.CellValue,
            FnlCellularReturnType.Distance,
            FnlCellularReturnType.Distance2,
            FnlCellularReturnType.Distance2Add,
            FnlCellularReturnType.Distance2Sub,
            FnlCellularReturnType.Distance2Mul,
            FnlCellularReturnType.Distance2Div,
        ]

        for df in dist_funcs:
            self.fnl.set_cellular_distance_function(df)
            for rt in ret_types:
                self.fnl.set_cellular_return_type(rt)
                for x in range(3):
                    val = self.fnl.get_noise(x * 4.0, 7.0)
                    self.assertFalse(math.isnan(val), f"NaN in Cellular {df.name} / {rt.name}")

    def test_domain_warp_2d_and_3d(self):
        """Validates domain warping coordinate transforms."""
        warp_types = [
            FnlDomainWarpType.OpenSimplex2,
            FnlDomainWarpType.OpenSimplex2Reduced,
            FnlDomainWarpType.BasicGrid,
        ]
        self.fnl.set_domain_warp_amp(20.0)

        for wt in warp_types:
            self.fnl.set_domain_warp_type(wt)
            wx, wy = self.fnl.domain_warp_2d(10.0, 20.0)
            self.assertFalse(math.isnan(wx))
            self.assertFalse(math.isnan(wy))
            self.assertNotEqual((wx, wy), (10.0, 20.0), f"Warp did not modify 2D coords for {wt.name}")

            wx3, wy3, wz3 = self.fnl.domain_warp_3d(10.0, 20.0, 30.0)
            self.assertFalse(math.isnan(wx3))
            self.assertFalse(math.isnan(wy3))
            self.assertFalse(math.isnan(wz3))
            self.assertNotEqual((wx3, wy3, wz3), (10.0, 20.0, 30.0), f"Warp did not modify 3D coords for {wt.name}")


if __name__ == "__main__":
    unittest.main()
