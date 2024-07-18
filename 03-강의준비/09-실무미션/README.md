# CH31_01. 효율적인 인프라 관리를 위해서 Git과 IaC를 이용하여 운영한다.(실무미션)
> **주의사항1**
실습을 진행하기 전에 AWS 계정 및 필요한 권한이 있는지 확인하세요. 모든 명령어와 파일 경로가 정확히 설정되었는지 확인하고, 필요한 도구가 설치되어 있는지 확인합니다.

> **주의사항2**
terraform으로 프로비저닝된 리소스 및 서비스들은 시나리오 종료시마다 반드시 `terraform destroy` 명령어를 사용하여 정리해주세요. 그렇지 않으면, 불필요한 비용이 많이 발생할 수 있습니다. AWS 비용 측정은 시간당으로 계산되기에 매번 리소스를 생성하고 삭제하는 것이 불편하실 수도 있겠지만, 비용을 절감시키기 위해서 권장드립니다. 본인의 상황에 맞게 진행해주세요.

> **주의사항3**
실습 정리할 때, AWS ALB와 TargetGroup, Route53 record은 Terraform에서 상태관리 되지 않기 때문에 수동으로 삭제해야 합니다.
> - AWS Application Load Balancer Controller를 사용하여 ALB를 생성하였을 경우, ALB와 TargetGroup을 수동으로 삭제해야 합니다.
> - ExternalDNS를 사용하여 Route53 record를 생성하였을 경우, Route53 record를 수동으로 삭제해야 합니다.

<br>

## 챕터명

효율적인 인프라 관리를 위해서 Git과 IaC를 이용하여 운영한다.(실무미션)

<br><br>

## 내용

이 강의에서는 Terraform Cloud를 이용하여 AWS 인프라를 생성하고, GitOps를 통해 애플리케이션을 배포하는 방법을 배웁니다. 또한, Slack을 통해 알림을 받는 방법을 배웁니다.

![Terraform Cloud를 이용한 전반적인 아키텍쳐](../../images/03-09-01.png)
**[그림1. Terraform Cloud를 이용한 전반적인 아키텍쳐]**

<br><br>

## 환경

- AWS 계정
- Github 계정
- Terraform Cloud
- Slack
- kubectl v1.28.4
- k9s v0.28.2
- aws CLI v2.15.17
- EKS v1.28
- ArgoCD 설치

<br><br>

## 시나리오

1. Slack Incoming Webhooks 생성
2. terraform cloud 세팅
  - workspace 생성(infra 레포, working directory 경로 설정, aws)
  - secret 등록
```
- gitops_org_username: "본인의 Github ID"
- gitops_org_password: "본인의 Github Password(PAT)"
- AWS_SECRET_ACCESS_KEY: "본인의 AWS Secret Access Key"
- AWS_ACCESS_KEY_ID: "본인의 AWS Access Key ID"
```
  - slack 연동
3. terraform cloud로 인프라 생성
4. 확인
  - AWS Console
  - kubectl로 EKS 연결
  - k9s로 리소스가 잘 생성되었는지 확인
  - ArgoCD UI로 Repo, Project, App 확인
  - Guestbook 애플리케이션 확인(브라우저로 접속)
5. terraform cloud로 인프라 삭제

<br><br>

## 파일 설명
|파일명|설명|
|---|---|
|aws/*|Terraform을 사용하여 AWS 인프라를 생성하는 코드|
|gitops/*|GitOps repo에 배포할 애드온 및 애플리케이션 코드|

<br><br>

## 참고

- [Slack 워크스페이스 생성](https://slack.com/intl/ko-kr/help/articles/206845317-Slack-%EC%9B%8C%ED%81%AC%EC%8A%A4%ED%8E%98%EC%9D%B4%EC%8A%A4-%EC%83%9D%EC%84%B1)
- [Slack Incoming Webhooks](https://api.slack.com/messaging/webhooks)
- [Github Organization](https://docs.github.com/en/organizations)
- [Terraform Cloud](https://www.terraform.io/cloud)
- [Terraform Cloud 생성](https://learn.hashicorp.com/tutorials/terraform/cloud-sign-up?in=terraform/cloud-get-started)
- [Github Personal Access Token](https://docs.github.com/ko/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
