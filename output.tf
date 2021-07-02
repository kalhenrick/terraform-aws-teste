output "public_ip" {
    value = aws_eip.elastic_public_ip.public_ip
}

output "bucket_name" {
    value = aws_s3_bucket.bucket.bucket
}