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
    - modal bottom sheet
        리스트에 elevation 주기 - 색상, 높이 변경
    - 식자재 등록
        인식에 따른 유사 음식 추천 - AI 활용 등록방법 적용 후 추가.

    - screen uil package 사용하기. (개발 이후)
    - boolean 값들에 따라 보여주는 각각의 위젯을 빌드해주는 방식으로 변경하기
        - AddFood할때, 각각의 bool값들의 연산을 DB에 입력시키기


    - 빌드를 다시하면 로그은 페이지로 넘어감.