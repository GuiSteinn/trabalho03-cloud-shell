# Relatorio Final - Trabalho 03

## Identificacao

**Aluno:** Guilherme Stein Zunino Sgrott  
**Instituicao:** Unidavi  
**Tema:** Sistema de Reservas para um Hotel  
**Disciplina:** Cloud Computing

## 1. Introducao

Este trabalho apresenta um ambiente Linux containerizado para apoiar a operacao de um sistema de reservas de hotel. A proposta evolui o projeto do Trabalho 02 para incluir tarefas comuns de DevOps: preparacao do servidor, instalacao e validacao do Apache, deploy de arquivos estaticos, backup, monitoramento, gerenciamento de processos, controle de permissoes e geracao de relatorios.

## 2. Arquitetura do Ambiente

O ambiente utiliza uma imagem baseada no Ubuntu 24.04. O Docker Compose cria o container `trabalho03-linux`, publica a porta 80 do Apache na porta 8080 do computador e configura o volume persistente `trabalho03_hotel_dados`. As pastas `backups/` e `logs/` tambem sao mapeadas para o computador, facilitando a consulta das saidas.

Fluxo de acesso:

`Navegador -> localhost:8080 -> container Ubuntu -> Apache -> /var/www/html`

## 3. Automacoes Implementadas

Foram desenvolvidos nove scripts operacionais e um menu principal. As rotinas atualizam o Ubuntu, instalam e verificam o Apache, criam diretorios de reservas, hospedes e quartos, geram backups compactados, publicam o site, administram processos, monitoram recursos, criam o grupo `hotel_ops` e o usuario `reservas_user`, aplicam permissoes e consolidam um relatorio operacional.

Os scripts usam funcoes, variaveis, validacoes, mensagens compreensiveis e arquivos de log. As permissoes seguem o principio do menor privilegio, com modos `2750` e `2770`, sem uso de `chmod 777`.

## 4. Relacao com o Tema

A adaptacao ao tema aparece na estrutura `/app/hotel`, nos diretorios de reservas, hospedes e quartos, nos nomes do usuario e do grupo, nos arquivos de backup, nos logs, no relatorio e no portal publicado. O site estatico foi baseado no contexto funcional do sistema de reservas desenvolvido no Trabalho 02.

## 5. Testes Realizados

Registrar nesta secao, depois da execucao:

- Build e inicializacao do container.
- Acesso ao portal em `http://localhost:8080`.
- Execucao individual dos scripts 01 a 09.
- Execucao do menu interativo.
- Reinicio do container para validar a persistencia do volume.
- Criacao e inspecao de um backup `.tar.gz`.
- Publicacao e download da imagem no DockerHub.

## 6. Evidencias

As evidencias estao armazenadas na pasta `evidencias/` do repositorio. Cada arquivo deve ser associado aos itens da tabela presente em `evidencias/README.md`.

## 7. Dificuldades Encontradas

Durante a implementacao, as principais dificuldades foram adaptar o gerenciamento de servicos para um container sem `systemd`, proteger operacoes de limpeza e encerramento de processos e definir permissoes que permitissem a operacao do Apache sem liberar acesso excessivo. Essas situacoes foram tratadas com `apachectl`, validacao de caminhos, bloqueio de PIDs criticos e uso de grupo operacional.

> Revise este paragrafo e acrescente dificuldades que voce realmente encontrou durante a execucao na sua maquina.

## 8. Uso de Inteligencia Artificial

Foi utilizada a ferramenta ChatGPT/Codex como apoio na estruturacao inicial dos scripts, revisao de comandos, organizacao da documentacao e identificacao de validacoes de seguranca. O conteudo foi revisado e testado pelo aluno, que realizou os ajustes necessarios para o ambiente local e analisou o funcionamento de cada funcao antes da entrega.

Com esse processo, foram reforcados conhecimentos sobre Docker, Apache em containers, funcoes Shell, variaveis, logs, `tar`, `ps`, `pgrep`, `kill`, `chown`, `chmod`, usuarios de sistema e monitoramento por meio de `/proc`, `free` e `df`.

## 9. Links da Entrega

**GitHub:** adicionar link apos publicar.  
**DockerHub:** https://hub.docker.com/r/guilhermesteinn/trabalho03-hotel-shell

## 10. Conclusao

O ambiente criado demonstra como rotinas operacionais repetitivas podem ser padronizadas com Shell Script e Docker. A solucao permite que outra pessoa construa o container, acesse o site e valide as tarefas seguindo a documentacao do repositorio, aproximando o trabalho de uma rotina real de administracao Linux aplicada a cloud computing.
