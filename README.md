# CoinRank
**Implementation Details**
<br/>The app makes calls to the CoinRanking API to fetch digital coins information. 
<br/>It uses a mix of UIKit for the main views while adding  SwiftUI components within it such as for tableview cell as well as coin details view and charts
<br/>For networking calls, there is the use of concurrency via asynchronous network calls
<br/>Its been built on iOS SDK 16, using Xcode 16.2

**Architecture**
<br/> Build using MVVM architecture with Combine used for binding of views to data in the View Models

**Persistence**
<br/>The app makes use of CoreData to manage local data storage for persistence puposes

**Running The App**
<br/>Download and open the project on Xcode. Run the app to view it on a simulator or device
