# 앱 리젝 사유 및 대처 방안
## version 2.0.7
Naver Login Error:
Here I have found out that after updating pod file I had to manually change consumerKey, urlScheme, appName.. in "NaverThirdPartyConstantsForApp.h" (-> location: ProjectFile/Pods/naverlogin-sdk-ios/NaverThirdPartyLogin/Headers/NaverThirdPartyConstantsForApp.h)

Video Player Layer Disappearing Issue:
In every Pod update or install process the BMPlayer overrides its initial files that were designed for ClassTok.. so the solution is to replace those BMPlayerControlView and Pod_Asset files after updating pods. 

## version 1.4.3

Guideline 3.1.1 - Business - Payments - In-App Purchase
가이드 라인 3.1.1-비즈니스-결제-인앱 구매

We noticed that your app or its metadata enables the purchase of content, services, or functionality in the app by means other than the in-app purchase API, which is not appropriate for the App Store.
앱 또는 메타 데이터가 앱 스토어에 적합하지 않은 인앱 구매 API 이외의 방법으로 앱의 콘텐츠, 서비스 또는 기능을 구매할 수있는 것으로 나타났습니다.

Specifically, classes for sale should implement in-app purchase API since all classes are digitally taken.
특히 판매용 클래스는 모든 클래스가 디지털 방식으로 수행되므로 인앱 구매 API를 구현해야합니다.

Next Steps
다음 단계

While the payment system that you have included may conduct the transaction outside of the app, if the purchasable content, functionality, or services are intended to be used in the app, they must be purchased using in-app purchase, within the app - unless it is of the type referenced in guideline 3.1.3 of the App Store Review Guidelines.
포함 된 결제 시스템이 앱 외부에서 거래를 수행 할 수 있지만 구매 가능한 콘텐츠, 기능 또는 서비스를 앱에서 사용하려는 경우 앱 내에서 앱 내 구매를 사용하여 구매해야합니다. App Store Review Guidelines의 지침 3.1.3에서 참조 된 유형입니다.

In-App Purchase
인앱 구매

It may be appropriate to revise your app to use the in-app purchase API to provide content purchasing functionality.
콘텐츠 구매 기능을 제공하기 위해 인앱 구매 API를 사용하도록 앱을 수정하는 것이 적절할 수 있습니다.

In-app purchase provides several benefits, including:
인앱 구매는 다음과 같은 여러 가지 이점을 제공합니다.

- The flexibility to support a variety of business models.
- Impacting your app ranking by consolidating your sales to one app rather than distributing them across multiple apps.
- An effective marketing vehicle to drive additional sales of new content.
-다양한 비즈니스 모델을 지원할 수있는 유연성.
-여러 앱에 판매를 분배하지 않고 하나의 앱에 판매를 통합하여 앱 순위에 영향을줍니다.
-새로운 컨텐츠의 추가 판매를 유도하는 효과적인 마케팅 수단.

For information on in-app purchase, please refer to the following documentation:
인앱 구매에 대한 자세한 내용은 다음 설명서를 참조하십시오.

In-App Purchase for Developers
개발자를위한 인앱 구매

In-App Purchase Programming Guide
인앱 구매 프로그래밍 가이드

For step-by-step instructions on in-app purchase creation within App Store Connect, refer to App Store Connect Help.
App Store Connect 내에서 인앱 구매 생성에 대한 단계별 지침은 App Store Connect 도움말을 참조하십시오.가이드 라인 

> 해결 방안
 - 앱내 구매를 못하게 막음 처리
 - 문구 변경
     -> *. 수강권만 구매하기는 PC에서만 가능합니다. *
     -> 앱스토어 정책으로 인해 앱 내에서는 수강권만 구매할 수 없습니다.
