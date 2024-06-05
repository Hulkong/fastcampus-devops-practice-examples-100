# Part02. CI&CD 안정적 운영
---

- 디렉토리명: `02-강의준비`

|챕터명|클립명|실습자료명|
|---|---|---|
|사전준비|CH14_01. 사전준비|01-prepare|
|CI 빌드속도 개선|CH15_03. 시나리오 설명 및 실습|02-senario|
|도커라이징 최적화|CH16_03. 시나리오 설명 및 실습|03-senario|
|도커 이미지 풀 제약에 대해서 private 저장소를 사용하여 해결|CH17_03. 시나리오 설명 및 실습|04-senario|
|ArgoCD Image Updater를 사용하여 완전한 pull 방식을 지향|CH18_03. 시나리오 설명 및 실습|05-senario|
|secret값 변경시, ArgoCD에서 동기화 하는 방법|CH19_03. 시나리오 설명 및 실습|06-senario|
|argocd에서 orphaned resource를 어떻게 모니터링 할까?|CH20_02. 시나리오 설명 및 실습|07-senario|
|도커라이징시 최적화하여 CI 빌드속도를 높여 실질적인 서비스 안정성을 높여본다.(실무미션)|CH21_01. 도커라이징시 최적화하여 CI 빌드속도를 높여 실질적인 서비스 안정성을 높여본다.|08-senario|

<br><br>

## 실습 환경

|도구명|용도|버전|비고|
|---|---|---|---|
|Terraform Cli|Terraform을 실행하기 도구|v1.6.3|-|
|kubectl|쿠버네티스 클러스터와 통신하기 위한 CLI 도구|v1.28.4|-|
|k9s|쿠버네티스 클러스터를 터미널에서 쉽게 관리할 수 있게 해주는 도구|v0.28.2|-|
|aws CLI|AWS 리소스를 관리하기 위한 CLI 도구|v2.15.17|-|
|EKS|AWS에서 제공하는 쿠버네티스 서비스|v1.28|-|
|act|GitHub Actions를 로컬에서 실행할 수 있게 해주는 도구|v0.2.56|-|
|Docker Desktop|Windows와 Mac 운영 체제에서 Docker를 실행하고 관리하기 위한 도구|4.15.0|-|
|Docker Hub|Docker 이미지를 저장하고 공유하는 클라우드 기반의 레지스트리 서비스|-|-|
|ECR|AWS에서 제공하는 Docker 컨테이너 이미지 저장소 서비스|-|-|
|GitHub Actions|GitHub에서 직접 소프트웨어 개발 워크플로우를 자동화할 수 있는 도구|-|-|
|ArgoCD|쿠버네티스에 대한 선언적인 GitOps 연속 배포 도구|-|-|
|ArgoCD Image Updater|쿠버네티스 클러스터에서 실행되는 애플리케이션의 컨테이너 이미지를 자동으로 업데이트하는 Argo CD의 확장 도구|-|-|
|ArgoCD Vault Plugin|Argo CD에서 HashiCorp Vault를 사용하여 비밀을 관리하는 데 도움이 되는 플러그인|-|-|

