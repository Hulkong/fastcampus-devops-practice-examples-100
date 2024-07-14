# 2. Route53 레코드 타입 변경
# 이 코드를 실행한 후, AWS 콘솔에서 레코드 타입을 변경하면, 테라폼은 변경 사항을 인식하지 못하고, 인프라 배포에 실패할 수 있습니다.
# resource "aws_route53_zone" "primary" {
#   name = "part03-example.com"
# }

# resource "aws_route53_record" "www" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "www.part03-example.com"
#   type    = "A"
#   ttl     = "300"
#   records = ["192.0.2.44"]
# }
