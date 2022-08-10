resource "aws_lambda_function" "convert_to_mp3" {
  function_name = "convert_to_mp3"
  filename = var.lambda_filename
  role = aws_iam_role.convert_to_mp3_role.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.9"
  architectures = ["arm64"]
  memory_size = var.lambda_memory

  layers = [aws_lambda_layer_version.ffmpeg_layer.arn]

  environment {
    variables = {
      MP3Bucket = var.destination_bucket_name
    }
  }
}

resource "aws_lambda_layer_version" "ffmpeg_layer" {
  layer_name = "ffmpeg"
  filename = var.ffmpeg_layer_filename
}

resource "aws_iam_role" "convert_to_mp3_role" {
  name = "ConvertToMP3Role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "convert_to_mp3_role_s3_policy" {
  name = "ConvertToMP3RolePolicy"
  description = "Allows conversion Lambda to access relevant S3 Buckets."

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "${aws_s3_bucket.source_bucket.arn}/*"
    },
    {
      "Effect": "Allow",
      "Action": [
          "s3:PutObject",
          "s3:DeleteObject"
      ],
      "Resource": "${aws_s3_bucket.destination_bucket.arn}/*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "convert_to_mp3_role_s3_policy_attach" {
  role = aws_iam_role.convert_to_mp3_role.name
  policy_arn = aws_iam_policy.convert_to_mp3_role_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_cloudwatch_attach" {
  role = aws_iam_role.convert_to_mp3_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "allow_s3_event_notification" {
  statement_id = "AllowS3Event"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.convert_to_mp3.arn
  principal = "s3.amazonaws.com"
  source_arn = aws_s3_bucket.source_bucket.arn
}