---
name: flutter-error-feedback
description: Cria mensagens de erro úteis e acessíveis para formulários, login, rede, API, permissões e armazenamento em Flutter. Use quando uma falha deixa o usuário sem saber o que aconteceu ou como prosseguir.
---

# Feedback de erros em Flutter

## Objetivo e acionamento

Transforme falhas técnicas em informação compreensível, com a próxima ação viável e sem perder o trabalho do usuário. Use esta skill ao implementar ou revisar estados de erro em telas e fluxos assíncronos. Não a acione para mera troca de cor ou texto decorativo sem comportamento de falha; para regras de entrada, use a skill de validação de formulários.

## Antes de alterar

- Localize a origem da falha e o contrato da operação: validação local, `401`, `403`, `409`, `429`, timeout, falta de conexão, `5xx`, leitura ou gravação local.
- Verifique se a operação foi aplicada no servidor antes de oferecer **Tentar novamente**. Resposta perdida não significa que a gravação falhou.
- Confira o estado já digitado, os controles de foco, o padrão de erros do projeto e se há informações privadas em exceções ou logs.

## Procedimento

1. Separe erro técnico de mensagem ao usuário. Mapeie exceções/status a uma categoria tipada na camada de dados ou no ViewModel; mantenha causa e código para diagnóstico sem exibir corpo bruto da resposta.
2. Para cada categoria, escreva **o que ocorreu**, **o efeito sobre os dados** quando conhecido e **a ação possível**. Exemplo: “Não foi possível enviar agora. Seu rascunho continua neste aparelho. Confira a conexão e tente novamente.” Evite afirmar que o rascunho está salvo antes de confirmar a gravação local.
3. Use erro próximo ao campo para validação; mensagem persistente na tela para bloqueios de fluxo; `SnackBar` apenas para feedback breve que pode desaparecer. Em falha de autenticação, não revele se uma conta específica existe.
4. Preserve `TextEditingController`, seleção e rascunho ao falhar. Desative apenas a ação que não pode prosseguir; ofereça recuperação contextual, como corrigir campo, entrar novamente, abrir permissões ou reenviar.
5. Ao receber `401`, encerre ou renove a sessão conforme o contrato; para `409`, encaminhe à revisão de versões; para `429`, respeite o prazo informado pelo servidor. Não repita automaticamente mutações sem garantia de idempotência.
6. Defina mensagens legíveis por leitores de tela (`Semantics`/componentes nativos) e leve o foco ao resumo ou primeiro campo inválido quando o usuário submete um formulário. Mantenha o aviso visível com texto ampliado.

## Práticas e problemas comuns

- Prefira uma categoria estável, por exemplo `network`, `unauthorized`, `conflict`, `invalidInput`, `storage`, `server`, `unknown`, a decisões por comparação do texto de exceções.
- Registre código, operação e ID de correlação; remova senha, token, resposta sensível e entrada pessoal dos logs.
- Não substitua todo erro por “Algo deu errado”. Não atribua uma falha de servidor à conexão do usuário sem evidência.
- Não mostre “Salvo com sucesso” se apenas uma escrita local está pendente ou se a resposta remota se perdeu.

## Validação e critérios de aceitação

- Simule cada categoria no gateway/repositório; verifique mensagem, ação oferecida e estado do formulário após falha e nova tentativa.
- Teste timeout após envio com resposta incerta, `401`, `409`, `429` e erro de armazenamento. Confira que a UI não cria duas operações.
- Com leitor de tela e texto ampliado, confirme que o erro é anunciado e sua ação pode ser alcançada.
- Aceite quando toda falha relevante tem efeito e recuperação explícitos, dados digitados permanecem disponíveis, e nenhuma mensagem ou log expõe detalhe sensível.

## Cenários de ativação — especificações ainda não executadas em agente

- **Direta:** “Use flutter-error-feedback para melhorar os erros de login, rede e gravação do meu app.”
- **Indireta:** “Quando a API cai, o usuário só vê um spinner e perde o formulário; corrija isso.”
- **Não ativar:** “Mude o ícone da tela inicial e alinhe o título.”
