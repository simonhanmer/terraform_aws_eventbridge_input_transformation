resource "aws_cloudwatch_event_rule" "test_bucket_event_rule" {
  name        = "${var.project_name}-test-bucket-event-rule"
  description = "Rule to trigger eventbridge on PutObject to test bucket"

  event_pattern = jsonencode(
    {
      "source" : ["aws.s3"],
      "detail-type" : ["AWS API Call via CloudTrail"],
      "detail" : {
        "eventSource" : ["s3.amazonaws.com"],
        "eventName" : ["PutObject"],
        "requestParameters" : {
          "bucketName" : [aws_s3_bucket.test_bucket.id]
        }
      }
    }
  )
}

resource "aws_cloudwatch_event_target" "eventbridge_lambda" {
  rule = aws_cloudwatch_event_rule.test_bucket_event_rule.name
  arn  = aws_lambda_function.reader_function.arn

  input_transformer {
    input_paths = {
      bucketName = "$.detail.requestParameters.bucketName",
      objectKey = "$.detail.requestParameters.key"
      instance = "$.detail.instance",
      status   = "$.detail.status",
    }
    input_template = <<EOF
{
    "Records": [
        {
            "eventName": "ObjectCreated:Put",
            "s3": {
                "bucket": {
                    "name": <bucketName>,
                    "arn": "arn:aws:s3:::<bucketName>"
                },
                "object": {
                    "key": <objectKey>
                }
            }
        }
    ]
}
EOF
  }
}
