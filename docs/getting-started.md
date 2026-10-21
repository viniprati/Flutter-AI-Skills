# Primeiros passos

## 1. Escolha a tarefa

Comece pelo problema observável no seu aplicativo. Para uma tela que corta texto ampliado, examine [flutter-adaptive-fonts](../skills/flutter-adaptive-fonts/SKILL.md) e [flutter-responsive-layout](../skills/flutter-responsive-layout/SKILL.md). Para criar uma integração nova, escolha [flutter-rest-api](../skills/flutter-rest-api/SKILL.md); se houver cópia local e fila de alterações, acrescente [flutter-data-sync](../skills/flutter-data-sync/SKILL.md). O [catálogo completo](../README.md#catálogo-de-skills) explica a finalidade de cada pasta.

## 2. Instale no aplicativo

Siga o [guia de instalação](installation.md) e copie apenas os diretórios escolhidos para `.agents/skills/` (Codex) ou `.claude/skills/` (Claude Code) **dentro do projeto Flutter**. Confira que cada pasta contém `SKILL.md` e quaisquer recursos citados por ele. Abra o cliente na raiz do aplicativo e verifique a lista de skills; o clone da biblioteca em outro diretório não basta para a descoberta.

## 3. Dê contexto e peça uma mudança verificável

Um pedido útil informa o comportamento desejado, o que já existe e como confirmar o resultado. Por exemplo:

> Use `$flutter-accessible-forms` no formulário de cadastro. Preserve os campos e a arquitetura atuais. Os erros devem ser anunciados, o primeiro campo inválido deve receber foco, e o formulário deve funcionar com teclado aberto e texto a 200%. Mostre os testes executados e o que ainda depende de teste em aparelho.

Para uma tarefa que cruza responsabilidades, indique a sequência e os critérios:

> Use `flutter-domain-rules` para isolar o cálculo de totais; em seguida, `flutter-testing` para cobrir quantidade zero, limites e soma inconsistente. Só depois adapte a tela. Registre quais casos passaram.

O agente deve inspecionar as dependências e regras existentes antes de alterar o código. Exemplos das skills são padrões de trabalho, não substitutos para o contrato real da API ou para os requisitos do seu produto.

## 4. Confira a entrega

Leia o diff, execute `flutter analyze` e os testes relevantes no projeto, e confira os critérios de aceite da skill usada. Para acessibilidade, complemente a automação com inspeção em dispositivo e leitor de tela. Para FCM, um envio aceito pelo serviço ainda não prova entrega no aparelho. Para Android, build bem-sucedido ainda não comprova instalação e funcionamento.

Quando o agente não tiver Flutter, emulador, credenciais de teste ou acesso ao backend, peça que separe o que verificou do que permanece pendente. Não use dados ou segredos de produção para preencher essa lacuna.
