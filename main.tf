
data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "codepipeline:StartPipelineExecution"
    ]
    resources = [
      var.pipeline_arn
    ]
  }
}

resource "aws_iam_policy" "policy" {
  name   = "${local.event_name}-iam-role-policy"
  policy = data.aws_iam_policy_document.policy.json
}

data "aws_iam_policy_document" "event_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "role" {
  name = "${local.event_name}-iam-role"

  assume_role_policy = data.aws_iam_policy_document.event_assume_role_policy.json
}


resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  policy_arn = aws_iam_policy.policy.arn
  role       = aws_iam_role.role.name
}
resource "aws_cloudwatch_event_rule" "codecommit_event" {
  name        = local.event_name
  description = "Trigger event for ${var.branch_name} on ${var.repo_arn}"

  event_pattern = jsonencode({
    source = ["aws.codecommit"],
    detail-type = [
      "CodeCommit Repository State Change"
    ],
    resources = [
      var.repo_arn
    ],
    detail = {
      event = [
        "referenceCreated",
        "referenceUpdated"
      ],
      referenceType = [
        "branch"
      ],
      referenceName = [
        var.branch_name
      ]
    }
  })
}

resource "aws_cloudwatch_event_target" "codepipeline_target" {
  target_id = "${local.event_name}-${var.branch_name}-trigger"
  rule      = aws_cloudwatch_event_rule.codecommit_event.name
  arn       = var.pipeline_arn
  role_arn  = aws_iam_role.role.arn
}
