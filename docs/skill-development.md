# Desenvolvimento de skills

Este guia complementa [CONTRIBUTING.md](../CONTRIBUTING.md). Use a [especificação Agent Skills](https://agentskills.io/specification) como fonte do formato: uma pasta por skill, `SKILL.md` obrigatório, `name` igual à pasta (1–64 caracteres em kebab-case, sem `--`) e `description` não vazia com até 1024 caracteres. A descrição deve permitir ao agente identificar **o que a skill faz e quando acioná-la**.

## Estrutura mínima

```text
skills/
└── flutter-example-task/
    └── SKILL.md
```

```yaml
---
name: flutter-example-task
description: Executa uma tarefa Flutter específica. Use quando o projeto precisar dessa tarefa e ainda não tiver um procedimento equivalente.
---
```

O corpo é Markdown em português brasileiro. Mantenha o arquivo focado; `references/` recebe detalhes usados apenas em certos contextos e `examples/` recebe código necessário à tarefa. Cada link deve usar caminho relativo à pasta da skill e apontar para um arquivo presente. Não crie pastas auxiliares vazias.

## Conteúdo operacional

Cada skill deste catálogo deve permitir ao agente:

1. Reconhecer o objetivo e o caso de uso, inclusive pedidos indiretos, e saber quando deixar outra skill atuar.
2. Conferir pré-requisitos concretos (arquivos, arquitetura atual, versões, contrato da API, permissões ou dispositivo) antes de modificar código.
3. Seguir um procedimento com escolhas explícitas conforme o contexto; respeitar dependências já adotadas no aplicativo.
4. Evitar erros frequentes, com orientações específicas de segurança e acessibilidade quando a tarefa as envolver.
5. Executar validações proporcionais ao risco e declarar critérios observáveis de aceite.
6. Apresentar um exemplo de pedido e três cenários de ativação: direto, indireto e negativo.

Marque os cenários como **especificações não executadas** até realizar uma avaliação real em agente compatível. Uma checagem de YAML confirma estrutura, não seleção correta. Quando houver avaliação, registre agente/versão, projeto de teste, pedido, skill selecionada, resultado e evidência; não generalize um único acerto para todos os clientes.

Evite instruções genéricas, versões fixadas sem motivo e exemplos agrícolas derivados do Nativa. Código Dart deve ter dependências explícitas, não conter credenciais e usar APIs reais. Antes de declarar que ele compila, rode `dart format`, `flutter analyze` e testes no SDK e plataforma pertinentes. Se isso não for possível, descreva a limitação.

## Validação local

Na raiz do repositório, com Python 3.11+:

```bash
python -m pip install -r requirements-dev.txt
python scripts/validate_skills.py
python -m unittest discover -s tests -v
```

O validador local checa a presença das 33 skills, YAML, nomes, limites, arquivos obrigatórios vazios, duplicatas, links relativos e marcadores evidentes de conteúdo incompleto. A [GitHub Action](../.github/workflows/validate-skills.yml) acrescenta o validador de referência `skills-ref`. Para uso manual do `skills-ref`, instale-o a partir do [subdiretório oficial no repositório agentskills/agentskills](https://github.com/agentskills/agentskills/tree/main/skills-ref) e rode `skills-ref validate skills/<nome>`; a CI usa um commit fixo para reproduzir o resultado. O pacote homônimo de terceiros no PyPI não é usado na CI.

Faça uma revisão de conteúdo além da automação: compare a descrição com skills vizinhas, simule os três pedidos de ativação, procure passos sem saída verificável e confira os limites de segurança e acessibilidade. Descreva resultados e testes não executados no pull request.
