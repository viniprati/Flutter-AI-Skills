"""Behavioral checks for the catalog validator's failure paths."""

from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

from scripts.validate_skills import EXPECTED_SKILLS, REQUIRED_FILES, validate_repository


class CatalogValidationTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        for relative in REQUIRED_FILES:
            path = self.root / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text("Arquivo de teste.\n", encoding="utf-8")
        for name in EXPECTED_SKILLS:
            directory = self.root / "skills" / name
            directory.mkdir(parents=True)
            (directory / "SKILL.md").write_text(
                f"---\nname: {name}\n"
                f"description: Executa {name} quando solicitado em um projeto Flutter.\n"
                "---\n\n# Procedimento\n\nInspecione o projeto e valide a alteração.\n",
                encoding="utf-8",
            )

    def skill_file(self, name: str = "flutter-project-setup") -> Path:
        return self.root / "skills" / name / "SKILL.md"

    def test_valid_catalog(self) -> None:
        self.assertEqual(validate_repository(self.root), [])

    def test_missing_skill_and_empty_required_file(self) -> None:
        self.skill_file().unlink()
        (self.root / "LICENSE").write_text("", encoding="utf-8")
        errors = "\n".join(validate_repository(self.root))
        self.assertIn("SKILL.md: arquivo obrigatório ausente", errors)
        self.assertIn("LICENSE: arquivo obrigatório vazio", errors)

    def test_duplicate_yaml_key_is_rejected(self) -> None:
        path = self.skill_file()
        path.write_text(
            "---\nname: flutter-project-setup\nname: another-name\n"
            "description: Uma descrição.\n---\n\nCorpo.\n",
            encoding="utf-8",
        )
        self.assertIn("chave YAML duplicada", "\n".join(validate_repository(self.root)))

    def test_name_and_description_constraints(self) -> None:
        path = self.skill_file()
        path.write_text(
            "---\nname: Flutter--Setup\ndescription: ''\n---\n\nCorpo.\n",
            encoding="utf-8",
        )
        errors = "\n".join(validate_repository(self.root))
        self.assertIn("name deve ter 1–64 caracteres", errors)
        self.assertIn("description deve ter 1–1024 caracteres", errors)

    def test_broken_relative_link_but_not_external_or_fragment(self) -> None:
        path = self.skill_file()
        with path.open("a", encoding="utf-8") as stream:
            stream.write("\n[guia](references/missing.md) [site](https://example.org) [seção](#secao)\n")
        errors = "\n".join(validate_repository(self.root))
        self.assertIn("referência local inexistente: references/missing.md", errors)
        self.assertNotIn("https://example.org", errors)

    def test_placeholder_outside_code_block_only(self) -> None:
        path = self.skill_file()
        with path.open("a", encoding="utf-8") as stream:
            stream.write("\n```text\nTODO: dado de demonstração\n```\n")
        self.assertEqual(validate_repository(self.root), [])
        with path.open("a", encoding="utf-8") as stream:
            stream.write("\nTODO: escrever instruções\n")
        self.assertIn("marcador de conteúdo incompleto", "\n".join(validate_repository(self.root)))

    def test_empty_supporting_resource(self) -> None:
        resource = self.skill_file().parent / "references" / "details.md"
        resource.parent.mkdir()
        resource.write_text("", encoding="utf-8")
        self.assertIn("arquivo auxiliar vazio", "\n".join(validate_repository(self.root)))

    def test_optional_frontmatter_types_and_unknown_field(self) -> None:
        self.skill_file().write_text(
            "---\nname: flutter-project-setup\n"
            "description: Prepara um projeto quando Flutter precisa ser configurado.\n"
            "compatibility: 123\nmetadata:\n  edition: 2\nextra: value\n"
            "---\n\nCorpo.\n",
            encoding="utf-8",
        )
        errors = "\n".join(validate_repository(self.root))
        self.assertIn("campos de frontmatter não previstos", errors)
        self.assertIn("compatibility deve ter 1–500 caracteres", errors)
        self.assertIn("metadata deve mapear texto para texto", errors)

    def test_unlisted_skill_directory(self) -> None:
        extra = self.root / "skills" / "flutter-extra"
        extra.mkdir()
        (extra / "SKILL.md").write_text(
            "---\nname: flutter-extra\ndescription: Use para teste.\n---\n\nTexto.\n",
            encoding="utf-8",
        )
        self.assertIn("diretório de skill não catalogado", "\n".join(validate_repository(self.root)))

    def test_case_insensitive_duplicate_directories(self) -> None:
        upper = self.root / "skills" / "Flutter-project-setup"
        try:
            upper.mkdir()
        except FileExistsError:
            self.skipTest("filesystem não distingue capitalização em nomes de diretório")
        (upper / "SKILL.md").write_text(
            "---\nname: Flutter-project-setup\ndescription: Use para teste.\n---\n\nTexto.\n",
            encoding="utf-8",
        )
        self.assertIn("diretório duplicado", "\n".join(validate_repository(self.root)))


if __name__ == "__main__":
    unittest.main()
