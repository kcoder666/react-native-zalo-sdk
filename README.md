# react-native-zalo-sdk

## Getting started

`$ npm install react-native-zalo-sdk --save`

### Mostly automatic installation

`$ react-native link react-native-zalo-sdk`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-zalo-sdk` and add `ZaloSdk.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libZaloSdk.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainApplication.java`
  - Add `import ktgeek.zalo.ZaloSdkPackage;` to the imports at the top of the file
  - Add `new ZaloSdkPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-zalo-sdk'
  	project(':react-native-zalo-sdk').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-zalo-sdk/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-zalo-sdk')
  	```


## Usage
```javascript
import ZaloSdk from 'react-native-zalo-sdk';

// TODO: What to do with the module?
ZaloSdk;
```
