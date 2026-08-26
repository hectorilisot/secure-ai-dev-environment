# Public Repository Publication Checklist

Esta checklist deve ser executada antes do primeiro push público e novamente após alterações relevantes.

## Conteúdo

- [ ] README compreensível sem contexto privado.
- [ ] Arquitetura descrita de forma genérica.
- [ ] Exemplos revisados para publicação.
- [ ] Sem dumps de troubleshooting desnecessários.
- [ ] Sem evidências internas de QA.
- [ ] Sem arquivos temporários ou backups.

## Credenciais e autenticação

Confirmar ausência de:

- [ ] passwords;
- [ ] tokens;
- [ ] API keys;
- [ ] cookies;
- [ ] `.env`;
- [ ] `auth.json`;
- [ ] private keys;
- [ ] certificados privados;
- [ ] `authorized_keys`;
- [ ] sessões autenticadas.

Busca básica:

```bash
grep -RniE \
  --exclude-dir=.git \
  -- \
  'password|passwd|token|secret|api[_-]?key|auth\.json|authorized_keys' \
  . \
  || true
```

Cabeçalhos de private keys:

```bash
grep -RniE \
  --exclude-dir=.git \
  -- \
  '-----BEGIN (OPENSSH|RSA|EC|DSA|PRIVATE) PRIVATE KEY-----' \
  . \
  || true
```

Resultados precisam ser revisados manualmente.

Documentação pode conter palavras como `password` sem conter uma senha real.

## Infraestrutura privada

Confirmar ausência de:

- [ ] IPs operacionais;
- [ ] MAC addresses;
- [ ] serial de hardware;
- [ ] hostname privado;
- [ ] nomes internos de VMs;
- [ ] usernames pessoais;
- [ ] caminhos reais de discos;
- [ ] caminhos reais de backup;
- [ ] domínios internos;
- [ ] identificadores de recursos;
- [ ] topologia operacional.

Preferir:

```text
<DEV_USER>
<VM_IP>
<HOST_GATEWAY>
<VM_STORAGE_PATH>
<BACKUP_PATH>
192.0.2.0/24
```

## Git

- [ ] Repositório público possui histórico próprio.
- [ ] `.git` privado nunca foi copiado.
- [ ] Não existem branches importadas do privado.
- [ ] `git status` foi revisado.
- [ ] Arquivos ignorados foram revisados.

Executar:

```bash
git status --untracked-files=all
```

## Scripts

Para scripts:

- [ ] parâmetros documentados;
- [ ] entradas validadas;
- [ ] sem `eval` sem justificativa;
- [ ] caminhos privados removidos;
- [ ] sem comandos destrutivos desnecessários;
- [ ] privilégios administrativos não assumidos sem necessidade.

Para shell scripts:

```bash
bash -n caminho/do/script.sh
```

## Configurações

Antes de publicar:

```text
Caddyfile
systemd units
SSH configs
firewall
Codex configs
```

confirmar:

- [ ] usuários generalizados;
- [ ] IPs generalizados;
- [ ] caminhos generalizados;
- [ ] nomes internos removidos;
- [ ] comentários revisados;
- [ ] limitações documentadas.

## Screenshots

Antes de adicionar imagens:

- [ ] revisar username;
- [ ] revisar hostname;
- [ ] revisar IP;
- [ ] revisar e-mail;
- [ ] revisar caminhos;
- [ ] revisar outras janelas;
- [ ] revisar notificações;
- [ ] revisar identificadores.

Screenshots internos não devem ser publicados automaticamente.

## Markdown

Verificar code fences:

```bash
for file in README.md checklists/*.md docs/*.md; do
    [ -f "$file" ] || continue

    count=$(grep -c '^```' "$file")

    if (( count % 2 != 0 )); then
        printf 'BROKEN  %-45s fences=%s\n' "$file" "$count"
    else
        printf 'OK      %-45s fences=%s\n' "$file" "$count"
    fi
done
```

Todos os arquivos devem retornar `OK`.

Também revisar:

```bash
git diff --check
```

ou, depois do staging:

```bash
git diff --cached --check
```

## Documentação

- [ ] texto técnico e direto;
- [ ] sem linguagem promocional;
- [ ] decisões possuem justificativa;
- [ ] limitações explícitas;
- [ ] comportamento esperado diferenciado de erro;
- [ ] comandos possuem contexto.

## Licença

- [ ] licença escolhida conscientemente;
- [ ] aplicação da licença revisada;
- [ ] nenhum arquivo recebeu licença automaticamente sem decisão.

## Revisão final

Antes do push:

```bash
git status
git diff --cached --name-status
git diff --cached --stat
git diff --cached --check
```

O repositório só deve ser publicado quando puder permanecer público sem depender da remoção posterior de informações.
