package com.liveperson.helpers;

/**
 * Created by dvillacis on 1/3/18.
 */

// Shared Preferences
import android.content.SharedPreferences;

/**
 * Will manage Shared Preferences
 */
public class LocalStorage {

  // Name Key
  public final String NAME = "Name";
  // Last Name Key
  public final String LAST_NAME = "Last Name";
  // Phone Key
  public final String PHONE = "Phone";

  // Shared Preferences Reference
  private SharedPreferences sharedPreferences;

  public LocalStorage(SharedPreferences sharedPref){
    // Init SharedPreferences
    this.sharedPreferences = sharedPref;
  }

  /**
   * Will Save a Key/Value to Local Storage
   * @param key - Name of the Property
   * @param value - Value of the Property
   */
  public void saveString(String key, String value){
    // Get Editor
    SharedPreferences.Editor editor = this.sharedPreferences.edit();
    // Put String
    editor.putString(key, value);
    // Save Changes
    editor.apply();
  }

  /**
   * Will get a Key/Value from Local Storage
   * @param key - Value to Get
   * @return - Value
   */
  public String getString(String key){
    // Return Value for given Key
    return this.sharedPreferences.getString(key, null);
  }
}
