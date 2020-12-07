provider "aws" {
  alias  = "west"
  region = "us-west-1"
}

resource "aws_s3_bucket" "b" {
  provider = aws.west
  bucket = "project-cloud-martijn"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_object" "file_upload_nature" {
  provider = aws.west
  bucket = aws_s3_bucket.b.id
  key    = "nature.jpg"
  source = "nature.jpg"
}

resource "aws_s3_bucket_object" "file_upload_fords" {
  provider = aws.west
  bucket = aws_s3_bucket.b.id
  key    = "fjords.jpg"
  source = "fjords.jpg"
}

resource "aws_s3_bucket_object" "file_upload_lights" {
  provider = aws.west
  bucket = aws_s3_bucket.b.id
  key    = "lights.jpg"
  source = "lights.jpg"
}

resource "aws_s3_bucket_policy" "b" {
  provider = aws.west
  bucket = aws_s3_bucket.b.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::project-cloud-martijn/*"
    }
  ]
}
POLICY
}