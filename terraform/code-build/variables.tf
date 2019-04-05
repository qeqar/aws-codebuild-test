variable "project_name" {
  type = "string"
  default = "aws-codebuild-test"
}

variable "aws_tags" {
  type = "map"
  default = {
    managed_by = "Terraform"
    project = "aws-codebuild-test"
    subproject = "code-build"
    terraform_source = "https://github.com/qeqar/aws-codebuild-test"
    author_email = "ito-peng@kaufhof.de"
  }
}
