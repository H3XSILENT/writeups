# Binarios e Hexas
[Tudo no computador é feito em binarios (0-1).](https://github.com/rv157244/Assembly-Language/blob/main/foundation/binary-numbers.md)

usar o comando xxd para ler:

* Primeiro vamos gerar um arquivo txt

```BASH
                                                                                                              
┌──(jow㉿redziz)-[~]
└─$ echo "hello world!" >>  hello.txt
dquote> 
                                                                                                              
┌──(jow㉿redziz)-[~]
└─$ echo "hello world\!" >>  hello.txt
                                                                                                              
┌──(jow㉿redziz)-[~]
└─$ cat hello.txt                
hello world!
```
* Agora vamos ler em binarios

```BASH
┌──(jow㉿redziz)-[~]
└─$ xxd -b hello.txt 
00000000: 01101000 01100101 01101100 01101100 01101111 00100000  hello 
00000006: 01110111 01101111 01110010 01101100 01100100 00100001  world!
0000000c: 00001010  
```
Lembrando que estamos lendo em 16 bits, podemos ver o padrão `01101111 00100000` se repetir 3x por causa do L. 

Ler em binario é um pouco incoveniente.

* Então vamos ler em Hexadecimal:
```BASH
┌──(jow㉿redziz)-[~]
└─$ xxd hello.txt 
00000000: 6865 6c6c 6f20 776f 726c 6421 0a         hello world!.
```
O padrão *6c* se reperte diversas vezes. Lembrando que o hexadecimal ler de 2 em 2 bytes.

Essa conversão funciona porque segue um padão internacional: o Unicode (utf-8).

Tudo é um numero*, por exemplo emojis, numeros em si, letras. A tabela mais antiga, mas que ainda acabamos usando é a ASCII.

Considerando o seguinte programa em C:
```C
#include <stdio.h>

int main(void){
        char var[12]= "HELLO WORLD!";
        printf("%s\n", var);
       return 0;
}
```

No fina ele imprimira a string.

Vamos pegar o binario e ler. poderiamos usar diversas ferramentas com hexeditor ou hexdump. Mas vamos continuar no xxd:
```bash
xxd var | more
00000000: 7f45 4c46 0201 0100 0000 0000 0000 0000  .ELF............
00000010: 0300 3e00 0100 0000 5010 0000 0000 0000  ..>.....P.......
00000020: 4000 0000 0000 0000 9036 0000 0000 0000  @........6......
00000030: 0000 0000 4000 3800 0e00 4000 1f00 1e00  ....@.8...@.....
00000040: 0600 0000 0400 0000 4000 0000 0000 0000  ........@.......
00000050: 4000 0000 0000 0000 4000 0000 0000 0000  @.......@.......
00000060: 1003 0000 0000 0000 1003 0000 0000 0000  ................
00000070: 0800 0000 0000 0000 0300 0000 0400 0000  ................
00000080: 9403 0000 0000 0000 9403 0000 0000 0000  ................
00000090: 9403 0000 0000 0000 1c00 0000 0000 0000  ................
000000a0: 1c00 0000 0000 0000 0100 0000 0000 0000  ................
```
Podemos notar que a um padrao, vamos dividir a primeira linha em 3 partes:

* A coluna da direita temos os endereços

* A segunda coluna são 16 bytes seguidos, divididos em 4 letras, cada um com dois bytes com um total de 8 blocos de 4 letras. Cada 2 letra é um byte em hexadecimal

    - Se olharmos sao 15 bytess por linha e na segunda linha estamos no endereços `0x010`, que siguinifica 16 e na terceira 32,e assim por diante.

* A terceira linha está em A representaçao na tabela ascii. quando nao ah representaçao ele mostra apenas um ponto.

    - se pegarmos os 3 primeiros bytes(com exessao do .) vemos que `45 4c46` é o .ELF(Executable Linkable Format), que foi o formato que eu copilei.

Se fosse uma imagem seria:

```BASH
8950 4e47 .PNG
```

Se olharmos um binario do java:
```JAVA
00000000: cafe babe 0000 003d 00ad 0700 0201 001f  .......=........
```
Assim podemos ver a diferença entre uma linguagem feita por especialista e detalhistas em relaçao a um [* JS da vida que foi feito as pressas] (https://www.superprof.pt/blog/a-historia-do-curso-javascript/).

Se ainda nao ficou claro, não é assim que um binario realmente é. Essa é uma representaçao legivel que possamos ler, entender e modificar. UM binario em si nao possui caractes e de linhas, so uma unica linha infinita de 0  e 1 semelhante a fitas.

Entende agora porque vemos computadores antigos gravando  em fitas ou k7s? é assim mesmo que funciona ate hoje.

(*Nota: Na década de 90, a Netscape Navigator tornou-se o grande navegador Web e a sua versão 2.0 tinha o primeiro dos códigos JavaScript, desenvolvido em apenas 10 dias pelo programador Brendan Eich, com um grande dom informático, contratado pela Netscape, depois de esta ter chegado à conclusão que a internet teria de se tornar ainda mais dinâmica, para facilitar o seu acesso. Inicialmente, foi denominada de LiveScript e não se imaginava ainda a importância que o JavaScript iria ter hoje.)

## uma breve explicaçao sobre representaçao:

Em decimal representamos tudo de 0 a 9:
        
        0 1 2 3 4 5 6 7 8 9
        
Em Hexadecimal reprentamos de 0 a F:
        
        0 1 2 3 4 5 6 7 8 9 A B C D F
        
Sendo :
        
    A = 10; B = 11;

É assim sucessivamente, ate 15.

Todas as regras aritmetricas funcionam igual, Sendo:
    
        F + 1 = 10
        pois:
        F = 15; 1 = 1;

Em representação ASCII, seria F + 1 = 16. ou 10 em hexadecimal.

## Bitwise
Para fazer contas em binario é mais vantajoso em alguns casos.

O numero 4, por exemplo é representado por `01 00`:

```BASH
00003260  34 01 00 00  12 00 00 00   00 00 00 00  00 00 00 00                                 4...............
```
Se voce mover 1 para esquerda ficaria 8:

```Bash
    4 = 01 00
    8 = 10 00
```
Note que multiplicou por 2, mas se você mover para a direita dividiria por 2:

```Bash
    4 = 01 00
    2 = 00 10
```

Isso foi bem simplificado, porque se fosse em numeros impares, nao teriamos um resto assim.

Esse é o conceito do operador Bitwise, que esta prasente em qual quer linguagem moderna: (shift left <<) e (shift right >>).

Usando o console JS vamos fazer alguns testes e exercita: 

* Podemos representar numero 4:
        
        > 0b0100
        <. 4

* Vamos criar um array com 11 palavras:
        
        > palavra = "hello world!"
        <. hello world!

* Se quiser pegar a ultima string, seria 10. pois o array começa do 0:

        > palavra[10]
        <. '!'

* Podemos chegar na mesma letra se passarmos um valor em Hexa:

    - Precisamos passar um valor 0 da memoria e x para ele interpretar que queremos um valor
    
            > palavra[0xA]
            <. '!'
Para ficar mais hardcore, poderiamos passar o valor cru:

        > palavra[0b1010]
        <. '!'

No fim, tudo é um binario. As linguagens de programção so facilitam deixando usar numeros em decimais, ou mesmo letras.

* Se eu fizer um L bitwise de 10, seria divisão por 2:

        > 10>>1
        <. 5
* Então podemos usar a mesma logica no console JS:
        
        > palavra[0b1010>>1]
        <. ''

Isso aconteceu porque na string `hello world!`, o espaço tambem é contado como caracter, o qual está na posição 5.

* A mesma logica se aplica a valores hexadecimal:
        
        > palavra[0xA>>1]
        <. ''
        > palvra[0x4>>1]
        <. 'l'

# 32 ou 64?
Se voce parar pra pensar, em computadores de 32-bits e 64-bits, usando o conceito de base decimal, temos a impresão de que so estamos dobrando de tamanho de 32 para 64. Mas oque isso siguinifica?

Internamente siguinifica que o computador consegue processar numeros de 32 ou 64 bits de comprimento de uma só vez.

Até agora trabalhamos com apenas numeros de 4 bits que dá pra contar ate 256.

Levando em consideração o conceito do bitwise, 5 bits já seriam o dobro de 4 bits: 

        5 bits = 2 x 4 bits
        6 bits = 2 x 5 bits
        33 bits = 2 x 32 bits
        64 bits = (32 bits)^2

Então a metade de 64 não é 32, e sim 63:

        64 bits / 2 = 63 bits

Em 32 bits podemos representar até quase 4.4 bilhões de numeros:

        32 bits = 4,294,967,295
        
Em 64 bits podemos representar um numero gigante (1.8 x 10^19):

        18,446,744,073,709,551,615
        
A vantagem do Hexadecimal é que podemos representar esse numero imenso com apenas 16 caracters:

        0xFFFFFFFFFFFFFFFF

Mesmo que você esteja extremamente curioso, é simples mente logico. Estamos usando numeros derivados da base 2. Com isso 1 mb não é igual a 1000 bytes, e sim 1024 bytes, que em hexa seria:

        40 00 || 0x400
        
dessa forma a gente tende a usar numeros que são redondos em hexadecimal.

De qualque forma 64 bits é um numero dificil de vizualizar na cabeça.
