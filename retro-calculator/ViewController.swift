//
//  ViewController.swift
//  retro-calculator
//
//  Created by Marcus Mitchell on 19/05/2016.
//  Copyright © 2016 Marcus Mitchell. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Add = "+"
        case Subtract = "-"
        case Equals = "="
        case Empty = ""
    }
    
    @IBOutlet weak var lblOutput: UILabel!
    
    var btnSound: AVAudioPlayer!
    var operationSound: AVAudioPlayer!
    var equalsSound: AVAudioPlayer!
    var clearSound: AVAudioPlayer!
    
    var runningNumber = ""
    var leftValString = ""
    var currentOperator: Operation = Operation.Empty
    var rightValString = ""
    var numericExpression = ""
    var result: NSNumber!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let btnSoundPath = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let btnSoundUrl = NSURL(fileURLWithPath: btnSoundPath!)
        do {
            try btnSound = AVAudioPlayer(contentsOfURL: btnSoundUrl)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        let operationSoundPath = NSBundle.mainBundle().pathForResource("operation", ofType: "aiff")
        let operationSoundUrl = NSURL(fileURLWithPath: operationSoundPath!)
        do {
            try operationSound = AVAudioPlayer(contentsOfURL: operationSoundUrl)
            operationSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        let equalsSoundPath = NSBundle.mainBundle().pathForResource("equals", ofType: "wav")
        let equalsSoundUrl = NSURL(fileURLWithPath: equalsSoundPath!)
        do {
            try equalsSound = AVAudioPlayer(contentsOfURL: equalsSoundUrl)
            equalsSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        let clearSoundPath = NSBundle.mainBundle().pathForResource("clear", ofType: "wav")
        let clearSoundUrl = NSURL(fileURLWithPath: clearSoundPath!)
        do {
            try clearSound = AVAudioPlayer(contentsOfURL: clearSoundUrl)
            clearSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onNumberPressed(btn: UIButton) {
        if btnSound.playing { btnSound.stop() }
        btnSound.play()
        
        if lblOutput.text == "0" { runningNumber = "" }
        
        runningNumber += "\(btn.tag)"
        lblOutput.text = runningNumber
    }

    @IBAction func onAdditionPressed(sender: AnyObject) {
        processOperation(Operation.Add)
    }
    
    @IBAction func onSubtractionPressed(sender: AnyObject) {
        processOperation(Operation.Subtract)
    }
    
    @IBAction func onMultiplicationPressed(sender: AnyObject) {
        processOperation(Operation.Multiply)
    }
    
    @IBAction func onDivisionPressed(sender: AnyObject) {
        processOperation(Operation.Divide)
    }
    
    @IBAction func onEqualsPressed(sender: AnyObject) {
        if equalsSound.playing { equalsSound.stop() }
        equalsSound.play()
        processOperation(Operation.Equals)
    }
    
    func processEquals(op: Operation) {
        if currentOperator != Operation.Empty {
            if runningNumber != "" {
                
                leftValString = String(result)
                lblOutput.text = leftValString
            }
        }
    }
    
    func processOperation(op: Operation) {
        playOperationSound()
        
        if currentOperator != Operation.Empty {
            // DO MATH
            if runningNumber != "" {
                
                rightValString = runningNumber
                runningNumber = ""
                
                if currentOperator == Operation.Equals {
                    let numericExpression = "\(Double(leftValString)!) \(op.rawValue) \(Double(rightValString)!)"
                    let expression = NSExpression(format: numericExpression)
                    result = expression.expressionValueWithObject(nil, context: nil) as! NSNumber
                } else {
                    let numericExpression = "\(Double(leftValString)!) \(currentOperator.rawValue) \(Double(rightValString)!)"
                    let expression = NSExpression(format: numericExpression)
                    result = expression.expressionValueWithObject(nil, context: nil) as! NSNumber
                }
                
                leftValString = String(result)
                lblOutput.text = leftValString
            }
        
            currentOperator = op
            
        } else {
            leftValString = runningNumber
            runningNumber = ""
            currentOperator = op
        }
    }
    
    func playOperationSound() {
        if operationSound.playing { operationSound.stop() }
        operationSound.play()
    }
    
    @IBAction func onClearPressed(sender: AnyObject) {
        clearSound.play()
        leftValString = ""
        rightValString = ""
        currentOperator = Operation.Empty
        runningNumber = "0"
        lblOutput.text = runningNumber
    }
    
}

