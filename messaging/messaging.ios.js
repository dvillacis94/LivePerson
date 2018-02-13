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
  backButtonSubscription : EmitterSubscription;

  /**
   * App LifeCycle - Component will Mount
   */
  componentWillMount() {
    // Add Agent Details Listener
    this.agentDetailsSubscription = reactNativeEventEmitter.addListener('AgentDetails', this.agentDetails, this);
    //
    this.backButtonSubscription = reactNativeEventEmitter.addListener('BackButtonPressed', this.popView, this);
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
    this.agentDetailsSubscription.remove();
    // Remove Back Button Pressed Listener
    this.backButtonSubscription.remove();
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

  popView () {
    //
    this.props.navigation.goBack();
  }

  /**
   * Will Override Navigation Options
   * @param navigation
   * @returns {{title: string, headerLeft: *, headerStyle: {backgroundColor: string}|styles.navigationBar|{backgroundColor}, headerTintColor: string, headerRight: *}}
   */
  static navigationOptions = ( { navigation } ) => ({
    // Navigation Bar Title
    title           : typeof(navigation.state.params)==='undefined' || typeof(navigation.state.params.title) === 'undefined' ? 'Messaging': navigation.state.params.title,
    //
    header : null,
    // Set Back Button
    headerLeft      : (
      // Create Back Button
      <TouchableOpacity
        // View Style
        style={styles.backButton}
        // View Action
        onPress={()=>navigation.goBack()}>
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
        onPress={() => {}}>
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
    backgroundColor : '#FFFFFF'
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