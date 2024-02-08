#!/bin/zsh
set -Eeuo pipefail

ASN1_PREFIX=$'\x30\x4E\x30\x4C\xA0\x03\x02\x01\x00\x30\x45\x30\x43\x30\x41\x30\x09\x06\x05\x2B\x0E\x03\x02\x1A\x05\x00\x04\x14\x33\x81\xD1\xEF\xDB\x68\xB0\x85\x21\x4D\x2E\xEF\xAF\x8C\x4A\x69\x64\x3C\x2A\x6C\x04\x14\x57\x17\xED\xA2\xCF\xDC\x7C\x98\xA1\x10\xE0\xFC\xBE\x87\x2D\x2C\xF2\xE3\x17\x54\x02\x08'
URL_HOST='http://ocsp.apple.com'
URL_RESPONDER='ocsp04-devid01' # or ocsp-devid01
LEGITIMATE_SERIALS=(
  $'\x00\x83\xD3\x24\xD4\xED\x43\xA2'
  $'\x02\xAD\x87\x78\x5C\xC9\x4D\x1C'
  $'\x03\xF4\x3B\xA1\x7F\x73\x96\x0F'
  $'\x04\x92\x63\xF5\x74\x32\xD1\xE5'
  $'\x04\xB6\xC2\xDC\x29\xEF\xE3\xBD'
  $'\x04\xCA\x81\xF7\x7D\x5E\x33\xF7'
  $'\x06\xA7\x65\xE8\xB7\x0A\x87\xE0'
  $'\x06\xC7\x94\x21\x6C\x7A\xA9\x30'
  $'\x09\x71\xF0\x38\x88\x29\xE7\x94'
  $'\x0A\x2E\x04\x85\x3E\x95\x32\x7C'
  $'\x0A\x45\x89\xDC\xB1\x67\x0E\xAE'
  $'\x0B\x4A\x9A\xB6\xDD\xCD\xB7\xB2'
  $'\x0C\xAB\x1E\x0B\xDE\x31\xC9\x29'
  $'\x11\x48\xDF\xC7\x64\xDB\x01\x5D'
  $'\x12\x99\x56\x16\x81\x9A\x3C\x4F'
  $'\x13\x95\x28\x17\xD8\x21\xF3\x03'
  $'\x16\x87\xA2\x35\xE8\xFF\xCF\x8F'
  $'\x18\xCA\xA9\xBE\x8D\xF7\xA7\xC0'
  $'\x19\xC6\x0C\x0C\x77\xEA\x61\xD2'
  $'\x1A\xBE\x58\x35\xD0\x35\x83\x82'
  $'\x1B\x69\x7D\xF3\xDD\x6B\xCA\xD7'
  $'\x1B\xBD\xD4\xBB\xB1\x19\x30\xD7'
  $'\x1C\x12\x1E\x13\x46\xDA\x8C\xCC'
  $'\x1D\x96\xBB\xEF\x6C\xE7\xB6\x38'
  $'\x22\x43\x6A\xE6\x6B\xE7\xE3\xA9'
  $'\x23\xAD\x88\x3A\xF3\x9D\xDD\x55'
  $'\x24\xFC\xF9\xF5\x58\x32\x05\xC6'
  $'\x26\x17\x8E\x18\xE7\xF6\x9D\x93'
  $'\x27\xCB\x22\x0E\xB6\xC3\xD7\x57'
  $'\x2A\xDA\x71\xBA\xA7\xBD\x17\x9F'
  $'\x2B\xE0\x38\xCF\x65\x6A\xC2\xBA'
  $'\x2C\xB0\x23\x3A\x43\x78\x98\x38'
  $'\x2C\xFD\x15\x3C\x29\x73\x44\x2F'
  $'\x2F\xD9\x47\xD6\x65\x7B\xD6\xF8'
  $'\x32\x36\x2B\x86\xAE\x38\xFA\xD8'
  $'\x34\xC8\x25\xD8\x79\x0A\x6E\xFB'
  $'\x3B\x21\x43\xB5\xDA\x74\x2C\x09'
  $'\x3D\x7C\xA5\xDD\xA5\xD3\xAF\x94'
  $'\x3E\x9A\x56\x50\x43\xC7\x2D\xD7'
  $'\x3F\x04\x2E\x8D\x55\xA6\xC7\x8D'
  $'\x40\xB9\x02\xCE\x9F\x1E\xAA\x55'
  $'\x43\x54\xA7\x22\x19\x7C\x79\x60'
  $'\x44\xCA\x5D\x3D\x88\xC7\x55\x3A'
  $'\x44\xE1\xF0\xA2\x98\x43\x4C\x74'
  $'\x44\xE4\x77\x70\xA8\xFD\xB8\x8B'
  $'\x46\xEF\xC4\xF2\x2A\x30\x64\xA9'
  $'\x48\x1B\x3D\xEA\xF9\x5B\x5E\x32'
  $'\x48\x2C\x9F\x9D\xFA\x52\xEA\x10'
  $'\x4A\x55\x89\x12\xC7\x87\xB1\x40'
  $'\x4A\x74\xDD\x37\xBC\x15\xA1\x24'
  $'\x4C\xBA\x6F\x38\x71\x8F\xBA\xC1'
  $'\x4D\x28\x0A\x0C\x95\xB5\x0B\x00'
  $'\x4D\x3C\x3A\xBD\x73\x5B\x09\x50'
  $'\x4D\x50\x33\x39\x83\xDF\x53\x6C'
  $'\x50\x79\x45\xB5\xA0\xD1\x3B\x28'
  $'\x51\x62\x03\xD8\x7D\x3F\xE5\xB6'
  $'\x53\xE8\x19\x42\xC2\x36\x2C\x3B'
  $'\x53\xF8\xF3\x95\xEF\x61\x61\x1D'
  $'\x54\x3E\x7E\xFC\x94\xCB\xC4\xE4'
  $'\x55\xA3\x8C\xED\x4D\x61\x18\xD1'
  $'\x56\x77\xC9\xE8\x6C\x3D\xE6\x6A'
  $'\x56\xA8\x54\x12\x50\xA3\xB5\x9F'
  $'\x57\x8C\x60\x42\xC4\xFB\xF6\xB4'
  $'\x57\x9C\x99\xC0\x8F\x66\x2A\x7C'
  $'\x59\x67\xF4\xBD\x87\x21\xDF\x69'
  $'\x5B\x58\xE8\x1C\x57\xA2\xAB\xA1'
  $'\x5C\x0A\x28\x8F\x26\x8C\xC8\x44'
  $'\x5D\x8C\x36\xBE\x31\x50\x3D\xA2'
  $'\x5E\x01\x64\x9C\xE6\xEC\x6F\xDE'
  $'\x5E\xFE\x81\x6E\xEC\x3D\x8B\x62'
  $'\x61\x42\x22\x88\x8C\x24\x70\x3D'
  $'\x64\xEF\xEA\xFE\xC2\x39\xE8\xA5'
  $'\x68\x31\xB4\x41\xEF\x16\xF9\x33'
  $'\x6B\x45\xCD\xCD\x60\xA8\x34\xDD'
  $'\x75\x16\x1E\xA9\xFB\xDE\xEC\x15'
  $'\x75\x8E\xF3\x40\x27\x52\xDE\x87'
  $'\x75\xA6\x01\x1E\x17\x0D\x99\xC3'
  $'\x77\x25\xDB\xFF\x31\xBD\xEF\xCD'
  $'\x78\x50\x3D\xAC\x9B\x93\x11\xA1'
  $'\x7B\x12\xC5\x30\x94\x80\x20\xE6'
  $'\x7B\x75\x0E\x87\xEC\xCD\x7D\x87'
  $'\x7C\x20\x9D\x7B\xED\xED\x71\xD0'
  $'\x7D\xEE\xA1\x78\xCD\x97\x37\x39'
  $'\x7F\x00\xBB\xDE\xDF\xEB\x09\x05'
)

