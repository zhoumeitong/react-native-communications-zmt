//方法一
var ReactNative = require('react-native')
module.exports = ReactNative.NativeModules.Communication

//方法二
// import { NativeModules } from 'react-native';
// module.exports = NativeModules.Communication;

// import { NativeModules } from 'react-native';
// var Communication = NativeModules.Communication;
// module.exports = Communication;