import UIKit

public final class NewsImageView: UIView {

    public var cornerRadius: CGFloat = 12 {
        didSet {
            imageView.layer.cornerRadius = cornerRadius
            shimmer.layer.cornerRadius = cornerRadius
        }
    }

    private let imageView = UIImageView()
    private let gradient = CAGradientLayer()
    private let shimmer = ShimmerView()

    private var currentURL: URL?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        clipsToBounds = false

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.cornerCurve = .continuous

        gradient.colors = [
            UIColor.black.withAlphaComponent(0.0).cgColor,
            UIColor.black.withAlphaComponent(0.25).cgColor,
            UIColor.black.withAlphaComponent(0.45).cgColor
        ]
        gradient.locations = [0.0, 0.6, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.isHidden = true

        shimmer.layer.cornerRadius = cornerRadius
        shimmer.layer.masksToBounds = true

        addSubview(imageView)
        addSubview(shimmer)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        shimmer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            shimmer.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            shimmer.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            shimmer.topAnchor.constraint(equalTo: imageView.topAnchor),
            shimmer.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if gradient.superlayer == nil {
            imageView.layer.addSublayer(gradient)
        }
        gradient.frame = imageView.bounds
    }

    func configure(with url: URL?, loader: ImageLoader) {
        currentURL = url
        imageView.image = nil
        gradient.isHidden = true

        guard let url else {
            shimmer.stop()
            shimmer.isHidden = true
            return
        }

        shimmer.start()
        loader.loadImage(from: url) { [weak self] image in
            guard let self else { return }
            guard self.currentURL == url else { return }

            self.shimmer.stop()

            if let image {
                UIView.transition(with: self.imageView, duration: 0.25, options: .transitionCrossDissolve, animations: {
                    self.imageView.image = image
                }, completion: nil)
                self.gradient.isHidden = false
            } else {
                self.imageView.image = nil
                self.gradient.isHidden = true
            }
        }
    }

    public func prepareForReuse() {
        currentURL = nil
        imageView.image = nil
        gradient.isHidden = true
        shimmer.start() // will be stopped when configure completes or url is nil
    }
}
