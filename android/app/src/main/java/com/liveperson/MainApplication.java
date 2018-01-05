package com.liveperson;

/**
 * LivePerson
 *
 * Created by David Villacis on 1/3/18.
 */
// Required Android Imports
import android.app.Application;
// Required React-Native Imports
import com.facebook.react.ReactApplication;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;
import com.facebook.react.shell.MainReactPackage;
import com.facebook.soloader.SoLoader;
import com.liveperson.messaging.MessagingReactPackage;
// Required Java Imports
import java.util.Arrays;
import java.util.List;

public class MainApplication extends Application implements ReactApplication {

  /**
   * Init React-Native Host
   */
  private final ReactNativeHost mReactNativeHost = new ReactNativeHost(this) {

    /**
     * Will return if Debug is Enable
     * @return - Flag for Debug Mode
     */
    @Override
    public boolean getUseDeveloperSupport() {
      return BuildConfig.DEBUG;
    }

    /**
     * Will list available Packages on React-Native Side
     * @return Packages List
     */
    @Override
    protected List<ReactPackage> getPackages() {
      return Arrays.<ReactPackage>asList(
          new MainReactPackage(),
          new MessagingReactPackage()
      );
    }

    /**
     * Will get React Native Module Name
     * @return - Index
     */
    @Override
    protected String getJSMainModuleName() {
      return "index";
    }
  };

  /**
   * Will return React-Native Host
   * @return Host
   */
  @Override
  public ReactNativeHost getReactNativeHost() {
    return mReactNativeHost;
  }

  /**
   * App LifeCycle - OnCreate
   */
  @Override
  public void onCreate() {
    // Super Init
    super.onCreate();
    // Init Loader React-Native
    SoLoader.init(this, /* native exopackage */ false);
  }
}
