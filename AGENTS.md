# Instruções para agentes colaboradores

Este repositório distribui procedimentos reutilizáveis, não um aplicativo Flutter. Mantenha cada skill independente do Nativa e em português brasileiro, com nomes oficiais de APIs em inglês. Antes de alterar uma skill, leia seu `SKILL.md` e os recursos locais que ela indicar.

Cada diretório em `skills/` deve conter `SKILL.md` com frontmatter compatível com [Agent Skills](https://agentskills.io/specification): `name` igual ao diretório e `description` que diga o que fazer e quando ativar. Escreva passos que o agente consiga executar e validar. Preserve os cenários de ativação direta, indireta e negativa. Use `references/` ou `examples/` apenas quando forem necessários e ligados a partir da skill.

O [Nativa](https://github.com/viniprati/nativa-app) é referência somente para leitura. Não copie credenciais, dados pessoais ou arquivos do aplicativo. Não declare testes em dispositivo ou entrega de notificações como concluídos sem evidência. Confirme autorização específica antes de instruir operações destrutivas em dados ou ambientes de produção.

Depois de mudanças, execute `python scripts/validate_skills.py` e `python -m unittest discover -s tests -v` após instalar `requirements-dev.txt`. Para exemplos Dart executáveis, rode `dart format`, `flutter analyze` e os testes pertinentes quando o SDK estiver disponível. Registre o que não pôde ser executado.
