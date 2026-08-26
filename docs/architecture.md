# Architecture

## Objetivo

Este projeto utiliza uma VM Linux dedicada para concentrar as ferramentas de desenvolvimento e execução assistida por IA.

O host Windows permanece responsável pelo hypervisor, editor gráfico e navegador.

O código-fonte, runtimes, Git, agente e servidor de preview permanecem dentro da VM Linux.

## Visão geral

```text
Windows Host
│
├── Hyper-V
│
├── VS Code
│   └── Remote SSH
│
└── Linux Development VM
    │
    ├── Administrative User
    │
    └── Development User
        │
        ├── Git
        ├── NVM / Node.js
        ├── AI Development Agent
        ├── workspaces/
        ├── Caddy
        ├── systemd --user
        └── preview-control
```

## Responsabilidades do host

O host não é tratado como ambiente principal de desenvolvimento.

Ele fornece:

- Hyper-V;
- administração da VM;
- VS Code;
- navegador;
- acesso SSH;
- armazenamento externo para backups.

O objetivo é evitar que diferentes stacks de desenvolvimento sejam distribuídas entre Windows e Linux sobre o mesmo working tree.

## Responsabilidades da VM

A VM concentra:

- sistema operacional Linux;
- Git;
- runtimes;
- dependências;
- agente de desenvolvimento;
- projetos;
- ferramentas de QA;
- servidor de preview.

Os working trees permanecem no filesystem Linux.

Exemplo:

```text
/home/<DEV_USER>/workspaces/
```

O Windows acessa esses diretórios através do VS Code Remote SSH.

## Separação de usuários

A arquitetura utiliza dois papéis.

### Administrative user

Possui privilégios administrativos e é utilizado apenas quando uma mudança no sistema exige isso.

Exemplos:

```text
instalação de pacotes
configuração de SSH
firewall
rede
manutenção do sistema
```

### Development user

Utilizado para trabalho diário.

Não possui privilégios administrativos por padrão.

Executa:

```text
Git
Node.js
Codex
projetos
Caddy
systemd --user
wrappers locais
```

A separação reduz a necessidade de executar ferramentas de desenvolvimento com privilégios elevados.

## Rede

A VM utiliza uma rede virtual com NAT fornecido pelo host.

A implementação pública não depende de uma sub-rede específica.

Exemplo documental:

```text
Virtual network: 192.0.2.0/24
Host gateway:    192.0.2.1
Development VM:  192.0.2.10
```

O bloco `192.0.2.0/24` é reservado para documentação.

## Preview

O preview roda dentro da própria VM.

```text
Host browser
     │
     ▼
VM HTTP port
     │
     ▼
Caddy
     │
     ▼
preview/current
     │
     ▼
selected workspace
```

O caminho servido pelo Caddy permanece constante.

A seleção do projeto é feita alterando um symlink controlado.

## Git

Os repositórios de desenvolvimento são manipulados pelo Git instalado na VM.

Isso evita utilizar Git do Windows diretamente sobre os mesmos working trees Linux.

## Princípio de arquitetura

A divisão adotada pode ser resumida como:

```text
Windows = host e interface

Linux VM = ambiente de desenvolvimento

Development user = execução diária

Administrative user = manutenção do sistema
```

O objetivo não é tornar a arquitetura complexa, mas deixar explícita a responsabilidade de cada camada.
