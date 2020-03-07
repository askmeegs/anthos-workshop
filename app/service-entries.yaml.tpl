apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: balancereader
  namespace: fsi
spec:
  addresses:
  - 240.0.0.5
  endpoints:
  - address: GWIP_ONPREM
    ports:
      http: 8080
  hosts:
  - balancereader.fsi.global
  location: MESH_INTERNAL
  ports:
  - name: http
    number: 8080
    protocol: http
  resolution: DNS
---
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: ledgerwriter
  namespace: fsi
spec:
  addresses:
  - 240.0.0.6
  endpoints:
  - address: GWIP_ONPREM
    ports:
      http: 8080
  hosts:
  - ledgerwriter.fsi.global
  location: MESH_INTERNAL
  ports:
  - name: http
    number: 8080
    protocol: http
  resolution: DNS
---
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: transactionhistory
  namespace: fsi
spec:
  addresses:
  - 240.0.0.7
  endpoints:
  - address: GWIP_ONPREM
    ports:
      http: 8080
  hosts:
  - transactionhistory.fsi.global
  location: MESH_INTERNAL
  ports:
  - name: http
    number: 8080
    protocol: http
  resolution: DNS
---
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: ledger-db
  namespace: fsi
spec:
  addresses:
  - 240.0.0.8
  endpoints:
  - address: GWIP_ONPREM
    ports:
      http: 8080
  hosts:
  - ledger-db.fsi.global
  location: MESH_INTERNAL
  ports:
  - name: http
    number: 8080
    protocol: http
  resolution: DNS