//
//  NewsCell.swift
//  NewsExplorer
//
//  Created by Md Mazharul Islam on 12/1/26.
//

import UIKit

final class NewsCell: UITableViewCell {

    // MARK: - Reuse Identifier
    static let reuseID = "NewsCell"

    // MARK: - UI Components
    private let cardView = UIView()
    private let newsImageView = NewsImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let badgeLabel = PaddingLabel()

    // Keep track of the URL to avoid wrong image on reuse
    private var currentImageURL: URL?

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    func configure(with article: Article) {
        applyText(from: article)
        applyBadge(from: article)
        applyImage(from: article)
    }

    // MARK: - UI Setup
    private func setupUI() {
        configureCellAppearance()
        configureCardView()
        configureImageView()
        configureTitleLabel()
        configureDescriptionLabel()
        configureBadgeLabel()
        addSubviews()
        setupConstraints()
    }

    private func configureCellAppearance() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    private func configureCardView() {
        cardView.backgroundColor = .secondarySystemBackground
        cardView.layer.cornerRadius = 14
        cardView.layer.cornerCurve = .continuous
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = UIColor.label.withAlphaComponent(0.1).cgColor
        cardView.layer.shadowOpacity = 1
        cardView.layer.shadowRadius = 10
        cardView.layer.shadowOffset = CGSize(width: 0, height: 6)
    }

    private func configureImageView() {
        newsImageView.cornerRadius = 12
    }

    private func configureTitleLabel() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.numberOfLines = 3
    }

    private func configureDescriptionLabel() {
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        descriptionLabel.adjustsFontForContentSizeCategory = true
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textColor = .secondaryLabel
    }

    private func configureBadgeLabel() {
        badgeLabel.textColor = .white
        badgeLabel.backgroundColor = .systemBlue
        badgeLabel.layer.cornerRadius = 6
        badgeLabel.layer.masksToBounds = true
        badgeLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        badgeLabel.adjustsFontForContentSizeCategory = true
    }

    private func addSubviews() {
        contentView.addSubview(cardView)
        cardView.addSubview(newsImageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(descriptionLabel)
        cardView.addSubview(badgeLabel)
    }

    private func setupConstraints() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false

        let imageHeight: CGFloat = 180

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            newsImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            newsImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            newsImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            newsImageView.heightAnchor.constraint(equalToConstant: imageHeight),

            badgeLabel.leadingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant: 12),
            badgeLabel.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: -12),

            titleLabel.leadingAnchor.constraint(equalTo: newsImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: newsImageView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 10),

            descriptionLabel.leadingAnchor.constraint(equalTo: newsImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: newsImageView.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descriptionLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Apply Content Helpers
    private func applyText(from article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
    }

    private func applyBadge(from article: Article) {
        // Placeholder logic; adjust when categories/sources are available
        badgeLabel.text = "Top"
        badgeLabel.isHidden = false
    }

    private func applyImage(from article: Article) {
        currentImageURL = article.imageURL
        newsImageView.configure(with: article.imageURL, loader: ImageLoader.shared)
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        updateShadowPath()
    }

    private func updateShadowPath() {
        cardView.layer.shadowPath = UIBezierPath(
            roundedRect: cardView.bounds,
            cornerRadius: cardView.layer.cornerRadius
        ).cgPath
    }

    // MARK: - Highlight animation
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let values = highlightValues(for: highlighted)
        let animations = { self.applyHighlight(values) }

        if animated {
            UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseInOut]) {
                animations()
            }
        } else {
            animations()
        }
    }

    private struct HighlightValues {
        let transform: CGAffineTransform
        let shadowRadius: CGFloat
        let shadowOffset: CGSize
    }

    private func highlightValues(for highlighted: Bool) -> HighlightValues {
        HighlightValues(
            transform: highlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity,
            shadowRadius: highlighted ? 6 : 10,
            shadowOffset: highlighted ? CGSize(width: 0, height: 3) : CGSize(width: 0, height: 6)
        )
    }

    private func applyHighlight(_ values: HighlightValues) {
        cardView.transform = values.transform
        cardView.layer.shadowRadius = values.shadowRadius
        cardView.layer.shadowOffset = values.shadowOffset
    }

    // MARK: - Reuse Handling
    override func prepareForReuse() {
        super.prepareForReuse()
        resetContent()
    }

    private func resetContent() {
        currentImageURL = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        newsImageView.prepareForReuse()
    }
}
