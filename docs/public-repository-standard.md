# Public Repository Standard

## Objetivo

Este documento registra o padrão inicial utilizado para publicação de projetos técnicos no portfólio.

A regra principal é:

> Publicar conhecimento técnico sem publicar a infraestrutura operacional utilizada para produzi-lo.

## Repositório público e operacional são diferentes

Um repositório interno não deve ser convertido diretamente em público quando contém informações de operação, recovery ou infraestrutura.

A versão pública deve possuir histórico próprio.

Isso evita carregar:

- commits antigos;
- arquivos já removidos;
- caminhos internos;
- inventários;
- metadados;
- configurações específicas;
- detalhes que não pertencem ao portfólio.

## Classificação do conteúdo

Antes da publicação, o conteúdo deve ser classificado.

### PUBLICAR

Pode ser utilizado praticamente sem alteração.

Exemplos:

```text
conceitos técnicos
diagramas genéricos
decisões de arquitetura
comandos independentes do ambiente privado
exemplos produzidos para documentação
```

### REESCREVER

É tecnicamente útil, mas possui detalhes específicos do ambiente original.

Exemplos:

```text
configurações
scripts
systemd units
firewall
rede
procedimentos de instalação
```

O conteúdo deve ser generalizado antes da publicação.

### OMITIR

Não agrega valor ao portfólio ou representa evidência operacional desnecessária.

Exemplos:

```text
dumps de comandos
logs
inventários completos
arquivos temporários
evidências brutas de QA
listas de pacotes sem contexto
```

### PRIVADO

Não deve entrar no repositório público.

Exemplos:

```text
credenciais
tokens
private keys
arquivos de autenticação
cookies
IPs operacionais
MAC addresses
serial de hardware
caminhos de backup
topologia detalhada
exports de VM
discos virtuais
```

## Naming

Os nomes dos repositórios devem ser curtos e descritivos.

Não existe obrigação de utilizar prefixo de empresa.

Preferir:

```text
secure-ai-dev-environment
microsoft365-security-baseline
network-troubleshooting-lab
linux-server-hardening
```

Evitar:

```text
project-01
lab-test
repo-final
project-new
```

O nome deve informar o assunto ou problema tratado.

## README

Todo repositório público deve possuir um `README.md`.

No mínimo, deve explicar:

```text
objetivo
problema
arquitetura
tecnologias
decisões relevantes
escopo
limitações
estado atual
```

O README não deve ser escrito como material promocional.

Preferir:

```text
O preview roda como systemd --user para evitar execução do servidor como root.
```

em vez de:

```text
Foi implementada uma arquitetura moderna, segura e robusta.
```

## Estilo de escrita

A documentação deve ser técnica e direta.

Prioridades:

- explicar o que foi feito;
- explicar por que foi feito;
- registrar como validar;
- registrar limitações;
- diferenciar comportamento esperado de erro;
- utilizar comandos quando agregarem informação.

Evitar:

- excesso de adjetivos;
- linguagem promocional;
- frases genéricas;
- repetição;
- formalidade artificial;
- texto sem informação técnica.

## Valores de exemplo

Não utilizar valores do ambiente operacional original.

Usar placeholders:

```text
<DEV_USER>
<VM_IP>
<HOST_GATEWAY>
<VM_STORAGE_PATH>
<BACKUP_PATH>
```

Para redes de exemplo, utilizar blocos reservados para documentação.

Exemplo:

```text
192.0.2.0/24
```

## Configurações e scripts

Arquivos públicos devem ser independentes da infraestrutura de origem.

Antes de publicar:

1. remover caminhos específicos;
2. substituir usuários;
3. substituir endereços;
4. remover identificadores;
5. revisar comentários;
6. validar se o exemplo continua coerente.

## Histórico Git

O histórico público deve começar sanitizado.

Fluxo recomendado:

```text
private repository
        │
        ▼
classification
        │
        ▼
rewrite / sanitization
        │
        ▼
new directory
        │
        ▼
git init
        │
        ▼
audit
        │
        ▼
first public commit
```

Não reutilizar o `.git` do repositório privado.

## Segredos

O `.gitignore` é uma camada preventiva.

Ele não substitui auditoria.

Antes do primeiro commit, verificar:

```text
private keys
tokens
authentication files
.env
credentials
IPs
local paths
usernames
e-mails
internal names
```

A auditoria deve ocorrer antes do `git add` sempre que possível.

## Screenshots

Capturas de tela devem ser revisadas manualmente.

Verificar:

- username;
- hostname;
- IP;
- domínio;
- e-mail;
- caminhos;
- notificações;
- favoritos;
- identificadores;
- outras janelas ou abas.

Screenshots internos não devem ser publicados automaticamente.

## Estrutura

Um projeto pode utilizar:

```text
README.md
SECURITY.md
LICENSE
docs/
examples/
scripts/
diagrams/
checklists/
```

Nem todos os diretórios são obrigatórios.

A estrutura só deve existir quando houver conteúdo para ela.

## Commits

Commits públicos devem representar mudanças compreensíveis.

Preferir:

```text
docs: add architecture overview
docs: document security model
feat: add sanitized preview wrapper
docs: add publication checklist
```

Evitar:

```text
update
fix
final
changes
teste
commit 2
```

## Licença

A licença não deve ser escolhida automaticamente.

Ela deve ser definida conforme o conteúdo e o objetivo do projeto.

A decisão deve ocorrer antes da publicação definitiva.

## Segurança

Projetos que apresentam configurações, scripts ou hardening devem avaliar a necessidade de `SECURITY.md`.

O documento deve deixar claro que exemplos precisam ser adaptados antes de uso em outro ambiente.

## Validação antes da publicação

Antes do primeiro push, revisar o projeto como um terceiro.

Perguntas mínimas:

```text
O README explica o projeto sem contexto externo?

Os exemplos fazem sentido fora do ambiente original?

Existem valores privados?

Existem arquivos que só fazem sentido internamente?

Os comandos possuem contexto?

O histórico Git é novo?

O repositório pode permanecer público sem depender de remoções futuras?
```

## Critério de publicação

O push público só deve ocorrer depois de:

```text
conteúdo revisado
exemplos sanitizados
auditoria de segredos
auditoria de metadados
Markdown validado
README revisado
licença definida
git status revisado
histórico público separado
```

## Relação com documentação privada

O repositório público não substitui documentação operacional.

A documentação privada pode conter:

- procedimentos completos;
- parâmetros reais;
- inventários;
- evidências;
- caminhos;
- topologia;
- mecanismos de recovery.

A versão pública contém apenas o necessário para explicar o projeto e permitir que os conceitos sejam aplicados em outro ambiente.
