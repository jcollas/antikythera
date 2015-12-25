//
//  AntikytheraOpenGLPrototypeAppDelegate.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 2/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

import UIKit

func DegreesToRadians (value:Double) -> Double {
    return value * M_PI / 180.0
}

func RadiansToDegrees (value:Double) -> Double {
    return value * 180.0 / M_PI
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    weak var glView: GLView!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        self.glView = window?.rootViewController?.view as! GLView
        
        self.glView.animationInterval = 1.0 / 60.0
        self.glView.startAnimation()

        return true
    }


    func applicationWillResignActive(application: UIApplication) {
        self.glView.animationInterval = 1.0 / 60.0
    }

    func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        self.glView.animationInterval = 1.0 / 60.0
    }

    func applicationWillTerminate(application: UIApplication) {
    // Saves changes in the application's managed object context before the application terminates.
    }

}
