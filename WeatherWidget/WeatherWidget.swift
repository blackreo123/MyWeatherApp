//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by JHMB on 2022/06/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), currentWeather: "", currentTempt: "", maxTempt: "", minTempt: "", countryName: "", cityName: "", widgetType: 0, selectedImage: UIImage(), textColor: "black")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), currentWeather: "", currentTempt: "", maxTempt: "", minTempt: "", countryName: "", cityName: "", widgetType: 0, selectedImage: UIImage(), textColor: "black")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let userDefaults = UserDefaults(suiteName: "group.com.jihaWeather")
        let currentWeather = userDefaults?.string(forKey: "currentWeather")
        let currentTempt = userDefaults?.string(forKey: "currentTempt")
        let maxTempt = userDefaults?.string(forKey: "maxTempt")
        let minTempt = userDefaults?.string(forKey: "minTempt")
        let countryName = userDefaults?.string(forKey: "countryName")
        let cityName = userDefaults?.string(forKey: "cityName")
        let widgetType = userDefaults?.integer(forKey: "currentPage")
        let selectedImage = userDefaults?.object(forKey: "selectedImage")
        let textColor = userDefaults?.string(forKey: "textColor")
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(
                date: entryDate,
                currentWeather: currentWeather ?? "",
                currentTempt: currentTempt ?? "",
                maxTempt: maxTempt ?? "",
                minTempt: minTempt ?? "",
                countryName: countryName ?? "",
                cityName: cityName ?? "",
                widgetType: widgetType ?? 0,
                selectedImage: loadImage(data: selectedImage as? Data),
                textColor: textColor ?? "black"
            )
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .after(Date(timeIntervalSinceNow: 60)))
        completion(timeline)
    }
    
    func loadImage(data: Data?) -> UIImage{
        guard let data = data else { return UIImage() }
        let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
        let image = UIImage(data: decoded) ?? UIImage()
        return image
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let currentWeather: String
    let currentTempt: String
    let maxTempt: String
    let minTempt: String
    let countryName: String
    let cityName: String
    let widgetType: Int
    let selectedImage: UIImage
    let textColor: String
}

struct WeatherWidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        switch entry.textColor {
        case "white":
            setView(entry: entry).foregroundColor(.white)
        default:
            setView(entry: entry).foregroundColor(.black)
        }
    }
}

struct setView: View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Image(uiImage: entry.selectedImage)
                .resizable()
            switch entry.widgetType {
            case 0:
                Ex1View(entry: entry)
            case 1:
                Ex2View(entry: entry)
            case 2:
                Ex3View(entry: entry)
            default:
                Ex1View(entry: entry)
            }
        }
    }
}

