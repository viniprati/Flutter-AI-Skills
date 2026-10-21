---
name: flutter-clean-architecture
description: Separa apresentação, regras de negócio e acesso a dados em apps Flutter sem criar camadas desnecessárias. Use ao estruturar funcionalidades, reduzir acoplamento ou tornar regras e integrações testáveis.
---

# Separar responsabilidades em Flutter

## Objetivo

Definir fronteiras claras para que regras de negócio possam ser testadas sem widgets e a interface não dependa de detalhes de HTTP ou armazenamento.

## Quando usar

Ao criar uma funcionalidade com regras e fontes de dados, reorganizar telas que fazem requisições diretamente ou reduzir dependências circulares.

## Quando não usar

Para um ajuste visual local ou um aplicativo pequeno sem integração nem regras significativas. Não imponha pastas, casos de uso e interfaces para cada operação simples.

## Verificar antes

- Mapeie pastas, imports, serviços, modelos, fontes de dados, estado e testes existentes.
- Identifique quais regras precisam funcionar sem Flutter e quais contratos externos podem variar.
- Verifique padrões e dependências já aceitos pelo projeto; preserve interfaces públicas quando possível.

## Procedimento

1. Desenhe o fluxo da funcionalidade: widget recebe estado e eventos; controlador/ViewModel coordena; domínio decide; repositório/gateway executa I/O.
2. Mova validação e cálculo determinístico para funções ou objetos de domínio sem `BuildContext`, HTTP ou persistência.
3. Defina um contrato de repositório somente onde a troca de implementação ou o teste isolado justificarem a abstração. Faça a implementação de dados depender do contrato, com serialização e erros de infraestrutura fora do domínio.
4. Faça a apresentação receber dependências por construtor ou composição no ponto de entrada; não instancie clientes de rede em widgets.
5. Migre um fluxo por vez, mantendo testes de comportamento e evitando renomeações em massa sem ganho funcional.

## Boas práticas

Direção preferida: `ui -> domain <- data` quando há contrato no domínio; a composição liga as implementações. Um app simples pode usar `ui -> repository` diretamente e ainda manter regras puras. Use nomes que expressem o negócio do app, não o domínio de um exemplo externo.

## Erros comuns

- Colocar toda a lógica no ViewModel e chamar isso de arquitetura em camadas.
- Fazer modelos de domínio conhecerem JSON, `Response` ou `BuildContext`.
- Criar interfaces que apenas repetem uma classe sem fronteira concreta.

## Segurança e acessibilidade

Autorização e regras sensíveis também devem ser verificadas pelo servidor; separação no cliente não cria barreira de segurança. Preserve informações necessárias para estados acessíveis de carregamento, erro e sucesso na camada de apresentação.

## Validação

Execute análise estática e testes de domínio sem iniciar Flutter UI ou serviços externos; teste o controlador com repositório falso e uma tela crítica com widget test. Procure imports indevidos de `ui/` ou `data/` em `domain/` e ciclos entre camadas.

## Critérios de aceitação

Regras principais estão fora dos widgets, integrações têm fronteira clara, falhas são convertidas em estados de UI compreensíveis e os fluxos preservam comportamento anterior. O número de camadas corresponde à complexidade real.

## Cenários de ativação

Especificações de teste de ativação, ainda não executadas em agente compatível:

- **Direta:** “Use flutter-clean-architecture para separar tela, regras e API deste cadastro.”
- **Indireta:** “Meu widget faz cálculo, chama HTTP e salva cache; preciso testá-lo sem servidor.”
- **Não ativa:** “Troque o ícone da barra superior sem alterar o fluxo.”
