# 백엔드 API 명세서 (앱 개발용)

## 기본 정보
- **Base URL**: 서버 설정에 따름 (환경변수로 관리 예정)
- **인증 방식**: JWT (Access Token + Refresh Token)
- **Content-Type**: application/json

---

## 1. 인증 (Authentication)

### 1.1 일반 로그인
**POST** `/api/user/login`

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**설명:**
- Access Token 유효기간: 24시간 (86400000ms)
- Refresh Token 유효기간: 7일 (604800000ms)

---

### 1.2 VR 기기 로그인 (Device Code Flow)

#### Step 1: VR 기기에서 인증 코드 생성
**GET** `/api/user/activation`

**Response:**
```json
{
  "status": "success",
  "message": "인증 코드가 생성 되었습니다.",
  "data": {
    "authCode": "ABCD1234EF"
  }
}
```

**설명:**
- 10자리 랜덤 코드 생성 (혼동되는 문자 제외: I, O, 0, 1 등)
- 유효시간: 1분
- VR 기기 화면에 이 코드를 표시

---

#### Step 2: 앱에서 인증 코드 입력
**POST** `/api/user/auth-device`

**Request Headers:**
```
Authorization: Bearer {accessToken}
```

**Request Body:**
```json
{
  "deviceAuthCode": "ABCD1234EF"
}
```

**Response:**
```json
{
  "status": "success",
  "message": "기기가 인증 되었습니다.",
  "data": null
}
```

**설명:**
- 사용자가 앱에 로그인한 상태여야 함
- VR 기기에 표시된 코드를 앱에서 입력
- 인증 성공 시 세션에 userId 저장

---

#### Step 3: VR 기기에서 토큰 획득 (폴링)
**POST** `/api/user/polling`

**Request Body:**
```json
{
  "deviceAuthCode": "ABCD1234EF"
}
```

**Response (인증 전):**
```json
{
  "status": "error",
  "message": "인증 처리되지 않았습니다."
}
```

**Response (인증 완료):**
```json
{
  "status": "success",
  "message": "기기가 인증 되었습니다.",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**설명:**
- VR 기기에서 주기적으로 호출 (예: 2~3초마다)
- 앱에서 인증하기 전까지 에러 반환
- 인증 완료되면 토큰 발급 후 세션 삭제

---

### 1.3 토큰 재발급
**POST** `/api/user/reissue-token`

**Request Body:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "userId": 1
}
```

**Response:**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

