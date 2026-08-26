# Development Workflow

## Objetivo

O fluxo diário mantém código, Git, runtimes e ferramentas de desenvolvimento dentro da VM Linux.

O Windows é utilizado como interface para edição, administração e navegação.

## Início da sessão

O host inicia a VM pelo Hyper-V.

Depois do boot, a conectividade SSH deve ser validada.

```text
Windows Host
     │
     ▼
    SSH
     │
     ▼
Development VM
```

O VS Code conecta utilizando Remote SSH.

Os projetos permanecem no filesystem Linux:

```text
/home/<DEV_USER>/workspaces/
```

## Abrir um projeto

Na VM:

```bash
cd ~/workspaces/<PROJECT>
```

Antes de iniciar alterações:

```bash
git status
```

Isso permite confirmar:

- branch atual;
- alterações pendentes;
- arquivos não rastreados.

## Preview

Selecionar o projeto:

```bash
preview-control select <PROJECT>
```

Confirmar:

```bash
preview-control current
```

Verificar o serviço:

```bash
preview-control status
```

O navegador do host acessa:

```text
http://<VM_IP>:8080
```

## Agente de desenvolvimento

O agente deve ser iniciado dentro do diretório do projeto.

Exemplo:

```bash
cd ~/workspaces/<PROJECT>
codex
```

Isso mantém o contexto do workspace associado ao projeto correto.

## Git

O Git utilizado nos projetos é o Git instalado dentro da VM.

O fluxo básico permanece:

```bash
git status
git diff
git add <files>
git commit
```

Operações remotas:

```bash
git fetch
git pull
git push
```

utilizam as credenciais configuradas no usuário Linux.

Não é necessário manipular o mesmo working tree com uma instalação Git do Windows.

## Administração

Operações que exigem privilégios administrativos ficam fora do fluxo normal de desenvolvimento.

Exemplos:

```text
instalação de pacotes do sistema
firewall
SSH server
rede
atualizações do sistema operacional
```

O usuário de desenvolvimento não recebe privilégios administrativos apenas por conveniência.

## Encerramento

Antes de finalizar a sessão:

```bash
git status
```

Verificar:

- arquivos modificados;
- arquivos não rastreados;
- commits ainda não enviados;
- branch atual.

A VM pode permanecer ligada ou ser desligada de forma limpa pelo sistema operacional.

Desligamento forçado pelo hypervisor não deve ser o procedimento normal.
