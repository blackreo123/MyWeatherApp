//
//  Example1View.swift
//  WorkSpace
//
//  Created by JHMB on 2022/06/23.
//

import UIKit

class Example1View: UIView {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var countryName: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    func commonInit() {
        if let view = Bundle.main.loadNibNamed("Example1", owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            view.layer.cornerRadius = 22
            view.backgroundColor = .white
            view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
            view.layer.shadowOpacity = 1
            view.layer.shadowRadius = 24
            addSubview(view)
        }
    }
    
    func getInfo(weatherInfo: WeatherInfo) {
        switch weatherInfo.weather[0].main {
        case WeatherType.clear.rawValue:
            self.weatherImageView.image = UIImage(named: "sunny")
        case WeatherType.rain.rawValue:
            self.weatherImageView.image = UIImage(named: "rain")
        case WeatherType.snow.rawValue:
            self.weatherImageView.image = UIImage(named: "snow")
        case WeatherType.cloud.rawValue:
            self.weatherImageView.image = UIImage(named: "cloud")
        default:
            self.weatherImageView.image = UIImage(named: "cloudSunny")
        }
        self.cityName.text = weatherInfo.name
        self.countryName.text = weatherInfo.sys.country
    }
    
    func changeBackgroundImage(image: UIImage) {
        self.backgroundImageView.image = image
        self.backgroundImageView.layer.cornerRadius = 22
    }
    
    func changeTextWhite() {
        self.cityName.textColor = .white
        self.countryName.textColor = .white
    }
    
    func changeTextBlack() {
        self.cityName.textColor = .black
        self.countryName.textColor = .black
    }
}
