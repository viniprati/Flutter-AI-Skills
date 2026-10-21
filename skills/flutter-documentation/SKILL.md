---
name: flutter-documentation
description: Cria e atualiza README e guias técnicos de projetos Flutter com instalação, arquitetura, ambientes, testes e limitações verificadas. Use quando o projeto precisar de documentação técnica confiável ou atualização após mudança funcional.
---

# Documentação técnica Flutter

## Objetivo e uso

Escreva instruções que outra pessoa consiga executar e uma descrição fiel do estado do projeto. Use para README, instalação, arquitetura, configuração, release e limitações. Não ative para texto de marketing desconectado do código.

## Pré-requisitos

Inspecione `pubspec.yaml`, `analysis_options.yaml`, estrutura `lib/`, `test/`, `integration_test/`, configurações de plataforma, scripts e workflows. Compare docs atuais com código e evidências de execução. Confirme versões e comandos no ambiente disponível; não publique valores de `.env` ou dados pessoais.

## Procedimento

1. Defina público e tarefa do documento. No README, descreva finalidade, requisitos, instalação, configuração segura, comando de execução, testes e links para guias específicos.
2. Escreva comandos completos a partir da raiz correta, indicando plataforma e pré-requisitos. Para variáveis de ambiente, use nomes e valores fictícios, explique onde definir valores reais e quais são secretos.
3. Documente arquitetura pelo fluxo real entre UI, domínio, repositórios, armazenamento e backend. Use caminho de arquivo e contrato concreto; evite diagrama que prometa camada inexistente.
4. Separe status em **implementado**, **testado** e **pendente**. Indique comando, data/ambiente e plataforma para testes observados. Um build não significa validação em aparelho; teste automatizado de semântica não significa teste TalkBack/VoiceOver.
5. Atualize links, exemplos, changelog e limitações afetadas pela mudança. Garanta que idioma e termos de domínio estejam consistentes. Se houver guia em inglês, confira equivalência factual, sem exigir tradução palavra por palavra.

## Erros comuns, segurança e aceite

Evite versão fixa de dependência que contradiga `pubspec.yaml`, comandos dependentes de diretório implícito, promessas de login offline sem implementação e exemplos com URL/credenciais privadas. Confira links locais, copie os comandos para terminal quando o ambiente permitir e revise cada alegação contra código ou teste. Aceite quando uma pessoa nova conseguir instalar e executar o fluxo documentado e as pendências estejam visíveis.

## Especificações de ativação (ainda não executadas em agente)

- Direta: “Use flutter-documentation para criar o README e o guia de instalação.”
- Indireta: “Atualize as instruções porque o login agora depende de uma API.”
- Não ativar: “Corrija somente o `RenderFlex overflow` desta tela.”

Referências: [documentação Flutter](https://docs.flutter.dev/) e [Agent Skills](https://agentskills.io/specification) quando a documentação tratar da instalação de skills.
