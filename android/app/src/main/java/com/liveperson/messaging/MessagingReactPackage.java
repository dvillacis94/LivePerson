package com.liveperson.messaging;

/**
 * Created by dvillacis on 1/4/18.
 */

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class MessagingReactPackage implements ReactPackage {

  /**
   * Will Create ViewManagers for React-Native
   * @param reactContext - ReactContext
   * @return - ViewCollections
   */
  @Override
  public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
    return Collections.emptyList();
  }

  /**
   * Will Create React-Navite Modules
   * @param reactContext - ReactContext
   * @return - List Of Modules
   */
  @Override
  public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
    // Create new List
    List<NativeModule> modules = new ArrayList<>();
    // Add MessagingModule to List
    modules.add(new MessagingModule(reactContext));
    // Return List of Modules
    return modules;
  }
}
