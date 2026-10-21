---
name: flutter-screen-reader
description: Corrige leitura e navegação com TalkBack, VoiceOver e tecnologias assistivas em Flutter. Use para rótulos, papéis, ordem de leitura, cabeçalhos, estados, alertas e controles personalizados.
---

# Tornar telas legíveis por leitor de tela

## Objetivo

Fazer cada ação, conteúdo essencial e mudança importante ser anunciada na ordem certa, sem duplicações ou controles sem nome.

## Quando usar

Quando leitores de tela não identificam ícones, cards, gráficos ou estados, ou quando uma tela personalizada precisa de navegação sem visão.

## Quando não usar

Para mudar apenas contraste ou tamanho de fonte sem problema semântico. Não substitua widgets nativos acessíveis por `Semantics` customizado sem necessidade.

## Verificar antes

Mapeie jornada, árvore de widgets, foco, ações por gesto, componentes Material/Cupertino usados e idiomas. Confirme dispositivos/plataformas disponíveis para teste real.

## Procedimento

1. Percorra a tela como uma sequência de tarefas. Identifique cada elemento focável e o anúncio esperado: nome, papel, valor, estado e ação.
2. Prefira botões, campos, switches e navegação nativos. Em componente customizado, adicione `Semantics` com rótulo e propriedades apropriadas; use `MergeSemantics` ou `ExcludeSemantics` somente após conferir que nenhum conteúdo ou ação desaparece.
3. Marque cabeçalhos, seleção, expansão, desabilitação e agrupamentos; mantenha ordem de leitura coerente com a ordem visual e de foco. Rotule ícones interativos e retire duplicidade de imagens decorativas.
4. Para erro, sucesso ou atualização assíncrona relevante, exponha mensagem visível e anúncio oportuno (`Semantics(liveRegion: true)` quando apropriado). Evite anúncios repetidos em cada reconstrução.
5. Dê alternativa textual a gráficos e gestos exclusivos; revise diálogos, navegação de retorno e foco após fechar um overlay.

## Boas práticas

Escreva rótulos que indiquem a ação ou o valor, não “botão” sem contexto. Deixe estados automáticos dos controles nativos ativos. Teste com idioma real da interface e conteúdo variável.

## Erros comuns

- Adicionar `Semantics(label: ...)` em volta de um botão nativo e criar anúncio duplicado.
- Excluir semântica de um subtree que contém ação essencial.
- Confundir teste de árvore semântica com percurso em TalkBack/VoiceOver.

## Segurança e acessibilidade

Não anuncie token, senha ou conteúdo privado em tela bloqueada. Quando houver mensagens de erro, descreva correção possível sem ler detalhes internos do servidor.

## Validação

Execute widget tests com semântica habilitada para nomes, papéis e estados. Faça roteiro manual no TalkBack e VoiceOver, quando os alvos forem suportados, registrando aparelho, SO, ordem e problemas encontrados. Se não houver dispositivo, marque a verificação real como pendente; consulte a [API Semantics](https://api.flutter.dev/flutter/widgets/Semantics-class.html).

## Critérios de aceitação

Todas as ações essenciais têm anúncio compreensível, ordem e foco permitem concluir a jornada, estados/erros são comunicados e não há anúncio duplicado relevante. A evidência separa teste automatizado de teste com leitor real.

## Cenários de ativação

Especificações de teste de ativação, ainda não executadas em agente compatível:

- **Direta:** “Use flutter-screen-reader para revisar esta tela com TalkBack e VoiceOver.”
- **Indireta:** “O usuário ouve ‘botão sem rótulo’ no calendário e não sabe qual dia está selecionado.”
- **Não ativa:** “Aumente somente o contraste das bordas dos campos.”
