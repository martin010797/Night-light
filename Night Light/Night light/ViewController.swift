//
//  ViewController.swift
//  Light
//
//  Created by Martin Kostelej on 03/08/2020.
//  Copyright © 2020 Martin Kostelej. All rights reserved.
//

let COLOR_PICKING_VIEW_HEIGHT = 180, TIMER_VIEW_HEIGHT = 180, FLOW_MODE_HEIGHT = 270

let NOT_ASSIGNED_VALUE = -1
let NUMBER_OF_COLORS_FLOW_MODE = 4
let COLOR_TAB = 0, TIMER_TAB = 1, FLOW_MODE_TAB = 2
let DEFAULT_TIMER_VALUE = 60
let FIRST_COLOR_BUTTON_INDEX = 0, SECOND_COLOR_BUTTON_INDEX = 1, THIRD_COLOR_BUTTON_INDEX = 2, FOURTH_COLOR_BUTTON_INDEX = 3
let RECENTLY_USED_COLORS_MAX_COUNT = 5
let DEFAULT_COLOR = UIColor.orange
let DEFAULT_TIMER_HOURS = 1
let DEFAULT_TIMER_MINUTES = 30
let DEFAULT_FLOW_SPEED = 0.5
let ONE_COLOR_LIGHT_KEY = "ONE_COLOR_LIGHT"
let RECENTLY_USED_COLORS_KEY = "RECENTLY_USED_COLORS_KEY"
let INDEX_OF_NEXT_ITEM_IN_RECENTLY_KEY = "INDEX_OF_NEXT_ITEM_IN_RECENTLY_KEY"
let TIMER_KEY = "TIMER_KEY"
let FLOW_SPEED_KEY = "FLOW_SPEED_KEY"
let FLOW_MODE_COLORS_KEY = "FLOW_MODE_COLORS_KEY"

import UIKit

class ViewController: UIViewController, UIColorPickerViewControllerDelegate {
    var userData: UserData?
    var shutdownTimer: ShutdownTimer?
    var flowMode: FlowMode?
    
    @IBOutlet var brightnessSlider: UISlider!
    @IBOutlet var colorView: UIView!
    @IBOutlet var choiceButtons: UISegmentedControl!
    @IBOutlet var colorViewHeight: NSLayoutConstraint!
    @IBOutlet var countDownTimer: UIDatePicker!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet weak var timerView: UIView!
    
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
    
    @IBOutlet weak var colorPickerButton: UIButton!
    @IBOutlet weak var recentlyUsedLabel: UILabel!
    @IBOutlet weak var recentlyUsedColor1: UIButton!
    @IBOutlet weak var recentlyUsedColor2: UIButton!
    @IBOutlet weak var recentlyUsedColor3: UIButton!
    @IBOutlet weak var recentlyUsedColor4: UIButton!
    @IBOutlet weak var recentlyUsedColor5: UIButton!
    @IBOutlet weak var recentlyUsedColorsView: UIView!
    @IBOutlet weak var colorPickerButtonFlowMode: UIButton!
    @IBOutlet weak var brightnessSliderConstraintRight: NSLayoutConstraint!
    
    @IBOutlet weak var brightnessSliderConstraintDown: NSLayoutConstraint!
    
    var colorPicker = UIColorPickerViewController()
    var arrayOfRecentlyUsedColorsButtons = [UIButton]()
    var arrayOfFlowModeColorsButtons = [UIButton]()
    let defaults = UserDefaults.standard
    
    // MARK: Structures
    
