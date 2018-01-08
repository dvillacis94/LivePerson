package com.liveperson.firebase;

/**
 * Created by dvillacis on 9/13/17.
 */

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.firebase.jobdispatcher.FirebaseJobDispatcher;
import com.firebase.jobdispatcher.GooglePlayDriver;
import com.firebase.jobdispatcher.Job;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import com.liveperson.infra.model.PushMessage;
import com.liveperson.messaging.sdk.api.LivePerson;
import com.liveperson.helpers.Configuration;
import com.liveperson.helpers.LivePersonJobService;
import com.liveperson.helpers.NotificationUI;
import com.liveperson.MainActivity;

import java.util.Map;

public class LPFirebaseMessagingService extends FirebaseMessagingService {

  // Tag for LOG
  private static final String TAG = "FirebaseMsgService::";
  // Notification ID
  public static final int NOTIFICATION_ID = 143434567;
  // Push Identifier
  public static final String PUSH_NOTIFICATION = "push_notification";
  // Local Notification Intent EXTRA - Agent Name
  public static final String LOCAL_NOTIFICATION_EXTRA_AGENT = "SHOW_LOCAL_NOTIFICATION_EXTRA_AGENT";
  // Local Notification Intent EXTRA - Message
  public static final String LOCAL_NOTIFICATION_EXTRA_MESSAGE = "SHOW_LOCAL_NOTIFICATION_EXTRA_MESSAGE";
  // Local Notification Intent
  public static final String LOCAL_NOTIFICATION_ACTION = "com.liveperson.support.SHOW_LOCAL_NOTIFICATION_ACTION";

  /**
   * Called when message is received.
   *
   * @param remoteMessage Object representing the message received from Firebase Cloud Messaging.
   */
  @Override
  public void onMessageReceived(RemoteMessage remoteMessage) {
    // Transform the RemoteMessage to a bundle the MessagingSDK can understand
    Bundle bundle = new Bundle();
    //
    for (Map.Entry<String, String> entry : remoteMessage.getData().entrySet()) {
      // Put Strings
      bundle.putString(entry.getKey(), entry.getValue());
      // Log Strings
      Log.d(TAG, String.format("%s => %s", entry.getKey(), entry.getValue()));
    }
    try {
        // Register
        final PushMessage message;
        // Check if message contains a data payload.
        if (remoteMessage.getData().size() > 0) {
          // Get Remote Notification
          message = LivePerson.handlePushMessage(this, remoteMessage.getData(), Configuration.ALPHA, false);
          //Code snippet to add push UI notification
          if (message != null) {
            // Check Application State
            if (MainActivity.foreground) {
              // Create New Intent
              Intent intent = new Intent();
              // Set Intent Action
              intent.setAction(LOCAL_NOTIFICATION_ACTION);
              // Add Message String
              intent.putExtra(LOCAL_NOTIFICATION_EXTRA_AGENT, message.getFrom());
              // Add Message String
              intent.putExtra(LOCAL_NOTIFICATION_EXTRA_MESSAGE, message.getMessage());
              // Broadcast Intent
              sendBroadcast(intent);
            } else {
              // Show Notification
              NotificationUI.showNotification(this, message);
            }
          } else {
            // For long-running tasks (10 seconds or more) use Firebase Job Dispatcher.
            scheduleJob();
          }
        }
    } catch (Exception e) {
      System.out.println("Error:: " + e.getMessage());
    }
  }

  /**
   * Schedule a job using FirebaseJobDispatcher.
   */
  private void scheduleJob() {
    // [START dispatch_job]
    FirebaseJobDispatcher dispatcher = new FirebaseJobDispatcher(new GooglePlayDriver(this));
    Job myJob = dispatcher.newJobBuilder()
        .setService(LivePersonJobService.class)
        .setTag("live-notification-tag")
        .build();
    dispatcher.schedule(myJob);
    // [END dispatch_job]
  }
}
