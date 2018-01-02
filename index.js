import {AppRegistry, Platform} from 'react-native';
// Import NavigationBar
import {StackNavigator} from 'react-navigation';
// Home Screen Component
import Home from './Home';
// Import Messaging Component
const messaging = Platform.select({
  ios     : require('./messaging/messaging.ios'),
  android : 'Double tap R on your keyboard to reload,\n' + 'Shake or press menu button for dev menu',
});
// App Component
const App = StackNavigator({
  Main      : { screen : Home },
  Messaging : { screen : messaging },
});
AppRegistry.registerComponent('LivePerson', () => App);
