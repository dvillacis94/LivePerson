# LivePerson
LPMessagingSDK integration with React-Native

## Install NPM Modules  ##

1. On the terminal window, navigate to the Project directory and type the following command:

    ```sh
        $ npm install
    ```

## iOS & Xcode ##

### Add CocoaPods ###

##### **(Optional) Install Cocoapods on your Computer.**

1. On the terminal window, type the following command:

    ```sh
        $ gem install cocoapods
    ```
    
2. After the installation is over, navigate to your project folder and init a new pod using the following command:

    ```sh
        $ pod init
    ```

#### Add LPMessagingSDK to your Podfile ####

1. On top of your Podfile, on the source section add:

    ```ruby
        source 'https://github.com/LivePersonInc/iOSPodSpecs.git'
    ```

2. Under your Application Target add:

    ```ruby
        target ‘<YourApplicatioName>’ do
    
     		# Pods for <YourApplicatioName>
      		pod ‘LPMessagingSDK','~>2.8.0.9'
  	```
  	
3. Your Podfile should look like this:

    ```ruby
        # Uncomment the next line to define a global platform for your project
        # platform :ios, '9.0'
    
        source 'https://github.com/CocoaPods/Specs.git'
        source 'https://github.com/LivePersonInc/iOSPodSpecs.git'
        
        target '<YourApplicatioName>' do
          # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
          # use_frameworks!
          
          # Pods for <YourApplicatioName>
          pod ‘LPMessagingSDK','~>2.9.0'
          
          target '<YourApplicatioName>Tests' do
            inherit! :search_paths
            # Pods for testing
          end
          
          target '<YourApplicatioName>UITests' do
            inherit! :search_paths
            # Pods for testing
          end
        end
    ```
    
    > Note: DO NOT USE FRAMEWORKS
    
- If you already had a Podfile, your terminal run the following command:

    ```sh
        $ pod update
    ```
    
- if not, run the following command:

    ```sh
        $ pod init
    ```
    
3. Add LPMessagingSDK Frameworks
  - On your Xcode Project, create a Folder called Frameworks,
  - Drag the LPMessagingSDK Frameworks from the Finder Window to the Folder,
  - Add the Frameworks to the Project on the General Tab.

4. Clean & Build the App

## Android Studio ##

In the Case if Android using the following [Guide](https://developers.liveperson.com/android-implementation-guide.html), as adding the SDK to Android follow the same process.
