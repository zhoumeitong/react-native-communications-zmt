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
        Communication.openContacts((name,res) => {
           if (res) {
            AlertIOS.alert(res);
            AlertIOS.alert(name);
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
