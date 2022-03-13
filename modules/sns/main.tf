resource "aws_sns_topic" "topic-update" {
  name = "user-update-topic"
}

resource "aws_sqs_queue" "queue_service" {
  name = "aws_queue_service"
}

resource "aws_sns_topic_subscription" "sub-topics" {
  topic_arn = aws_sns_topic.topic-update.arn
  protocol = "email"
  endpoint = "venkatachalapathys1996@gmail.com"
}
