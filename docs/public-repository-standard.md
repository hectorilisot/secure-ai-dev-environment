# Public Repository Standard

## Objetivo

Este documento define o padrão inicial utilizado para publicação de projetos técnicos no portfólio.

O padrão foi criado durante a preparação do repositório `secure-ai-dev-environment` e deve servir como referência para projetos futuros.

A regra principal é simples:

> Publicar conhecimento técnico sem publicar a infraestrutura operacional utilizada para produzi-lo.

## 1. Repositório público e repositório operacional são diferentes

Um repositório interno não deve ser convertido diretamente em público.

Quando o projeto de origem contém informações de operação, recuperação, infraestrutura ou segurança, a versão pública deve ser criada em um novo repositório.

Isso evita carregar:

- histórico Git antigo;
- arquivos removidos em commits anteriores;
- caminhos internos;
- inventários;
- metadados;
- configurações específicas do ambiente;
- informações que não deveriam fazer parte do portfólio.

O repositório público deve começar com histórico próprio.

## 2. Classificação do conteúdo

Antes da publicação, cada informação deve receber uma das classificações abaixo.

### PUBLICAR

Conteúdo que pode ser utilizado praticamente sem alteração.

Exemplos:

- conceitos técnicos;
- diagramas genéricos;
- decisões de arquitetura;
- comandos que não dependem do ambiente privado;
- explicações sobre ferramentas;
- exemplos criados especificamente para documentação.

### REESCREVER

Conteúdo tecnicamente útil, mas que contém detalhes específicos do ambiente original.

Exemplos:

- configurações;
- scripts;
- arquivos de serviço;
- regras de firewall;
- documentação de rede;
- procedimentos de instalação.

O conteúdo deve ser reescrito com valores genéricos antes da publicação.

### OMITIR

Informação que não agrega valor ao portfólio ou representa evidência operacional desnecessária.

Exemplos:

- dumps de comandos;
- inventários completos;
- arquivos temporários;
- logs;
- listas brutas de pacotes;
- evidências de QA utilizadas apenas durante a implementação.

### PRIVADO

Informação que não deve entrar no repositório público.

Exemplos:

- credenciais;
- tokens;
- chaves privadas;
- arquivos de autenticação;
- cookies;
- endereços internos reais;
- MAC addresses;
- serial de hardware;
- caminhos de backup;
- nomes de usuários pessoais;
- topologia operacional detalhada;
- exports de VM;
- VHDX;
- mecanismos internos de recuperação.

## 3. Naming

Os repositórios públicos devem utilizar nomes curtos e descritivos.

Não existe obrigação de adicionar prefixo de empresa em todos os projetos.

Preferir:

```text
secure-ai-dev-environment
microsoft365-security-baseline
network-troubleshooting-lab
linux-server-hardening
