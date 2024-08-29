# Certificate management using cert-manager

## How to install k3s cluster? 
- create selfsigned certificate process from [blog](https://medium.com/geekculture/a-simple-ca-setup-with-kubernetes-cert-manager-bc8ccbd9c2)

```
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 && ls /usr/local/bin/k3s-uninstall.sh && kubectl

kubectl get pod -A

echo "alias k='kubectl'" >> ~/.bashrc
source ~/.bashrc
k get all -A

wget https://get.helm.sh/helm-v3.15.4-linux-amd64.tar.gz
tar -zxvf helm-v3.15.4-linux-amd64.tar.gz 
mv linux-amd64/helm /usr/local/bin/helm
helm version

helm repo add jetstack https://charts.jetstack.io --force-update

kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.7.1/cert-manager.crds.yaml
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version 1.7.1 --set installCRDs=true
```


## Certificate duration and renewBefore
https://stackoverflow.com/questions/75541042/cert-manager-renewbefore-notafter-timing-different-from-kubernetes-hosts-machine
https://cert-manager.io/docs/usage/certificate/#renewal
> spec.duration and spec.renewBefore fields on a Certificate can be used to specify a certificate's duration and a renewBefore value. Default value for spec.duration is 90 days.The actual duration may be different depending upon the issuers configurations. Minimum value for spec.duration is 1 hour and minimum value for spec.renewBefore is 5 minutes. Also, please note that spec.duration > spec.renewBefore.

# Generate private certificates
- This part is not managed at this moment due to "selfsigned" certificate is on the table.

### Root
```bash
openssl req -x509 -newkey rsa:4096 -keyout rootca.key -out rootca.crt -days 1
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:IL    
State or Province Name (full name) [Some-State]:haeyoon
Locality Name (eg, city) []:tlv
Organization Name (eg, company) [Internet Widgits Pty Ltd]:hello
Organizational Unit Name (eg, section) []:org1
Common Name (e.g. server FQDN or YOUR name) []:org1-cn
Email Address []:hajo@example.com
root@localhost:~# 
root@localhost:~# ls -h
```

###  intermediate cert
```bash
openssl req -newkey rsa:4096 -keyout intermediate.key -out intermediate.csr
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:IL
State or Province Name (full name) [Some-State]:haeyoon
Locality Name (eg, city) []:tlv
Organization Name (eg, company) [Internet Widgits Pty Ltd]:hello
Organizational Unit Name (eg, section) []:org1
Common Name (e.g. server FQDN or YOUR name) []:org1-cn
Email Address []:hajo@example.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:!@12qwas
An optional company name []:olym
```

```bash
vi intermediate.ext
[v3_ca]
subjectAltName = @critical
subjectAltName = IP:127.0.0.1
subjectAltName = DNS:example.com
keyUsage = critical, keyCertSign, cRLSign
```

```bash
openssl x509 -req -in intermediate.csr -days 1 -extfile intermediate.ext -extensions v3_ca -signkey rootca.key -out intermediate.crt
```

### leaf cert
```bash
openssl req -newkey rsa:4096 -keyout leaf.key -out leaf.csr

Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:IL
State or Province Name (full name) [Some-State]:haeyoon
Locality Name (eg, city) []:tlv
Organization Name (eg, company) [Internet Widgits Pty Ltd]:hello
Organizational Unit Name (eg, section) []:org1
Common Name (e.g. server FQDN or YOUR name) []:org1-cn
Email Address []:hajo@example.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:!@12qwas
An optional company name []:olym-leaf
```

```bash
$ vi leaf.ext
[v3_leaf]
subjectAltName = @critical
subjectAltName = DNS:example.com
keyUsage = critical, digitalSignature, nonRepudiation, keyEncipherment

$ openssl x509 -req -in leaf.csr -days 1 -extfile leaf.ext -extensions v3_leaf -signkey intermediate.key -out leaf.crt

```

```bash
base64 -w 0 rootca.crt > rootca.crt.base64
base64 -w 0 intermediate.crt > intermediate.crt.base64
base64 -w 0 intermediate.key > intermediate.key.base64
base64 -w 0 leaf.crt > leaf.crt.base64
base64 -w 0 leaf.key > leaf.key.base64
```
