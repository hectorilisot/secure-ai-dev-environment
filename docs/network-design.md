# Network Design

## Objetivo

A VM de desenvolvimento precisa de acesso à Internet para instalação de pacotes, Git e ferramentas externas, mas não precisa fazer parte diretamente da rede física principal.

A implementação utiliza uma rede virtual interna com NAT no host.

## Modelo

```text
Internet
   │
   ▼
Windows Host
   │
   ├── Physical Network
   │
   └── Virtual NAT
          │
          ▼
    Development VM