while true; do
  if [ $((RANDOM % 2)) -eq 0 ]; then
    NONEXISTENT_SERIAL=$(dd if=/dev/random count=8 bs=1 2>/dev/null)
    ASN1_SERIAL="$NONEXISTENT_SERIAL"
  else
    DICE=$((RANDOM % ${#LEGITIMATE_SERIALS} + 1))
    ASN1_SERIAL="${LEGITIMATE_SERIALS[$DICE]}"
  fi
  echo -n "$ASN1_SERIAL" | xxd -p

  ASN1_BASE64=$(echo -n "$ASN1_PREFIX$ASN1_SERIAL" | base64)
  URL_ASN1=$(sed -e 's/+/%2B/g' -e 's/\//%2F/g' -e 's/=/%3D/g' <<< "$ASN1_BASE64")
  curl -s "$URL_HOST/$URL_RESPONDER/$URL_ASN1" \
    -H 'Accept: */*' \
    -H 'Accept-Language: en-us' \
    -H 'Connection: keep-alive' \
    -H 'Accept-Encoding: gzip, deflate' \
    -H 'User-Agent: com.apple.trustd/2.0' \
    -o /dev/null

  TIMER=$((RANDOM % 300))
  echo "Sleeping ${TIMER}s..."
  sleep "$TIMER"
done