struct Ex1View: View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    var body: some View {
        switch family {
        case .systemSmall:
            VStack {
                showWeatherImage(currnetWeather: entry.currentWeather)
                    .resizable()
                    .frame(width: 67, height: 67)
                VStack(spacing: 0) {
                    Text(entry.cityName)
                        .frame(width: 123, height: 23, alignment: .leading)
                        .font(.system(size: 18, weight: .semibold, design: .default))
                    
                    Text(entry.countryName)
                        .frame(width: 123, height: 23, alignment: .leading)
                        .font(.system(size: 18, weight: .semibold, design: .default))
                }
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            
        case .systemMedium:
            VStack(alignment: .leading) {
                showWeatherImage(currnetWeather: entry.currentWeather)
                    .resizable()
                    .frame(width: 82, height: 82)
                    .padding(.leading)
                Text("\(entry.cityName), \(entry.countryName)")
                    .frame(alignment: .leading)
                    .font(.system(size: 24, weight: .semibold, design: .default))
                    .padding(.leading)
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
            
        case .systemLarge:
            VStack {
                showWeatherImage(currnetWeather: entry.currentWeather)
                    .resizable()
                    .frame(width: 115, height: 115)
                    .padding(EdgeInsets(top: 48, leading: 0, bottom: 0, trailing: 0))
                VStack(spacing: 0) {
                    Text(entry.cityName)
                        .frame(width: 297, height: 42, alignment: .leading)
                        .font(.system(size: 32, weight: .semibold, design: .default))
                    Text(entry.countryName)
                        .frame(width: 297, height: 42, alignment: .leading)
                        .font(.system(size: 32, weight: .semibold, design: .default))
                    
                }.padding(EdgeInsets(top: 48, leading: 0, bottom: 0, trailing: 0))
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        default:
            Text("may be new size in the mirai")
        }
    }
}

struct Ex2View: View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    var body: some View {
        switch family {
        case .systemSmall:
            VStack {
                Text(entry.cityName)
                    .font(.system(size: 17, weight: .regular, design: .default))
                    .frame(width: 137, height: 21, alignment: .leading)
                Text(entry.currentTempt)
                    .font(.system(size: 32, weight: .heavy, design: .default))
                    .frame(width: 137, height: 38.5, alignment: .leading)
                HStack {
                    showWeatherImage(currnetWeather: entry.currentWeather)
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                    Spacer()
                }
                
                Text("max: \(entry.maxTempt) min: \(entry.minTempt)")
                    .font(.system(size: 12, weight: .regular, design: .default))
                    .frame(width: 137, height: 14.5, alignment: .leading)
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            
        case .systemMedium:
            VStack(alignment: .leading) {
                HStack {
                    showWeatherImage(currnetWeather: entry.currentWeather)
                        .resizable()
                        .frame(width: 82, height: 82)
                        .padding(.leading)
                    VStack {
                        Text("max:\(entry.maxTempt)")
                        Text("min:\(entry.minTempt)")
                    }
                    Text(entry.currentTempt)
                        .font(.system(size: 36, weight: .black, design: .default))
                }
                
                Text("\(entry.cityName), \(entry.countryName)")
                    .frame(alignment: .leading)
                    .font(.system(size: 24, weight: .semibold, design: .default))
                    .padding(.leading)
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
            
        case .systemLarge:
            VStack {
                Text(entry.cityName)
                    .font(.system(size: 24, weight: .regular, design: .default))
                    .frame(width: 200, height: 21, alignment: .center)
                Text(entry.currentTempt)
                    .font(.system(size: 64, weight: .heavy, design: .default))
                    .frame(width: 200, height: 38.5, alignment: .center)
                
                    showWeatherImage(currnetWeather: entry.currentWeather)
                        .resizable()
                        .frame(width: 64, height: 64)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                
                Text("max: \(entry.maxTempt) min: \(entry.minTempt)")
                    .font(.system(size: 17, weight: .regular, design: .default))
                    .frame(width: 200, height: 14.5, alignment: .center)
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        default:
            Text("may be new size in the mirai")
        }
    }
}

struct Ex3View: View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    var body: some View {
        switch family {
        case .systemSmall:
            VStack {
                Text(entry.currentTempt)
                    .font(.system(size: 42, weight: .black, design: .default))
                    .frame(width: 137, height: 52, alignment: .center)
                Text("max: \(entry.maxTempt) min: \(entry.minTempt)")
                    .font(.system(size: 12, weight: .regular, design: .default))
                    .frame(width: 137, height: 14.5, alignment: .center)
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            
        case .systemMedium:
            VStack(alignment: .center) {
                HStack {
                    Text(entry.currentTempt)
                        .font(.system(size: 36, weight: .black, design: .default))
                    VStack {
                        Text("max:\(entry.maxTempt)")
                        Text("min:\(entry.minTempt)")
                    }
                }
                
                Text("\(entry.cityName), \(entry.countryName)")
                    .frame(alignment: .leading)
                    .font(.system(size: 24, weight: .semibold, design: .default))
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            
        case .systemLarge:
            VStack {
                showWeatherImage(currnetWeather: entry.currentWeather)
                    .resizable()
                    .frame(width: 100, height: 100)
                Text(entry.cityName)
                    .font(.system(size: 24, weight: .regular, design: .default))
                    .frame(width: 200, height: 21, alignment: .center)
                Text(entry.currentTempt)
                    .font(.system(size: 64, weight: .heavy, design: .default))
                    .frame(width: 200, height: 38.5, alignment: .center)
                Text("max: \(entry.maxTempt) min: \(entry.minTempt)")
                    .font(.system(size: 17, weight: .regular, design: .default))
                    .frame(width: 200, height: 14.5, alignment: .center)
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        default:
            Text("may be new size in the mirai")
        }
    }
}

func showWeatherImage(currnetWeather: String) -> Image {
    switch currnetWeather {
    case "Clear":
        return Image("sunny")
    case "Rain":
        return Image("rain")
    case "Snow":
        return Image("snow")
    case "Clouds":
        return Image("cloud")
    default:
        return Image("cloudSunny")
    }
}

@main
struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WeatherWidgetEntryView(entry: SimpleEntry(date: Date(), currentWeather: "", currentTempt: "", maxTempt: "", minTempt: "", countryName: "", cityName: "", widgetType: 0, selectedImage: UIImage(), textColor: "black"))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
