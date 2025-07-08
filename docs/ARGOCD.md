## Install ArgoCD
[Back to main](../README.md)  
There is a preconfigured values.yaml file for argocd deploy with helm:
```shell
#Add argocd repo
helm repo add argo-cd https://argoproj.github.io/argo-helm

#install argocd
helm upgrade --install argocd argo-cd/argo-cd --version 8.1.2 \
  --namespace "argocd" --create-namespace \
  --values k8s/argocd/values.yaml \
  --wait

#Get argocd URL
export ARGOCD_SERVER=$(kubectl get svc argocd-server -n argocd -o json | jq --raw-output '.status.loadBalancer.ingress[0].hostname')
echo "ArgoCD URL: https://$ARGOCD_SERVER"

#Get Argocd password for admin user
export ARGOCD_PWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "ArgoCD admin password: $ARGOCD_PWD"

#Login with argocli
argocd login $ARGOCD_SERVER --username admin --password $ARGOCD_PWD --insecure
```
