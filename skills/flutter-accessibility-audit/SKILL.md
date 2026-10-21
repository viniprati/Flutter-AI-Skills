---
name: flutter-accessibility-audit
description: Audita acessibilidade de apps Flutter e entrega achados localizados com impacto, severidade e correção. Use em revisões de contraste, semântica, foco, navegação, formulários, toque e escala de texto.
---

# Auditar acessibilidade

## Objetivo

Encontrar barreiras reais nas jornadas do app e produzir um relatório que permita corrigir e verificar cada problema.

## Quando usar

Quando o usuário pede diagnóstico de acessibilidade, revisão para pessoas idosas ou avaliação antes de uma entrega.

## Quando não usar

Para uma implementação delimitada de alto contraste, fonte ou formulário sem solicitação de auditoria geral. Não declare conformidade WCAG com base apenas em código ou testes automatizados.

## Verificar antes

Defina plataformas, público, jornadas críticas, versão Flutter, tema, idiomas e critérios de acessibilidade pedidos. Inspecione telas, componentes compartilhados, testes existentes e disponibilidade de aparelho com TalkBack/VoiceOver.

## Procedimento

1. Liste fluxos completos: entrada, navegação, formulário, erro, confirmação e saída. Inclua estados vazios, carregando e falha.
2. Examine pares de contraste, texto em 200%, alvos de toque, orientação, teclado aberto, foco por teclado, ordem de leitura, rótulos, estados e anúncios. Revise se informação depende só de cor, gesto ou posição.
3. Use inspeção de widgets e testes das [diretrizes de acessibilidade do Flutter](https://docs.flutter.dev/ui/accessibility/accessibility-testing) para localizar problemas reproduzíveis. Teste com leitor de tela no dispositivo quando disponível e registre modelo/sistema.
4. Classifique cada achado por severidade com base em bloqueio da tarefa e frequência, indicando **arquivo/tela**, passo de reprodução, evidência, impacto e correção sugerida.
5. Informe o que foi verificado automaticamente, manualmente e o que ficou pendente. Se a solicitação incluir correção, implemente as prioridades e repita o percurso.

Formato mínimo de achado:

| Local | Problema e reprodução | Impacto | Severidade | Correção | Verificação |
| --- | --- | --- | --- | --- | --- |
| Tela/campo/arquivo | Ação e resultado observado | Quem fica impedido | Crítica/alta/média/baixa | Mudança concreta | Teste que comprova |

## Boas práticas

Associe cada recomendação a uma observação; agrupe duplicações causadas por componente compartilhado. Priorize bloqueios de tarefa antes de detalhes estéticos. Diferencie ausência de evidência de aprovação.

## Erros comuns

- Relatório com “melhorar Semantics” sem elemento, reprodução ou impacto.
- Tratar screenshot e teste de contraste da paleta como prova de contraste de toda a tela.
- Inferir ordem do TalkBack/VoiceOver apenas pela árvore visual.

## Segurança e acessibilidade

Use dados fictícios nos testes e no relatório; não inclua credenciais nem conteúdo pessoal anunciado por leitor de tela. Teste erros e operações destrutivas com dados de teste.

## Validação

Reproduza ao menos um caso por classe de problema encontrada, execute testes relevantes e confira o relatório contra o app. Testes automatizados cobrem apenas propriedades que inspecionam; registre testes reais de leitor de tela separadamente.

## Critérios de aceitação

Cada achado permite localizar e reproduzir a falha, tem impacto/severidade justificados e sugere correção verificável. O relatório declara plataformas e jornadas cobertas, resultados e lacunas.

## Cenários de ativação

Especificações de teste de ativação, ainda não executadas em agente compatível:

- **Direta:** “Use flutter-accessibility-audit para revisar meu app para usuários idosos.”
- **Indireta:** “Antes de entregar, identifique onde teclado, leitor de tela ou fonte grande impedem o cadastro.”
- **Não ativa:** “Implemente somente a cor de alto contraste já especificada para este botão.”
