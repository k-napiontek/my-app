resource "aws_iam_policy" "alb_controller_policy" {
  name = "AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "Policy for ALB Controller"
  policy      = file("${path.module}/iam-policy.json")
}

module "lb_role" {
    source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
    version = "~> 6.0"

    name= "aws-load-balancer-controller"

    oidc_providers = {
        this = {
            provider_arn               = var.oidc_provider_arn
            namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
        }
    }
}

resource "aws_iam_role_policy_attachment" "alb_controller_attach" {
  role       = module.lb_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}



# curl -o terraform/modules/alb/iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v3.0.0/docs/install/iam_policy.json

# polityki robimy po to aby ingress controller miał uprawnienia do tworzenia i usuwania load balancers

# teraz podejscie imeratywne pozniej zrobie to w argocd

# eksctl create iamserviceaccount \
#   --cluster=dev-myapp \
#   --namespace=kube-system \
#   --name=aws-load-balancer-controller \
#   --attach-policy-arn=arn:aws:iam::438950223046:policy/AWSLoadBalancerControllerIAMPolicy \
#   --override-existing-serviceaccounts \
#   --region eu-central-1 \
#   --approve

# eksctl create iamserviceaccount \
#   --cluster=dev-myapp \
#   --namespace=kube-system \
#   --name=aws-load-balancer-controller \
#   --attach-role-arn=arn:aws:iam::438950223046:role/aws-load-balancer-controller-20260203163253215500000001 \
#   --region eu-central-1 \
#   --approve

# kubectl get sa -n kube-system aws-load-balancer-controller -o yaml


# helm repo add eks https://aws.github.io/eks-charts
# helm install aws-load-balancer-controller eks/aws-load-balancer-controller --set clusterName=dev-myapp -n kube-system \
# --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller
