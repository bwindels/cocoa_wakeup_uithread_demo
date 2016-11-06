//
//  ViewController.swift
//  async_event_source
//
//  Created by Bruno Windels on 06/11/16.
//  Copyright © 2016 Bruno Windels. All rights reserved.
//

import Cocoa
import Dispatch;


class ViewController: NSViewController {

    @IBOutlet weak var output: NSTextField!
    @IBOutlet weak var input: NSTextField!
    @IBOutlet weak var animation: NSProgressIndicator!
    
    @IBOutlet weak var button: NSButton!
    
    var source: DispatchSourceUserDataAdd? = nil;
    var max: Int32 = 0;
    var thread: Thread? = nil;
    
    @IBAction func startCountdownPressed(_ sender: AnyObject) {
        source = DispatchSource.makeUserDataAddSource(queue: DispatchQueue.main);
        
        func sourceCallback() {
            let value = output.intValue - 1;
            output.intValue = value;
            if value == 0 {
                cleanup();
            }
        }
        
        source!.setEventHandler(handler: sourceCallback);
        source!.resume();
        max = input.intValue;
        thread = Thread(target: self, selector: #selector(runCountdown), object: nil);
        
        
        animation.startAnimation(self);
        output.intValue = max;
        button.isEnabled = false;
        thread!.start();
    }
    
    func cleanup() {
        thread = nil;
        source!.cancel();
        source = nil;
        max = 0;

        animation.stopAnimation(self);
        button.isEnabled = true;

    }
    
    func runCountdown() {
        var value : Int32 = max;
        while (value > 0) {
            sleep(1);
            source!.add(data: 1);
            value -= 1;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

