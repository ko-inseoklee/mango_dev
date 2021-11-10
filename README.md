# mangodevelopment

A new Flutter project.

## Getting Started

- 파베 연동이 안될 때
    - 안드로이드 에뮬레이터 인터넷 연결 확인
    - AndroidManifest permission 넣어주기 (ACCESS NETWORK / INTERNET)

- Google Platform Exception
    - 파이어베이스 프로젝트에 SHA 인증서 등록이 되어 있는 지 확인.

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
    
    - 전화번호 인증시,
        현재는 amulator에서 작동 (reCAPTCHA 인증만 사용), 실제 Phone으로 test 할 경우 (SafetyNet 인증 사용해야 된다. => 일정량 이상 추가 요금 발생)

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
    - barcode : 카테고리, CardStatus 재정의 필요. -> 받아온 데이터 기준으로 UI 구성.
- TODO (jhyun)
	- 새로운 device로 로그인시 친구의 교환된 정보 목록에서도 수정필요
	- profileImageRef 친구의 교환된 정보 목록에서도 수정필요
	- Post.snapshot 에서 User.fromSnapshot 사용 필요 or User 정보 수정 시 Post db의 정보도 수정 필요

- Ref 
    - branch 관련: .
        mj branch - kakao+naver+google 로그인로 (googleLogin -> AddUserInfo(회원정보) -> Home)
        mjV2 brnach - email + password로 로그인 (emailLogin -> Home / emailSignUp(회원정보입력) -> Home)
        (다음과 같이 진행한 이유는, google login 같은 경우 SignIn + SignUp동시에 존재 => 회원정보를 경우에 따라서 받아야 될 때와 아닐때 따로 있음
         하지만, email login 같은 경우 SignIn과 SignUp 동시 불가 => SignIn이면 바로 Home, SignUp이면 회원정보 입력 필요)
    