---
name: flutter-sync-conflicts
description: Detecta e resolve edições concorrentes entre cópia local e remota em Flutter. Use quando a sincronização recebe revisão divergente ou precisa permitir revisão sem sobrescrita silenciosa.
---

# Conflitos de sincronização

## Objetivo e acionamento

Preserve duas alterações concorrentes e obtenha uma decisão rastreável antes de descartar uma delas. Use com revisão/`ETag`, `409`/`412`, merge ou escolha entre versões. Não acione para erro de validação comum, nem trate um timeout isolado como conflito confirmado.

## Antes de alterar

- Confirme protocolo de revisão, estado base conhecido, campos comparáveis e se exclusões têm tombstone.
- Entenda se há histórico/backup, qual versão é local, qual é remota e se a API oferece leitura atual e escrita condicional.
- Identifique dados sensíveis que não devem aparecer em comparação, notificações ou logs.

## Procedimento

1. Salve a revisão e o retrato base após cada sync bem-sucedida. Ao editar, mantenha a versão local com sua revisão base até confirmação remota.
2. Ao buscar remoto ou receber `409`/`412`, compare **base**, **local** e **remoto**. Se só um lado mudou, aplique a mudança correspondente; se ambos mudaram o mesmo registro/campo, marque conflito sem alterar a cópia local.
3. Apresente identificação do registro, campos alterados e versões com rótulos claros (neste aparelho, no servidor, quando disponível). Não dependa apenas de cor. Para coleção grande, mostre resumo e detalhes suficientes para decisão.
4. Ofereça estratégias suportadas: manter local mediante nova tentativa condicional, usar remoto após confirmação de descarte, ou merge de campos independentes quando a regra de negócio permitir. Não force overwrite para resolver `409` sem mostrar consequência.
5. Antes de aplicar uma escolha que descarta trabalho, consulte novamente a versão remota; se a revisão mudou, reabra o conflito. Persista a resolução local de modo atômico e só então retire o conflito da lista.
6. Se a resolução falhar, restaure o estado anterior e mantenha ambas as versões disponíveis. Registre identificador e revisões, sem dados pessoais ou conteúdo bruto.

## Práticas e problemas comuns

- `last-write-wins` silencioso perde dados; use apenas quando a regra do produto autorizar expressamente e o impacto for aceitável.
- Hash/fingerprint ajuda a detectar diferença, mas não substitui revisão para escrita concorrente no servidor.
- Relógio local e horário de exibição podem estar incorretos; não decida vencedor só por timestamp do aparelho.
- Se remoto foi excluído, preserve a edição local e trate exclusão versus edição como conflito próprio.

## Validação e critérios de aceitação

- Teste local igual à base/remoto mudou; remoto igual à base/local mudou; ambos mudaram; exclusão remota; nova mudança durante resolução; falha ao persistir.
- Em teste de widget, confira comparação legível, confirmação antes de descarte e acessibilidade de cada escolha.
- Aceite quando conflito nunca sobrescreve silenciosamente, decisões usam a revisão remota atual e falhas mantêm a possibilidade de recuperar a edição local.

## Cenários de ativação — especificações ainda não executadas em agente

- **Direta:** “Use flutter-sync-conflicts para mostrar as duas versões quando a API retorna 409.”
- **Indireta:** “Duas pessoas editaram o mesmo item em celulares diferentes e a última atualização apagou a primeira.”
- **Não ativar:** “Mostre erro de campo obrigatório antes de salvar um formulário.”
