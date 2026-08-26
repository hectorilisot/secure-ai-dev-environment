# Development Workflow

## Objetivo

O fluxo diário mantém o código e as ferramentas dentro da VM Linux.

O Windows é utilizado como interface.

## Início da sessão

O host inicia a VM pelo Hyper-V.

Após o boot, validar SSH:

```text
Host
  │
  ▼
SSH
  │
  ▼
Development VM
