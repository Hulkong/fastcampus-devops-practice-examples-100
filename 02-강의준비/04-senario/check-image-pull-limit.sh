#!/bin/bash

# 토큰을 가져오는 함수
get_token() {
  TOKEN=$(curl "https://auth.docker.io/token?service=registry.docker.io&scope=repository:hulkong/test-limit:pull" | jq -r .token)
}

# watch 없이 무한 루프를 사용합니다.
while true; do
  # curl 명령을 실행하고 HTTP 상태 코드를 가져옵니다.
  RESPONSE=$(curl --write-out "HTTPSTATUS:%{http_code}" --silent --head -H "Authorization: Bearer $TOKEN" https://registry-1.docker.io/v2/hulkong/test-limit/manifests/nginx)

  # HTTP 상태 코드를 추출합니다.
  STATUS_CODE=$(echo $RESPONSE | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

  # HTTP 상태 코드가 401이면 토큰을 다시 가져옵니다.
  if [ $STATUS_CODE -eq 401 ]; then
    get_token
  fi

  # curl의 출력을 표시합니다.
  curl --head -H "Authorization: Bearer $TOKEN" https://registry-1.docker.io/v2/hulkong/test-limit/manifests/nginx

  # 15초 대기합니다.
  sleep 15
done