// Import React
import React, {Component} from 'react';
// Import Components
import {
  View,
  StyleSheet,
  requireNativeComponent,
  NativeModules,
  NativeEventEmitter,
  EmitterSubscription,
  PixelRatio,
  Platform
} from 'react-native';
// Import Messaging View (Window Mode) from Swift Project
const MessagingModule = requireNativeComponent('WindowModeView');
// EventEmitter Import
const { ReactNativeEventEmitter } = NativeModules;
// Create New EventEmitter Instance
const reactNativeEventEmitter = new NativeEventEmitter(ReactNativeEventEmitter);

/**
 * Messaging Component for iOS
 **/
class Messaging extends Component<{}> {

  /**
   * Conversation Closed Emitter Subscription
   */
  conversationClosedSubscription : EmitterSubscription;

  /**
   * App LifeCycle - Component will Mount
   */
  componentWillMount() {
    // Add Conversation Closed Listener
    this.conversationClosedSubscription = reactNativeEventEmitter.addListener('ConversationClosed', this.conversationWasClosed, this);
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
    // Remove Conversation Closed Listener
    this.conversationClosedSubscription.remove()
  }

  /**
   * Callback will contain Conversation State
   * @param conversation
   */
  conversationWasClosed( conversation ){
    // Check if Conversation was dismissed
    if (conversation.state === 'dismiss') {
      // Go Back to Previous Controller
      this.props.navigation.goBack();
    }
  }

  /**
   * Will Override Navigation Options
   * @type {{title: string}}
   */
  static navigationOptions = ( { navigation } ) => ({
    // Navigation Title
    title  : 'Messaging',
    // Hide Navigation Bar
    header : Platform.select({
      ios : null
    }),
  });

  /**
   * Will render View
   * @returns {*}
   */
  render() {
    return (
      <View style={styles.container}>
        <MessagingModule style={styles.container}/>
      </View>);
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
  legend        : {
    flex           : 1,
    alignSelf      : 'center',
    marginVertical : PixelRatio.getPixelSizeForLayoutSize(50),
    color          : '#FFFFFF'
  },
});

/**
 * Expose Class
 * @type {Messaging}
 */
module.exports = Messaging;