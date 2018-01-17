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
  private let account : String = ""
  /// Conversation Query
  private var conversationQuery : ConversationParamProtocol? {
    // Return Query
    return LPMessagingSDK.instance.getConversationBrandQuery(self.account)
  }
  /// LPMessagingSDKDelegate
  public var delegate : LPMessagingSDKdelegate? {
    get { return LPMessagingSDK.instance.delegate }
    set { LPMessagingSDK.instance.delegate = newValue }
  }
  /// Reference to MessagingViewController
  private var conversationViewController : MessagingViewController?
  /// Check if a conversation is currently active
  public var isConversationActive : Bool {
    get { return (self.conversationQuery != nil) ? LPMessagingSDK.instance.checkActiveConversation(self.conversationQuery!) : false }
  }
  
  // MARK: - Initialization
  
  // Avoid Default Init
  override init() {}
  
  /// Will init SDK Instance
  public func initSDK() {
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
  
  /// Will Init LPMessagingSDK Logger
  public func initLogger(){
    // Logger
    LPMessagingSDK.instance.subscribeLogEvents(LogLevel.trace) { (log) -> () in
      // Logger Trace
      print("LPMessagingSDK log: \(String(describing: log.text))")
    }
  }
  
  // MARK: - LPMessaging Methods
  
  /// Will Show Conversation with a Native ViewController
  public func showConversation(){
    // Check if ConversationQuery has been set
    if self.conversationQuery != nil {
      // Create new ConversationViewParams
      let conversationViewParams = LPConversationViewParams(conversationQuery: self.conversationQuery!, containerViewController: nil, isViewOnly: false)
      // Create Authentication Params
      let authenticationParams = LPAuthenticationParams()
      // Show Conversation
      LPMessagingSDK.instance.showConversation(conversationViewParams, authenticationParams: authenticationParams)
    }
  }
  
  /// Will Show Conversation with a Custom ViewController
  public func showConversation(withView viewController : UIViewController){
    // Check if ConversationQuery has been set
    if self.conversationQuery != nil {
      // Set ConversationViewController Reference
      self.conversationViewController = viewController as? MessagingViewController
      // Create new ConversationViewParams
      let conversationViewParams = LPConversationViewParams(conversationQuery: self.conversationQuery!, containerViewController: viewController, isViewOnly: false)
      // Create Authentication Params
      let authenticationParams = LPAuthenticationParams()
      // Show Conversation
      LPMessagingSDK.instance.showConversation(conversationViewParams, authenticationParams: authenticationParams)
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
      // Create Authentication Params
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
    // Enable Checkmark instead of Text
    configuration.isReadReceiptTextMode = false
    // Set Check Mark Visibility (SentAndAccepted, SentOnly, All)
    configuration.checkmarkVisibility = CheckmarksState.sentAndAccepted
    // Checkmark Read Color
    configuration.checkmarkReadColor = UIColor.tangerine
    // Set Ability to enable/disable Shift Toaster
    configuration.ttrShowShiftBanner = true
    
    // INFO: LPMessagingSDK Version 2.7 introduced new Customization Options
    
    // Set Background Color of the Connectivity Status Bar while Connecting
    // configuration.connectionStatusConnectingBackgroundColor = UIColor.lightGray
    // Set Text Color of the Connectivity Status Bar while Connecting
    // configuration.connectionStatusConnectingTextColor = UIColor.white
    // Set Background Color of the Connectivity Status Bar when Connection Fails
    // configuration.connectionStatusFailedToConnectBackgroundColor = UIColor.lightGray
    // Set Text Color of the Connectivity Status Bar when Connection Fails
    // configuration.connectionStatusFailedToConnectTextColor = UIColor.red
    
    // INFO: LPMessagingSDK Version 2.8 introduced new Customization Options
    
    // Set Text Mode to false, in order to use an Image, if true it will always use text, even if an image is set
    // configuration.isSendMessageButtonInTextMode = false
    // Set Send Button Image
    // configuration.sendButtonImage = UIImage(named: "IMAGE_NAME")
    // Set the radius of the scroll to bottom badge corners
    // configuration.scrollToBottomButtonBadgeCornerRadius = 12
    // Set the top left and bottom left radius of the scroll to bottom button
    // configuration.scrollToBottomButtonCornerRadius = 20
    // Set the corner radius of the unread messages cell
    // configuration.unreadMessagesCornersRadius = 8
    
    // INFO: LPMessagingSDK Version 2.8 introduced new Customization from User Bubbles
    
    // Set User Bubble Top Left Corner Radius
    // configuration.userBubbleTopLeftCornerRadius = 8
    // Set User Bubble Top Right Corner Radius
    // configuration.userBubbleTopRightCornerRadius = 8
    // Set User Bubble Bottom Left Corner Radius
    // configuration.userBubbleBottomLeftCornerRadius = 8
    // Set User Bubble Bottom Right Corner Radius
    // configuration.userBubbleBottomRightCornerRadius = 0
    
    // INFO: LPMessagingSDK Version 2.8 introduced new Customization from Agent Bubbles
    
    // Set Agent Bubble Top Left Corner Radius
    // configuration.remoteUserBubbleTopLeftCornerRadius = 8
    // Set Agent Bubble Top Right Corner Radius
    // configuration.remoteUserBubbleTopRightCornerRadius = 8
    // Set Agent Bubble Bottom Left Corner Radius
    // configuration.remoteUserBubbleBottomLeftCornerRadius = 0
    // Set Agent Bubble Bottom Right Corner Radius
    // configuration.remoteUserBubbleBottomRightCornerRadius = 8
    
    // INFO: LPMessagingSDK Version 2.9 introduced new Customization Options
    
    // Set Custom font for Timestamp
    // configuration.customFontNameDateSeparator = "FONT_NAME"
    // Set Date Separator Font Text Style
    // configuration.dateSeparatorFontSize = UIFontTextStyle.footnote
    // Set Date Separator Top Spacing
    // configuration.dateSeparatorTopPadding = 5.0
    // Set Date Separator Bottom Spacing
    // configuration.dateSeparatorBottomPadding = 5.0
    // Set Input TextView Top Border Color - by default is Clear
    // configuration.inputTextViewTopBorderColor = UIColor.lightGray
    // Set Conversation Closed Separator Font Size
    // configuration.conversationSeparatorFontSize = UIFontTextStyle.caption1
    // Set Font Name for Conversation Closed Separator
    // configuration.conversationSeparatorFontName = "FONT_NAME"
    // Set Conversation Closed Separator Top Spacing
    // configuration.conversationSeparatorTopPadding = 2.0
    // Set Conversation Closed separator line spacing (From Label to next Conversation Bottom Padding)
    // configuration.conversationSeparatorBottomPadding = 2.0
    // Set Conversation Separator Bottom Spacing
    // configuration.conversationSeparatorViewBottomPadding = 2.0
    // Set Array of images for creating the custom refresh controller. The controller will loop the images; two or more images are required for the array to take effect.
    // configuration.customRefreshControllerImagesArray = [UIImage(named:"IMAGE 1"), UIImage(named:"IMAGE 2")]
    // Set Custom refresh controller speed animation; defines the full images loop time. A smaller value will create a higher speed animation.
    // configuration.customRefreshControllerAnimationSpeed = 2
    // Set Bubble Timestamp Top Spacing (from Text Bubble to Timestamp)
    // configuration.bubbleTimestampTopPadding = 2.0
    // Set Bubble Timestamp Bottom Spacing (from Timestamp to Next Message Bubble)
    // configuration.bubbleTimestampBottomPadding = 2.0
    
    
    // INFO: LPMessagingSDK Version 2.9 introduced new Customization from Agent Bubbles
    
    // Set Remote User Left Padding (left edge to the avatar)
    // configuration.remoteUserAvatarLeadingPadding = 2.0
    // Set Remote User Right Padding (from the avatar to the bubble)
    // configuration.remoteUserAvatarTrailingPadding = 2.0
    // Set Remote User Bubble Top Spacing (Inner Padding)
    // configuration.bubbleTopPadding = 2.0
    // Set Remote User Bubble Bottom Spacing (Inner Padding)
    // configuration.bubbleBottomPadding = 2.0
    // Set Remote User Bubble Bottom Spacing (Inner Padding from Left Bubble Edge to Text)
    // configuration.bubbleLeadingPadding = 2.0
    // Set Remote User Bubble Bottom Spacing (Inner Padding from Text to Right Bubble Edge)
    // configuration.bubbleTrailingPadding = 2.0
    
    // INFO: Set Navigation Bar Background Color for Window Mode Only
    configuration.conversationNavigationBackgroundColor = UIColor.tangerine
    
    // Costumize Structured Content
    self.customizeStructuredContent(config: configuration)
    // Customize Messaging Survey
    self.customizeSurvey(config: configuration)
    // Customize Secure Forms
    self.customizeSecureForms(config: configuration)
    // Print Configurations
    LPConfig.printAllConfigurations()
  }
  
  /// Will customize Structured Content Items
  ///
  /// - Parameter config: LPConfig Instance
  private func customizeStructuredContent(config : LPConfig){
    // INFO : LPMessagingSDK Version 2.7 introduced the ability to send Structure Content
    
    // Enable Structure Content
    // config.enableStrucutredContent = true
    // Set Structure Content Border Color
    // config.structuredContentBubbleBorderColor = UIColor.black
    // Set Structure Content Bubble Border Width in Pixels
    // config.structuredContentBubbleBorderWidth = 1.5
  }
  
  /// Will customize Secure Forms Items
  ///
  /// - Parameter config: LPConfig Instance
  private func customizeSecureForms(config : LPConfig){
    // Set Navigation Bar Background Color for Secure Form
    config.secureFormNavigationBackgroundColor = UIColor.tangerine
    
    // INFO : LPMessagingSDK Version 2.7 introduced Customize New Elements for Secure Forms
    
    // Set font name to be used when the user is completing the secure form. If not set, the default font is Helvetica
    config.secureFormCustomFontName = "Helvetica"
    // Hiding the secure form logo at the top of the form
    config.secureFormHideLogo = false
    // Set loading indicator color when loading the form before opening.
    config.secureFormBubbleLoadingIndicatorColor = UIColor.lightGray
    // Hiding the secure form logo at the top of the form
    config.secureFormHideLogo = false
    // Set Navigation Back Button Item (X) Color
    config.secureFormBackButtonColor = UIColor.white
    // Set SecureForm "Fill in form" Text Color
    config.secureFormBubbleFillFormButtonTextColor = UIColor.tangerine
    // Set SecureForm Image Outline Color
    config.secureFormBubbleFormImageTintColor = UIColor.tangerine
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
      resolve.isEnabled = self.isConversationActive
      // Toggle Urgent State Depending on Conversation State
      urgent.isEnabled = self.isConversationActive
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
    // Dispatch Event with Agent Details
    EventEmitter.shared.dispatch(name: "AgentDetails", body: agent)
  }
}

