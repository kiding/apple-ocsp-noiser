# apple-ocsp-noiser
Noise Machine for Apple Developer ID OCSP

In order to confuse eavesdroppers in the middle, `ocsp-noiser` sends out an OCSP request to `http://ocsp.apple.com` with a *random* legitimate or nonexistent **serial number** every *random* period of time within 5 minutes. 

Simply run:
```bash
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/kiding/apple-ocsp-noiser/main/script.sh)"
```
