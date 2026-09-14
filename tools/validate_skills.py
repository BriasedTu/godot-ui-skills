"""Validate the Godot adaptation using Python's standard library only."""
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
EXPECTED = {
    "godot-design-engineering", "godot-animate", "godot-animate-mobile",
    "godot-review-animations", "godot-improve-animations",
    "godot-find-animation-opportunities", "godot-animation-vocabulary",
    "godot-fluid-interface-design", "godot-write-gdscript",
    "godot-pick-ui-component", "godot-prototype", "godot-notifications",
}
LEGACY = re.compile(
    r"\b(?:CSS|HTML|DOM|React|ReactNative|Reanimated|Expo|Swift|SwiftUI|"
    r"WAAPI|Tailwind|JavaScript|TypeScript|JSX|TSX|Sonner|Framer|"
    r"browser|frontend|DevTools|npm|npx|requestAnimationFrame|"
    r"useReducedMotion|prefers-reduced-motion)\b", re.I
)


def validate(root: Path = ROOT) -> list[str]:
    errors = []
    folders = {p.name for p in (root / "skills").iterdir() if p.is_dir()}
    if folders != EXPECTED:
        errors.append(f"Skill inventory mismatch: missing={sorted(EXPECTED-folders)}, extra={sorted(folders-EXPECTED)}")
    for folder in sorted((root / "skills").iterdir()):
        if not folder.is_dir():
            continue
        entry = folder / "SKILL.md"
        if not entry.is_file():
            errors.append(f"Missing entry: {entry.relative_to(root)}")
            continue
        text = entry.read_text(encoding="utf-8")
        header = re.match(r"\A---\n(.*?)\n---\n", text, re.S)
        if not header:
            errors.append(f"Invalid frontmatter: {entry.relative_to(root)}")
        else:
            fields = dict(re.findall(r"^(name|description):\s*(.+)$", header[1], re.M))
            if fields.get("name") != folder.name or not fields.get("description"):
                errors.append(f"Invalid name/description: {entry.relative_to(root)}")
        for path in folder.rglob("*"):
            if not path.is_file() or ".godot" in path.parts:
                continue
            if path.suffix not in {".md", ".gd", ".godot", ".tscn", ".tres", ".yaml", ".gdshader"}:
                continue
            body = path.read_text(encoding="utf-8")
            for number, line in enumerate(body.splitlines(), 1):
                instruction = re.sub(r"https?://[^\s)]+", "", line)
                if LEGACY.search(instruction):
                    errors.append(f"Non-native instruction: {path.relative_to(root)}:{number}: {line[:120]}")
            if path.suffix == ".md":
                for target in re.findall(r"\[[^\]]*\]\(([^\s)]+)\)", body):
                    if target.startswith(("https://", "http://", "#")):
                        continue
                    destination = (path.parent / target.split("#", 1)[0]).resolve()
                    if not destination.is_relative_to(folder.resolve()) or not destination.exists():
                        errors.append(f"Unbundled link: {path.relative_to(root)} -> {target}")
    return errors


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    issues = validate(Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else ROOT)
    for issue in issues:
        print(issue)
    print(f"{'FAIL' if issues else 'PASS'}: {len(issues)} issues; {len(EXPECTED)} expected Godot skills")
    raise SystemExit(bool(issues))
