# Flutter AI Skills

[Português brasileiro](README.md)

**Reusable workflows for AI coding agents building accessible, secure, organized, and tested Flutter applications.** This repository contains 33 independent skills, primarily written in Brazilian Portuguese, using the open [Agent Skills specification](https://agentskills.io/specification). They are designed for Codex, Claude Code, and other clients that support the format.

## Motivation and origin

A broad coding request can produce an interface that looks complete while missing network failures, domain constraints, screen reader behavior, or meaningful verification. Each skill gives an agent a specific procedure: inspect the existing project, choose a compatible implementation, make the change, and check acceptance criteria. Developers can install only the workflows their application needs.

The [Nativa App](https://github.com/viniprati/nativa-app), built by Vinicius Prati Machado during an IFES hackathon with Flutter, Dart, a TypeScript API, and MongoDB, supplied practical examples of layering, accessibility, manual synchronization, and tests. This library is independent of Nativa and includes no copy of the application. See [what was learned and what remains unverified](docs/nativa-inspiration.md).

An Agent Skill is a directory containing `SKILL.md`. Its YAML `name` and `description` help the agent discover it; its Markdown body gives task instructions. Supporting references and examples are loaded only when useful. A skill does not provide service access or Flutter dependencies on its own.

## Skill catalog

### Foundations and architecture

| Skill | Purpose |
| --- | --- |
| [flutter-project-setup](skills/flutter-project-setup/SKILL.md) | Check SDKs, dependencies, static analysis, and starting structure. |
| [flutter-clean-architecture](skills/flutter-clean-architecture/SKILL.md) | Separate UI, business rules, and data access without unnecessary layers. |
| [flutter-state-management](skills/flutter-state-management/SKILL.md) | Organize state, lifecycles, and change notifications. |
| [flutter-design-system](skills/flutter-design-system/SKILL.md) | Centralize Material 3, colors, type, and components. |
| [flutter-responsive-layout](skills/flutter-responsive-layout/SKILL.md) | Adapt layouts to constraints, keyboards, and orientation. |
| [flutter-localization](skills/flutter-localization/SKILL.md) | Translate UI and format values by locale, with pt-BR examples. |

### Accessibility and user experience

| Skill | Purpose |
| --- | --- |
| [flutter-accessibility-audit](skills/flutter-accessibility-audit/SKILL.md) | Report located, prioritized accessibility barriers. |
| [flutter-adaptive-fonts](skills/flutter-adaptive-fonts/SKILL.md) | Add font controls while preserving system text scaling. |
| [flutter-high-contrast](skills/flutter-high-contrast/SKILL.md) | Add semantic, persisted high contrast themes. |
| [flutter-screen-reader](skills/flutter-screen-reader/SKILL.md) | Review semantics, reading order, and assistive announcements. |
| [flutter-accessible-forms](skills/flutter-accessible-forms/SKILL.md) | Build labeled forms with accessible errors and focus. |
| [flutter-error-feedback](skills/flutter-error-feedback/SKILL.md) | Turn failures into actionable messages without losing user input. |
| [flutter-confirmation-undo](skills/flutter-confirmation-undo/SKILL.md) | Confirm destructive actions and offer undo where restoration exists. |

### Data, rules, APIs, and authentication

| Skill | Purpose |
| --- | --- |
| [flutter-form-validation](skills/flutter-form-validation/SKILL.md) | Check required fields, limits, formats, and asynchronous rules. |
| [flutter-domain-rules](skills/flutter-domain-rules/SKILL.md) | Keep deterministic invariants outside widgets. |
| [flutter-numeric-precision](skills/flutter-numeric-precision/SKILL.md) | Represent quantities and money with deliberate precision. |
| [flutter-rest-api](skills/flutter-rest-api/SKILL.md) | Integrate HTTP, serialization, timeouts, pagination, and errors. |
| [flutter-jwt-authentication](skills/flutter-jwt-authentication/SKILL.md) | Handle login, expiration, 401 responses, storage, and logout. |
| [flutter-local-persistence](skills/flutter-local-persistence/SKILL.md) | Choose local storage and handle schema changes and failures. |
| [flutter-data-sync](skills/flutter-data-sync/SKILL.md) | Sync local and remote changes with safe retries. |
| [flutter-sync-conflicts](skills/flutter-sync-conflicts/SKILL.md) | Resolve concurrent versions without losing edits. |
| [flutter-offline-resilience](skills/flutter-offline-resilience/SKILL.md) | Plan caches, queues, and feedback for unstable networks. |

### Reporting and notifications

| Skill | Purpose |
| --- | --- |
| [flutter-data-visualization](skills/flutter-data-visualization/SKILL.md) | Present faithful, accessible metrics and charts. |
| [flutter-pdf-reporting](skills/flutter-pdf-reporting/SKILL.md) | Generate paginated PDFs from real data and Unicode fonts. |
| [flutter-push-notifications](skills/flutter-push-notifications/SKILL.md) | Integrate FCM and distinguish setup from verified delivery. |

### Testing and quality

| Skill | Purpose |
| --- | --- |
| [flutter-testing](skills/flutter-testing/SKILL.md) | Choose unit, widget, and integration tests. |
| [flutter-performance](skills/flutter-performance/SKILL.md) | Measure and fix rendering and memory bottlenecks. |
| [flutter-debugging](skills/flutter-debugging/SKILL.md) | Reproduce and diagnose failures using logs and evidence. |
| [flutter-security-review](skills/flutter-security-review/SKILL.md) | Prioritize client risks and server responsibilities. |
| [flutter-android-release](skills/flutter-android-release/SKILL.md) | Prepare signing, versioning, APK/AAB, and release installation. |
| [flutter-ci-cd](skills/flutter-ci-cd/SKILL.md) | Automate formatting, analysis, tests, and validation builds. |
| [flutter-code-review](skills/flutter-code-review/SKILL.md) | Review with severity, evidence, and suggested corrections. |
| [flutter-documentation](skills/flutter-documentation/SKILL.md) | Document setup, architecture, and verified limitations. |

## Installation and use

You need Git, a compatible coding agent, and a local checkout of this catalog. Applying a skill to an app also requires that app's Flutter setup; validating this catalog requires Python 3.11+ and `requirements-dev.txt`.

For Codex, copy a selected **whole skill folder** into the Flutter app's `.agents/skills/` directory. For Claude Code, use `.claude/skills/`. From a parent directory containing both `flutter-ai-skills/` and `my-app/`, the Bash commands are:

```bash
cd my-app
mkdir -p .agents/skills
cp -R ../flutter-ai-skills/skills/flutter-accessibility-audit .agents/skills/
test -f .agents/skills/flutter-accessibility-audit/SKILL.md
```

For Claude Code, replace `.agents/skills` with `.claude/skills`. See the [installation guide](docs/installation.md) for PowerShell, user-level paths, clone instructions, and verification. A clone in an arbitrary directory does **not** make the skills available automatically. The [Codex skill documentation](https://learn.chatgpt.com/docs/build-skills) and [Claude Code skill documentation](https://code.claude.com/docs/en/skills) define their current local discovery paths.

In Codex CLI or its IDE extension, use `/skills` or mention `$flutter-accessibility-audit`. In Claude Code, invoke `/flutter-accessibility-audit`. Examples of natural requests:

> Use flutter-accessibility-audit to review my app for accessibility barriers affecting older users.

> Use flutter-high-contrast to implement an accessible theme without changing domain rules.

> Use flutter-rest-api to connect my app to a REST API with error handling and layered code.

> Use flutter-testing to cover my domain rules and forms with automated tests.

> Use flutter-code-review to identify security, performance, and architecture problems in AI-generated Flutter code.

For a combined workflow: “Use flutter-accessibility-audit to find barriers, flutter-high-contrast to fix the theme, and flutter-testing to verify the states; report the result of each step.” Install all requested skills first.

## Quality and participation

CI checks the 33 folders, YAML frontmatter, local links, validator tests, and official `skills-ref` format validation. These checks establish catalog integrity, not real agent behavior. Each skill records direct, indirect, and negative activation scenarios as **test specifications that have not yet been run with an agent**. Executable Dart examples require a Flutter SDK for analysis and tests. Read the [development guide](docs/skill-development.md), [contribution guide](CONTRIBUTING.md), and [security policy](SECURITY.md).

Author: **Vinicius Prati Machado**. [MIT license](LICENSE).
