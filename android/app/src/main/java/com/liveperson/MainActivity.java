package com.liveperson;
/**
 * LivePerson
 *
 * Created by David Villacis on 1/3/18.
 */
import android.content.IntentFilter;
// Required React-Native Import
import com.facebook.react.ReactActivity;
// Required Firebase Import
import com.liveperson.firebase.LPFirebaseMessagingService;
// Required Local Notification Import
import com.liveperson.helpers.LocalNotificationReceiver;

public class MainActivity extends ReactActivity {

  // Saves App State
  public static boolean foreground;

  /**
   * Returns the name of the main component registered from JavaScript.
   * This is used to schedule rendering of the component.
   */
  @Override
  protected String getMainComponentName() {
    return "LivePerson";
  }

  // Intent For Local Notification Message
  IntentFilter localNotificationMessageFilter = new IntentFilter(LPFirebaseMessagingService.LOCAL_NOTIFICATION_ACTION);
  // Create Local Notification Receiver
  LocalNotificationReceiver notificationReceiver = new LocalNotificationReceiver();

  /**
   * App LifeCycle - Will Resume
   */
  @Override
  protected void onResume() {
    // Init Super Class
    super.onResume();
    // Set Foreground Flag - Needed to Show Toast Notification, instead of Push
    foreground = true;
    // Register New Receiver for Local Notification
    registerReceiver(notificationReceiver, localNotificationMessageFilter);
  }

  /**
   * App LifeCycle - Will Pause
   */
  @Override
  protected void onPause() {
    // Set Foreground Flag - Needed to Push Notification, instead of Toast
    foreground = false;
    // Unregister Receiver - Notification
    unregisterReceiver(notificationReceiver);
    // Init Super Class
    super.onPause();
  }
}
