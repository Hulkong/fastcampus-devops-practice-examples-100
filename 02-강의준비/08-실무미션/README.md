# CH21_01. 도커라이징시 최적화하여 CI 빌드속도를 높여 실질적인 서비스 안정성을 높여본다.
> **주의사항**
terraform으로 프로비저닝된 리소스 및 서비스들은 시나리오 종료시마다 반드시 `terraform destroy` 명령어를 사용하여 정리해주세요. 그렇지 않으면, 불필요한 비용이 많이 발생할 수 있습니다. AWS 비용 측정은 시간당으로 계산되기에 매번 리소스를 생성하고 삭제하는 것이 불편하실 수도 있겠지만, 비용을 절감시키기 위해서 권장드립니다. 본인의 상황에 맞게 진행해주세요.

<br>

## 챕터명

도커라이징시 최적화하여 CI 빌드속도를 높여 실질적인 서비스 안정성을 높여본다.(실무미션)

<br><br>

## 내용

운영을 하다 보면, 개발 생산성과 서비스의 가용성을 높이기 위해 많은 고민을 합니다. 이 중, 드라마틱한 결과를 낼 수 있는 부분이 있습니다.

1. 컨테이너 이미지를 최적화하여 CI 빌드속도를 높여 실질적인 서비스 안정성을 높여본다.
2. Github Actions의 CI 빌드속도를 높여 개발 생산성을 높인다.

우선 컨테이너 이미지를 최적화 해봅니다. 다음의 안 좋은 예시의 Dockerfile이고, 각 해결방법에 대해서 알아봅니다.

```Dockerfile
# 1번째 문제: 경량화되지 않은 베이스 이미지 사용하면, 전체적인 이미지 사이즈가 커집니다. -> 경량화된 베이스 이미지를 사용합니다.
# 2번째 문제: latest 태그 사용시, 빌드가 일관성이 없을 수 있습니다. 즉, 빌드를 실행할 때마다 다른 Ubuntu 버전이 사용될 수 있습니다. 이는 예상치 못한 문제를 일으킬 수 있습니다. -> 버전을 명시합니다.
FROM ubuntu:latest

WORKDIR /app

# 3번째 문제: COPY . . 을 사용하면, 불필요한 파일들이 이미지에 포함됩니다. -> .dockerignore 파일을 사용하여 불필요한 파일을 제외합니다.
# 4번째 문제: 하위에 레이어가 캐싱되더라도, 무조건 이 라인의 레이어부터 다시 빌드합니다. 즉, 캐싱이 되지 않습니다. -> COPY . . 를 가장 마지막에 사용합니다.
COPY . .

# 5번째 문제: RUN 지시자를 여러번 사용하면, 이미지 레이어가 많아져 이미지 사이즈가 커집니다. -> &&를 사용하여 하나의 RUN 지시자로 합쳐줍니다.
RUN apt-get -qq update
RUN apt-get -qq upgrade --yes 
RUN apt-get -qq install curl --yes
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get -qq install nodejs --yes

ARG VERSION
ENV VERSION ${VERSION}

# 6번째 문제: 불필요한 패키지를 설치하면, 이미지 사이즈가 커집니다. -> 불필요한 패키지를 제거합니다.
COPY package*.json ./

# 7번째 문제: npm install을 실행하면, 불필요한 패키지가 설치됩니다. -> npm ci --omit=dev를 사용하여 불필요한 패키지가 설치되지 않도록 합니다.
# 8번째 문제: 멀티스테이지 빌드를 사용하지 않으면, 빌드에 사용한 패키지가 이미지에 포함되어 이미지 사이즈가 커집니다. -> 멀티스테이지 빌드를 사용합니다.
RUN npm install

CMD ["npm", "start"]
```

<br>

다음은 최적화된 Dockerfile입니다.

```Dockerfile
# 1. 경량화된 베이스 이미지를 사용합니다. 또한, 멀티스테이지 빌드를 사용하여 빌드에 사용한 패키지가 이미지에 포함되지 않습니다.
FROM node:18-alpine AS base

WORKDIR /app

COPY package*.json ./

# 2. 불필요한 패키지를 제거합니다.
RUN npm ci --omit=dev


FROM node:18-alpine AS deploy

ARG VERSION
ENV VERSION ${VERSION}

WORKDIR /app

# 3. 빌드 레이어에서 생성한 애플리케이션 구동시 필요한 파일만 복사합니다.
COPY --from=base /app/node_modules ./node_modules

# 4. 마지막에 COPY . . 를 사용하여 상위 레이어까지 캐싱되도록 합니다.
COPY . .

CMD ["npm", "start"]
```

