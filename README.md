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
   * 方式1: 使用 `zip` 命令（推荐）
     执行以下命令从指定 JAR 包中删除 `JndiLookup.class`
     ```
     zip -q -d '这里填写JAR包路径' org/apache/logging/log4j/core/lookup/JndiLookup.class
     ```
   * 方式2: 使用本仓库 `log4j2-core` 目录下同名 JAR 包替换  
     本仓库的 JAR 包来自 maven 仓库，仅敲除 `JndiLookup.class`，没有其它任何改动。在确认文件名相同的情况下，可直接替换文件。

3. 重启应用程序后缓解措施生效

## 原理

为了兼容部分没有提供 JNDI 实现的 JRE，在 [LOG4J2-703](https://github.com/apache/logging-log4j2/commit/3203d3eab6bdd12fdad7ded1860db16a89468c3f) 改动中对 `${jndi:xxx}` 的注册步骤包裹了一层 `try/catch`，当 `JndiLookup` 类实例化失败时仅记录告警日志，不会抛出异常。通过删除 `JndiLookup.class` 文件，我们阻止了 `${jndi:xxx}` 的注册，使漏洞无法被触发。

* 该缓解手段对 log4j2 正式发版的所有版本有效，而 `log4j2.formatMsgNoLookups` 仅适用于 `log4j2 ≥ 2.10`
* 该缓解手段避免了禁用 lookup 功能对 `${date:xxx}`、`${ctx:xxx}` 等正常功能的影响
* `log4j2.xml` / `log4j2.properties` / `-classpath` 对于某些部署场景不好修改，或者在运行时被程序指定/覆盖，直接修改 JAR 包更简单有效

## 官方认可

该缓解手段得到 [log4j2 官方认可](https://github.com/apache/logging-log4j2/pull/608#issuecomment-990474429)：

> Thank you @zhangyoufu for the suggested workaround for older versions of log4j to remove the JndiLookup.class class! The team likes your idea and we will include the workaround you suggested in the release notes and announcement email. Many thanks!

## 参考链接

* https://nvd.nist.gov/vuln/detail/CVE-2021-44228
* https://github.com/advisories/GHSA-jfh8-c2jp-5v3q
* https://logging.apache.org/log4j/2.x/security.html
* https://mail-archives.apache.org/mod_mbox/www-announce/202112.mbox/%3C643bc702-4b46-411b-4980-1fcf637dbb11@apache.org%3E
* https://github.com/apache/logging-log4j2/pull/608
* https://github.com/tangxiaofeng7/apache-log4j-poc

## 其他缓解措施

* https://github.com/Glavo/log4j-patch (插入 classpath 覆盖原有实现)
* https://github.com/LoliKingdom/NukeJndiLookupFromLog4j (运行时删除 "jndi" 处理)
* JVM 参数 `-Dlog4j2.formatMsgNoLookups=true` 或环境变量 `LOG4J_FORMAT_MSG_NO_LOOKUPS=true` (仅适用于 `log4j-core ≥ 2.10`)
