resource "aws_route53_zone" "sub" {
  name = local.domain
}

resource "aws_route53_record" "nameserver" {
  allow_overwrite = false
  name            = aws_route53_zone.sub.name
  ttl             = 300
  type            = "NS"
  zone_id         = data.aws_route53_zone.selected.zone_id

  records = aws_route53_zone.sub.name_servers
}
