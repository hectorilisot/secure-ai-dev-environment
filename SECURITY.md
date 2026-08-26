# Security Policy

## Scope

Este repositório contém documentação e exemplos para construção de um ambiente isolado de desenvolvimento.

Os arquivos publicados são exemplos genéricos.

Eles devem ser revisados e adaptados antes de uso em outro ambiente.

## Reporting a security issue

Se identificar um problema de segurança nos scripts, exemplos ou configurações deste repositório, não publique credenciais, tokens, chaves ou dados sensíveis em uma issue pública.

Utilize um canal privado de contato com o mantenedor do repositório.

## Examples

Os exemplos deste projeto não devem ser tratados como configuração universal.

Antes de utilizar qualquer arquivo, revisar:

- endereçamento;
- usuários;
- permissões;
- firewall;
- serviços expostos;
- versões de software;
- requisitos do ambiente.

## Secrets

Nunca adicionar ao repositório:

- passwords;
- tokens;
- private keys;
- `.env`;
- authentication files;
- cookies;
- certificates containing private keys;
- exported sessions.

## Preview

O servidor de preview foi projetado para ambiente local de desenvolvimento.

Não expor a porta de preview diretamente à Internet sem implementar controles apropriados para o cenário.
