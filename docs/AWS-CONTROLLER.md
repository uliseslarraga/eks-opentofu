## Install AWS Controller

There is a value.yml file with values to deploy an AWS controller with helm:

```shell
$ helm repo add eks https://aws.github.io/eks-charts

$ helm repo update eks

$ helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
    -n kube-system \
    --values k8s/aws-controller/values-dev.yml \
    --set vpcId=$VPC_ID,region=us-east-2 \
    --version 1.13.3
```

## Deploy a demo example to validate AWS Controller

```shell
$ k apply -f k8s/sample_app/demo.yml

$ export DEMO_APP_URL=$(kubectl get ingress/ingress-2048 -n game-2048 -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

$ echo "Game 2048 URL: http://$DEMO_APP_URL"

```
