# Secure AI Dev Environment

Ambiente Linux isolado para desenvolvimento assistido por IA, executado em uma VM Hyper-V e acessado a partir do Windows por SSH.

A implementação de referência utiliza Ubuntu Server, Git, Node.js, Codex, Caddy e `systemd --user`.

O objetivo é manter as ferramentas de desenvolvimento fora do host principal, limitar privilégios desnecessários e fornecer um fluxo simples para edição, execução e preview de projetos web.

## Objetivos

O ambiente foi criado com alguns requisitos definidos desde o início:

- manter runtimes e ferramentas de desenvolvimento dentro de uma VM Linux;
- evitar dependência de Node.js, Git e ferramentas Linux instaladas diretamente no Windows;
- utilizar VS Code no Windows através de Remote SSH;
- executar o agente de desenvolvimento com um usuário sem privilégios administrativos;
- limitar operações fora dos workspaces;
- disponibilizar preview HTTP dos projetos sem executar o servidor como `root`;
- manter o ambiente documentado e reproduzível;
- separar documentação pública de informações operacionais privadas.

## Arquitetura

```text
Windows Host
│
├── Hyper-V
├── VS Code
│   └── Remote SSH
│
└── Linux Development VM
    │
    ├── Administrative User
    │
    └── Development User
        │
        ├── Git
        ├── NVM / Node.js
        ├── Codex
        ├── workspaces/
        ├── Caddy
        ├── systemd --user
        └── preview-control
```

O Windows permanece responsável pelo hypervisor, pelo editor e pelo navegador.

Os projetos, runtimes e ferramentas de desenvolvimento permanecem dentro da VM Linux.

Mais detalhes:

- [Architecture](docs/architecture.md)
- [Security Model](docs/security-model.md)
- [Network Design](docs/network-design.md)
- [Development Workflow](docs/development-workflow.md)
- [Preview Architecture](docs/preview-architecture.md)
- [Recovery Strategy](docs/recovery-strategy.md)
- [Lessons Learned](docs/lessons-learned.md)

## Separação de usuários

A VM utiliza dois papéis distintos.

### Administrative user

Responsável por alterações no sistema operacional, por exemplo:

- instalação e atualização de pacotes;
- configuração de SSH;
- firewall;
- rede;
- manutenção do sistema.

### Development user

Utilizado no trabalho diário.

Esse usuário não recebe privilégios administrativos por padrão e executa:

- Git;
- Node.js;
- Codex;
- projetos;
- servidor de preview;
- ferramentas locais do workspace.

Essa separação evita executar ferramentas de desenvolvimento com privilégios elevados sem necessidade.

## Controle do agente

A configuração de referência utiliza:

```toml
approval_policy = "on-request"
sandbox_mode = "workspace-write"
approvals_reviewer = "user"
```

O agente pode trabalhar normalmente dentro do workspace.

Operações que ultrapassam esse limite continuam sujeitas aos controles definidos pelo agente e pelas permissões do sistema operacional.

O sandbox não substitui as permissões Linux. Os dois mecanismos são tratados como camadas diferentes.

## Preview dos projetos

O preview web é executado dentro da própria VM.

```text
workspace
    │
    ▼
symlink controlado
    │
    ▼
Caddy
    │
    ▼
systemd --user
    │
    ▼
porta HTTP da VM
```

Um wrapper controla qual projeto será servido.

Exemplo:

```bash
preview-control select project-a
preview-control current
preview-control status
```

O wrapper restringe a seleção aos projetos existentes dentro do diretório autorizado de workspaces.

## Por que `systemd --user`

O servidor de preview não precisa executar como `root`.

Ele é iniciado como serviço do próprio usuário de desenvolvimento através de `systemd --user`.

O uso opcional de `linger` permite iniciar esses serviços durante o boot da VM sem depender de uma sessão SSH interativa.

## Rede

A VM utiliza uma rede virtual isolada com NAT fornecido pelo host.

Este repositório não publica o endereçamento ou os parâmetros utilizados no ambiente operacional de origem.

Quando necessário, a documentação utiliza valores reservados para exemplos, como:

```text
192.0.2.0/24
```

## Segurança

As principais decisões aplicadas ao ambiente são:

- usuário de desenvolvimento sem `sudo`;
- SSH por chave;
- autenticação SSH por senha desabilitada após validação das chaves;
- firewall com regras restritas;
- sandbox do agente;
- preview executado como usuário não privilegiado;
- wrapper com validação de entrada e restrição de caminhos;
- separação entre documentação pública e Recovery Kit privado.

Consulte [Security Model](docs/security-model.md).

## Estrutura do repositório

```text
.
├── README.md
├── SECURITY.md
├── LICENSE
├── checklists/
├── docs/
└── examples/
    ├── caddy/
    ├── codex/
    ├── preview-wrapper/
    └── systemd/
```

Os arquivos em `examples/` foram preparados especificamente para publicação.

Eles não são cópias diretas das configurações utilizadas no ambiente privado.

## Exemplos disponíveis

### Codex

```text
examples/codex/config.toml.example
```

Configuração básica utilizando `workspace-write` e aprovação sob demanda.

### Caddy

```text
examples/caddy/Caddyfile.example
```

Servidor estático para preview utilizando bind restrito e diretório controlado.

### systemd

```text
examples/systemd/preview.service.example
```

Exemplo de serviço executado pelo próprio usuário de desenvolvimento.

### Preview wrapper

```text
examples/preview-wrapper/preview-control.example.sh
```

Wrapper responsável por selecionar projetos sem aceitar caminhos arbitrários.

## Escopo

Este projeto documenta:

- arquitetura do ambiente;
- separação entre host e VM;
- modelo de usuários;
- SSH;
- sandbox do agente;
- fluxo de desenvolvimento;
- preview com Caddy;
- `systemd --user`;
- estratégia de recuperação;
- decisões técnicas e problemas encontrados durante a implementação.

Não fazem parte deste repositório:

- credenciais;
- chaves privadas;
- tokens;
- arquivos de autenticação;
- exports de VM;
- discos virtuais;
- inventários do host;
- endereços internos reais;
- caminhos de backup;
- detalhes operacionais do ambiente privado.

## Implementação de referência

A implementação utilizada durante o desenvolvimento deste projeto foi baseada em:

```text
Windows 11
Hyper-V
Ubuntu Server
OpenSSH
Git
NVM
Node.js
Codex
Caddy
systemd
UFW
```

As versões exatas utilizadas durante a implementação representam uma baseline testada, não dependências permanentes.

Antes de uma nova instalação, versões suportadas e LTS devem ser verificadas novamente.

## Status

A arquitetura de referência foi implementada e validada.

Este repositório contém a documentação pública e exemplos sanitizados derivados desse trabalho.

Para uso em outro ambiente, os exemplos devem ser revisados e adaptados aos requisitos locais.
