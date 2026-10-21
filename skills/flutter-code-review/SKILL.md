---
name: flutter-code-review
description: Revisa código Flutter escrito manualmente ou por IA para detectar bugs, riscos de segurança, acoplamento, falhas de acessibilidade e lacunas de teste. Use em revisão de mudanças, PRs ou auditoria de código com evidências por arquivo e linha.
---

# Revisão de código Flutter

## Objetivo e ativação

Entregue achados acionáveis e ordenados por risco. Use quando o pedido for revisar código, PR ou mudança gerada por IA. Não ative para implementar funcionalidade nova sem código a revisar; se o pedido incluir correção, aplique as mudanças após identificar os achados.

## Pré-requisitos

Defina diff/base, requisitos, plataformas e limites do projeto. Leia `AGENTS.md`, testes, `pubspec.yaml`, configurações e arquivos alterados. Inspecione chamadas e consumidores das APIs mudadas, não apenas o diff. Se houver Nativa como referência, não copie dados nem considere teste histórico como validação do projeto atual.

## Procedimento

1. Identifique fluxos afetados e invariantes: estados vazios/falhos, validação de domínio, concorrência assíncrona, persistência, autenticação e navegação. Compare implementação com o requisito.
2. Examine fronteiras entre UI, estado, domínio e dados; procure dependência circular, regra crítica só no widget, `BuildContext` usado após `await`, listeners sem descarte e mudanças de contrato sem migração.
3. Inspecione dados sensíveis, HTTPS, autorização no servidor, logs, credenciais, permissões e payloads. Faça também leitura de acessibilidade: rótulos, foco, ordem, contraste, texto ampliado e mensagem de erro.
4. Rode testes/análise pertinentes quando possível. Confirme cada possível bug por caminho de execução, teste ou contrato. Se não puder confirmar, marque como hipótese e explique qual prova falta.
5. Relate primeiro os achados, cada um com severidade, arquivo/linha, cenário concreto, impacto e correção sugerida. Depois resuma testes executados e lacunas. Se não houver achados, diga isso explicitamente e informe o alcance da revisão.

Severidade sugerida: **crítica** para exposição explorável de credencial/dado ou perda grave; **alta** para fluxo essencial quebrado ou perda de dados; **média** para defeito com contorno; **baixa** para problema localizado. Ajuste segundo o contexto, sem inflar a classificação.

## Erros comuns e aceite

Evite crítica genérica (“melhorar arquitetura”), preferências pessoais tratadas como defeito e alegações de funcionamento em dispositivo baseadas só em `flutter test` ou build. Não inclua segredo encontrado no texto da revisão. Aceite quando cada achado puder ser localizado e reproduzido ou investigado com passos claros; indique cobertura e limites da revisão.

## Especificações de ativação (ainda não executadas em agente)

- Direta: “Use flutter-code-review para revisar este PR Flutter.”
- Indireta: “A IA gerou esta tela; veja se há bugs, vazamentos e problemas de acesso.”
- Não ativar: “Implemente uma tela nova de cadastro sem código existente.”

Referências: [análise Flutter](https://docs.flutter.dev/testing/errors) e [tipos de teste](https://docs.flutter.dev/testing/overview).
