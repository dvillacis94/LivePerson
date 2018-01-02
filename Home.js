/**Rays
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */
// Import React
import React, {Component} from 'react';
// Import Components
import {
  Platform, StyleSheet, TouchableOpacity, View, Text, Image, Dimensions,PixelRatio
} from 'react-native';

class Home extends Component<{}> {

  // Set Navigation Options
  static navigationOptions = {
    // Navigation Title
    title : '',
    // Hide Navigation Bar
    // header : Platform.select({
    //   ios : null
    // }),
  };

   _handleMessagingNavigation( navigate ) {
    //
    navigate('Messaging');
  }

  render() {
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
          onPress={() => this._handleMessagingNavigation(navigate)}
          activeOpacity={0.6}>
          <Text style={styles.chatButtonText}>
            Chat
          </Text>
        </TouchableOpacity>
      </View>
    </View>);
  }
}

// Styling
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
// Expose Class
module.exports = Home;