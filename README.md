# Trabalho 03 - Linux, Shell Script e Cloud Computing

## Aluno

**Guilherme Stein Zunino Sgrott**  
Instituicao: **Unidavi**

## Tema

**Sistema de Reservas para um Hotel**

## Descricao do Projeto

Este projeto simula a operacao Linux de uma aplicacao de reservas de hotel em um ambiente cloud containerizado. Um container Ubuntu executa o Apache e recebe um site estatico adaptado do Trabalho 02. Scripts Shell automatizam atualizacao do sistema, instalacao do servidor web, criacao de diretorios tematicos, backup, deploy, processos, monitoramento, usuarios, permissoes e relatorio operacional.

O professor pode construir e validar o ambiente apenas com os comandos deste README.

## Tecnologias Utilizadas

- Ubuntu 24.04
- Docker e Docker Compose
- Apache HTTP Server
- Shell Script (Bash)
- HTML, CSS e JavaScript
- GitHub e DockerHub

## Arquitetura

```text
Navegador
    |
    | http://localhost:8080
    v
Container trabalho03-linux (Ubuntu)
    |
    +-- Apache -> /var/www/html
    +-- Scripts -> /app/scripts
    +-- Site fonte -> /app/source
    +-- Logs -> /app/logs (mapeado para ./logs)
    +-- Backups -> /app/backups (mapeado para ./backups)
    +-- Dados -> /app/hotel/dados (volume Docker persistente)
```

## Estrutura do Projeto

```text
trabalho03-cloud-shell/
|-- Dockerfile
|-- docker-compose.yml
|-- docker-entrypoint.sh
|-- README.md
|-- scripts/
|   |-- 01_update.sh
|   |-- 02_apache.sh
|   |-- 03_estrutura.sh
|   |-- 04_backup.sh
|   |-- 05_deploy.sh
|   |-- 06_processos.sh
|   |-- 07_monitoramento.sh
|   |-- 08_usuarios_permissoes.sh
|   |-- 09_relatorio.sh
|   `-- menu.sh
|-- source/
|   |-- index.html
|   |-- sobre.html
|   `-- assets/
|       |-- app.js
|       `-- styles.css
|-- backups/
|-- logs/
|-- evidencias/
`-- relatorio-final/
```

## Como Executar

### Pre-requisitos

1. Instalar e iniciar o Docker Desktop.
2. Abrir um terminal na pasta `trabalho03-cloud-shell`.
3. Confirmar que a porta `8080` esta livre.

Se a porta estiver ocupada, defina outro valor para `APACHE_PORT` no arquivo `.env`, por exemplo `APACHE_PORT=8081`.

### Construir e iniciar

```bash
docker compose up -d --build
```

Validar o container:

```bash
docker compose ps
docker logs trabalho03-linux
```

Abrir um terminal Bash no container:

```bash
docker exec -it trabalho03-linux bash
```

Dentro do container:

```bash
cd /app/scripts
ls -l
./menu.sh
```

### Acessar o Apache

Abra no navegador:

```text
http://localhost:8080
```

Teste tambem pelo terminal:

```bash
curl http://localhost:8080
```

### Parar o ambiente

```bash
docker compose down
```

O comando acima preserva o volume. Para remover tambem os dados persistentes:

```bash
docker compose down -v
```

## Scripts Disponiveis

| Script | Descricao |
|---|---|
| `01_update.sh` | Executa `apt-get update` e `apt-get upgrade`, com log e validacao. |
| `02_apache.sh` | Instala o Apache, exibe a versao e verifica o processo. |
| `03_estrutura.sh` | Cria diretorios e arquivos de reservas, hospedes, quartos e dados. |
| `04_backup.sh` | Gera backup `.tar.gz` com data e hora. |
| `05_deploy.sh` | Limpa `/var/www/html`, publica `source/` e valida `index.html`. |
| `06_processos.sh` | Lista, busca ou encerra um processo por PID. |
| `07_monitoramento.sh` | Coleta CPU, RAM, disco e status do Apache, emitindo alertas. |
| `08_usuarios_permissoes.sh` | Cria `hotel_ops` e `reservas_user` e aplica `chown`/`chmod`. |
| `09_relatorio.sh` | Gera `/app/logs/relatorio_execucao.txt`. |
| `menu.sh` | Integra as rotinas em um menu interativo. |

Todos os scripts iniciam com `#!/bin/bash`, usam funcoes e possuem comentarios. As permissoes de execucao sao aplicadas durante o build. Se necessario:

```bash
chmod +x /app/scripts/*.sh
```

## Execucao Individual dos Scripts

Os comandos abaixo sao executados no computador e chamam os scripts dentro do container:

```bash
docker exec trabalho03-linux /app/scripts/01_update.sh
docker exec trabalho03-linux /app/scripts/02_apache.sh
docker exec trabalho03-linux /app/scripts/03_estrutura.sh
docker exec trabalho03-linux /app/scripts/04_backup.sh
docker exec trabalho03-linux /app/scripts/05_deploy.sh
docker exec trabalho03-linux /app/scripts/06_processos.sh listar
docker exec trabalho03-linux /app/scripts/06_processos.sh buscar apache
docker exec trabalho03-linux /app/scripts/07_monitoramento.sh
docker exec trabalho03-linux /app/scripts/08_usuarios_permissoes.sh
docker exec trabalho03-linux /app/scripts/09_relatorio.sh
```

