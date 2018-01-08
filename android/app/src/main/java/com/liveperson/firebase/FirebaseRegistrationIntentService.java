package com.liveperson.firebase;

// Required Android Imports
import android.app.IntentService;
import android.content.Intent;
import android.util.Log;
// Required Firebase Imports
import com.google.firebase.iid.FirebaseInstanceId;
// Required LivePerson Imports
import com.liveperson.messaging.sdk.api.LivePerson;
import com.liveperson.helpers.Configuration;


/**
 *
 */
public class FirebaseRegistrationIntentService extends IntentService {

  // Application Tag
  public static final String TAG = FirebaseRegistrationIntentService.class.getSimpleName();

  /**
   * Creates an IntentService.  Invoked by your subclass's constructor.
   */
  public FirebaseRegistrationIntentService() {
    // Init
    super(TAG);
  }

  @Override
  protected void onHandleIntent(Intent intent) {
    // LOG
    Log.d(TAG, "onHandleIntent: registering the token to pusher");
    // Get Token
    String token = FirebaseInstanceId.getInstance().getToken();
    // LOG - Token
    Log.d(TAG, "Token :: " + token);
    // LOG - Brand Id
    Log.d(TAG, "Brand :: " + Configuration.ALPHA);
    // LOG - Firebase Id
    Log.d(TAG, "Firebase :: " + Configuration.FIREBASE_ID);
    // Register to LivePerson Pusher
    LivePerson.registerLPPusher(Configuration.ALPHA, Configuration.FIREBASE_ID, token);
  }
}
