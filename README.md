# Log4j2 日志内容 JNDI 注入 RCE 缓解措施

国际镜像：https://github.com/zhangyoufu/log4j2-without-jndi
国内镜像：https://code.aliyun.com/zhangyoufu/log4j2-without-jndi/tree/master

## 使用说明

1. 寻找部署目录下的 `log4j2-core` 组件  
   执行以下命令在文件系统中搜索
   ```
   find . -name 'log4j2-core*.jar'
   ```

2. 对找到的 `log4j2-core` JAR 包实施缓解措施
   * 方式1: 使用 `zip`/`unzip` 命令（推荐）
     1. 执行以下命令从指定 JAR 包中删除 `JndiLookup.class`
        ```
        zip -q -d '这里填写JAR包路径' org/apache/logging/log4j/core/lookup/JndiLookup.class
        ```
     2. 执行以下命令确认删除结果（确认输出中不存在 `JndiLookup.class`）
        ```
        unzip -l '这里填写JAR包路径' org/apache/logging/log4j/core/lookup/JndiLookup.class
        ```
   * 方式2: 使用本仓库 `log4j2-core` 目录下同名 JAR 包替换  
     本仓库的 jar 包来自 maven 仓库，仅敲除 `JndiLookup.class`，没有其它任何改动。在确认文件名相同的情况下，可直接替换文件，重启应用程序后生效。
