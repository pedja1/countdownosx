//
//  CountdownViewController.swift
//  countdownosx
//
//  Created by Apple on 7/12/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Cocoa

class CountdownViewController: NSViewController {

    @IBOutlet weak var startPicker: NSDatePicker!
    @IBOutlet weak var lunchPicker: NSTextField!
    @IBOutlet weak var quit: NSButton!
    @IBOutlet weak var timerLabel: NSTextField!

    weak var delegate: CountdownViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        let calendar = NSCalendar.current
        let date = Date()
        let time = Int(calendar.startOfDay(for: date).timeIntervalSince1970) + UserDefaults.standard.integer(forKey: Consts.PREF_KEY_START)
        startPicker.dateValue = Date(timeIntervalSince1970: TimeInterval(time))

        lunchPicker.stringValue = String(UserDefaults.standard.integer(forKey: Consts.PREF_KEY_LUNCH) / 60)
    }

    @IBAction func onStartTimeChanged(_ sender: Any) {
        print("onStartTimeChanged")

        let calendar = NSCalendar.current
        let seconds = startPicker.dateValue.timeIntervalSince1970 - calendar.startOfDay(for: startPicker.dateValue).timeIntervalSince1970


        let defaults = UserDefaults.standard
        defaults.set(Int(seconds), forKey: Consts.PREF_KEY_START)

        delegate?.onTimesChanged()
    }

    @IBAction func onLunchTimeChanged(_ sender: Any) {
        print("onLunchTimeChanged")

        let defaults = UserDefaults.standard
        defaults.set(Int(lunchPicker.stringValue)! * 60, forKey: Consts.PREF_KEY_LUNCH)

        delegate?.onTimesChanged()
    }

    @IBAction func onQuit(_ sender: Any) {
        delegate?.onQuit()
    }

    func updateTimerText(text: String) {
        timerLabel?.stringValue = text
        timerLabel?.sizeToFit()
    }
}

protocol CountdownViewControllerDelegate: class {
    func onTimesChanged()
    func onQuit()
}

extension CountdownViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> CountdownViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "CountdownViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? CountdownViewController else {
            fatalError("Why cant i find CountdownViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}
