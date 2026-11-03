# Skyhook Radar

[Radar](https://radarhq.io) is an open-source (Apache-2.0) Kubernetes UI: topology, resource browser, event timeline, logs, GitOps status (Argo CD and Flux), and an MCP server for AI agents.

This 1-Click installs the `radar` chart from the `skyhook` Helm repo (https://skyhook-io.github.io/helm-charts), pinned to 1.19.0, into the `radar` namespace with the chart defaults:

- ClusterIP service on port 9280, no Ingress or load balancer
- no authentication, so Radar is not reachable from outside the cluster
- read-only access to cluster resources and pod logs
- event timeline kept in memory, so no volume is created

Requests are 200m CPU and 256Mi memory, limits 2 CPU and 1Gi.

## Accessing the UI

```
kubectl port-forward -n radar svc/radar 9280:9280
```

Then open http://localhost:9280

## MCP server

While the port-forward is running, AI agents can connect to the MCP endpoint at `http://localhost:9280/mcp`. Client setup: [MCP docs](https://radarhq.io/docs/features/mcp).

## Permissions

Pod terminal, port forwarding, Secrets and Helm write access are off by default. Radar's Helm releases page needs Secret read access, because Helm stores releases in Secrets, so it shows "Access Restricted" until that is enabled. Enable them with the `rbac.podExec`, `rbac.portForward`, `rbac.secrets` and `rbac.helm` chart values.

## Exposing Radar

Enable authentication (OIDC or an auth proxy) before exposing Radar with an Ingress or a load balancer. See the [in-cluster guide](https://radarhq.io/docs/configuration/in-cluster) and [authentication docs](https://radarhq.io/docs/configuration/authentication).

## Uninstalling

`uninstall.sh` removes the Helm release, including the ClusterRole and ClusterRoleBinding. The empty `radar` namespace stays; remove it with `kubectl delete namespace radar`.

Full documentation: https://radarhq.io/docs
