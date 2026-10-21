---
name: flutter-local-persistence
description: Implementa armazenamento local Flutter com serialização, evolução de esquema e recuperação de falhas. Use em preferências, cache, rascunhos ou dados locais que precisam sobreviver ao reinício.
---

# Persistência local

## Objetivo e acionamento

Grave e restaure dados no dispositivo sem perda silenciosa nem confusão com fonte remota. Use para preferências, rascunhos, cache e base local. Não acione para variáveis que só existem durante a tela e podem desaparecer sem efeito para o usuário.

## Antes de alterar

- Classifique volume, frequência de escrita, relações, necessidade de consulta/transação, sensibilidade, política de expiração e plataformas.
- Veja armazenamento já utilizado e sua versão; confirme se os dados precisam ser por usuário, conta ou URL de API.
- Defina esquema, chave, identificador estável e como lidar com versão desconhecida ou arquivo corrompido antes de migrar dados existentes.

## Procedimento

1. Use `shared_preferences` para configurações pequenas e não sensíveis; para coleções, consultas, alterações parciais e integridade transacional, escolha banco/armazenamento mais robusto compatível com o projeto. Tokens e senhas exigem armazenamento seguro apropriado.
2. Encapsule leitura/escrita atrás de interface testável. Inclua `schemaVersion` no dado serializado e valide tipos, IDs duplicados e campos obrigatórios ao carregar.
3. Decodifique tudo em objeto temporário. Só substitua o estado em memória após leitura e validação completas. Para migração, execute passos explícitos e preservadores; mantenha cópia ou estratégia de recuperação antes de converter dado único insubstituível.
4. Trate falha de leitura e gravação separadamente. Avise quando rascunho não foi salvo; não mostre indicador de “salvo” antes do `Future` terminar. Serialize escritas concorrentes ou use transação para evitar que uma gravação antiga sobrescreva outra recente.
5. Defina invalidação e exclusão por conta ao logout, retenção e privacidade. Nunca apague cache como primeira reação a esquema desconhecido sem avaliar perda de rascunhos.

## Práticas e problemas comuns

- Cache é cópia; identifique origem e última atualização. Persistência local, por si só, não é sincronização.
- Não suponha que escrita assíncrona sempre conclui ao fechar o app.
- Evite guardar um único JSON crescente em preferência simples quando o volume e a frequência exigem transação e consulta.
- Não grave senha, JWT ou chave privada em `shared_preferences`, código fonte ou log.

## Validação e critérios de aceitação

- Teste dado ausente, versão atual/antiga/desconhecida, JSON truncado, ID duplicado, falha de leitura/escrita e duas escritas próximas.
- Reabra o app em teste de integração quando a plataforma estiver disponível; unit tests com armazenamento em memória verificam apenas lógica, não o plugin nativo.
- Aceite quando restauração não aplica estado parcial, falhas são observáveis e dados sensíveis usam mecanismo adequado ou não são persistidos.

## Cenários de ativação — especificações ainda não executadas em agente

- **Direta:** “Use flutter-local-persistence para salvar rascunhos e restaurá-los ao abrir o app.”
- **Indireta:** “Ao reiniciar, as alterações somem; se o cache está corrompido, a tela fica vazia.”
- **Não ativar:** “Mantenha a seleção de aba só enquanto esta tela estiver aberta.”
