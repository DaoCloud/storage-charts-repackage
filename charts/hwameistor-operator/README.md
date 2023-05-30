# 如何更新 Hwameistor-Operator Charts
1. 下载代码
```shell
$ git clone https://github.com/DaoCloud/storage-charts-repackage.git
```

2. 删除 `/charts/hwameistor-operator/hwameistor-operator` 目录
```shell
$ rm -rf charts/hwameistor-operator/hwameistor-operator
```
> 这个目录是根据每个版本生成的，没有通用的文件或者配置

3. 更新 `/charts/hwameistor-operator/config` hwameistor-operator 至指定版本
```shell
$ vim charts/hwameistor-operator/config
...
```

4. 手动生成最新的 helm 目录
```shell
$ make -e PROJECT=hwameistor-operator

# 检查目录是否生成
ls charts/hwameistor-operator/hwameistor-operator
```

5. 根据产品定制化的要求去修改values
修改global下内容:
`hwameistorImageRegistry: ghcr.m.daocloud.io`
`k8sImageRegistry: m.daocloud.io/registry.k8s.io`
```shell
$ vi charts/hwameistor-operator/hwameistor-operator
...
```

6. 检查本地安装是否正常
```shell
$ helm install hwameistor-operator charts/hwameistor-operator/hwameistor-operator -n hwameistor
```