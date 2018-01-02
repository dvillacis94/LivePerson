//
//  LivePersonSDK.swift
//  LivePerson
//
//  Created by David Villacis on 12/18/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

import UIKit
// Required LP Imports
import LPMessagingSDK
import LPAMS
import LPInfra

@objc(LivePersonSDK)
/// Class Wrapper for LPMessagingSDK
class LivePersonSDK: NSObject {
  
  // MARK: - Properties
  
  // Singleton
  static let shared = LivePersonSDK()
  /// Account Number / BrandId
  private var account : String?
  /// Conversation Query
  private var conversationQuery : ConversationParamProtocol? {
    // Check if Account Number has been set
    if self.account != nil {
      // Return Query
      return LPMessagingSDK.instance.getConversationBrandQuery(self.account!)
    } else {
      // Return Nil
      return nil
    }
  }
  /// LPMessagingSDKDelegate
  public var delegate : LPMessagingSDKdelegate? {
    get { return LPMessagingSDK.instance.delegate }
    set { LPMessagingSDK.instance.delegate = newValue }
  }
  /// Reference to MessagingViewController
  private var conversationViewController : MessagingViewController?
  
  // MARK: - Initialization
  
  // Avoid Default Init
  override init() {}
  
  /// Will init Singleton with Account Number
  ///
  /// - Parameter brandId: Account Number
  public func initSDK(account brandId: String) {
    // Set BrandId/Account Number
    self.account = brandId
    //
    do {
      // Init LPMessagingSDK
      try LPMessagingSDK.instance.initialize()
    } catch let error as NSError {
      // Print Error
      print("initialize error: \(error)")
      // Escape
      return
    }
  }
  
  // MARK: - LPMessaging Methods
  
  /// Will Show Conversation with a Native ViewController
  public func showConversation(){
    // Check if ConversationQuery has been set
    if self.conversationQuery != nil {
      // Get new ConversationViewParams
      let conversationViewParams = LPConversationViewParams(conversationQuery: self.conversationQuery!, containerViewController: nil, isViewOnly: false)
      // Show Conversation
      LPMessagingSDK.instance.showConversation(conversationViewParams, authenticationParams: nil)
    }
  }
  
  /// Will Show Conversation with a Custom ViewController
  public func showConversation(withView viewController : UIViewController){
    // Check if ConversationQuery has been set
    if self.conversationQuery != nil {
      // Set ConversationViewController Reference
      self.conversationViewController = viewController as? MessagingViewController
      // Get new ConversationViewParams
      let conversationViewParams = LPConversationViewParams(conversationQuery: self.conversationQuery!, containerViewController: self.conversationViewController!, isViewOnly: false)
      // Show Conversation
      LPMessagingSDK.instance.showConversation(conversationViewParams, authenticationParams: nil)
      // Refresh View
      viewController.parent?.view.addSubview(viewController.view)
    }
  }
  
  /// Will Remove Conversation
  ///
  /// - Returns: Value if Conversation was removed
  public func removeConversation() {
    // Check if ConversationQuery has been set
    if self.conversationQuery != nil {
      // Show Conversation
      LPMessagingSDK.instance.removeConversation(self.conversationQuery!)
      //
      // LivePersonSDK.shared.conversationViewController!.removeFromParentViewController()
    }
  }
  
  /// Will resolve Current Conversation
  public func resolveConversation(){
    // Check if ConversationQuery has been set
    if self.conversationQuery != nil {
      // Resolve Conversation
      LPMessagingSDK.instance.resolveConversation(self.conversationQuery!)
    }
  }
  
  /// Will logout Current User from LPMessagingSDK
  public func logout(){
    // Logout SDK
    LPMessagingSDK.instance.logout(completion: {
      // Log - Success
      print("User::logged out")
    }) { (error) in
      // Log - Error
      print("User:: \(error.localizedDescription)")
    }
  }
  
  /// Will reconnect to current Conversation
  public func reconnect(){
    // Check if ConversationQuery has been set
    if self.conversationQuery != nil {
      // Create Nil Params
      let authParams = LPAuthenticationParams()
      // Show Conversation
      LPMessagingSDK.instance.reconnect(self.conversationQuery!, authenticationParams: authParams)
    }
  }
  
  /// Will check if Current Conversation is Mark as Urgent
  ///
  /// - Returns: Urgent/NotUrgent
  public func isUrgent() -> Bool {
    // Return if Conversation is Mark as Urgent
    return LPMessagingSDK.instance.isUrgent(self.conversationQuery!)
  }
  
  /// Will Toggle Urgent State for Current Conversation
  public func toggleUrgentState() {
    // Check if Current Conversation is Urgent
    if self.isUrgent() {
      // Remove Urgent State
      LPMessagingSDK.instance.dismissUrgent(self.conversationQuery!)
    } else {
      // Mark as Urgent
      LPMessagingSDK.instance.markAsUrgent(self.conversationQuery!)
    }
  }
  
  /// Will Init LPMessagingSDK Logger
  public func initLogger(){
    // Logger
    LPMessagingSDK.instance.subscribeLogEvents(LogLevel.trace) { (log) -> () in
      // Logger Trace
      print("LPMessagingSDK log: \(String(describing: log.text))")
    }
  }
  
  // MARK: - Customization
  
