//
//  ViewController.swift
//  Light
//
//  Created by Martin Kostelej on 03/08/2020.
//  Copyright © 2020 Martin Kostelej. All rights reserved.
//
let COLOR_PICKING_VIEW_HEIGHT = 180, TIMER_VIEW_HEIGHT = 180, FLOW_MODE_HEIGHT = 270, COLOR_PICKING_HEIGHT_ACTIVE_GRADIENT_OR_IMAGE = 290, COLOR_PICKING_HEIGHT_ACTIVE_BASIC_COLOR = 250

let NOT_ASSIGNED_VALUE = -1
let NUMBER_OF_COLORS_FLOW_MODE = 4
let COLOR_TAB = 0, TIMER_TAB = 1, FLOW_MODE_TAB = 2
let DEFAULT_TIMER_VALUE = 60
let FIRST_COLOR_BUTTON_INDEX = 0, SECOND_COLOR_BUTTON_INDEX = 1, THIRD_COLOR_BUTTON_INDEX = 2, FOURTH_COLOR_BUTTON_INDEX = 3
let RECENTLY_USED_COLORS_MAX_COUNT = 5
let RECENTLY_USED_COLORS_FIRST_BUTTON_INDEX = 0, RECENTLY_USED_COLORS_SECOND_BUTTON_INDEX = 1, RECENTLY_USED_COLORS_THIRD_BUTTON_INDEX = 2, RECENTLY_USED_COLORS_FOURTH_BUTTON_INDEX = 3, RECENTLY_USED_COLORS_FIFTH_BUTTON_INDEX = 4
let DEFAULT_COLOR = UIColor.orange
let DEFAULT_TIMER_HOURS = 1
let DEFAULT_TIMER_MINUTES = 30
let DEFAULT_FLOW_SPEED = 0.5
let DEFAULT_IMAGE_INDEX = 0
let DEFAULT_IMAGE_NAME = "background_image_1"
let ONE_COLOR_LIGHT_KEY = "ONE_COLOR_LIGHT"
let RECENTLY_USED_COLORS_KEY = "RECENTLY_USED_COLORS_KEY"
let INDEX_OF_NEXT_ITEM_IN_RECENTLY_KEY = "INDEX_OF_NEXT_ITEM_IN_RECENTLY_KEY"
let TIMER_KEY = "TIMER_KEY"
let FLOW_SPEED_KEY = "FLOW_SPEED_KEY"
let FLOW_MODE_COLORS_KEY = "FLOW_MODE_COLORS_KEY"
let GRADIENT_COLORS_KEY = "GRADIENT_COLORS_KEY"
let GRADIENT_ACTIVE_KEY = "GRADIENT_ACTIVE_KEY"
let IMAGE_ACTIVE_KEY = "IMAGE_ACTIVE_KEY"
let IMAGE_INDEX_KEY = "IMAGE_INDEX_KEY"
let COLOR_INFO_TEXT = "Pre zvolenie jednej farby pozadia vyberte z piatich naposledy použitých farieb. Pokiaľ chcete inú farbu, tak zvoľte možnosť pre otvorenie palety farieb. Táto voľba sa automaticky pridá medzi naposledy zvolené. \n \n Ak je potrebné prelínanie dvoch farieb, tak zapnite možnosť pre gradient. Následne sa nižšie zobrazia dve tlačidlá s farbami, ktoré sa medzi sebou budú miešať. Pre zmenu kliknite na ne a otovrí sa paleta farieb. \n \n Pokiaľ chce používateľ nastaviť na pozadie niektorý z obrázkov, tak je potrebné prepnúť možnosť pre použitie obrázku. Potom sa zobrazí pod prepínačom možnosť pre zmenu."
let COLOR_INFO_TITLE = "Výber pozadia"
let TIMER_INFO_TEXT = "Časovač slúži pre šetrenie batérie zariadenia. Určuje čas po uplynutí ktorého sa aplikácia vypne a zníži jas na minimum. Ak chcete aj celkové vypnutie displeja tak choďte do: Nastavenie/Displej a jas/Uzamykanie a nastavte požadovaný čas po vypnutí aplikácie. \n \n Po zvolení hodín a minút stlačte čierno zlené tlačidlo na pravej strane pre spustenie časovača. Ak chcete časovač vypnúť tak stlačte opätovne to isté tlačidlo."
let TIMER_INFO_TITLE = "Nastavenie časovača"
let FLOW_MODE_INFO_TEXT = "Prechod medzi farbami slúži na striedanie medzi štyrmi farbami po určitom čase. \n \n Farby medzi ktorými sa prechádza sú reprezentované štyrmi tlačidlami. Pokiaľ chcete niektoré zmeniť, tak naň kliknite a zobrarzí sa nad ním šípka, čo určuje že sa aktuálne môže modifikovať. Pre zmenu vyberte možnosť pre otvorenie palety farieb. \n \n Slider naspodku určuje ako rýchlo sa budú farby medzi sebou striedať(vľavo pomalšie a vpravo rýchlejšie). Pre spustenie alebo vypnutie stlačte čierno zelené tlačidlo v pravom hornom rohu menu."
let FLOW_MODE_INFO_TITLE = "Prechod farieb"

