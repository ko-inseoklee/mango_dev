# mangodevelopment

A new Flutter project.

## Getting Started

- 파베 연동이 안될 때
    - 안드로이드 에뮬레이터 인터넷 연결 확인
    - AndroidManifest permission 넣어주기 (ACCESS NETWORK / INTERNET)

- small API
    - MangoAppBar
           String title,
           List<Widget> actions,
           required bool isLeading // whether having pop-button or not.
    - FoodSection // For make refrigerator section (냉장, 냉동 등)
            required List<Food> foods

    - mangoDialog
          String dialogTitle,
          String contentText // for body text
          VoidCallback onTapOK // function that execute when the hasOK is true.
          bool hasOK // whether OK button is appear or not.


- TODO
    - modal bottom sheet
        리스트에 elevation 주기 - 색상, 높이 변경
    - 식자재 등록
        인식에 따른 유사 음식 추천 - AI 활용 등록방법 적용 후 추가.

    - screen uil package 사용하기. (개발 이후)

    - 직접입력 시 default 섹션 하나 / 수량 default 1 / focus 이동

    - 자체 pre-set 제작

- Development plan
    1. Before Home

        2) SMS 인증 기능 추가

        3) 레이아웃 체크

    2. After Home

        1) 등록

            1. Floating button 분할(품목 등록, 나눔 품목 등록)
            2. 카메라 커스터 마이징
            3. 카메라 인식률 개선
            4. 인식 후 정보 입력(이름, 수량) / focusnode → category.
            5. UT - 영수증 // 영어 영수증 준비.
            6. 직접입력 focusNode = 이름 → 수량 → 카테고리

        3) 나눔

            1. Push Notification
            2. 나눔 등록

        4) 마이페이지

            1. 알림일 설정
            2. 거래내역
            3. 기타 될 수 있는 기능들 추가.

    3. Later
        - 각 표시 기준(위젯 표기 boolean 값) 매일 날짜 기준으로 업데이트 시키기.
            -> User 의 lastSignIn 정보를 받아서, 날짜 기준으로 음식의 state 업데이트하기 (CSR(Client Side Rendering)

- Todo(Inseok)
    - Food class의 CardStatus CSR로 변경.
    - 디테일 페이지 / 수정기능

    - 에러: 마지막 하나 남은 것 삭제하면 화면 업데이트 되지 않음.