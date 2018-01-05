import {AppRegistry, Platform} from 'react-native';
// Import NavigationBar
import {StackNavigator} from 'react-navigation';
// Home Screen Component
import Home from './Home';
// TODO : Window Mode Flag, if true, it will instantiate a Component that will Init LPMessagingSDK in WindowMode, else it will instantiate Component in ViewController Mode
let WINDOW_MODE = true;
//
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