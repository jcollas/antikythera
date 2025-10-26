//
//  AppDelegate.swift
//  Antikythera
//
//  Created by Matt Ricketson on 2/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#if os(iOS)
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MetalView and MetalViewController handle their own initialization
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // MetalView pauses automatically when app becomes inactive
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // MetalView resumes automatically when app becomes active
    }

    func applicationWillTerminate(_ application: UIApplication) {
    // Saves changes in the application's managed object context before the application terminates.
    }

}

#elseif os(macOS)
import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    var viewController: MetalViewController!

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create window
        let contentRect = NSRect(x: 0, y: 0, width: 800, height: 600)
        window = NSWindow(
            contentRect: contentRect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.title = "Antikythera Mechanism"
        window.isReleasedWhenClosed = false

        // Create view controller
        viewController = MetalViewController()
        window.contentViewController = viewController

        // Show window
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ notification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
#endif
