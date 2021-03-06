//
//  WindowModeViewController.swift
//  LivePerson
//
//  Created by David Villacis on 1/3/18.
//  Copyright © 2018 Facebook. All rights reserved.
//
import UIKit
// Required LP Imports
import LPMessagingSDK
import LPAMS
import LPInfra

class WindowModeViewController: UIViewController {
  
  // MARK: - App LifeCycle
  
  /// Init View
  ///
  /// - Parameter frame: Frame
  init() {
    // Init Super
    super.init(nibName: nil, bundle: nil)
  }
  
  /// Super Init
  required init?(coder aDecoder: NSCoder) {
    // Log
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Override LoadView
  override func loadView() {
    // Get Frame from Screen
    let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    // Create new with Frame
    let view = UIView(frame: frame)
    // Set Background color
    view.backgroundColor = UIColor.lightGray.lighter(by: 20.0)
    // Set View
    self.view = view
  }
  
  /// App LifeCycle - View Did Load
  override func viewDidLoad() {
    // Super Init
    super.viewDidLoad()
    // Init LivePerson Singleton
    LivePersonSDK.shared.initSDK()
    // Init SDK Logger
    LivePersonSDK.shared.initLogger()
    // Set Delegate
    LivePersonSDK.shared.delegate = self
    // Customize Messaging Screen
    LivePersonSDK.shared.customizeMessagingScreen()
  }
  
  /// App LifeCycle - Memory Warning
  override func didReceiveMemoryWarning() {
    // Super Init
    super.didReceiveMemoryWarning()
  }
  
  /// App LifeCycle - View will Appear
  ///
  /// - Parameter animated: Bool
  override func viewWillAppear(_ animated: Bool) {
    // We need to call Show Conversation in ViewwillAppear for a few reasons:
    // 1) Based off of emperical evidence from testing with the SDK, the view needs to be loaded before we call showConversation
    // 2) Calling showConversation in viewDidLoad would be ideal, but we need to call removeConversation when the tab
    // gets navigated away from, so we may need to call showConversation multiple times in the viewcontrollers lifecycle
    //
    // NOTE: Calling showConversation when the conversation is already showing does nothing
    // Show Messaging Screen
    LivePersonSDK.shared.showConversation()
    // Super Init
    super.viewWillAppear(animated)
  }
  
  /// App LifeCycle - View will Disappear
  override func viewWillDisappear(_ animated: Bool) {
    // INFO: When using Custom View Controller Mode, Conversation must be remove when leaving the App, if the Conversation View is the current screen
    // Super Init
    super.viewWillDisappear(animated)
    // Remove Conversation
    LivePersonSDK.shared.removeConversation()
  }
}
extension WindowModeViewController : LPMessagingSDKdelegate {
  
  //MARK:- Required - LPMessagingSDKDelegate
  
  /**
   This delegate method is required.
   It is called when authentication process fails
   */
  func LPMessagingSDKAuthenticationFailed(_ error: NSError) {
    NSLog("Error: \(error)");
  }
  
  /**
   This delegate method is required.
   It is called when the SDK version you're using is obselete and needs an update.
   */
  func LPMessagingSDKObseleteVersion(_ error: NSError) {
    NSLog("Error: \(error)");
  }
  
  /**
   This delegate method is required.
   It is called when the token which used for authentication is expired
   */
  func LPMessagingSDKTokenExpired(_ brandID: String) {
    
  }
  
  /**
   This delegate method is required.
   It lets you know if there is an error with the sdk and what this error is
   */
  func LPMessagingSDKError(_ error: NSError) {
    // Log - Event
    print("SDKError :: \(error.localizedDescription)")
  }
  
  //MARK:- Optionals - LPMessagingSDKDelegate
  
  /**
   This delegate method is optional.
   It is called each time the SDK receives info about the agent on the other side.
   
   Example:
   You can use this data to show the agent details on your navigation bar (in view controller mode)
   */
  func LPMessagingSDKAgentDetails(_ agent: LPUser?) {
    
  }
  
  /**
   This delegate method is optional.
   It is called each time the SDK menu is opened/closed.
   */
  func LPMessagingSDKActionsMenuToggled(_ toggled: Bool) {
    
  }
  
  /**
   This delegate method is optional.
   It is called each time the agent typing state changes.
   */
  func LPMessagingSDKAgentIsTypingStateChanged(_ isTyping: Bool) {
    
  }
  
  /**
   This delegate method is optional.
   It is called after the customer satisfaction page is submitted with a score.
   */
  func LPMessagingSDKCSATScoreSubmissionDidFinish(_ accountID: String, rating: Int) {
    
  }
  
  /**
   This delegate method is optional.
   If you set a custom button, this method will be called when the custom button is clicked.
   */
  func LPMessagingSDKCustomButtonTapped() {
    
  }
  
  /**
   This delegate method is optional.
   It is called when the conversation view controller removed from its container view controller or window.
   */
  func LPMessagingSDKConversationViewControllerDidDismiss() {
    // INFO : Event needs to be dispatch when using Window Mode, React-Navite will handle Removing ParentViewController
    // Agent Dictionary
    var info : [String : String] = [:]
    // Add Conversation State
    info["state"] = "dismiss"
    // Dispatch Event
    EventEmitter.shared.dispatch(name: "ConversationClosed", body: info)
  }
  
  /**
   This delegate method is optional.
   It is called when a new conversation has started, from the agent or from the consumer side.
   */
  func LPMessagingSDKConversationStarted(_ conversationID: String?) {
    // Log - Event
    print("conversationID:: \(conversationID!)")
  }
  
  /**
   This delegate method is optional.
   It is called when a conversation has ended, from the agent or from the consumer side.
   */
  func LPMessagingSDKConversationEnded(_ conversationID: String?) {
    
  }
  
  /**
   This delegate method is optional.
   It is called when the customer satisfaction survey is dismissed after the user has submitted the survey/
   */
  func LPMessagingSDKConversationCSATDismissedOnSubmittion(_ conversationID: String?) {
    
  }
  
  /**
   This delegate method is optional.
   It is called whenever an event log is received.
   */
  func LPMessagingSDKDidReceiveEventLog(_ eventLog: String) {
    // Log - Event
    print("EventLog :: \(eventLog)")
  }
  
  /**
   This delegate method is optional.
   It is called when the SDK has connections issues.
   */
  func LPMessagingSDKHasConnectionError(_ error: String?) {
    // Log - Event
    print("SDKHasConnectionError :: \(error!)")
  }
  
  /**
   This delegate method is optional.
   It is called each time connection state changed for a brand with a flag whenever connection is ready.
   Ready means that all conversations and messages were synced with the server.
   */
  func LPMessagingSDKConnectionStateChanged(_ isReady: Bool, brandID: String) {
  
  }
  
  /**
   This delegate method is optional.
   It is called when the user tapped on the agent’s avatar in the conversation and also in the navigation bar within window mode.
   */
  func LPMessagingSDKAgentAvatarTapped(_ agent: LPUser?) {
    
  }
  
  /**
   This delegate method is optional.
   It is called when the Conversation CSAT did load
   */
  func LPMessagingSDKConversationCSATDidLoad(_ conversationID: String?) {
    
  }
  
  /**
   This delegate method is optional.
   It is called when the Conversation CSAT skipped by the consumer
   */
  func LPMessagingSDKConversationCSATSkipped(_ conversationID: String?) {
    
  }
  
  /**
   This delegate method is optional.
   It is called when the user is opening photo sharing gallery/camera and the persmissions denied
   */
  func LPMessagingSDKUserDeniedPermission(_ permissionType: LPPermissionTypes) {
    
  }
}