import UIKit

class ViewController: UIViewController, UIColorPickerViewControllerDelegate {
    //struktury
    var userData: UserData?
    var shutdownTimer: ShutdownTimer?
    var flowMode: FlowMode?

    //prepojenia ku elementom vlozenych vo view
    @IBOutlet var brightnessSlider: UISlider!
    @IBOutlet var colorView: UIView!
    @IBOutlet var choiceButtons: UISegmentedControl!
    @IBOutlet var colorViewHeight: NSLayoutConstraint!
    @IBOutlet var countDownTimer: UIDatePicker!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var infoTimerButton: UIButton!
    
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
    @IBOutlet weak var infoFlowModeButton: UIButton!
    
    @IBOutlet weak var gradientUseLabel: UILabel!
    @IBOutlet weak var gradientSwitch: UISwitch!
    @IBOutlet weak var gradientColor1Label: UILabel!
    @IBOutlet weak var gradientColor2Label: UILabel!
    @IBOutlet weak var gradientColor1Button: UIButton!
    @IBOutlet weak var gradientColor2Button: UIButton!
    
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
    @IBOutlet weak var infoColorsButton: UIButton!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var imageUseLabel: UILabel!
    @IBOutlet weak var imageUseLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var imageSwitch: UISwitch!
    @IBOutlet weak var imageSwitchBottomConstraint: NSLayoutConstraint!
    
    var colorPicker = UIColorPickerViewController()
    var arrayOfRecentlyUsedColorsButtons = [UIButton]()
    var arrayOfFlowModeColorsButtons = [UIButton]()
    let defaults = UserDefaults.standard
    var gradientColorToChange = NOT_ASSIGNED_VALUE
    
    // MARK: Structures
    
    //pouzivatelske data ktore sa ukladaju do databazy UserDefaults
    struct UserData {
        var oneColorLight: UIColor = UIColor()
        var arrayOfFlowModeColors = [UIColor]()
        var arrayOfRecntlyUsedColors = [UIColor]()
        var indexOfNextItemInRecently: Int = Int()
        var flowSpeed: Float = Float()
        var timerHours: Int = Int()
        var timerMinutes: Int = Int()
        var gradientActive: Bool = Bool()
        var gradientColors = [UIColor]()
        var imageActive: Bool = Bool()
        var imageIndex: Int = Int()
        init() {
            //getting gradient colors
            var retrievedGradientColors = UserDefaults.standard.colorItemForKey(key: GRADIENT_COLORS_KEY) as? [UIColor] ?? [UIColor]()
            if retrievedGradientColors.count == 0 {
                retrievedGradientColors.append(DEFAULT_COLOR)
                retrievedGradientColors.append(DEFAULT_COLOR)
                UserDefaults.standard.setColorItem(item: retrievedGradientColors, forKey: GRADIENT_COLORS_KEY)
            }
            //getting gradient activity
            let retrievedGradientActivity = UserDefaults.standard.colorItemForKey(key: GRADIENT_ACTIVE_KEY) as? Bool ?? false
            
            //getting image activity
            let retrievedImageActivity = UserDefaults.standard.bool(forKey: IMAGE_ACTIVE_KEY)
            
            //getting image index
            let retrievedImageIndex = UserDefaults.standard.integer(forKey: IMAGE_INDEX_KEY)
            
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
            gradientActive = retrievedGradientActivity
            gradientColors = retrievedGradientColors
            imageActive = retrievedImageActivity
            imageIndex = retrievedImageIndex
        }
    }
    
