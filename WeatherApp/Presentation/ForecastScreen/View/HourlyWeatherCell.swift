import UIKit

final class HourlyWeatherCell: UICollectionViewCell {

    static let cellId = "hourlyWeather"

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.prepareForConstraints()
        label.text = "26 \u{00B0} C"
        label.font = UIFont(name: UIFont.overpass, size: 17)
        label.textColor = .white
        return label
    }()

    private let conditionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.prepareForConstraints()
        imageView.image = UIImage(named: "sunny")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.prepareForConstraints()
        label.text = "09:00"
        label.font = UIFont(name: UIFont.overpass, size: 17)
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(conditionImage)
        contentView.addSubview(timeLabel)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            temperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            conditionImage.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 15),
            conditionImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            conditionImage.widthAnchor.constraint(equalToConstant: 32),
            conditionImage.heightAnchor.constraint(equalToConstant: 32),

            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    func configure(to weather: ForecastViewModel.Hour) {
        temperatureLabel.text = "\(weather.temperature)"
        timeLabel.text = weather.time
        conditionImage.image = UIImage(named: weather.conditionImageName)
    }
}
