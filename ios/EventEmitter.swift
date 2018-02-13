//
//  Events.swift
//  LivePerson
//
//  Created by David Villacis on 12/19/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation

class EventEmitter {
  
  /// Shared Instance.
  public static var shared = EventEmitter()
  
  // ReactNativeEventEmitter is instantiated by React Native with the bridge.
  private static var eventEmitter: ReactNativeEventEmitter!
  
  private init() {}
  
  // When React Native instantiates the emitter it is registered here.
  func registerEventEmitter(eventEmitter: ReactNativeEventEmitter) {
    EventEmitter.eventEmitter = eventEmitter
  }
  
  
  /// Will Dispatch Event to React-Native with Payload
  ///
  /// - Parameters:
  ///   - name: Event Name
  ///   - body: Event Body
  /// INFO : Different Types can be sent as Body by override the type [String : String ] or creating new method
  func dispatch(name: String, body: [String : String ]) {
    // Dispatch Event with Payload
    EventEmitter.eventEmitter.sendEvent(withName: name, body: body)
  }
  
  /// Will Dispatch Event to React-Native without Payload
  ///
  /// - Parameter name: Event Name
  func dispatch(name : String){
    // Dispatch Event without Payload
    EventEmitter.eventEmitter.sendEvent(withName: name, body: nil)
  }
  
  /// All Events which must be support by React Native.
  lazy var allEvents: [String] = {
    // Event Names
    var allEventNames: [String] = []
    // INFO: Append Event - Agent Details - This is needed when using ViewControllerMode to Change the Agent Name on the Navigation Bar
    allEventNames.append("AgentDetails")
    // INFO: Append Event - Conversation Closed - This is needed when using WindowMode to dismiss View when Conversation is Closed
    allEventNames.append("ConversationClosed")
    // INFO: Append Event - Back Button Pressed - This is needed when using ViewControllerMode to let ConversationController Know that an Back Button was press
    allEventNames.append("BackButtonPressed")
    // Return Supported Events
    return allEventNames
  }()
}
