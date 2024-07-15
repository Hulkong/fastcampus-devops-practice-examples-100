# CH25_03. 시나리오 설명 및 실습
> **주의사항**
이 실습에서는 AWS 서비스 쿼타를 의도적으로 초과시켜 문제를 재현하고, 이를 해결하는 방법을 배웁니다. 실습 과정에서 AWS 자원이 소모되므로, 실습이 끝난 후 반드시 모든 자원을 삭제하여 비용이 발생하지 않도록 주의하세요.

<br>

## 챕터명

AWS 서비스 쿼타의 문제를 발생시키고, 해결해 본다.

<br><br>

## 내용

이 강의에서는 AWS 서비스 쿼타 초과 문제를 재현하고, 이를 해결하는 방법을 실습합니다.
1. Elastic IP (EIP) 쿼타 초과 이슈

<br><br>

## 환경

- AWS 계정
- AWS CLI v2.15.17
- Terraform CLI v1.6.6

<br><br>

## 시나리오

### 시나리오1: EIP 쿼타 초과 이슈를 재현하고, 해결해 본다.
1. 여러 개의 Elastic IP를 할당하여 기본 쿼타(5개)를 초과합니다.
2. EIP 할당 시 발생하는 오류 메시지를 확인합니다.
3. AWS Management Console 또는 AWS CLI를 사용하여 EIP 쿼타 증가 요청을 제출합니다.
4. 쿼타 증가가 승인되면 다시 EIP를 할당하여 문제가 해결되었음을 확인합니다.

<br><br>

## 파일 설명
|파일명|설명|
|---|---|
|provider.tf|Terraform 공급자 설정 파일|
|01-example.tf|EIP 쿼타 초과 시나리오|
|02-example.tf|리전 당 VPC 생성 개수 쿼타 초과 시나리오|
|03-example.tf|S3 Bucket 개수 쿼타 초과 시나리오|

<br><br>

## 주요명령어

```bash
# Terraform 주요 명령어
terraform init
terraform plan
terraform apply
terraform destroy
```

<br><br>

## 실제 실습 명령어

```bash
# 0. 실습 환경 구축
terraform -chdir=../ init
terraform -chdir=../ plan
terraform -chdir=../ apply --auto-approve

# 1. EIP 쿼타 초과 이슈 재현 및 해결
terraform init
terraform apply --auto-approve

# 2. 실습환경 삭제
terraform destroy --auto-approve
```
