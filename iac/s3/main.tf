resource "aws_s3_bucket" "vuln_bucket" {
    bucket = "research-s3-public-access-test-id-1"

    tags = {
        "ResearchID" = "CIS-v5-S3.1" #Key
        "Standard" = "CIS-AWS-5.0.0"
        "Environment" = "Thesis-Lab"
     }
}

#Public access enabled - vulnerability
resource "aws_s3_bucket_public_access_block" "vuln_block" {
    bucket = aws_s3_bucket.vuln_bucket.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false

}
