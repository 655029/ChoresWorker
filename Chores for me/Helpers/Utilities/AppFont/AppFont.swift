//
//  AppFont.swift
//  Chores for me
//
//  Created by Chores for me 2021 on 14/04/21.
//

import Foundation
import Designable

struct AppFont {

    // TODO: - Change me
    enum Poppins: FontRepresentable {
        case thin
        case extraLight
        case light
        case regular
        case medium
        case semiBold
        case bold
        case extraBold
        case black
        case thinItalic
        case extraLightItalic
        case lightItalic
        case italic
        case mediumItalic
        case semiBoldItalic
        case boldItalic
        case extraBoldItalic
        case blackItalic

        var fontName: String {
            switch self {
            case .thin:
                return "Poppins-Thin"
            case .extraLight:
                return "Poppins-ExtraLight"
            case .light:
                return "Poppins-Light"
            case .regular:
                return "Poppins-Regular"
            case .medium:
                return "Poppins-Medium"
            case .semiBold:
                return "Poppins-SemiBold"
            case .bold:
                return "Poppins-Bold"
            case .extraBold:
                return "Poppins-ExtraBold"
            case .black:
                return "Poppins-Black"
            case .thinItalic:
                return "Poppins-ThinItalic"
            case .extraLightItalic:
                return "Poppins-ExtraLightItalic"
            case .lightItalic:
                return "Poppins-LightItalic"
            case .italic:
                return "Poppins-Italic"
            case .mediumItalic:
                return "Poppins-MediumItalic"
            case .semiBoldItalic:
                return "Poppins-SemiBoldItalic"
            case .boldItalic:
                return "Poppins-BoldItalic"
            case .extraBoldItalic:
                return "Poppins-ExtraBoldItalic"
            case .blackItalic:
                return "Poppins-BlackItalic"
            }
        }
    }

    // TODO: - Change me
    static func font(style: Poppins) -> Font {
        return Font.font(style: style)
    }

    // TODO: - Change me
    static func font(style: AppFont.Poppins, size: CGFloat = UIFont.labelFontSize) -> Font {
        return Font.font(style: style, size: size)
    }
}
