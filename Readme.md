
# MSALSwiftUI
In this project I showcase how I use MSAL in a swift ui application using @Environment and @Observable
I also implement a basic navigation stack to showcase how the MSAL UIViewRepresentable can appear on any view in your application

## Getting MSAL Setup
### SETUP (can [skip](#createApp) if project already setup and you have clientId, authorityURL etc..)
basic app template
![app setup](images/Step1.png)
do not use swiftData like I did here, leave it as default.
![app setup](images/Step2.png)
This is how your basic app should look
![app preview](images/Step3.png)
### Create Microsoft project 
[Go to MS admin portal](https://aka.ms/admincenter) and go to **Identity** -> **Application** -> **App Registration** and create a **New Registration** <br />
![ms dashboard](images/Step4.png)<br />
Add your application name and register after matching criteria in image below.<br />
![ms dashboard](images/Step5.png)<br />
Add the iOS platform under **Manage** -> **Authentication** -> **+Add Platform** -> **iOS/MacOS**<br />
![ms dashboard](images/Step6.png)<br />
It will ask for bundle Identifier which is found here. <br />
![ms dashboard](images/Step7.png)<br />
Then you save the msal configuration information that is displayed next in a notepad for future use. and select DONE <br /><br />
Next, add this [package](https://github.com/AzureAD/microsoft-authentication-library-for-objc.git) to your project<br />
![add package](images/Step9.png)<br />
Go to **Signing & Capabilities** and add the **Keychain Sharing** Capabitlity<br />
![add keychain](images/step10.png)<br />
add com.microsoft.adalcache and com.microsoft.identity.universalstorage<br />
![add keychain definitions](images/Step11.png)<br />
in your info.plst file add : msauth , msauthv2 , msauthv3 under **Queried URL Schemes**<br />
![add url schemes](images/step11.1.png)<br />
Add a URL type using this format msauth.--BUNDLE-IDENTIFIER-HERE--
![add url Types](images/Step12.png)<br />

thats IT for setup... lets start building an app with MSAL<br />

### CREATE APP <a name="createApp"></a>

Create a file to store your MSAL Properties
**IMPORTANT**
notice my authority URL has changed from what was given to us from what was provided from microsoft.
update your URL to match this format:
  "https://login.microsoftonline.com/[YOUR TENANT ID]/oauth2/v2.0/authorize"
you can find your tenant ID in the Overview section of your app registration on MS Admin Center.

```
import Foundation
import MSAL

struct Token {
  var value: String
  var expiry: Date?
}


struct MSALProperties {
  var account : MSALAccount?
  var clientID : String?      = "d1969185-57c4-405f-8fe7-475854abd807"
  var redirectUri : String?   = "msauth.com.carrie.aiden.MSALSwiftUI://auth"
  var authorityUrl : String?  = "https://login.microsoftonline.com/8579326f-5aee-4683-9a87-c93740220d50/oauth2/v2.0/authorize"
  var authority : MSALAADAuthority?
  var scopes : [String]?      = ["user.read"]
  var token : Token?
  var application : MSALPublicClientApplication?
  var interactiveParameters : MSALInteractiveTokenParameters?
  var webviewParams : MSALWebviewParameters?

}
```



### A third-level heading
