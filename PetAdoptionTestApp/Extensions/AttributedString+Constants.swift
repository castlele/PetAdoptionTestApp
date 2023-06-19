import UIKit

extension NSAttributedString {
    static var headerText: NSAttributedString {
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        let attributedText = NSMutableAttributedString(string: "Hey Spikey,\nAdopt a new friend near you!", attributes: [NSAttributedString.Key.kern: 0.03, NSAttributedString.Key.paragraphStyle: paragraphStyle])

        return attributedText
    }
}
