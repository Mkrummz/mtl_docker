
# this is configuration of the different grafana agents for metrics logs traces
```code
kubectl apply -f agent-config-map-logs.yaml # this is one of the private file in the repo
kubectl apply -f agent-config-map-traces.yaml # this is one of the private file in the repo
kubectl apply -f agent-config-map.yaml # this is one of the private file in the repo
```

# this is part of our Grafana Kuberentes integration to install the agents and the ksm service
```code
MANIFEST_URL=https://raw.githubusercontent.com/grafana/agent/v0.24.0/production/kubernetes/agent-bare.yaml NAMESPACE=default /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/grafana/agent/v0.24.0/production/kubernetes/install-bare.sh)" | kubectl apply -f -
MANIFEST_URL=https://raw.githubusercontent.com/grafana/agent/v0.24.0/production/kubernetes/agent-loki.yaml NAMESPACE=default /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/grafana/agent/v0.24.0/production/kubernetes/install-bare.sh)" | kubectl apply -f -
MANIFEST_URL=https://raw.githubusercontent.com/grafana/agent/v0.24.2/production/kubernetes/agent-traces.yaml NAMESPACE=default /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/grafana/agent/v0.24.2/production/kubernetes/install-bare.sh)" | kubectl apply -f -
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts && helm repo update && helm install ksm prometheus-community/kube-state-metrics --set image.tag=v2.4.2 -n default
```