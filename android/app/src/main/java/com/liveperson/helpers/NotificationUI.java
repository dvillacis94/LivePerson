package com.liveperson.helpers;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.Color;
import android.os.Build;
import android.support.v4.app.NotificationCompat;
import android.util.Log;

import com.liveperson.infra.model.PushMessage;
import com.liveperson.messaging.sdk.api.LivePerson;
import com.liveperson.MainActivity;
import com.liveperson .R;

import java.util.List;

/**
 * Created by dvillacis on 1/3/18.
 */

public class NotificationUI {

  // Notification Tag
  private static final String TAG = NotificationUI.class.getSimpleName();
  // Notification ID
  public static final int NOTIFICATION_ID = 143434567;
  // Identifier
  public static final String PUSH_NOTIFICATION = "PUSH_NOTIFICATION";
  // Notification Channel
  private static final String NOTIFICATION_CHANNEL = "FIREBASE_PUSH_NOTIFICATION";

  /**
   * Will Show Notification
   * @param ctx - Application Context
   * @param pushMessage - Push Message
   */
  public static void showNotification(Context ctx, PushMessage pushMessage) {
    // Log Showing Notification
    Log.d("NotificationUI::", "showNotification");
    // Create Notifications
    NotificationCompat.Builder builder;
    // Check OS Version
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      Log.d("NotificationUI::", "Oreo");
      // Will Create new Notification Channel
      createNotificationChannel(ctx);
      // Build Notification
      builder = new NotificationCompat.Builder(ctx, NOTIFICATION_CHANNEL);
      // Set When to Show Notification
      builder.setWhen(System.currentTimeMillis());
    } else {
      Log.d("NotificationUI::", "Not-Oreo");
      // Build Notification
      builder = new NotificationCompat.Builder(ctx);
      // Set Notification Priority
      builder.setPriority(Notification.PRIORITY_HIGH);
    }
    // Set Notification Category
    builder = builder.setCategory(Notification.CATEGORY_MESSAGE);
    // Set Notification Icon
    builder.setSmallIcon(R.mipmap.ic_stat_notification);
    // Set Content Intent
    builder.setContentIntent(getPendingIntent(ctx));
    // Set if Notification Should Auto-cancel
    builder.setAutoCancel(true);
    // Set Defaults
    builder.setDefaults(Notification.DEFAULT_SOUND | Notification.DEFAULT_LIGHTS);
    // Set Notification Style
    builder.setStyle(new NotificationCompat.InboxStyle()
        .addLine("From: " + pushMessage.getFrom())
        .addLine("Message: " + pushMessage.getMessage())
        .addLine("Unread messages: " + pushMessage.getCurrentUnreadMessgesCounter()));
    // Build Notification
    getNotificationManager(ctx).notify(NOTIFICATION_ID, builder.build());
  }

  /**
   * Will Hide Notification
   * @param ctx - Application Context
   */
  public static void hideNotification(Context ctx) {
    // Remove Notification
    getNotificationManager(ctx).cancel(NOTIFICATION_ID);

  }

  /**
   * Get Notification Manager
   * @param ctx - Application Context
   * @return - Notification Manager
   */
  private static NotificationManager getNotificationManager(Context ctx) {
    // Return Notification Manager
    return (NotificationManager) ctx.getSystemService(Context.NOTIFICATION_SERVICE);
  }

  /**
   * Will Create a Notification Channel for OS 26 or greater
   * @param context - Application Context
   */
  private static void createNotificationChannel(Context context) {
    // Validation to Avoid Error - This is being validated on the ShowNotification Method too
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      // Create new Notification Channel
      NotificationChannel notificationChannel = new NotificationChannel(NOTIFICATION_CHANNEL, "Firebase", NotificationManager.IMPORTANCE_HIGH);
      // Configure the notification channel.
      notificationChannel.setDescription("Firebase Notification");
      notificationChannel.enableLights(true);
      notificationChannel.setLightColor(Color.red(1));
      notificationChannel.setVibrationPattern(new long[]{ 0, 1000, 500, 1000 });
      notificationChannel.enableVibration(true);
      getNotificationManager(context).createNotificationChannel(notificationChannel);
    }
  }

  /**
   * Get Pending Intent
   * @param ctx - Application Context
   * @return - Return Activity
   */
  private static PendingIntent getPendingIntent(Context ctx) {
    // Create Main Activity Intent
    Intent showIntent = new Intent(ctx, MainActivity.class);
    // Add Flat to Intent - States that Application is been open from a Push Notification
    showIntent.putExtra(PUSH_NOTIFICATION, true);
    // Return Intent
    return PendingIntent.getActivity(ctx, 0, showIntent, PendingIntent.FLAG_UPDATE_CURRENT);
  }

  /**
   * Set Application Unread Badge
   * @param context - Application Context
   * @param count - Notification Badge Counter
   */
  public static void setBadge(Context context, int count) {
    // Get Class Name
    String launcherClassName = getLauncherClassName(context);
    // Check if Class Name is set
    if (launcherClassName == null) {
      // Escape
      return;
    }
    // Create Intent to Update Badge
    Intent intent = new Intent("android.intent.action.BADGE_COUNT_UPDATE");
    // Intent - Add Counter
    intent.putExtra("badge_count", count);
    // Intent - Add Package Name
    intent.putExtra("badge_count_package_name", context.getPackageName());
    // Intent - Class Name
    intent.putExtra("badge_count_class_name", launcherClassName);
    // Broadcast Intent to Update Badge
    context.sendBroadcast(intent);
  }

  /**
   * Get Launcher Class Name
   * @param context - Application Context
   * @return - Class Name
   */
  public static String getLauncherClassName(Context context) {
    // Get Package Manager
    PackageManager pm = context.getPackageManager();
    // Create new Intent
    Intent intent = new Intent(Intent.ACTION_MAIN);
    // Add Intent Category
    intent.addCategory(Intent.CATEGORY_LAUNCHER);
    // Get Intent Activities
    List<ResolveInfo> resolveInfos = pm.queryIntentActivities(intent, 0);
    for (ResolveInfo resolveInfo : resolveInfos) {
      // Get Package Name
      String pkgName = resolveInfo.activityInfo.applicationInfo.packageName;
      // Check Package vs Context Package Name
      if (pkgName.equalsIgnoreCase(context.getPackageName())) {
        // Return Package name
        return resolveInfo.activityInfo.name;
      }
    }
    // Return Null - if no Package Name found
    return null;
  }

  /**
   * Listen to changes in unread messages counter and updating app icon badge
   */
  public static class BadgeBroadcastReceiver extends BroadcastReceiver {

    /**
     *
     */
    public BadgeBroadcastReceiver() {}

    /**
     * Will receive Unread Messages Counter
     * @param context - Application Context
     * @param intent - Intent
     */
    @Override
    public void onReceive(Context context, Intent intent) {
      // Get Counter from LivePerson Intent
      int counter = intent.getIntExtra(LivePerson.ACTION_LP_UPDATE_NUM_UNREAD_MESSAGES_EXTRA, 0);
      // Update Application Badge
      NotificationUI.setBadge(context, counter);
    }
  }
}
