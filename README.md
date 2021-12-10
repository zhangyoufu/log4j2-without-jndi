# CVE-2021-44228 Log4j2 日志内容 JNDI RCE 缓解措施

[English version](README_en.md)

国际镜像：https://github.com/zhangyoufu/log4j2-without-jndi  
国内镜像：https://code.aliyun.com/zhangyoufu/log4j2-without-jndi/tree/master

## 使用方式

1. 寻找部署目录下的 `log4j2-core` 组件  
   执行以下命令在文件系统中搜索
   ```
   find . -name '*log4j-core*.jar'
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
     本仓库的 JAR 包来自 maven 仓库，仅敲除 `JndiLookup.class`，没有其它任何改动。在确认文件名相同的情况下，可直接替换文件。

3. 重启应用程序后缓解措施生效

## 原理

为了兼容部分没有提供 JNDI 实现的 JRE，在 [LOG4J2-703](https://github.com/apache/logging-log4j2/commit/3203d3eab6bdd12fdad7ded1860db16a89468c3f) 改动中对 `${jndi:xxx}` 的注册步骤包裹了一层 `try/catch`，当 `JndiLookup` 类实例化失败时仅记录告警日志，不会抛出异常。通过删除 `JndiLookup.class` 文件，我们阻止了 `${jndi:xxx}` 的注册，使漏洞无法被触发。

* 该缓解手段对 log4j2 正式发版的所有版本有效，而 `log4j2.formatMsgNoLookups` 仅对 log4j2 ≥ 2.10 有效
* 该缓解手段避免了禁用 lookup 功能对 `${date:xxx}`、`${ctx:xxx}` 等正常功能的影响
* `log4j2.xml` / `log4j2.properties` / `-classpath` 对于某些部署场景不好修改，或者在运行时被程序指定/覆盖，直接修改 JAR 包更简单有效

## 官方认可

该缓解手段得到 [log4j2 官方认可](https://github.com/apache/logging-log4j2/pull/608#issuecomment-990474429)：

> Thank you @zhangyoufu for the suggested workaround for older versions of log4j to remove the JndiLookup.class class! The team likes your idea and we will include the workaround you suggested in the release notes and announcement email. Many thanks!

## Credit

Youfu Zhang of Chaitin (长亭科技)
