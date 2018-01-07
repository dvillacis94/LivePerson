/**
 * LivePerson
 *
 * Created by David Villacis on 12/15/17.
 */

import { AppRegistry, Platform } from 'react-native';
// Import NavigationBar
import { StackNavigator } from 'react-navigation';
// Home Screen Component
import Home from './Home';
// TODO : iOS Window Mode Flag, if true, it will instantiate a Component that will Init LPMessagingSDK in WindowMode, else it will instantiate Component in ViewController Mode
// TODO : In the case of Android this is done on the Home Component
let WINDOW_MODE = false;
// Will Select React Component depending with type of View
let ios = (WINDOW_MODE) ? require('./messaging/messaging.window.ios') : require('./messaging/messaging.ios');
// Import Messaging Component
const messaging = Platform.select({
  ios     : ios,
  android : require('./messaging/messaging.android'),
});
// App Component
const App = StackNavigator({
  // Add Home as Main Screen
  Main      : { screen : Home },
  // Add Messaging Screen to Stack
  Messaging : { screen : messaging },
});
// Register Component
AppRegistry.registerComponent('LivePerson', () => App);
