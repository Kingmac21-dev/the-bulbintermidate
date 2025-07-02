provider "aws" { 
    access_key = ""
    secret_key = ""
    region = "us-east-1"
}

resource "aws_instance" "web" {
 ami          = "ami-020cba7c55df1f615"
 instance_type = "t2.micro"

  tags = {
  Name = "mac-instance"
  }
}

resource "aws_s3_bucket" "mac-bucket" {
  bucket = "chinonso-bucket2007"

  tags = {
    Name        = "macauley-bucket"
    Environment = "Dev"
  }
}