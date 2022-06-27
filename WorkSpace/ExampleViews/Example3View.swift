//
//  Example3View.swift
//  WorkSpace
//
//  Created by JHMB on 2022/06/23.
//

import Foundation
import UIKit

class Example3View: UIView {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var currentTempt: UILabel!
    @IBOutlet weak var maxTempt: UILabel!
    @IBOutlet weak var minTempt: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    func commonInit() {
        
        if let view = Bundle.main.loadNibNamed("Example3", owner: self, options: nil)?.first as? UIView {
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
        self.currentTempt.text = "\(Int(weatherInfo.main.temp - 273.15))℃"
        self.maxTempt.text = "max:\(Int(weatherInfo.main.temp_max - 273.15))℃"
        self.minTempt.text = "min:\(Int(weatherInfo.main.temp_min - 273.15))℃"
    }
    
    func changeBackgroundImage(image: UIImage) {
        self.backgroundImageView.image = image
        self.backgroundImageView.layer.cornerRadius = 22
    }
    
    func changeTextWhite() {
        self.maxTempt.textColor = .white
        self.currentTempt.textColor = .white
        self.minTempt.textColor = .white
    }
    
    func changeTextBlack() {
        self.maxTempt.textColor = .black
        self.currentTempt.textColor = .black
        self.minTempt.textColor = .black
    }
}
