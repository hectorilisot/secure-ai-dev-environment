# Network Design

## Objetivo

A VM de desenvolvimento precisa acessar Internet, Git e repositórios de pacotes, mas não precisa ficar diretamente conectada à rede física principal.

A arquitetura utiliza uma rede virtual interna com NAT fornecido pelo host.

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
```

O host funciona como gateway da rede virtual.

A VM utiliza um endereço privado e acessa redes externas através do NAT.

## Exemplo de endereçamento

Os valores abaixo são apenas exemplos:

```text
Virtual network: 192.0.2.0/24
Host gateway:    192.0.2.1
Development VM:  192.0.2.10
```

O bloco `192.0.2.0/24` é reservado para documentação e não representa a rede utilizada no ambiente original.

## Endereço estático

Um endereço previsível facilita:

- SSH;
- VS Code Remote SSH;
- acesso ao preview;
- regras de firewall;
- validações automatizadas.

Exemplo conceitual de Netplan:

```yaml
network:
  version: 2
  ethernets:
    <INTERFACE>:
      dhcp4: false
      addresses:
        - 192.0.2.10/24
      routes:
        - to: 0.0.0.0/0
          via: 192.0.2.1
      nameservers:
        addresses:
          - 1.1.1.1
          - 8.8.8.8
```

O nome da interface deve ser identificado no sistema.

Não assumir `eth0` em todas as instalações.

## Default route

Uma rota default IPv4 utiliza:

```text
0.0.0.0/0
```

Um prefixo como:

```text
0.0.0.0/24
```

não representa uma rota default e pode impedir conectividade externa.

## Validação

Verificar interface e rota:

```bash
ip -br addr
ip route
```

Testar conectividade IP:

```bash
ping -c 4 1.1.1.1
```

Testar DNS:

```bash
getent hosts example.com
```

Testar HTTPS:

```bash
curl -I https://example.com
```

Esses testes verificam camadas diferentes.

Falha de ICMP contra o gateway não deve ser utilizada isoladamente como diagnóstico de falha de NAT, pois o host pode bloquear ping por firewall.

## Serviços de entrada

O firewall da VM deve liberar apenas os serviços necessários.

Neste projeto:

```text
SSH
Preview HTTP
```

Quando possível, as regras devem restringir também a origem permitida.

## Exposição

O preview foi criado para comunicação entre host e VM.

Ele não deve ser publicado diretamente na Internet sem revisão específica de:

- firewall;
- TLS;
- autenticação;
- reverse proxy;
- arquivos expostos;
- aplicação servida.
