resource "aws_elastic_beanstalk_application" "nodejs_app" {
  name        = "my-nodejs-app"
  description = "My Node.js App for AWS Elastic Beanstalk"
}

resource "aws_elastic_beanstalk_environment" "nodejs_env" {
  name                = "my-nodejs-env"
  application         = aws_elastic_beanstalk_application.nodejs_app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.4.6 running Node.js 12"

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "NODE_ENV"
    value     = "production"
  }

  # Add any other settings or configurations as required.
}


resource "aws_iam_role" "beanstalk_instance_role" {
  name = "beanstalk-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "beanstalk_instance_profile" {
  name = "beanstalk-instance-profile"
  role = aws_iam_role.beanstalk_instance_role.name
}

resource "aws_iam_role_policy_attachment" "beanstalk_s3_full" {
  role       = aws_iam_role.beanstalk_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "beanstalk_full" {
  role       = aws_iam_role.beanstalk_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

resource "aws_iam_role_policy_attachment" "beanstalk_worker" {
  role       = aws_iam_role.beanstalk_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}
