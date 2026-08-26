# Lessons Learned

Este documento registra problemas encontrados durante a implementação e as decisões tomadas a partir deles.

## 1. Rede virtual interna não implica DHCP

Uma rede virtual interna pode iniciar sem fornecer endereço IPv4 para a VM.

Isso não significa necessariamente problema no Linux.

Foi necessário definir explicitamente:

```text
endereço da VM
gateway
DNS
NAT no host
```

## 2. Default route precisa usar o prefixo correto

Uma configuração como:

```text
0.0.0.0/24
```

não cria uma rota default IPv4.

A rota correta utiliza:

```text
0.0.0.0/0
```

Uma rota incorreta pode gerar:

```text
Network is unreachable
```

mesmo quando o endereço local da interface está correto.

## 3. Ping do gateway não é diagnóstico suficiente

ICMP pode ser bloqueado por firewall.

A validação de conectividade deve verificar separadamente:

```text
conectividade IP
DNS
HTTPS
```

Exemplo:

```bash
ping -c 4 1.1.1.1
getent hosts example.com
curl -I https://example.com
```

## 4. SSH por senha só deve ser removido depois da chave ser validada

Sequência utilizada:

```text
configurar chave
↓
testar nova sessão
↓
manter sessão administrativa atual aberta
↓
validar configuração do SSH server
↓
desabilitar autenticação por senha
↓
testar novamente
```

Isso reduz o risco de perder acesso à VM por erro de configuração.

## 5. Ferramentas de desenvolvimento não precisam de acesso administrativo

Git, Node.js, agente e servidor de preview podem executar sem `sudo`.

Separar o usuário administrativo do usuário de desenvolvimento reduz privilégios no fluxo diário.

## 6. Sandbox do agente e permissões Linux são controles diferentes

Um sandbox com escrita limitada ao workspace não representa necessariamente isolamento total de leitura.

O modelo precisa considerar:

```text
sandbox
+
permissões Linux
+
separação de usuários
```

## 7. Preview não precisa executar como root

Caddy pode rodar como serviço do próprio usuário de desenvolvimento.

`systemd --user` fornece:

- gerenciamento do processo;
- restart;
- logs;
- inicialização controlada.

Não é necessário criar um serviço privilegiado apenas para preview local.

## 8. Linger permite iniciar serviços de usuário sem login

Quando um serviço de usuário precisa iniciar junto com a VM:

```bash
loginctl enable-linger <DEV_USER>
```

permite que o user manager do systemd seja iniciado antes de uma sessão SSH interativa.

Esse comportamento deve ser ativado conscientemente.

## 9. Symlink simplifica a seleção do projeto

O servidor aponta sempre para:

```text
preview/current
```

O wrapper altera somente o destino desse link.

Isso evita:

- alterar o Caddyfile;
- trocar portas;
- criar serviços diferentes para cada projeto.

## 10. Wrapper funciona como fronteira de controle

Permitir que uma ferramenta escolha qualquer diretório ampliaria desnecessariamente a interface disponível.

O wrapper foi limitado a:

```text
status
start
stop
restart
current
select
logs
```

A seleção verifica:

- nome;
- existência do projeto;
- caminho resolvido;
- diretório raiz permitido.

## 11. Checkpoints acumulados complicam a cadeia de discos

Checkpoints geram discos diferenciais.

Após remover um checkpoint, o hypervisor ainda pode precisar de algum tempo para concluir a consolidação.

Durante esse processo, o disco ativo pode continuar aparecendo como diferencial.

A ação correta é aguardar e verificar o estado.

O arquivo diferencial não deve ser apagado manualmente.

## 12. Repositório público deve possuir histórico próprio

Remover alguns IPs ou caminhos de um repositório privado não é sanitização suficiente.

O histórico Git anterior pode continuar contendo dados removidos.

O fluxo adotado foi:

```text
private repository
↓
content classification
↓
rewrite and sanitization
↓
new directory
↓
new Git history
↓
audit
↓
publication
```

Além de reduzir o risco de exposição, isso produz documentação melhor para quem não conhece o ambiente original.

## 13. Markdown também precisa de validação

Durante a primeira publicação, alguns arquivos Markdown foram truncados porque um bloco de código externo continha outros blocos com o mesmo delimitador.

O conteúdo parecia correto durante a preparação, mas os arquivos terminaram com code fences abertas.

A correção foi adicionar uma validação explícita da quantidade de fences antes do commit.

Documentação também faz parte do QA do projeto.
