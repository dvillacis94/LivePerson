//
//  ReactNativeEventEmitter.swift
//  LivePerson
//
//  Created by David Villacis on 1/2/18.
//  Copyright © 2018 Facebook. All rights reserved.
//
import Foundation

@objc(ReactNativeEventEmitter)
open class ReactNativeEventEmitter: RCTEventEmitter {
  
  override init() {
    super.init()
    EventEmitter.shared.registerEventEmitter(eventEmitter: self)
  }
  
  /// Base overide for RCTEventEmitter.
  ///
  /// - Returns: all supported events
  @objc open override func supportedEvents() -> [String] {
    return EventEmitter.shared.allEvents
  }
  
}
