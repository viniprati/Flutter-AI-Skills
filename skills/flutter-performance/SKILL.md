---
name: flutter-performance
description: Investiga e corrige lentidão, quadros perdidos, reconstruções, listas, imagens e memória em Flutter. Use quando houver sintoma mensurável de desempenho ou meta de desempenho definida.
---

# Desempenho Flutter

## Objetivo e uso

Encontre o gargalo e confirme a melhoria por medida comparável. Use para travamentos, rolagem lenta, consumo crescente de memória e tarefas assíncronas que bloqueiam a interface. Não ative para uma mudança visual sem indício de desempenho.

## Antes de alterar

Anote dispositivo, plataforma, modo de execução, tela, conjunto de dados e sequência reproduzível. Compare com a mesma versão e condições. Consulte DevTools Performance/Memory em mobile ou desktop; para Web, use o painel Performance do Chrome DevTools. Faça perfil em `flutter run --profile -d ID` em dispositivo adequado. Métricas de debug não representam release.

## Procedimento

1. Reproduza e capture duração dos quadros, trilha de CPU, reconstruções e memória. Relacione o pico com uma ação específica; estabeleça medida inicial.
2. Se houver reconstruções amplas, reduza a área que observa estado, separe widgets, preserve identidades quando fizer sentido e use `const` onde aplicável. Verifique pela ferramenta se o número de rebuilds caiu.
3. Para listas longas, use `ListView.builder`/`SliverList` e paginação quando o volume exigir. Evite montar todos os itens e todos os dados de gráficos em um único quadro.
4. Para imagens, entregue dimensões adequadas e verifique cache/decodificação; libere controladores e ouvintes em `dispose`. Para trabalho pesado de CPU, avalie isolate/`compute` quando a medida justificar; para I/O, use operações assíncronas sem bloquear `build`.
5. Refaça a captura na mesma ação e compare quadros lentos, tempo de CPU, memória e comportamento funcional. Guarde o antes/depois no relatório.

## Erros comuns, segurança e acessibilidade

Não espalhe `const`, isoles ou cache sem medir efeito. Cache de dados privados precisa de política de expiração e proteção. Não remova rótulos, estados de carregamento ou conteúdo textual acessível de gráficos para ganhar quadros. Não esconda falhas de rede atrás de indicador infinito.

## Validação e aceite

Execute testes das telas alteradas, `flutter analyze` e um novo perfil no mesmo dispositivo/cenário. Aceite quando a métrica que motivou o trabalho melhorar sem regressão funcional; se não houver dispositivo, registre a limitação e não declare ganho de runtime comprovado.

## Especificações de ativação (ainda não executadas em agente)

- Direta: “Use flutter-performance para investigar quadros perdidos na lista.”
- Indireta: “A tela congela ao abrir mil registros e a memória continua subindo.”
- Não ativar: “Traduza o botão Salvar para inglês.”

Referências: [desempenho Flutter](https://docs.flutter.dev/perf), [renderização](https://docs.flutter.dev/perf/rendering-performance) e [DevTools Performance](https://docs.flutter.dev/tools/devtools/performance).
