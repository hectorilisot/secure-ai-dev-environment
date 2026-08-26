# Secure AI Dev Environment

Ambiente Linux isolado para desenvolvimento assistido por IA, executado em uma VM Hyper-V e acessado a partir do Windows por SSH.

A implementação de referência utiliza Ubuntu Server, Git, Node.js, Codex, Caddy e `systemd --user`.

O objetivo do projeto é separar o ambiente de desenvolvimento do host principal, reduzir privilégios desnecessários e manter um fluxo simples para edição, execução e preview de projetos web.

## Objetivo

A arquitetura foi criada para atender alguns requisitos específicos:

- manter ferramentas de desenvolvimento dentro de uma VM Linux;
- evitar dependência de runtimes instalados diretamente no Windows;
- permitir acesso pelo VS Code usando Remote SSH;
- executar o agente de desenvolvimento com um usuário sem privilégios administrativos;
- limitar operações fora do workspace;
- disponibilizar preview HTTP dos projetos sem expor um shell privilegiado;
- manter configuração documentada e reproduzível;
- separar documentação pública de dados operacionais do ambiente real.

## Arquitetura

```text
Windows Host
│
├── Hyper-V
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
        ├── Node.js / NVM
        ├── Codex
        ├── workspaces/
        │
        ├── Caddy
        ├── systemd --user
        └── preview wrapper

## Estrutura do repositório
.
├── README.md
├── SECURITY.md
├── LICENSE
├── docs/
├── examples/
│   ├── caddy/
│   ├── codex/
│   ├── preview-wrapper/
│   └── systemd/
└── checklists/
