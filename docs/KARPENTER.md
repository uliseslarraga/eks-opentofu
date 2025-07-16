<!--This guide is based on migration from cluster autoscaler to karpenter docs https://karpenter.sh/docs/getting-started/migrating-from-cas/
-->

# Migration from Cluster Autoscaler to Karpenter
[Back to main](../README.md)  
This guide is intended to change Cluster autoscaler features with karpenter node provisioner for EKS.

## Configuring prerequisites
Run the next command to prepare current deployed EKS infra to support Karpenter deploy
```shell
make karpenter-prereq
```
The command above will tag EKS cluster security group

## Update aws-auth config map

We need to allow nodes that are using the node IAM role we just created to join the cluster. To do that we have to modify the aws-auth ConfigMap in the cluster.

```shell
kubectl edit configmap aws-auth -n kube-system
```


You will need to add a section to the mapRoles that looks something like this. Replace the AWS_PARTITION variable with the account partition, AWS_ACCOUNT_ID variable with your account ID, and CLUSTER_NAME variable with the cluster name, but do not replace the {{EC2PrivateDNSName}}.

```yaml
- groups:
  - system:bootstrappers
  - system:nodes
  ## If you intend to run Windows workloads, the kube-proxy group should be specified.
  # For more information, see https://github.com/aws/karpenter/issues/5099.
  # - eks:kube-proxy-windows
  rolearn: arn:<AWS_PARTITION>:iam::<AWS_ACCOUNT_ID>:role/<CLUSTER_NAME>-karpenter-node
  username: system:node:{{EC2PrivateDNSName}}

```

## Deploying Karpenter
Create Karpenter manifest with the next command:
```shell
make create-karpenter-manifest
```

Edit the karpenter.yaml file and find the karpenter deployment affinity rules. Modify the affinity so karpenter will run on one of the existing node group nodes.

The rules should look something like this. Modify the value to match your $NODEGROUP, one node group per line.

```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: karpenter.sh/nodepool
          operator: DoesNotExist
        - key: eks.amazonaws.com/nodegroup
          operator: In
          values:
          - <nodegroup>
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - topologyKey: "kubernetes.io/hostname"
```

Now that our deployment is ready we can create the karpenter namespace, create the NodePool CRD, and then deploy the rest of the karpenter resources.

```shell
make create-crds-and-deploy-karpenter
```

## Create default Nodepool

We need to create a default NodePool so Karpenter knows what types of nodes we want for unscheduled workloads. You can refer to some of the example NodePool for specific needs.

```shell
make create-nodeclass-and-nodepool
```

## Testing automatic node provisioning
We'll use the following Deployment to trigger Karpenter to scale out:

```shell
kubectl apply -f k8s/karpenter/karpenter-demo.yaml
```

Now let's scale in the deployment

```shell
kubectl scale -n other deployment/inflate --replicas 5
```

After scaling deployment keep an eye on k8s cluster nodes, they should be increasing 
```shell
kubectl get node -l type=karpenter
```
You should see an ouput like this:
```shell
NAME                                       STATUS     ROLES    AGE   VERSION
ip-10-0-0-149.us-east-2.compute.internal   Ready      <none>   70s   v1.31.7-eks-473151a
ip-10-0-0-233.us-east-2.compute.internal   NotReady   <none>   11s   v1.31.7-eks-473151a
```