O script `01_update.sh` pode levar alguns minutos, pois consulta os repositorios Ubuntu e atualiza os pacotes instalados.

Para testar o bloqueio de encerramento sem PID:

```bash
docker exec trabalho03-linux /app/scripts/06_processos.sh matar
```

Para encerrar um processo de teste, crie um processo temporario e use o PID exibido. Nao encerre o PID 1 nem processos do Apache durante a demonstracao:

```bash
docker exec trabalho03-linux bash -c "sleep 300 & echo \$!"
docker exec trabalho03-linux /app/scripts/06_processos.sh matar PID_EXIBIDO
```

## Menu Principal

O menu precisa de terminal interativo:

```bash
docker exec -it trabalho03-linux /app/scripts/menu.sh
```

As opcoes 01, 02 e 08 precisam de root. O `docker exec` utiliza root por padrao neste projeto.

## Diretorios Tematicos

O script `03_estrutura.sh` cria:

```text
/app/hotel/reservas
/app/hotel/hospedes
/app/hotel/quartos
/app/hotel/dados
/app/hotel/logs
/app/hotel/publicacao
/app/hotel/backups
```

Essa estrutura representa dados operacionais de reservas, cadastro de hospedes, controle de quartos, publicacao, logs e backups.

## Backup

Executar:

```bash
docker exec trabalho03-linux /app/scripts/04_backup.sh
```

Formato gerado:

```text
backups/backup_hotel_reservas_2026-06-15_16-30-00.tar.gz
```

Listar e inspecionar:

```bash
docker exec trabalho03-linux ls -lh /app/backups
docker exec trabalho03-linux tar -tzf /app/backups/NOME_DO_BACKUP.tar.gz
```

## Monitoramento e Alertas

Os limites padrao sao 80%. Eles podem ser alterados por variaveis de ambiente para demonstrar alertas:

```bash
docker exec -e LIMITE_CPU=0 -e LIMITE_MEMORIA=0 -e LIMITE_DISCO=0 trabalho03-linux /app/scripts/07_monitoramento.sh
```

## Usuarios e Permissoes

O script cria:

- Grupo: `hotel_ops`
- Usuario de sistema: `reservas_user`
- Diretorios operacionais: modo `2770`
- Diretorio base/publicacao: modo `2750`

O bit `2` ativa `setgid`, fazendo novos arquivos herdarem o grupo `hotel_ops`. O projeto nao utiliza `chmod 777`.

## Volume Persistente

Listar e inspecionar:

```bash
docker volume ls
docker volume inspect trabalho03_hotel_dados
```

Teste de persistencia:

```bash
docker exec trabalho03-linux bash -c "echo persistencia-ok > /app/hotel/dados/teste-volume.txt"
docker compose down
docker compose up -d
docker exec trabalho03-linux cat /app/hotel/dados/teste-volume.txt
```

## Evidencias

O roteiro completo de capturas esta em [`evidencias/README.md`](evidencias/README.md). As imagens precisam ser feitas na maquina do aluno e adicionadas ao repositorio antes da entrega.

## Publicacao no DockerHub

1. Criar uma conta/repository no DockerHub.
2. Copiar `.env.example` para `.env` e informar o usuario:

```bash
cp .env.example .env
```

No PowerShell:

```powershell
Copy-Item .env.example .env
```

Conteudo:

```env
DOCKERHUB_USERNAME=guilhermesteinn
```

3. Autenticar, construir e publicar:

```bash
docker login
docker compose build
docker compose push
```

4. Testar o download da imagem:

```bash
docker pull guilhermesteinn/trabalho03-hotel-shell:latest
```

**Link da imagem:** https://hub.docker.com/r/guilhermesteinn/trabalho03-hotel-shell

## Publicacao no GitHub

Crie um repositorio chamado `trabalho03-cloud-shell` e envie o conteudo desta pasta. Antes do push, confirme que `.env`, tokens e senhas nao foram incluidos.

**Link do repositorio:** adicionar apos a publicacao.

## Principais Dificuldades Encontradas

- Iniciar e validar o Apache dentro de um container que nao utiliza `systemd`.
- Proteger comandos de limpeza e encerramento de processos.
- Aplicar permissoes suficientes para a operacao sem recorrer a `chmod 777`.
- Manter dados, backups e logs persistentes fora da camada temporaria do container.

Revise esta secao e acrescente as dificuldades realmente observadas durante a execucao na sua maquina.

## Uso de Inteligencia Artificial

Foi utilizada a ferramenta ChatGPT/Codex como apoio na estruturacao dos scripts, revisao de comandos, documentacao e validacoes de seguranca. O aluno deve revisar, executar e compreender todas as funcoes, registrar os ajustes manuais realizados e estar preparado para explicar os comandos durante a avaliacao.

Principais aprendizados envolvidos:

- Funcoes, variaveis, parametros e codigos de saida em Bash.
- Diferenca entre imagem, container, bind mount e volume Docker.
- Publicacao de arquivos no DocumentRoot do Apache.
- Backup com `tar`, monitoramento com `/proc`, `free` e `df`.
- Processos com `ps`, `pgrep` e `kill`.
- Usuarios, grupos, `chown`, `chmod` e bit `setgid`.

## Roteiro Rapido para Correcao

```bash
git clone LINK_DO_REPOSITORIO
cd trabalho03-cloud-shell
docker compose up -d --build
docker compose ps
docker exec -it trabalho03-linux bash
cd /app/scripts
./menu.sh
```

Site:

```text
http://localhost:8080
```
