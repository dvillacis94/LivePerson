//
//  MessagingViewController.swift
//  LivePerson
//
//  Created by David Villacis on 12/18/17.
//  Copyright © 2017 Facebook. All rights reserved.
//
import UIKit
import AVFoundation
import Photos
// Required LP Imports
import LPMessagingSDK
import LPAMS
import LPInfra


class MessagingViewController: UIViewController {
  
  // MARK: - Properties
  
  // Flag to know is CSAT was showing
  private var wasCSATShowing : Bool = false
  
  // Flag to know if SDK is trying to Reconnect
  private var isTryingToReconnect : Bool = false
  
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
    let frame = CGRect(x: 0, y:110, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-110)
    // Create new with Frame
    let view = UIView(frame: frame)
    // Set Background color
    view.backgroundColor = UIColor.lightGray
    // Set View
    self.view = view
  }
  
  /// App LifeCycle - View Did Load
  override func viewDidLoad() {
    // Super Init
    super.viewDidLoad()
    // Add Navigation Bar Customization
    self.initNavigationBar()
    // Will make ConversationController layout properly with NavigationBar
    self.edgesForExtendedLayout = []
    // Init LivePerson Singleton
    LivePersonSDK.shared.initSDK()
    // Init SDK Logger
    LivePersonSDK.shared.initLogger()
    // Set Delegate
    LivePersonSDK.shared.delegate = self
    // Set Window Mode Flags
    LivePersonSDK.shared.isWindowMode = false
    // Customize Messaging Screen
    LivePersonSDK.shared.customizeMessagingScreen()
    // Change Status Bar Style
    UIApplication.shared.statusBarStyle = .lightContent
    // Update Status Bar Appearance
    self.setNeedsStatusBarAppearanceUpdate()
  }
  
  /// App LifeCycle - Memory Warning
  override func didReceiveMemoryWarning() {
    // Super Init
    super.didReceiveMemoryWarning()
  }
  
  /// App LifeCycle - View did Appear
  ///
  /// - Parameter animated: Bool
  override func viewDidAppear(_ animated: Bool) {
    // Super Init
    super.viewDidAppear(animated)
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
    self.showConversation()
    // Super Init
    super.viewWillAppear(animated)
  }
  
  /// App LifeCycle - View will Disappear
  override func viewWillDisappear(_ animated: Bool) {
    // INFO: When using Custom View Controller Mode, Conversation must be remove when leaving the App, if the Conversation View is the current screen
    // Super Init
    super.viewWillDisappear(animated)
    // Check if Conversation ViewController should be remove
    if LivePersonSDK.shared.shouldRemoveViewController {
      // Remove Conversation
      LivePersonSDK.shared.removeConversation()
      // Change Status Bar Style
      UIApplication.shared.statusBarStyle = .default
      // Update Status Bar Appearance
      self.setNeedsStatusBarAppearanceUpdate()
    }
  }
  
  // MARK: - LPMessagingSDK Methods
  
  /// Will Show LPMessagingSDK Conversation
  private func showConversation() {
    // Show Conversation View
    LivePersonSDK.shared.showConversation(withView: self)
  }
  
  /// Will Initialize Navigation Bar Elements
  private func initNavigationBar(){
    // Try to get Navigation Controller Reference
    if let navigation = self.navigationController {
      // Create Back Button
      let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonPressed))
      // Create Menu Button
      let menuButton = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(menuButtonPressed))
      // Set Navigation Bar - Title View
      navigation.navigationBar.topItem?.titleView = self.getAttributedTitle("Messaging")
      // Set Navigation Bar - Right Item
      navigation.navigationBar.topItem?.rightBarButtonItem = menuButton
      // Set Navigation Bar - Left Item
      navigation.navigationBar.topItem?.leftBarButtonItem = backButton
    }
  }
  
  /// Will handle User Pressing Back Button
  @objc func backButtonPressed(){
    // Dismiss View Controller
    self.dismiss(animated: true, completion: nil)
    // Set Remove ViewController Flag
    LivePersonSDK.shared.shouldRemoveViewController = true
    // Dispatch Event with Agent Details
    EventEmitter.shared.dispatch(name: "BackButtonPressed")
  }
  
  /// Will handle User Pressing Menu Button
  @objc func menuButtonPressed(){
    // Create Alert Controller for Menu
    let menu = UIAlertController(title: "Menu", message: "Choose an Option", preferredStyle: .actionSheet)
    // Create Resolve Action
    let resolve = UIAlertAction(title: "Resolve", style: .destructive) { (alert : UIAlertAction) in
      // Resolve Conversation
      LivePersonSDK.shared.resolveConversation()
    }
    // Set Title Depending on Current Conversation State
    let isUrgentTitle = LivePersonSDK.shared.isUrgent() ? "Dissmiss Urgent" : "Mark as Urgent"
    // Create Mark/Dismiss Urgent Action
    let urgent = UIAlertAction(title: isUrgentTitle, style: .default) { (alert : UIAlertAction) in
      // Toggle Urgent State
      LivePersonSDK.shared.toggleUrgentState()
    }
    // Create Cancel - Will Dismiss AlertSheet
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    // Toggle Resolve State Depending on Conversation State
    resolve.isEnabled = LivePersonSDK.shared.isConversationActive
    // Toggle Urgent State Depending on Conversation State
    urgent.isEnabled = LivePersonSDK.shared.isConversationActive
    // Add Action - Resolve
    menu.addAction(resolve)
    // Add Action - Urgent
    menu.addAction(urgent)
    // Add Action - Cancel
    menu.addAction(cancel)
    // Show Menu
    self.present(menu, animated: true, completion: nil)
  }
  
  /// Will create a new UILabel with Attributed String
  ///
  /// - Parameter title: New Title
  /// - Returns: UILabel with new Attributed String
  public func getAttributedTitle(_ title : String ) -> UILabel{
    // Create Label to Hold new Title
    let view = UILabel()
    // Set Title
    var newTitle = title
    // Create Attributes for Title
    let attributes : [ NSAttributedStringKey : Any ] = [
      .foregroundColor : UIColor.white,
      .font : UIFont(name: "ArialMT", size: 16.0)!
    ]
    // Limit to 15 Chars
    if ( title.length > 23 ){
      // Trim Title
      newTitle = title.subString(0, length: 20)
      // Append Ellipsis
      newTitle.append("...")
    }
    // Create new Title String
    let text = NSAttributedString(string: newTitle, attributes: attributes)
    // Set Title
    view.attributedText = text
    // Return new UILabel
    return view
  }
}
extension MessagingViewController : LPMessagingSDKdelegate {
  
