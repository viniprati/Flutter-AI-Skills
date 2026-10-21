# Compatibilidade e limites

## Formato

As 33 pastas seguem [Agent Skills](https://agentskills.io/specification): `SKILL.md` com YAML `name`/`description`, corpo Markdown e arquivos opcionais ligados por caminho relativo. A validação de formato não garante que um agente selecione a skill correta ou cumpra suas instruções. Cada skill inclui três cenários de ativação (direto, indireto e negativo) como **especificações ainda não executadas em um agente compatível**.

## Clientes

| Cliente | Instalação local por projeto documentada | Invocação documentada | Escopo desta verificação |
| --- | --- | --- | --- |
| Codex CLI/extensão IDE | `.agents/skills/<nome>/SKILL.md` | `/skills` ou `$nome` | Caminho e uso conferidos na [documentação oficial](https://learn.chatgpt.com/docs/build-skills); ativação das 33 skills não foi avaliada no cliente. |
| Claude Code | `.claude/skills/<nome>/SKILL.md` | `/nome` ou pedido compatível com a descrição | Caminho e uso conferidos na [documentação oficial](https://code.claude.com/docs/en/skills); ativação das 33 skills não foi avaliada no cliente. |
| Outros clientes | Depende do cliente | Depende do cliente | Formato portátil, sem promessa de descoberta ou execução não testada. |

O mesmo `SKILL.md` pode ser copiado para ambos os caminhos, sem campos específicos de um fornecedor. Instalar todas as 33 skills pode aumentar o orçamento de descrições durante a descoberta; selecione as relevantes ao projeto.

## Flutter e serviços

As skills não fixam uma única versão de Flutter. Exemplos com sintaxe Dart moderna ou pacotes como `pdf`, `printing` e `firebase_messaging` exigem conferir a versão do SDK e das dependências do aplicativo consumidor. Sem Flutter/Dart no ambiente, é possível validar a estrutura do catálogo, mas não executar análise estática ou testes Flutter.

Fluxos de JWT, sincronização, permissões, FCM, impressão e distribuição dependem de contrato ou configuração no backend, Android/iOS e provedores externos. Os testes de unidade e widget podem validar decisões locais; execução em aparelho, leitores de tela, entrega push e impressão precisam de evidência própria. A documentação do [Nativa](nativa-inspiration.md) registra esses limites na origem da inspiração.
