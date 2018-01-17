/**
 * LivePerson
 *
 * Created by David Villacis on 12/15/17.
 */

// Import React
import React, {Component} from 'react';
// Import Components
import {
  View, Text, StyleSheet, TouchableOpacity, requireNativeComponent, NativeModules, NativeEventEmitter, EmitterSubscription
} from 'react-native';
// Import Messaging View from Swift Project
const MessagingModule = requireNativeComponent('MessagingView', Messaging);
// LivePerson Native Module - Menu (Back - Menu Buttons)
const { LivePersonSDK } = NativeModules;
// EventEmitter Import
const { ReactNativeEventEmitter } = NativeModules;
// Create New EventEmitter Instance
const reactNativeEventEmitter = new NativeEventEmitter(ReactNativeEventEmitter);

/**
 * Messaging Component for iOS
 **/
class Messaging extends Component<{}> {

  /**
   * Agent Emitter Subscription
   */
  agentDetailsSubscription : EmitterSubscription;

  /**
   * App LifeCycle - Component will Mount
   */
  componentWillMount() {
    // Add Agent Details Listener
    this.agentDetailsSubscription = reactNativeEventEmitter.addListener('AgentDetails', this.agentDetails, this);
  }

  /**
   * App LifeCycle - Component did Mount
   */
  componentDidMount() {

  }

  /**
   * App LifeCycle - Component will Unmount
   */
  componentWillUnmount() {
    // Remove Agent Details Listener
    this.agentDetailsSubscription.remove()
  }

  /**
   * Callback will contain Agent Details
   * @param agent(firstName, lastName, nickName, imageURL)
   * @private
   */
  agentDetails (agent){
    // Check if Agent Details are "", if true leave "Messaging" as Title
    let title = (agent.firstName === "") ? "Messaging" : agent.firstName;
    // Change Navigation Bar Name to Agent Name
    this.props.navigation.setParams({ title: title });
  }

  /**
   * Will Override Navigation Options
   * @param navigation
   * @returns {{title: string, headerLeft: *, headerStyle: {backgroundColor: string}|styles.navigationBar|{backgroundColor}, headerTintColor: string, headerRight: *}}
   */
  static navigationOptions = ( { navigation } ) => ({
    // Navigation Bar Title
    title           : typeof(navigation.state.params)==='undefined' || typeof(navigation.state.params.title) === 'undefined' ? 'Messaging': navigation.state.params.title,
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

  /**
   * Will render View
   * @returns {*}
   */
  render() {
    return (
      <View style={styles.container}>
        <MessagingModule style={styles.container}/>
      </View>
    );
  }
}

/**
 * Styling
 */
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

/**
 * Expose Class
 * @type {Messaging}
 */
module.exports = Messaging;