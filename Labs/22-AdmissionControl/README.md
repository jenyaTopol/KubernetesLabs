![](../../resources/k8s-logos.png)

# K8S Hands-on
![Visitor Badge](https://visitor-badge.laobi.icu/badge?page_id=nirgeier)

---

# K8S Admission Control

### TLS Certificates
- We need to serve our application over HTTPS.
- Since a webhook must be served via HTTPS, we need proper certificates for the server. 
- These certificates can be self-signed (rather: signed by a self-signed CA), but we need Kubernetes to instruct the respective CA certificate when talking to the webhook server. 
- In addition, the common name (CN) of the certificate must match the server name used by the Kubernetes API server, which for internal services is `<service-name>.<namespace>.svc`, i.e., webhook-server.webhook-demo.svc in our case.

  - Src:  Kubernetes — A Guide to Kubernetes Admission Controllers

```sh
# 01. Create the CA key and certificate:
openssl req \
    -new \
    -x509 \
    -nodes \
    -days   3650 \
    -subj   '/CN=codewizard' \
    -keyout ca.key \
    -out    ca.crt

# 02. Create the server key:
openssl genrsa -out server.key 2048

# 03. Create a certificate signing request:
openssl req \
    -new \
    -key  server.key \
    -subj '/CN=codewizard.default.svc' \
    -out  server.csr

# 04. Create the server certificate:
openssl x509 \
    -req \
    -CAcreateserial \
    -in     server.csr \
    -CA     ca.crt \
    -CAkey  ca.key \
    -days   3650 \
    -out    server.crt
```    