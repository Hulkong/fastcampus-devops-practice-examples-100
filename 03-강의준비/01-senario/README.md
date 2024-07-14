# CH23_03. 시나리오 설명 및 실습
> **주의사항**
Terraform을 사용할 때는 변경사항이 의도하지 않은 영향을 미치지 않도록 신중하게 계획하고 실행해야 합니다. 특히, S3 버킷의 공개 설정, Route53 레코드 타입 변경, 모듈 종속성 관리, 배열 사용 시 요소 추가/삭제와 같은 경우에는 더욱 주의가 필요합니다.

<br>

## 챕터명

Terraform 사용시 주의사항

<br><br>

## 내용

이 강의에서는 Terraform을 사용하면서 주의해야 할 몇 가지 중요한 사항에 대해 다룹니다. S3 버킷을 private에서 public으로 변경하는 경우, Route53 레코드 타입을 변경하는 경우, 모듈 사용으로 인한 종속성 이슈, 배열 사용 시 중간에 요소를 추가하거나 삭제할 때 발생하는 문제 등을 실습을 통해 확인합니다.

<br><br>

## 환경

- AWS 계정
- AWS CLI v2.15.17
- Terraform CLI v1.6.6

<br><br>

## 시나리오

1. **S3 버킷을 private에서 public으로 변경**
   - S3 버킷의 ACL을 private에서 public으로 변경할 때, 테라폼에서 이를 감지하지 못하는 문제를 실습합니다.

2. **Route53 레코드 타입 변경**
   - Route53 레코드의 타입을 변경할 때, 테라폼에서 이를 감지하지 못하는 문제를 실습합니다.

3. **모듈 사용으로 인한 종속성 이슈**
   - Terraform 모듈 사용 시 발생할 수 있는 종속성 문제를 다룹니다. 예를 들어, VPC 변경 시 서브넷 및 EC2 인스턴스가 재생성되는 문제를 실습합니다.

4. **배열 사용 시 요소 추가/삭제**
   - Terraform에서 배열을 사용할 때 중간에 요소를 추가하거나 삭제하면 리소스가 삭제되고 다시 생성되는 문제를 실습을 통해 확인하고, 이를 방지하는 방법을 알아봅니다.

<br><br>

## 파일 설명
|파일명|설명|
|---|---|
|provider.tf|AWS 프로바이더 설정|
|01-example.tf|S3 버킷을 private에서 public으로 변경하는 예제|
|02-example.tf|Route53 레코드 타입 변경하는 예제|
|03-example.tf|모듈 사용으로 인한 종속성 이슈 예제|
|04-example.tf|배열 사용 시 요소 추가/삭제 예제|

<br><br>

## 주요명령어

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

<br><br>

## 실제 실습 명령어

```bash
terraform init
terraform apply --auto-approve
terraform destroy --auto-approve
```
