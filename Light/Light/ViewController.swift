//
//  ViewController.swift
//  Light
//
//  Created by Martin Kostelej on 03/08/2020.
//  Copyright © 2020 Martin Kostelej. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let COLOR_PICKING_VIEW_HEIGHT = 150, TIMER_VIEW_HEIGHT = 220, NOT_ASSIGNED_VALUE = -1, FLOW_MODE_HEIGHT = 270,
            NUMBER_OF_COLORS_FLOW_MODE = 4
    
    var hours = -1
    var minutes = -1
    var seconds = -1
    var changedColorFlowModeIndex = 0
    var flowModeActive = false
    var indexOfColorFlowMode = 0
//    var colorImage:UIImage = UIImage(contentsOfFile: "")
    
    var timerBeforeExit: Timer!
    var timerFlowMode: Timer!
    
    @IBOutlet var colorSlider: UISlider!
    @IBOutlet var brightnessSlider: UISlider!
    @IBOutlet var colorView: UIView!
    @IBOutlet var blackButton: UIButton!
    @IBOutlet var whiteButton: UIButton!
    @IBOutlet var choiceButtons: UISegmentedControl!
    @IBOutlet var colorViewHeight: NSLayoutConstraint!
    @IBOutlet var countDownTimer: UIDatePicker!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var timerLabel: UILabel!
    
    @IBOutlet var colorSliderFlowMode: UISlider!
    @IBOutlet var flowSpeedSlider: UISlider!
    @IBOutlet var flowSpeedLabel: UILabel!
    @IBOutlet var colorLabel: UILabel!
    @IBOutlet var firstColorFMButton: UIButton!
    @IBOutlet var secondColorFMButton: UIButton!
    @IBOutlet var thirdColorFMButton: UIButton!
    @IBOutlet var fourthColorFMButton: UIButton!
    @IBOutlet var firstColorPointerLabel: UILabel!
    @IBOutlet var secondColorPointerLabel: UILabel!
    @IBOutlet var thirdColorPointerLabel: UILabel!
    @IBOutlet var fourthColorPointerLabel: UILabel!
    @IBOutlet var startFlowModeButton: UIButton!
    @IBOutlet var stopFlowModeButton: UIButton!
    
//    var drawingView: DrawView!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        drawingView = DrawView()
//        drawingView.backgroundColor = UIColor.gray
//        self.view.addSubview(drawingView)
//        drawingView.frame = self.view.frame
        
        UIApplication.shared.isIdleTimerDisabled = true
        brightnessSlider.value = Float(UIScreen.main.brightness)
        
        var colorValue = CGFloat(colorSlider.value)
        var color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        self.view.backgroundColor = color
        
        colorSlider.thumbTintColor = color
        blackButton.backgroundColor = UIColor.black
        whiteButton.backgroundColor = UIColor.white
        
        choiceButtons.selectedSegmentIndex = 0
        colorViewHeight.constant = CGFloat(COLOR_PICKING_VIEW_HEIGHT)
        self.view.layoutIfNeeded()
        countDownTimer.isHidden = true
        startButton.isHidden = true
        stopButton.isHidden = true
        timerLabel.isHidden = true
        
        colorSliderFlowMode.isHidden = true
        flowSpeedLabel.isHidden = true
        flowSpeedSlider.isHidden = true
        colorLabel.isHidden = true
        firstColorFMButton.isHidden = true
        secondColorFMButton.isHidden = true
        thirdColorFMButton.isHidden = true
        fourthColorFMButton.isHidden = true
        firstColorPointerLabel.isHidden = true
        secondColorPointerLabel.isHidden = true
        thirdColorPointerLabel.isHidden = true
        fourthColorPointerLabel.isHidden = true
        startFlowModeButton.isHidden = true
        stopFlowModeButton.isHidden = true

        firstColorFMButton.backgroundColor = UIColor.black
        secondColorFMButton.backgroundColor = UIColor.black
        thirdColorFMButton.backgroundColor = UIColor.black
        fourthColorFMButton.backgroundColor = UIColor.black
        firstColorFMButton.layer.cornerRadius = 0.5 * firstColorFMButton.bounds.size.width
        secondColorFMButton.layer.cornerRadius = 0.5 * secondColorFMButton.bounds.size.width
        thirdColorFMButton.layer.cornerRadius = 0.5 * thirdColorFMButton.bounds.size.width
        fourthColorFMButton.layer.cornerRadius = 0.5 * fourthColorFMButton.bounds.size.width
        firstColorFMButton.titleLabel?.text = ""
        secondColorFMButton.titleLabel?.text = ""
        thirdColorFMButton.titleLabel?.text = ""
        fourthColorFMButton.titleLabel?.text = ""
        
