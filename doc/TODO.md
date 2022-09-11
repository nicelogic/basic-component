
# TODO

## TODO

* cassandra scale down
* 规划五台机器minio, cassandra容量分配
* env支持master虚ip情况，强制不允许ingress部署虚Ip.ingress虚ip情况不允许master虚ip。互斥关系。但是basic-component可以直接利用master虚ip来访问。这点测试环境机器比较少是需要的。traefik要和虚ip概念剥离开。只要能访问到它即可。不管是什么ip.
  双网卡可以都支持
* efk,顺带搞清楚containerd, pod日志存储情况
* prometheus after cassandra
* traefik 放在basic-component中
* traefik需要支持动态修改配置。同时最好不用helm
* traefik TRACING METRICS ACCESSLOG HUB 都用上
* traefik prometheus + log
* minio log, prometheus and their pv need automiate create in new node. use the local-hostpath, instaed create in a special node
* cassandra log, promethues, backup, repairer
