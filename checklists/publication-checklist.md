# Public Repository Publication Checklist

Esta checklist deve ser executada antes do primeiro push público e novamente após alterações relevantes.

## 1. Conteúdo

- [ ] O README explica o projeto sem depender de contexto privado.
- [ ] A arquitetura está descrita de forma genérica.
- [ ] Os exemplos foram escritos ou revisados especificamente para publicação.
- [ ] Não existem dumps brutos usados apenas durante troubleshooting.
- [ ] Não existem evidências internas de QA.
- [ ] Não existem arquivos temporários ou backups.

## 2. Credenciais e autenticação

Confirmar ausência de:

- [ ] senhas;
- [ ] tokens;
- [ ] API keys;
- [ ] cookies;
- [ ] arquivos `.env`;
- [ ] `auth.json`;
- [ ] private keys;
- [ ] certificados privados;
- [ ] `authorized_keys`;
- [ ] sessões autenticadas.

Verificação básica:

```bash
grep -RniE -- \
  'password|passwd|token|secret|api[_-]?key|auth\.json|authorized_keys' \
  . \
  --exclude-dir=.git \
  || true
