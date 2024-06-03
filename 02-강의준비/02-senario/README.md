# 🚀 CH02_03. 시나리오 설명 및 실습
> **⚠️ 주의사항**
이 시나리오는 CI 빌드 속도를 개선하는 방법에 대해 설명합니다. 실습을 진행하기 전에 모든 종속성이 설치되어 있는지 확인하십시오.

<br>

## 📚 챕터명

CI 빌드속도 개선

<br><br>

## 📝 내용

이 시나리오에서는 CI 빌드 속도를 개선하는 다양한 방법을 탐색합니다. Dockerfile 최적화, 캐싱 전략, 병렬 빌드 등 다양한 기법을 사용하여 빌드 속도를 향상시킬 수 있습니다.

![CI 빌드속도 개선](../images/ci-build-speed.png)

<br><br>

## 🌐 환경

- Docker
- GitHub Actions

<br><br>

## 🎬 시나리오

1. 캐싱 전략을 사용하여 종속성 설치 속도 개선
2. 병렬 빌드를 사용하여 여러 작업 동시 실행

<br><br>

## 📌 주요명령어

```bash
# Docker 이미지 빌드
docker build -t my-app .

# Docker 이미지 실행
docker run -p 8080:8080 my-app
```

<br><br>

## 🛠️ 실제 실습 명령어

```bash
# GitHub Actions 워크플로우 실행
git push origin main
```

<br><br>

## 📁 파일 설명
|파일명|설명|
|---|---|
|Dockerfile|애플리케이션을 컨테이너화하기 위한 Dockerfile입니다.|
|app.js|Node.js로 작성된 간단한 웹 애플리케이션입니다.|
|.github/workflows/main.yml|GitHub Actions 워크플로우를 정의하는 YAML 파일입니다.|

<br><br>

## 📚 참고
- [Dockerfile best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [GitHub Actions documentation](https://docs.github.com/en/actions)
- [실습 도커 이미지 저장소](https://hub.docker.com/repository/docker/username/repo)
