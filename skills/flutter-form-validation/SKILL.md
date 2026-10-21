---
name: flutter-form-validation
description: Implementa validação consistente de entradas em formulários Flutter, incluindo formato, limites e checagens assíncronas. Use quando dados inválidos passam pela interface ou mensagens de campos não refletem as regras reais.
---

# Validação de formulários

## Objetivo e acionamento

Faça cada entrada ser interpretada e validada de modo consistente antes do envio. Use em cadastros, filtros com restrições, login e edição de dados. Não acione para validar exclusivamente regras de negócio sem interação de formulário; nesse caso, use a skill de regras de domínio.

## Antes de alterar

- Levante o contrato do backend: campos obrigatórios, limites, formatos, normalização, unicidade e códigos de erro.
- Identifique locale, teclado esperado, máscara, `TextInputFormatter`, estado do rascunho e comportamento de foco da tela.
- Separe regras sincronizáveis no cliente das que exigem consulta remota ou autorização do servidor.

## Procedimento

1. Defina uma função pura para cada regra reaproveitada. Normalize sem destruir a entrada necessária ao usuário: por exemplo, `trim()` em identificador textual, mas não altere silenciosamente senhas.
2. Ligue funções síncronas ao `Form`/`TextFormField.validator`; faça a mensagem indicar a correção (“Informe um valor entre 1 e 50”), não apenas “Inválido”. Use `keyboardType`, autofill e formatação compatíveis com o campo.
3. No envio, chame `FormState.validate()` uma vez, destaque o primeiro campo inválido e leve foco/rolagem até ele. Preserve os valores. Trate campos opcionais vazios distintamente de zero ou valor malformado.
4. Faça checagem assíncrona (por exemplo, identificador já usado) fora do `validator` síncrono. Debounce e cancelamento/versão da requisição evitam aplicar resposta antiga. Indique “verificando” e permita nova tentativa em falha de rede.
5. Envie dados tipados e normalizados ao repositório. Repita no backend as regras que protegem integridade e autorização; mapeie respostas `400`/`422` para os campos quando o contrato permitir.

Exemplo Dart sem dependência externa, para entrada inteira não negativa:

```dart
String? validarQuantidade(String? texto) {
  final valor = int.tryParse(texto?.trim() ?? '');
  if (valor == null) return 'Informe uma quantidade inteira.';
  if (valor < 0) return 'A quantidade não pode ser negativa.';
  return null;
}
```

## Práticas e problemas comuns

- Máscara e `keyboardType` ajudam a digitar; não substituem validação.
- Cuidado com `double.tryParse` em dinheiro ou quantidades discretas e com separador decimal do locale.
- Não bloqueie permanentemente o formulário porque uma validação assíncrona falhou; distinga indisponibilidade de valor inválido.
- Evite regras divergentes entre campo, ViewModel e servidor; mantenha uma fonte explícita para os limites no cliente.

## Validação e critérios de aceitação

- Teste vazio, espaços, limite inferior/superior, caracteres inesperados, valores opcionais e retorno remoto atrasado/fora de ordem.
- Em widget test, verifique primeira falha, foco, mensagem e preservação dos campos após rejeição da API.
- Aceite quando toda regra local tem caso válido/inválido verificável, o servidor continua autoridade para gravação e erros são legíveis com teclado e leitor de tela.

## Cenários de ativação — especificações ainda não executadas em agente

- **Direta:** “Use flutter-form-validation no cadastro, inclusive unicidade assíncrona.”
- **Indireta:** “O campo quantidade aceita letras e a API só reclama depois que envio.”
- **Não ativar:** “Calcule o total de um pedido já tipado, sem tela de formulário.”
