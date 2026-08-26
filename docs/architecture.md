# Architecture

## Objetivo

Este projeto utiliza uma VM Linux dedicada para concentrar ferramentas de desenvolvimento e execução assistida por IA.

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
