import UIKit

final class DailyWeatherCell: UITableViewCell {

    static let cellId = "dailyWeather"

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.prepareForConstraints()
        label.font = UIFont(name: UIFont.overpassBold, size: 17)
        label.text = "Sep, 13"
        label.textColor = .white
        return label
    }()

    private let conditionsImage: UIImageView = {
        let imagView = UIImageView()
        imagView.prepareForConstraints()
        imagView.image = UIImage(named: "rainy")
        imagView.contentMode = .scaleAspectFit
        return imagView
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.prepareForConstraints()
        label.font = UIFont(name: UIFont.overpass, size: 17)
        label.text = "26 \u{00B0} C"
        label.textColor = .white
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    private func setupViews() {
        backgroundColor = .clear
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(conditionsImage)
        contentView.addSubview(temperatureLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            conditionsImage.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            conditionsImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            conditionsImage.heightAnchor.constraint(equalToConstant: 40),
            conditionsImage.widthAnchor.constraint(equalToConstant: 40),

            temperatureLabel.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22)
        ])
    }

    func configure(with weather: ForecastViewModel.Day) {
        dateLabel.text = weather.date
        temperatureLabel.text = weather.temperature
        conditionsImage.image = UIImage(named: weather.conditionImageName)
    }
}
