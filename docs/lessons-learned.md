# Lessons Learned

Este documento registra problemas encontrados durante a implementação e as decisões adotadas.

## 1. Um switch virtual interno não fornece DHCP automaticamente

Ao criar uma rede virtual interna, a VM pode inicializar sem endereço IPv4.

Isso não significa necessariamente erro no Linux.

Foi necessário definir explicitamente:

- endereço da VM;
- gateway;
- DNS;
- NAT no host.

## 2. Default route precisa utilizar o prefixo correto

Uma configuração incorreta como:

```text
0.0.0.0/24
