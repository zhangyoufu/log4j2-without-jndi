# CVE-2021-44228 Log4j2 JNDI RCE Mitigation

[Chinese version](README.md)

## Usage

1. Locate `log4j2-core` component under deploy path  
   Execute the following command to find in your filesystem
   ```
   find . -name '*log4j-core*.jar'
   ```

2. Apply mitigation against `log4j2-core` JARs found above
   * Method 1: Use `zip`/`unzip` command (recommended)
     1. Execute the following command to remove `JndiLookup.class` from the JAR you specified
        ```
        zip -q -d 'JAR_path_here' org/apache/logging/log4j/core/lookup/JndiLookup.class
        ```
     2. Execute the following command to check the result (ensure that there is no `JndiLookup.class` in the output)
        ```
        unzip -l 'JAR_path_here' org/apache/logging/log4j/core/lookup/JndiLookup.class
        ```
   * Method 2: Replace your JAR with patched JAR from this repo (under `log4j2-core/` directory)  
     All JARs included in this repo comes from maven, with `JndiLookup.class` removed and no further modification. You can replace your JAR safely if the filename matches.

3. Restart you application for the mitigation to become effective.

## How does it work?

To improve compatibility on some JRE that does not provide JNDI, changeset [LOG4J2-703](https://github.com/apache/logging-log4j2/commit/3203d3eab6bdd12fdad7ded1860db16a89468c3f) wraps `${jndi:xxx}` registration with `try/catch`.
When `JndiLookup` instansiation failed, there will be only warning log instead of throw an exception.
We can effectively stop `${jndi:xxx}` handler from registering by removing `JndiLookup.class` file, thus avoid triggering the vulnerability.

* This mitigation applies to all stable release of log4j2, while `log4j2.formatMsgNoLookups` option only applies to log4j2 ≥ 2.10
* This mitigation does not disable all lookups, the functionality of `${date:xxx}`, `${ctx:xxx}`, etc are preserved.
* Sometimes modification to `log4j2.xml` / `log4j2.properties` / `-classpath` are not trivial, or may be overridden on runtime. Modifying JAR is much simpler and effective.

## Acknowledge

This mitigation was [acknowledged by log4j2 team](https://github.com/apache/logging-log4j2/pull/608#issuecomment-990474429):

> Thank you @zhangyoufu for the suggested workaround for older versions of log4j to remove the JndiLookup.class class! The team likes your idea and we will include the workaround you suggested in the release notes and announcement email. Many thanks!

## Credit

Youfu Zhang of Chaitin (@ChaitinTech)
