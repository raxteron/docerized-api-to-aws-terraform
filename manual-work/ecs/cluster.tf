resource "aws_ecs_cluster" "app_cluster" {
  tags = {
    Name = "${var.app_name}-ecs-cluster"
  }
  name = var.cluster_name
}