<br><br>

다음은 최적화되지 않은 Dockerfile을 기반으로 빌드를 진행하는 비효율적인 Github Actions CI 파일입니다.

```yaml
name: 느린 예시 CI(도커라이징이 최적화되지 않음)

# 수동으로 실행할 수 있도록 workflow_dispatch를 사용합니다. 여기서 imageVersion을 사용자가 입력하면 실제 컨테이너 이미지 태그로 활용됩니다.
# 이후, ArgoCD Image Updater가 해당 태그를 기반으로 이미지를 업데이트합니다.
on:
  workflow_dispatch:
    inputs:
      imageVersion:
        description: 'Image Version'
        required: true
        default: 'v1.0.0'

defaults:
  run:
    working-directory: '02-강의준비/08-실무미션'
        
jobs:
  docker:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      # 1. Node.js 18.x 환경에서 코드를 테스트 합니다.
      - name: Use Node.js 18.x
        uses: actions/setup-node@v2
        with:
          node-version: '18.x'

      - name: Install Dependencies
        run: npm install

      - name: Run Test
        run: npm test


      # 2. 도커 빌드 및 푸시를 진행합니다. 다만, 플랫폼을 시퀀셜하게 빌드하므로 빌드속도가 느립니다.
      - name: Set up QEMU
        uses: docker/setup-qemu-action@v3
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      
      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
      
      - name: Build and push
        uses: docker/build-push-action@v6
        with:
          context: '02-강의준비/08-실무미션'
          file: '02-강의준비/08-실무미션/Dockerfile.bad'
          platforms: linux/amd64,linux/arm/v7    # 두 플랫폼 기반으로 빌드합니다.
          build-args: |
            VERSION=${{ github.event.inputs.imageVersion }}
          push: true
          tags: hulkong/fastcampus-devops-practice-examples-100:part02-08-senario-${{ github.event.inputs.imageVersion }}
```

<br>

다음은 1차적으로 최적화된 Dockerfile을 기반으로 빌드를 진행하는 Github Actions CI 파일입니다.

```yaml
name: 느린 예시 CI(도커라이징이 최적화 되었지만...)

on:
  workflow_dispatch:
    inputs:
      imageVersion:
        description: 'Image Version'
        required: true
        default: 'v1.0.0'

defaults:
  run:
    working-directory: '02-강의준비/08-실무미션'
        
jobs:
  docker:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Use Node.js 18.x
        uses: actions/setup-node@v2
        with:
          node-version: '18.x'

      - name: Install Dependencies
        run: npm install

      - name: Run Test
        run: npm test


      # 도커 빌드 및 푸시를 진행합니다. 다만, 플랫폼을 시퀀셜하게 빌드하므로 빌드속도가 느립니다.
      - name: Set up QEMU
        uses: docker/setup-qemu-action@v3
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      
      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
      
      - name: Build and push
        uses: docker/build-push-action@v6
        with:
          context: '02-강의준비/08-실무미션'
          file: '02-강의준비/08-실무미션/Dockerfile.optimize'
          platforms: linux/amd64,linux/arm/v7
          build-args: |
            VERSION=${{ github.event.inputs.imageVersion }}
          push: true
          tags: hulkong/fastcampus-devops-practice-examples-100:part02-08-senario-${{ github.event.inputs.imageVersion }}
```

<br>

다음은 최적화된 Dockerfile을 기반으로 빌드를 진행하는 Github Actions CI 파일입니다.

