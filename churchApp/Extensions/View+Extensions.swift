//Created for churchApp  (25.09.2020 )
 
import UIKit

extension UIView {
    
    // create and apply shadow
    // used in customization and notification vcs
    func applyShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
    }
    
    func applyShadow(color: UIColor, opacity: Float, offset: CGSize) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
    }
    
    
    // apply border to view
    func applyBorder() {
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 151 / 255,
            green: 151 / 255,
            blue: 151 / 255, alpha: 1).cgColor
    }
    
}

extension UIImage {
    func imageWithColor(_ color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0);
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension UITabBar {
    
    func setUnselectedColor(_ unselectedColor: UIColor) {
        guard let items = self.items else { return }
        for item in items {
            item.image = item.selectedImage?.imageWithColor(unselectedColor).withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            let attributes = [NSAttributedString.Key.foregroundColor: unselectedColor]
            item.setTitleTextAttributes(attributes, for: UIControl.State())
            let selectedAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 249/255, green: 214/255, blue: 1/255, alpha: 1)]
            item.setTitleTextAttributes(selectedAttributes, for: UIControl.State.selected)
        }
    }
    
}

extension String {
    
    // validate string as email address with regex
    func isValidEmailString() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

  
extension Date {
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}

extension Date {

    func years(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.year], from: sinceDate, to: self).year
    }

    func months(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.month], from: sinceDate, to: self).month
    }

    func days(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: sinceDate, to: self).day
    }

    func hours(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.hour], from: sinceDate, to: self).hour
    }

    func minutes(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute
    }

    func seconds(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.second], from: sinceDate, to: self).second
    }

}

public enum DeviceTypes : String {
    case simulator      = "Simulator",
    iPad2          = "iPad 2",
    iPad3          = "iPad 3",
    iPhone4        = "iPhone 4",
    iPhone4S       = "iPhone 4S",
    iPhone5        = "iPhone 5",
    iPhone5S       = "iPhone 5S",
    iPhone5c       = "iPhone 5c",
    iPad4          = "iPad 4",
    iPadMini1      = "iPad Mini 1",
    iPadMini2      = "iPad Mini 2",
    iPadAir1       = "iPad Air 1",
    iPadAir2       = "iPad Air 2",
    iPhone6        = "iPhone 6",
    iPhone6plus    = "iPhone 6 Plus",
    unrecognized   = "?unrecognized?"
}

extension Date {
    
    func hoursFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    
    func minutesFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    
    func secondsFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }

    func isTodayOrEarlier() -> Bool {
        let cal = Calendar.current
        var components = (cal as NSCalendar).components([.era, .year, .month, .day], from: Date())
        let today = cal.date(from: components)!
        
        components = (cal as NSCalendar).components([.era, .year, .month, .day], from: self)
        let otherDate = cal.date(from: components)!
        let comp = today.compare(otherDate)
        
        return comp == .orderedDescending || comp == .orderedSame
    }
    
}
 
extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
}


extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
