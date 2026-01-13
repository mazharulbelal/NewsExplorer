import UIKit

public final class ShimmerView: UIView {
    private let gradientLayer = CAGradientLayer()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        setup()
    }

    public required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        backgroundColor = UIColor.secondarySystemFill
        gradientLayer.colors = [
            UIColor.secondarySystemFill.withAlphaComponent(0.8).cgColor,
            UIColor.secondarySystemFill.withAlphaComponent(0.3).cgColor,
            UIColor.secondarySystemFill.withAlphaComponent(0.8).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        layer.addSublayer(gradientLayer)
        isHidden = true
        layer.masksToBounds = true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    public func start() {
        isHidden = false
        gradientLayer.removeAllAnimations()
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.2
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmer")
    }

    public func stop() {
        gradientLayer.removeAllAnimations()
        isHidden = true
    }
}