```yaml
name: 빠른 예시 CI

on:
  workflow_dispatch:
    inputs:
      imageVersion:
        description: 'Image Version'
        required: true
        default: 'v1.0.0'

env:
  REGISTRY_IMAGE: hulkong/fastcampus-devops-practice-examples-100

jobs:
  build:
    defaults:
      run:
        working-directory: '02-강의준비/08-실무미션'
    runs-on: ubuntu-latest
    # 빌드속도 개선 1: 플랫폼을 병렬로 빌드하므로 빌드속도가 빨라집니다.
    strategy:
      fail-fast: false
      matrix:
        platform:
          - linux/amd64
          - linux/arm/v7
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Use Node.js 18.x
        uses: actions/setup-node@v2
        with:
          node-version: '18.x'

      - name: Install Dependencies
        run: npm install

      - name: Run Test
        run: npm test


      # 도커 빌드 및 푸시를 진행합니다. 병렬적으로 빌드하므로 빌드속도가 빠릅니다.
      - name: Prepare
        run: |
          platform=${{ matrix.platform }}
          echo "PLATFORM_PAIR=${platform//\//-}" >> $GITHUB_ENV
      
      - name: Docker meta
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY_IMAGE }}
          tags: raw,value=part02-08-senario-${{ github.event.inputs.imageVersion }}
          flavor: |
            latest=false
      
      - name: Set up QEMU
        uses: docker/setup-qemu-action@v3
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      
      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
      
      - name: Build and push by digest
        id: build
        uses: docker/build-push-action@v6
        with:
          context: '02-강의준비/08-실무미션'
          file: '02-강의준비/08-실무미션/Dockerfile.optimize2'
          platforms: ${{ matrix.platform }}
          labels: part02-08-senario-${{ steps.meta.outputs.labels }}
          outputs: type=image,name=${{ env.REGISTRY_IMAGE }},push-by-digest=true,name-canonical=true,push=true
          build-args: |
            VERSION=${{ github.event.inputs.imageVersion }}
          # 빌드속도 개선 2: 레이어 캐시를 사용하여 빌드속도를 높입니다. 두 번째 빌드시 레이어 캐시를 사용하여 빌드 속도가 빨라집니다.
          cache-from: type=gha,scope=build-${{ matrix.platform }}
          cache-to: type=gha,mode=max,scope=build-${{ matrix.platform }}
      
      - name: Export digest
        run: |
          mkdir -p /tmp/digests
          digest="${{ steps.build.outputs.digest }}"
          touch "/tmp/digests/${digest#sha256:}"
      
      - name: Upload digest
        uses: actions/upload-artifact@v4
        with:
          name: digests-${{ env.PLATFORM_PAIR }}
          path: /tmp/digests/*
          if-no-files-found: error
          retention-days: 1

  # 상위 job에서 빌드된 이미지를 병합하여 manifest list를 생성하고, 이미지를 최종적으로 업로드합니다.
  merge:
    runs-on: ubuntu-latest
    needs:
      - build
    steps:
      - name: Download digests
        uses: actions/download-artifact@v4
        with:
          path: /tmp/digests
          pattern: digests-*
          merge-multiple: true
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      
      - name: Docker meta
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY_IMAGE }}
          tags: raw,value=part02-08-senario-${{ github.event.inputs.imageVersion }}
      
      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
      
      - name: Create manifest list and push
        working-directory: /tmp/digests
        run: |
          docker buildx imagetools create $(jq -cr '.tags | map("-t " + .) | join(" ")' <<< "$DOCKER_METADATA_OUTPUT_JSON") \
            $(printf '${{ env.REGISTRY_IMAGE }}@sha256:%s ' *)
      
      - name: Inspect image
        run: |
          docker buildx imagetools inspect ${{ env.REGISTRY_IMAGE }}:${{ steps.meta.outputs.version }}
```

이처럼 다양한 빌드 최적화 방법을 사용하여 CI 빌드속도를 높일 수 있습니다.

<br><br>

## 환경

