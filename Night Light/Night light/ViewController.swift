//
//  ViewController.swift
//  Light
//
//  Created by Martin Kostelej on 03/08/2020.
//  Copyright © 2020 Martin Kostelej. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let COLOR_PICKING_VIEW_HEIGHT = 150, TIMER_VIEW_HEIGHT = 220, FLOW_MODE_HEIGHT = 270
    let NOT_ASSIGNED_VALUE = -1
    let NUMBER_OF_COLORS_FLOW_MODE = 4
    let COLOR_TAB = 0, TIMER_TAB = 1, FLOW_MODE_TAB = 2
    let DEFAULT_COLOR_VALUE:Float = 0.5
    let DEFAULT_TIMER_VALUE = 60
    let FIRST_COLOR_BUTTON_INDEX = 0, SECOND_COLOR_BUTTON_INDEX = 1, THIRD_COLOR_BUTTON_INDEX = 2, FOURTH_COLOR_BUTTON_INDEX = 3
    
    var hours = -1
    var minutes = -1
    var seconds = -1
    var changedColorFlowModeIndex = 0
    var flowModeActive = false
    var indexOfColorFlowMode = 0
    
    var timerBeforeExit: Timer!
    var timerFlowMode: Timer!
    var userData: UserData?
    
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
    
    struct UserData {
        //these are saved to user defaults
        var oneColorLight: Float
        var arrayOfFlowModeColors = [Float]()
        var flowSpeed: Float
        var timerHours: Int
        var timerMinutes: Int
    }
    struct ShutdownTimer {
        var hours: Int
        var minutes: Int
        var seconds: Int
        var timerBeforeExit: Timer!
    }
    struct FlowMode {
        var changedColorFlowModeIndex: Int
        var flowModeActive: Bool
        var indexOfColorFlowMode: Int
        var timerFlowMode: Timer!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //user data
        if userData == nil {
            var flowModeColors = [Float]()
            for _ in 1...4 {
                flowModeColors.append(0.3)
            }
            userData = UserData(oneColorLight: 0.6, arrayOfFlowModeColors: flowModeColors, flowSpeed: 0.6, timerHours: 1, timerMinutes: 30)
        }
        
        //to avoid display turning off
        UIApplication.shared.isIdleTimerDisabled = true
        
        brightnessSlider.value = Float(UIScreen.main.brightness)
        //setting slider value and background color
        if userData != nil {
            colorSlider.value = userData?.oneColorLight ?? DEFAULT_COLOR_VALUE
        }else{
            colorSlider.value = DEFAULT_COLOR_VALUE
        }
        let colorValue = CGFloat(colorSlider.value)
        let color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        self.view.backgroundColor = color
        
        self.view.layoutIfNeeded()
        
        //setting color tab
        choiceButtons.selectedSegmentIndex = COLOR_TAB
        colorViewHeight.constant = CGFloat(COLOR_PICKING_VIEW_HEIGHT)
        colorSlider.thumbTintColor = color
        blackButton.backgroundColor = UIColor.black
        whiteButton.backgroundColor = UIColor.white
        
        //setting timer tab values
        if userData != nil {
            let min = userData?.timerMinutes ?? 1
            let hrs = userData?.timerHours ?? 0
            countDownTimer.countDownDuration = TimeInterval((hrs * 60 + min) * 60)
        }else{
            countDownTimer.countDownDuration = TimeInterval(DEFAULT_TIMER_VALUE)
        }
        
        //hiding timer tab
        countDownTimer.isHidden = true
        startButton.isHidden = true
        stopButton.isHidden = true
        timerLabel.isHidden = true
        
        //hiding flow mode tab
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

        //setting color buttons for flow mode
        if userData != nil {
            var colors = [UIColor]()
            for i in 0...3 {
                colors.append(UIColor(hue: CGFloat(userData?.arrayOfFlowModeColors[i] ?? DEFAULT_COLOR_VALUE), saturation: 1.0, brightness: 1.0, alpha: 1.0))
            }
            firstColorFMButton.backgroundColor = colors[0]
            secondColorFMButton.backgroundColor = colors[1]
            thirdColorFMButton.backgroundColor = colors[2]
            fourthColorFMButton.backgroundColor = colors[3]
        }else{
            let defColor = UIColor(hue: CGFloat(DEFAULT_COLOR_VALUE), saturation: 1.0, brightness: 1.0, alpha: 1.0)
            firstColorFMButton.backgroundColor = defColor
            secondColorFMButton.backgroundColor = defColor
            thirdColorFMButton.backgroundColor = defColor
            fourthColorFMButton.backgroundColor = defColor
        }
        
//        firstColorFMButton.backgroundColor = UIColor.black
//        secondColorFMButton.backgroundColor = UIColor.black
//        thirdColorFMButton.backgroundColor = UIColor.black
//        fourthColorFMButton.backgroundColor = UIColor.black
        firstColorFMButton.layer.cornerRadius = 0.5 * firstColorFMButton.bounds.size.width
        secondColorFMButton.layer.cornerRadius = 0.5 * secondColorFMButton.bounds.size.width
        thirdColorFMButton.layer.cornerRadius = 0.5 * thirdColorFMButton.bounds.size.width
        fourthColorFMButton.layer.cornerRadius = 0.5 * fourthColorFMButton.bounds.size.width
        firstColorFMButton.titleLabel?.text = ""
        secondColorFMButton.titleLabel?.text = ""
        thirdColorFMButton.titleLabel?.text = ""
        fourthColorFMButton.titleLabel?.text = ""
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
        case COLOR_TAB:
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
            
        case TIMER_TAB:
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

        case FLOW_MODE_TAB:
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
            
            if userData != nil {
                colorSliderFlowMode.value = userData?.arrayOfFlowModeColors[changedColorFlowModeIndex] ?? DEFAULT_COLOR_VALUE
            }else{
                colorSliderFlowMode.value = DEFAULT_COLOR_VALUE
            }
            let colorValue = CGFloat(colorSliderFlowMode.value)
            let color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            colorSliderFlowMode.thumbTintColor = color
            
            switch changedColorFlowModeIndex {
            case FIRST_COLOR_BUTTON_INDEX:
                firstColorPointerLabel.isHidden = false
                firstColorFMButton.backgroundColor = color
            case SECOND_COLOR_BUTTON_INDEX:
                secondColorPointerLabel.isHidden = false
                secondColorFMButton.backgroundColor = color
            case THIRD_COLOR_BUTTON_INDEX:
                thirdColorPointerLabel.isHidden = false
                thirdColorFMButton.backgroundColor = color
            case FOURTH_COLOR_BUTTON_INDEX:
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
        let colorValue = CGFloat(colorSliderFlowMode.value)
        let color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        
        colorSliderFlowMode.thumbTintColor = color
        
        if userData != nil {
            if userData?.arrayOfFlowModeColors != nil {
                userData?.arrayOfFlowModeColors[changedColorFlowModeIndex] = colorSliderFlowMode.value
            }
        }
        
        switch changedColorFlowModeIndex {
        case FIRST_COLOR_BUTTON_INDEX:
            firstColorFMButton.backgroundColor = color
        case SECOND_COLOR_BUTTON_INDEX:
            secondColorFMButton.backgroundColor = color
        case THIRD_COLOR_BUTTON_INDEX:
            thirdColorFMButton.backgroundColor = color
        case FOURTH_COLOR_BUTTON_INDEX:
            fourthColorFMButton.backgroundColor = color
        default:
            firstColorFMButton.backgroundColor = color
        }
    }
    
    @IBAction func firstColorButtonPressed(_ sender: Any) {
        if userData != nil {
            colorSliderFlowMode.value = userData?.arrayOfFlowModeColors[FIRST_COLOR_BUTTON_INDEX] ?? DEFAULT_COLOR_VALUE
        }else{
            colorSliderFlowMode.value = DEFAULT_COLOR_VALUE
        }
//        colorSliderFlowMode.value = Float(0.5)
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
        if userData != nil {
            colorSliderFlowMode.value = userData?.arrayOfFlowModeColors[SECOND_COLOR_BUTTON_INDEX] ?? DEFAULT_COLOR_VALUE
        }else{
            colorSliderFlowMode.value = DEFAULT_COLOR_VALUE
        }
//        colorSliderFlowMode.value = Float(0.5)
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
        if userData != nil {
            colorSliderFlowMode.value = userData?.arrayOfFlowModeColors[THIRD_COLOR_BUTTON_INDEX] ?? DEFAULT_COLOR_VALUE
        }else{
            colorSliderFlowMode.value = DEFAULT_COLOR_VALUE
        }
//        colorSliderFlowMode.value = Float(0.5)
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
        if userData != nil {
            colorSliderFlowMode.value = userData?.arrayOfFlowModeColors[FOURTH_COLOR_BUTTON_INDEX] ?? DEFAULT_COLOR_VALUE
        }else{
            colorSliderFlowMode.value = DEFAULT_COLOR_VALUE
        }
//        colorSliderFlowMode.value = Float(0.5)
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
            indexOfColorFlowMode = 4
            flowingColors()
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
        case FIRST_COLOR_BUTTON_INDEX:
            self.view.backgroundColor = firstColorFMButton.backgroundColor
        case SECOND_COLOR_BUTTON_INDEX:
            self.view.backgroundColor = secondColorFMButton.backgroundColor
        case THIRD_COLOR_BUTTON_INDEX:
            self.view.backgroundColor = thirdColorFMButton.backgroundColor
        case FOURTH_COLOR_BUTTON_INDEX:
            self.view.backgroundColor = fourthColorFMButton.backgroundColor
        default:
            print("invalid index")
        }
    }
    
    @IBAction func stopButtonFlowModePressed(_ sender: Any) {
        if flowModeActive == true {
            flowModeActive = false
            timerFlowMode.invalidate()
            let colorValue = CGFloat(colorSlider.value)
            let color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            self.view.backgroundColor = color
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

