# Preview Architecture

## Objetivo

O preview permite visualizar projetos web executados dentro da VM Linux a partir do navegador no host.

O servidor não deve exigir configuração manual para cada projeto.

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