    //casovac pre vypnutie
    struct ShutdownTimer {
        var hours: Int
        var minutes: Int
        var seconds: Int
        var timerBeforeExit: Timer?
    }
    
    //prechod farieb
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
        changeTimerTabVisibility(isHidden: true)
        changeFlowModeTabVisibility(isHidden: true)
        
        //setting gradients
        gradientColor1Button.layer.cornerRadius = 10.0
        gradientColor2Button.layer.cornerRadius = 10.0
        if userData != nil {
            gradientColor1Button.backgroundColor = userData!.gradientColors[0]
            gradientColor2Button.backgroundColor = userData!.gradientColors[1]
            gradientSwitch.isOn = userData!.gradientActive
            if gradientSwitch.isOn {
                turnOnGradient()
            }
        }else{
            gradientColor1Button.backgroundColor = DEFAULT_COLOR
            gradientColor2Button.backgroundColor = DEFAULT_COLOR
            gradientSwitch.isOn = false
        }
        changeByGradientOrImageActivity()
        
        //setting image
        imageThumbnail.layer.cornerRadius = 10.0
        if userData != nil {
            imageSwitch.isOn = userData!.imageActive
            if imageSwitch.isOn {
                turnOnImage()
                changeByGradientOrImageActivity()
            }
            imageThumbnail.image = getImage(index: userData!.imageIndex)
        }else{
            imageThumbnail.image = UIImage(named: DEFAULT_IMAGE_NAME)!
        }
        
        //setting timer tab values
        if userData != nil {
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
        self.view.layoutIfNeeded()
        setStatusBarDependingBackgroundColorBrightness()
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
    
    //zmeny pri otoceni zariadenia
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setBrightnessSliderOrientation()
        coordinator.animate(alongsideTransition: nil) { _ in
            if self.gradientSwitch.isOn {
                if self.flowMode != nil {
                    if self.flowMode!.active == false {
                        self.view.layer.sublayers?.remove(at: 0)
                        self.turnOnGradient()
                    }
                }
            }
        }
    }
    
    //prisposobenie farby status baru podla farby pozadia
    func setStatusBarDependingBackgroundColorBrightness(){
        var cgColor = DEFAULT_COLOR.cgColor
        if gradientSwitch.isOn {
            if flowMode != nil{
                if flowMode!.active == false {
                    cgColor = gradientColor1Button.backgroundColor!.cgColor
                }else{
                    cgColor = self.view.backgroundColor!.cgColor
                }
            }
        }else{
            cgColor = self.view.backgroundColor!.cgColor
        }
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
        if imageSwitch.isOn {
            if flowMode != nil{
                if flowMode!.active == false {
                    UIApplication.shared.statusBarStyle = .lightContent
                }
            }
        }
    }
    
    //prisposobenie slideru pre nastavenie jasu podla orientacie na vysku alebo sirku
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
    
    //zmena sirky menu a prvkov podla toho ci je zvoleny gradient alebo obrazok
    func changeByGradientOrImageActivity() {
        if gradientSwitch.isOn {
            colorViewHeight.constant = CGFloat(COLOR_PICKING_HEIGHT_ACTIVE_GRADIENT_OR_IMAGE)
            imageThumbnail.isHidden = true
            changeImageButton.isHidden = true
            imageUseLabelTopConstraint.constant = 65
            imageSwitchBottomConstraint.constant = 20
            gradientColor1Label.isHidden = false
            gradientColor1Button.isHidden = false
            gradientColor2Label.isHidden = false
            gradientColor2Button.isHidden = false
        }else{
            if imageSwitch.isOn {
                colorViewHeight.constant = CGFloat(COLOR_PICKING_HEIGHT_ACTIVE_GRADIENT_OR_IMAGE)
                imageThumbnail.isHidden = false
                changeImageButton.isHidden = false
                imageSwitchBottomConstraint.constant = 60
            }else{
                colorViewHeight.constant = CGFloat(COLOR_PICKING_HEIGHT_ACTIVE_BASIC_COLOR)
                imageSwitchBottomConstraint.constant = 20
                imageThumbnail.isHidden = true
                changeImageButton.isHidden = true
            }
            imageUseLabelTopConstraint.constant = 15
            gradientColor1Label.isHidden = true
            gradientColor1Button.isHidden = true
            gradientColor2Label.isHidden = true
            gradientColor2Button.isHidden = true
        }
    }
    
