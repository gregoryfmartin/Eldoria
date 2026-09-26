"""
Main CLI entrypoint for Eldoria.
"""

import argparse
import sys
from .core.engine import EldoriaCore


def main() -> None:
    parser = argparse.ArgumentParser(description="Eldoria Python Virtual Terminal Game Engine")
    parser.add_argument(
        "--screen",
        choices=["splash", "title", "party", "builder", "map", "combat", "ui", "soda"],
        default="splash",
        help="Initial screen to boot into (default: splash for production boot flow)",
    )
    parser.add_argument(
        "--map-width",
        type=int,
        default=54,
        help="Width of the procedural noise map and UI frames (default: 54)",
    )
    parser.add_argument(
        "--map-height",
        type=int,
        default=24,
        help="Height of the procedural noise map and UI frames (default: 24)",
    )
    args = parser.parse_args()

    screen_map = {
        "splash": "GSSplashScreen",
        "title": "GSTitleScreen",
        "party": "GSPartyBuilderScreen",
        "builder": "GSCharacterBuilderScreen",
        "map": "GSNoiseMapTestScreen",
        "combat": "GSNvNCombatScreen",
        "ui": "GSUiTestScreen",
        "soda": "GSAnimatedSodaCanTestScreen",
    }
    initial_state = screen_map.get(args.screen, "GSSplashScreen")

    engine = EldoriaCore(
        initial_state=initial_state,
        map_width=args.map_width,
        map_height=args.map_height,
    )
    try:
        engine.run()
    except KeyboardInterrupt:
        pass
    finally:
        engine.cleanup()


if __name__ == "__main__":
    main()
