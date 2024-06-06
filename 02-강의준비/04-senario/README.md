# CH17_03. 시나리오 설명 및 실습
> **⚠️ 주의사항**
>
> 이 방법은 Docker Hub의 풀 제한을 시험하기 위한 것입니다. 실제 운영 환경이나 공개적인 서비스에서 이러한 테스트를 수행하는 것은 제한 조건을 위반하는 행위가 될 수 있으므로 주의해야 합니다. 또한, 이미지 풀 제한에 도달하면, 해당 IP 주소에서는 더 이상 이미지를 풀할 수 없게 됩니다. 이는 일시적으로 서비스에 영향을 줄 수 있으므로, 테스트 환경에서만 실행해야 합니다. 그리고 Docker Hub의 풀 제한 정책은 변경될 수 있으므로, 테스트를 실행하기 전에 최신 정책을 확인하세요.
>
> **또한, 아래의 이미지 레지스트리 및 이미지는 본인들의 계정을 사용하여 테스트를 진행해야 합니다. 다른 사람의 계정을 사용하여 테스트를 진행하면, 해당 계정의 풀 제한에 영향을 줄 수 있습니다.**


<br>

## 챕터명

도커 이미지 풀 제약에 대해서 private 저장소를 사용하여 해결

<br><br>

## 내용

도커에선 "약 1%정도의 익명의 사용자가 Docker Hub 전체 다운로드의 30%를 사용" 한다고 말하면서 기존 무제한 다운로드 정책에서 제한된 정책을 발표했습니다.

> Docker Hub Rate Limit Consequences
In order to evaluate the solutions, let’s try to understand how the rate limit works. The current limits as for December, 13th 2023 are the following:
> - 100 pull requests per 6 hours for anonymous users on a free plan. Enforced based on your IP Address.
> - 200 pull requests per 6 hours for authenticated users on a free plan.
> - Up to 5000 pulls per day for paying customers.

anonmyous로 사용하면 공인 IP를 기준으로 rate limit 수를 카운팅 하고, login을 하면 계정 사용자 기준으로 카운팅 합니다.

다시 말하면, 익명 사용자는 IP 기반으로 6시간에 100번, 로그인 사용자는 계정 기반으로 6시간에 200번, 지불 계정 사용자는 1일에 5000번까지 가능하다는 것입니다.

- 익명 유저(`docker login 안함`)인 경우 IP 기반으로 필터링 되며 6시간동안 100번 요청 가능
- 로그인 유저(`docker login 함`)인 경우 계정 기반으로 필터링 되며 6시간동안 200번 요청 가능
- 지불 계정(`pro, team`) 유저(`docker login 함`)인 경우 아무 제한 없음

<br>

그렇다면, k8s node 개수가 많아지면 어떻게 될까요?

**k8s node 개수 와 상관 관계**

- 익명 유저인 경우 node가 많고 각 노드가 public ip를 갖는경우, 노드 당 100개의 요청을 보낼 수 있어 오히려 로그인하는거보다 나을 수 있습니다.
- 로그인 유저일 경우, 모든 노드가 로그인 계정을 공유하여, 200개의 요청 수 제한이 존재합니다. 그러므로 node가 많으면 더 빠르게 rate limit에 도달할 수 있습니다.
- 지불 계정 유저는 요청 수 제한이 증가하지만 그래도 24시간 내에 5000개의 요청 수 제한이 있습니다.

<br>

### 만약 요청 수 제한이 걸리게 된다면 어떤 결과를 초래하게 될까요?
다음은 rate limit가 걸릴 때 발생하는 결과입니다.
```bash
HTTP/1.1 429 Too Many Requests
Cache-Control: no-cache
Connection: close
Content-Type: application/json
{
  "errors": [{
      "code": "TOOMANYREQUESTS",
      "message": "You have reached your pull rate limit. You may increase the limit by authenticating and upgrading: https://www.docker.com/increase-rate-limit"
  }]
}
```
1. 이미지를 다운로드할 수 없게 됩니다.
2. 이미지를 다운로드할 수 없으므로, 컨테이너를 실행할 수 없게 됩니다.
3. 컨테이너를 실행할 수 없으므로, 스케일 아웃 및 배포를 할 수 없고, 그 영향으로 서비스의 가용성이 떨어져 사용자에게 영향을 줍니다.