  // MARK: - Permissions Handlers
  
  /// Will Ask User for Permission to Access the Camera
  private func requestCameraPermissions(){
    // Request Camera Access
    AVCaptureDevice.requestAccess(for: AVMediaType.video , completionHandler: { ( status ) in
      // Check if Access Allowed
      if status {
        // Log
        print("Access :: Allowed")
      } else {
        // Log
        print("Access :: Denied")
      }
    })
  }
  
  /// Will Ask User for Permission to Access the Photo Library
  private func requestLibraryPermissions(){
    // Request Photo Library Access
    PHPhotoLibrary.requestAuthorization({ ( status ) in
      // Check if Access was Authorized
      if status == PHAuthorizationStatus.authorized {
        // Log
        print("Access :: Allowed")
      } else {
        // Log
        print("Access :: Denied")
      }
    })
  }
  
  //MARK: - Required - LPMessagingSDKDelegate
  
  /// Will be trigger when authentication process fails
  ///
  /// - Parameter error: Error
  func LPMessagingSDKAuthenticationFailed(_ error: NSError) {
    // Log
    print("SDK Authentication Failed  :: \(error.localizedDescription)")
  }
  
  /// Will be trigger when the SDK version you're using is obselete and needs an update.
  ///
  /// - Parameter error: Error
  func LPMessagingSDKObseleteVersion(_ error: NSError) {
    // Log
    print("SDK Obsolete Version :: \(error.localizedDescription)")
  }
  