//        colorImage = firstColorFMButton.currentImage!
//        firstColorFMButton.setImage(nil, for: .normal)
        
    }
    
    @objc func showTimer(){
        if seconds > 0{
            seconds -= 1
        }else if seconds == 0 && minutes > 0{
            minutes -= 1
            seconds = 59
        }else if seconds == 0 && minutes == 0 && hours > 0{
            hours -= 1
            minutes = 59
            seconds = 59
        }
        if hours == 0 && minutes == 0 && seconds == 0{
            hours = NOT_ASSIGNED_VALUE
            minutes = NOT_ASSIGNED_VALUE
            seconds = NOT_ASSIGNED_VALUE
            timerBeforeExit.invalidate()
            timerLabel.isHidden = true
            if choiceButtons.selectedSegmentIndex == 1 {
                countDownTimer.isHidden = false
            }
            UIApplication.shared.isIdleTimerDisabled = false;
            UIScreen.main.brightness = CGFloat(0.1)
            if flowModeActive == true {
                flowModeActive = false
                timerFlowMode.invalidate()
            }
            exit(-1)
        }else{
            setTimerTextLabel()
        }
    }
    
    func setTimerTextLabel(){
        var helpHours:String = "0"
        var helpMinutes:String = "0"
        var helpSeconds:String = "0"
        
        if hours < 10 {
            helpHours = "0\(hours)"
        }else{
            helpHours = "\(hours)"
        }
        if minutes < 10 {
            helpMinutes = "0\(minutes)"
        }else{
            helpMinutes = "\(minutes)"
        }
        if seconds < 10 {
            helpSeconds = "0\(seconds)"
        }else{
            helpSeconds = "\(seconds)"
        }
        timerLabel.text = "\(helpHours):\(helpMinutes):\(helpSeconds)"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        blackButton.layer.cornerRadius = 0.5 * blackButton.bounds.size.width
        whiteButton.layer.cornerRadius = 0.5 * whiteButton.bounds.size.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //setting status bar
        UIApplication.shared.statusBarStyle = .darkContent
        
        //disable going to sleep
        UIApplication.shared.isIdleTimerDisabled = true;
        
        colorView.backgroundColor = UIColor.lightGray
        if traitCollection.userInterfaceStyle == .light {
//            print("Light mode")
//            colorSlider.thumbTintColor = UIColor.black
            colorSlider.maximumTrackTintColor = UIColor.black
        } else {
//            print("Dark mode")
//            colorSlider.thumbTintColor = UIColor.white
            colorSlider.maximumTrackTintColor = UIColor.white
        }
        //colorSlider.minimumTrackTintColor = UIColor.white
        brightnessSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        brightnessSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))

        colorView.layer.cornerRadius = 15.0
        startButton.layer.cornerRadius = 15.0
        stopButton.layer.cornerRadius = 15.0
        startFlowModeButton.layer.cornerRadius = 15.0
        stopFlowModeButton.layer.cornerRadius = 15.0
        
        hours = NOT_ASSIGNED_VALUE
        minutes = NOT_ASSIGNED_VALUE
        seconds = NOT_ASSIGNED_VALUE
        changedColorFlowModeIndex = 0
    }

    @IBAction func tappedScreeen(_ sender: Any) {
        if colorView.isHidden{
            //colorSlider.isHidden = false
            brightnessSlider.isHidden = false
            colorView.isHidden = false
        }else{
            //colorSlider.isHidden = true
            brightnessSlider.isHidden = true
            colorView.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false;
    }
    @IBAction func brightnessSliderVlaueDidChange(_ sender: Any) {
        UIScreen.main.brightness = CGFloat(brightnessSlider.value)
    }
    
    @IBAction func sliderValueDidChange(_ sender: Any) {
        var colorValue = CGFloat(colorSlider.value)
        var color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        self.view.backgroundColor = color
        colorSlider.thumbTintColor = color
        if flowModeActive == true {
            flowModeActive = false
            timerFlowMode.invalidate()
        }
        //setting status bar
        UIApplication.shared.statusBarStyle = .darkContent
    }
    
    @IBAction func blackButtonPressed(_ sender: Any) {
        self.view.backgroundColor = UIColor.black
        //setting status bar
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @IBAction func whiteButtonPressed(_ sender: Any) {
        UIApplication.shared.statusBarStyle = .darkContent
        //setting status bar
        self.view.backgroundColor = UIColor.white
    }
    
    @IBAction func choiceChanged(_ sender: Any) {
        switch choiceButtons.selectedSegmentIndex {
        case 0:
            colorSlider.isHidden = false
            blackButton.isHidden = false
            whiteButton.isHidden = false
            countDownTimer.isHidden = true
            startButton.isHidden = true
            stopButton.isHidden = true
            timerLabel.isHidden = true
            
            colorSliderFlowMode.isHidden = true
            flowSpeedLabel.isHidden = true
            flowSpeedSlider.isHidden = true
            colorLabel.isHidden = true
            firstColorFMButton.isHidden = true
            secondColorFMButton.isHidden = true
            thirdColorFMButton.isHidden = true
            fourthColorFMButton.isHidden = true
            firstColorPointerLabel.isHidden = true
            secondColorPointerLabel.isHidden = true
            thirdColorPointerLabel.isHidden = true
            fourthColorPointerLabel.isHidden = true
            startFlowModeButton.isHidden = true
            stopFlowModeButton.isHidden = true
            colorViewHeight.constant = CGFloat(COLOR_PICKING_VIEW_HEIGHT)
            self.view.layoutIfNeeded()
            
        case 1:
            colorSlider.isHidden = true
            blackButton.isHidden = true
            whiteButton.isHidden = true
            if seconds != NOT_ASSIGNED_VALUE && minutes != NOT_ASSIGNED_VALUE && seconds != NOT_ASSIGNED_VALUE {
                timerLabel.isHidden = false
            }else{
                countDownTimer.isHidden = false
            }
            startButton.isHidden = false
            stopButton.isHidden = false
            
            colorSliderFlowMode.isHidden = true
            flowSpeedLabel.isHidden = true
            flowSpeedSlider.isHidden = true
            colorLabel.isHidden = true
            firstColorFMButton.isHidden = true
            secondColorFMButton.isHidden = true
            thirdColorFMButton.isHidden = true
            fourthColorFMButton.isHidden = true
            firstColorPointerLabel.isHidden = true
            secondColorPointerLabel.isHidden = true
            thirdColorPointerLabel.isHidden = true
            fourthColorPointerLabel.isHidden = true
            startFlowModeButton.isHidden = true
            stopFlowModeButton.isHidden = true
            colorViewHeight.constant = CGFloat(TIMER_VIEW_HEIGHT)
            self.view.layoutIfNeeded()

        case 2:
            colorSlider.isHidden = true
            blackButton.isHidden = true
            whiteButton.isHidden = true
            countDownTimer.isHidden = true
            startButton.isHidden = true
            stopButton.isHidden = true
            timerLabel.isHidden = true
            
            colorSliderFlowMode.isHidden = false
            flowSpeedLabel.isHidden = false
            flowSpeedSlider.isHidden = false
            colorLabel.isHidden = false
            firstColorFMButton.isHidden = false
            secondColorFMButton.isHidden = false
            thirdColorFMButton.isHidden = false
            fourthColorFMButton.isHidden = false
            startFlowModeButton.isHidden = false
            stopFlowModeButton.isHidden = false
            var colorValue = CGFloat(colorSliderFlowMode.value)
            var color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            colorSliderFlowMode.thumbTintColor = color
            switch changedColorFlowModeIndex {
            case 0:
                firstColorPointerLabel.isHidden = false
                firstColorFMButton.backgroundColor = color
            case 1:
                secondColorPointerLabel.isHidden = false
                secondColorFMButton.backgroundColor = color
            case 2:
                thirdColorPointerLabel.isHidden = false
                thirdColorFMButton.backgroundColor = color
            case 3:
                fourthColorPointerLabel.isHidden = false
                fourthColorFMButton.backgroundColor = color
            default:
                firstColorPointerLabel.isHidden = false
                firstColorFMButton.backgroundColor = color
            }
            
            colorViewHeight.constant = CGFloat(FLOW_MODE_HEIGHT)
            self.view.layoutIfNeeded()

        default:
            print("not available index")
        }
         
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
//        print(Int(countDownTimer.countDownDuration))
        if seconds == NOT_ASSIGNED_VALUE && minutes == NOT_ASSIGNED_VALUE && seconds == NOT_ASSIGNED_VALUE {
            var rest = Int(countDownTimer.countDownDuration)
            hours = Int(rest / 60 / 60)
            minutes = (rest - hours * 60 * 60) / 60
            seconds = (rest - hours * 60 * 60 - minutes * 60)
            
            setTimerTextLabel()
            timerLabel.isHidden = false
            countDownTimer.isHidden = true
            
            timerBeforeExit = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(showTimer), userInfo: nil, repeats: true)
        }
    }
    @IBAction func stopButtonPressed(_ sender: Any) {
        if seconds != NOT_ASSIGNED_VALUE && minutes != NOT_ASSIGNED_VALUE && seconds != NOT_ASSIGNED_VALUE {
            timerBeforeExit.invalidate()
        }
        hours = NOT_ASSIGNED_VALUE
        minutes = NOT_ASSIGNED_VALUE
        seconds = NOT_ASSIGNED_VALUE
        timerLabel.isHidden = true
        countDownTimer.isHidden = false
    }
    
    @IBAction func colorSliderFMValueChanged(_ sender: Any) {
        var colorValue = CGFloat(colorSliderFlowMode.value)
        var color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        
        colorSliderFlowMode.thumbTintColor = color
        
        switch changedColorFlowModeIndex {
        case 0:
            firstColorFMButton.backgroundColor = color
        case 1:
            secondColorFMButton.backgroundColor = color
        case 2:
            thirdColorFMButton.backgroundColor = color
        case 3:
            fourthColorFMButton.backgroundColor = color
        default:
            firstColorFMButton.backgroundColor = color
        }
    }
    
    @IBAction func firstColorButtonPressed(_ sender: Any) {
        colorSliderFlowMode.value = Float(0.5)
        var colorValue = CGFloat(colorSliderFlowMode.value)
        var color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        firstColorFMButton.backgroundColor = color
        colorSliderFlowMode.thumbTintColor = color
        
        changedColorFlowModeIndex = 0
        firstColorPointerLabel.isHidden = false
        secondColorPointerLabel.isHidden = true
        thirdColorPointerLabel.isHidden = true
        fourthColorPointerLabel.isHidden = true
    }
    
    @IBAction func secondColorButtonPressed(_ sender: Any) {
        colorSliderFlowMode.value = Float(0.5)
        var colorValue = CGFloat(colorSliderFlowMode.value)
        var color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        secondColorFMButton.backgroundColor = color
        colorSliderFlowMode.thumbTintColor = color

        changedColorFlowModeIndex = 1
        firstColorPointerLabel.isHidden = true
        secondColorPointerLabel.isHidden = false
        thirdColorPointerLabel.isHidden = true
        fourthColorPointerLabel.isHidden = true
        
    }
    
    @IBAction func thirdColorButtonPressed(_ sender: Any) {
        colorSliderFlowMode.value = Float(0.5)
        var colorValue = CGFloat(colorSliderFlowMode.value)
        var color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        thirdColorFMButton.backgroundColor = color
        colorSliderFlowMode.thumbTintColor = color
        
        changedColorFlowModeIndex = 2
        firstColorPointerLabel.isHidden = true
        secondColorPointerLabel.isHidden = true
        thirdColorPointerLabel.isHidden = false
        fourthColorPointerLabel.isHidden = true
    }
    
    @IBAction func fourthColorButtonPressed(_ sender: Any) {
        colorSliderFlowMode.value = Float(0.5)
        var colorValue = CGFloat(colorSliderFlowMode.value)
        var color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        fourthColorFMButton.backgroundColor = color
        colorSliderFlowMode.thumbTintColor = color

        changedColorFlowModeIndex = 3
        firstColorPointerLabel.isHidden = true
        secondColorPointerLabel.isHidden = true
        thirdColorPointerLabel.isHidden = true
        fourthColorPointerLabel.isHidden = false
    }
    
    @IBAction func startButtonFlowModePressed(_ sender: Any) {
        if flowModeActive == false {
            flowModeActive = true
            
            let speed = (1.1 - flowSpeedSlider.value) * 5
            timerFlowMode = Timer.scheduledTimer(timeInterval: TimeInterval(speed), target: self, selector: #selector(flowingColors), userInfo: nil, repeats: true)
        }
    }
    
    @objc func flowingColors(){
        //timerFlowMode.timeInterval =
        //print(flowSpeedSlider.value)
        indexOfColorFlowMode += 1
        if indexOfColorFlowMode >= NUMBER_OF_COLORS_FLOW_MODE {
            indexOfColorFlowMode = 0
        }
        switch indexOfColorFlowMode {
        case 0:
            self.view.backgroundColor = firstColorFMButton.backgroundColor
        case 1:
            self.view.backgroundColor = secondColorFMButton.backgroundColor
        case 2:
            self.view.backgroundColor = thirdColorFMButton.backgroundColor
        case 3:
            self.view.backgroundColor = fourthColorFMButton.backgroundColor
        default:
            print("invalid index")
        }
    }
    
    @IBAction func stopButtonFlowModePressed(_ sender: Any) {
        if flowModeActive == true {
            flowModeActive = false
            timerFlowMode.invalidate()
        }
    }
    @IBAction func flowSpeedSliderValueChanged(_ sender: Any) {
        //timerFlowMode.timeInterval =
        if flowModeActive == true {
            let speed = (1.1 - flowSpeedSlider.value) * 5
            timerFlowMode.invalidate()
            timerFlowMode = Timer.scheduledTimer(timeInterval: TimeInterval(speed), target: self, selector: #selector(flowingColors), userInfo: nil, repeats: true)
        }
    }
}
