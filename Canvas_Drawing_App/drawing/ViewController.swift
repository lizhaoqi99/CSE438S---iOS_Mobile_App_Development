//
//  ViewController.swift
//  lab3
//
//  Created by Steve Li on 9/29/19.
//  Copyright © 2019 Steve Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var currentPoint: CGPoint?
    var canvas: MyView!
    var currentWidth: CGFloat = 10
    var currentColor: UIColor = .red
    var isFill: Bool  = false
    var isClear: Bool = false
    var isCanvasColor: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let safeArea = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 105) // make sure the drawing cannot reach the bottom stack view of different pen colors
        whiteSubButton.backgroundColor = UIColor.clear
        orangeSubButton.backgroundColor = UIColor.clear
        yellowSubButton.backgroundColor = UIColor.clear
        greenSubButton.backgroundColor = UIColor.clear
        blueSubButton.backgroundColor = UIColor.clear
        purpleSubButton.backgroundColor = UIColor.clear
        pinkSubButton.backgroundColor = UIColor.clear
        canvas = MyView(frame: safeArea)
        view.addSubview(canvas)
    }
  
    @IBAction func pathWidthSetter(_ sender: UISlider) {
        currentWidth = CGFloat(sender.value)
    }
    
    @IBAction func clearCanvas(_ sender: Any) {
        currentPoint = nil
        canvas.lastCurveCollection = []
        canvas.curveCollection = []
        isClear = true
    }
    
    @IBAction func undoAction(_ sender: Any) {
        if canvas.curveCollection.count > 0 {
            canvas.lastCurveCollection.append(canvas.curveCollection.popLast()!)    // every time when undo is triggered, pop the deleted element into lastCurveCollection array
        }
    }
    
    @IBAction func redoAction(_ sender: Any) {
        if canvas.lastCurveCollection.count > 0 {
            canvas.curveCollection.append(canvas.lastCurveCollection.popLast()!)
        }
            // every time when redo is triggered, pop the last deleted element back into curveCollection array
}
    
    @IBAction func setCanvasColor(_ sender: Any) {
        if isCanvasColor {
            isCanvasColor = false
        } else {
            isCanvasColor = true
            canvas.backgroundColor = currentColor
        }
    }
    
    @IBAction func eraser(_ sender: CirclularButton) {
        clearSubButton(button1: orangeSubButton, button2: yellowSubButton, button3: greenSubButton, button4: blueSubButton, button5: purpleSubButton, button6: pinkSubButton, button7: redSubButton)
        currentColor = UIColor.white
        whiteSubButton.backgroundColor = UIColor.lightGray
        if isCanvasColor {
            canvas.backgroundColor = currentColor
        }
    }
    
    @IBOutlet weak var whiteSubButton: UIButton!
    
    @IBAction func redButton(_ sender: CirclularButton) {
        clearSubButton(button1: orangeSubButton, button2: yellowSubButton, button3: greenSubButton, button4: blueSubButton, button5: purpleSubButton, button6: pinkSubButton, button7: whiteSubButton)
        currentColor = sender.backgroundColor!
        redSubButton.backgroundColor = currentColor
        if isCanvasColor {
            canvas.backgroundColor = currentColor
        }
    }
    
    @IBOutlet weak var redSubButton: UIButton!
    
    @IBAction func orangeButton(_ sender: CirclularButton) {
        clearSubButton(button1: redSubButton, button2: yellowSubButton, button3: greenSubButton, button4: blueSubButton, button5: purpleSubButton, button6: pinkSubButton, button7: whiteSubButton)
        currentColor = sender.backgroundColor!
        orangeSubButton.backgroundColor = currentColor
        if isCanvasColor {
            canvas.backgroundColor = currentColor
        }
    }
    
    @IBOutlet weak var orangeSubButton: UIButton!
    
    @IBAction func yellowButton(_ sender: CirclularButton) {
        clearSubButton(button1: orangeSubButton, button2: redSubButton, button3: greenSubButton, button4: blueSubButton, button5: purpleSubButton, button6: pinkSubButton, button7: whiteSubButton)
        currentColor = sender.backgroundColor!
        yellowSubButton.backgroundColor = currentColor
        if isCanvasColor {
            canvas.backgroundColor = currentColor
        }
    }
    
    @IBOutlet weak var yellowSubButton: UIButton!
    
    @IBAction func greenButton(_ sender: CirclularButton) {
        clearSubButton(button1: orangeSubButton, button2: yellowSubButton, button3: redSubButton, button4: blueSubButton, button5: purpleSubButton, button6: pinkSubButton, button7: whiteSubButton)
        currentColor = sender.backgroundColor!
        greenSubButton.backgroundColor = currentColor
        if isCanvasColor {
            canvas.backgroundColor = currentColor
        }
    }
    
    @IBOutlet weak var greenSubButton: UIButton!
    
    @IBAction func blueButton(_ sender: CirclularButton) {
        clearSubButton(button1: orangeSubButton, button2: yellowSubButton, button3: greenSubButton, button4: redSubButton, button5: purpleSubButton, button6: pinkSubButton, button7: whiteSubButton)
        currentColor = sender.backgroundColor!
        blueSubButton.backgroundColor = currentColor
        if isCanvasColor {
            canvas.backgroundColor = currentColor
        }
    }
    
    @IBOutlet weak var blueSubButton: UIButton!
    
    @IBAction func purpleButton(_ sender: CirclularButton) {
        clearSubButton(button1: orangeSubButton, button2: yellowSubButton, button3: greenSubButton, button4: blueSubButton, button5: redSubButton, button6: pinkSubButton, button7: whiteSubButton)
        currentColor = sender.backgroundColor!
        purpleSubButton.backgroundColor = currentColor
        if isCanvasColor {
            canvas.backgroundColor = currentColor
        }
    }
    
    @IBOutlet weak var purpleSubButton: UIButton!
    
    @IBAction func pinkButton(_ sender: CirclularButton) {
        clearSubButton(button1: orangeSubButton, button2: yellowSubButton, button3: greenSubButton, button4: blueSubButton, button5: purpleSubButton, button6: redSubButton, button7: whiteSubButton)
        currentColor = sender.backgroundColor!
        pinkSubButton.backgroundColor = currentColor
        if isCanvasColor {
            canvas.backgroundColor = currentColor
        }
    }
    
    @IBOutlet weak var pinkSubButton: UIButton!
    
    @IBAction func fillPath(_ sender: Any) {
        if isFill {
            isFill = false
        } else {
        isFill = true
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point: Curve = Curve(points: [CGPoint](), curveWidth: currentWidth, color: currentColor, isFill: isFill)
        canvas.curveCollection.append(point)   // every time add a new set of CGPoints
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: view) else { return }
        guard var lastCurve = canvas.curveCollection.popLast() else{ return }
        lastCurve.points.append(touchPoint)  // add the current point
        canvas.curveCollection.append(lastCurve)
    }
    
    func clearSubButton(button1: UIButton, button2: UIButton, button3: UIButton, button4: UIButton, button5: UIButton, button6: UIButton, button7: UIButton) {
        button1.backgroundColor = UIColor.clear
        button2.backgroundColor = UIColor.clear
        button3.backgroundColor = UIColor.clear
        button4.backgroundColor = UIColor.clear
        button5.backgroundColor = UIColor.clear
        button6.backgroundColor = UIColor.clear
        button7.backgroundColor = UIColor.clear
    }
    
    /*
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: view) else { return }
        
        if let newCircle = currentCirc {
            circCanvas.circles.append(newCircle)
        }
    }
    */
 
}

