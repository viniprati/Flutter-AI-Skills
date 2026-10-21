---
name: flutter-data-sync
description: Implementa sincronização segura de alterações locais com uma API em Flutter. Use quando o app precisa enviar pendências, buscar mudanças remotas e retomar após falhas sem duplicar ou perder dados.
---

# Sincronização de dados

## Objetivo e acionamento

Faça dados locais e remotos convergirem com resultado verificável, inclusive após interrupção. Use em sync manual ou automática, fila de alterações e troca de dados entre aparelhos. Não a acione para uma chamada REST isolada que não mantém cópia local nem pendências.

## Antes de alterar

- Defina a fonte de verdade, chaves estáveis, revisão/`ETag`, contrato de criação/atualização/exclusão e política de tombstone.
- Levante quais dados são locais, compartilhados, privados por usuário, ou apenas catálogos; confira transações locais e endpoint de mudanças desde cursor.
- Confirme idempotência do servidor e o que significa uma resposta perdida. Não declare sync automática se só existe ação manual.

## Procedimento

1. Modele estados separados por item: `localOnly`, `pending`, `sending`, `synced`, `conflict` e `failed`; mantenha ID local e ID remoto/revisão mapeados. Registre a alteração pendente antes de tentar rede.
2. Para criação, gere ID/chave idempotente estável e persista-a antes do envio. Para atualização, envie revisão base; o servidor deve rejeitar revisão antiga (por exemplo, `409`/`412`) em vez de sobrescrever.
3. Bloqueie execuções simultâneas do mesmo ciclo. Persistência local deve concluir antes da primeira chamada. Envie pendências em ordem exigida por dependências; marque cada item sincronizado somente após resposta confirmada e persistida.
4. Após timeout ou resposta perdida, consulte por ID/chave idempotente e reconcilie o resultado antes de reenviar. Prossiga com outros itens quando o contrato permitir; reporte sucesso parcial e mantenha contagem exata de pendências.
5. Busque mudanças remotas por cursor/página até o fim e aplique-as sem substituir alterações locais divergentes. Registre revisão e baseline; encaminhe colisões para revisão de conflitos. Atualize “última sincronização concluída” somente após todo o ciclo exigido terminar.
6. Exponha à UI progresso, número pendente, horário, resultado parcial e ação de tentar novamente. Em `401`, pause e oriente login; em offline, preserve a fila. Evite loops infinitos de retry e backoff sem limite.

## Práticas e problemas comuns

- Não remova pendência ao iniciar uma requisição; a resposta pode não chegar.
- Apenas comparar timestamps de aparelhos não é detecção confiável de conflito; use revisão do servidor ou outro protocolo explícito.
- Uma sequência “envia tudo e baixa tudo” sem paginação ou cursor pode omitir dados quando a coleção cresce.
- Retentativa de `POST` sem ID estável pode criar duplicatas. Sincronização local por preferência simples pode exigir banco transacional conforme volume e risco.

## Validação e critérios de aceitação

- Com gateway falso, teste criação repetida, resposta perdida, interrupção entre envio e persistência, `409`, `401`, erro parcial e retomada após reinício.
- Teste dois clientes editando o mesmo registro. Confirme que nenhum dado local é descartado sem decisão explícita.
- Aceite quando uma tentativa repetida não duplica, pendências sobrevivem a falha/reabertura e o estado mostrado ao usuário corresponde ao que servidor e armazenamento confirmaram.

## Cenários de ativação — especificações ainda não executadas em agente

- **Direta:** “Use flutter-data-sync para sincronizar edições locais com a API.”
- **Indireta:** “Um pedido criado sem rede precisa aparecer no outro aparelho depois de tocar em Atualizar.”
- **Não ativar:** “Carregue uma lista remota somente para leitura ao abrir a página.”
