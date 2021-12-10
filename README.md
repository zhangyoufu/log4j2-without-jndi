# Log4j2 日志内容 JNDI 注入 RCE 缓解措施

## 使用说明

1. 寻找部署目录下的 `log4j2-core` 组件

   ```
   find . -name 'log4j2-core*.jar'
   ```

2. 对找到的 `log4j2-core` JAR 包实施缓解措施

   * 方式1: 自行执行命令修复（推荐）

     执行以下命令从指定 JAR 包中删除 `JndiLookup.class`

     ```
     zip -q -d '这里填写JAR包路径' org/apache/logging/log4j/core/lookup/JndiLookup.class
     ```

     执行以下命令确认删除结果（确认输出中不存在 `JndiLookup.class`）

     ```
     unzip -l '这里填写JAR包路径' org/apache/logging/log4j/core/lookup/JndiLookup.class
     ```

   * 方式2: 使用本仓库提供的同名 JAR 包替换

     本仓库的 jar 包来自 maven 仓库，仅敲除 `JndiLookup.class`，没有其它任何改动。在确认文件名相同的情况下，可直接替换文件，重启应用程序后生效。