<br>

### 해결 방법은 다음과 같습니다.

1. Docker Pro 및 Docker Team 계정을 구독하여, Docker Hub에서 24 시간 동안 컨테이너 이미지를 50,000개 다운로드할 수 있습니다. 하지만, 이 방법은 비용이 발생합니다.
2. mirror registry를 구축합니다. 하지만, mirror registry도 rate limit가 걸릴 수 있습니다.
3. Docker Hub 이미지를 프록시하여 Docker Hub에서 이미지를 다운로드하는 대신 프록시 캐시에서 이미지를 다운로드합니다. 하지만, 이 방법은 이미지를 복제하고 유지 관리하는 추가 작업이 필요합니다.
4. 오픈 소스 프로젝트의 경우 Docker Hub에서 이미지를 무제한으로 다운로드할 수 있습니다.
5. Docker Hub에서 이미지를 다운로드하는 대신, Docker Hub 이미지를 복제하여 자체 레지스트리에 저장합니다.
6. Amazon ECR 또는 GitHub Container Registry와 같은 대체 이미지 저장소를 사용합니다.

이 중,`6번 방법`을 권장합니다. 왜냐하면, Docker Hub에서 이미지를 다운로드하는 대신, 이미지를 복제하여 자체 레지스트리에 저장하면, Docker Hub의 rate limit에 영향을 받지 않기 때문입니다.

<br><br>

## 환경

환경은 다음과 같습니다.

- macOS Apple M1
- Lima 0.22.0
- containerd v1.7.16
- nerdctl v1.7.6
- aws cli 2.15.17

> ⚠️ 주의사항
Lima는 현재 windows에서는 지원하지 않습니다.

저희는 docker hub limit pull 제한을 테스트하기 위해, `Lima`를 사용하여 Linux VM을 실행하고, `containerd`와 `nerdctl`을 사용하여 Docker Hub에서 이미지를 다운로드하고, rate limit을 확인해보겠습니다.

Docker Desktop을 사용하지 않는 이유는 내부 메커니즘으로 인해, rate limit을 확인하기 어렵기 때문입니다.

Lima, containerd, nerdctl에 대한 설명은 다음과 같습니다.

- Lima는 macOS에서 Linux VM을 실행할 수 있게 해주는 오픈소스 프로젝트입니다.
- containerd는 Docker의 컨테이너 엔진으로, 컨테이너의 전체 라이프사이클을 관리합니다.
- nerdctl은 containerd의 CLI로, Docker CLI와 유사한 기능을 제공합니다.

<br>

자세한 설명은 다음 링크를 참고하세요.