참고로, Windows에서는 WSL(Windows Subsystem for Linux)을 사용하여 Linux 환경을 구축하고 그 안에서 각 종 툴을 사용하는 것도 좋은 대안이 될 수 있습니다. 이 방법을 통하면 Linux에서와 동일한 방식으로 툴을 사용할 수 있습니다.
> [wsl 공식 설치 문서](https://learn.microsoft.com/ko-kr/windows/wsl/install) 
[Windows에서 WSL(Linux 개발 환경) 구축하기](https://tech.cloud.nongshim.co.kr/2023/11/14/windows%EC%97%90%EC%84%9C-wsllinux-%EA%B0%9C%EB%B0%9C-%ED%99%98%EA%B2%BD-%EA%B5%AC%EC%B6%95%ED%95%98%EA%B8%B0/)

또는, 리눅스의 apt와 같은 패키지 매니저 역할을 하는 window의 choco라는 툴을 이용하면 윈도우에서도 편리하게 라이브러리를 설치할 수 있으나, 사용하려는 툴을 지원하는지 확인해보아야 합니다.
> [choco 설치 방법](https://chocolatey.org/install) 
[패키지를 지원하는지 검색 필요](https://community.chocolatey.org/packages)

<br>

### 1. Terraform cli 설치

**Terraform**는 인프라스트럭처를 코드로 관리하기 위한 도구입니다.

> 아래의 링크에 각 OS 환경에 맞는 설치 방법이 나와 있습니다. 
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

```bash
# ex. MacOS에서 특정 Terraform CLI 설치
brew tap hashicorp/tap
brew install hashicorp/tap/terraform@1.6.3
```

<br>

### 2. kubectl 설치

**kubectl**은 쿠버네티스 클러스터와 통신하기 위한 CLI 도구입니다.

> 아래의 링크에 각 OS 환경에 맞는 설치 방법이 나와 있습니다. 
https://kubernetes.io/ko/docs/tasks/tools/

<br>

### 3. k9s 설치

**k9s**는 쿠버네티스 클러스터를 터미널에서 쉽게 관리할 수 있게 해주는 도구입니다.

> 아래의 링크에 각 OS 환경에 맞는 설치 방법이 나와 있습니다. 
https://kubernetes.io/ko/docs/tasks/tools/

<br>

### 4. aws-cli 설치

**aws-cli**는 AWS 리소스를 관리하기 위한 CLI 도구입니다.

> 아래의 링크에 각 OS 환경에 맞는 설치 방법이 나와 있습니다. 
https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/getting-started-install.html

<br>

### 5. EKS 설치

**EKS**는 AWS에서 제공하는 쿠버네티스 서비스입니다.

> EKS는 02-강의준비/main.tf 파일을 기반으로 테라폼으로 프로비저닝 할 수 있습니다.

```terraform
# 02-강의준비/main.tf
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.15"

  cluster_name                   = local.name
  ......
}
```

```bash
# terraform으로 EKS 프로비저닝
cd fastcampus-devops-practice-examples-100
terraform -chdir=02-강의준비 plan
terraform -chdir=02-강의준비 apply
```

<br>

### 6. act 설치

**act**는 GitHub Actions를 로컬에서 실행할 수 있게 해주는 도구입니다.

> 아래의 링크에 각 OS 환경에 맞는 설치 방법이 나와 있습니다. 
https://nektosact.com/installation/index.html

<br><br>

## Tips

```bash
# EKS 클러스터의 인증정보를 기반으로 나의 로컬의 kubeconfig를 업데이트 하는 명령어
# 실제 kubectl과 같은 CLI를 사용할 때 필요합니다.
aws eks --region {REGION명} update-kubeconfig --name {클러스터 명}
aws eks --region us-west-2 update-kubeconfig --name part02

# 쿠버네티스 컨텍스트를 설정하고자 할 때 다음과 같은 명령어를 사용해 주세요.
## 다음 명령어로 현재 내 로컬에 설정되어 있는 context들을 확인합니다.
kubectl config get-contexts

## 위에서 확인한 컨텍스트를 기반으로 설정합니다.
kubectl config use-context arn:aws:eks:us-west-2:{AWS Account ID}:cluster/part02
```

<br>

## 주의사항

- 모든 리소스 정리시, 항상 EKS 내의 모든 리소스를 제거 후에 `terraform destroy`를 진행해 주세요. 예를 들어, 메니페스트 Ingress로 생성한 ALB가 먼저 삭제되지 않으면, `terraform destroy`을 사용해도 정상적으로 리소스가 제거되지 않습니다.

- Terraform으로 실습환경 구축시, 다음과 같이 AWS loadbalancer 쪽에 문제가 있을 경우, terraform apply 명령어를 재실행 해주거나, main.tf의 EKS module 내부의 cluster_addons에서 `aws-ebs-csi-driver` 필드를 주석치고 먼저 프로비저닝 한 다음, 다시 주석을 해제하고 다시 apply 해보세요.
```text
╷
│ Error: 1 error occurred:
│ 	* Internal error occurred: failed calling webhook "mservice.elbv2.k8s.aws": failed to call webhook: Post "https://aws-load-balancer-webhook-service.kube-system.svc:443/mutate-v1-service?timeout=10s": no endpoints available for service "aws-load-balancer-webhook-service"
```
