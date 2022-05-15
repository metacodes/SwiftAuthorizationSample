//
// Created by Felix Liu on 2022/5/15.
//
import Foundation
import Cocoa

class WorkspaceEvents {

    static func registerFrontAppChangeNote() {
        NSLog("starting registerFrontAppChangeNote 7")
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(receiveFrontAppChangeNote(_:)), name: NSWorkspace.didActivateApplicationNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(receiveFrontAppLaunchNote(_:)), name: NSWorkspace.didLaunchApplicationNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(receiveFrontAppTerminateNote(_:)), name: NSWorkspace.didTerminateApplicationNotification, object: nil)
        NSLog("end registerFrontAppChangeNote 7")
    }

    // We add apps when we receive a didActivateApplicationNotification notification, not when we receive an apps launched, because any app will have an apps launched notification.
    // But we are only interested in apps that have windows. We think that since an app can be activated, it must have a window, and subscribing to its window event makes sense and is likely to work, even if it requires multiple retries to subscribe.
    // I'm not very sure if there is an edge case, but so far testing down the line has not revealed it.
    // When we receive the didActivateApplicationNotification notification, NSRunningApplication.isActive=true, even if the app is not the frontmost window anymore.
    // If we go to add the application when we receive the message of apps launched, at this time NSRunningApplication.isActive may be false, and try axUiElement.windows() may also throw an exception.
    // For those background applications, we don't receive notifications of didActivateApplicationNotification until they have their own window. For example, those menu bar applications.
    @objc static func receiveFrontAppChangeNote(_ notification: Notification) {
        NSLog("receiveFrontAppChangeNote")
        if let application = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication {
            NSLog("OS event \(notification.name.rawValue), \(application.bundleIdentifier), \(application.processIdentifier)")
        }
    }

    @objc static func receiveFrontAppLaunchNote(_ notification: Notification) {
        NSLog("receiveFrontAppLaunchNote")
        if let application = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication {
            NSLog("OS event \(notification.name.rawValue), \(application.bundleIdentifier), \(application.processIdentifier)")
        }
    }

    @objc static func receiveFrontAppTerminateNote(_ notification: Notification) {
        NSLog("receiveFrontAppTerminateNote")
        if let application = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication {
            NSLog("OS event \(notification.name.rawValue), \(application.bundleIdentifier), \(application.processIdentifier)")
        }
    }
}
