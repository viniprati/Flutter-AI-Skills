---
name: flutter-offline-resilience
description: Torna fluxos Flutter úteis e honestos com rede ausente ou instável, usando cache, fila durável e repetição controlada. Use quando leitura ou edição deve continuar sem conexão e convergir depois.
---

# Resiliência offline

## Objetivo e acionamento

Defina exatamente o que continua possível sem rede e proteja as alterações até a conexão voltar. Use quando telas dependem de dados remotos, operações precisam ser enfileiradas ou falhas intermitentes interrompem o fluxo. Não ative para aumentar apenas o timeout de uma chamada sem requisito de experiência offline.

## Antes de alterar

- Liste operação por operação: leitura de cache, criação, edição, exclusão, login, pagamento e funções que precisam de autorização remota.
- Defina validade/escopo do cache, retenção, política de conflito, modelo de fila durável e limite de dados privados por conta.
- Verifique se a API suporta ID idempotente, revisão e consulta de estado após resposta perdida.

## Procedimento

1. Crie uma matriz de capacidade visível ao usuário: disponível offline, disponível com dados possivelmente antigos, ou requer conexão. Exiba “última atualização” e origem dos dados quando isso muda a decisão do usuário.
2. Para leitura, carregue cópia local validada enquanto atualiza em segundo plano quando possível; se não houver cópia, mostre estado vazio distinto de erro de rede. Não invente dados de exemplo como se fossem reais.
3. Para escrita offline permitida, confirme persistência local antes de mostrar “salvo neste aparelho”. Grave operação com ID estável, payload, revisão base, ordem/dependência e estado pendente. Não trate fila só em memória como suporte offline verdadeiro.
4. Ao reconectar, processe a fila com limite de concorrência, idempotência e backoff finito; pause em `401`/permissão e encaminhe `409` a resolução de conflito. Após resposta incerta, consulte o servidor antes de repetir mutação.
5. Mostre pendências, falhas permanentes e ação de tentar de novo. Se gravação local falhar, não deixe o usuário acreditar que o rascunho está protegido. Preserve capacidade de exportar/copiar entrada crítica quando apropriado.
6. Separe autenticação de cache: dados locais podem estar disponíveis depois de login anterior se a política permitir; isso não significa que o usuário consegue fazer login offline. Proteja dados privados e limpe o escopo correto no logout/troca de conta.

## Práticas e problemas comuns

- Indicador de conectividade não garante acesso à API; baseie resultado em requisições e estados reais.
- Repetir automaticamente toda mutação ao voltar a rede pode criar duplicatas ou executar ação antiga indesejada.
- `shared_preferences` pode servir a preferências/cache pequeno; fila grande e editável costuma exigir transações e consultas locais.
- Não chame “sincronizado” um registro apenas gravado no dispositivo; diferencie pendente, enviando, confirmado e conflito.

## Validação e critérios de aceitação

- Teste modo avião antes da abertura e no meio da gravação, fechamento/reabertura com pendências, resposta perdida, retorno de rede e troca de conta.
- Compare fila e servidor após retry; confirme ausência de duplicatas e preservação de rascunhos. Teste leitor de tela nos estados de offline e pendência.
- Aceite quando cada operação tem comportamento offline documentado, a UI descreve precisamente o estado dos dados e a fila sobrevive ao reinício sem perder nem duplicar alterações.

## Cenários de ativação — especificações ainda não executadas em agente

- **Direta:** “Use flutter-offline-resilience para permitir edição de pedidos sem internet.”
- **Indireta:** “No metrô, o app perde alterações quando o sinal cai; quero recuperá-las depois.”
- **Não ativar:** “Troque a animação do indicador de carregamento numa tela sempre online.”
