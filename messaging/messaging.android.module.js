/**
 * This exposes the native ToastExample module as a JS module. This has a
 * function 'show' which takes the following parameters:
 *
 */
import { NativeModules } from 'react-native';

/**
 * Expose Android Class to React-Native
 */
module.exports = NativeModules.MessagingModule;