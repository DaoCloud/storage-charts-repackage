# 目录意义
因为 [Hwameistor](https://github.com/hwameistor/hwameistor) 是开源项目，但是在产品使用中不可避免的会有一些
产品需求， 对待这些需求，一般我们采用以下方式处理

* 合理需求转换成功能，反馈到上游 `Hwameistor` 主库
* **特定产品需求由其他Repo做一个适配处理，比如本Repo**

因此，这个目录里面主要会做一个产品化相关的事情，包含

* 根据 Values.yaml 生成 `values.schema.json`
* 添加 helm 安装主页面 `README`
    > 可以反馈到主库
* 添加 helm `hwameistor 图标` 
    > 可以反馈到主库
  
***注意：*** 如果有任何超出上述范围的内容，请更新此文档，如果需求合理，尽量将其推到主库 [Hwameistor](https://github.com/hwameistor/hwameistor)

# 如何更新 Hwameistor Charts
1. 下载代码
```shell
$ git clone https://github.com/DaoCloud/storage-charts-repackage.git
```

2. 删除 `/charts/hwameistor/hwameistor` 目录
```shell
$ rm -rf charts/hwameistor/hwameistor
```
> 这个目录是根据每个版本生成的，没有通用的文件或者配置

3. 更新 `/charts/hwameistor/config` hwameistor 至指定版本
```shell
$ vim charts/hwameistor/config
...
```

4. 手动生成最新的 helm 目录
```shell
$ make -e PROJECT=hwameistor

# 检查目录是否生成
ls charts/hwameistor/hwameistor

# 拷贝通用文件
cp charts/hwameistor/parent/* charts/hwameistor/hwameistor
```

5. 检查本地安装是否正常
```shell
$ helm install hwameistor charts/hwameistor/hwameistor -n hwameistor
```