# Simple CTF (in progress)
---
## Recon
Recebemos o endpoint para ser testado. Colocando o Endereço IP no navegador, descobrir que se tratava de umapagina index exposta do Apache. Vamos usar o gobuster enquanto fazemos ua simples varedura com nmap para sebermos com o que exatamente estamos lidando:
   
    Gobuster:
    gobuster dir -u $IP -w /usr/share/wordlists/dirb/common.txt 
       /.hta                 (Status: 403) [Size: 292]
      /.htpasswd            (Status: 403) [Size: 297]
      /.htaccess            (Status: 403) [Size: 297]
      /index.html           (Status: 200) [Size: 11321]
      /robots.txt           (Status: 200) [Size: 929]
      /server-status        (Status: 403) [Size: 301]
      /simple               (Status: 301) [Size: 315] [--> http://10.201.64.114/simple/]

---
Flags: 

dir - Modo de opeção

-u - especificar url ou IP

-w - especificar a wordlist para o fuzz
---
    Nmap:
    nmap $IP
      PORT     STATE SERVICE
      21/tcp   open  ftp
      80/tcp   open  http
      2222/tcp open  EtherNetIP-1
Temos algumas portas interesantes.
---

Olhando a page simple, se trata de um CMS: SIMPLE; Este em especifico tem uma CVE: [CVE-2019-9053](https://www.exploit-db.com/exploits/46635). 

Note: que o exploit foi escrito em python2, então foi necessario reconstrui-lo. Mas não se preocupe você nao tera que fazer o mesmo.

A vulnerabilidade CVE-2019-9053 permite SQL Injection não autenticado no CMS Made Simple até a versão 2.2.9 por meio do parâmetro m1_idlist do módulo News. O erro ocorre porque o valor desse parâmetro é incorporado diretamente em uma consulta SQL sem validação adequada, permitindo que um atacante insira comandos SQL maliciosos e, nesse caso, utilize técnicas time-based para extrair informações sensíveis. [CVE-DETAILS](https://www.cvedetails.com/cve/CVE-2019-9053/)

```php
// suposto codigo vulneravel
$idlist = $_GET['m1_idlist'];
$sql = "SELECT * FROM news WHERE id IN ($idlist)"; 
$result = mysqli_query($conn, $sql);
```
Neste exemplo, qualquer valor enviado por GET em m1_idlist será inserido diretamente na query SQL, sem escape ou validação. Isso significa que um atacante poderia enviar algo como:
      
      UNION SELECT user,password FROM users--
      
e executar comandos perigosos no banco.​ (FortiGuard)[https://www.fortiguard.com/encyclopedia/ips/56782]

### Código seguro (sanitização e prevenção)
A abordagem correta é NUNCA montar queries SQL a partir de dados do usuário sem usar prepared statements (consultas preparadas):

```php
$idlist = explode(',', $_GET['m1_idlist']);
$placeholders = implode(',', array_fill(0, count($idlist), '?'));
$sql = "SELECT * FROM news WHERE id IN ($placeholders)";
$stmt = $conn->prepare($sql);
$stmt->bind_param(str_repeat('i', count($idlist)), ...$idlist);
$stmt->execute();
```
