//
//  AppDelegate.swift
//  syncany-notifier
//
//  Created by Christian Roth on 30/12/14.
//  Copyright (c) 2014 Christian Roth. All rights reserved.
//

import Cocoa
import CommandLine

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        parseCommandLine()
    }
    
    func parseCommandLine() {
        let cli = CommandLine()
        
        let title = StringOption(shortFlag: "t", longFlag: "title", required: true, helpMessage: "Title of the notification")
        let subtitle = StringOption(shortFlag: "s", longFlag: "subtitle", required: false, helpMessage: "Subtitle of the notification")
        let message = StringOption(shortFlag: "m", longFlag: "message", required: false, helpMessage: "Body of the notification")
        
        cli.addOptions(title, subtitle, message)
        let (success, error) = cli.parse()
        
        if !success {
            println(error!)
            cli.printUsage()
            exit(EX_USAGE)
        }
        
        showNotification(title.value!, message: message.value, folder: nil)
    }
    
    func showNotification(title: NSString, message: NSString? = nil, folder: NSString? = nil) {
        let notification = NSUserNotification()
        var userInfo = Dictionary<String, String>()
        notification.title = title
        
        if message != nil {
            notification.informativeText = message
        }
        
        if folder != nil {
            notification.setValue(true, forKey: "_showsButtons")
            notification.hasActionButton = true
            notification.actionButtonTitle = "Show"
            userInfo["folder"] = folder
        }
        
        //notification.identifier = "syncany-notification"
        notification.userInfo = userInfo
        
        let center = NSUserNotificationCenter.defaultUserNotificationCenter()
        center.delegate = self
        center.scheduleNotification(notification)
    }
    
    func userNotificationCenter(center: NSUserNotificationCenter, didDeliverNotification notification: NSUserNotification) {
        exit(0)
    }
    
    func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        return true
    }
}