    struct UserData {
        var oneColorLight: UIColor = UIColor()
        var arrayOfFlowModeColors = [UIColor]()
        var arrayOfRecntlyUsedColors = [UIColor]()
        var indexOfNextItemInRecently: Int = Int()
        var flowSpeed: Float = Float()
        var timerHours: Int = Int()
        var timerMinutes: Int = Int()
        init() {
            //getting one color data
            let retrievedColor = UserDefaults.standard.colorItemForKey(key: ONE_COLOR_LIGHT_KEY) as? UIColor ?? DEFAULT_COLOR
            if retrievedColor == DEFAULT_COLOR{
                UserDefaults.standard.setColorItem(item: DEFAULT_COLOR, forKey: ONE_COLOR_LIGHT_KEY)
            }
            //getting recently used colors
            var retrievedRecentlyUsedColors = UserDefaults.standard.colorItemForKey(key: RECENTLY_USED_COLORS_KEY) as? [UIColor] ?? [UIColor]()
            if retrievedRecentlyUsedColors.count == 0 {
                retrievedRecentlyUsedColors.append(retrievedColor)
                UserDefaults.standard.setColorItem(item: retrievedRecentlyUsedColors, forKey: RECENTLY_USED_COLORS_KEY)
            }
            //getting index of recently used colors next item
            var retrievedIndex = UserDefaults.standard.integer(forKey: INDEX_OF_NEXT_ITEM_IN_RECENTLY_KEY)
            if retrievedIndex == 0 && retrievedRecentlyUsedColors.count < RECENTLY_USED_COLORS_MAX_COUNT {
                retrievedIndex = retrievedRecentlyUsedColors.count
                UserDefaults.standard.set(retrievedIndex, forKey: INDEX_OF_NEXT_ITEM_IN_RECENTLY_KEY)
            }
            //getting timer values
            var retrievedTimer = UserDefaults.standard.object(forKey: TIMER_KEY) as? [Int] ?? [Int]()
            if retrievedTimer.count == 0 {
                retrievedTimer.append(DEFAULT_TIMER_HOURS)
                retrievedTimer.append(DEFAULT_TIMER_MINUTES)
                UserDefaults.standard.set(retrievedTimer, forKey: TIMER_KEY)
            }
            //getting flow speed value
            let retrievedFlowSpeed = UserDefaults.standard.float(forKey: FLOW_SPEED_KEY)
            if retrievedFlowSpeed == 0.0 {
                UserDefaults.standard.set(retrievedFlowSpeed, forKey: FLOW_SPEED_KEY)
            }
            //getting flow mode colors
            var retrievedFlowModeColors = UserDefaults.standard.colorItemForKey(key: FLOW_MODE_COLORS_KEY) as? [UIColor] ?? [UIColor]()
            if retrievedFlowModeColors.count == 0 {
                for _ in 1...4 {
                    retrievedFlowModeColors.append(DEFAULT_COLOR)
                }
                UserDefaults.standard.setColorItem(item: retrievedFlowModeColors, forKey: FLOW_MODE_COLORS_KEY)
            }
            oneColorLight = retrievedColor
            arrayOfFlowModeColors = retrievedFlowModeColors
            arrayOfRecntlyUsedColors = retrievedRecentlyUsedColors
            indexOfNextItemInRecently = retrievedIndex
            flowSpeed = retrievedFlowSpeed
            timerHours = retrievedTimer[0]
            timerMinutes = retrievedTimer[1]
        }
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
    
    // MARK: General functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if arrayOfFlowModeColorsButtons.count == 0 {
            arrayOfFlowModeColorsButtons.append(firstColorFMButton)
            arrayOfFlowModeColorsButtons.append(secondColorFMButton)
            arrayOfFlowModeColorsButtons.append(thirdColorFMButton)
            arrayOfFlowModeColorsButtons.append(fourthColorFMButton)
        }
        
        if arrayOfRecentlyUsedColorsButtons.count == 0 {
            arrayOfRecentlyUsedColorsButtons.append(recentlyUsedColor1)
            arrayOfRecentlyUsedColorsButtons.append(recentlyUsedColor2)
            arrayOfRecentlyUsedColorsButtons.append(recentlyUsedColor3)
            arrayOfRecentlyUsedColorsButtons.append(recentlyUsedColor4)
            arrayOfRecentlyUsedColorsButtons.append(recentlyUsedColor5)
        }
        
        colorPicker.delegate = self
        
        //user data
        if userData == nil {
            userData = UserData()
        }
        
        //timer
        if shutdownTimer == nil {
            shutdownTimer = ShutdownTimer(hours: NOT_ASSIGNED_VALUE, minutes: NOT_ASSIGNED_VALUE, seconds: NOT_ASSIGNED_VALUE, timerBeforeExit: nil)
        }
        
