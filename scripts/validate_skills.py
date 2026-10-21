#!/usr/bin/env python3
"""Validate the Flutter AI Skills catalog and its local documentation links.

Install the development dependency with ``python -m pip install -r requirements-dev.txt``.
The format checks complement, rather than replace, the Agent Skills reference
validator and behavioral activation tests.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path
from urllib.parse import unquote, urlsplit

import yaml


EXPECTED_SKILLS = (
    "flutter-project-setup",
    "flutter-clean-architecture",
    "flutter-state-management",
    "flutter-design-system",
    "flutter-responsive-layout",
    "flutter-localization",
    "flutter-accessibility-audit",
    "flutter-adaptive-fonts",
    "flutter-high-contrast",
    "flutter-screen-reader",
    "flutter-accessible-forms",
    "flutter-error-feedback",
    "flutter-confirmation-undo",
    "flutter-form-validation",
    "flutter-domain-rules",
    "flutter-numeric-precision",
    "flutter-rest-api",
    "flutter-jwt-authentication",
    "flutter-local-persistence",
    "flutter-data-sync",
    "flutter-sync-conflicts",
    "flutter-offline-resilience",
    "flutter-data-visualization",
    "flutter-pdf-reporting",
    "flutter-push-notifications",
    "flutter-testing",
    "flutter-performance",
    "flutter-debugging",
    "flutter-security-review",
    "flutter-android-release",
    "flutter-ci-cd",
    "flutter-code-review",
    "flutter-documentation",
)

REQUIRED_FILES = (
    "README.md",
    "README.en.md",
    "LICENSE",
    "CONTRIBUTING.md",
    "CODE_OF_CONDUCT.md",
    "SECURITY.md",
    "CHANGELOG.md",
    "AGENTS.md",
    ".gitignore",
    ".github/workflows/validate-skills.yml",
    ".github/ISSUE_TEMPLATE/bug_report.md",
    ".github/ISSUE_TEMPLATE/skill_request.md",
    "docs/installation.md",
    "docs/getting-started.md",
    "docs/skill-development.md",
    "docs/compatibility.md",
    "docs/nativa-inspiration.md",
    "requirements-dev.txt",
    "scripts/validate_skills.py",
    "tests/test_skill_validation.py",
)

NAME_RE = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
LINK_RE = re.compile(r"!?\[[^\]]*\]\((<[^>]+>|[^)\s]+)(?:\s+['\"][^'\"]*['\"])?\)")
REFERENCE_LINK_RE = re.compile(r"^\s*\[[^\]]+\]:\s*(<[^>]+>|\S+)", re.MULTILINE)
PLACEHOLDER_RE = re.compile(
    r"^\s*(?:[-*]\s*)?(?:TODO|TBD|FIXME|XXX)(?:\s*[:\-]|\s*$)"
    r"|\[(?:TODO|TBD|FIXME)\]|lorem ipsum|conteúdo pendente"
    r"|^\s*(?:[-*]\s*)?a preencher\s*$",
    re.IGNORECASE | re.MULTILINE,
)
ALLOWED_FIELDS = {
    "name", "description", "license", "compatibility", "metadata", "allowed-tools"
}


class UniqueKeyLoader(yaml.SafeLoader):
    """Reject duplicate YAML keys, which would make frontmatter ambiguous."""


def _construct_mapping(loader: UniqueKeyLoader, node: yaml.MappingNode) -> dict:
    loader.flatten_mapping(node)
    mapping: dict = {}
    for key_node, value_node in node.value:
        key = loader.construct_object(key_node, deep=True)
        try:
            already_seen = key in mapping
        except TypeError as exc:
            raise yaml.constructor.ConstructorError(
                None, None, "chave YAML não pode ser uma lista ou mapa", key_node.start_mark
            ) from exc
        if already_seen:
            raise yaml.constructor.ConstructorError(
                None, None, f"chave YAML duplicada: {key}", key_node.start_mark
            )
        mapping[key] = loader.construct_object(value_node, deep=True)
    return mapping


UniqueKeyLoader.add_constructor(
    yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, _construct_mapping
)


def _parse_frontmatter(content: str, path: Path) -> tuple[dict | None, str, list[str]]:
    lines = content.lstrip("\ufeff").splitlines(keepends=True)
    if not lines or lines[0].strip() != "---":
        return None, "", [f"{path}: frontmatter deve começar na primeira linha"]
    closing = next((i for i in range(1, len(lines)) if lines[i].strip() == "---"), None)
    if closing is None:
        return None, "", [f"{path}: frontmatter sem delimitador final ---"]
    try:
        metadata = yaml.load("".join(lines[1:closing]), Loader=UniqueKeyLoader)
    except yaml.YAMLError as exc:
        return None, "", [f"{path}: YAML inválido: {exc}"]
    if not isinstance(metadata, dict):
        return None, "", [f"{path}: frontmatter deve ser um mapa YAML"]
    return metadata, "".join(lines[closing + 1 :]), []


def _without_fenced_code(markdown: str) -> str:
    output: list[str] = []
    fence: str | None = None
    for line in markdown.splitlines():
        match = re.match(r"^\s*(`{3,}|~{3,})", line)
        if match:
            marker = match.group(1)
            if fence is None:
                fence = marker
            elif marker[0] == fence[0] and len(marker) >= len(fence):
                fence = None
            output.append("")
        else:
            output.append("" if fence else line)
    return "\n".join(output)


def validate_local_links(path: Path, root: Path) -> list[str]:
    """Check file targets in Markdown links; HTTP URLs and fragment-only links are external."""
    markdown = _without_fenced_code(path.read_text(encoding="utf-8"))
    targets = [*LINK_RE.findall(markdown), *REFERENCE_LINK_RE.findall(markdown)]
    errors: list[str] = []
    for raw in targets:
        target = raw.strip("<>")
        parsed = urlsplit(target)
        if parsed.scheme or parsed.netloc or not parsed.path:
            continue
        candidate = (path.parent / unquote(parsed.path)).resolve()
        if not candidate.is_relative_to(root.resolve()) or not candidate.exists():
            errors.append(f"{path}: referência local inexistente: {target}")
    return errors


def validate_skill(directory: Path, root: Path) -> list[str]:
    path = directory / "SKILL.md"
    if not path.is_file():
        return [f"{path}: arquivo obrigatório ausente"]
    if path.stat().st_size == 0:
        return [f"{path}: arquivo obrigatório vazio"]
    content = path.read_text(encoding="utf-8")
    metadata, body, errors = _parse_frontmatter(content, path)
    if errors:
        return errors
    assert metadata is not None
    extra = metadata.keys() - ALLOWED_FIELDS
    if extra:
        errors.append(f"{path}: campos de frontmatter não previstos: {sorted(map(str, extra))}")
    name = metadata.get("name")
    if not isinstance(name, str) or not NAME_RE.fullmatch(name) or len(name) > 64:
        errors.append(f"{path}: name deve ter 1–64 caracteres em kebab-case")
    elif name != directory.name:
        errors.append(f"{path}: name '{name}' difere da pasta '{directory.name}'")
    description = metadata.get("description")
    if not isinstance(description, str) or not 1 <= len(description.strip()) <= 1024:
        errors.append(f"{path}: description deve ter 1–1024 caracteres")
    compatibility = metadata.get("compatibility")
    if compatibility is not None and (
        not isinstance(compatibility, str) or not 1 <= len(compatibility.strip()) <= 500
    ):
        errors.append(f"{path}: compatibility deve ter 1–500 caracteres")
    for key in ("license", "allowed-tools"):
        if key in metadata and (not isinstance(metadata[key], str) or not metadata[key].strip()):
            errors.append(f"{path}: {key} deve ser texto não vazio")
    if "metadata" in metadata and (
        not isinstance(metadata["metadata"], dict)
        or any(not isinstance(k, str) or not isinstance(v, str)
               for k, v in metadata["metadata"].items())
    ):
        errors.append(f"{path}: metadata deve mapear texto para texto")
    if not body.strip():
        errors.append(f"{path}: instruções Markdown vazias")
    return errors


def validate_repository(root: Path) -> list[str]:
    errors: list[str] = []
    root = root.resolve()
    for relative in REQUIRED_FILES:
        path = root / relative
        if not path.is_file():
            errors.append(f"{path}: arquivo obrigatório ausente")
        elif path.stat().st_size == 0:
            errors.append(f"{path}: arquivo obrigatório vazio")
    skills_root = root / "skills"
    if not skills_root.is_dir():
        return [*errors, f"{skills_root}: diretório ausente"]
    directories = [p for p in skills_root.iterdir() if p.is_dir()]
    seen: dict[str, Path] = {}
    for directory in directories:
        folded = directory.name.casefold()
        if folded in seen:
            errors.append(f"{directory}: diretório duplicado de {seen[folded]}")
        else:
            seen[folded] = directory
    actual = {p.name for p in directories}
    for missing in sorted(set(EXPECTED_SKILLS) - actual):
        errors.append(f"{skills_root / missing}: skill esperada ausente")
    for unexpected in sorted(actual - set(EXPECTED_SKILLS)):
        errors.append(f"{skills_root / unexpected}: diretório de skill não catalogado")
    for directory in directories:
        errors.extend(validate_skill(directory, root))
        for resource in directory.rglob("*"):
            if resource.is_file() and resource.stat().st_size == 0:
                errors.append(f"{resource}: arquivo auxiliar vazio")
    markdown_files = [p for p in root.rglob("*.md") if ".git" not in p.parts]
    for path in markdown_files:
        content = _without_fenced_code(path.read_text(encoding="utf-8"))
        if PLACEHOLDER_RE.search(content):
            errors.append(f"{path}: marcador de conteúdo incompleto")
        errors.extend(validate_local_links(path, root))
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    args = parser.parse_args()
    errors = validate_repository(args.root)
    if errors:
        for error in errors:
            print(f"ERRO: {error}", file=sys.stderr)
        return 1
    print(f"OK: {len(EXPECTED_SKILLS)} skills, frontmatter, arquivos e links locais")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
