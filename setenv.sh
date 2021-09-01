# Environment parameters used by ReFlex
echo ">>>>>>>>>>>"
echo $CATALINA_HOME
echo "<<<<<<<<<<<"
export CATALINA_OPTS="-Xms512M -Xmx4096M -Dfile.encoding=UTF-8"
export REFLEX_CONFIG_ROOTDIR=${CATALINA_HOME}/reflex-config
export REFLEX_LOG_ROOTDIR=${CATALINA_HOME}/logs

# dump memory content in case of memory error
export CATALINA_OPTS="${CATALINA_OPTS} -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/heap.dump.dir"