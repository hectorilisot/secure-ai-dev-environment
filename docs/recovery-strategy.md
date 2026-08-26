# Recovery Strategy

## Objetivo

Este documento descreve os princípios utilizados para recuperação do ambiente sem publicar os procedimentos operacionais do ambiente original.

## Git não é backup completo

Git protege:

- histórico do código;
- documentação;
- scripts versionados.

Git não protege sozinho:

- sistema operacional da VM;
- pacotes instalados;
- configurações não versionadas;
- credenciais;
- estado do hypervisor;
- dados fora dos repositórios.

Por isso são utilizadas camadas diferentes.

## Camadas de recuperação

Modelo conceitual:

```text
Working tree
    │
    ▼
Local Git history
    │
    ▼
Private Git remote
    │
    ▼
Independent local copy
    │
    ▼
VM backup/export
