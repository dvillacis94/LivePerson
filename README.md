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
      		pod ‘LPMessagingSDK','~>2.9.0'
  	```
  	
3. Then add the necessary Pods for React-Native

    ```ruby
        # Uncomment the next line to define a global platform for your project
        # platform :ios, '9.0'
    
        source 'https://github.com/CocoaPods/Specs.git'
        source 'https://github.com/LivePersonInc/iOSPodSpecs.git'
        
        target 'LivePerson' do
            # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
            # use_frameworks!

            # Pods for LivePerson
            pod ‘LPMessagingSDK','~>2.9.0'
            # Your 'node_modules' directory is probably in the root of your project,
            # but if not, adjust the `:path` accordingly
            pod 'React', :path => '../node_modules/react-native', :subspecs => [
                'Core',
                'CxxBridge', # Include this for RN >= 0.47
                'DevSupport', # Include this to enable In-App Devmenu if RN >= 0.43
                'RCTText',
                'RCTNetwork',
                'RCTWebSocket', # needed for debugging
                # Add any other subspecs you want to use in your project
            ]
            # Add Event Emitter Module
            pod 'MSREventBridge', :path => '../node_modules/react-native-event-bridge/MSREventBridge.podspec'
            
            # Explicitly include Yoga if you are using RN >= 0.42.0
            pod 'yoga', :path => '../node_modules/react-native/ReactCommon/yoga'
                  
            # Third party deps podspec link
            pod 'DoubleConversion', :podspec => '../node_modules/react-native/third-party-podspecs/DoubleConversion.podspec'
            pod 'GLog', :podspec => '../node_modules/react-native/third-party-podspecs/GLog.podspec'
            pod 'Folly', :podspec => '../node_modules/react-native/third-party-podspecs/Folly.podspec'
            
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

> NOTE: if during Building the Project Xcode complains with any errors, Clean the Build Folder using `Shift + alt + cmd + k`, then Build Again `cmd + b`

## Android Studio ##

In the Case if Android use the following [Guide](https://developers.liveperson.com/android-implementation-guide.html), as adding the SDK to Android follow the same process.
