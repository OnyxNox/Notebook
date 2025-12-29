# Self-signed SSL Certificate

1. [Create Local Certificate Authority (CA)](#1-create-local-root-certificate-authority-ca)
2. [Create Self-signed Certificate](#2-create-self-signed-certificate)
3. [Install Local Root CA on Windows](#3-install-local-root-ca-on-windows)
4. [Use Self-signed Certificate](#4-use-self-signed-certificate)

---

## 1. Create Local Root Certificate Authority (CA)

```bash
# Generate CA private key
openssl genrsa -out local-ca.key 4096

# Generate CA certificate (valid 10 years)
openssl req -x509 -new -nodes -key local-ca.key -sha256 -days 3650 -out local-ca.crt -subj "/CN=Local Root CA"
```

## 2. Create Self-signed Certificate

```bash
# Generate server private key
openssl genrsa -out home.lan.key 2048

# Create config file for Subject Alternative Names (SANs)
#   * IP entries are only required when accessing the service directly via IP address
#   * Add multiple IPs by incrementing the number (IP.1, IP.2, IP.3, etc.)
cat > home.lan.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = home.lan
DNS.2 = *.home.lan
IP.1 = 192.168.1.67
EOF

# Generate Certificate Signing Request (CSR)
openssl req -new -key home.lan.key -out home.lan.csr -subj "/CN=*.home.lan"

# Generate self-signed certificate
openssl x509 -req -in home.lan.csr -CA local-ca.crt -CAkey local-ca.key -CAcreateserial -out home.lan.crt -days 825 -sha256 -extfile home.lan.ext

# Create full chain certificate
cat home.lan.crt local-ca.crt > home.lan.fullchain.crt
```

## 3. Install Local Root CA on Windows

Double-click `local-ca.crt` → Install Certificate... → Local Machine → Place all certificates in the following store → Trusted Root Certification Authorities

Restart any open browsers to trust the new LAN Root CA. In Chrome, use `chrome://restart`.

## 4. Use Self-signed Certificate

Configure application SSL settings to use the full chain certificate (`home.lan.fullchain.crt`) and server private key (`home.lan.key`).

**NOTE:** Some applications require a PEM format. Rename `.crt` to `.pem` for the certificate, and `.key` to `.pem` for the private key.
