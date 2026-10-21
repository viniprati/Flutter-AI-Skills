# Como contribuir

Contribuições com correções técnicas, exemplos enxutos, acessibilidade e testes são bem-vindas. Abra uma issue para mudanças amplas e descreva o problema observado, público afetado e abordagem proposta.

## Ao criar ou alterar uma skill

1. Escolha uma tarefa específica e um nome em inglês, kebab-case, com até 64 caracteres. Verifique sobreposição com o [catálogo](README.md#catálogo-de-skills).
2. Escreva `skills/<nome>/SKILL.md` em português brasileiro. O frontmatter precisa de `name` idêntico à pasta e `description` que diga a ação e o contexto de ativação.
3. Inclua objetivo, quando usar e quando não usar, verificações prévias, passos de execução, práticas concretas, erros frequentes, segurança e acessibilidade quando relevantes, validação, critérios de aceite e exemplo de pedido.
4. Registre três cenários de ativação: pedido direto, pedido indireto e pedido que não deve selecionar a skill. Eles são especificações de teste até serem executados em agentes reais.
5. Coloque explicações extensas em `references/`; inclua código Dart apenas quando ele acrescentar um padrão que possa ser executado ou adaptado, com dependências explícitas. Não copie código, dados ou credenciais do Nativa.
6. Rode `python -m pip install -r requirements-dev.txt`, `python scripts/validate_skills.py` e `python -m unittest discover -s tests -v`. Para código Dart executável, rode análise e testes com uma versão Flutter compatível e relate resultados.

O validador verifica formato e integridade de arquivos. Revise também o comportamento esperado da skill com solicitações reais; a aprovação no validador não comprova qualidade da orientação nem compatibilidade automática em todos os clientes.

Ao enviar um pull request, explique o que mudou, o motivo, as verificações executadas e as limitações observadas. Não inclua dados pessoais, arquivos `.env` reais, segredos, chaves de assinatura ou instruções destrutivas sem controle explícito.
