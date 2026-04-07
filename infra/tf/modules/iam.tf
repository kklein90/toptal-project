data "aws_caller_identity" "current" {}

# server role
resource "aws_iam_role" "server_role" {
  name                 = "Server-role"
  description          = "This role allows server access to services for deployment"
  max_session_duration = "21600"
  assume_role_policy   = data.aws_iam_policy_document.server_pol.json
  path                 = "/"
}

data "aws_iam_policy_document" "server_pol" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_instance_profile" "server_inst_profile" {
  name = "serverProfile"
  role = aws_iam_role.server_role.name
}

resource "aws_iam_policy" "server_policy" {
  name        = "server-server-policy"
  path        = "/"
  description = "Service role for server"
  policy      = data.aws_iam_policy_document.server_server_pol_doc.json
}

resource "aws_iam_role_policy_attachment" "server_server_pol_attach" {
  role       = aws_iam_role.server_role.name
  policy_arn = aws_iam_policy.server_policy.arn
}

data "aws_iam_policy_document" "server_server_pol_doc" {
  statement {
    sid    = "Secrets"
    effect = "Allow"

    actions = [
      "secretsmanager:*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "SSMAllow"
    effect = "Allow"

    actions = [
      "ssm:*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "IAM"
    effect = "Allow"

    actions = [
      "iam:PassRole"
    ]

    resources = [
      "*"
    ]
  }
}
