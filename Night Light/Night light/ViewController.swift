//
//  ViewController.swift
//  Light
//
//  Created by Martin Kostelej on 03/08/2020.
//  Copyright © 2020 Martin Kostelej. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIColorPickerViewControllerDelegate {
    let COLOR_PICKING_VIEW_HEIGHT = 150, TIMER_VIEW_HEIGHT = 180, FLOW_MODE_HEIGHT = 270
    let NOT_ASSIGNED_VALUE = -1
    let NUMBER_OF_COLORS_FLOW_MODE = 4
    let COLOR_TAB = 0, TIMER_TAB = 1, FLOW_MODE_TAB = 2
    let DEFAULT_COLOR_VALUE:Float = 0.5
    let DEFAULT_TIMER_VALUE = 60
    let FIRST_COLOR_BUTTON_INDEX = 0, SECOND_COLOR_BUTTON_INDEX = 1, THIRD_COLOR_BUTTON_INDEX = 2, FOURTH_COLOR_BUTTON_INDEX = 3
    
    var userData: UserData?
    var shutdownTimer: ShutdownTimer?
    var flowMode: FlowMode?
    
    @IBOutlet var colorSlider: UISlider!
    @IBOutlet var brightnessSlider: UISlider!
    @IBOutlet var colorView: UIView!
    @IBOutlet var blackButton: UIButton!
    @IBOutlet var whiteButton: UIButton!
    @IBOutlet var choiceButtons: UISegmentedControl!
    @IBOutlet var colorViewHeight: NSLayoutConstraint!
    @IBOutlet var countDownTimer: UIDatePicker!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet weak var timerView: UIView!
    
    @IBOutlet var colorSliderFlowMode: UISlider!
    @IBOutlet var flowSpeedSlider: UISlider!
    @IBOutlet var flowSpeedLabel: UILabel!
    @IBOutlet var colorLabel: UILabel!
    @IBOutlet var firstColorFMButton: UIButton!
    @IBOutlet var secondColorFMButton: UIButton!
    @IBOutlet var thirdColorFMButton: UIButton!
    @IBOutlet var fourthColorFMButton: UIButton!
    @IBOutlet weak var firstColorPointer: UIImageView!
    @IBOutlet weak var secondColorPointer: UIImageView!
    @IBOutlet weak var thirdColorPointer: UIImageView!
    @IBOutlet weak var fourthColorPointer: UIImageView!
    @IBOutlet var startFlowModeButton: UIButton!
    
    @IBOutlet weak var changeColorTest: UIButton!
    private var colorPicker = UIColorPickerViewController()
    private var c = UIColor.black
    
    struct UserData {
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
        var timerBeforeExit: Timer?
    }
    struct FlowMode {
        var changedColorIndex: Int
        var active: Bool
        var indexOfColor: Int
        var timer: Timer?
        var enteredTimes: Int
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorPicker.delegate = self

        //user data
        if userData == nil {
            var flowModeColors = [Float]()
            for _ in 1...4 {
                flowModeColors.append(0.3)
            }
            userData = UserData(oneColorLight: 0.6, arrayOfFlowModeColors: flowModeColors, flowSpeed: 0.6, timerHours: 1, timerMinutes: 30)
        }
        
        //timer
        if shutdownTimer == nil {
            shutdownTimer = ShutdownTimer(hours: NOT_ASSIGNED_VALUE, minutes: NOT_ASSIGNED_VALUE, seconds: NOT_ASSIGNED_VALUE, timerBeforeExit: nil)
        }
        
        //Flow mode
        if flowMode == nil{
            flowMode = FlowMode(changedColorIndex: 0, active: false, indexOfColor: 0, timer: nil, enteredTimes: 0)
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
        changeColorTest.backgroundColor = UIColor.systemRed
        
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
        timerView.isHidden = true
        
        //hiding flow mode tab
        colorSliderFlowMode.isHidden = true
        flowSpeedLabel.isHidden = true
        flowSpeedSlider.isHidden = true
        colorLabel.isHidden = true
        firstColorFMButton.isHidden = true
        secondColorFMButton.isHidden = true
        thirdColorFMButton.isHidden = true
        fourthColorFMButton.isHidden = true
        firstColorPointer.isHidden = true
        secondColorPointer.isHidden = true
        thirdColorPointer.isHidden = true
        fourthColorPointer.isHidden = true
        startFlowModeButton.isHidden = true
        firstColorPointer.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi))
        secondColorPointer.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi))
        thirdColorPointer.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi))
        fourthColorPointer.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi))


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
        firstColorFMButton.layer.cornerRadius = 0.5 * firstColorFMButton.bounds.size.width
        secondColorFMButton.layer.cornerRadius = 0.5 * secondColorFMButton.bounds.size.width
        thirdColorFMButton.layer.cornerRadius = 0.5 * thirdColorFMButton.bounds.size.width
        fourthColorFMButton.layer.cornerRadius = 0.5 * fourthColorFMButton.bounds.size.width
