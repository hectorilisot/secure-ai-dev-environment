# Recovery Strategy

## Objetivo

Este documento descreve a estratégia de recuperação em nível conceitual.

Os procedimentos operacionais, caminhos, parâmetros e detalhes do ambiente real permanecem em documentação privada.

## Git não é backup completo

Git protege:

- código;
- histórico;
- documentação;
- scripts versionados.

Git não protege sozinho:

- sistema operacional da VM;
- pacotes instalados;
- configurações não versionadas;
- credenciais;
- configuração do hypervisor;
- dados fora dos repositórios.

Por isso são utilizadas camadas diferentes.

## Modelo

```text
Working tree
    │
    ▼
Local Git history
    │
    ▼
Private Git remote
    │
    ▼
Independent local copy
    │
    ▼
VM backup or export
```

Cada camada cobre tipos diferentes de falha.

## Recovery Kit privado

Configurações necessárias para reconstrução podem ser mantidas em um repositório privado.

Esse material pode conter informações que não devem fazer parte do portfólio público.

Exemplos:

- parâmetros reais;
- caminhos;
- inventários;
- topologia;
- procedimentos completos de reconstrução;
- informações específicas do host.

O repositório público não substitui esse Recovery Kit.

## Cópia independente

Documentação e arquivos importantes devem possuir pelo menos uma cópia fora do disco da VM.

Isso reduz dependência de um único dispositivo físico.

## Export da VM

Quando o hypervisor oferece mecanismo de export, ele pode ser utilizado como camada adicional.

Antes do export:

- desligar a VM corretamente;
- verificar estado dos discos virtuais;
- verificar checkpoints;
- evitar cadeias desnecessárias de discos diferenciais.

## Checkpoints

Checkpoint é mecanismo temporário de rollback.

Ele não deve ser tratado como backup.

Manter checkpoints por muito tempo pode gerar:

- discos diferenciais;
- maior consumo de espaço;
- cadeias de dependência;
- recuperação mais complexa.

Quando um checkpoint deixa de ser necessário, deve ser removido pelo mecanismo suportado pelo hypervisor.

Arquivos diferenciais não devem ser apagados manualmente.

## Validação

Um backup deve possuir algum mecanismo de validação.

Exemplos:

```text
validar integridade do disco virtual
confirmar presença da configuração da VM
verificar ausência de discos diferenciais inesperados
testar restauração em ambiente controlado
```

A existência de um arquivo de backup, isoladamente, não comprova que ele pode ser restaurado.

## Segredos

Credenciais não devem ser adicionadas a um repositório apenas para facilitar recuperação.

O processo de recovery deve prever recriação ou restauração segura de:

- tokens;
- chaves;
- arquivos de autenticação;
- certificados privados;
- outras credenciais.
