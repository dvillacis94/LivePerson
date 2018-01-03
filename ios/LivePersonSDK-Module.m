//
//  LivePersonSDK-Module.m
//  LivePerson
//
//  Created by David Villacis on 12/19/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

// INFO : This bridge is use when using ViewController Mode to handle Menu Interaction
@interface RCT_EXTERN_MODULE(LivePersonSDK, NSObject)
  RCT_EXTERN_METHOD(menuButtonPressed)
@end

