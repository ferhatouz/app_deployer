module "artimes_namespace" {
source = "./modules/terraform-k8s-namespace"
deployment_namespace= "artemis"
}

module "artemis" {
source = "./modules/terraform-helm"
deployment_name= "artemis"
deployment_namespace="artemis"
deployment_path="charts/application"
values_yaml= <<EOF
replicaCount: 1

image:
  repository: "us-central1-docker.pkg.dev/slmltfqkwlcqdtwu/artemis/artemis"
  tag: "2.0.0"

service:
  type: ClusterIP
  port: 5000

ingress:
  enabled: true
  className: "nginx"
  annotations: 
     ingress.kubernetes.io/ssl-redirect: "false"
     cert-manager.io/cluster-issuer: letsencrypt-prod
     acme.cert-manager.io/http01-edit-in-place: "true"
  hosts:
    - host: "artemis.ferhatouz.com"
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls: 
    - secretName: artemis
      hosts:
        - "artemis.ferhatouz.com"

EOF
  
}