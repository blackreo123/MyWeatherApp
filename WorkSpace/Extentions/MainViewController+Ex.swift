//
//  MainViewController+Ex.swift
//  WorkSpace
//
//  Created by JHMB on 2022/06/25.
//

import Foundation
import CoreLocation
import UIKit
import PhotosUI

extension MainViewController {
    func weatherInfoToJSON(watherInfo: WeatherInfo) -> String {
        do {
            let jsonData = try JSONEncoder().encode(watherInfo)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            return jsonString
        } catch {
            print(error)
        }
        return ""
    }
    
    func saveImage(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        let encoded = try! PropertyListEncoder().encode(data)
        self.userDefaults?.setValue(encoded, forKey: "selectedImage")
    }
    
    func loadImage(data: Data?) -> UIImage{
        guard let data = data else { return UIImage() }
        let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
        let image = UIImage(data: decoded) ?? UIImage()
        return image
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location: CLLocation = locations[locations.count - 1]
        let longtitude: CLLocationDegrees = location.coordinate.longitude
        let latitude:CLLocationDegrees = location.coordinate.latitude
        
        self.callAPI(lat: latitude, lon: longtitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            getLocationUsagePermission()
        case .denied:
            print("GPS 권한 요청 거부됨")
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
        default:
            print("GPS: Default")
        }
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(floor(scrollView.contentOffset.x / UIScreen.main.bounds.width))
        self.userDefaults?.setValue(self.pageControl.currentPage, forKey: "currentPage")
    }
}

extension MainViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           
            itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                
                guard let selectedImgage = image as? UIImage else {return}
                DispatchQueue.main.sync {
                    guard let ex1 = self.ex1 as? Example1View else {return}
                    guard let ex2 = self.ex2 as? Example2View else {return}
                    guard let ex3 = self.ex3 as? Example3View else {return}
                    ex1.changeBackgroundImage(image: selectedImgage)
                    ex2.changeBackgroundImage(image: selectedImgage)
                    ex3.changeBackgroundImage(image: selectedImgage)
                    self.saveImage(image: selectedImgage)
                }
            }
        }
    }
    
    
}
