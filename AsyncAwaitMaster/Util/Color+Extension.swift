//
//  Color+Extension.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import SwiftUI

extension Color {
    var luminance: Double {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        return 0.2126 * Double(red) + 0.7152 * Double(green) + 0.0722 * Double(blue)
    }
    
    var isLight: Bool {
        return luminance > 0.5
    }
    
    var adaptedTextColor: Color {
        return isLight ? Color.black : Color.white
    }
    
    var adaptedTextColorInverse: Color {
        return isLight ? Color.white : Color.black
    }
}
