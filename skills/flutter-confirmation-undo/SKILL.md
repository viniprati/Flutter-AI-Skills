---
name: flutter-confirmation-undo
description: Implementa confirmação, proteção contra ações repetidas e desfazer em fluxos Flutter. Use em exclusão, substituição, envio irreversível ou edições de rascunho que precisam de recuperação clara.
---

# Confirmação e desfazer

## Objetivo e acionamento

Proteja mudanças com risco real de perda e permita desfazer quando a operação é reversível. Use ao criar ou revisar exclusão, substituição, fechamento de rascunho e envio de mutações. Não apresente confirmação em ações triviais e reversíveis, como abrir uma tela, nem prometa desfazer uma operação sem mecanismo de restauração.

## Antes de alterar

- Classifique a ação: reversível só na UI, reversível no repositório, reversível no servidor, ou irreversível. Confirme janela de tempo, dependências e quem pode restaurar.
- Identifique persistência do rascunho, transações disponíveis, endpoint de restauração, proteção de concorrência e efeito de repetir a chamada.
- Confira texto e estilo atuais dos diálogos, navegação, foco e `ScaffoldMessenger`.

## Procedimento

1. Para ações destrutivas ou sem retorno seguro, mostre `AlertDialog` com objeto e consequência específicos. Use verbos distintos, por exemplo **Cancelar** e **Excluir registro**; deixe Cancelar como saída simples. Confirme explicitamente antes de sobrescrever trabalho concorrente.
2. Para mudanças apenas em rascunho, guarde uma cópia suficiente para restaurar estado e seleção. Mostre `SnackBar` com ação **Desfazer** e estabeleça quando a cópia deixa de existir (por exemplo, ao salvar ou sair). Se a ação expirar, não deixe o texto sugerir que continua disponível.
3. Execute a mutação somente depois da confirmação. Marque a operação como ocupada antes do primeiro `await`; desabilite botões, gestos equivalentes e fechamento que cause perda; libere o estado em `finally`.
4. Depois da resposta, atualize UI a partir do resultado persistido. Se a resposta se perdeu, consulte o estado ou use uma chave idempotente antes de repetir. Não reverta visualmente uma exclusão remota sem garantir que a restauração foi aplicada.
5. Se a mutação falhar, mantenha rascunho e ofereça ação coerente. Avise ao leitor de tela sobre confirmação, progresso e resultado; teste toque, teclado e botão Voltar.

## Práticas e problemas comuns

- Use confirmação apenas onde o custo de erro justifica uma interrupção; para edição simples, um desfazer confiável costuma ser mais fluido.
- Não use “Tem certeza?” sem nomear o item e o efeito. Não coloque **Excluir** como ação padrão de um diálogo.
- Evite dois caminhos para o mesmo envio que ignoram o mesmo indicador `busy`.
- Um `SnackBar` que só restaura a lista local após exclusão no servidor é uma falsa promessa de desfazer.

## Validação e critérios de aceitação

- Teste cancelar, confirmar, toque repetido rápido, falha de rede, saída/retorno da tela e desfazer dentro/fora da janela definida.
- Verifique que uma única mutação ocorre por decisão e que a mensagem de êxito depende de persistência confirmada.
- Aceite quando consequências são claras, ações destrutivas exigem decisão explícita, e qualquer **Desfazer** realmente restaura o estado correspondente.

## Cenários de ativação — especificações ainda não executadas em agente

- **Direta:** “Use flutter-confirmation-undo para confirmar exclusões e oferecer desfazer em rascunhos.”
- **Indireta:** “Um toque duplo cria duas compras e remover um item apaga tudo de imediato.”
- **Não ativar:** “Coloque uma transição ao abrir a aba de relatórios.”