        //Flow mode
        if flowMode == nil{
            flowMode = FlowMode(changedColorIndex: 0, active: false, indexOfColor: 0, timer: nil, enteredTimes: 0)
        }
        if userData != nil {
            flowSpeedSlider.value = userData!.flowSpeed
        }
        
        //to avoid display turning off
        UIApplication.shared.isIdleTimerDisabled = true
        
        brightnessSlider.value = Float(UIScreen.main.brightness)
                
        //rotating pointers for colors
        firstColorPointer.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi))
        secondColorPointer.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi))
        thirdColorPointer.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi))
        fourthColorPointer.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi))
        
        setColorsForFlowModeButtons()
        
        //setting color tab
        choiceButtons.selectedSegmentIndex = COLOR_TAB
        colorViewHeight.constant = CGFloat(COLOR_PICKING_VIEW_HEIGHT)
        changeTimerTabVisibility(isHidden: true)
        changeFlowModeTabVisibility(isHidden: true)
        
        //setting timer tab values
        if userData != nil {
//            let min = userData?.timerMinutes ?? 1
//            let hrs = userData?.timerHours ?? 0
//            countDownTimer.countDownDuration = TimeInterval((hrs * 60 + min) * 60)
            let calendar = Calendar(identifier: .gregorian)
            let date = DateComponents(calendar: calendar, hour: userData?.timerHours ?? 0, minute: userData?.timerMinutes ?? 1).date!
            countDownTimer.setDate(date, animated: true)
        }else{
            countDownTimer.countDownDuration = TimeInterval(DEFAULT_TIMER_VALUE)
        }
        

        for button in arrayOfRecentlyUsedColorsButtons {
            button.layer.cornerRadius = 10.0
        }
        
        for button in arrayOfFlowModeColorsButtons {
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
        }
        
        startFlowModeButton.layer.cornerRadius = 15.0
        colorView.layer.cornerRadius = 15.0
        startButton.layer.cornerRadius = 15.0
        
        self.view.backgroundColor = userData!.oneColorLight
        showRecentlyUsedColors()
        setStatusBarDependingBackgroundColorBrightness()
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setStatusBarDependingBackgroundColorBrightness()
        
        //disable going to sleep
        UIApplication.shared.isIdleTimerDisabled = true;
        
        colorView.backgroundColor = UIColor.lightGray
        setBrightnessSliderOrientation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false;
    }
    @IBAction func brightnessSliderVlaueDidChange(_ sender: Any) {
        UIScreen.main.brightness = CGFloat(brightnessSlider.value)
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setBrightnessSliderOrientation()
    }
    
    func setStatusBarDependingBackgroundColorBrightness(){
        let cgColor = self.view.backgroundColor!.cgColor
        let rgbColor = cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        let rgbComponents = rgbColor?.components
        if rgbComponents != nil && rgbComponents?.count ?? 0 >= 3 {
            let brightness = Float(((rgbComponents![0] * 299) + (rgbComponents![1] * 587) + (rgbComponents![2] * 114)) / 1000)
            if brightness < 0.5 {
                UIApplication.shared.statusBarStyle = .lightContent
            }else{
                UIApplication.shared.statusBarStyle = .darkContent
            }
        }else{
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    func setBrightnessSliderOrientation() {
        if UIDevice.current.orientation.isLandscape{
            brightnessSlider.transform = CGAffineTransform(rotationAngle: CGFloat(2*Float.pi))
            brightnessSliderConstraintRight.constant = 10.0
            brightnessSliderConstraintDown.constant = 10.0
        }else{
            brightnessSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Float.pi/2))
            brightnessSliderConstraintRight.constant = -95.0
            brightnessSliderConstraintDown.constant = 130.0
        }
    }
    
    @IBAction func choiceChanged(_ sender: Any) {
        switch choiceButtons.selectedSegmentIndex {
        case COLOR_TAB:
            changeColorTabVisibility(isHidden: false)
            
            changeTimerTabVisibility(isHidden: true)
            changeFlowModeTabVisibility(isHidden: true)
            colorViewHeight.constant = CGFloat(COLOR_PICKING_VIEW_HEIGHT)
            self.view.layoutIfNeeded()
            
        case TIMER_TAB:
            changeColorTabVisibility(isHidden: true)
            changeFlowModeTabVisibility(isHidden: true)
            
            changeTimerTabVisibility(isHidden: false)
            
            colorViewHeight.constant = CGFloat(TIMER_VIEW_HEIGHT)
            self.view.layoutIfNeeded()

        case FLOW_MODE_TAB:
            changeColorTabVisibility(isHidden: true)
            changeTimerTabVisibility(isHidden: true)
            
            changeFlowModeTabVisibility(isHidden: false)
            setColorsForFlowModeButtons()

            colorViewHeight.constant = CGFloat(FLOW_MODE_HEIGHT)
            self.view.layoutIfNeeded()

        default:
            print("not available index")
        }
    }
    
    func changeFlowModeTabVisibility(isHidden: Bool) {
        for button in arrayOfFlowModeColorsButtons {
            button.isHidden = isHidden
        }
        colorPickerButtonFlowMode.isHidden = isHidden
        flowSpeedLabel.isHidden = isHidden
        flowSpeedSlider.isHidden = isHidden
        colorLabel.isHidden = isHidden
        startFlowModeButton.isHidden = isHidden
        
        if isHidden == false {
            if flowMode != nil && userData != nil {
                switch flowMode!.changedColorIndex {
                case FIRST_COLOR_BUTTON_INDEX:
                    firstColorPointer.isHidden = false
                case SECOND_COLOR_BUTTON_INDEX:
                    secondColorPointer.isHidden = false
                case THIRD_COLOR_BUTTON_INDEX:
                    thirdColorPointer.isHidden = false
                case FOURTH_COLOR_BUTTON_INDEX:
                    fourthColorPointer.isHidden = false
                default:
                    firstColorPointer.isHidden = false
                }
            }else{
                firstColorPointer.isHidden = false
            }
        }else{
            firstColorPointer.isHidden = isHidden
            secondColorPointer.isHidden = isHidden
            thirdColorPointer.isHidden = isHidden
            fourthColorPointer.isHidden = isHidden
        }
    }
    
    func changeTimerTabVisibility(isHidden: Bool){
        startButton.isHidden = isHidden
        if isHidden == false {
            if shutdownTimer != nil {
                if shutdownTimer!.seconds != NOT_ASSIGNED_VALUE && shutdownTimer!.minutes != NOT_ASSIGNED_VALUE && shutdownTimer!.hours != NOT_ASSIGNED_VALUE {
                    timerView.isHidden = false
                }else{
                    countDownTimer.isHidden = false
                }
            }
        }else{
            countDownTimer.isHidden = isHidden
            timerView.isHidden = isHidden
        }
    }
    
    func changeColorTabVisibility(isHidden: Bool){
        recentlyUsedColorsView.isHidden = isHidden
        recentlyUsedLabel.isHidden = isHidden
        colorPickerButton.isHidden = isHidden
    }
    
    // MARK: Color tab functions
    
    @IBAction func openColorPicker(_ sender: Any) {
        stopFlowMode()
        colorPicker.supportsAlpha = false
        colorPicker.selectedColor = self.view.backgroundColor!
        present(colorPicker, animated: true)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        if choiceButtons.selectedSegmentIndex == COLOR_TAB {
            if viewController.selectedColor != self.view.backgroundColor {
                if userData != nil {
                    if userData!.arrayOfRecntlyUsedColors.count < RECENTLY_USED_COLORS_MAX_COUNT {
                        userData!.arrayOfRecntlyUsedColors.append(viewController.selectedColor)
                    }else{
                        userData!.arrayOfRecntlyUsedColors[userData!.indexOfNextItemInRecently] = viewController.selectedColor
                    }
                    userData!.indexOfNextItemInRecently = (userData!.indexOfNextItemInRecently + 1) % RECENTLY_USED_COLORS_MAX_COUNT
                    defaults.set(userData!.indexOfNextItemInRecently, forKey: INDEX_OF_NEXT_ITEM_IN_RECENTLY_KEY)
                    userData!.oneColorLight = viewController.selectedColor
                    defaults.setColorItem(item: userData!.arrayOfRecntlyUsedColors, forKey: RECENTLY_USED_COLORS_KEY)
                }
                self.view.backgroundColor = viewController.selectedColor
                showRecentlyUsedColors()
                defaults.setColorItem(item: viewController.selectedColor, forKey: ONE_COLOR_LIGHT_KEY)
            }
        }else{
            if userData != nil && flowMode != nil {
                userData!.arrayOfFlowModeColors[flowMode!.changedColorIndex] = viewController.selectedColor
                defaults.setColorItem(item: userData!.arrayOfFlowModeColors, forKey: FLOW_MODE_COLORS_KEY)
            }
            arrayOfFlowModeColorsButtons[flowMode!.changedColorIndex].backgroundColor = viewController.selectedColor
        }
        setStatusBarDependingBackgroundColorBrightness()
    }
    
    func showRecentlyUsedColors() {
        if userData != nil {
            let count = userData!.arrayOfRecntlyUsedColors.count
            if (count < RECENTLY_USED_COLORS_MAX_COUNT) || (count == RECENTLY_USED_COLORS_MAX_COUNT && userData!.indexOfNextItemInRecently == 0) {
                if count >= 1 {
                    for i in (0...(count - 1)).reversed(){
                        arrayOfRecentlyUsedColorsButtons[count - 1 - i].backgroundColor = userData!.arrayOfRecntlyUsedColors[i]
                    }
                }
            }else{
                var index = userData!.indexOfNextItemInRecently
                for i in 0...4 {
                    arrayOfRecentlyUsedColorsButtons[count - 1 - i].backgroundColor = userData!.arrayOfRecntlyUsedColors[index]
                    index = (index + 1) % RECENTLY_USED_COLORS_MAX_COUNT
                }
            }
        }
        hideUnactiveRecentlyUsedColors()
    }
    
    func hideUnactiveRecentlyUsedColors(){
        if userData != nil {
            let count = userData!.arrayOfRecntlyUsedColors.count
            for i in 0...4 {
                if i < count {
                    arrayOfRecentlyUsedColorsButtons[i].isHidden = false
                }else{
                    arrayOfRecentlyUsedColorsButtons[i].isHidden = true
                }
            }
        }
    }
    
    @IBAction func recentlyUsedColorButton1Pressed(_ sender: Any) {
        self.view.backgroundColor = arrayOfRecentlyUsedColorsButtons[0].backgroundColor
        setStatusBarDependingBackgroundColorBrightness()
        if userData != nil {
            userData!.oneColorLight = arrayOfRecentlyUsedColorsButtons[0].backgroundColor!
        }
        stopFlowMode()
        defaults.setColorItem(item: arrayOfRecentlyUsedColorsButtons[0].backgroundColor, forKey: ONE_COLOR_LIGHT_KEY)
    }
    
    @IBAction func recentlyUsedColorButton2Pressed(_ sender: Any) {
        self.view.backgroundColor = arrayOfRecentlyUsedColorsButtons[1].backgroundColor
        setStatusBarDependingBackgroundColorBrightness()
        if userData != nil {
            userData!.oneColorLight = arrayOfRecentlyUsedColorsButtons[1].backgroundColor!
        }
        stopFlowMode()
        defaults.setColorItem(item: arrayOfRecentlyUsedColorsButtons[1].backgroundColor, forKey: ONE_COLOR_LIGHT_KEY)
    }
    
    @IBAction func recentlyUsedColorButton3Pressed(_ sender: Any) {
        self.view.backgroundColor = arrayOfRecentlyUsedColorsButtons[2].backgroundColor
        setStatusBarDependingBackgroundColorBrightness()
        if userData != nil {
            userData!.oneColorLight = arrayOfRecentlyUsedColorsButtons[2].backgroundColor!
        }
        stopFlowMode()
        defaults.setColorItem(item: arrayOfRecentlyUsedColorsButtons[2].backgroundColor, forKey: ONE_COLOR_LIGHT_KEY)
    }
    
    @IBAction func recentlyUsedColorButton4Pressed(_ sender: Any) {
        self.view.backgroundColor = arrayOfRecentlyUsedColorsButtons[3].backgroundColor
        setStatusBarDependingBackgroundColorBrightness()
        if userData != nil {
            userData!.oneColorLight = arrayOfRecentlyUsedColorsButtons[3].backgroundColor!
        }
        stopFlowMode()
        defaults.setColorItem(item: arrayOfRecentlyUsedColorsButtons[3].backgroundColor, forKey: ONE_COLOR_LIGHT_KEY)
    }
    
    @IBAction func recentlyUsedColorButton5Pressed(_ sender: Any) {
        self.view.backgroundColor = arrayOfRecentlyUsedColorsButtons[4].backgroundColor
        setStatusBarDependingBackgroundColorBrightness()
        if userData != nil {
            userData!.oneColorLight = arrayOfRecentlyUsedColorsButtons[4].backgroundColor!
        }
        stopFlowMode()
        defaults.setColorItem(item: arrayOfRecentlyUsedColorsButtons[4].backgroundColor, forKey: ONE_COLOR_LIGHT_KEY)
    }
    
    //MARK: Timer functions
        
    @IBAction func countDownTimerValueChanged(_ sender: Any) {
        let hours = Int(countDownTimer.countDownDuration/60/60)
        let minutes = (Int(countDownTimer.countDownDuration) - Int(hours * 60 * 60))/60
        var arrayOfTimerData = [Int]()
        arrayOfTimerData.append(hours)
        arrayOfTimerData.append(minutes)
        defaults.set(arrayOfTimerData, forKey: TIMER_KEY)
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
                startButton.setImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
                startButton.tintColor = .systemGreen
                timerView.isHidden = true
                if choiceButtons.selectedSegmentIndex == 1 {
                    countDownTimer.isHidden = false
                }
                if flowMode != nil {
                    if flowMode!.active == true {
                        flowMode!.active = false
                        flowMode!.timer?.invalidate()
                    }
                }
                UIApplication.shared.isIdleTimerDisabled = false;
                UIScreen.main.brightness = CGFloat(0.1)
                exit(-1)
//                UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            }else{
                setTimerTextLabel()
            }
        }
    }
    
    @IBAction func startButtonTimerPressed(_ sender: Any) {
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
    
    // MARK: Flow mode functions
    
    func setColorsForFlowModeButtons(){
        var i = 0
        for button in arrayOfFlowModeColorsButtons {
            var color = DEFAULT_COLOR
            if userData != nil {
                if userData!.arrayOfFlowModeColors.count >= 4 {
                    color = userData!.arrayOfFlowModeColors[i]
                }
            }
            button.backgroundColor = color
            i += 1
        }
    }
    
    @IBAction func firstColorButtonPressed(_ sender: Any) {
        if flowMode != nil {
            flowMode!.changedColorIndex = 0
        }
        firstColorPointer.isHidden = false
        secondColorPointer.isHidden = true
        thirdColorPointer.isHidden = true
        fourthColorPointer.isHidden = true
    }
    
    @IBAction func secondColorButtonPressed(_ sender: Any) {
        if flowMode != nil {
            flowMode!.changedColorIndex = 1
        }
        firstColorPointer.isHidden = true
        secondColorPointer.isHidden = false
        thirdColorPointer.isHidden = true
        fourthColorPointer.isHidden = true
        
    }
    
    @IBAction func thirdColorButtonPressed(_ sender: Any) {
        if flowMode != nil {
            flowMode!.changedColorIndex = 2
        }
        firstColorPointer.isHidden = true
        secondColorPointer.isHidden = true
        thirdColorPointer.isHidden = false
        fourthColorPointer.isHidden = true
    }
    
    @IBAction func fourthColorButtonPressed(_ sender: Any) {
        if flowMode != nil {
            flowMode!.changedColorIndex = 3
        }
        firstColorPointer.isHidden = true
        secondColorPointer.isHidden = true
        thirdColorPointer.isHidden = true
        fourthColorPointer.isHidden = false
    }
    
    func stopFlowMode(){
        if flowMode != nil {
            if flowMode!.active == true {
                startFlowModeButton.setImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
                startFlowModeButton.tintColor = .systemGreen
                flowMode!.active = false
                flowMode!.timer?.invalidate()
                if userData != nil {
                    self.view.backgroundColor = userData!.oneColorLight
                    setStatusBarDependingBackgroundColorBrightness()
                }
            }
        }
    }
    
    @IBAction func startButtonFlowModePressed(_ sender: Any) {
        if flowMode != nil {
            if flowMode!.active == false {
                startFlowModeButton.setImage(UIImage(systemName: "stop.fill"), for: UIControl.State.normal)
                startFlowModeButton.tintColor = .systemRed
                flowMode!.active = true
                let speed = 0.06
                flowMode!.enteredTimes = 0
                flowMode!.timer = Timer.scheduledTimer(timeInterval: TimeInterval(speed), target: self, selector: #selector(flowingColors), userInfo: nil, repeats: true)
                flowMode!.indexOfColor = 4
                flowingColors()
            }else{
                stopFlowMode()
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
                setStatusBarDependingBackgroundColorBrightness()
            }
            flowMode!.enteredTimes += 1
            let limit = Int(fabsf(1.0 - flowSpeedSlider.value)*150+50)
            
            if flowMode!.enteredTimes >= (limit-10) {
                let color1 = (userData?.arrayOfFlowModeColors[flowMode!.indexOfColor])!
                let color2 = (userData?.arrayOfFlowModeColors[(flowMode!.indexOfColor + 1)%4])!
                var chosenColor:UIColor = DEFAULT_COLOR
                
                var br:Float = 0
                if flowMode!.enteredTimes < (limit-10+5) {
                    chosenColor = color1
                    br = 1.0 - 0.1 * Float(flowMode!.enteredTimes - (limit - 11))
                }else{
                    chosenColor = color2
                    br = 1.0 - 0.1 * Float(limit + 1 - flowMode!.enteredTimes)
                }
                self.view.backgroundColor = chosenColor.modified(withAdditionalHue: CGFloat(0.0), additionalSaturation: CGFloat(0.0), additionalBrightness: CGFloat(br - 1.0))
            }
            if flowMode!.enteredTimes == limit{
                flowMode!.enteredTimes = 0
            }
        }
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
        defaults.set(flowSpeedSlider.value, forKey: FLOW_SPEED_KEY)
    }
    
    @IBAction func openColorpickerFlowMode(_ sender: Any) {
        colorPicker.supportsAlpha = false
        if flowMode != nil {
            colorPicker.selectedColor = arrayOfFlowModeColorsButtons[flowMode!.changedColorIndex].backgroundColor!
        }
        present(colorPicker, animated: true)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
}

extension UIColor {

    func modified(withAdditionalHue hue: CGFloat, additionalSaturation: CGFloat, additionalBrightness: CGFloat) -> UIColor {

        var currentHue: CGFloat = 0.0
        var currentSaturation: CGFloat = 0.0
        var currentBrigthness: CGFloat = 0.0
        var currentAlpha: CGFloat = 0.0

        if self.getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentAlpha){
            return UIColor(hue: currentHue + hue,
                           saturation: currentSaturation + additionalSaturation,
                           brightness: currentBrigthness + additionalBrightness,
                           alpha: currentAlpha)
        } else {
            return self
        }
    }
}

extension UserDefaults {
    func colorItemForKey(key: String) -> Any? {
        var colorReturnded: Any?
        if let colorData = data(forKey: key) {
            do {
                if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) {
                    colorReturnded = color
                }
            } catch {
                print("Error with getting color")
            }
        }
        return colorReturnded
    }
    func setColorItem(item: Any?, forKey key: String){
        var colorData: NSData?
        if let item = item {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: item, requiringSecureCoding: false) as NSData?
                colorData = data
            } catch {
                print("Error with saving color")
            }
        }
        set(colorData, forKey: key)
    }
}


