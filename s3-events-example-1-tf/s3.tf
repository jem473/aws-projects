resource "aws_s3_bucket" "source_bucket" {
  bucket = var.source_bucket_name
}

resource "aws_s3_bucket" "destination_bucket" {
  bucket = var.destination_bucket_name
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.source_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.convert_to_mp3.arn
    events = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]
    filter_suffix = var.filter_suffix
  }

  depends_on = [aws_lambda_permission.allow_s3_event_notification]
}