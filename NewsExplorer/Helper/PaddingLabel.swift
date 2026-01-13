import UIKit

public final class PaddingLabel: UILabel {
    public var insets = UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6)

    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + insets.left + insets.right,
                      height: size.height + insets.top + insets.bottom)
    }
}
