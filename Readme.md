
# MSALSwiftUI
This project showcases how I use MSAL in a swift ui application using **@Environment** and **@Observable**<br />
I also implement a basic navigation stack to show how the MSAL UIViewRepresentable can appear on any view in your application

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

Create a file to store your MSAL Properties<br />
**IMPORTANT**<br />
notice my authority URL has changed from what was given to us from microsoft.<br />
update your URL to match this format:<br />
  "https://login.microsoftonline.com/[YOUR TENANT ID]/oauth2/v2.0/authorize"<br />
you can find your tenant ID in the Overview section of your app registration on MS Admin Center.<br /><br />

```
//  MSALProperties.swift

import Foundation
import MSAL

struct Token {
  var value: String
  var expiry: Date?
}


struct MSALProperties {
  var account : MSALAccount?
  var clientID : String?      = "YOUR CLIENT ID"
  var redirectUri : String?   = "YOUR REDIRECT URI"
  var authorityUrl : String?  = "https://login.microsoftonline.com/YOUR TENANT ID/oauth2/v2.0/authorize"
  var authority : MSALAADAuthority?
  var scopes : [String]?      = ["user.read"]
  var token : Token?
  var application : MSALPublicClientApplication?
  var interactiveParameters : MSALInteractiveTokenParameters?
  var webviewParams : MSALWebviewParameters?

}
```
<br /><br />

Next, Create your App Model (for this app im using MV architecture)
I am also setting up our navigation path for the future.

```
//  AppModel.swift

import Foundation
import SwiftUI



@Observable class AppModel {
  
  //our msal properties.
  var msalProperties : MSALProperties = MSALProperties()
  
  //Navigation
  var navPath : NavigationPath = NavigationPath()
  var navPathBinding: Binding<NavigationPath> {
    Binding {
      self.navPath
    } set: { value in
      self.navPath = value
    }
  }
  
}
```
<br /><br />

Now we build our UIViewRepresentable for MSAL and setup of our properties. <br />
This viewmodel only sets up our authority, application, and parameters so we can shove them in the environment.<br />
The rest is pretty standard as per MSAL docs.<br />

```
//  MSALViewControllerRepresentable.swift

import Foundation
import SwiftUI
import MSAL

struct MSALViewController : UIViewControllerRepresentable {
  
  @Environment(AppModel.self) var model
  
  func makeUIViewController(context: Context)  -> UIViewController {
    
    let viewController =  UIViewController()
    
    if let authURL = model.msalProperties.authorityUrl,
       let clientID = model.msalProperties.clientID,
       let redirectUri = model.msalProperties.redirectUri,
       let scopes = model.msalProperties.scopes
    {
      guard let authorityURL = URL(string: authURL) else {
        print("Unable to create authority URL")
        return viewController
      }
      
      let authority : MSALAADAuthority?
      do {
        authority = try MSALAADAuthority(url: authorityURL)
        
        let config = MSALPublicClientApplicationConfig(
          clientId: clientID,
          redirectUri: redirectUri,
          authority:  authority)
        
        if let application = try? MSALPublicClientApplication(configuration: config) {
          let webviewParameters = MSALWebviewParameters(authPresentationViewController: viewController)
          
          let interactiveParameters = MSALInteractiveTokenParameters(scopes: scopes, webviewParameters: webviewParameters)
          
          model.msalProperties = MSALProperties(authority: authority, application: application, interactiveParameters: interactiveParameters, webviewParams: webviewParameters)
        }
        else {print("Unable to create application.")}
      }
      catch {print("Unable to create authority URL")}
    }
    return viewController
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
  }
  
}
```
<br /><br />
Inject your Aggregate model into your environment<br />
![Environment](images/Step21.png)<br />

Add Navigation to your AppModel.swift

```
  public enum Destination: Codable, Hashable {
    case login
    case home
    case screenOne
  }
  func navigate(to destination: Destination) {
    navPath.append(destination)
  }
  
  func navigateBack() {
    navPath.removeLast()
  }
  
  func navigateToRoot() {
    navPath.removeLast(navPath.count)
  }
```
<br /><br />
Setup your View<br />
In your root NavigationStack, this is where you want to place your MSALViewController so your app has access to its properties from anywhere inside.<br />
Set the frame width and height to one. this view only needs to exist on initialization of your application.
![Environment](images/Step20.png)<br />
```
//  ContentView.swift

import SwiftUI

struct ContentView: View {
  
  @Environment(AppModel.self) var model
  
    var body: some View {
      NavigationStack(path: model.navPathBinding){
        VStack {
          Button(action:{}){
            Text("Interactive Login")
        }
        }
        .navigationDestination(for: AppModel.Destination.self) { page in
          switch page {
          case .home :
            EmptyView()
          case .login :
            EmptyView()
          case .screenOne :
            EmptyView()
          }
        }
      }
      .overlay{
        MSALViewController()
          .frame(width: 1, height: 1)
      }
    }
}

#Preview {
    ContentView()
    .environment(AppModel())
}
```

Lets setup an interactive login, for this I make an extension off of my aggregate model and use the + syntax for file organization<br />
so for a project using AppModel as the aggregate, I will create a new file called App+MSAL.swift<br />

```
//  App+MSAL.swift

import Foundation
import MSAL

extension AppModel {
  
  func interactiveLogin() async throws {
    
    if let params = self.msalProperties.interactiveParameters, let application = self.msalProperties.application {
      
      params.promptType = .selectAccount
      
      do {
        let result = try await Task<MSALResult, Error> { @MainActor in
          try await application.acquireToken(with: params)
        }.value

          if let token = result.idToken, let exp = result.expiresOn {
            msalProperties.token = Token(value: token, expiry: exp)
          }
          self.msalProperties.account = result.account
          //it worked... now I need to navigate my app somwhere.
          navigate(to: .home)
        
      }
      catch let error as NSError where error.domain == MSALErrorDomain && error.code == MSALError.userCanceled.rawValue {
        print("Canceled")
      } catch {
        print("Could not acquire token: \(error)")
      }
    }else {
      print("Missing interactive properties and Application MSAL")
    }
  }
  
}
```
Now we need to add a call to this in our ContenView.swift :<br />

```
// ContentView.swift
...
Button(action:{
  Task{
    try await model.interactiveLogin() <--
  }
}){
  Text("Interactive Login")
}
...
```
Now when we click our interactive button ....
![Environment](images/Step22.png)<br />