  /// Will be trigger when the token which used for authentication is expired
  ///
  /// - Parameter brandID: Account ID / Brand Id
  func LPMessagingSDKTokenExpired(_ brandID: String) {
    // Try to Reconnect
    LivePersonSDK.shared.reconnect()
  }
  
  /// Will let you know if there is an error with the sdk and what this error is
  ///
  /// - Parameter error: Error
  func LPMessagingSDKError(_ error: NSError) {
    // Log Error
    print("SDK Error :: \(error.localizedDescription)")
  }
  
  //MARK:- Optionals - LPMessagingSDKDelegate
  
  /// Will be triggerd once all connection retries were failed.
  ///
  /// - Parameter error: Error
  func LPMessagingSDKConnectionRetriesFailed(_ error: NSError) {
    // Log Error
    print("SDK Error :: \(error.localizedDescription)")
  }
  
  /// Will be trigger when an off hours state changes.
  ///
  /// - Parameters:
  ///   - isOffHours: Bool - True if offHour Changed
  ///   - brandID: Brand ID
  func LPMessagingSDKOffHoursStateChanged(_ isOffHours: Bool, brandID: String) {
    // Log if OffHours Changed
    print("OffHours Changed:: \(isOffHours)")
  }
  
  /// Will
  ///
  /// - Parameter error: Error
  func LPMessagingSDKCertPinningFailed(_ error: NSError) {
    // Log Error
    print("SDK Error :: \(error.localizedDescription)")
  }
  
  /// Will be trigger each time the SDK receives info about the agent on the other side.
  /// Example:
  /// You can use this data to show the agent details on your navigation bar (in view controller mode)
  ///
  /// - Parameter agent - (firstName, lastName, nickName, profileImageURL, phoneNumber, employeeID, uid)
  func LPMessagingSDKAgentDetails(_ agent: LPUser?) {
    // Check if Agent Details are Available
    if(agent != nil) {
      // Try to get Navigation Controller Reference
      if let navigation = self.navigationController {
        // INFO: Set Agent Name - This comes from Class Extension
        navigation.setNavigationViewTitle(agent: agent!)
      }
    }
  }
  
  /// Will be trigger each time the agent typing state changes.
  ///
  /// - Parameter isTyping: Bool
  func LPMessagingSDKAgentIsTypingStateChanged(_ isTyping: Bool) {
    // Log
    print("Agent is Typing :: \(isTyping)")
    // Check if Title View with Agent Details has been set
    if self.navigationController?.navigationBar.topItem?.titleView == nil{
      // Get Agent Details
      let agent = LivePersonSDK.shared.getAgentDetails()
      // Check if there is an Agent Assigned to the Conversation
      if agent != nil {
        // Set Agent Title View
        self.navigationController?.setNavigationViewTitle(agent: agent!)
      }
    }
  }
  
  /// Will be trigger whenever an event log is received.
  ///
  /// - Parameter eventLog: Event
  func LPMessagingSDKDidReceiveEventLog(_ eventLog: String) {
    // Log - Event
    print("EventLog:: \(eventLog)")
  }
  
  /// Will be trigger when the SDK has connections issues.
  ///
  /// - Parameter error: Error Description
  func LPMessagingSDKHasConnectionError(_ error: String?) {
    // Log
    print("Connection Error :: \(error!)")
  }
  
  /// Will be trigger when the conversation view controller removed from its container view controller or window.
  func LPMessagingSDKConversationViewControllerDidDismiss() {
    // Log
    print("Conversation :: Dismissed")
  }
  
  /// Will be trigger when a new conversation has started, from the agent or from the consumer side.
  ///
  /// - Parameter conversationID: Conversation ID
  func LPMessagingSDKConversationStarted(_ conversationID: String?) {
    // Log - Event
    print("conversationID:: \(conversationID!)")
  }
  