    //zmena menu podla zvolenej moznosti
    @IBAction func choiceChanged(_ sender: Any) {
        switch choiceButtons.selectedSegmentIndex {
        case COLOR_TAB:
            changeColorTabVisibility(isHidden: false)
            
            changeTimerTabVisibility(isHidden: true)
            changeFlowModeTabVisibility(isHidden: true)
            changeByGradientOrImageActivity()
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
    
    //prisposobenie viditelnosti menu prechodu farieb podla toho ci bolo zvolene
    func changeFlowModeTabVisibility(isHidden: Bool) {
        for button in arrayOfFlowModeColorsButtons {
            button.isHidden = isHidden
        }
        colorPickerButtonFlowMode.isHidden = isHidden
        flowSpeedLabel.isHidden = isHidden
        flowSpeedSlider.isHidden = isHidden
        colorLabel.isHidden = isHidden
        startFlowModeButton.isHidden = isHidden
        infoFlowModeButton.isHidden = isHidden
        
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
    
    //prisposobenie viditelnosti menu casovaca podla toho ci bolo zvolene
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
        infoTimerButton.isHidden = isHidden
    }
    
    //prisposobenie viditelnosti menu farby pozadia podla toho ci bolo zvolene
    func changeColorTabVisibility(isHidden: Bool){
        recentlyUsedColorsView.isHidden = isHidden
        recentlyUsedLabel.isHidden = isHidden
        colorPickerButton.isHidden = isHidden
        gradientSwitch.isHidden = isHidden
        gradientUseLabel.isHidden = isHidden
        gradientColor1Button.isHidden = isHidden
        gradientColor2Button.isHidden = isHidden
        gradientColor1Label.isHidden = isHidden
        gradientColor2Label.isHidden = isHidden
        infoColorsButton.isHidden = isHidden
        imageSwitch.isHidden = isHidden
        imageUseLabel.isHidden = isHidden
        imageThumbnail.isHidden = isHidden
        changeImageButton.isHidden = isHidden
    }
    
    // MARK: Color tab functions
    
    @IBAction func gradientActiveValueChanged(_ sender: Any) {
        if userData != nil {
            userData!.gradientActive = gradientSwitch.isOn
        }
        defaults.setColorItem(item: gradientSwitch.isOn, forKey: GRADIENT_ACTIVE_KEY)
        changeByGradientOrImageActivity()
        if gradientSwitch.isOn {
            turnOnGradient()
            turnOffImage()
        }else{
            if flowMode != nil {
                if flowMode!.active == false {
                    self.view.layer.sublayers?.remove(at: 0)
                }
            }
        }
        if flowMode != nil {
            if flowMode!.active {
                stopFlowMode()
            }
        }
        setStatusBarDependingBackgroundColorBrightness()
    }
    
    func turnOffGradient() {
        if gradientSwitch.isOn {
            gradientSwitch.setOn(false, animated: true)
            if userData != nil {
                userData!.gradientActive = gradientSwitch.isOn
            }
            defaults.setColorItem(item: gradientSwitch.isOn, forKey: GRADIENT_ACTIVE_KEY)
            changeByGradientOrImageActivity()
            if flowMode != nil {
                if flowMode!.active == false {
                    self.view.layer.sublayers?.remove(at: 0)
                }
            }
        }
    }
    
    @IBAction func gradientColor1ButtonPressed(_ sender: Any) {
        gradientColorToChange = 0
        if flowMode != nil {
            if flowMode!.active {
                turnOnGradient()
            }
        }
        stopFlowMode()
        if userData != nil {
            colorPicker.selectedColor = userData!.gradientColors[0]
        }else{
            colorPicker.selectedColor = DEFAULT_COLOR
        }
        colorPicker.supportsAlpha = false
        present(colorPicker, animated: true)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @IBAction func gradientColor2ButtonPressed(_ sender: Any) {
        gradientColorToChange = 1
        if flowMode != nil {
            if flowMode!.active {
                turnOnGradient()
            }
        }
        stopFlowMode()
        if userData != nil {
            colorPicker.selectedColor = userData!.gradientColors[1]
        }else{
            colorPicker.selectedColor = DEFAULT_COLOR
        }
        colorPicker.supportsAlpha = false
        present(colorPicker, animated: true)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func turnOnGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [gradientColor1Button.backgroundColor?.cgColor, gradientColor2Button.backgroundColor?.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func imageSwitchValueChanged(_ sender: Any) {
        if imageSwitch.isOn {
            turnOnImage()
        }else{
            backgroundImageView.isHidden = true
            defaults.set(imageSwitch.isOn, forKey: IMAGE_ACTIVE_KEY)
            setStatusBarDependingBackgroundColorBrightness()
        }
        turnOffGradient()
        stopFlowMode()
        changeByGradientOrImageActivity()
    }
    
    func turnOffImage(){
        if imageSwitch.isOn {
            imageSwitch.setOn(false, animated: true)
            backgroundImageView.isHidden = true
            if userData != nil {
                userData!.imageActive = imageSwitch.isOn
            }
            defaults.set(imageSwitch.isOn, forKey: IMAGE_ACTIVE_KEY)
            changeByGradientOrImageActivity()
        }
    }
    
    //zobrazi obrazok na pozadi
    func turnOnImage() {
        if userData != nil {
            backgroundImageView.image = getImage(index: userData!.imageIndex)
            userData!.imageActive = imageSwitch.isOn
        }else{
            backgroundImageView.image = UIImage(named: DEFAULT_IMAGE_NAME)!
        }
        backgroundImageView.isHidden = false
        defaults.set(imageSwitch.isOn, forKey: IMAGE_ACTIVE_KEY)
        setStatusBarDependingBackgroundColorBrightness()
    }
    
    func getImage(index: Int) -> UIImage {
        switch index {
        case 0:
            return UIImage(named: "background_image_1")!
        case 1:
            return UIImage(named: "background_image_2")!
        case 2:
            return UIImage(named: "background_image_3")!
        case 3:
            return UIImage(named: "background_image_4")!
        case 4:
            return UIImage(named: "background_image_5")!
        case 5:
            return UIImage(named: "background_image_6")!
        case 6:
            return UIImage(named: "background_image_7")!
        case 7:
            return UIImage(named: "background_image_8")!
        case 8:
            return UIImage(named: "background_image_9")!
        case 9:
            return UIImage(named: "background_image_10")!
        case 10:
            return UIImage(named: "background_image_11")!
        case 11:
            return UIImage(named: "background_image_12")!
        case 12:
            return UIImage(named: "background_image_13")!
        case 13:
            return UIImage(named: "background_image_14")!
        case 14:
            return UIImage(named: "background_image_15")!
        default:
            return UIImage(named: DEFAULT_IMAGE_NAME)!
        }
    }
    
    func saveImage(imageIndex: Int) {
        if userData != nil {
            userData!.imageIndex = imageIndex
        }
        defaults.set(imageIndex, forKey: IMAGE_INDEX_KEY)
        imageThumbnail.image = getImage(index: imageIndex)
        turnOnImage()
    }
    
    @IBAction func changeImageButtonPressed(_ sender: Any) {
        turnOnImage()
        turnOffGradient()
        stopFlowMode()
        changeByGradientOrImageActivity()
    }
  
    //otvara sa paleta farieb pre jednofarebne pozadie
    @IBAction func openColorPicker(_ sender: Any) {
        turnOffGradient()
        turnOffImage()
        stopFlowMode()
        colorPicker.supportsAlpha = false
        colorPicker.selectedColor = self.view.backgroundColor!
        present(colorPicker, animated: true)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    //akcie nastavane pri zatvoreni palety farieb
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        if choiceButtons.selectedSegmentIndex == COLOR_TAB {
            if gradientSwitch.isOn {
                if gradientColorToChange != NOT_ASSIGNED_VALUE {
                    if gradientColorToChange == 0 {
                        gradientColor1Button.backgroundColor = colorPicker.selectedColor
                        userData?.gradientColors[0] = colorPicker.selectedColor
                    }else{
                        gradientColor2Button.backgroundColor = colorPicker.selectedColor
                        userData?.gradientColors[1] = colorPicker.selectedColor
                    }
                    defaults.setColorItem(item: userData?.gradientColors, forKey: GRADIENT_COLORS_KEY)
                    self.view.layer.sublayers?.remove(at: 0)
                    turnOnGradient()
                }
            }else{
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
    
    //nastavi farbu tlacidlam pre naposledy zvolene farby
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
    
    //ak je menej ako 5 naposledy zvolených farieb tak nepouzite tlacidla skryje
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
        setBackgroundColorForRecentlyUsedColorButton(indexOfButton: RECENTLY_USED_COLORS_FIRST_BUTTON_INDEX)
    }
    
    @IBAction func recentlyUsedColorButton2Pressed(_ sender: Any) {
        setBackgroundColorForRecentlyUsedColorButton(indexOfButton: RECENTLY_USED_COLORS_SECOND_BUTTON_INDEX)
    }
    
    @IBAction func recentlyUsedColorButton3Pressed(_ sender: Any) {
        setBackgroundColorForRecentlyUsedColorButton(indexOfButton: RECENTLY_USED_COLORS_THIRD_BUTTON_INDEX)
    }
    
    @IBAction func recentlyUsedColorButton4Pressed(_ sender: Any) {
        setBackgroundColorForRecentlyUsedColorButton(indexOfButton: RECENTLY_USED_COLORS_FOURTH_BUTTON_INDEX)
    }
    
    @IBAction func recentlyUsedColorButton5Pressed(_ sender: Any) {
        setBackgroundColorForRecentlyUsedColorButton(indexOfButton: RECENTLY_USED_COLORS_FIFTH_BUTTON_INDEX)
    }
    
    func setBackgroundColorForRecentlyUsedColorButton(indexOfButton: Int) {
        self.view.backgroundColor = arrayOfRecentlyUsedColorsButtons[indexOfButton].backgroundColor
        if userData != nil {
            userData!.oneColorLight = arrayOfRecentlyUsedColorsButtons[indexOfButton].backgroundColor!
        }
        turnOffGradient()
        turnOffImage()
        stopFlowMode()
        defaults.setColorItem(item: arrayOfRecentlyUsedColorsButtons[indexOfButton].backgroundColor, forKey: ONE_COLOR_LIGHT_KEY)
        setStatusBarDependingBackgroundColorBrightness()
    }
    
    //zobrazi informacie o vybere farby pozadia
    @IBAction func infoColorsPressed(_ sender: Any) {
        let alert = UIAlertController(title: COLOR_INFO_TITLE, message: COLOR_INFO_TEXT, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
    
    //vypisovanie zostavajuceho casu
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
    
    //vypocet kazdu sekundu pre zostavajuci cas
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
    
    //zapnutie a vypnutie casovacu
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
    
    @IBAction func infoTimer(_ sender: Any) {
        let alert = UIAlertController(title: TIMER_INFO_TITLE, message: TIMER_INFO_TEXT, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Flow mode functions
    
    //priradi spravne farby pre tlacidla farieb
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
    
    //rusi casovac ktory vchadzal do funkcie pre prechod medzi farbami
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
    
    //zapnutie a vpynutie prechodu farieb
    @IBAction func startButtonFlowModePressed(_ sender: Any) {
        if flowMode != nil {
            if flowMode!.active == false {
                if gradientSwitch.isOn {
                    self.view.layer.sublayers?.remove(at: 0)
                }
                backgroundImageView.isHidden = true
                startFlowModeButton.setImage(UIImage(systemName: "stop.fill"), for: UIControl.State.normal)
                startFlowModeButton.tintColor = .systemRed
                flowMode!.active = true
                let speed = 0.06
                flowMode!.enteredTimes = 0
                flowMode!.timer = Timer.scheduledTimer(timeInterval: TimeInterval(speed), target: self, selector: #selector(flowingColors), userInfo: nil, repeats: true)
                flowMode!.indexOfColor = 4
                flowingColors()
            }else{
                if gradientSwitch.isOn {
                    turnOnGradient()
                }
                stopFlowMode()
                if imageSwitch.isOn {
                    backgroundImageView.isHidden = false
                    setStatusBarDependingBackgroundColorBrightness()
                }
            }
        }
    }
    
    //prechadza medzi farbami podla casu
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
    
    //otvara paletu farieb pre nastavenie farby pre prechod medzi nimi
    @IBAction func openColorpickerFlowMode(_ sender: Any) {
        colorPicker.supportsAlpha = false
        if flowMode != nil {
            colorPicker.selectedColor = arrayOfFlowModeColorsButtons[flowMode!.changedColorIndex].backgroundColor!
        }
        present(colorPicker, animated: true)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    //zobrazenie informacii pre prechod medzi farbami
    @IBAction func infoFlowMode(_ sender: Any) {
        let alert = UIAlertController(title: FLOW_MODE_INFO_TITLE, message: FLOW_MODE_INFO_TEXT, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIColor {

    //tmavnutie a zosvetlovanie farieb
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

//pristup a ukladanie dat
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
