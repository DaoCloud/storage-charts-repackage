# 如何更新 [Hwameistor-Operator](https://github.com/hwameistor/hwameistor-operator) Charts
1. 下载代码
```shell
$ git clone https://github.com/DaoCloud/storage-charts-repackage.git
```
或是使用脚本代替2-5的所有操作
```shell
$ cd charts/hwameistor-operator && bash upgrade_hwameistor-operator.sh v0.10.2
```

2. 删除 `charts/hwameistor-operator/hwameistor-operator` 目录
```shell
$ rm -rf charts/hwameistor-operator/hwameistor-operator
```
> 这个目录是根据每个版本生成的，没有通用的文件或者配置

3. 更新 `charts/hwameistor-operator/config` hwameistor-operator 至指定版本
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

如果修改了定制化的内容记得要修改脚本(upgrade_hwameistor-oprator.sh)

修改global的以下内容,使用Daocloud源:

`hwameistorImageRegistry: ghcr.m.daocloud.io`

`k8sImageRegistry: m.daocloud.io/registry.k8s.io`

```shell
$ vi charts/hwameistor-operator/hwameistor-operator/values.yaml
...
```

6. 检查本地安装是否正常
```shell
$ helm install hwameistor-operator charts/hwameistor-operator/hwameistor-operator -n hwameistor --create-namespace
```
7. 推送至fork后的自己的仓库
```shell
$ git push https://{你的Token}@github.com/{你的用户名}/storage-charts-repackage.git
```

8. 运行Github Action,推送至Harbor
