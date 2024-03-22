# Part01. 쿠버네티스 안정적 운영 실습

## 실습 환경

- Terraform Cli v1.6.3
- kubectl v1.28.4
- k9s v0.28.2
- aws CLI v2.15.17
- vegeta v12.11.1
- EKS v1.28

참고로, Windows에서는 WSL(Windows Subsystem for Linux)을 사용하여 Linux 환경을 구축하고 그 안에서 각 종 툴을 사용하는 것도 좋은 대안이 될 수 있습니다. 이 방법을 통하면 Linux에서와 동일한 방식으로 툴을 사용할 수 있습니다.
> [wsl 공식 설치 문서](https://learn.microsoft.com/ko-kr/windows/wsl/install) 
[Windows에서 WSL(Linux 개발 환경) 구축하기](https://tech.cloud.nongshim.co.kr/2023/11/14/windows%EC%97%90%EC%84%9C-wsllinux-%EA%B0%9C%EB%B0%9C-%ED%99%98%EA%B2%BD-%EA%B5%AC%EC%B6%95%ED%95%98%EA%B8%B0/)

또는, 리눅스의 apt와 같은 패키지 매니저 역할을 하는 window의 choco라는 툴을 이용하면 윈도우에서도 편리하게 라이브러리를 설치할 수 있으나, 사용하려는 툴을 지원하는지 확인해보아야 합니다.
> [choco 설치 방법](https://chocolatey.org/install) 
[패키지를 지원하는지 검색 필요](https://community.chocolatey.org/packages)

<br>

### 1. Terraform cli 설치
> 아래의 링크에 각 OS 환경에 맞는 설치 방법이 나와 있습니다. 
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

```bash
# ex. MacOS에서 특정 Terraform CLI 설치
brew tap hashicorp/tap
brew install hashicorp/tap/terraform@1.6.3
```

<br>

### 2. kubectl 설치
> 아래의 링크에 각 OS 환경에 맞는 설치 방법이 나와 있습니다. 
https://kubernetes.io/ko/docs/tasks/tools/

<br>

### 3. k9s 설치
> 아래의 링크에 각 OS 환경에 맞는 설치 방법이 나와 있습니다. 
https://kubernetes.io/ko/docs/tasks/tools/

<br>

### 4. aws-cli 설치
> 아래의 링크에 각 OS 환경에 맞는 설치 방법이 나와 있습니다. 
https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/getting-started-install.html

<br>

### 5. vegeta 설치
> 아래의 링크에 각 OS 환경에 맞는 설치 방법이 나와 있습니다. 
https://github.com/tsenart/vegeta?tab=readme-ov-file#install

```bash
# ex. macOS
$ brew update && brew install vegeta

# ex. 기타 리눅스 OS
git clone https://github.com/tsenart/vegeta
cd vegeta
make vegeta
mv vegeta ~/bin # Or elsewhere, up to you.
```