### 1.4 회원가입
**POST** `/api/user/signup`

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "nickname": "닉네임"
}
```

**Response:**
- Status: 201 Created

---

## 2. 대시보드 (Dashboard)

모든 대시보드 API는 인증이 필요합니다.

**Request Headers:**
```
Authorization: Bearer {accessToken}
```

---

### 2.1 스테이지 통계 정보
**GET** `/api/dashboard/stage/info?stage={stage}`

**Query Parameters:**
- `stage`: 스테이지 정보 (예: "1.1.1", "1.1.2", "1.2.1", "1.2.2", "2", "3", "4")

**Response:**
```json
{
  "status": "success",
  "message": "스테이지 정보가 조회되었습니다.",
  "data": {
    "stage": "1.1.1",
    "totalTryCount": 150,
    "totalCorrectCount": 120,
    "totalWrongCount": 30
  }
}
```

**설명:**
- 해당 스테이지의 누적 통계

---

### 2.2 스테이지 평균 시도 횟수
**GET** `/api/dashboard/stage/try-avg?stage={stage}`

**Query Parameters:**
- `stage`: 스테이지 정보

**Response:**
```json
{
  "status": "success",
  "message": "스테이지 평균 시도 횟수가 조회되었습니다.",
  "data": {
    "stage": "1.1.1",
    "averageTryCount": 3.5,
    "totalSessions": 10
  }
}
```

**설명:**
- 해당 스테이지를 플레이한 세션별 평균 시도 횟수

---

### 2.3 스테이지 최근 정답률
**GET** `/api/dashboard/stage/correct-rate?stage={stage}`

**Query Parameters:**
- `stage`: 스테이지 정보

**Response:**
```json
{
  "status": "success",
  "message": "스테이지 정답률이 조회되었습니다.",
  "data": {
    "stage": "1.1.1",
    "correctRate": 85.5,
    "correctCount": 17,
    "wrongCount": 3,
    "totalProblems": 20,
    "completedAt": "2025-11-06T15:30:00"
  }
}
```

**설명:**
- 가장 최근에 플레이한 세션의 정답률

---

### 2.4 출석 기록 조회

#### 2.4.1 기간별 조회
**GET** `/api/dashboard/attendance?startdate={yyMMdd}&enddate={yyMMdd}`

**Query Parameters:**
- `startdate`: 시작 날짜 (예: "250101")
- `enddate`: 종료 날짜 (예: "250131")

**Response:**
```json
{
  "status": "success",
  "message": "출석 기록 조회가 완료되었습니다.",
  "data": {
    "periodData": {
      "attendDates": [
        {
          "attendDate": "2025-01-01",
          "playtime": "15:30"
        },
        {
          "attendDate": "2025-01-02",
          "playtime": "20:15"
        }
      ],
      "totalAttendDays": 2
    },
    "dailyData": null
  }
}
```

---

#### 2.4.2 일별 조회
**GET** `/api/dashboard/attendance?date={yyMMdd}`

**Query Parameters:**
- `date`: 조회할 날짜 (예: "250101")

**Response:**
```json
{
  "status": "success",
  "message": "일별 출석 현황 조회가 완료되었습니다.",
  "data": {
    "periodData": null,
    "dailyData": {
      "attendDate": "2025-01-01",
      "playtime": "15:30",
      "attended": true
    }
  }
}
```

**설명:**
- playtime 형식: "분:초"
- attended: 해당 날짜에 출석했는지 여부

---

### 2.5 틀린 음소 랭킹
**GET** `/api/dashboard/mistake/phonemes/rank?limit={limit}`

**Query Parameters:**
- `limit`: 조회할 개수 (예: 10)

**Response:**
```json
{
  "status": "success",
  "message": "틀린 음소 랭킹이 조회되었습니다.",
  "data": [
    {
      "phonemeId": 1,
      "value": "ㄱ",
      "category": "자음",
      "wrongCnt": 15
    },
    {
      "phonemeId": 2,
      "value": "ㅏ",
      "category": "모음",
      "wrongCnt": 12
    }
  ]
}
```

**설명:**
- 사용자가 가장 많이 틀린 음소를 내림차순으로 반환

---

### 2.6 시도 횟수가 많은 음소 랭킹
**GET** `/api/dashboard/try/phonemes/rank?limit={limit}`

**Query Parameters:**
- `limit`: 조회할 개수 (예: 10)

**Response:**
```json
{
  "status": "success",
  "message": "시도 횟수가 많은 음소 랭킹이 조회되었습니다.",
  "data": [
    {
      "phonemeId": 1,
      "value": "ㄱ",
      "category": "자음",
      "tryCnt": 50
    },
    {
      "phonemeId": 2,
      "value": "ㅏ",
      "category": "모음",
      "tryCnt": 45
    }
  ]
}
```

**설명:**
- 사용자가 가장 많이 시도한 음소를 내림차순으로 반환

---

## 3. 사용자 정보

### 3.1 User 엔티티 구조
```json
{
  "id": 1,
  "email": "user@example.com",
  "nickname": "닉네임"
}
```

**설명:**
- JWT에서 userId, email, nickname을 추출 가능
- password는 응답에 포함되지 않음

---

## 4. 에러 응답 형식

```json
{
  "status": "error",
  "message": "에러 메시지"
}
```

**주요 에러 케이스:**
- 로그인 정보 불일치: "로그인 정보에 일치하는 회원이 없습니다."
- 토큰 만료: "만료된 리프레시 토큰입니다."
- 유효하지 않은 토큰: "유효하지 않은 리프레시 토큰입니다."
- Device code 만료: "시간이 만료되었습니다."
- Device code 미인증: "인증 처리되지 않았습니다."
- 잘못된 device code: "해당 코드는 유효하지 않습니다."

---

## 5. 참고 사항

### 5.1 스테이지 구조
프로젝트는 VR 기반 한글 학습 시스템으로, 다음과 같은 스테이지가 있습니다:
- **1.1.1, 1.1.2**: 초급 1단계
- **1.2.1, 1.2.2**: 초급 2단계
- **2**: 중급
- **3**: 고급 1
- **4**: 고급 2

### 5.2 음소 (Phoneme)
- 한글의 자음과 모음을 의미
- category: "자음" 또는 "모음"
- value: 실제 음소 값 (예: "ㄱ", "ㅏ")

### 5.3 BKT (Bayesian Knowledge Tracing)
- 백엔드에서 사용자의 학습 수준을 추적하는 알고리즘
- UserKcMastery: 사용자의 지식 구성요소(Knowledge Component) 숙달도
- 앱에서는 대시보드 통계로 간접적으로 확인 가능

### 5.4 JWT 토큰 구조
Access Token에 포함된 정보:
- userId (id)
- email
- nickname

---

## 6. 앱 개발 권장 사항

### 6.1 토큰 관리
- Access Token은 메모리에 저장 (앱 재시작 시 삭제)
- Refresh Token은 안전한 저장소에 저장 (Keychain/Keystore)
- 401 에러 발생 시 자동으로 토큰 재발급 시도

### 6.2 Device Code 로그인 UX
1. VR 기기에서 "앱으로 로그인" 선택
2. 10자리 코드 표시 (큰 글씨로)
3. 앱에서 코드 입력 화면 제공 (입력하기 쉽게)
4. 인증 성공 시 VR 기기에 즉시 반영

### 6.3 대시보드 화면 구성 제안
- **홈**: 출석 현황 (달력 형태), 최근 학습 시간
- **학습 분석**:
  - 스테이지별 정답률 그래프
  - 평균 시도 횟수 차트
  - 취약 음소 표시 (틀린 음소 랭킹)
- **프로필**: 닉네임, 이메일, 로그아웃

### 6.4 API 호출 최적화
- 대시보드 진입 시 필요한 API 병렬 호출
- 캐싱 활용 (특히 통계 데이터)
- Pull-to-refresh로 최신 데이터 갱신
