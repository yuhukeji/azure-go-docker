# azure-go-docker

## Docker Repo

yuhukeji/azure-go

## Build

``` bash
version='1.0.0'
ubuntu='20.04'
go='1.20.2'
docker build --target base --tag yuhukeji/azure-go:${version}-ubuntu${ubuntu} .
docker build --target development --tag yuhukeji/azure-go:${version}-ubuntu${ubuntu}-go${go} .

docker login -u yuhukeji
docker push yuhukeji/azure-go:${version}-ubuntu${ubuntu}
docker push yuhukeji/azure-go:${version}-ubuntu${ubuntu}-go${go}
```
