//
//  ViewController.swift
//  Light
//
//  Created by Martin Kostelej on 03/08/2020.
//  Copyright © 2020 Martin Kostelej. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let COLOR_PICKING_VIEW_HEIGHT = 150, TIMER_VIEW_HEIGHT = 180, FLOW_MODE_HEIGHT = 270
    let NOT_ASSIGNED_VALUE = -1
    let NUMBER_OF_COLORS_FLOW_MODE = 4
    let COLOR_TAB = 0, TIMER_TAB = 1, FLOW_MODE_TAB = 2
    let DEFAULT_COLOR_VALUE:Float = 0.5
    let DEFAULT_TIMER_VALUE = 60
    let FIRST_COLOR_BUTTON_INDEX = 0, SECOND_COLOR_BUTTON_INDEX = 1, THIRD_COLOR_BUTTON_INDEX = 2, FOURTH_COLOR_BUTTON_INDEX = 3
    
    var changedColorFlowModeIndex = 0
    var flowModeActive = false
    var indexOfColorFlowMode = 0
    var enteredTimes = 0
    var timerFlowMode: Timer!
    
    var userData: UserData?
    var shutdownTimer: ShutdownTimer?
    
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
        var timer: Timer!
        var enteredTimes: Int
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
        
        //timer
        if shutdownTimer == nil {
            shutdownTimer = ShutdownTimer(hours: NOT_ASSIGNED_VALUE, minutes: NOT_ASSIGNED_VALUE, seconds: NOT_ASSIGNED_VALUE, timerBeforeExit: nil)
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
        firstColorFMButton.titleLabel?.text = ""
        secondColorFMButton.titleLabel?.text = ""
        thirdColorFMButton.titleLabel?.text = ""
        fourthColorFMButton.titleLabel?.text = ""
        
        brightnessSlider.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi/2))

        colorView.layer.cornerRadius = 15.0
        startButton.layer.cornerRadius = 15.0
        startFlowModeButton.layer.cornerRadius = 15.0
        
        changedColorFlowModeIndex = 0
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
                if shutdownTimer!.timerBeforeExit != nil {
                    shutdownTimer!.timerBeforeExit!.invalidate()
                }
                timerView.isHidden = true
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
                if shutdownTimer!.timerBeforeExit != nil {
                    shutdownTimer!.timerBeforeExit!.invalidate()
                }
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
//        colorSliderFlowMode.value = Float(0.5)
        var colorValue = CGFloat(colorSliderFlowMode.value)
        var color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        secondColorFMButton.backgroundColor = color
        colorSliderFlowMode.thumbTintColor = color

        changedColorFlowModeIndex = 1
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
//        colorSliderFlowMode.value = Float(0.5)
        var colorValue = CGFloat(colorSliderFlowMode.value)
        var color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        thirdColorFMButton.backgroundColor = color
        colorSliderFlowMode.thumbTintColor = color
        
        changedColorFlowModeIndex = 2
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
//        colorSliderFlowMode.value = Float(0.5)
        let colorValue = CGFloat(colorSliderFlowMode.value)
        let color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        fourthColorFMButton.backgroundColor = color
        colorSliderFlowMode.thumbTintColor = color

        changedColorFlowModeIndex = 3
        firstColorPointer.isHidden = true
        secondColorPointer.isHidden = true
        thirdColorPointer.isHidden = true
        fourthColorPointer.isHidden = false
    }
    
    @IBAction func startButtonFlowModePressed(_ sender: Any) {
        if flowModeActive == false {
            startFlowModeButton.setImage(UIImage(systemName: "stop.fill"), for: UIControl.State.normal)
            startFlowModeButton.tintColor = .systemRed
            flowModeActive = true
//            let speed = (1.1 - flowSpeedSlider.value) * 5
            let speed = 0.06
            enteredTimes = 0
            timerFlowMode = Timer.scheduledTimer(timeInterval: TimeInterval(speed), target: self, selector: #selector(flowingColors), userInfo: nil, repeats: true)
            indexOfColorFlowMode = 4
            flowingColors()
        }else{
            startFlowModeButton.setImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
            startFlowModeButton.tintColor = .systemGreen
            flowModeActive = false
            timerFlowMode.invalidate()
            let colorValue = CGFloat(colorSlider.value)
            let color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            self.view.backgroundColor = color
        }
    }
    
    
    @objc func flowingColors(){
        if enteredTimes == 0 {
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
        enteredTimes += 1
        let limit = Int(fabsf(1.0 - flowSpeedSlider.value)*150+50)
        
        if enteredTimes >= (limit-10) {
            let color1 = (userData?.arrayOfFlowModeColors[indexOfColorFlowMode])!
            let color2 = (userData?.arrayOfFlowModeColors[(indexOfColorFlowMode + 1)%4])!
            var colorValue:CGFloat = 0
            var br:Float = 0
            if enteredTimes < (limit-10+5) {
                colorValue = CGFloat(color1)
                br = 1.0 - 0.1 * Float(enteredTimes - (limit - 11))
            }else{
                colorValue = CGFloat(color2)
                br = 1.0 - 0.1 * Float(limit + 1 - enteredTimes)
            }
            let color = UIColor(hue: colorValue, saturation: 1.0, brightness: CGFloat(br), alpha: 1.0)
            self.view.backgroundColor = color
        }
        if enteredTimes == limit{
            enteredTimes = 0
        }

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
        //timerFlowMode.timeInterval =
        if flowModeActive == true {
//            let speed = (1.1 - flowSpeedSlider.value) * 5
            let speed = 0.06
            timerFlowMode.invalidate()
            timerFlowMode = Timer.scheduledTimer(timeInterval: TimeInterval(speed), target: self, selector: #selector(flowingColors), userInfo: nil, repeats: true)
            enteredTimes = 0
            indexOfColorFlowMode = 4
            flowingColors()
        }
    }
}

