resource "aws_codebuild_project" "CodeBuildProject" {
  name          = "${var.project_name}-project"
  description   = "${var.project_name} Deploy Project"
  build_timeout = "5"
  service_role  = "${aws_iam_role.CodeBuildIAMRole.arn}"
  tags          = "${var.aws_tags}"
  badge_enabled = true

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"

    environment_variable {
      "name"  = "GITHUB_USER"
      "value" = "qeqar"
    }
    environment_variable {
      "name"  = "GITHUB_AUTHOR_NAME"
      "value" = "AWS CodeBuild"
    }
    environment_variable {
      "name"  = "GITHUB_AUTHOR_EMAIL"
      "value" = "ito-peng@kaufhof.de"
    }

    # Manually fill the variable in the EC2 Parameter Store
    environment_variable {
      "name"  = "GITHUB_ACCESS_TOKEN"
      "value" = "/CodeBuild/githubAccessToken"
      "type"  = "PARAMETER_STORE"
    }
  }

  # Manually Connect the Github Account
  source {
    type            = "GITHUB"
    location        = "https://github.com/qeqar/aws-codebuild-test.git"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "NO_CACHE"
  }

}

resource "aws_cloudwatch_event_rule" "CloudBuildEvent" {
  name        = "every_5_min"
  description = "Build every 5 min"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "CodeBuildTarget" {
  target_id = "CodeBuild"
  rule      = "${aws_cloudwatch_event_rule.CloudBuildEvent.name}"
  arn       = "${aws_codebuild_project.CodeBuildProject.arn}"
  role_arn  = "${aws_iam_role.CloudWatchEventIAMRole.arn}"
}