  /// Will be trigger when a conversation has ended, from the agent or from the consumer side.
  ///
  /// - Parameters:
  ///   - conversationID: Conversation ID
  ///   - closeReason: Who Closed the Conversation ( 0 : agent, 1 : consumer, 2 : system )
  func LPMessagingSDKConversationEnded(_ conversationID: String?, closeReason: LPConversationCloseReason) {
    // Remove Agent Name from ConversationViewController Navigation Title
    self.navigationItem.titleView = self.getAttributedTitle("LivePerson")
    // Print Log
    print("Closed Reason :: \(closeReason.rawValue)")
  }
  
  /// Will be trigger each time connection state changed for a brand with a flag whenever connection is ready.
  /// Ready means that all conversations and messages were synced with the server.
  ///
  /// - Parameters:
  ///   - isReady: Bool
  ///   - brandID: Brand ID
  func LPMessagingSDKConnectionStateChanged(_ isReady: Bool, brandID: String) {
    // Log
    print("Brand is Ready :: \(isReady)")
    // INFO: When presenting ConversationView after showing CSAT, the SDK needs to Reconnect, we do this manually in React-Native
    if !isReady && self.wasCSATShowing && !self.isTryingToReconnect {
      // Reconnect
      LivePersonSDK.shared.reconnect()
      // Change Reconnection Flag
      self.isTryingToReconnect = true
    } else if isReady && self.isTryingToReconnect {
      // Change Reconnection Flag
      self.isTryingToReconnect = false
    }
  }
  
  /// Will be trigger when the user is opening photo sharing gallery/camera and the persmissions denied
  ///
  /// - Parameter permissionType: Permissions (location, contacts, calendars, photos,
  /// bluetooth, microphone, speechRecognition, camera, health, homekit, mediaLibrary, motionAndFitness)
  func LPMessagingSDKUserDeniedPermission(_ permissionType: LPPermissionTypes) {
    // Log Permissions
    print("Permissions :: \(permissionType.description)")
    // Check if Camera Access was Denied
    if permissionType == .camera {
      // Request Camera Access
      self.requestCameraPermissions()
      // Check if Media Library Access was Denied
    } else if permissionType == .mediaLibrary {
      // Request Media Library Access
      self.requestLibraryPermissions()
    }
  }
  
  // MARK: - CSAT Delegates
  
  /// Will be trigger when the Conversation CSAT did load
  ///
  /// - Parameter conversationID: Conversation ID
  func LPMessagingSDKConversationCSATDidLoad(_ conversationID: String?) {
    // Log
    print("Conversation ID :: \(conversationID!)")
    // Change CSAT Flag
    self.wasCSATShowing = true
  }
  
  /// Will be trigger when the Conversation CSAT skipped by the consumers
  ///
  /// - Parameter conversationID: Conversation ID
  func LPMessagingSDKConversationCSATSkipped(_ conversationID: String?) {
    // Log
    print("Conversation ID :: \(conversationID!)")
    // Change CSAT Flag
    self.wasCSATShowing = false
  }
  
  /// Will be trigger when the customer satisfaction survey is dismissed after the user has submitted the survey/
  ///
  /// - Parameter conversationID: Conversation ID
  func LPMessagingSDKConversationCSATDismissedOnSubmittion(_ conversationID: String?) {
    // Log
    print("Conversation ID :: \(conversationID!)")
    // Change CSAT Flag
    self.wasCSATShowing = false
  }
  
  /// Will be trigger after the customer satisfaction page is submitted with a score.
  ///
  /// - Parameters:
  ///   - accountID: Account ID / Brand ID
  ///   - rating: Rating
  func LPMessagingSDKCSATScoreSubmissionDidFinish(_ accountID: String, rating: Int) {
    // Log
    print("CSAT Score :: \(rating)")
  }
}
