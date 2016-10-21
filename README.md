# react-native-Communication

功能：
实现打电话、发短信、打开系统通讯录

一、链接WXPay库
参考http://reactnative.cn/docs/0.28/linking-libraries-ios.html#content

1、添加react-native-Communication插件到你工程的node_modules文件夹下
2、添加Communication库中的.xcodeproj文件在你的工程中
3、点击你的主工程文件，选择Build Phases，然后把刚才所添加进去的.xcodeproj下的Products文件夹中的静态库文件（.a文件），拖到Link Binary With Libraries组内。

二、开发环境配置

如果是iOS10需要在plist文件中进行如下配置：

![](http://upload-images.jianshu.io/upload_images/2093433-106317e5bcad4b7b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
<key>NSContactsUsageDescription</key>  
<string>App需要您的同意,才能访问通讯录</string>  
```

三、简单使用

js文件
```
/**
* Sample React Native App
* https://github.com/facebook/react-native
* @flow
*/

import React, { Component } from 'react';
import { NativeModules } from 'react-native';


var Communication = NativeModules.Communication;


import {
AppRegistry,
StyleSheet,
Text,
View,
Dimensions,
AlertIOS,
ScrollView,
TouchableHighlight,
NativeAppEventEmitter
} from 'react-native';

class CommunicationView extends Component {


call() {
Communication.call('10000',(res) => {
if (res) {
AlertIOS.alert(res);
} 
});
}

messageNumberWithMessage() {
Communication.messageNumberWithMessage('10000','发短信给10000',(res) => {
if (res) {
AlertIOS.alert(res);
}
});
}

openContacts() {
Communication.openContacts((res) => {
if (res) {
AlertIOS.alert(res);
}
});
}



render() {
return (
<ScrollView contentContainerStyle={styles.wrapper}>

<TouchableHighlight 
style={styles.button} underlayColor="#f38"
onPress={this.call}>
<Text style={styles.buttonTitle}>打电话</Text>
</TouchableHighlight>


<TouchableHighlight 
style={styles.button} underlayColor="#f38"
onPress={this.messageNumberWithMessage}>
<Text style={styles.buttonTitle}>发短信</Text>
</TouchableHighlight>

<TouchableHighlight 
style={styles.button} underlayColor="#f38"
onPress={this.openContacts}>
<Text style={styles.buttonTitle}>打开通讯录</Text>
</TouchableHighlight>


</ScrollView>
);
}
}

const styles = StyleSheet.create({
wrapper: {
paddingTop: 60,
paddingBottom: 20,
alignItems: 'center',
},
pageTitle: {
paddingBottom: 40
},
button: {
width: 200,
height: 40,
marginBottom: 10,
borderRadius: 6,
backgroundColor: '#f38',
alignItems: 'center',
justifyContent: 'center',
},
buttonTitle: {
fontSize: 16,
color: '#fff'
}

});


AppRegistry.registerComponent('TextReactNative', () => CommunicationView);
```

效果展示

![](http://upload-images.jianshu.io/upload_images/2093433-d072bdfe543132f0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

