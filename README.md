# apple-ocsp-noiser
Privacy-Preserving Noise Machine for Apple Developer ID OCSP

> Read [the writeup](https://kiding.medium.com/macos-ocsp-telemetry-explainer-and-mitigation-9bc243928f4c) for the full details.

macOS sends a periodic OCSP request *in plaintext* with a **serial number** of the developer certificate of the app that's being installed or launched. Whether the intention, the requests themselves can be used as *telemetry* by anyone on the network; ISPs, governments, etc. 

Blocking `ocsp.apple.com` entirely will hinder Apple's built-in malware protection. What we should do instead is to *confuse* the eavesdroppers in the middle by adding noise.

`apple-ocsp-noiser` sends out an OCSP request to `http://ocsp.apple.com` with a *random* legitimate or nonexistent **serial number** for every *random* period of time. 

Download `script.sh`, examine the file, then run it with `zsh`.
```bash
cd /Users/Shared/ || exit 1
curl -Ro 'apple-ocsp-noiser.sh' --fail -- \
    'https://raw.githubusercontent.com/kiding/apple-ocsp-noiser/main/script.sh'
chmod +x apple-ocsp-noiser.sh

# If you're confident the script is trustworthy:
/bin/zsh apple-ocsp-noiser.sh
```

You can also install the script to run at load:
```bash
mkdir -p ~/Library/LaunchAgents/
cd ~/Library/LaunchAgents/ || exit 1
curl -ROJ --fail -- \
    'https://raw.githubusercontent.com/kiding/apple-ocsp-noiser/main/launched.apple-ocsp-noiser.plist'

# Examine the plist file in case there was a disruption in downloading
# You will also need to change the `<username>` to the real user name
YOUR_FAVORATE_EDITOR=vim
"$YOUR_FAVORATE_EDITOR" launched.apple-ocsp-noiser.plist

launchctl load -w launched.apple-ocsp-noiser.plist
```

## Serial Number Submission

A well-equipped eavesdropper might have a database of *Developer ID* serial numbers. You can help the project by adding more legitimate serial numbers in the *random* pool. Make an issue or a pull request with **only** the serial numbers in hex format.

Please **do not post** the name of apps or developers. Creating a trackable database is not the purpose here.

```bash
ls | grep '.app' | while read APP; do
  rm -f OCSP_0 OCSP_1 OCSP_2
  codesign -d --extract-certificates="OCSP_" "$APP" 2>/dev/null

  if [ -f OCSP_0 ]; then
    openssl x509 -in OCSP_0 -inform DER -serial | head -n1 | sed 's/serial=\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)/\\x\1\\x\2\\x\3\\x\4\\x\5\\x\6\\x\7\\x\8/' 2>/dev/null
  fi

  rm -f OCSP_0 OCSP_1 OCSP_2
done
# \x75\x8E\xF3\x40\x27\x52\xDE\x87
```
