// Import React
import React, {Component} from 'react';
//
import { EventRegister } from 'react-native-event-listeners'
// Import Components
import {
  View, Text, StyleSheet, TouchableOpacity, requireNativeComponent, NativeModules,AppState
} from 'react-native';
// Import Messaging View from Swift Project
const MessagingModule = requireNativeComponent('MessagingView', Messaging);
//
const {LivePersonSDK} = NativeModules;
//
/**
 *
 **/
class Messaging extends Component<{}> {

  componentDidMount() {
    this.listener = EventRegister.addEventListener('agent', (data) => {
      //Log
      console.log(`Agent :: ${data}`)
    })
  }

  componentWillUnmount() {
    EventRegister.removeEventListener(this.listener);
  }

  // Override Navigation Option
  static navigationOptions = ( { navigation } ) => ({
    // Navigation Bar Title
    title           : 'Messaging',
    // Set Back Button
    headerLeft      : (
      // Create Back Button
      <TouchableOpacity
        // View Style
        style={styles.backButton}
        // View Action
        onPress={() => navigation.goBack()}>
        <Text
          // Button Text Style
          style={styles.navButtonText}>
          Back
        </Text>
      </TouchableOpacity>), // Navigation Bar
    headerStyle     : styles.navigationBar, // Navigation Title Color
    headerTintColor : '#FFFFFF', // Set Menu Button
    headerRight     : (
      // Create Back Button
      <TouchableOpacity
        // View Style
        style={styles.menuButton}
        // View Action
        onPress={() => LivePersonSDK.menuButtonPressed()}>
        <Text
          // Button Text Style
          style={styles.navButtonText}>
          Menu
        </Text>
      </TouchableOpacity>),
  });

  render() {
    return (<View style={styles.container}>
      <MessagingModule style={styles.container}/>
    </View>);
  }
}

// Styling
const styles = StyleSheet.create({
  container     : {
    flex            : 1,
    backgroundColor : '#123144'
  },
  navigationBar : {
    backgroundColor : '#f49012',
  },
  backButton    : {
    paddingStart : 10,
  },
  menuButton    : {
    paddingEnd : 10,
  },
  navButtonText : {
    color      : '#FFFFFF',
    fontSize   : 15,
    fontWeight : '500',
  }
});
// Expose Class
module.exports = Messaging;