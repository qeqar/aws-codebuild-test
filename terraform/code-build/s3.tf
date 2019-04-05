resource "aws_s3_bucket" "code_build_log_bucket" {
  bucket = "${var.project_name}-code-build-logs"
  acl    = "private"

  tags = "${var.aws_tags}"
}
