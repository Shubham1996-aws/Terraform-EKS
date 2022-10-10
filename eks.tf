resource "aws_iam_role" "eks_cluster_role" {
  name               = "RolesForEKSCluster"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : [
            "eks.amazonaws.com"
          ]
        }
      }
    ]
  })
}

# Attach the EKS Cluster policy to EKS role
resource "aws_iam_role_policy_attachment" "eks_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# EKS Cluster
resource "aws_eks_cluster" "eks" {
  name     = "eks-demo"
  version = "1.22"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      #aws_subnet.private-us-east-1a.id,
      #aws_subnet.private-us-east-1b.id,
      aws_subnet.public-1.id,
      aws_subnet.public-2.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy]
}