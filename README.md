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


- Development plan
    1. Before Home

        1) 빌드 때 로그인이 되어 있으면, 홈으로 넘어가게 하기 (LANDING 페이지 제대로 활용)

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

        2) 냉장고

            1. 유통기한 별 보기
            2. RUD
            3. 유통기한 별 보기 → 레시피 페이지 → WEBVIEW(만개의 레시피)

        3) 나눔

            1. Push Notification
            2. 나눔 등록

        4) 마이페이지

            1. 알림일 설정
            2. 거래내역
            3. 기타 될 수 있는 기능들 추가.

    3. Later
        - 각 표시 기준(위젯 표기 boolean 값) 매일 날짜 기준으로 업데이트 시키기.