module "s3_buckets" {
  for_each = var.buckets

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.9.0"

  bucket = each.key
  tags   = each.value.tags

  # Secure bucket settings (v4-compatible)
  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "static_site_policy" {
  for_each = {
    for name, cfg in var.buckets : name => cfg
    if lookup(cfg, "policy", null) != null
  }

  bucket = module.s3_buckets[each.key].s3_bucket_id
  policy = each.value.policy
}