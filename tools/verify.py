"""Run package checks and both native sample suites; no third-party modules."""
import argparse
from pathlib import Path
import re
import subprocess
import sys

from validate_skills import ROOT, validate


def run(command: list[str], name: str, reports: Path) -> None:
    result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True,
                            encoding="utf-8", errors="replace", timeout=60)
    output = result.stdout + result.stderr
    (reports / f"{name}.log").write_text(output, encoding="utf-8")
    if result.returncode or re.search(r"(?m)^(?:SCRIPT ERROR:|ERROR:)|Parse Error:", output):
        print(output)
        raise RuntimeError(f"{name} failed (exit {result.returncode})")
    summary = [line for line in output.splitlines() if "verification:" in line]
    print(f"PASS {name}" + (": " + "; ".join(summary) if summary else ""))


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--godot", required=True, help="Godot 4.6 executable")
    parser.add_argument("--capture", action="store_true", help="Also render viewport captures (needs a display)")
    args = parser.parse_args()
    reports = ROOT / "reports"
    reports.mkdir(exist_ok=True)
    issues = validate()
    if issues:
        raise RuntimeError("\n".join(issues))
    print("PASS skill packaging and native-only instructions")
    run([args.godot, "--version"], "engine-version", reports)
    for skill, lab in [("godot-animate", "motion-lab"), ("godot-prototype", "prototype-lab")]:
        project = ROOT / "skills" / skill / "assets" / lab
        base = [args.godot, "--path", str(project)]
        run(base + ["--headless", "--editor", "--import"], f"{lab}-import", reports)
        run(base + ["--headless", "--script", "res://verify.gd"], f"{lab}-tests", reports)
        # Also load the actual entry scene, not just the independently tested helpers.
        run(base + ["--headless", "--quit-after", "5"], f"{lab}-entry", reports)
        if args.capture:
            run(base + ["--script", str(ROOT / "tools" / "capture_lab.gd"),
                        "--", str(reports / lab)], f"{lab}-render", reports)


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    try:
        main()
    except (RuntimeError, subprocess.TimeoutExpired, OSError) as error:
        print(f"FAIL: {error}")
        raise SystemExit(1)