> 👉 [Lima(Linux Machines)](https://lima-vm.io/docs/installation/)
> 👉 [containerd](https://containerd.io/)
> 👉 [nerdctl](https://github.com/containerd/nerdctl)

<br>

설치는 다음과 같습니다.

```bash
# Lima 설치
$ brew install lima

# 초기화
$ limactl start
? Creating an instance "default"  [Use arrows to move, type to filter]
> Proceed with the current configuration
  Open an editor to review or modify the current configuration
  Choose another template (docker, podman, archlinux, fedora, ...)
  Exit
...
INFO[0029] READY. Run `lima` to open the shell.

# Lima 설치 확인
$ lima uname -a 
Linux lima-default 6.8.0-31-generic ......

# containerd 설치 확인
$ lima containerd --version
containerd github.com/containerd/containerd v1.7.16 ......

# nerdctl 설치 확인
$ lima nerdctl --version
nerdctl version 1.7.6
```

<br><br>

## 시나리오

시나리오는 다음과 같습니다.

실제 쿠버네티스 환경에서 Scale Out 및 배포를 수행하면, Docker Hub의 rate limit에 도달할 수 있습니다. 그와 비슷한 환경을 만들어서 rate limit를 확인해보겠습니다.

1. Docker Hub에 rate limit를 초과하도록 특정 스크립트를 실행합니다. 이 때, rate limit가 감소하는 것과 실제 초과하면 어떤 결과가 나타나는지 확인합니다.
2. 다음은 ECR로 이미지를 복제하여 rate limit를 확인합니다.(`이 부분은 수강생 분들이 직접 실습해보시기 바랍니다.`) 간단하게 다음과 같은 프로세스를 통해서 ECR로 이미지를 복제할 수 있습니다.

```bash
# 1. 이미지 태깅
# 이미지가 복제되기 전에 이미지를 태그해야 합니다. 또한, 이미지가 존재하지 않는다면 미리 준비해야 합니다.
$ docker tag {이미지명}:{태그명} {계정번호}.dkr.ecr.{리전명}.amazonaws.com/{이미지명}:{태그명}

# 2. ECR 로그인
# 이 때, aws cli가 설치되어 있어야 합니다. 또한, aws configure를 통해 계정 정보를 설정해야 합니다.
$ aws ecr get-login-password --region {리전명} | docker login --username AWS --password-stdin {계정번호}.dkr.ecr.{리전명}.amazonaws.com

# 3. ECR 이미지를 지속적으로 다운로드 하고, Rate Limit를 확인
$ ./get-image-pull-limit.sh {계정번호}.dkr.ecr.{리전명}.amazonaws.com/{이미지명}:{태그명}
$ ./check-image-pull-limit.sh
```

여기서 우리는 다음의 두 지표를 확인합니다.

- RateLimit-Limit: 6시간 동안 수행할 수 있는 총 풀 수
- RateLimit-Remaining: 6시간 동안 남은 풀 수

<br><br>

## 주요명령어

```bash
# rate limit 확인하기 위한 Token 발급
TOKEN=$(curl "https://auth.docker.io/token?service=registry.docker.io&scope=repository:{레포지토리명}:pull" | jq -r .token)

# rate limit 확인
curl --head -H "Authorization: Bearer $TOKEN" https://registry-1.docker.io/v2/{레포지토리명}/manifests/{태그명}

# lima를 사용하여 컨테이너 이미지 다운로드
lima nerdctl pull {레포지토리명}:{태그명}

# lima를 사용하여 컨테이너 이미지 삭제
lima nerdctl rmi {레포지토리명}:{태그명}

# ECR 로그인
aws ecr get-login-password --region {리전명} | docker login --username AWS --password-stdin {계정번호}.dkr.ecr.{리전명}.amazonaws.com
```

<br><br>

## 실제 실습 명령어

```bash
# 1. rate limit 확인하기 위해서 컨테이너 이미지를 다운로드하고, 삭제하는 것을 반복하는 스크립트 실행
./get-image-pull-limit.sh hulkong/test-limit:nginx

# 2. 실시간으로 rate limit 확인
./check-image-pull-limit.sh

# 3. ECR로 이미지 복제하여 rate limit 확인
이 부분은 상위 프로세스를 통해서 수강생 분들이 직접 실습해보시기 바랍니다.
```

<br><br>

## 파일 설명
|파일명|설명|
|---|---|
|check-image-pull-limit.sh|rate limit를 확인하는 스크립트|
|get-image-pull-limit.sh|rate limit를 초과하게 만드는 스크립트|

<br><br>

## 참고
- [Docker Hub rate limit](https://docs.docker.com/docker-hub/download-rate-limit/)
- [Lima](https://github.com/lima-vm/lima#getting-started)
- [Docker-Sponsored Open Source Program](https://www.docker.com/community/open-source/application/)

> **Other limits**
Docker Hub also has an overall rate limit to protect the application and infrastructure. This limit applies to all requests to Hub properties including web pages, APIs, and image pulls. The limit is applied per-IP, and while the limit changes over time depending on load and other factors, it's in the order of thousands of requests per minute. The overall rate limit applies to all users equally regardless of account level.  
>
>You can differentiate between these limits by looking at the error code. The "overall limit" returns a simple 429 Too Many Requests response. The pull limit returns a longer error message that includes a link to this page.
>
> 링크: [Docker Hub rate limit](https://docs.docker.com/docker-hub/download-rate-limit/)