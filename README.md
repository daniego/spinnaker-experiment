# Ingress
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml


# Spinnaker
kubectl apply -f spinnaker-Namespace.yaml
kubectl apply -f spinnaker-ServiceAccount.yaml
kubectl apply -f spinnaker-RBAC.yaml


kubectl config set-cluster cluster.local --server=https://kubernetes.default.svc --certificate-authority=/etc/kubernets/ssl/ca.pem

kubectl config  set-credentials admin-cluster.local --client-certificate=/etc/kubernets/ssl/admin-k8s-01.pem --client-key=/etc/kubernets/ssl/admin-k8s-01-key.pem

kubectl config set-context admin-cluster.local --cluster=cluster.local --namespace=spinnaker --user=admin-cluster.local


kubectl config use-context admin-cluster.local

# Provider

+ Create a Kubernetes Service Account
+ Configure Kubernetes roles (RBAC)

- Adding an account
  # First, make sure that the provider is enabled:

hal config provider kubernetes enable

  # Then add the account:

hal config provider kubernetes account add my-k8s-v2-account \
    --provider-version v2 \
    --context $(kubectl config current-context)

  # You’ll also need to run

hal config features edit --artifacts true

# Environment

hal config deploy edit --type distributed --account-name my-k8s-v2-account

# Storage - Minio

export MINIO_SECRET_KEY=secretkey
export MINIO_ACCESS_KEY=accesskey
export MINIO_ENDPOINT=http://minio-service.spinnaker.svc.cluster.local:9000

echo $MINIO_SECRET_KEY | hal config storage s3 edit --endpoint $MINIO_ENDPOINT \
    --access-key-id $MINIO_ACCESS_KEY \
    --secret-access-key
    # will be read on STDIN to avoid polluting your
                        # ~/.bash_history with a secret

hal config storage edit --type s3

# Set urls

export DOMAIN=mydomain.com
hal config security ui edit \
    --override-base-url http://spinnaker.$DOMAIN

hal config security api edit \
    --override-base-url http://spinnaker-api.$DOMAIN

hal deploy apply

# Deploy and connect
hal version list

export SPINNAKER_VERSION="1.8.5"
hal config version edit --version $SPINNAKER_VERSION

hal deploy apply
