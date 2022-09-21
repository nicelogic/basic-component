
# monitoring

## 技术选型

prometheus + grafana 基本是当前的行业标准

kube-prometheus包含：
	* prometheus
	* grafana
	* node exporter
	* blackbox-exporter
	* kube-state-metrics
	* alertmanager
这些是必要的组件，提供crd，方便部署
但是默认没有持久化存储： https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/user-guides/storage.md
这个文档提供配置本地存储

太久的没啥意义，一定时间内的存储数据即可。用于出现问题时候的排查。

