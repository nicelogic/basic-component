
# TODO

## TODO

* stargate可以和dc一起部署
* 测试minio挂一台，其他数据mc命令还是可读
* 规划五台机器minio, cassandra容量分配
* node-1调整成control-panel

* efk,顺带搞清楚containerd, pod日志存储情况
* prometheus + grafana

* traefik 放在basic-component中
* traefik需要支持动态修改配置。同时最好不用helm
* traefik TRACING METRICS ACCESSLOG HUB 都用上
* traefik prometheus + log
* minio log, prometheus and their pv need automiate create in new node. use the local-hostpath, instaed create in a special node
* cassandra log, promethues, backup, repairer

* etcd备份及恢复