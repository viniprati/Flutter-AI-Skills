---
name: flutter-accessible-forms
description: Constrói ou corrige formulários Flutter com rótulos persistentes, teclado e autocompletar adequados, erros anunciados e foco no primeiro campo inválido. Use em cadastros e login difíceis de preencher em tela pequena.
---

# Criar formulários acessíveis

## Objetivo

Permitir preencher, corrigir e enviar um formulário sem perder dados, foco ou ações quando texto cresce ou teclado abre.

## Quando usar

Ao implementar login/cadastro ou corrigir campos sem rótulo, erros difíceis de localizar, foco perdido e botão encoberto pelo teclado.

## Quando não usar

Para validar uma regra de negócio sem interação de formulário; use a skill de validação/domínio apropriada. Não use esta skill para reformar telas que não capturam entrada.

## Verificar antes

Leia modelo dos dados, regras de validação, `Form`/`TextFormField`, `FocusNode`, rolagem, `MediaQuery.viewInsetsOf`, mascaramento, autocompletar e formatos enviados à API. Identifique campos sensíveis e ordem lógica.

## Procedimento

1. Use `Form` e campos com `InputDecoration.labelText` persistente (`floatingLabelBehavior: FloatingLabelBehavior.always` se a composição exigir), texto claro de obrigatoriedade e `helperText` para exemplo/formato.
2. Escolha `keyboardType`, `textInputAction`, `autofillHints`, autocorreção e capitalização por tipo de dado. Configure foco entre campos em ordem lógica; não avance automaticamente durante digitação sem pedido do usuário.
3. Mantenha controllers/foco com ciclo de vida definido e não apague valores após falha de validação, rede ou servidor. Separe mensagem do campo de mensagem geral de envio.
4. Ao enviar, valide os campos; use `FormState.validateGranularly()` quando disponível ou registro explícito da primeira falha. Após o frame, leve foco ao primeiro campo inválido e use `Scrollable.ensureVisible` para mostrá-lo, sem saltos repetidos a cada tecla.
5. Coloque o conteúdo em rolagem que funcione com `SafeArea` e teclado; adapte linhas de campos a colunas em larguras estreitas ou com fonte ampliada. Desabilite envio duplicado durante operação assíncrona.

## Boas práticas

Rótulo identifica o dado mesmo quando há valor; hint é exemplo, não substituto do rótulo. Mensagens dizem o que corrigir. Máscara visual não muda o valor de domínio sem conversão explícita. Validar no cliente melhora experiência; backend continua responsável pelas regras e autorização.

## Erros comuns

- Mostrar erro somente por cor ou ícone.
- Focar campo fora da tela sem rolar, ou rolar antes de o erro ser renderizado.
- Usar teclado numérico para identificador que pode conter zeros iniciais e tratá-lo como número.

## Segurança e acessibilidade

Senhas devem usar `obscureText` e autocompletar apropriado; não registrar seus valores em logs. Não exponha entrada privada em mensagens de erro ou semântica redundante. Preserve alvos de toque, leitura de rótulo/erro e saída clara de diálogos.

## Validação

Em widget tests, envie vazio, confira erro e foco no primeiro campo, corrija e envie; simule teclado, largura compacta e fonte de 200%, verificando rolagem e dados preservados após falha. Percorra manualmente teclado e leitor de tela em dispositivo disponível.

## Critérios de aceitação

Campos têm rótulo e obrigatoriedade identificáveis, entrada e autocomplete adequados, primeiro erro visível/focado, valores mantidos em falhas e botão alcançável com teclado aberto. Testes de cliente não são apresentados como prova de validação de servidor.

## Cenários de ativação

Especificações de teste de ativação, ainda não executadas em agente compatível:

- **Direta:** “Use flutter-accessible-forms para criar meu formulário de cadastro.”
- **Indireta:** “Depois de tocar em Salvar, a pessoa não sabe qual campo errou e o teclado cobre o botão.”
- **Não ativa:** “Valide a regra de desconto no backend sem alterar a interface.”
