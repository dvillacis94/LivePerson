package com.liveperson.messaging;
/**
 * LivePerson
 *
 * Created by David Villacis on 1/5/18.
 */
// Required Android Imports
import android.app.Notification;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.widget.Toast;
import com.liveperson.R;
// Required Firebase Imports
import com.liveperson.api.LivePersonIntents;
import com.liveperson.api.sdk.LPConversationData;
import com.liveperson.firebase.FirebaseRegistrationIntentService;
// Required LPMessaging Imports
import com.liveperson.helpers.Configuration;
import com.liveperson.infra.ConversationViewParams;
import com.liveperson.infra.ICallback;
import com.liveperson.infra.InitLivePersonProperties;
import com.liveperson.infra.LPAuthenticationParams;
import com.liveperson.infra.callbacks.InitLivePersonCallBack;
import com.liveperson.infra.messaging_ui.fragment.ConversationFragment;
import com.liveperson.messaging.model.AgentData;
import com.liveperson.messaging.sdk.api.LivePerson;
import com.liveperson.messaging.sdk.api.model.ConsumerProfile;

/**
 * Used as an example of how to use SDK "Fragment mode"
 */
public class FragmentContainerActivity extends AppCompatActivity {

  // Get Class Simple Name for Logging
  private static final String TAG = FragmentContainerActivity.class.getSimpleName();
  // Fragment Id
  private static final String LIVEPERSON_FRAGMENT = "liveperson_fragment";
  // Conversation Fragment
  private ConversationFragment mConversationFragment;
  // Reference to Toolbar - Needed to Update Agent Details
  public Toolbar mActionBarToolbar;
  // Will contain ConversationStatus
  public Boolean isConversationActive = false;
  // Will contain Conversation Urgent or Normal Status
  public Boolean isConversationUrgent = false;

  //<editor-fold defaultstate="expanded" desc="App LifeCycle">

