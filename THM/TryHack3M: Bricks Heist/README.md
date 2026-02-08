# TryHack3M: Bricks Heist

> Crack the code, command the exploit! Dive into the heart of the system with just an RCE CVE as your key.

Essa é a descrição da maquina hahaha. Vamos pra cima!

 ---
# Recon
Recebemos o IP `10.65.138.10`

Testar comunicações e verificar oque temos rodando.

```BASH
┌──(kali㉿kali)-[~]
└─$ ping 10.65.138.10
PING 10.65.138.10 (10.65.138.10) 56(84) bytes of data.
64 bytes from 10.65.138.10: icmp_seq=1 ttl=255 time=242 ms
64 bytes from 10.65.138.10: icmp_seq=2 ttl=255 time=265 ms
^C
--- 10.65.138.10 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 242.244/253.665/265.087/11.421 ms
                                                                                                                                                                                                                                            
┌──(kali㉿kali)-[~]
└─$ curl 10.65.138.10 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
        "http://www.w3.org/TR/html4/strict.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
        <title>Error response</title>
    </head>
    <body>
        <h1>Error response</h1>
        <p>Error code: 405</p>
        <p>Message: Method Not Allowed.</p>
        <p>Error code explanation: 405 - Specified method is invalid for this resource.</p>
    </body>
</html>
```
Nesse momento pus o nmap para funcionar e aproveitei a deixa, para configurar o hosts:

```BASH
┌──(root㉿kali)-[/home/kali]
└─# echo "10.65.138.10 bricks.thm" >> /etc/hosts
```
Aproveitanso esse momento vamos, ao dominio bricks.

Recebemos um error 405:

![](assets/img/fail.png)

Por outro lado o nmap retornou o seguinte resultado:

```BASH
┌──(root㉿kali)-[/home/kali]
└─# nmap -sV -n -sS  10.65.138.10 -T5   
PORT     STATE SERVICE  VERSION<img width="687" height="364" alt="fail" src="https://github.com/user-attachments/assets/8163c5aa-b07a-47be-b709-f6a54729af67" />

22/tcp   open  ssh      OpenSSH 8.2p1 Ubuntu 4ubuntu0.11 (Ubuntu Linux; protocol 2.0)
80/tcp   open  http     Python http.server 3.5 - 3.10
443/tcp  open  ssl/http Apache httpd
3306/tcp open  mysql    MySQL (unauthorized)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

Bom, Seguindo a dica: `What is the content of the hidden .txt file in the web folder?`.

Gobuster com wordiliste medium do dirbuster. Mas Vou pelo Mais Simples:

Aqui Temos a versão do Worldpress:

![](assets/img/version.png)

Pesquisei no goolge por exploit po essa versão e achei esse git: [K3ysTr0K3R](https://github.com/K3ysTr0K3R/CVE-2024-25600-EXPLOIT/blob/main/CVE-2024-25600.py)

Instalei os requerimentos com:

```BASH
sudo apt update
sudo apt install python3-requests python3-bs4 python3-prompt-toolkit python3-rich
```

E Rodei o Script Com:

```BASH
python3 CVE.py -u https://bricks.thm
````
e vua lá!

## Initial Acess
