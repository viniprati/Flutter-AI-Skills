# Instalação

O diretório `skills/` deste repositório é o catálogo de origem. Cada ferramenta procura skills em locais definidos por ela. Escolha uma ou mais pastas completas do catálogo e copie-as para o diretório descoberto pelo cliente; manter `SKILL.md` sem seus arquivos de apoio pode quebrar o procedimento.

## Obter o catálogo

Depois da publicação do repositório, clone-o em uma pasta de trabalho:

```bash
git clone https://github.com/viniprati/Flutter-AI-Skills.git flutter-ai-skills
```

Se você já recebeu este repositório como checkout local, use o caminho desse checkout e dispense o clone. Os comandos a seguir assumem dois diretórios irmãos, `flutter-ai-skills/` e `meu-app/`; ajuste o caminho de origem se estiverem em outro lugar.

## Codex por projeto

A [documentação oficial do Codex](https://learn.chatgpt.com/docs/build-skills) informa que ele procura skills em `.agents/skills/` no diretório atual e em ancestrais até a raiz do repositório. No projeto Flutter:

```bash
cd meu-app
mkdir -p .agents/skills
cp -R ../flutter-ai-skills/skills/flutter-high-contrast .agents/skills/
cp -R ../flutter-ai-skills/skills/flutter-testing .agents/skills/
test -f .agents/skills/flutter-high-contrast/SKILL.md
```

Equivalente no PowerShell, iniciado no diretório que contém os dois checkouts:

```powershell
Set-Location .\meu-app
New-Item -ItemType Directory -Force .agents\skills | Out-Null
Copy-Item -LiteralPath ..\flutter-ai-skills\skills\flutter-high-contrast -Destination .agents\skills -Recurse
Copy-Item -LiteralPath ..\flutter-ai-skills\skills\flutter-testing -Destination .agents\skills -Recurse
Test-Path .agents\skills\flutter-high-contrast\SKILL.md
```

Abra o Codex dentro de `meu-app`. No Codex CLI/extensão IDE, consulte `/skills` ou mencione `$flutter-high-contrast` no pedido. O Codex também pode selecioná-la quando o pedido combinar com a descrição; se uma skill recém-copiada não aparecer, reinicie o Codex. O diretório `skills/` do catálogo, sozinho, não é um local de descoberta do projeto consumidor.

Para uso pessoal em todos os projetos no mesmo computador, copie a pasta para `~/.agents/skills/` em vez de `.agents/skills/` no projeto. Prefira instalação por projeto quando a equipe precisa versionar exatamente as skills que usa. Para qualquer instalação, revise as instruções de terceiros antes de executá-las.

## Claude Code por projeto

A [documentação oficial do Claude Code](https://code.claude.com/docs/en/skills) usa `.claude/skills/<nome>/SKILL.md` no projeto e `~/.claude/skills/<nome>/SKILL.md` para uso pessoal. A partir de `meu-app`:

```bash
mkdir -p .claude/skills
cp -R ../flutter-ai-skills/skills/flutter-accessible-forms .claude/skills/
test -f .claude/skills/flutter-accessible-forms/SKILL.md
```

No PowerShell:

```powershell
New-Item -ItemType Directory -Force .claude\skills | Out-Null
Copy-Item -LiteralPath ..\flutter-ai-skills\skills\flutter-accessible-forms -Destination .claude\skills -Recurse
Test-Path .claude\skills\flutter-accessible-forms\SKILL.md
```

Abra Claude Code no projeto e peça `/flutter-accessible-forms` ou descreva a tarefa. As regras de descoberta para sessões em nuvem e diretórios adicionais podem diferir das sessões locais; consulte a documentação do cliente antes de atribuir compatibilidade a esse ambiente.

## Outros clientes Agent Skills

O [padrão Agent Skills](https://agentskills.io/specification) define o conteúdo da pasta, mas não obriga todos os clientes a procurar no mesmo caminho. Identifique no manual do cliente seu diretório de skills e método de invocação, copie a pasta completa e confirme que ela aparece na lista do cliente. Não interprete a validação de `SKILL.md` como teste de descoberta ou de comportamento nessa ferramenta.

## Verificar o catálogo antes de distribuir

Com Python 3.11+ instalado, na raiz da biblioteca:

```bash
python -m pip install -r requirements-dev.txt
python scripts/validate_skills.py
python -m unittest discover -s tests -v
```

O CI também executa `skills-ref validate` para cada pasta. Para verificar código Dart em um projeto consumidor, rode `flutter pub get`, `flutter analyze` e os testes pertinentes dentro desse projeto, com a versão de Flutter adotada por ele. Nenhuma skill instala automaticamente o SDK, plugins ou credenciais.
