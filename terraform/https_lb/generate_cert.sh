LB_IP=34.160.189.8

# Template LB IP into san.cnf for self-signed cert
cat > san.cnf <<EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
CN = $LB_IP

[v3_req]
subjectAltName = @alt_names

[alt_names]
IP.1 = $LB_IP
EOF

openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout selfsigned.key \
  -out selfsigned.crt \
  -config san.cnf
