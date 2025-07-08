## Install AWS Controller
[Back to main](../README.md)  
There is a value.yml file with values to deploy an AWS controller with helm:

```shell
make aws-controller-install env=development layer=network
```

## Deploy a demo example to validate AWS Controller

```shell
$ k apply -f k8s/sample_app/demo.yml

$ export DEMO_APP_URL=$(kubectl get ingress/ingress-2048 -n game-2048 -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

$ echo "Game 2048 URL: http://$DEMO_APP_URL"

```
