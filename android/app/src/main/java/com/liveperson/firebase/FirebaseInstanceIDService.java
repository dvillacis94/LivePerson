package com.liveperson.firebase;

/**
 * Created by dvillacis on 9/13/17.
 */
// Required Android Imports
import android.content.Intent;
import android.util.Log;
// Required Firebase Imports
import com.google.firebase.iid.FirebaseInstanceIdService;


public class FirebaseInstanceIDService extends FirebaseInstanceIdService {
  //
  private static final String TAG = "FirebaseIIDService";

  /**
   * Called if InstanceID token is updated. This may occur if the security of
   * the previous token had been compromised. Note that this is called when the InstanceID token
   * is initially generated so this is where you would retrieve the token.
   */
  @Override
  public void onTokenRefresh() {
    Log.d(TAG,"onTokenRefresh");
    // Get updated Firebase InstanceID token.
    Intent intent = new Intent(this, FirebaseRegistrationIntentService.class);
    // Start Service
    startService(intent);
  }
}
