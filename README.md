# Flutter AI Skills

[English](README.en.md)

**Procedimentos reutilizáveis para agentes de IA implementarem Flutter com acessibilidade, segurança, organização e testes.** O catálogo contém 33 skills independentes, escritas principalmente em português brasileiro, para Codex, Claude Code e clientes que adotam o formato [Agent Skills](https://agentskills.io/specification).

## Por que existe

Pedidos genéricos a um agente podem produzir código que parece pronto sem tratar falhas de rede, regras de negócio, leitores de tela ou validação. Cada skill deste repositório orienta uma tarefa concreta: o agente examina o projeto, escolhe uma solução compatível, implementa e verifica critérios de aceite. Desenvolvedores iniciantes podem pedir uma skill pelo nome; quem mantém projetos maduros pode usar apenas as que se aplicam à arquitetura existente.

O [Nativa App](https://github.com/viniprati/nativa-app), criado por Vinicius Prati Machado em um hackathon do IFES com Flutter, Dart, API TypeScript e MongoDB, inspirou padrões de camadas, acessibilidade, sincronização manual e testes. Este repositório contém procedimentos genéricos; não distribui uma cópia do aplicativo. O que foi observado e os limites da evidência estão em [inspiração técnica](docs/nativa-inspiration.md).

## Como funcionam as skills

Uma Agent Skill é uma pasta com `SKILL.md`: frontmatter YAML (`name`, `description`) para descoberta e instruções Markdown carregadas quando a tarefa combina com a descrição. Exemplos e referências locais são opcionais. O formato não concede acesso a serviços nem executa mudanças por si só. O agente precisa das ferramentas, dependências e permissões do projeto onde atua. Veja a [especificação](https://agentskills.io/specification).

Instale apenas as skills necessárias. Clonar esta biblioteca em uma pasta arbitrária não faz o agente descobri-las automaticamente. Os caminhos verificados para instalação local por projeto são `.agents/skills/` no Codex e `.claude/skills/` no Claude Code; veja [instalação](docs/installation.md) e [compatibilidade](docs/compatibility.md).

## Catálogo de skills

### Fundamentos e arquitetura

| Skill | Finalidade |
| --- | --- |
| [flutter-project-setup](skills/flutter-project-setup/SKILL.md) | Conferir SDKs, dependências, análise estática e estrutura inicial. |
| [flutter-clean-architecture](skills/flutter-clean-architecture/SKILL.md) | Separar interface, regras e dados sem complexidade desnecessária. |
| [flutter-state-management](skills/flutter-state-management/SKILL.md) | Organizar estado, ciclos de vida e notificações de mudança. |
| [flutter-design-system](skills/flutter-design-system/SKILL.md) | Centralizar Material 3, cores, tipografia e componentes. |
| [flutter-responsive-layout](skills/flutter-responsive-layout/SKILL.md) | Adaptar telas a restrições, teclado e orientação. |
| [flutter-localization](skills/flutter-localization/SKILL.md) | Traduzir interface e formatar dados por localidade, com foco em pt-BR. |

### Acessibilidade e experiência

| Skill | Finalidade |
| --- | --- |
| [flutter-accessibility-audit](skills/flutter-accessibility-audit/SKILL.md) | Auditar barreiras e entregar achados priorizados e localizados. |
| [flutter-adaptive-fonts](skills/flutter-adaptive-fonts/SKILL.md) | Ajustar fontes preservando a escala do sistema e testar até 200%. |
| [flutter-high-contrast](skills/flutter-high-contrast/SKILL.md) | Implementar contraste com cores semânticas e preferência persistida. |
| [flutter-screen-reader](skills/flutter-screen-reader/SKILL.md) | Revisar semântica, ordem de leitura e anúncios assistivos. |
| [flutter-accessible-forms](skills/flutter-accessible-forms/SKILL.md) | Criar formulários com rótulos, erros e foco acessíveis. |
| [flutter-error-feedback](skills/flutter-error-feedback/SKILL.md) | Transformar falhas em mensagens úteis sem perder entrada do usuário. |
| [flutter-confirmation-undo](skills/flutter-confirmation-undo/SKILL.md) | Confirmar ações destrutivas e oferecer desfazer quando viável. |

### Dados, regras, APIs e autenticação

| Skill | Finalidade |
| --- | --- |
| [flutter-form-validation](skills/flutter-form-validation/SKILL.md) | Validar entradas, limites e verificações assíncronas. |
| [flutter-domain-rules](skills/flutter-domain-rules/SKILL.md) | Isolar invariantes e cálculos determinísticos da interface. |
| [flutter-numeric-precision](skills/flutter-numeric-precision/SKILL.md) | Representar quantidades e dinheiro sem erros de precisão. |
| [flutter-rest-api](skills/flutter-rest-api/SKILL.md) | Integrar HTTP, serialização, timeouts, paginação e erros. |
| [flutter-jwt-authentication](skills/flutter-jwt-authentication/SKILL.md) | Tratar login, expiração, 401, armazenamento e logout. |
| [flutter-local-persistence](skills/flutter-local-persistence/SKILL.md) | Escolher e manter armazenamento local com recuperação de falhas. |
| [flutter-data-sync](skills/flutter-data-sync/SKILL.md) | Sincronizar alterações locais e remotas com retry seguro. |
| [flutter-sync-conflicts](skills/flutter-sync-conflicts/SKILL.md) | Resolver versões concorrentes preservando edições. |
| [flutter-offline-resilience](skills/flutter-offline-resilience/SKILL.md) | Planejar cache, filas e comunicação em redes instáveis. |

### Relatórios e notificações

| Skill | Finalidade |
| --- | --- |
| [flutter-data-visualization](skills/flutter-data-visualization/SKILL.md) | Exibir indicadores e gráficos legíveis, fiéis e acessíveis. |
| [flutter-pdf-reporting](skills/flutter-pdf-reporting/SKILL.md) | Gerar PDFs de dados reais, com paginação e caracteres brasileiros. |
| [flutter-push-notifications](skills/flutter-push-notifications/SKILL.md) | Integrar FCM e distinguir configuração, aceite e entrega. |

### Testes e qualidade

| Skill | Finalidade |
| --- | --- |
| [flutter-testing](skills/flutter-testing/SKILL.md) | Selecionar testes de unidade, widget e integração. |
| [flutter-performance](skills/flutter-performance/SKILL.md) | Medir e corrigir gargalos de interface e memória. |
| [flutter-debugging](skills/flutter-debugging/SKILL.md) | Reproduzir e diagnosticar erros por logs e causas. |
| [flutter-security-review](skills/flutter-security-review/SKILL.md) | Priorizar riscos no cliente e suas contrapartes no servidor. |
| [flutter-android-release](skills/flutter-android-release/SKILL.md) | Preparar assinatura, versão, APK/AAB e instalação de release. |
| [flutter-ci-cd](skills/flutter-ci-cd/SKILL.md) | Automatizar formato, análise, testes e builds de validação. |
| [flutter-code-review](skills/flutter-code-review/SKILL.md) | Revisar código por severidade, evidência e correção. |
| [flutter-documentation](skills/flutter-documentation/SKILL.md) | Documentar instalação, arquitetura e limitações verificadas. |

## Instalação rápida

Pré-requisitos: Git, um cliente compatível com skills e um checkout deste catálogo. Para aplicar instruções em um aplicativo, prepare o Flutter SDK e as dependências desse aplicativo; para validar este catálogo, use Python 3.11+ e `requirements-dev.txt`.

No terminal Bash, a partir de um diretório que contenha `flutter-ai-skills/` e `meu-app/`:

```bash
cd meu-app
mkdir -p .agents/skills
cp -R ../flutter-ai-skills/skills/flutter-accessibility-audit .agents/skills/
test -f .agents/skills/flutter-accessibility-audit/SKILL.md
```

No PowerShell:

```powershell
Set-Location .\meu-app
New-Item -ItemType Directory -Force .agents\skills | Out-Null
Copy-Item -LiteralPath ..\flutter-ai-skills\skills\flutter-accessibility-audit -Destination .agents\skills -Recurse
Test-Path .agents\skills\flutter-accessibility-audit\SKILL.md
```

Para Claude Code, troque `.agents/skills` por `.claude/skills` nos comandos. Copie o diretório completo da skill escolhida para manter eventuais `references/` e `examples/`. Consulte os comandos para instalação pessoal, clonagem e verificação em [docs/installation.md](docs/installation.md).

## Pedidos de exemplo

No Codex CLI ou extensão IDE, selecione a skill com `/skills` ou mencione `$flutter-accessibility-audit`. Também é possível fazer um pedido natural se a skill estiver instalada e sua descrição corresponder à tarefa. Exemplos:

> Utilize a skill flutter-accessibility-audit para revisar meu projeto e identificar problemas de acessibilidade para usuários idosos.

> Utilize flutter-high-contrast para implementar um tema acessível sem alterar as regras de negócio existentes.

> Utilize flutter-rest-api para conectar meu aplicativo a uma API REST, implementando tratamento de erros e organização por camadas.

> Utilize flutter-testing para criar testes automatizados das minhas regras de negócio e dos formulários.

> Utilize flutter-code-review para identificar problemas de segurança, desempenho e arquitetura no código gerado por IA.

Um fluxo com várias skills pode pedir: “Use `flutter-accessibility-audit` para localizar barreiras, `flutter-high-contrast` para corrigir o tema e `flutter-testing` para criar testes dos estados visuais; mostre os resultados de cada etapa.” Instale as três no projeto antes de iniciar. Em Claude Code, o comando direto usa `/nome-da-skill`; as instruções oficiais de [Claude Code](https://code.claude.com/docs/en/skills) explicam descoberta e escopo.

## Qualidade, contribuição e licença

O workflow de CI valida as 33 pastas, frontmatter, links locais e testes do validador, além de executar o `skills-ref` oficial. Esse resultado confirma formato e integridade do catálogo; os cenários de ativação documentados nas skills ainda precisam ser avaliados em sessões reais de agentes. Exemplos Dart exigem Flutter para análise e execução. Consulte [desenvolvimento de skills](docs/skill-development.md), [contribuição](CONTRIBUTING.md) e [segurança](SECURITY.md).

Autor: **Vinicius Prati Machado**. Licença [MIT](LICENSE).
