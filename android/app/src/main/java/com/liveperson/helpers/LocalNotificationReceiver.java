package com.liveperson.helpers;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import com.liveperson.firebase.LPFirebaseMessagingService;

/**
 * Created by dvillacis on 1/3/18.
 */

public class LocalNotificationReceiver extends BroadcastReceiver {

  /**
   * Initializer
   */
  public LocalNotificationReceiver () {

  }

  /**
   *
   * @param context - Application Context
   * @param intent - Intent
   */
  @Override
  public void onReceive(Context context, Intent intent) {
    // Bundle Extras
    Bundle extras = intent.getExtras();
    // Check Extras are available
    if (extras != null) {
      //
      String toastText = "";
      // Get Message Agent
      String agent = extras.getString(LPFirebaseMessagingService.LOCAL_NOTIFICATION_EXTRA_AGENT);
      // Get Message Text
      String message = extras.getString(LPFirebaseMessagingService.LOCAL_NOTIFICATION_EXTRA_MESSAGE);
      // Append Agent Name
      toastText = (agent != null && !agent.equals("")) ? (toastText + agent + " : ") : toastText;
      // Append Message Text
      toastText = (message != null && !message.equals("")) ? (toastText + message) : toastText;
      // Check if message is not null
      if (message != null) {
        // LOG
        Log.d("LocalOnReceiver", "Showing Toast");
        // Show Toast Notification
        Toast.makeText(context, toastText, Toast.LENGTH_SHORT).show();
      }
    }
  }
}
