# Preview Architecture

## Objetivo

O preview permite visualizar no navegador do host projetos web executados dentro da VM Linux.

O servidor utiliza uma configuração única e não precisa ser reconfigurado para cada projeto.

## Fluxo

```text
/home/<DEV_USER>/workspaces/project-a
                    │
                    │ preview-control select project-a
                    ▼
/home/<DEV_USER>/preview/current
                    │
                    │ symbolic link
                    ▼
                  Caddy
                    │
                    ▼
                TCP 8080
                    │
                    ▼
               Host browser
```

## Symlink

O Caddy utiliza um caminho fixo como raiz:

```text
~/preview/current
```

Esse caminho é um link simbólico.

Quando outro projeto é selecionado, apenas o destino do link é alterado.

Exemplo inicial:

```text
preview/current
    ↓
workspaces/project-a
```

Depois:

```bash
preview-control select project-b
```

Resultado:

```text
preview/current
    ↓
workspaces/project-b
```

Não é necessário alterar o Caddyfile ou criar outro servidor.

## Caddy

Exemplo de configuração:

```caddyfile
{
    admin off
}

:8080 {
    bind 127.0.0.1 <VM_IP>

    root * /home/<DEV_USER>/preview/current

    file_server {
        hide .git .codex .env .env.* .DS_Store
    }
}
```

O bind é restrito ao localhost e ao endereço definido da VM.

A configuração não utiliza `0.0.0.0` como padrão.

## `systemd --user`

O Caddy é executado como serviço do usuário de desenvolvimento.

Exemplo:

```ini
[Service]
Type=simple

ExecStart=/usr/bin/caddy run --config=%h/.config/caddy/Caddyfile --adapter=caddyfile

Restart=on-failure
RestartSec=3

NoNewPrivileges=true
PrivateTmp=true
```

Isso permite:

- executar o servidor sem `root`;
- reiniciar o processo automaticamente em caso de falha;
- consultar estado pelo systemd;
- utilizar o journal para logs.

Comandos típicos:

```bash
systemctl --user status preview.service
systemctl --user restart preview.service
journalctl --user -u preview.service
```

## Linger

Serviços de usuário normalmente estão relacionados à sessão daquele usuário.

Quando o preview precisa iniciar junto com a VM, antes de qualquer login SSH, pode ser utilizado:

```bash
loginctl enable-linger <DEV_USER>
```

Isso permite que o user manager do systemd seja iniciado sem depender de uma sessão interativa.

O uso de `linger` deve ser consciente porque mantém os serviços daquele usuário disponíveis mesmo sem login.

## Wrapper

O wrapper expõe apenas operações específicas:

```text
preview-control status
preview-control start
preview-control stop
preview-control restart
preview-control current
preview-control select <project>
preview-control logs
```

Ele não oferece:

- shell arbitrário;
- seleção arbitrária de serviço;
- caminho arbitrário;
- execução de comandos fornecidos como parâmetro.

## Validação do projeto

O nome recebido em `select` é validado antes de qualquer alteração no symlink.

Formato aceito:

```text
letras
números
.
_
-
```

Exemplos válidos:

```text
project-a
client_site
demo.v2
```

Exemplos rejeitados:

```text
../
/etc
test;id
project name
```

Depois da validação do nome, o caminho é resolvido com `realpath`.

O caminho final precisa permanecer dentro de:

```text
~/workspaces/
```

Essa segunda verificação evita depender somente da expressão regular.

## Logs

Problemas podem ser investigados pelo wrapper:

```bash
preview-control status
preview-control logs
```

ou diretamente:

```bash
systemctl --user status preview.service
journalctl --user -u preview.service
```

## Validação local

Dentro da VM:

```bash
curl -I http://127.0.0.1:8080
```

Resultado esperado:

```text
HTTP/1.1 200 OK
```

No host:

```text
http://<VM_IP>:8080
```

Se o teste local funcionar e o host não conseguir conectar, verificar:

```text
firewall da VM
bind do Caddy
rede virtual
rota entre host e VM
```

## Limitação

Esse servidor foi projetado para desenvolvimento local.

Ele não substitui:

- servidor de produção;
- reverse proxy público;
- TLS de produção;
- autenticação da aplicação;
- controles de acesso necessários para exposição à Internet.
