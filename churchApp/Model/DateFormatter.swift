//Created for churchApp  (29.10.2020 )

import Foundation

enum DateFormats: String {
    case
        timeSheetDate = "dd/MM/YY",
        hoursAndMinutes = "h:mm a",
        dayAtTime = "EEEE 'at' h:mma",
        DayMonAtDate = "EE, MMMM dd 'at' h:mma",  /// Wed, May 27 at 8:00pm"
        thisDayMMdd = "'This' EEEE, MMMM dd" /// This Wednesday, May 27
        
    
}

extension Date {
    func formated(_ format: DateFormats, ignoreTimezone: Bool = true) -> String {
        let df = DateFormatter()
        df.timeZone = ignoreTimezone ? TimeZone(secondsFromGMT: 0) : .current
        df.dateFormat = format.rawValue
        return df.string(from: self)
    }
}
