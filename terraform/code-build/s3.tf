resource "aws_s3_bucket" "CodeBuildLogBucket" {
  bucket = "${var.project_name}-code-build-logs"
  acl    = "private"

  tags = "${var.aws_tags}"
}