//        firstColorFMButton.titleLabel?.text = ""
//        secondColorFMButton.titleLabel?.text = ""
//        thirdColorFMButton.titleLabel?.text = ""
//        fourthColorFMButton.titleLabel?.text = ""
        
        brightnessSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Float.pi/2))

        colorView.layer.cornerRadius = 15.0
        startButton.layer.cornerRadius = 15.0
        startFlowModeButton.layer.cornerRadius = 15.0
    }
    @IBAction func changeColorActionTest(_ sender: Any) {
        colorPicker.supportsAlpha = true
        colorPicker.selectedColor = c
        present(colorPicker, animated: true)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        //actions when Im closing picker
        UIApplication.shared.statusBarStyle = .darkContent
    }
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        c = viewController.selectedColor
        self.view.backgroundColor = c
    }
    
    func setTimerTextLabel(){
        var helpHours:String = "0"
        var helpMinutes:String = "0"
        var helpSeconds:String = "0"
        if shutdownTimer != nil {
            if shutdownTimer!.hours < 10 {
                helpHours = "0\(shutdownTimer!.hours)"
            }else{
                helpHours = "\(shutdownTimer!.hours)"
            }
            if shutdownTimer!.minutes < 10 {
                helpMinutes = "0\(shutdownTimer!.minutes)"
            }else{
                helpMinutes = "\(shutdownTimer!.minutes)"
            }
            if shutdownTimer!.seconds < 10 {
                helpSeconds = "0\(shutdownTimer!.seconds)"
            }else{
                helpSeconds = "\(shutdownTimer!.seconds)"
            }
            timerLabel.text = "\(helpHours):\(helpMinutes):\(helpSeconds)"
        }else{
            timerLabel.text = "Not available"
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        blackButton.layer.cornerRadius = 0.5 * blackButton.bounds.size.width
        whiteButton.layer.cornerRadius = 0.5 * whiteButton.bounds.size.width
        changeColorTest.layer.cornerRadius = 0.5 * changeColorTest.bounds.size.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //setting status bar
        UIApplication.shared.statusBarStyle = .darkContent
        
        //disable going to sleep
        UIApplication.shared.isIdleTimerDisabled = true;
        
        colorView.backgroundColor = UIColor.lightGray
        if traitCollection.userInterfaceStyle == .light {
            colorSlider.maximumTrackTintColor = UIColor.black
        } else {
            colorSlider.maximumTrackTintColor = UIColor.white
        }
    }

    @IBAction func tappedScreeen(_ sender: Any) {
        if colorView.isHidden{
            brightnessSlider.isHidden = false
            colorView.isHidden = false
        }else{
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
        let colorValue = CGFloat(colorSlider.value)
        let color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        self.view.backgroundColor = color
        colorSlider.thumbTintColor = color
        if flowMode != nil {
            if flowMode!.active == true {
                flowMode!.active = false
                flowMode!.timer?.invalidate()
            }
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
            changeColorTest.isHidden = false
            countDownTimer.isHidden = true
            startButton.isHidden = true
            timerView.isHidden = true
            
            colorSliderFlowMode.isHidden = true
            flowSpeedLabel.isHidden = true
            flowSpeedSlider.isHidden = true
            colorLabel.isHidden = true
            firstColorFMButton.isHidden = true
            secondColorFMButton.isHidden = true
            thirdColorFMButton.isHidden = true
            fourthColorFMButton.isHidden = true
            firstColorPointer.isHidden = true
            secondColorPointer.isHidden = true
            thirdColorPointer.isHidden = true
            fourthColorPointer.isHidden = true
            startFlowModeButton.isHidden = true
            colorViewHeight.constant = CGFloat(COLOR_PICKING_VIEW_HEIGHT)
            self.view.layoutIfNeeded()
            
        case TIMER_TAB:
            changeColorTest.isHidden = true
            colorSlider.isHidden = true
            blackButton.isHidden = true
            whiteButton.isHidden = true
            if shutdownTimer != nil {
                if shutdownTimer!.seconds != NOT_ASSIGNED_VALUE && shutdownTimer!.minutes != NOT_ASSIGNED_VALUE && shutdownTimer!.hours != NOT_ASSIGNED_VALUE {
                    timerView.isHidden = false
                }else{
                    countDownTimer.isHidden = false
                }
            }
            
            startButton.isHidden = false
            
            colorSliderFlowMode.isHidden = true
            flowSpeedLabel.isHidden = true
            flowSpeedSlider.isHidden = true
            colorLabel.isHidden = true
            firstColorFMButton.isHidden = true
            secondColorFMButton.isHidden = true
            thirdColorFMButton.isHidden = true
            fourthColorFMButton.isHidden = true
            firstColorPointer.isHidden = true
            secondColorPointer.isHidden = true
            thirdColorPointer.isHidden = true
            fourthColorPointer.isHidden = true
            startFlowModeButton.isHidden = true
            colorViewHeight.constant = CGFloat(TIMER_VIEW_HEIGHT)
            self.view.layoutIfNeeded()

        case FLOW_MODE_TAB:
            changeColorTest.isHidden = true
            colorSlider.isHidden = true
            blackButton.isHidden = true
            whiteButton.isHidden = true
            countDownTimer.isHidden = true
            startButton.isHidden = true
            timerView.isHidden = true
            
            colorSliderFlowMode.isHidden = false
            flowSpeedLabel.isHidden = false
            flowSpeedSlider.isHidden = false
            colorLabel.isHidden = false
            firstColorFMButton.isHidden = false
            secondColorFMButton.isHidden = false
            thirdColorFMButton.isHidden = false
            fourthColorFMButton.isHidden = false
            startFlowModeButton.isHidden = false
            
            if userData != nil && flowMode != nil {
                colorSliderFlowMode.value = userData?.arrayOfFlowModeColors[flowMode!.changedColorIndex] ?? DEFAULT_COLOR_VALUE
            }else{
                colorSliderFlowMode.value = DEFAULT_COLOR_VALUE
            }
            let colorValue = CGFloat(colorSliderFlowMode.value)
            let color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            colorSliderFlowMode.thumbTintColor = color
            
            if flowMode != nil {
                switch flowMode!.changedColorIndex {
                case FIRST_COLOR_BUTTON_INDEX:
                    firstColorPointer.isHidden = false
                    firstColorFMButton.backgroundColor = color
                case SECOND_COLOR_BUTTON_INDEX:
                    secondColorPointer.isHidden = false
                    secondColorFMButton.backgroundColor = color
                case THIRD_COLOR_BUTTON_INDEX:
                    thirdColorPointer.isHidden = false
                    thirdColorFMButton.backgroundColor = color
                case FOURTH_COLOR_BUTTON_INDEX:
                    fourthColorPointer.isHidden = false
                    fourthColorFMButton.backgroundColor = color
                default:
                    firstColorPointer.isHidden = false
                    firstColorFMButton.backgroundColor = color
                }
            }else{
                firstColorPointer.isHidden = false
                firstColorFMButton.backgroundColor = color
            }
            
            colorViewHeight.constant = CGFloat(FLOW_MODE_HEIGHT)
            self.view.layoutIfNeeded()

        default:
            print("not available index")
        }
         
    }
    
    @objc func showTimer(){
        if shutdownTimer != nil {
            if shutdownTimer!.seconds > 0{
                shutdownTimer!.seconds -= 1
            }else if shutdownTimer!.seconds == 0 && shutdownTimer!.minutes > 0{
                shutdownTimer!.minutes -= 1
                shutdownTimer!.seconds = 59
            }else if shutdownTimer!.seconds == 0 && shutdownTimer!.minutes == 0 && shutdownTimer!.hours > 0{
                shutdownTimer!.hours -= 1
                shutdownTimer!.minutes = 59
                shutdownTimer!.seconds = 59
            }
            if shutdownTimer!.hours == 0 && shutdownTimer!.minutes == 0 && shutdownTimer!.seconds == 0{
                shutdownTimer!.hours = NOT_ASSIGNED_VALUE
                shutdownTimer!.minutes = NOT_ASSIGNED_VALUE
                shutdownTimer!.seconds = NOT_ASSIGNED_VALUE
                shutdownTimer!.timerBeforeExit?.invalidate()
                timerView.isHidden = true
                if choiceButtons.selectedSegmentIndex == 1 {
                    countDownTimer.isHidden = false
                }
                UIApplication.shared.isIdleTimerDisabled = false;
                UIScreen.main.brightness = CGFloat(0.1)
                if flowMode != nil {
                    if flowMode!.active == true {
                        flowMode!.active = false
                        flowMode!.timer?.invalidate()
                    }
                }
                exit(-1)
            }else{
                setTimerTextLabel()
            }
        }
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        if shutdownTimer != nil {
            if shutdownTimer!.seconds == NOT_ASSIGNED_VALUE && shutdownTimer!.minutes == NOT_ASSIGNED_VALUE && shutdownTimer!.hours == NOT_ASSIGNED_VALUE {
                startButton.setImage(UIImage(systemName: "stop.fill"), for: UIControl.State.normal)
                startButton.tintColor = .systemRed
                let rest = Int(countDownTimer.countDownDuration)
                shutdownTimer!.hours = Int(rest / 60 / 60)
                shutdownTimer!.minutes = (rest - shutdownTimer!.hours * 60 * 60) / 60
                shutdownTimer!.seconds = (rest - shutdownTimer!.hours * 60 * 60 - shutdownTimer!.minutes * 60)
                
                setTimerTextLabel()
                timerView.isHidden = false
                countDownTimer.isHidden = true
                
                shutdownTimer!.timerBeforeExit = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(showTimer), userInfo: nil, repeats: true)
            }else{
                startButton.setImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
                startButton.tintColor = .systemGreen
                shutdownTimer!.timerBeforeExit?.invalidate()
                shutdownTimer!.hours = NOT_ASSIGNED_VALUE
                shutdownTimer!.minutes = NOT_ASSIGNED_VALUE
                shutdownTimer!.seconds = NOT_ASSIGNED_VALUE
                timerView.isHidden = true
                countDownTimer.isHidden = false
            }
        }
    }
    
    @IBAction func colorSliderFMValueChanged(_ sender: Any) {
        let colorValue = CGFloat(colorSliderFlowMode.value)
        let color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        
        colorSliderFlowMode.thumbTintColor = color
        
        if userData != nil && flowMode != nil {
            if userData?.arrayOfFlowModeColors != nil {
                userData?.arrayOfFlowModeColors[flowMode!.changedColorIndex] = colorSliderFlowMode.value
            }
        }
        
        switch flowMode?.changedColorIndex {
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
        let colorValue = CGFloat(colorSliderFlowMode.value)
        let color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        firstColorFMButton.backgroundColor = color
        colorSliderFlowMode.thumbTintColor = color
        
        if flowMode != nil {
            flowMode!.changedColorIndex = 0
        }
        firstColorPointer.isHidden = false
        secondColorPointer.isHidden = true
        thirdColorPointer.isHidden = true
        fourthColorPointer.isHidden = true
    }
    
    @IBAction func secondColorButtonPressed(_ sender: Any) {
        if userData != nil {
            colorSliderFlowMode.value = userData?.arrayOfFlowModeColors[SECOND_COLOR_BUTTON_INDEX] ?? DEFAULT_COLOR_VALUE
        }else{
            colorSliderFlowMode.value = DEFAULT_COLOR_VALUE
        }
        var colorValue = CGFloat(colorSliderFlowMode.value)
        var color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        secondColorFMButton.backgroundColor = color
        colorSliderFlowMode.thumbTintColor = color

        if flowMode != nil {
            flowMode!.changedColorIndex = 1
        }
        firstColorPointer.isHidden = true
        secondColorPointer.isHidden = false
        thirdColorPointer.isHidden = true
        fourthColorPointer.isHidden = true
        
    }
    
    @IBAction func thirdColorButtonPressed(_ sender: Any) {
        if userData != nil {
            colorSliderFlowMode.value = userData?.arrayOfFlowModeColors[THIRD_COLOR_BUTTON_INDEX] ?? DEFAULT_COLOR_VALUE
        }else{
            colorSliderFlowMode.value = DEFAULT_COLOR_VALUE
        }
        let colorValue = CGFloat(colorSliderFlowMode.value)
        let color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        thirdColorFMButton.backgroundColor = color
        colorSliderFlowMode.thumbTintColor = color
        
        if flowMode != nil {
            flowMode!.changedColorIndex = 2
        }
        firstColorPointer.isHidden = true
        secondColorPointer.isHidden = true
        thirdColorPointer.isHidden = false
        fourthColorPointer.isHidden = true
    }
    
    @IBAction func fourthColorButtonPressed(_ sender: Any) {
        if userData != nil {
            colorSliderFlowMode.value = userData?.arrayOfFlowModeColors[FOURTH_COLOR_BUTTON_INDEX] ?? DEFAULT_COLOR_VALUE
        }else{
            colorSliderFlowMode.value = DEFAULT_COLOR_VALUE
        }
        let colorValue = CGFloat(colorSliderFlowMode.value)
        let color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        fourthColorFMButton.backgroundColor = color
        colorSliderFlowMode.thumbTintColor = color

        if flowMode != nil {
            flowMode!.changedColorIndex = 3
        }
        firstColorPointer.isHidden = true
        secondColorPointer.isHidden = true
        thirdColorPointer.isHidden = true
        fourthColorPointer.isHidden = false
    }
    
    @IBAction func startButtonFlowModePressed(_ sender: Any) {
        if flowMode != nil {
            if flowMode!.active == false {
                startFlowModeButton.setImage(UIImage(systemName: "stop.fill"), for: UIControl.State.normal)
                startFlowModeButton.tintColor = .systemRed
                flowMode!.active = true
    //            let speed = (1.1 - flowSpeedSlider.value) * 5
                let speed = 0.06
                flowMode!.enteredTimes = 0
                flowMode!.timer = Timer.scheduledTimer(timeInterval: TimeInterval(speed), target: self, selector: #selector(flowingColors), userInfo: nil, repeats: true)
                flowMode!.indexOfColor = 4
                flowingColors()
            }else{
                startFlowModeButton.setImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
                startFlowModeButton.tintColor = .systemGreen
                flowMode!.active = false
                flowMode!.timer?.invalidate()
                let colorValue = CGFloat(colorSlider.value)
                let color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
                self.view.backgroundColor = color
            }
        }
    }
    
    
    @objc func flowingColors(){
        if flowMode != nil {
            if flowMode!.enteredTimes == 0 {
                flowMode!.indexOfColor += 1
                if flowMode!.indexOfColor >= NUMBER_OF_COLORS_FLOW_MODE {
                    flowMode!.indexOfColor = 0
                }
                switch flowMode!.indexOfColor {
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
            flowMode!.enteredTimes += 1
            let limit = Int(fabsf(1.0 - flowSpeedSlider.value)*150+50)
            
            if flowMode!.enteredTimes >= (limit-10) {
                let color1 = (userData?.arrayOfFlowModeColors[flowMode!.indexOfColor])!
                let color2 = (userData?.arrayOfFlowModeColors[(flowMode!.indexOfColor + 1)%4])!
                var colorValue:CGFloat = 0
                var br:Float = 0
                if flowMode!.enteredTimes < (limit-10+5) {
                    colorValue = CGFloat(color1)
                    br = 1.0 - 0.1 * Float(flowMode!.enteredTimes - (limit - 11))
                }else{
                    colorValue = CGFloat(color2)
                    br = 1.0 - 0.1 * Float(limit + 1 - flowMode!.enteredTimes)
                }
                let color = UIColor(hue: colorValue, saturation: 1.0, brightness: CGFloat(br), alpha: 1.0)
                self.view.backgroundColor = color
            }
            if flowMode!.enteredTimes == limit{
                flowMode!.enteredTimes = 0
            }
        }

        //old
//        indexOfColorFlowMode += 1
//        if indexOfColorFlowMode >= NUMBER_OF_COLORS_FLOW_MODE {
//            indexOfColorFlowMode = 0
//        }
//        switch indexOfColorFlowMode {
//        case FIRST_COLOR_BUTTON_INDEX:
//            self.view.backgroundColor = firstColorFMButton.backgroundColor
//        case SECOND_COLOR_BUTTON_INDEX:
//            self.view.backgroundColor = secondColorFMButton.backgroundColor
//        case THIRD_COLOR_BUTTON_INDEX:
//            self.view.backgroundColor = thirdColorFMButton.backgroundColor
//        case FOURTH_COLOR_BUTTON_INDEX:
//            self.view.backgroundColor = fourthColorFMButton.backgroundColor
//        default:
//            print("invalid index")
//        }
    }
    
    @IBAction func flowSpeedSliderValueChanged(_ sender: Any) {
        if flowMode != nil {
            if flowMode!.active == true {
                let speed = 0.06
                flowMode!.timer?.invalidate()
                flowMode!.timer = Timer.scheduledTimer(timeInterval: TimeInterval(speed), target: self, selector: #selector(flowingColors), userInfo: nil, repeats: true)
                flowMode!.enteredTimes = 0
                flowMode!.indexOfColor = 4
                flowingColors()
            }
        }
    }
}