  /// Will customize Messaging Screen
  public func customizeMessagingScreen () {
    // Configuration instance
    let configuration = LPConfig.defaultConfiguration
    // Set Agent User Bubble Background Color
    configuration.remoteUserBubbleBackgroundColor = UIColor.tangerine
    // Set Agent User Bubble Border Color
    configuration.remoteUserBubbleBorderColor = UIColor.tangerine
    // Set Agent Avatar Silhouette Color
    configuration.remoteUserAvatarIconColor = UIColor.white
    // Set Agent Avatar Background Color
    configuration.remoteUserAvatarBackgroundColor = UIColor.tangerine
    // Set User Bubble Background Color
    configuration.userBubbleBackgroundColor = UIColor.white
    // Set User Bubble Border Color
    configuration.userBubbleBorderColor = UIColor.white
    // Set User Bubble Border Width
    configuration.userBubbleBorderWidth = 1.5
    // Set User Text Color
    configuration.userBubbleTextColor = UIColor.tangerine
    // Set Scroll to Bottom Button Background Color
    configuration.scrollToBottomButtonBackgroundColor = UIColor.tangerine
    // Enable Photo Sharing
    configuration.enablePhotoSharing = true
    // Show Survey when Resolve Conversation
    configuration.csatShowSurveyView = true
    // Set the Background Color on Photo Sharing Menu
    configuration.photosharingMenuBackgroundColor = UIColor.tangerine
    // Set the text of buttons on Photo Sharing Menu
    configuration.photosharingMenuButtonsTextColor = UIColor.white
    // Set Photo Share Menu Button's Background Color
    configuration.photosharingMenuButtonsBackgroundColor = UIColor.white
    // Set Photo Sharing Menu Buttons Outline Color
    configuration.photosharingMenuButtonsTintColor = UIColor.tangerine
    // Set Send Button Color
    configuration.sendButtonEnabledColor = UIColor.tangerine
    // Set Brand Name
    configuration.brandName = "LivePerson"
    // Set Navigation Bar Background Color for Secure Form
    configuration.secureFormNavigationBackgroundColor = UIColor.tangerine
    // Enable Checkmark instead of Text
    configuration.isReadReceiptTextMode = false
    // Set Check Mark Visibility (SentAndAccepted, SentOnly, All)
    configuration.checkmarkVisibility = CheckmarksState.sentAndAccepted
    // Checkmark Read Color
    configuration.checkmarkReadColor = UIColor.tangerine
    // Set Navigation Bar Background Color for Window Mode On
    configuration.conversationNavigationBackgroundColor = UIColor.tangerine
    // Set Ability to enable/disable Shift Toaster
    configuration.ttrShowShiftBanner = true
    // Costumize Structured Content
    self.customizeStructuredContent(config: configuration)
    // Customize Messaging Survey
    self.customizeSurvey(config: configuration)
    // Print Configurations
    LPConfig.printAllConfigurations()
  }
  
  /// Will customize Structured Content Items
  ///
  /// - Parameter config: LPConfig Instance
  private func customizeStructuredContent(config : LPConfig){
    // Enable Structure Content
    config.enableStrucutredContent = true
    // Set Structure Content Border Color
    config.structuredContentBubbleBorderColor = UIColor.black
  }
  
  /// Will customize Survey Screen
  ///
  /// - Parameter config: LPConfig Instance
  private func customizeSurvey(config: LPConfig) {
    // Set Survey Button Background Color
    config.csatSubmitButtonBackgroundColor = UIColor.tangerine
    // Set Survey Background Color of the Rating Buttons
    config.csatRatingButtonSelectedColor = UIColor.tangerine
    // Set Survey Color for the FCR survey buttons (YES/NO) when selected.
    config.csatResolutionButtonSelectedColor = UIColor.tangerine
    // Set Survey Text Color for all Labels.
    config.csatAllTitlesTextColor = UIColor.tangerine
    // Set Survey Navigation Bar Background Color
    config.csatNavigationBackgroundColor = UIColor.tangerine
    // Should Hide Agent View Hidden
    config.csatAgentViewHidden = false
    // Should Hide CSAT Resolution
    config.csatResolutionHidden = true
  }
  
  /// Will show Conversation Menu
  @objc func menuButtonPressed(){
    DispatchQueue.main.async {
      // Create Alert Controller for Menu
      let menu = UIAlertController(title: "Menu", message: "Choose an Option", preferredStyle: .actionSheet)
      // Create Resolve Action
      let resolve = UIAlertAction(title: "Resolve", style: .default) { (alert : UIAlertAction) in
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
      // Add Action - Resolve
      menu.addAction(resolve)
      // Add Action - Urgent
      menu.addAction(urgent)
      // Add Action - Cancel
      menu.addAction(cancel)
      // Log
      print("ShowingMenu::")
      // Show Menu
      LivePersonSDK.shared.conversationViewController!.present(menu, animated: true, completion: nil)}
  }
  
  
  /// Will get Agent Details when available
  ///
  /// - Parameters:
  ///   - firstName: Name
  ///   - lastName:  Last Name
  ///   - nickName:  Nickname
  ///   - imageURL:  Agent Avatar URL
  @objc func didAgentDetailsChanged(_ firstName : String?, lastName : String?, nickName: String?, imageURL : String? ){
    // Agent Dictionary
    var agent : [String : String] = [:]
    // Add FirstName
    agent["firstName"] = firstName ?? ""
    // Add LastName
    agent["lastName"] = lastName ?? ""
    // Add NickName
    agent["nickName"] = nickName ?? ""
    // Add Image URL
    agent["imageURL"] = imageURL ?? ""
    //
    let notificatioName = Notification.Name(rawValue:"agent")
    //
    NotificationCenter.default.post(name: notificatioName, object: agent)
  }
}

