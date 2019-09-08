//
//  UIColor+Extensions.swift
//  MasterClass
//
//  Created by James Czepiel on 2/18/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

extension UIColor {
    /// Creates a UIColor using the given red, green and blue color values. Usage example: `UIColor.rgb(red: 230, green: 32, blue: 32)`
    ///
    /// - Parameters:
    ///   - red: The value for red
    ///   - green: The value for green
    ///   - blue: The value for blue
    /// - Returns: A UIColor created using the given RGB values
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    /// Creates and returns a random UIColor. Usage example: `UIColor.random()`
    ///
    /// - Returns: A random UIColor
    static func random() -> UIColor {
        return UIColor.rgb(red: CGFloat.random(in: 0..<255), green: CGFloat.random(in: 0..<255), blue: CGFloat.random(in: 0..<255))
    }
}

/// The below extensions were made while learning with https://learnui.design/blog/the-hsb-color-system-practicioners-primer.html & https://medium.com/@erikdkennedy/color-in-ui-design-a-practical-framework-e18cacd97f9e
/// The goal was to attempt to make an easy way to quicky lighten/darker colors and learn about Color Theory
extension UIColor {
    
    /// Darkens a color by the given percentage. The percentage defaults to 5% if not specified. Percentage is given in the format where 0.05 = 5%, 0.20 = 20% and so on.
    /// Operates by the idea that darker color variation = higher saturation + lower brightness.
    /// Thus the current saturation will be increated by the % and the current brightness will be decreased by the %.
    /// - Parameter percent: The given percentage to darken the color by
    /// - Returns: The new darkened color
    func makeDarker(by percent: CGFloat = 0.05) -> UIColor {
        guard percent >= 0.00 && percent <= 1.0 else { return self }
        
        var hue: CGFloat = 0/360
        var saturation: CGFloat = 0/100
        var brightness: CGFloat = 0/100
        var alpha: CGFloat = 0/100
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            //Logger.log(message: "Old Hue: \(hue) Old Saturation: \(saturation) Old Brightness: \(brightness)", event: .verbose)
            saturation = saturation + (saturation * percent)
            brightness = brightness - (brightness * percent)
            //Logger.log(message: "New Hue: \(hue) New Saturation: \(saturation) New Brightness: \(brightness)", event: .verbose)
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        }
        
        return self
    }
    
    /// Darkens a color by the given percentage. The percentage defaults to 5% if not specified. Percentage is given in the format where 0.05 = 5%, 0.20 = 20% and so on.
    /// Operates by the idea that lighter Color Variation = lower saturation + higher brightness.
    /// Thus the current saturation will be decreased by the % and the current brightness will be increased by the %.
    /// - Parameter percent: The given percentage to darken the color by
    /// - Returns: The new darkened color
    func makeLighter(by percent: CGFloat = 0.05) -> UIColor {
        guard percent >= 0.00 && percent <= 1.0 else { return self }
        
        var hue: CGFloat = 0/360
        var saturation: CGFloat = 0/100
        var brightness: CGFloat = 0/100
        var alpha: CGFloat = 0/100
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            //Logger.log(message: "Old Hue: \(hue) Old Saturation: \(saturation) Old Brightness: \(brightness)", event: .verbose)
            saturation = saturation - (saturation * percent)
            brightness = brightness + (brightness * percent)
            //Logger.log(message: "New Hue: \(hue) New Saturation: \(saturation) New Brightness: \(brightness)", event: .verbose)
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        }
        
        return self
    }
}

/// Below is further reading on Colors and how to darken/lighten them:

/*
 https://learnui.design/blog/the-hsb-color-system-practicioners-primer.html
 https://medium.com/@erikdkennedy/color-in-ui-design-a-practical-framework-e18cacd97f9e
 
 Hue: the color it most resembles on the color wheel, from 0° to 360°
 Saturation: how injected with color it is, from 0% to 100%
 Brightness: how much the “lightbulb” is turned on, from 0% to 100%
 
 Removing white – that is, making your darker shades richer – is the “correct” way to generate darker variations of a color 95%+ of the time.
 
 When there’s a shadowed variation of a color, you can expect brightness to go down and saturation to go up. We just looked at this in two instances, but as far as I’ve ever seen, it’s a solid rule you can go by.
 
 Darker color variation = higher saturation + lower brightness
 Lighter Color Variation = lower saturation + higher brightness
 - You can think of making lighter variations as adding white.
 
 Darker color variations are made by lowering brightness and increasing saturation. Brighter color variations are made by increasing brightness and lowering saturation.
 
 Darker variations:
 
 Brightness decreases
 Saturation increases
 Hue (often) shifts towards a luminosity minimum (red, green, or blue)
 
 Lighter variations:
 
 Brightness increases
 Saturation decreases
 Hue (often) shifts towards a luminosity maximum (yellow, cyan, magenta)
 */

extension UIColor {
    /// https://stackoverflow.com/questions/2509443/check-if-uicolor-is-dark-or-bright
    func isDarkColor() -> Bool {
        let colorComponents = self.cgColor.components
        if let redComponent = colorComponents?[0], let greenComponent = colorComponents?[1], let blueComponent = colorComponents?[2] {
            let colorBrightness = ((redComponent * 299) + (greenComponent * 587) + (blueComponent * 114)) / 1000
            return colorBrightness < 0.5
        }
        
        return false
    }
}
