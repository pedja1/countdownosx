//
//  AppDelegate.swift
//  countdownosx
//
//  Created by Apple on 7/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, CountdownViewControllerDelegate {


    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.variableLength)
    let popover = NSPopover()

    var startSec = 29_700
    var lunchSec = 3600
    let workSec = 27_000
    var total: Int = 0

    var timer: Timer? = nil

    override init() {
        super.init()
        updateTimesFromDefaults()
    }

    private func updateTimesFromDefaults() {
        let defaults = UserDefaults.standard
        let startSecTmp = defaults.integer(forKey: Consts.PREF_KEY_START)
        let lunchSecTmp = defaults.integer(forKey: Consts.PREF_KEY_LUNCH)

        if(startSecTmp > 0) {
            startSec = startSecTmp
        }

        if(lunchSecTmp > 0) {
            lunchSec = lunchSecTmp
        }

        total = startSec + lunchSec + workSec
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.action = #selector(togglePopover(_:))
        }

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTime(_:))), userInfo: nil, repeats: true)

        popover.contentViewController = CountdownViewController.freshController()
        (popover.contentViewController as! CountdownViewController).delegate = self
    }


    func applicationWillTerminate(_ aNotification: Notification) {
        timer?.invalidate()
    }

    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }

    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }

    func closePopover(sender: Any?) {
        popover.performClose(sender)
    }

    @objc func updateTime(_ sender: Any?) {
        let calendar = NSCalendar.current
        let date = Date()
        let secondsFromMidnight = (date.timeIntervalSince1970 - calendar.startOfDay(for: date).timeIntervalSince1970)
        let diff = total - Int(secondsFromMidnight)

        let hours = diff / 3600
        let minutes = (diff % 3600) / 60
        let seconds = diff % 60

        let text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        statusItem.title = text
        (popover.contentViewController as? CountdownViewController)?.updateTimerText(text: text)
    }

    func onQuit() {
        NSApplication.shared.terminate(self)
    }

    func onTimesChanged() {
        updateTimesFromDefaults()
    }
}
