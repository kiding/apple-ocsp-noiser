# apple-ocsp-noiser
Noise Machine for Apple Developer ID OCSP

> Read [the writeup](https://kiding.medium.com/macos-ocsp-telemetry-explainer-and-mitigation-9bc243928f4c) for the full details.

macOS sends a periodic OCSP request *in plaintext* with a **serial number** of the developer certificate of the app that's being installed or launched. Whether the intention, the requests themselves can be used as *telemetry* by anyone on the network; ISPs, governments, etc. 

Blocking `ocsp.apple.com` entirely will hinder Apple's built-in malware protection. What we should do instead is to *confuse* the eavesdroppers in the middle by adding noise.

`apple-ocsp-noiser` sends out an OCSP request to `http://ocsp.apple.com` with a *random* legitimate or nonexistent **serial number** for every *random* period of time. 

Simply run:
```bash
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/kiding/apple-ocsp-noiser/main/script.sh)"
```

## Serial Number Submission

A well-equipped eavesdropper might have a database of *Developer ID* serial numbers. You can help the project by adding more legitimate serial numbers in the *random* pool. Make an issue or a pull request with **only** the serial numbers in hex format.

Please **do not post** the name of apps or developers. Creating a trackable database is not the purpose here.

```bash
codesign -d --extract-certificates /Applications/RandomApplication.app 
openssl x509 -in codesign0 -inform DER -serial | head -n1 | sed 's/serial=\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)/\\x\1\\x\2\\x\3\\x\4\\x\5\\x\6\\x\7\\x\8/'
# \x75\x8E\xF3\x40\x27\x52\xDE\x87
```
