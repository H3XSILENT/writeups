```py
#Script Gerado por IA
hex_encoded = ""  # Coloque a chave do servidor
fake_flag = 'THM{'

xored_bytes = bytes.fromhex(hex_encoded)
key_stream = [chr(b ^ ord(fake_flag[i % len(fake_flag)])) for i, b in enumerate(xored_bytes)]
recovered_key = ''.join(key_stream[:4])

print(f"[+] XOR Encoded (hex): {hex_encoded}")
print(f"[+] Flag falsa usada   : {fake_flag}")
print(f"[+] Chave descoberta   : {recovered_key}")
```
