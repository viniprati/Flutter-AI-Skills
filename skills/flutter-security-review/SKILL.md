---
name: flutter-security-review
description: Audita riscos de segurança em Flutter, incluindo segredos, dados locais, HTTPS, autenticação, autorização, logs e integração com backend. Use em revisões de segurança de aplicativo, mudanças sensíveis ou preparação para distribuição.
---

# Revisão de segurança Flutter

## Objetivo e uso

Entregue achados priorizados, com evidência concreta, impacto e correção executável. Use para auditoria, revisão de login/dados sensíveis ou preparação de release. Não ative para uma revisão estética sem superfície de segurança.

## Pré-requisitos

Defina plataformas, dados sensíveis, usuários, ambiente, fluxo de autenticação, destino das APIs e limites do escopo. Inspecione `pubspec.yaml`, configuração de build, repositórios, armazenamento, logs, manifesto Android e backend quando disponível. Faça buscas por padrões de segredo sem copiar o valor encontrado para relatório ou logs.

## Procedimento

1. Mapeie entrada, armazenamento, transporte, saída e descarte de dados. Para cada credencial/chave, determine se é identificador público de cliente ou segredo de servidor.
2. Revise transporte HTTPS, validação de certificado conforme a plataforma e ausência de bypass de TLS em produção. Confira tratamento de 401, expiração, logout e isolamento de dados por conta.
3. Verifique armazenamento: senha e token sensível não pertencem a `shared_preferences`; selecione mecanismo adequado ao risco, limite persistência e limpe o estado em logout segundo o requisito. Avalie backup, aparelho compartilhado e cache offline.
4. Revise autorização no servidor. Ocultar botões ou validar no Flutter melhora UX, mas a API deve autenticar, autorizar por recurso e validar entradas. Avalie URLs, `--dart-define`, logs, crash reports e payloads de notificação para vazamento.
5. Produza tabela com severidade, arquivo/linha, cenário explorável, evidência sem segredo e correção. Diferencie confirmado de hipótese que exige execução ou acesso ao servidor.

## Erros e limites

Ofuscação Dart e assinatura de release não protegem segredo embutido. Não teste exploração contra produção nem altere dados reais sem autorização específica. Evite registrar conteúdo completo de resposta HTTP, JWT ou identificadores pessoais. Se encontrar segredo real, trate rotação/revogação como ação operacional a coordenar, sem publicá-lo no relatório.

## Validação e aceite

Depois das correções, execute análise/testes de autenticação e de armazenamento, verifique o artefato e a configuração de release, e confira regras de autorização no backend com ambiente de teste. Aceite quando cada risco confirmado tiver severidade, localização e medida corretiva; riscos não verificáveis devem permanecer explicitamente pendentes.

## Especificações de ativação (ainda não executadas em agente)

- Direta: “Use flutter-security-review para auditar tokens e logs do app.”
- Indireta: “Vamos publicar o APK; verifique se há credenciais ou dados de usuários expostos.”
- Não ativar: “Troque o espaçamento entre dois cartões.”

Referências: [limites da ofuscação Flutter](https://docs.flutter.dev/deployment/obfuscate) e [visão OWASP MASVS](https://mas.owasp.org/MASVS/).