  /**
   * App LifeCycle - OnCreate
   * @param savedInstanceState - Instance State
   */
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    // Super Init
    super.onCreate(savedInstanceState);
    // Bind View
    setContentView(R.layout.activity_custom);
    // Get Action Bar
    mActionBarToolbar = (Toolbar) findViewById(R.id.toolbar);
    // Set Action Bar
    setSupportActionBar(mActionBarToolbar);
    // Log
    Log.i(TAG, "onCreate savedInstanceState :: " + savedInstanceState);
    // Register Receiver for Filtered Intents
    LocalBroadcastManager.getInstance(getApplicationContext()).registerReceiver(eventsReceiver, this.getIntentFilter());
    // Init LPMessagingSDK
    this.initSDK();
  }

  /**
   * App LifeCycle - Will Resume
   */
  @Override
  protected void onResume() {
    // Super Init
    super.onResume();
    // Check Fragment is not null
    if (mConversationFragment != null) {
      // Attach Fragment
      attachFragment();
    }
  }

  /**
   *  App LifeCycle - OnPause
   */
  @Override
  protected void onPause() {
    // Super Init
    super.onPause();
  }

  /**
   * App LifeCycle - Back Button was Pressed
   */
  @Override
  public void onBackPressed() {
    // Check Fragment is not null or BackButton was not pressed
    if (mConversationFragment == null || !mConversationFragment.onBackPressed()) {
      // Super Init
      super.onBackPressed();
    }
  }

  //</editor-fold>


  //<editor-fold defaultstate="expanded" desc="Menu Events">

  /**
   * Will Create Menu Options
   * @param menu - Menu
   * @return New menu
   */
  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    // super.onCreateOptionsMenu(menu);
    // Get Menu Inflater
    MenuInflater inflater = getMenuInflater();
    // Add Fragment Menu
    inflater.inflate(R.menu.fragment_menu, menu);
    // Return True
    return true;
  }

  /**
   * Will respond to User Interacting with Menu Items
   * @param item - Touched Item
   * @return - Boolean
   */
  public boolean onOptionsItemSelected(MenuItem item) {
    // Select Touched Menu Item
    switch (item.getItemId()) {
      case R.id.urgent:
        this.toggleUrgentState();
        return true;
      case R.id.resolved:
        this.resolveConversation();
        return true;
      case R.id.clear:
        this.clearConversationHistory();
        return true;
      default:
        return super.onOptionsItemSelected(item);
    }
  }

  /**
   * Will Prepare Menu
   * @param menu - Menu
   * @return Boolean
   */
  @Override
  public boolean onPrepareOptionsMenu(Menu menu) {
    //
    super.onPrepareOptionsMenu(menu);
    if (menu.findItem(R.id.resolved) != null){
      // Get Menu Item - Resolved
      MenuItem resolved = menu.findItem(R.id.resolved);
      // Toggle State
      resolved.setVisible(isConversationActive);
    }
    if (menu.findItem(R.id.urgent) != null){
      // Get Menu Item - Urgent
      MenuItem urgent = menu.findItem(R.id.urgent);
      // Select Title
      String title = (isConversationUrgent) ? "Mark as Normal": ("Mark as Urgent");
      // Change Title
      urgent.setTitle(title);
      // Toggle State
      urgent.setVisible(isConversationActive);
    }
    if (menu.findItem(R.id.clear) != null){
      // Get Menu Item - Urgent
      MenuItem clear = menu.findItem(R.id.clear);
      // Toggle State
      clear.setVisible(!isConversationActive);
    }
    return true;
  }

  //</editor-fold>

  //<editor-fold defaultstate="expanded" desc="LPMessagingSDK Implementations">

  /**
   * Will Init LPMessagingSDK
   */
  private void initSDK(){
    // Init LPMessagingSDK
    LivePerson.initialize(getApplicationContext(), new InitLivePersonProperties(Configuration.BRAND_ID, Configuration.FIREBASE_ID, new InitLivePersonCallBack() {
      /**
       * LivePerson SDK was init
       */
      @Override
      public void onInitSucceed() {
        Log.i(TAG, "onInitSucceed");
        // Init Fragment on UI Thread
        runOnUiThread(new Runnable() {
          @Override
          public void run() {
            // Init Fragment
            initFragment();
          }
        });
        // Register Firebase Notification
        handleFirebaseRegistration();
        // Create Consumer Profile
        ConsumerProfile consumerProfile = new ConsumerProfile.Builder()
            .setFirstName("John")
            .setLastName("Doe")
            .setPhoneNumber("(123) 456-7809")
            .build();
        // Set User Profile
        LivePerson.setUserProfile(consumerProfile);
        // Toggle Menu
        checkConversationStatus();
      }

      /**
       * LivePerson SDK encounter an error while Initializing
       * @param e - Exception
       */
      @Override
      public void onInitFailed(Exception e) {
        // Log Error
        Log.e(TAG, "onInitFailed : " + e.getMessage());
      }
    }));
  }

  /**
   * Will check conversation is Active and Toggle Menu Buttons accordingly
   * TODO: There are multiple calls to this method
   */
  private void checkConversationStatus(){
    // Will check is Conversation is Active
    LivePerson.checkActiveConversation(new ICallback<Boolean, Exception>() {
      /**
       * Will handle Success
       * @param aBoolean - Conversation State
       */
      @Override
      public void onSuccess(Boolean aBoolean) {
        // Log State
        Log.d(TAG,"State :: " + String.valueOf(aBoolean));
        // Set isConversationActive
        isConversationActive = aBoolean;
        // if Conversation is Active Check if Urgent
        checkUrgentStatus();
      }
      /**
       * Will Handle Error
       * @param e - Error
       */
      @Override
      public void onError(Exception e) {
        // Log - Error
        Log.d(TAG,e.getLocalizedMessage());
      }
    });
  }

  /**
   * Will check if the Conversation is Mark as Urgent or not
   */
  private void checkUrgentStatus(){
    // Will check is Conversation is Mark As Urgent
    LivePerson.checkConversationIsMarkedAsUrgent(new ICallback<Boolean, Exception>() {
      /**
       * Will handle Success
       * @param aBoolean - Conversation State
       */
      @Override
      public void onSuccess(Boolean aBoolean) {
        // Log State
        Log.d(TAG,"Urgent :: " + String.valueOf(aBoolean));
        // Set isConversationActive
        isConversationUrgent = aBoolean;
      }
      /**
       * Will Handle Error
       * @param e - Error
       */
      @Override
      public void onError(Exception e) {
        // Log - Error
        Log.d(TAG,e.getLocalizedMessage());
      }
    });
  }

  /**
   * Will change the Conversation State Between Urgent and Normal
   */
  private void toggleUrgentState(){
    // Check if Conversation is Urgent
    if (this.isConversationUrgent){
      // Mark as Normal
      LivePerson.markConversationAsNormal();
    } else {
      // Mark as Urgent
      LivePerson.markConversationAsUrgent();
    }

  }

  /**
   * Will clear Conversation History
   */
  private void clearConversationHistory(){
    // Check if Conversation is Active
    if (!this.isConversationActive){
      LivePerson.clearHistory();
    } else {
      // Show Toast Notification
      Toast.makeText(getApplicationContext(), "Cannot clear history, is a conversation is active.", Toast.LENGTH_SHORT).show();
    }
  }

  /**
   * Will resolve Current Conversation
   */
  private void resolveConversation(){
    // Check if there is an Active Conversation
    if (this.isConversationActive){
      // Resolve Conversation
      LivePerson.resolveConversation();
    }
  }

  //</editor-fold>

  /**
   * Will handle Fragment registering Firebase Service (Push Notifications)
   */
  private void handleFirebaseRegistration(){
    // Create Intent for Firebase Service
    Intent firebase = new Intent(getApplicationContext(), FirebaseRegistrationIntentService.class);
    // Start Firebase Service
    getApplicationContext().startService(firebase);
  }

  /**
   * Will init Conversation Fragment
   */
  private void initFragment() {
    // Get Conversation Fragment
    mConversationFragment = (ConversationFragment) getSupportFragmentManager().findFragmentByTag(LIVEPERSON_FRAGMENT);
    // Log
    Log.d(TAG, "initFragment. mConversationFragment = " + mConversationFragment);
    // Check if Conversation Fragment exists
    if (mConversationFragment == null) {
      //<editor-fold defaultstate="collapsed" desc="Authentication Code">
      /*String authCode = SampleAppStorage.getInstance(FragmentContainerActivity.this).getAuthCode();
      Log.d(TAG, "initFragment. authCode = " + authCode);
      if (TextUtils.isEmpty(authCode)) {
        mConversationFragment = (ConversationFragment) LivePerson.getConversationFragment();
      } else {
        mConversationFragment = (ConversationFragment) LivePerson.getConversationFragment(authCode);
      }*/
      //</editor-fold>
      // TODO : Create Fragment add setHostAppJWT(), setAuthKey(), or setHostAppRedirectUri() to LPAuthenticationParams() depeding on needs
      mConversationFragment = (ConversationFragment) LivePerson.getConversationFragment(new LPAuthenticationParams(), new ConversationViewParams(false));
      // Check is State is Valid
      if (isValidState()) {
        // Pending intent for image foreground service
        Intent notificationIntent = new Intent(getApplicationContext(), FragmentContainerActivity.class);
        // Set Flag for Notification Intent
        notificationIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        // Set Notification Intent as Pending Intent
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0);
        // Set Service for Pending Intent
        LivePerson.setImageServicePendingIntent(pendingIntent);
        // Notification builder for image upload foreground service
        Notification.Builder uploadBuilder = new Notification.Builder(getApplicationContext());
        // Notification builder for image download foreground service
        Notification.Builder downloadBuilder = new Notification.Builder(getApplicationContext());
        // Build Upload Notification
        uploadBuilder.setContentTitle("Uploading image")
            .setSmallIcon(android.R.drawable.arrow_up_float)
            .setContentIntent(pendingIntent)
            .setProgress(0, 0, true);
        // Build Download Notification
        downloadBuilder.setContentTitle("Downloading image")
            .setSmallIcon(android.R.drawable.arrow_down_float)
            .setContentIntent(pendingIntent)
            .setProgress(0, 0, true);
        // Set Service - Upload
        LivePerson.setImageServiceUploadNotificationBuilder(uploadBuilder);
        // Set Service - Download
        LivePerson.setImageServiceDownloadNotificationBuilder(downloadBuilder);
        // Begin Fragment Transaction
        FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
        // Add Fragment
        ft.add(R.id.custom_fragment_container, mConversationFragment, LIVEPERSON_FRAGMENT).commitAllowingStateLoss();
      }
    } else {
      // Attach Fragment
      attachFragment();
    }
  }

  /**
   * Check if State is Valid
   * @return - State
   */
  private boolean isValidState() {
    // Check SDK Version
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
      // Status Check
      return !isFinishing() && !isDestroyed();
    } else {
      // Status Check
      return !isFinishing();
    }
  }

  /**
   * Will Attach Fragment
   */
  private void attachFragment() {
    // Check if Fragment is Detached
    if (mConversationFragment.isDetached()) {
      // Log
      Log.d(TAG, "initFragment. attaching fragment");
      // Check if State is Valid
      if (isValidState()) {
        // Get Fragment Manager & Start Transaction
        FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
        // Attach Fragment
        ft.attach(mConversationFragment).commitAllowingStateLoss();
      }
    }
  }

  //<editor-fold defaultstate="collapsed" desc="BroadCastReceiver Methods">

  /**
   * Broadcast Receiver - Will Catch Agent Details Changed Event
   */
  BroadcastReceiver eventsReceiver = new BroadcastReceiver() {
    @Override
    public void onReceive(Context context, Intent intent) {
      // Filter Intent by Action
      switch (intent.getAction()){
        case LivePersonIntents.ILivePersonIntentAction.LP_ON_AGENT_DETAILS_CHANGED_INTENT_ACTION:
          // Get Agent Details
          AgentData agentData = LivePersonIntents.getAgentData(intent);
          // Method to Print Agent Details on Toast
          onAgentDetailsChanged(agentData);
          break;
        case LivePersonIntents.ILivePersonIntentAction.LP_ON_CONVERSATION_RESOLVED_INTENT_ACTION:
          // Get LP Conversation Data
          LPConversationData lpConversationData = LivePersonIntents.getLPConversationData(intent);
          // Handle Conversation Ended
          onConversationResolved(lpConversationData);
          break;
        case LivePersonIntents.ILivePersonIntentAction.LP_ON_CONVERSATION_STARTED_INTENT_ACTION:
          // Get LP Conversation Data
          LPConversationData lpConversationData1 = LivePersonIntents.getLPConversationData(intent);
          // Handle Conversation Started
          onConversationStarted(lpConversationData1);
          break;
        case LivePersonIntents.ILivePersonIntentAction.LP_ON_CONVERSATION_MARKED_AS_NORMAL_INTENT_ACTION:
          onConversationMarkedAsNormal();
          break;
        case LivePersonIntents.ILivePersonIntentAction.LP_ON_CONVERSATION_MARKED_AS_URGENT_INTENT_ACTION:
          onConversationMarkedAsUrgent();
          break;
      }
    }
  };

  /**
   * Will get Agent Details Changed
   * @param agentData - Agent Information
   */
  private void onAgentDetailsChanged(AgentData agentData) {
    // Check if Toolbar not null
    if (getSupportActionBar() != null){
      // Build Agent - Fist Name
      String agent = (agentData.mFirstName.equals("")) ? "" : agentData.mFirstName;
      // Build Agent - Last Name
      agent += (agentData.mLastName.equals("")) ? "" : (" " + agentData.mLastName);
      // Set Agent Name in Toolbar Title
      getSupportActionBar().setTitle(agent);
    }
  }

  /**
   * Will get Conversation Data if Conversation started
   * @param conversationData - Conversation Data
   */
  private void onConversationStarted(LPConversationData conversationData){
    // Check Conversation Status
    this.checkConversationStatus();
  }

  /**
   * Will get Conversation Data if Conversation was resolve
   * @param conversationData - Conversation Data
   */
  private void onConversationResolved(LPConversationData conversationData){
    // Check if Toolbar not null
    if (getSupportActionBar() != null){
      // Change Toolbar Title to Default
      getSupportActionBar().setTitle("LivePerson");
    }
    // Check Conversation Status
    this.checkConversationStatus();
  }

  /**
   * Will be trigger if Conversation mark as Normal
   */
  private void onConversationMarkedAsNormal(){
    // Change Conversation Urgent State
    this.isConversationUrgent = false;
  }

  /**
   * Will be trigger if Conversation mark as Urgent
   */
  private void onConversationMarkedAsUrgent(){
    // Change Conversation Urgent State
    this.isConversationUrgent = true;
  }

  /**
   * Will return Selected Intents to Filter
   * @return IntentFilter
   */
  private IntentFilter getIntentFilter(){
    // Create Intent Filter
    IntentFilter filter = new IntentFilter();
    // Add Agent Details Changed Intent
    filter.addAction(LivePersonIntents.ILivePersonIntentAction.LP_ON_AGENT_DETAILS_CHANGED_INTENT_ACTION);
    // Add Conversation Resolved Intent
    filter.addAction(LivePersonIntents.ILivePersonIntentAction.LP_ON_CONVERSATION_RESOLVED_INTENT_ACTION);
    // Add Agent Details Changed Intent
    filter.addAction(LivePersonIntents.ILivePersonIntentAction.LP_ON_CONVERSATION_STARTED_INTENT_ACTION);
    // Add Conversation Mark as Normal Intent
    filter.addAction(LivePersonIntents.ILivePersonIntentAction.LP_ON_CONVERSATION_MARKED_AS_NORMAL_INTENT_ACTION);
    // Add Conversation Mark as Urgent Intent
    filter.addAction(LivePersonIntents.ILivePersonIntentAction.LP_ON_CONVERSATION_MARKED_AS_URGENT_INTENT_ACTION);
    // Return Selected Intents
    return filter;
  }

  //</editor-fold>
}
