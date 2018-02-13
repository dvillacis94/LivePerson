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
  
  /// Singleton
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
  /// Flag to know if ViewController should be Remove, ViewController Should only be remove when BackButton is pressed
  public var shouldRemoveViewController : Bool = false
  /// Will get Device Timezone
  public var timeZone : String {
    get { return TimeZone.current.identifier }
  }
  
  // MARK: - Initialization
  
  /// Avoid Default Init
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
      // Reset RemoveViewController Flag
      shouldRemoveViewController = false
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
  
  /// Will Clear Conversation History
  ///
  /// - Returns: Bool
  public func clearConversation() -> Bool {
    //
    do{
      try LPMessagingSDK.instance.clearHistory(self.conversationQuery!)
      // Return true if conversation was Clear
      return true
    } catch let error as NSError {
      // Print Error
      print("initialize error: \(error.localizedDescription)")
      // Return true if conversation was not Clear
      return false
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
    
    // INFO : Agent Configurations
    
    // Set Agent - Bubble Background Color
    configuration.remoteUserBubbleBackgroundColor = UIColor.tangerine
    // Set Agent - Bubble Border Color
    configuration.remoteUserBubbleBorderColor = UIColor.tangerine
    // Set Agent - Link Color
    // configuration.remoteUserBubbleLinkColor = UIColor.tangerine
    // Set Agent - Default Image
    // configuration.remoteUserDefaultAvatarImage = UIImage(named: "")
    // Set Agent - Text Color
    configuration.remoteUserBubbleTextColor = UIColor.white
    // Set Agent - Avatar Silhouette Color
    configuration.remoteUserAvatarIconColor = UIColor.white
    // Set Agent - Avatar Background Color
    configuration.remoteUserAvatarBackgroundColor = UIColor.tangerine
    // Set Agent - Text Bubble Border Width
    configuration.remoteUserBubbleBorderWidth = 1.0
    // Set Agent - Timestamp Color
    configuration.remoteUserBubbleTimestampColor = UIColor.tangerine
    // Set Agent - User Typing Animation Color
    configuration.remoteUserTypingTintColor = UIColor.white
    // Set Color of the remote user's bubble overlay when user uses a long press gesture on the bubble.
    configuration.remoteUserBubbleLongPressOverlayColor = UIColor.tangerine
    // Set Alpha of the remote user's bubble overlay when user uses a long press gesture on the bubble.
    configuration.remoteUserBubbleLongPressOverlayAlpha = 0.5
    // Set Agent Bubble Top Left Corner Radius
    // configuration.remoteUserBubbleTopLeftCornerRadius = 8
    // Set Agent Bubble Top Right Corner Radius
    // configuration.remoteUserBubbleTopRightCornerRadius = 8
    // Set Agent Bubble Bottom Left Corner Radius
    // configuration.remoteUserBubbleBottomLeftCornerRadius = 0
    // Set Agent Bubble Bottom Right Corner Radius
    // configuration.remoteUserBubbleBottomRightCornerRadius = 8
    // Set Remote User Left Padding (left edge to the avatar)
    // configuration.remoteUserAvatarLeadingPadding = 2.0
    // Set Remote User Right Padding (from the avatar to the bubble)
    // configuration.remoteUserAvatarTrailingPadding = 2.0
    
    // INFO: User Configurations
    
    // Set User - Bubble Background Color
    configuration.userBubbleBackgroundColor = UIColor.white
    // Set User - Text Bubble Border Color
    configuration.userBubbleBorderColor = UIColor.white
    // Set User - Link Color
    configuration.userBubbleLinkColor = UIColor.tangerine
    // Set User - Text Bubble Border Width
    configuration.userBubbleBorderWidth = 1.5
    // Set User Text Color
    configuration.userBubbleTextColor = UIColor.tangerine
    // Set User - Timestamp Color
    configuration.userBubbleTimestampColor = UIColor.tangerine
    // Set User - Sent Status Text Color
    configuration.userBubbleSendStatusTextColor = UIColor.tangerine
    // Set User - Error Text Color (!)
    configuration.userBubbleErrorTextColor = UIColor.red
    // Set User - Error Bubble Border Color
    configuration.userBubbleErrorBorderColor = UIColor.red
    // Set User Bubble Top Left Corner Radius
    // configuration.userBubbleTopLeftCornerRadius = 8
    // Set User Bubble Top Right Corner Radius
    // configuration.userBubbleTopRightCornerRadius = 8
    // Set User Bubble Bottom Left Corner Radius
    // configuration.userBubbleBottomLeftCornerRadius = 8
    // Set User Bubble Bottom Right Corner Radius
    // configuration.userBubbleBottomRightCornerRadius = 0
    // Set Remote User Bubble Top Spacing (Inner Padding)
    // configuration.bubbleTopPadding = 2.0
    // Set Remote User Bubble Bottom Spacing (Inner Padding)
    // configuration.bubbleBottomPadding = 2.0
    // Set Remote User Bubble Bottom Spacing (Inner Padding from Left Bubble Edge to Text)
    // configuration.bubbleLeadingPadding = 2.0
    // Set Remote User Bubble Bottom Spacing (Inner Padding from Text to Right Bubble Edge)
    // configuration.bubbleTrailingPadding = 2.0
    
    // INFO: Link Preview Configurations
    
    // Enable Link Preview
    configuration.enableLinkPreview = true
    // configuration.enableRealTimeLinkPreview = false
    // configuration.useNonOGTagsForLinkPreview = true
    // Set Descrption Text Color for the link preview area inside cell.
    configuration.linkPreviewDescriptionTextColor = UIColor(red:0.29, green:0.51, blue:0.52, alpha:1.0)
    // Set Link Preview Area Border Width
    configuration.linkPreviewBorderWidth = 1.5
    // configuration.linkPreviewBorderColor = UIColor(red:0.29, green:0.51, blue:0.52, alpha:1.0)
    // Set Background Color of the Link Preview Area
    configuration.linkPreviewBackgroundColor = UIColor.white
    // Set Site Name Color for the Link Preview Area
    configuration.linkPreviewSiteNameTextColor = UIColor(red:0.29, green:0.51, blue:0.52, alpha:1.0)
    // Set Title Text Color for the Link Preview Area
    configuration.linkPreviewTitleTextColor = UIColor.tangerine
    // Set URL Real Time Preview - Background Color
    configuration.urlRealTimePreviewBackgroundColor = UIColor.white
    // Set URL Real Time Preview - Border Color
    configuration.urlRealTimePreviewBorderColor = UIColor.tangerine
    // Set URL Real Time Preview - Border Width
    configuration.urlRealTimePreviewBorderWidth = 1.5
    // Set URL Real Time Preview - Title Color
    configuration.urlRealTimePreviewTitleTextColor = UIColor.tangerine
    // Set URL Real Time Preview - Description Text Color
    configuration.urlRealTimePreviewDescriptionTextColor = UIColor.tangerine
    
    // INFO: General Configurations
    
    // Set Send Button Color - Enable
    configuration.sendButtonEnabledColor = UIColor.tangerine
    // Set Send Button Color - Disable
    configuration.sendButtonDisabledColor = UIColor.lightGray
    // Set Unread Messages Divider - Background Color
    configuration.unreadMessagesDividerBackgroundColor = UIColor.white
    // Set Unread Messages Divider - Text Color
    configuration.unreadMessagesDividerTextColor = UIColor.blue
    // When using "getAssignedAgent" method, this option lets you decide whether to get assigned agents from active conversations only, or also from the last closed conversation in case there is no active conversation. If not assigned agent is available this method will return nil.
    configuration.retrieveAssignedAgentFromLastClosedConversation = true
    // If Set true, accessibility announces when agent is typing
    configuration.announceAgentTyping = true
    // Set Text Color for System Messages
    configuration.systemBubbleTextColor = UIColor.tangerine
    // Set Duration of Local Notification - TimeToRespond notification, local notification, etc.
    configuration.notificationShowDurationInSeconds = 1
    // Set Controller Text Color - Initial Welcoming Message
    configuration.controllerBubbleTextColor = UIColor.tangerine.darker()!
    // Should Enable vibration when a new message from a remote user received
    configuration.enableVibrationOnMessageFromRemoteUser = true
    
    // INFO: Brand Configurations
    
    // Set Brand Name
    configuration.brandName = "LivePerson"
    // Set Brand - Image Avatar - Ratio 1:1 (at least 50x50)
    // configuration.brandAvatarImage = UIImage(named: "")
    // Set Conversation Background Color
    configuration.conversationBackgroundColor = UIColor.white
    // Set Custom font for Conversation Feed - This font will affect all Messages, Timestamp and Separators
    // configuration.customFontNameConversationFeed = "FONT_NAME"
    // Set Custom font or all Non-Conversation Feed Controls - Buttons, Alerts, Banners, Menu and External Windows
    // configuration.customFontNameNonConversationFeed = "FONT_NAME"
    // Set Array of images for creating the custom refresh controller. The controller will loop the images; two or more images are required for the array to take effect.
    // configuration.customRefreshControllerImagesArray = [UIImage(named:"IMAGE 1"), UIImage(named:"IMAGE 2")]
    // Set Custom refresh controller speed animation; defines the full images loop time. A smaller value will create a higher speed animation.
    // configuration.customRefreshControllerAnimationSpeed = 2
    // Set Text Mode to false, in order to use an Image, if true it will always use text, even if an image is set
    configuration.isSendMessageButtonInTextMode = false
    // Set Send Button Image
    configuration.sendButtonImage = UIImage(named: "SendButtonIcon")
    // Set Bubble Timestamp Top Spacing (from Text Bubble to Timestamp)
    configuration.bubbleTimestampTopPadding = 2.0
    // Set Bubble Timestamp Bottom Spacing (from Timestamp to Next Message Bubble)
    configuration.bubbleTimestampBottomPadding = 2.0
    
    // INFO: Unread Messages Configurations
    
    // Set Scroll to Bottom Button - Background Color
    configuration.scrollToBottomButtonBackgroundColor = UIColor.tangerine
    // Set Scroll to Bottom Button - Text Color
    configuration.scrollToBottomButtonMessagePreviewTextColor = UIColor.white
    // Set Scroll to Bottom Button - Unread Message Badge Background Color
    configuration.scrollToBottomButtonBadgeBackgroundColor = UIColor.red
    // Set Scroll to Bottom Button - Unread Message Badge Text Color
    configuration.scrollToBottomButtonBadgeTextColor = UIColor.white
    // Set Scroll to Bottom Button - Arrow Color
    configuration.scrollToBottomButtonArrowColor = UIColor.white
    // Should Enable Scroll to Bottom
    configuration.scrollToBottomButtonEnabled = true
    // Should Enable Show Message Preview on Scroll to Bottom Accessory
    configuration.scrollToBottomButtonMessagePreviewEnabled = true
    // If disabled, scroll to bottom button will scroll to bottom although we can have new messages and don't show the badge at all nor "new message preview"
    configuration.unreadMessagesDividerEnabled = true
    // Set the corner radius of the unread messages cell
    // configuration.unreadMessagesCornersRadius = 8
    // Set the top left and bottom left radius of the scroll to bottom button
    // configuration.scrollToBottomButtonCornerRadius = 20
    // Set the radius of the scroll to bottom badge corners
    // configuration.scrollToBottomButtonBadgeCornerRadius = 12
    
    // INFO: Photo Sharing Configurations
    
    // Enable Photo Sharing
    configuration.enablePhotoSharing = true
    // Set Number of Files that will be save on disk, Exceeding files are deleted when the App Closes.
    configuration.maxNumberOfSavedFilesOnDisk = 20
    // Set the Background Color on Photo Sharing Menu
    configuration.photosharingMenuBackgroundColor = UIColor.tangerine
    // Set the text of buttons on Photo Sharing Menu
    configuration.photosharingMenuButtonsTextColor = UIColor.white
    // Set Photo Share Menu Button's Background Color
    configuration.photosharingMenuButtonsBackgroundColor = UIColor.white
    // Set Photo Sharing Menu Buttons Outline Color
    configuration.photosharingMenuButtonsTintColor = UIColor.tangerine
    // Set  Photo Sharing Camera Button Enabled State Color
    configuration.cameraButtonEnabledColor = UIColor.tangerine
    // Set  Photo Sharing Camera Button Disable State Color
    configuration.cameraButtonDisabledColor = UIColor.tangerine.lighter(by: 20)!
    // Set Radial loader fill color
    configuration.fileCellLoaderFillColor = UIColor.tangerine.lighter(by: 20)!
    // Set Radial loader progress color
    configuration.fileCellLoaderRingProgressColor = UIColor.tangerine
    // Set Radial loader progress background color
    configuration.fileCellLoaderRingBackgroundColor = UIColor.white
    
    // INFO: Delivery Notifications Options
    
    // Enable Checkmark instead of Text
    configuration.isReadReceiptTextMode = false
    // Set Check Mark Visibility (SentAndAccepted, SentOnly, All)
    configuration.checkmarkVisibility = CheckmarksState.sentAndAccepted
    // Checkmark Color for Read Messages
    configuration.checkmarkReadColor = UIColor.tangerine
    // Checkmark Color for Distributed Messages
    configuration.checkmarkDistributedColor = UIColor.tangerine.darker(by: 10)!
    // Checkmark Color for Sent Messages
    configuration.checkmarkSentColor = UIColor.tangerine.darker(by: 20)!
    
    // INFO: Time to Response Configurations
    
    // Set Ability to enable/disable Shift Toaster
    configuration.ttrShowShiftBanner = true
    // Set Time to Response - Number of seconds before the first TTR notification appears.
    configuration.ttrFirstTimeDelay = 0.5
    // Set Time to Response - Enable: Displays a time stamp in the TTR notification. Disable: Displays: "An agent will respond shortly".
    configuration.ttrShouldShowTimestamp = true
    // Set Time to Response - Don’t show the TTR more than once in X seconds.
    configuration.ttrShowFrequencyInSeconds = 0
    // Disable/Enable the off-hours Toaster.
    // configuration.showOffHoursBanner = true
    // Set Time to Response - Background Color
    // configuration.ttrBannerBackgroundColor = UIColor.lightGray
    // Set Time to Response - Text Color
    // configuration.ttrBannerTextColor = UIColor.white
    // Set Time to Response - Banner Opacity
    // configuration.ttrBannerOpacityAlpha = 0.8
    // Set Time to Response - TimeZone Name, if not set UTC is used
    // configuration.offHoursTimeZoneName = self.timeZone
    print("Time Zone :: \(timeZone)")
    
    // INFO: Date Separator Configurations
    
    // Set Custom font for Timestamp
    // configuration.customFontNameDateSeparator = "FONT_NAME"
    // Set Date Separator - Title Background Color
    configuration.dateSeparatorTitleBackgroundColor = UIColor.white
    // Set Date Separator - Text Color
    configuration.dateSeparatorTextColor = UIColor.tangerine
    // Set Date Separator - Line Color
    configuration.dateSeparatorLineBackgroundColor = UIColor.tangerine
    // Set Date Separator - Background Color
    configuration.dateSeparatorBackgroundColor = UIColor.white
    // Set Date Separator - Font Text Style
    configuration.dateSeparatorFontSize = UIFontTextStyle.footnote
    // Set Date Separator - Top Spacing
    configuration.dateSeparatorTopPadding = 5.0
    // Set Date Separator - Bottom Spacing
    configuration.dateSeparatorBottomPadding = 5.0
    
    // INFO: User Input View Configurations
    
    // Set User Input TextView - Background Color
    configuration.inputTextViewContainerBackgroundColor = UIColor.white
    // Set User Input TextView - Corner Radius.
    configuration.inputTextViewCornerRadius = 17.0
    // Set the Maximum Height of the Input TextField
    //configuration.inputTextViewMaxHeight = 15.0
    // Set Input TextView Top Border Color - by default is Clear
    configuration.inputTextViewTopBorderColor = UIColor.lightGray
    
    // INFO: Data Masking Configurations
    
    // Enable the Use of Regex to Mask Text -  All Masked Data will Appear as Asterisks, will be saved to Local DB Masked and will be Sent to the Server Unmasked.
    configuration.enableClientOnlyMasking = false
    // Enable Real Time Masking
    configuration.enableRealTimeMasking = false
    // Set Client Regex - Perl's regular expressions
    // configuration.clientOnlyMaskingRegex = ""
    // Set Real Time Regex - As user types - Perl's regular expressions
    configuration.realTimeMaskingRegex = ""
    
    // INFO: Connection Status Bar Configurations
    
    // Set Background Color of the Connectivity Status Bar while Connecting
    configuration.connectionStatusConnectingBackgroundColor = UIColor.lightGray
    // Set Text Color of the Connectivity Status Bar while Connecting
    configuration.connectionStatusConnectingTextColor = UIColor.white
    // Set Background Color of the Connectivity Status Bar when Connection Fails
    configuration.connectionStatusFailedToConnectBackgroundColor = UIColor.lightGray
    // Set Text Color of the Connectivity Status Bar when Connection Fails
    configuration.connectionStatusFailedToConnectTextColor = UIColor.red
    
    // Costumize Structured Content
    self.customizeStructuredContent(config: configuration)
    // Customize Messaging Survey
    self.customizeSurvey(config: configuration)
    // Customize Secure Forms
    self.customizeSecureForms(config: configuration)
    // Customize Window Mode
    self.customizeWindowMode(configuration)
    // Print Configurations
    LPConfig.printAllConfigurations()
  }
  
  /// Will Customize Elements Available only on Window Mode
  ///
  /// - Parameter config: LPConfig
  private func customizeWindowMode(_ config : LPConfig){
    // Set Navigation Bar Background Color
    config.conversationNavigationBackgroundColor = UIColor.tangerine
    // Add Custom Button to Navigation Bar
    config.customButtonImage = UIImage(named: "")
    // Set Conversation Navigation Bar Items Color
    config.conversationNavigationTitleColor = UIColor.white
    // Set Conversation Status Bar Style
    config.conversationStatusBarStyle = .lightContent
  }
  
  /// Will Customize Conversation Elements
  ///
  /// - Parameter config: LPConfig
  private func customizeConversation(_ config : LPConfig){
    // Set Number of conversations that will be show to the User
    config.maxPreviousConversationToPresent = 10
    // Set Deletion Time for Old Conversations (Month Base). Setting 0 will delete all closed conversations.
    config.deleteClosedConversationOlderThanMonths = 13
    // Set Maximum number of minutes to send the message
    config.sendingMessageTimeoutInMinutes = 60
    // Set Conversation separator text and line color
    config.conversationSeparatorTextColor = UIColor.tangerine.darker()!
    // Should show separator text message when conversation resolved from agent or consumer
    config.enableConversationSeparatorTextMessage = true
    // Should show Separator Line
    config.enableConversationSeparatorLine = true
    // Set Conversation Closed Separator Font Size
    config.conversationSeparatorFontSize = UIFontTextStyle.footnote
    // Set Conversation Closed separator line spacing (From Label to next Conversation Bottom Padding)
    config.conversationSeparatorBottomPadding = 7.0
    // Set Font Name for Conversation Closed Separator
    // config.conversationSeparatorFontName = "FONT_NAME"
    // Set Conversation Separator Bottom Spacing
    config.conversationSeparatorViewBottomPadding = 2.0
    // Set Conversation Closed Separator Top Spacing
    config.conversationSeparatorTopPadding = 2.0
  }
  
  /// Will customize Structured Content Items
  ///
  /// - Parameter config: LPConfig Instance
  private func customizeStructuredContent(config : LPConfig){
    // Enable Structure Content
    config.enableStrucutredContent = true
    // Set Structure Content Border Color
    config.structuredContentBubbleBorderColor = UIColor.black
    // Set Structure Content Bubble Border Width in Pixels
    config.structuredContentBubbleBorderWidth = 1.5
    // Used to determine which area of the map to focus on - structuredContentMapLongitudeDeltaSpan needs to be set
    config.structuredContentMapLatitudeDeltaDeltaSpan = 0.01
    // Used to determine which area of the map to focus on - structuredContentMapLatitudeDeltaDeltaSpan needs to be set
    config.structuredContentMapLongitudeDeltaSpan = 0.01
  }
  
  /// Will customize Secure Forms Items
  ///
  /// - Parameter config: LPConfig Instance
  private func customizeSecureForms(config : LPConfig){
    
    // INFO: Secure Form Screen Configurations
    
    // Set Navigation Bar Background Color for Secure Form
    config.secureFormNavigationBackgroundColor = UIColor.tangerine
    // Set Navigation Bar Title Color
    config.secureFormNavigationTitleColor = UIColor.white
    // Set font name to be used when the user is completing the secure form. If not set, the default font is Helvetica
    config.secureFormCustomFontName = "Helvetica"
    // Hiding the secure form logo at the top of the form
    config.secureFormHideLogo = false
    // Set Navigation Back Button Item (X) Color
    config.secureFormBackButtonColor = UIColor.white
    // Set Secure Form Status Bar Style to Light Content
    config.secureFormUIStatusBarStyleLightContent = true
    
    // INFO: Secure Form In-Chat Bubble
    
    // Set Agent - Segure Form Bubble Background Color
    config.secureFormBubbleBackgroundColor = UIColor.white
    // Set Agent - Secure Form Bubble Border Color
    config.secureFormBubbleBorderColor = UIColor.tangerine
    // Set Agent - Secure Form Bubble Border Width
    config.secureFormBubbleBorderWidth = 3.0
    // Set Agent - Secure Form Bubble Title Text Color
    config.secureFormBubbleTitleColor = UIColor.tangerine
    // Set Agent - Secure Form Bubble Description Text Color
    config.secureFormBubbleDescriptionColor = UIColor.tangerine
    // Set Agent - Secure Form Bubble - Fill in Form Button Background Color
    config.secureFormBubbleFillFormButtonBackgroundColor = UIColor.tangerine
    // Set SecureForm Image Outline Color
    config.secureFormBubbleFormImageTintColor = UIColor.red
    // Set SecureForm "Fill in form" Text Color
    config.secureFormBubbleFillFormButtonTextColor = UIColor.white
    // Set loading indicator color when loading the form before opening.
    config.secureFormBubbleLoadingIndicatorColor = UIColor.lightGray
  }
  
  /// Will customize Survey Screen
  ///
  /// - Parameter config: LPConfig Instance
  private func customizeSurvey(config: LPConfig) {
    // Show Survey when Resolve Conversation
    config.csatShowSurveyView = true
    // Should Hide CSAT Resolution
    config.csatResolutionHidden = false
    // Should Hide Agent Avatar and Name from CSAT
    config.csatAgentViewHidden = false
    // Should Hide Thank You screen after tapping Submit button
    config.csatThankYouScreenHidden = true
    // Set Survey - Avatar Background Color
    // config.csatAgentAvatarBackgroundColor = UIColor.tangerine
    // Set Survey - Avatar Color
    // config.csatAgentAvatarIconColor = UIColor.tangerine
    // Set Expiration Time for CSAT in minutes - If Survey exceeded the expiration, it will not be presented to the user
    config.csatSurveyExpirationInMinutes = 7200
    // Set Survey Background Color of the Rating Stars
    config.csatRatingButtonSelectedColor = UIColor.tangerine
    // Set Survey Color for the FCR survey buttons (YES/NO) when selected.
    config.csatResolutionButtonSelectedColor = UIColor.tangerine
    // Set Survey Text Color for all Labels.
    config.csatAllTitlesTextColor = UIColor.tangerine
    // Set Survey Navigation Bar Background Color
    config.csatNavigationBackgroundColor = UIColor.tangerine
    // Set Survey Navigation Bar Title Color
    config.csatNavigationTitleColor = UIColor.white
    // Set Survey Skip Button Color
    config.csatSkipButtonColor = UIColor.white
    // Set Survey Status Bar Style
    config.csatUIStatusBarStyleLightContent = true
    // Set Submit Survey Button - Corner Radius
    config.csatSubmitButtonCornerRadius = 30
    // Set Submit Survey Button - Background Color
    config.csatSubmitButtonBackgroundColor = UIColor.tangerine
    // Set Submit Survey Button - Text Color
    config.csatSubmitButtonTextColor = UIColor.white
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

