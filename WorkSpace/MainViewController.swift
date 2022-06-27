//
//  ViewController.swift
//  WorkSpace
//
//  Created by JHMB on 2022/06/23.
//

import UIKit
import CoreLocation
import PhotosUI
import WidgetKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var changeBackgroundButton: UIButton!
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var backgroundResetButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var textBlackButton: UIButton!
    @IBOutlet weak var textWhiteButton: UIButton!
    
    var locationManager = CLLocationManager()
    let userDefaults = UserDefaults(suiteName: "group.com.jihaWeather")
    
    lazy var ex1: UIView = {
        let view = Example1View(frame: CGRect(x: self.view.frame.width/2 - 155.0/2.0, y: self.scrollView.frame.height/2 - 155.0/2.0, width: 155, height: 155))
        return view
    }()
    
    lazy var ex2: UIView = {
        let view = Example2View(frame: CGRect(x: self.view.frame.width/2 - 155.0/2.0, y: self.scrollView.frame.height/2 - 155.0/2.0, width: 155, height: 155))
        return view
    }()
    
    lazy var ex3: UIView = {
        let view = Example3View(frame: CGRect(x: self.view.frame.width/2 - 155.0/2.0, y: self.scrollView.frame.height/2 - 155.0/2.0, width: 155, height: 155))
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocationManager()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch self.locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            break
        case .restricted, .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {return}
            
            let sheet = UIAlertController(title: "location information needed", message: "move to option?", preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }))
            sheet.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            present(sheet, animated: true)
        @unknown default:
            return
        }
    }
    
    @IBAction func changBackgroundButtonTapped(_ sender: UIButton) {
        self.openCameraroll()
    }
    
    @IBAction func backgroundResetButtonTapped(_ sender: UIButton) {
        self.saveImage(image: UIImage.imageWithColor(color: .white)!)
        self.rememberBackgroundImage()
    }
    
    @IBAction func textWhiteButtonTapped(_ sender: UIButton) {
        self.textWhite()
        self.userDefaults?.setValue("white", forKey: "textColor")
    }
    
    @IBAction func textBlackButtonTapped(_ sender: UIButton) {
        self.textBlack()
        self.userDefaults?.setValue("black", forKey: "textColor")
    }
    
    func openCameraroll() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func setLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 20
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        else {
            print("위치 서비스 허용 off")
        }
    }
    
    func callAPI(lat: Double, lon: Double) {
        WeatherAPI().getCurrentWeather(
            lat: lat,
            lon: lon,
            success: { respons in
                print(respons)
                self.userDefaults?.setValue(respons.weather.first?.main, forKey: "currentWeather")
                self.userDefaults?.setValue("\(Int(respons.main.temp - 273.15))℃", forKey: "currentTempt")
                self.userDefaults?.setValue("\(Int(respons.main.temp_max - 273.15))℃", forKey: "maxTempt")
                self.userDefaults?.setValue("\(Int(respons.main.temp_min - 273.15))℃", forKey: "minTempt")
                self.userDefaults?.setValue(respons.sys.country, forKey: "countryName")
                self.userDefaults?.setValue(respons.name, forKey: "cityName")
                WidgetCenter.shared.reloadAllTimelines()
                guard let ex1 = self.ex1 as? Example1View else {return}
                guard let ex2 = self.ex2 as? Example2View else {return}
                guard let ex3 = self.ex3 as? Example3View else {return}
                DispatchQueue.main.async {
                    ex1.getInfo(weatherInfo: respons)
                    ex2.getInfo(weatherInfo: respons)
                    ex3.getInfo(weatherInfo: respons)
                }
            },
            failure: { error in
                print(error)
            }
        )
    }
    
    func setup() {
        self.scrollView.delegate = self
        let exampleViews = [ex1, ex2, ex3]
        
        // scrollView
        for i in 0...2 {
            let subView = UIView(frame: CGRect(x: CGFloat(i) * self.view.frame.width,
                                               y: 0,
                                               width: self.view.frame.width,
                                               height: self.scrollView.frame.height))
            
            contentsView.addSubview(subView)
            
            if i == 2 {
                subView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor).isActive = true
            }
            
            subView.addSubview(exampleViews[i])
        }
        
        self.changeBackgroundButton.layer.cornerRadius = 8
        self.backgroundResetButton.layer.cornerRadius = 8
        self.textWhiteButton.layer.cornerRadius = 8
        self.textBlackButton.layer.cornerRadius = 8
        self.navigationColorChange()
        self.pageControl.isUserInteractionEnabled = false
        self.pageControl.numberOfPages = exampleViews.count
        self.rememberBackgroundImage()
        self.rememberTextColor()
    }
    
    func navigationColorChange() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    func rememberBackgroundImage() {
        guard let ex1 = self.ex1 as? Example1View else {return}
        guard let ex2 = self.ex2 as? Example2View else {return}
        guard let ex3 = self.ex3 as? Example3View else {return}
        let data = self.userDefaults?.object(forKey: "selectedImage")
        let backgroundImage = self.loadImage(data: data as? Data)
        ex1.backgroundImageView.image = backgroundImage
        ex1.backgroundImageView.layer.cornerRadius = 22
        ex2.backgroundImageView.image = backgroundImage
        ex2.backgroundImageView.layer.cornerRadius = 22
        ex3.backgroundImageView.image = backgroundImage
        ex3.backgroundImageView.layer.cornerRadius = 22
    }
    
    func textWhite() {
        guard let ex1 = self.ex1 as? Example1View else {return}
        guard let ex2 = self.ex2 as? Example2View else {return}
        guard let ex3 = self.ex3 as? Example3View else {return}
        ex1.changeTextWhite()
        ex2.changeTextWhite()
        ex3.changeTextWhite()
    }
    
    func textBlack() {
        guard let ex1 = self.ex1 as? Example1View else {return}
        guard let ex2 = self.ex2 as? Example2View else {return}
        guard let ex3 = self.ex3 as? Example3View else {return}
        ex1.changeTextBlack()
        ex2.changeTextBlack()
        ex3.changeTextBlack()
    }
    
    func rememberTextColor() {
        let textColor = self.userDefaults?.string(forKey: "textColor")
        if textColor == "white" {
            self.textWhite()
        } else if textColor == "black" {
            self.textBlack()
        } else {
            self.textBlack()
        }
    }
}
