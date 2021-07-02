# mangodevelopment

A new Flutter project.

## Getting Started

- 파베 연동이 안될 때
    - 안드로이드 에뮬레이터 인터넷 연결 확인
    - Androidmanifest permission 넣어주기 (ACCESS NETWORK / INTERNET)

- small API
    - MangoAppBar
           required String title,
           List<Widget> actions,
           required bool isLeading // whether having pop-button or not.

- TODO
    - Chip
        하나의 칩에 하나의 Food 모델 사용.
        Default chip 만들어 놓기.
    - 식자재 등록
        인식에 따른 유사 음식 추천 - AI 활용 등록방법 적용 후 추가.