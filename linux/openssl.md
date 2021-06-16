// get server cert
openssl s_client -showcerts  -connect x.x.x.x:443 -servername x.x.x.x:443

//show cert detail
openssl x509 -in test.cer -noout -text
openssl rsa -noout -text -in privatekey.pem


//create csr from private key
openssl req -new -key test.key -out test.csr