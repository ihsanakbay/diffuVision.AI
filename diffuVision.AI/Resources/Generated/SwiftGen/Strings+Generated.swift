// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum LocaleStrings {
  /// AI Image Generator
  internal static let appDescription = LocaleStrings.tr("Localizable", "appDescription", fallback: "AI Image Generator")
  /// Localizable.strings
  ///   diffuVision.AI
  /// 
  ///   Created by İhsan Akbay on 29.06.2023.
  internal static let appTitle = LocaleStrings.tr("Localizable", "appTitle", fallback: "diffuVision")
  /// Cancel
  internal static let cancel = LocaleStrings.tr("Localizable", "cancel", fallback: "Cancel")
  /// Continue
  internal static let `continue` = LocaleStrings.tr("Localizable", "continue", fallback: "Continue")
  /// You haven't generated an image yet.
  /// Enter your prompt and turn your ideas into images.
  internal static let dashboardTitle = LocaleStrings.tr("Localizable", "dashboardTitle", fallback: "You haven't generated an image yet.\nEnter your prompt and turn your ideas into images.")
  /// Delete your account
  internal static let deleteAccount = LocaleStrings.tr("Localizable", "deleteAccount", fallback: "Delete your account")
  /// Your account will be permanently deleted.
  /// Do you confirm?
  internal static let deleteAccountConfirmationMessage = LocaleStrings.tr("Localizable", "deleteAccountConfirmationMessage", fallback: "Your account will be permanently deleted.\nDo you confirm?")
  /// Your account has been deleted
  internal static let deletedSuccessfully = LocaleStrings.tr("Localizable", "deletedSuccessfully", fallback: "Your account has been deleted")
  /// Done
  internal static let doneButton = LocaleStrings.tr("Localizable", "doneButton", fallback: "Done")
  /// An unexpected error has occurred
  internal static let error = LocaleStrings.tr("Localizable", "error", fallback: "An unexpected error has occurred")
  /// Something went wrong
  internal static let errorTitle = LocaleStrings.tr("Localizable", "errorTitle", fallback: "Something went wrong")
  /// Give us feedback
  internal static let feedback = LocaleStrings.tr("Localizable", "feedback", fallback: "Give us feedback")
  /// Generating image. Please wait.
  internal static let generateImage = LocaleStrings.tr("Localizable", "generateImage", fallback: "Generating image. Please wait.")
  /// Get Started
  internal static let getStarted = LocaleStrings.tr("Localizable", "getStarted", fallback: "Get Started")
  /// An error occurred while saving the image to the library
  internal static let imageSaveError = LocaleStrings.tr("Localizable", "imageSaveError", fallback: "An error occurred while saving the image to the library")
  /// Image saved to library successfully
  internal static let imageSaveSuccess = LocaleStrings.tr("Localizable", "imageSaveSuccess", fallback: "Image saved to library successfully")
  /// Logout
  internal static let logout = LocaleStrings.tr("Localizable", "logout", fallback: "Logout")
  /// Are you sure you want to logout?
  internal static let logoutConfirmationMessage = LocaleStrings.tr("Localizable", "logoutConfirmationMessage", fallback: "Are you sure you want to logout?")
  /// My Subscription
  internal static let mySubscription = LocaleStrings.tr("Localizable", "mySubscription", fallback: "My Subscription")
  /// None
  internal static let `none` = LocaleStrings.tr("Localizable", "none", fallback: "None")
  /// OK
  internal static let ok = LocaleStrings.tr("Localizable", "ok", fallback: "OK")
  /// Transform your creative ideas into stunning images
  internal static let onboardMessage = LocaleStrings.tr("Localizable", "onboardMessage", fallback: "Transform your creative ideas into stunning images")
  /// Privacy Policy & Terms of Use
  internal static let policy = LocaleStrings.tr("Localizable", "policy", fallback: "Privacy Policy & Terms of Use")
  /// Premium
  internal static let premium = LocaleStrings.tr("Localizable", "premium", fallback: "Premium")
  /// Enter your prompt here
  internal static let prompt = LocaleStrings.tr("Localizable", "prompt", fallback: "Enter your prompt here")
  /// Regenerate
  internal static let regenerate = LocaleStrings.tr("Localizable", "regenerate", fallback: "Regenerate")
  /// Restore purchase
  internal static let restore = LocaleStrings.tr("Localizable", "restore", fallback: "Restore purchase")
  /// Save
  internal static let save = LocaleStrings.tr("Localizable", "save", fallback: "Save")
  /// Choose Model
  internal static let selectEngine = LocaleStrings.tr("Localizable", "selectEngine", fallback: "Choose Model")
  /// Choose Size
  internal static let selectSize = LocaleStrings.tr("Localizable", "selectSize", fallback: "Choose Size")
  /// Style
  internal static let selectStyle = LocaleStrings.tr("Localizable", "selectStyle", fallback: "Style")
  /// Share
  internal static let share = LocaleStrings.tr("Localizable", "share", fallback: "Share")
  /// Buy Subscription
  internal static let subscriptions = LocaleStrings.tr("Localizable", "subscriptions", fallback: "Buy Subscription")
  /// You can start using the application by subscribing
  internal static let subscriptionsDescription = LocaleStrings.tr("Localizable", "subscriptionsDescription", fallback: "You can start using the application by subscribing")
  /// Payment will be charged to your AppStore account upon confirmation of purchase. The subscription will automatically renew and be charged 24 hours before the end of the current period unless turned off by the user in the user's account settings. Any unused portion of the trial will be forfeited.
  internal static let subscriptionToC = LocaleStrings.tr("Localizable", "subscriptionToC", fallback: "Payment will be charged to your AppStore account upon confirmation of purchase. The subscription will automatically renew and be charged 24 hours before the end of the current period unless turned off by the user in the user's account settings. Any unused portion of the trial will be forfeited.")
  /// Settings
  internal static let tabSettings = LocaleStrings.tr("Localizable", "tabSettings", fallback: "Settings")
  /// Check your network connection and try again
  internal static let unreachableError = LocaleStrings.tr("Localizable", "unreachableError", fallback: "Check your network connection and try again")
  /// User
  internal static let user = LocaleStrings.tr("Localizable", "user", fallback: "User")
  /// Yes
  internal static let yes = LocaleStrings.tr("Localizable", "yes", fallback: "Yes")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension LocaleStrings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
