import UIKit

final class RecentSearchCell: UITableViewCell {

    static let caellId = "recentSearchCell"

    private enum Contraints {
        static let sidePadding = CGFloat(28)
        static let imageSize = CGFloat(22)
        static let cityNamePadding = CGFloat(26)
        static let temperatureLabelWidth = CGFloat(56)
    }

    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.prepareForConstraints()
        imageView.image = UIImage(systemName: "clock")
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .black
        return imageView
    }()

    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.prepareForConstraints()
        label.font = UIFont(name: UIFont.overpassBold, size: 17)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.prepareForConstraints()
        label.font = UIFont(name: UIFont.overpassBold, size: 17)
        label.textColor = .black
        label.textAlignment = .right
        label.isHidden = true
        return label
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.prepareForConstraints()
        activityIndicator.style = .medium
        activityIndicator.tintColor = .lightGray
        return activityIndicator
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(leftImageView)
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(activityIndicator)

        activityIndicator.startAnimating()

        NSLayoutConstraint.activate([
            leftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            leftImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Contraints.sidePadding
            ),
            leftImageView.widthAnchor.constraint(equalToConstant: Contraints.imageSize),
            leftImageView.heightAnchor.constraint(equalToConstant: Contraints.imageSize),

            cityNameLabel.centerYAnchor.constraint(equalTo: leftImageView.centerYAnchor),
            cityNameLabel.leadingAnchor.constraint(
                equalTo: leftImageView.trailingAnchor,
                constant: Contraints.cityNamePadding
            ),
            cityNameLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: contentView.trailingAnchor,
                constant: -Contraints.sidePadding - Contraints.temperatureLabelWidth
            ),

            temperatureLabel.centerYAnchor.constraint(equalTo: leftImageView.centerYAnchor),
            temperatureLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Contraints.sidePadding
            ),
            temperatureLabel.widthAnchor.constraint(equalToConstant: Contraints.temperatureLabelWidth),

            activityIndicator.centerYAnchor.constraint(equalTo: leftImageView.centerYAnchor),
            activityIndicator.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: Contraints.sidePadding
            ),
            activityIndicator.widthAnchor.constraint(equalToConstant: Contraints.imageSize),
            activityIndicator.heightAnchor.constraint(equalToConstant: Contraints.imageSize)
        ])
    }

    func configure(with cityName: String) {
        cityNameLabel.text = cityName
    }

    func setTemperature(to temperature: String) {
        activityIndicator.isHidden = true
        temperatureLabel.text = temperature
        temperatureLabel.isHidden = false
        activityIndicator.stopAnimating()
    }
}
