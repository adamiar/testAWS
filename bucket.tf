resource "aws_s3_bucket" "bucket_test_tf" {
  bucket = "bucket-test-tf-adamiar13"
  tags = {
    Name = "bucket-test-tf-adamiar13"
  }
}

# resource "aws_s3_bucket_acl" "acl_bucket_test" {

#   bucket = aws_s3_bucket.bucket_test_tf.id
#   acl    = "private"
# }

resource "aws_s3_bucket_policy" "bucket_test_policy" {
  bucket = "bucket-test-tf-adamiar13"
  policy = data.aws_iam_policy_document.write_policy_document.json
}

