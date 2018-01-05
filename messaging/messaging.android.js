/**
 * LivePerson
 *
 * Created by David Villacis on 12/15/17.
 */

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
  Text
} from 'react-native';

/**
 * Messaging Component for Android
 **/
class Messaging extends Component<{}> {

  /**
   * App LifeCycle - Component will Mount
   */
  componentWillMount() {

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

  }

  /**
   * Will Override Navigation Options
   * @type {{title: string}}
   */
  static navigationOptions = ( { navigation } ) => ({
    // Navigation Title
    title  : 'Messaging',
  });

  /**
   * Will render View
   * @returns {*}
   */
  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.legend}>
          Android Messaging Screen
        </Text>
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