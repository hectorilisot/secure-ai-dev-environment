# Security Model

## Objetivo

O modelo de segurança não depende de um único mecanismo.

As proteções são distribuídas entre diferentes camadas:

```text
virtualização
+
usuários Linux
+
SSH
+
firewall
+
sandbox do agente
+
restrições do preview
```

Cada camada possui uma função diferente.

## Isolamento por VM

As ferramentas de desenvolvimento não executam diretamente no host Windows.

O ambiente Linux permanece dentro de uma VM dedicada.

Esse isolamento não elimina todos os riscos, mas reduz o acesso direto das ferramentas de desenvolvimento ao sistema principal.

## Menor privilégio

O usuário de desenvolvimento não recebe `sudo` por padrão.

As ferramentas executadas nessa sessão utilizam as permissões desse usuário.

Operações administrativas permanecem separadas em outra conta.

Isso reduz a quantidade de comandos do fluxo diário que podem modificar o sistema operacional.

## SSH

O acesso remoto deve utilizar autenticação por chave.

Sequência recomendada:

```text
criar chave
↓
instalar chave pública
↓
testar nova sessão
↓
validar acesso
↓
desabilitar autenticação por senha
```

A autenticação por senha não deve ser removida antes da validação do acesso por chave.

## Firewall

A VM deve utilizar uma política restritiva para conexões de entrada.

Somente os serviços necessários precisam ser liberados.

Neste projeto, os principais exemplos são:

```text
SSH
Preview HTTP
```

As regras devem ser adaptadas à rede utilizada.

## Sandbox do agente

A implementação de referência utiliza:

```toml
approval_policy = "on-request"
sandbox_mode = "workspace-write"
approvals_reviewer = "user"
```

O objetivo é permitir operações normais dentro do workspace sem conceder acesso irrestrito ao restante do ambiente.

O sandbox não substitui as permissões Linux.

Um arquivo que seja legível pelo usuário Linux pode continuar sendo legível pelo processo.

Por isso, o controle também depende da separação de usuários e das permissões do sistema operacional.

## Preview sem privilégios administrativos

O Caddy utilizado para preview executa como usuário de desenvolvimento.

O processo é gerenciado por:

```text
systemd --user
```

Não existe necessidade de executar esse servidor como `root`.

A unit também utiliza:

```ini
NoNewPrivileges=true
PrivateTmp=true
```

Essas opções reduzem privilégios e isolam o diretório temporário do serviço.

## Seleção controlada de projetos

O servidor não recebe diretamente um caminho arbitrário.

Um wrapper controla a seleção do projeto.

Exemplo permitido:

```bash
preview-control select project-a
```

Exemplos rejeitados:

```text
../
/etc
test;id
```

O wrapper verifica:

- formato do nome;
- existência do diretório;
- caminho resultante após `realpath`;
- permanência dentro do diretório autorizado de workspaces.

Essa validação evita path traversal e reduz a superfície disponível para command injection.

## Arquivos não publicados pelo preview

O servidor também pode ocultar arquivos que não deveriam ser expostos através do file server.

Exemplos:

```text
.git
.codex
.env
.env.*
```

Essa regra é uma proteção adicional.

Arquivos sensíveis não devem ser mantidos em diretórios públicos apenas porque existe uma regra de ocultação.

## Segredos

Não devem entrar no repositório:

- private keys;
- tokens;
- arquivos de autenticação;
- cookies;
- `.env`;
- certificados privados;
- sessões autenticadas;
- credenciais.

O `.gitignore` é preventivo.

Ele não substitui auditoria antes de commits públicos.

## Limitações

Este projeto representa um ambiente controlado de desenvolvimento.

Ele não deve ser tratado como sandbox de alta garantia.

Dependendo do cenário, podem ser necessários controles adicionais, como:

- segmentação de rede;
- VMs descartáveis;
- containers;
- políticas de saída de rede;
- secrets management;
- monitoramento;
- políticas adicionais do hypervisor.

O nível de isolamento deve acompanhar o risco do trabalho executado.
