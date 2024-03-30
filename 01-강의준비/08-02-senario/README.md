# Part CH09_04. 멀티 클러스터 버전 업그레이드 프로세스
> **주의사항1**
멀티 클러스터 버전을 업그레이드 하는 실습은 기본적으로 EKS를 두 개 이상 필요하기에 일반적인 상황보다 과금이 더 발생할 수 있습니다. 이러한 점을 인지하고 진행하시기 바랍니다. 상황에 따라서 실습 영상으로만 해당 내용을 파악하셔도 크게 무리가 없습니다.

> **주의사항2**
terraform으로 프로비저닝된 리소스 및 서비스들은 시나리오 종료시마다 반드시 `terraform destroy` 명령어를 사용하여 정리해주세요. 그렇지 않으면, 불필요한 비용이 많이 발생할 수 있습니다. AWS 비용 측정은 시간당으로 계산되기에 매번 리소스를 생성하고 삭제하는 것이 불편하실 수도 있겠지만, 비용을 절감시키기 위해서 권장드립니다. 본인의 상황에 맞게 진행해주세요.

<br>

## 챕터명

멀티 클러스터 버전 업그레이드 프로세스

<br><br>

## 내용

클러스터 버전을 업그레이드 방법 중, `멀티 클러스터`를 기준으로 업그레이드를 진행하는 프로세스에 대해서 실습을 진행해 보고자 합니다.

<br>

![multi_cluster](../../images/09-senario.png)
**[그림1. 멀티 클러스터를 이용하여 EKS 노드 버전을 업그레이드]**

<br><br>

## 환경

- Terraform
- EKS
- ALB
- Route53
- Karpenter
- Sample application

<br><br>

## 시나리오

멀티 클러스터 환경에서 서비스의 다운타임을 최소화하여 노드 버전을 업그레이드해보자

<br><br>

## 실제 실습 명령어

```bash
# 0. 실습 환경 구축
terraform -chdir=../ plan 
terraform -chdir=../ apply --auto-approve

# 1. 쿠버네티스 리소스의 생성을 확인
watch kubectl get all --namespace 08-senario

# 2. 기존 버전의 EKS 클러스터에 샘플 애플리케이션 배포
kubectl apply -f ../08-01-senario/sample-app.yaml

# 3. curl 명령어를 통해 샘플 애플리케이션 호출 테스트
watch -n 2 curl "http://$(kubectl get -n 08-senario ingress/nginx-ingress -o jsonpath='{.status.loadBalancer.ingress[*].hostname}')"

# 4. 50:50으로 DNS 리졸빙을 진행하는지 확인
# 본인의 도메인으로 변경해주세요.
watch -n 2 dig +short "$(kubectl get ingress nginx-ingress -n 08-senario -o jsonpath="{.metadata.annotations['external-dns\.alpha\.kubernetes\.io/hostname']}")"

# 5. 신규 버전의 EKS 클러스터와 가중치 전환을 위한 Routet53에 Hosted Zone 생성
terraform apply --auto-approve

# 6. 신규 클러스터에 접근하기 위한 kubeconfig 파일 업데이트
aws eks --region us-west-2 update-kubeconfig --name part01-new

# 7. 현재 나의 로컬환경에 설정된 클러스터의 컨텍스트가 무엇인지 확인
kubectl config current-context

# 8. 신규 클러스터에 샘플 애플리케이션 배포
kubectl apply -f sample-app-new.yaml

# 9. 샘플 애플리케이션 삭제
kubectl delete -f sample-app-new.yaml

# 10. 신규 클러스터 제거
terraform destroy --auto-approve

# 11. 기존 애플리케이션 삭제
kubectl delete -f ../08-01-senario/sample-app.yaml

# 12. 실습 환경 제거
terraform -chdir=../ destroy --auto-approve
```

<br><br>

## 파일 설명
|파일명|설명|
|---|---|
|sample-app-new.yaml|신규 EKS 클러스터에 배포할 샘플 애플리케이션 메니페스트|
|08-senario-new-cluster.tf|신규 EKS 클러스터를 배포하는 테라폼 파일|
|output.tf|신규 EKS 클러스터에 접속하기 위한 명령어 출력 테라폼 파일|
|versions.tf|테라폼 및 프로바이더의 버전을 명시하는 테라폼 파일|

<br><br>

## 참고
- [Onfido’s Journey to a Multi-Cluster Amazon EKS Architecture](https://aws.amazon.com/ko/blogs/containers/)
- [freenom](https://www.freenom.com/)
- [도메인 등록 대행 및 서버 호스팅(가비아)](https://www.gabia.com/)
- [ExternalDNS](https://github.com/kubernetes-sigs/external-dns)
- [dig 명령](https://ko.wikipedia.org/wiki/Dig#:~:text=dig%20(domain%20information%20groper)%EB%8A%94,%EB%AA%85%EB%A0%B9%20%EC%A4%84%20%EC%9D%B8%ED%84%B0%ED%8E%98%EC%9D%B4%EC%8A%A4%20%ED%88%B4%EC%9D%B4%EB%8B%A4.&text=dig%EB%8A%94%20%EB%84%A4%ED%8A%B8%EC%9B%8C%ED%81%AC%20%ED%8A%B8%EB%9F%AC%EB%B8%94%EC%8A%88%ED%8C%85,%EC%97%90%EC%84%9C%20%EC%9E%91%EB%8F%99%ED%95%A0%20%EC%88%98%20%EC%9E%88%EB%8B%A4.)