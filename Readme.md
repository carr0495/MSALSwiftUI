
# MSALSwiftUI
In this project I showcase how I use MSAL in a swift ui application using @Environment and @Observable
I also implement a basic navigation stack to showcase how the MSAL UIViewRepresentable can appear on any view in your application

## Getting MSAL Setup
### Create app (can skip if project already setup and you have clientId, authorityURL etc..)
basic app template
![app setup](images/Step1.png)
do not use swiftData like I did here, leave it as default.
![app setup](images/Step2.png)
This is how your basic app should look
![app preview](images/Step3.png)
### Create Microsoft project 
[Go to MS admin portal](https://aka.ms/admincenter) and go to **Identity** -> **Application** -> **App Registration** and create a **New Registration** <br />
![ms dashboard](images/Step4.png)<br />
Add your application name and register after matching criteria in image below.
![ms dashboard](images/Step5.png)<br />
Add the iOS platform under **Manage** -> **Authentication** -> **+Add Platform** -> **iOS/MacOS**
![ms dashboard](images/Step6.png)<br />
It will ask for bundle Identifier which is found here. 
![ms dashboard](images/Step7.png)<br />
Then you save the msal configuration information that is displayed next in a notepad for future use. and select DONE <br /><br />
Next, add this [package](https://github.com/AzureAD/microsoft-authentication-library-for-objc.git) to your project
![add package](images/Step9.png)<br />
Go to **Signing & Capabilities** and add the **Keychain Sharing** Capabitlity
![add package](images/Step10.png)<br />




### A third-level heading
