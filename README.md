# storage-charts-repackage
[![Release Chart](https://github.com/DaoCloud/storage-charts-repackage/actions/workflows/release-chart.yml/badge.svg)](https://github.com/DaoCloud/storage-charts-repackage/actions/workflows/release-chart.yml)

## requirement

local host needs install：

* helm

* [helm-schema-gen](https://github.com/karuppiah7890/helm-schema-gen.git) if needed

## notice

增加一个新的chart，主要开发如下2个目录，细节请看后续说明

* /charts/${PROJECT}

***

## 生成chart

### case：不需要父chart，自动化同步开源 chart

如果直接使用开源chart，不需要父chart wrapper，那么 请编辑  /charts/${PROJECT}/config （可参考 spiderpool） ， 确保 USE_OPENSOURCE_CHART=true

    最终，执行`make -e PROJECT=${PROJECT}` ， 开源chart 最终生成到 /charts/${PROJECT}/${PROJECT}

> 如果你本地网络不能拉取开源chart，编辑请编辑  /charts/${PROJECT}/config 后，可提交 pr 后，在 github action 中手动触发"Call Generate Chart"，它会帮助执行 make，且生成 PR

### case: 自动化制作做父chart

针对需要制作 父chart ，dependency 依赖 开源的chart

1. 创建请  /charts/${PROJECT}/config，确保其中 USE_OPENSOURCE_CHART=false （可参考 spiderpool）。

2. 把父chart 的添加内容放置在 /charts/${PROJECT}/parent 目录中

3. 最终，执行`make -e PROJECT=${PROJECT}`， 工程自动化 执行如下流程 来 生成 chart

   （1）准备好一个 '父chart临时目录' ，把依赖的 dependency开源 chart 中的 README.md values.yaml Chart.yaml values.schema.json ，放置在 '父chart临时目录' 中

   （2）'父chart临时目录' 中的chart.yaml ， 主动注入 config 中的依赖内容 ，且把 dependency chart 自动放置在 '父chart临时目录'  /charts 目录下

   （3）如果存在 /charts/${PROJECT}/appendValues.yaml  ， 则 其中内容 被 追加到 '父chart临时目录' 的 values.yaml 中

   （4）如果存在 /charts/${PROJECT}/parent 目录（在此目录中，你可以事先准备好 子定义的 README.md values.yaml Chart.yaml values.schema.json， 从而 覆盖以上3步的效果 ），则把其中的所有文件  覆盖拷贝到 '父chart临时目录' 中

   （5）如果 '父chart临时目录'  缺失 values.schema.json 文件，则自动生成 values.schema.json

   （6）如果存在 /src/PROJECT/custom.sh， 则执行它， 脚本的第一个入参是 '父chart临时目录'的路径 。 在次脚本中，你可以自定义代码，实现 复杂的 自定义修改 。 （可参考 spiderpool）

   （7）最终 ， '父chart临时目录'  拷贝于 /charts/${PROJECT}/${PROJECT}

   注：如上流程看似复杂，其实为了满足 不同人的 制作 需求，您可以依赖 其中的几个步骤 来 完成 你的chart 制作

> 如果你本地网络不能拉取开源chart，编辑请编辑  /charts/${PROJECT}/config 后，可提交 pr 后，在 github action 中手动触发"Call Generate Chart"，它会帮助执行 make，且生成 PR

### case: 自己 准备好  chart

如果你自己 已经编辑好 chart，不需要自动化帮助生成chart，那么可直接把 chart 放在 /charts/${PROJECT}/${PROJECT} 下 ，且准备好 /charts/${PROJECT}/config （设置其中 DAOCLOUD_REPO_PROJECT ， 推送到哪个 daocloud chart仓库项目中）

***

## chart 发布到 github pages 和 daocloud 仓库

给工程 推送 任意 tag，github action 自动会制作所有项目的 chart tgz，并提交 PR 到 github pages (需要 approve 下 PR) (go-pages branch)，作为调试 chart 仓库使用

CI 还会并发送一份到 daocloud 仓库 ( 推送到哪个项目下？依据  charts/${PROJECT}/config 文件中的 DAOCLOUD_REPO_PROJECT 设置 )

你可使用 本工程的 chart repo 来测试

    helm repo add daocloud https://daocloud.github.io/storage-charts-repackage/
    helm pull daocloud/${PROJECT}

> 如果只 需要 发布 某一个项目 chart ，可 在 github action 中手动触发 "Release Chart" action， 触发推送指定chart