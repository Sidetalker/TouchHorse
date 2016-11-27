//
//  MainViewController.swift
//  TouchHorse
//
//  Created by Kevin Sullivan on 11/27/16.
//  Copyright © 2016 Kevin Sullivan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, TouchViewDelegate {

    @IBOutlet weak var touchView: TouchView! { didSet { touchView.delegate = self } }
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var logTextView: UITextView!
    
    var debugTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
    
    var startTime = Date()
    var touches = [TouchMetadata]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logTextView.text = ""
    }
    
    @IBAction func tappedBegin(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        
        if button.currentTitle == "BEGIN" {
            startTime = Date()
            touches.removeAll()
            button.setTitle("END", for: .normal)
            button.backgroundColor = .red
        } else {
            let currentText = logTextView.text ?? ""
            logTextView.text = "Logged \(touches.count) touches\n\n\(currentText)"
            button.setTitle("BEGIN", for: .normal)
            button.backgroundColor = .green
            
            TouchSet.create(with: touches, named: "Ballah Set", started: startTime)
            .then { touchSet -> Void in
                log.debug("TouchSet created!")
                self.logToScreen(text: "Log saved to Firebase")
            }.catch { error in
                log.error("Error creating TouchSet: \(error.localizedDescription)")
                self.logToScreen(text: "Error saving to Firebase: \(error.localizedDescription)")
            }
        }
    }
    
    func registeredTouch(with metadata: TouchMetadata) {
        let startTime = debugTimeFormatter.string(from: metadata.startTime)
        let duration = Int(Date().timeIntervalSince(metadata.startTime) * 1000)
        let location = metadata.startLocation
        
        logToScreen(text: "start: \(startTime)\nduration: \(duration)ms\nlocation: \(location)\n")
        
        touches.append(TouchMetadata(metadata: metadata, duration: duration))
    }
    
    func logToScreen(text: String) {
        let currentText = logTextView.text ?? ""
        logTextView.text = "\(text)\n\(currentText)"
    }
}

