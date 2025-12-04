
# c4ptur3-th3-fl4g  
[Room - TryHackMe](https://tryhackme.com/room/c4ptur3th3fl4g)

## Introdução
Este CTF tem o objetivo de apresentar como funciona um desafio de captura de bandeira (CTF) real, explorando as diversas tecnologias e dificuldades que podem surgir nesse processo. Além disso, promove de maneira educativa a pesquisa e o aprendizado de técnicas de codificação e decodificação.

***

## Capítulo 1 — Translation & Shifting
O objetivo desta fase é traduzir, deslocar e decodificar diversas mensagens, cada uma utilizando um tipo diferente de cifra ou representação.  
**Atenção:** todas as respostas são *case sensitive*.

***

### 1. Leet
Leet (ou *L33t*) é uma linguagem simbólica originada da substituição de letras por números ou símbolos visualmente semelhantes.  
Embora também exista uma linguagem de programação chamada *Leet*, o termo é mais usado para representar a escrita L33t 5p34k (leet speak).  

Exemplo de texto:
```
c4n y0u c4p7u23 7h3 f149?
```

Referência: [Wikipedia — Leet](https://en.wikipedia.org/wiki/Leet)

***

### 2. Binário
O sistema binário representa números usando apenas dois símbolos: 0 e 1.  
Ao converter o código a seguir para texto ASCII, obtemos a mensagem codificada.

```
01101100 01100101 01110100 01110011 00100000 01110100 01110010 01111001 00100000 01110011 01101111 01101101 01100101 00100000 01100010 01101001 01101110 01100001 01110010 01111001 00100000 01101111 01110101 01110100 00100001
```

Ferramenta: [Binary to ASCII Converter](https://www.rapidtables.com/convert/number/binary-to-ascii.html)  
Referência: [Wikipedia — Binary number](https://en.wikipedia.org/wiki/Binary_number)

***

### 3. Base32
O *Base32* é um sistema de codificação binário para texto, utilizando 32 caracteres distintos, geralmente compostos por A–Z e 2–7. É útil para representar dados binários em formato legível.

```
MJQXGZJTGIQGS4ZAON2XAZLSEBRW63LNN5XCA2LOEBBVIRRHOM======
```

Ferramenta: [CyberChef](https://cyberchef.org/)  
Referência: [Wikipedia — Base32](https://en.wikipedia.org/wiki/Base32)

***

### 4. Base64
Base64 é um sistema de codificação que transforma dados binários em texto usando um conjunto de 64 caracteres imprimíveis.  
É amplamente utilizado para transmissão segura de informações em formato textual.

```
RWFjaCBCYXNlNjQgZGlnaXQgcmVwcmVzZW50cyBleGFjdGx5IDYgYml0cyBvZiBkYXRhLg==
```

Resolução:
```bash
echo "RWFjaCBCYXNlNjQgZGlnaXQgcmVwcmVzZW50cyBleGFjdGx5IDYgYml0cyBvZiBkYXRhLg==" | base64 -d
```

Saída: *Each Base64 digit represents exactly 6 bits of data.*  
Referência: [Wikipedia — Base64](https://en.wikipedia.org/wiki/Base64)

***

### 5. Hexadecimal
O sistema hexadecimal (base 16) utiliza os dígitos 0–9 e as letras A–F para representar valores numéricos de forma compacta.  
Ao converter o código abaixo, obtemos:

```
68 65 78 61 64 65 63 69 6d 61 6c 20 6f 72 20 62 61 73 65 31 36 3f
```

Resultado: *hexadecimal or base16?*  
Ferramenta: [Cryptii — Hex Decoder](https://cryptii.com/pipes/hex-decoder)  
Referência: [Wikipedia — Hexadecimal](https://en.wikipedia.org/wiki/Hexadecimal)

***

### 6. Cifra de César
A cifra de César substitui cada letra do texto por outra deslocada um número fixo de posições no alfabeto.

```
Ebgngr zr 13 cynprf!
```

Decodificado com ROT13 → *Rotate me 13 places!*  
Ferramenta: [Cryptii — Caesar Cipher](https://cryptii.com/pipes/caesar-cipher)  
Referência: [Wikipedia — Caesar cipher](https://en.wikipedia.org/wiki/Caesar_cipher)

***

### 7. ROT47
Outra variação da substituição ROT, mas aplicada a todo o espectro ASCII imprimível.

```
*@F DA:? >6 C:89E C@F?5 323J C:89E C@F?5 Wcf E:>6DX
```

Ferramenta recomendada: [ROT47 Decoder](https://www.dcode.fr/rot-47-cipher)

***

### 8. Código Morse
O Código Morse representa letras e símbolos usando pontos e traços.  
Código:
```
- . .-.. . -.-. --- -- -- ..- -. .. -.-. .- - .. --- -.
. -. -.-. --- -.. .. -. --.
```

Mensagem: *TELECOMMUNICATION ENCODING*  
Ferramenta: [Morse Code Translator](https://morsecode.world/international/translator.html)

***

### 9. Decimal
O sistema decimal (base 10) é o mais comum, utilizando os dígitos de 0 a 9.  
Código:
```
85 110 112 97 99 107 32 116 104 105 115 32 66 67 68
```

Conversão: *Unpack this BCD*  
Ferramenta: [CyberChef](https://cyberchef.org)  
Referência: [Wikipedia — Decimal system](https://pt.wikipedia.org/wiki/Sistema_de_numera%C3%A7%C3%A3o_decimal)

***

### 10. Múltiplos Encodes
O trecho abaixo foi codificado sequencialmente em múltiplos níveis (Base64, Morse, binário, ROT47 e decimal). Essa técnica é comum em CTFs para testar conhecimento de diferentes métodos de ofuscação e decodificação.

```
LS0tLS0gLi0tLS0gLi0tLS0gLS0tLS0g...
```

Abordagem usada: decodificação iterativa com [CyberChef](https://cyberchef.org).  

***

## Capítulo 2 — Espectrograma
Um espectrograma é a representação visual do espectro de frequências de um sinal ao longo do tempo. Ao abrir o áudio fornecido no *Audacity* e mudar de “forma de onda” para “espectrograma”, uma mensagem oculta é revelada na imagem.

**Resposta:** *Super Secret Message*  
Referência: [Wikipedia — Spectrogram](https://en.wikipedia.org/wiki/Spectrogram)

***

## Capítulo 3 — Esteganografia
A esteganografia é a técnica de esconder uma informação dentro de outra, como um texto oculto dentro de uma imagem.  
Ferramentas utilizadas:
- [StegCracker](https://github.com/Paradoxis/StegCracker)
- [StegSeek](https://github.com/RickdeJager/stegseek) (versão moderna e mais rápida)

Após executar o *StegCracker*, o processo gerou o arquivo `img.png.out` contendo a senha oculta.

Citação do autor do StegCracker:
> “Embora eu tenha gostado de construir esta ferramenta, ela sempre foi baseada em uma má ideia — o uso intensivo de subprocessos para realizar brute-force é extremamente ineficiente.”

***

## Capítulo 4 — Security Through Obscurity
O conceito de *Security Through Obscurity* descreve a prática de confiar apenas no sigilo (e não em boas práticas de engenharia) para garantir a segurança de um sistema.

Durante a análise do arquivo, o uso do site [StegOnline](https://www.georgeom.net/StegOnline/image) permitiu visualizar strings ocultas na imagem.  
Parte das palavras estava disfarçada no terminal.



Referência: [Wikipedia — Security through obscurity](https://en.wikipedia.org/wiki/Security_through_obscurity)

***

### Referências gerais  
- [Wikipedia — Cryptography](https://en.wikipedia.org/wiki/Cryptography)  
- [TryHackMe - Capture The Flag Basics](https://tryhackme.com/r/room/c4ptur3th3fl4g)  
- [CyberChef - The Cyber Swiss Army Knife](https://gchq.github.io/CyberChef/)  

# Hack The World!