- EKS v1.28
- Terraform CLI v1.6.6
- kubectl v1.28.4
- Docker Desktop v4.15.0
- ArgoCD v2.11.3(👉 https://argo-cd.readthedocs.io/en/stable/getting_started/)
- ArgoCD Image Updater v0.12.0(👉 https://argocd-image-updater.readthedocs.io/en/stable/install/installation/)
- ArgoCD CLI v2.8.6(👉 https://argo-cd.readthedocs.io/en/stable/cli_installation/)

<br><br>

## 시나리오

시나리오는 다음과 같습니다.

1. 도커라이징시 최적화하여 CI 빌드속도를 높여 실질적인 서비스 안정성을 높여본다.
2. Github Actions의 CI 빌드속도를 높이는 다양한 방법을 적용해본다.
3. ArgoCD Image Updater를 사용하여 이미지를 자동으로 업데이트하는 방법을 적용해본다.

<br><br>

## 파일 설명
|파일명|설명|
|---|---|
|src|Node.js로 작성된 간단한 웹 애플리케이션을 구동하기 위한 소스 디렉토리|
|tests|test 코드가 존재하는 디렉토리|
|Dockerfile.bad|최적화되지 않은 Dockerfile|
|Dockerfile.optimize|1차적으로 최적화된 Dockerfile|
|Dockerfile.optimize2|최적화된 Dockerfile|
|Kustomization.yaml|Kustomize를 사용하여 배포하기 위한 파일|
|package-lock.json|프로젝트의 의존성 트리에 대한 정확한 정보를 저장하는 파일|
|package.json|프로젝트의 메타데이터와 의존성 정보를 포함하는 파일|

<br><br>

## 주요명령어

```bash
terraform init                    # 테라폼 모듈 다운로드 및 초기화 작업 진행
terraform plan                    # 테라폼으로 파일에 명시된 리소스들을 프로비저닝 하기 전 확인단계
terraform apply                   # 테라폼으로 파일에 명시된 리소스들을 프로비저닝
terraform destroy                 # 테라폼으로 파일에 명시된 리소스들을 삭제함

kubectl config current-context    # 현재 나의 로컬환경에 연결되어 있는 클러스터 확인
kubectl apply -f {파일명}           # yaml 파일에 기재된 쿠버네티스 리소스들을 생성
kubectl delete -f {파일명}          # yaml 파일에 기재된 쿠버네티스 리소스들을 삭제

# ArgoCD application 리스트 확인
argocd app list

# ArgoCD application 생성
argocd app create {APP_NAME} --repo {GIT_REPO} --path {PATH} --dest-server {DEST_SERVER} --dest-namespace {DEST_NAMESPACE} 

# ArgoCD application 상세정보 확인
argocd app get {APP_NAME}

# ArgoCD application 삭제
argocd app delete {APP_NAME}

# Docker 이미지 빌드
docker build --progress=plain --no-cache --platform linux/amd64 . -t {IMAGE_NAME} -f {DOCKERFILE}

# Docker 이미지 태그 추가
docker tag {SOURCE_IMAGE} {TARGET_IMAGE}

# port-forward
kubectl port-forward {RESOURCE}/{RESOURCE_NAME} {LOCAL_PORT}:{REMOTE_PORT}
```

<br><br>

## 실제 실습 명령어

```bash
# 0. 실습 환경 구축
terraform -chdir=../ init
terraform -chdir=../ plan
terraform -chdir=../ apply --auto-approve

# 1. ArgoCD 설치
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl port-forward svc/argocd-server -n argocd 8080:443
argocd admin initial-password -n argocd
argocd login localhost:8080

# 2. ArgoCD Image Updater 설치
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml

# 3. ArgoCD CLI로 애플리케이션 배포
argocd app list
argocd app create test --repo https://github.com/Hulkong/fastcampus-devops-practice-examples-100.git --path '02-강의준비/08-실무미션' --dest-server https://kubernetes.default.svc --dest-namespace default --sync-policy auto
argocd app get argocd/test
kubectl port-forward deployments/kustomize-sample 5000:5000

# 4. v2.0.0으로 이미지 빌드
docker build --progress=plain --no-cache --platform linux/amd64 . -t hulkong/fastcampus-devops-practice-examples-100:part02-08-senario-v1.0.0 -f Dockerfile.optimize2

# 5. Docker 레지스트리에 푸시
docker login 
docker push hulkong/fastcampus-devops-practice-examples-100:part02-08-senario-v1.0.0

# 6. ArgoCD Image Updater의 annotation 설정
kubectl annotate app test -n argocd \
    argocd-image-updater.argoproj.io/image-list=my-image=hulkong/fastcampus-devops-practice-examples-100 \
    argocd-image-updater.argoproj.io/my-image.allow-tags='regexp:^part02-08-senario-v\d+\.\d+\.\d+$' \
    argocd-image-updater.argoproj.io/my-image.update-strategy=name --overwrite

# 7. 리소스 정리 
argocd app delete argocd/test
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
terraform -chdir=../ destroy --auto-approve
```

<br><br>

## 참고

- [ArgoCD](https://argo-cd.readthedocs.io/en/stable/)
- [ArgoCD Image Updater](https://argocd-image-updater.readthedocs.io/en/stable/)
- [fastcampus-devops-practice-examples-100](https://hub.docker.com/repository/docker/hulkong/fastcampus-devops-practice-examples-100)
- https://docs.docker.com/reference/cli/docker/buildx/build/#cache-from
- [metadata-action](https://github.com/docker/metadata-action?tab=readme-ov-file#flavor-input)
- [build-push-action](https://github.com/docker/build-push-action?tab=readme-ov-file)
