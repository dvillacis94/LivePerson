package com.liveperson.messaging;

/**
 * LivePerson
 *
 * Created by David Villacis on 1/5/18.
 */
// Required Android Imports
import android.content.Intent;
import android.widget.Toast;
// Required React-Native Imports
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
// Required Firebase Import
import com.liveperson.firebase.FirebaseRegistrationIntentService;
// Import Configuration
import com.liveperson.helpers.Configuration;
// Required LPMessaging Imports
import com.liveperson.infra.ConversationViewParams;
import com.liveperson.infra.InitLivePersonProperties;
import com.liveperson.infra.LPAuthenticationParams;
import com.liveperson.infra.callbacks.InitLivePersonCallBack;
import com.liveperson.messaging.sdk.api.LivePerson;
import com.liveperson.messaging.sdk.api.model.ConsumerProfile;

public class MessagingModule extends ReactContextBaseJavaModule {

  /**
   * The purpose of this method is to return the string name of the NativeModule which represents this class in JavaScript
   * @return - Module Name
   */
  @Override
  public String getName() {
    return "MessagingModule";
  }

  /**
   * Will init Class with React Context
   * @param reactContext - React-Native Context
   */
  MessagingModule(ReactApplicationContext reactContext){
    // Init
    super(reactContext);
  }

  /**
   * Will show Messaging
   * ReactMethod - Makes this Method available on the React-Native Side
   */
  @ReactMethod
  public void showActivity(){
    // Init LPMessagingSDK
    this.initMessagingSDK(Configuration.ALPHA, Configuration.FIREBASE_ID);
  }

  /**
   * Will show Messaging on Fragment Mode
   * ReactMethod - Makes this Method available on the React-Native Side
   */
  @ReactMethod
  public void showFragment(){
    // Init Conversation Fragment Intent
    Intent intent = new Intent(getCurrentActivity(), FragmentContainerActivity.class);
    // Check if Current Activity Exists
    if (getCurrentActivity() != null) {
      // Start Conversation Fragment Intent
      getCurrentActivity().startActivity(intent);
    }
  }
  //<editor-fold defaultstate="expanded" desc="LivePerson SDK">

  /**
   * Init SDK
   *
   * @param brandId - Account Number
   * @param appId   - App ID
   */
  private void initMessagingSDK(String brandId, final String appId) {
    // Init SDK
    LivePerson.initialize(getCurrentActivity(), new InitLivePersonProperties(brandId, appId, new InitLivePersonCallBack() {
      @Override
      public void onInitSucceed() {
        // Init Firebase Intent Service
        Intent intent = new Intent(getCurrentActivity(), FirebaseRegistrationIntentService.class);
        // Check if Current Activity Exists
        if (getCurrentActivity() != null) {
          // Start Firebase Service
          getCurrentActivity().startService(intent);
        }
        // Show Conversation
        showConversation();
      }

      @Override
      public void onInitFailed(Exception e) {
        // Init Toast
        Toast toast = Toast.makeText(getReactApplicationContext(), "Messaging Initialization Failed", Toast.LENGTH_LONG);
        // Show Toast
        toast.show();
      }
    }));
  }

  /**
   * Will show a new Conversation
   */
  private void showConversation() {
    // Init Show Conversation
    LivePerson.showConversation(getCurrentActivity(), new LPAuthenticationParams().setHostAppJWT(Configuration.JWT), new ConversationViewParams(false));
    // Consumer Profile
    ConsumerProfile consumerProfile = new ConsumerProfile.Builder()
        .setFirstName("John")
        .setLastName("Doe")
        .setPhoneNumber("(789) 123-4567")
        .build();
    // Set User Profile
    LivePerson.setUserProfile(consumerProfile);
  }

  //</editor-fold>
}
