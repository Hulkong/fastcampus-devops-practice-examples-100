# CH29_03. 시나리오 설명 및 실습
> **주의사항**
terraform으로 프로비저닝된 리소스 및 서비스들은 시나리오 종료시마다 반드시 `terraform destroy` 명령어를 사용하여 정리해주세요. 그렇지 않으면, 불필요한 비용이 많이 발생할 수 있습니다. AWS 비용 측정은 시간당으로 계산되기에 매번 리소스를 생성하고 삭제하는 것이 불편하실 수도 있겠지만, 비용을 절감시키기 위해서 권장드립니다. 본인의 상황에 맞게 진행해주세요.
> - 실습을 진행하기 전에 AWS CLI가 설치되어 있어야 합니다.
> - Terraform이 설치되어 있어야 합니다.
> - IAM 권한이 적절히 설정되어 있는지 확인하십시오.

<br>

## 챕터명

비용절감을 위하여 람다를 이용하여 유휴상태인 RDS 사용정지하는 시나리오를 진행해 본다.

<br><br>

## 내용

이 실습에서는 AWS Lambda와 CloudWatch 이벤트를 사용하여 RDS 인스턴스를 자동으로 시작하고 종료하는 방법을 배웁니다. Lambda 함수는 매일 오전 8시에 RDS 인스턴스를 시작하고, 오후 8시에 종료하도록 설정됩니다. 이를 통해 유휴 상태의 RDS 인스턴스에 대한 비용을 절감할 수 있습니다.

![시나리오 다이어그램](../../images/03-06-01.png)
**[그림1. AWS Lambda와 CloudWatch 이벤트를 사용하여 RDS 인스턴스를 자동으로 시작하고 종료하는 플로우]**

<br><br>

## 환경

- AWS 계정
- AWS CLI v2.15.17
- Terraform CLI v1.6.6
- 적절한 IAM 권한 (Lambda, RDS, CloudWatch 이벤트 관리 권한)

<br><br>

## 시나리오

1. Terraform을 사용하여 Lambda 함수 및 관련 자원을 생성합니다.
2. Lambda 함수는 CloudWatch 이벤트에 의해 트리거됩니다.
3. CloudWatch 이벤트는 매일 오전 8시에 RDS 인스턴스를 시작하고, 오후 8시에 종료하도록 설정됩니다. 다만, 여기서는 Test 버튼을 클릭하여 실습을 진행하도록 하겠습니다.
4. Lambda 함수는 RDS 인스턴스를 시작하고 종료하는 역할을 수행합니다.
5. 이 설정을 통해 유휴 상태의 RDS 인스턴스에 대한 비용을 절감할 수 있습니다.

<br><br>

## 파일 설명
|파일명|설명|
|---|---|
|main.tf|Terraform 메인 구성 파일로 Lambda 함수, CloudWatch 이벤트 및 관련 자원을 정의합니다.|
|start_rds.py|Lambda 함수 코드로, RDS 인스턴스를 시작하고 로직을 포함합니다.|
|stop_rds.py|Lambda 함수 코드로, RDS 인스턴스를 종료하는 로직을 포함합니다.|

<br><br>

## 주요명령어

```bash
terraform init
terraform apply --auto-approve
```

<br><br>

## 실제 실습 명령어

```bash
# 0. 실습 환경 구축
terraform -chdir=../ init
terraform -chdir=../ plan
terraform -chdir=../ apply --auto-approve

# 1. AWS CloudWatch, Lambda, RDS 인스턴스 생성
terraform init
terraform apply --auto-approve

# 2. 실습환경 삭제
terraform destroy --auto-approve
```

<br><br>

## 참고

- [AWS Lambda 공식 문서](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)
- [AWS RDS 공식 문서](https://docs.aws.amazon.com/rds/index.html)
