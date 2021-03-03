//Created for churchApp  (26.09.2020 )
 
import UIKit

extension Date {
    func yearsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(NSCalendar.Unit.year, from: date, to: self, options: []).year!
    }
    func monthsFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(NSCalendar.Unit.month, from: date, to: self, options: []).month!
    }
    func weeksFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(NSCalendar.Unit.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    func daysFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(NSCalendar.Unit.day, from: date, to: self, options: []).day!
    }
//    func hoursFrom(_ date:Date) -> Int {
//        return (Calendar.current as NSCalendar).components(NSCalendar.Unit.hour, from: date, to: self, options: []).hour!
//    }
//    func minutesFrom(_ date:Date) -> Int{
//        return (Calendar.current as NSCalendar).components(NSCalendar.Unit.minute, from: date, to: self, options: []).minute!
//    }
//    func secondsFrom(_ date:Date) -> Int{
//        return (Calendar.current as NSCalendar).components(NSCalendar.Unit.second, from: date, to: self, options: []).second!
//    }
    func offsetFrom(_ date:Date) -> String {
        if yearsFrom(date)   > 1 { return "\(yearsFrom(date)) years ago"   }
        if yearsFrom(date)   == 1 { return "\(yearsFrom(date)) year ago"   }
        if monthsFrom(date)  > 1 { return "\(monthsFrom(date)) months ago"  }
        if monthsFrom(date)  == 1 { return "\(monthsFrom(date)) month ago"  }
        if weeksFrom(date)   > 1 { return "\(weeksFrom(date)) weeks ago"   }
        if weeksFrom(date)   == 1 { return "\(weeksFrom(date)) week ago"   }
        if daysFrom(date)    > 1 { return "\(daysFrom(date)) days ago"    }
        if daysFrom(date)    == 1 { return "\(daysFrom(date)) day ago"    }
        if hoursFrom(date)   > 1 { return "\(hoursFrom(date)) hours ago"   }
        if hoursFrom(date)   == 1 { return "\(hoursFrom(date)) hour ago"   }
        if minutesFrom(date) > 1 { return "\(minutesFrom(date)) minutes ago" }
        if minutesFrom(date) == 1 { return "\(minutesFrom(date)) minute ago" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date)) seconds ago" }
        return ""
    }
    
    var fts_dateStringForAPI: String {
        let dateFormatter = DateFormatter.fts_dateFormatterForClientToAPI
        return dateFormatter.string(from: self)
    }
}

extension DateFormatter {
    class var fts_dateFormatterForClientToAPI: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter
    }
}

extension Int {
    var fts_yearsAgo: Date? {
        var components = DateComponents()
        components.year = -self
        return Calendar.current.date(byAdding: components, to: Date())
    }
}

extension Date {
    private static var cachedDateFormatters = [String: DateFormatter]()
    
    func toString(format: DateFormatType, timeZone: TimeZoneType = .local, locale: Locale = Locale.current) -> String {
        let formatter = Date.cachedFormatter(format.stringFormat, timeZone: timeZone.timeZone, locale: locale)
        return formatter.string(from: self)
    }
    
    private static func cachedFormatter(_ format: String = DateFormatType.standard.stringFormat, timeZone: Foundation.TimeZone = Foundation.TimeZone.current, locale: Locale = Locale.current) -> DateFormatter {
        let hashKey = "\(format.hashValue)\(timeZone.hashValue)\(locale.hashValue)"
        if Date.cachedDateFormatters[hashKey] == nil {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.timeZone = timeZone
            formatter.locale = locale
            formatter.isLenient = true
            Date.cachedDateFormatters[hashKey] = formatter
        }
        return Date.cachedDateFormatters[hashKey]!
    }
}

public enum DateFormatType {
    /// "MM.dd.yyyy" i.e. 07.16.1997
    case mmddyyyyDots
    
    case mmddyyyyDashes

    /// "yyyy" i.e. 1997
    case yyyy
    
    /// "yyyy-MM" i.e. 1997-07
    case yyyymmDashes

    /// "yyyy-MM-dd" i.e. 1997-07-16
    case yyyymmddDashes
    
    /// "EEE MMM dd HH:mm:ss Z yyyy"
    case standard
    
    /// A custom date format string
    case custom(String)
    
    var stringFormat: String {
        switch self {
        case .mmddyyyyDots: return "MM.dd.yyyy"
        case .mmddyyyyDashes: return "MM/dd/yyyy"
        case .yyyy: return "yyyy"
        case .yyyymmDashes: return "yyyy-MM"
        case .yyyymmddDashes: return "yyyy-MM-dd"

        case .standard: return "EEE MMM dd HH:mm:ss Z yyyy"
        case .custom(let customFormat): return customFormat
        }
    }
}

/// The time zone to be used for date conversion
public enum TimeZoneType {
    case local, utc
    var timeZone: TimeZone {
        switch self {
        case .local: return NSTimeZone.local
        case .utc: return TimeZone(secondsFromGMT: 0)!
        }
    }
}
