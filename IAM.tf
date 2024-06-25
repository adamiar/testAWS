resource "aws_iam_role" "ec2_role" { # permet à une instance EC2 de lancer des actions en utilisant le service ec2.amazonaws.com
  name = "ec2_role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

data "aws_iam_policy_document" "write_policy_document" {
  statement {
    principals {
      type = "AWS"
      identifiers = [aws_iam_role.ec2_role.arn]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.bucket_test_tf.arn}/can_be_written/*"]
    effect = "Allow"
 
  }
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}
