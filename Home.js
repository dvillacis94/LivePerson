/**
 * LivePerson
 *
 * Created by David Villacis on 12/15/17.
 */

// Import React
import React, {Component} from 'react';
// Import Components
import {
  Platform, StyleSheet, TouchableOpacity, View, Text, Image, Dimensions, PixelRatio
} from 'react-native';
// Messaging Module for Android (this handles LPMessagingSDK)
import MessagingModule from './messaging/messaging.android.module'

/**
 * Main Screen Component
 **/
class Home extends Component<{}> {

  /**
   * Will Override Navigation Options
   * @type {{title: string}}
   */
  static navigationOptions = ( { navigation } ) => ({
    // Navigation Title
    title  : 'Home',
    // Hide Navigation Bar on Home Screen
    header : null
  });

  /**
   * Will handle Chat Button Pressed for IOS
   * @param navigate
   * @private
   */
  _handleIOSMessagingNavigation( navigate ) {
    // Move to Messaging Screen
    navigate('Messaging');
  }

  /**
   * Will handle Chat Button Pressed for Android
   * @private
   */
  _handleAndroidMessagingNavigation() {
    // Move to Messaging Screen
    MessagingModule.show();
  }

  /**
   * Will render View for Android OS
   * @returns {*}
   */
  renderAndroid() {
    return (
      <View style={styles.container}>
        <View style={styles.bgView}>
          <Image
            style={styles.bg}
            source={require('./assets/live-bg.png')}/>
        </View>
        <View style={styles.chatButtonView}>
          <TouchableOpacity
            style={styles.chatButton}
            onPress={() => this._handleAndroidMessagingNavigation()}
            activeOpacity={0.6}>
            <Text style={styles.chatButtonText}>
              Chat
            </Text>
          </TouchableOpacity>
        </View>
      </View>);
  }

  /**
   * Will render View for IOS
   * @param navigate - Navigation Options
   * @returns {*}
   */
  renderIOS(navigate) {
    return (
      <View style={styles.container}>
        <View style={styles.bgView}>
          <Image
            style={styles.bg}
            source={require('./assets/live-bg.png')}/>
        </View>
        <View style={styles.chatButtonView}>
          <TouchableOpacity
            style={styles.chatButton}
            onPress={() => this._handleIOSMessagingNavigation(navigate)}
            activeOpacity={0.6}>
            <Text style={styles.chatButtonText}>
              Chat
            </Text>
          </TouchableOpacity>
        </View>
      </View>);
  }

  /**
   * Will render View
   * @returns {*}
   */
  ex_render() {
    // Get Navigation Bar from Props
    const { navigate } = this.props.navigation;
    // Return View
    return (<View style={styles.container}>
      <View style={styles.bgView}>
        <Image
          style={styles.bg}
          source={require('./assets/live-bg.png')}/>
      </View>
      <View style={styles.chatButtonView}>
        <TouchableOpacity
          style={styles.chatButton}
          onPress={() => this._handleIOSMessagingNavigation(navigate)}
          activeOpacity={0.6}>
          <Text style={styles.chatButtonText}>
            Chat
          </Text>
        </TouchableOpacity>
      </View>
    </View>);
  }

  /**
   * Will render View
   * @returns {*}
   */
  render() {
    // Get Navigation Bar from Props
    const { navigate } = this.props.navigation;
    // Return Depending on Platform
    return Platform.select({
      ios : this.renderIOS(navigate),
      android : this.renderAndroid()
    });
  }
}

/**
 * Styling
 */
const styles = StyleSheet.create({
  container      : {
    flex            : 1,
    justifyContent  : 'center',
    alignItems      : 'center',
    backgroundColor : '#F5FCFF',
  },
  welcome        : {
    fontSize  : 20,
    textAlign : 'center',
    margin    : 10,
  },
  instructions   : {
    textAlign    : 'center',
    color        : '#333333',
    marginBottom : 5,
  },
  bg             : {
    width      : PixelRatio.getPixelSizeForLayoutSize(Dimensions.get('window').width),
    height     : PixelRatio.getPixelSizeForLayoutSize(30),
    resizeMode : Image.resizeMode.contain,
  },
  bgView         : {
    flex           : 7,
    flexDirection  : 'column',
    alignItems     : 'center',
    justifyContent : 'center'
  },
  chatButtonView : {
    flex           : 1,
    alignItems     : 'center',
    justifyContent : 'flex-start'
  },
  chatButton     : {
    alignItems      : 'center',
    backgroundColor : '#f49012',
    padding         : PixelRatio.getPixelSizeForLayoutSize(3),
    paddingStart    : PixelRatio.getPixelSizeForLayoutSize(10),
    paddingEnd      : PixelRatio.getPixelSizeForLayoutSize(10),
    borderRadius    : PixelRatio.getPixelSizeForLayoutSize(2.5),
  },
  chatButtonText : {
    color : '#FFFFFF'
  }
});

/**
 * Expose Class
 * @type {Messaging}
 */
module.exports = Home;