apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: balancereader
  namespace: fsi
spec:
  addresses:
  - 240.0.0.2
  endpoints:
  - address: GWIP_ONPREM
    ports:
      http1: 15443 # Do not change this port value
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
  - 240.0.0.3
  endpoints:
  - address: GWIP_ONPREM
    ports:
      http1: 15443 # Do not change this port value
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
  - 240.0.0.4
  endpoints:
  - address: GWIP_ONPREM
    ports:
      http1: 15443 # Do not change this port value
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
  - 240.0.0.5
  endpoints:
  - address: GWIP_ONPREM
    ports:
      http1: 15443 # Do not change this port value
  hosts:
  - ledger-db.fsi.global
  location: MESH_INTERNAL
  ports:
  - name: redis
    number: 6379
    protocol: redis
  resolution: DNS