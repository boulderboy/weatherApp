import UIKit

// TODO: Split view code
final class MainViewController: UIViewController, MainViewDelegate {
    private enum Constraints {
        static let indentFromTop = CGFloat(68)
        static let indentFromSides = CGFloat(29)
        static let smallIconSize = CGFloat(22)
        static let gapFromMapPinToLabel = CGFloat(19)
        static let mainImageTopAnchor = CGFloat(54)
        static let mainImageSize = CGFloat(131)
        static let dateLabelTop = CGFloat(16)
        static let temperatureLabelTop = CGFloat(23)
        static let conditionsLabelTop = CGFloat(5)
        static let humidityIconTop = CGFloat(19)
        static let windSpeedIconTop = CGFloat(32)
        static let windSpeedIconLeading = CGFloat(62)
        static let stackVewsLeading = CGFloat(19)
        static let forecastButtonBottom = CGFloat(33)
        static let forecastButtonWidth = CGFloat(204)
        static let forecastButtonHeight = CGFloat(60)
    }

    private enum Constants {
        static let wheatherInfoBackgroundCornerRadius = CGFloat(18.5)
        static let wheatherInfoBackgroundBorderWidth = CGFloat(1.85)
        static let wheatherInfoBackgroundY = CGFloat(334.7)
        static let wheatherInfoBackgroundBorderGradientEnd = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.00)

        static let separatorX = CGFloat(58.41)
    }

    // MARK: — Public properties
    var currentCity: String = "" {
        didSet {
            locationButton.setTitle(currentCity, for: .normal)
            navigationController?.navigationBar.setNeedsLayout()
        }
    }

    var todayWeather = TodayWeather.empty {
        didSet {
            dateLabel.text = todayWeather.date
            temperatureLabel.text = todayWeather.temperature
            windSpeedLabel.text = todayWeather.windSpeed
            humValueLabel.text = todayWeather.humidity
            mainWheatherImage.image = todayWeather.conditionImage
        }
    }

    // MARK: — Private properties
    private lazy var locationButton: UIButton = {
        var configuration = UIButton.Configuration.borderless()
        configuration.imagePadding = 19
        configuration.image = UIImage(named: "mapPin")
        configuration.imagePlacement = .leading
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = UIFont(name: UIFont.overpassBold, size: 22)
            return outgoing
        })
        configuration.titleAlignment = .center
        let button = UIButton()
        button.configuration = configuration
        button.tintColor = .white
        button.addTarget(self, action: #selector(openMap), for: .touchUpInside)
        button.prepareForConstraints()
        return button
    }()

    private let notificationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.prepareForConstraints()
        imageView.image = UIImage(named: "notificationBell")
        imageView.contentMode = .center
        imageView.tintColor = .white
        return imageView
    }()

    private let mainWheatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.prepareForConstraints()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var weatherInfoBackground: ViewWithGradientBorder = {
        let view = ViewWithGradientBorder(
            frame: CGRect(
                x: Constraints.indentFromSides,
                y: CGFloat(Constants.wheatherInfoBackgroundY),
                width: self.view.bounds.width - (Constraints.indentFromSides * 2),
                height: CGFloat(310.59)
            )
        )
        return view
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.prepareForConstraints()
        label.font = UIFont(name: UIFont.overpass, size: 17)
        label.textColor = .white
        return label
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.prepareForConstraints()
        label.font = UIFont(name: UIFont.overpass, size: 93)
        label.textColor = .white
        return label
    }()

    private let conditionsLabel: UILabel = {
        let label = UILabel()
        label.prepareForConstraints()
        label.font = UIFont(name: UIFont.overpassBold, size: 22)
        label.textColor = .white
        return label
    }()

    private let windSpeedIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.prepareForConstraints()
        imageView.image = UIImage(named: "windSpeed")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let humidityIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.prepareForConstraints()
        imageView.image = UIImage(named: "humidity")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var windSpeedStacView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [windLabel, windSpeedLabel])
        stackView.prepareForConstraints()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var humidityStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [humLabel, humValueLabel])
        stackView.prepareForConstraints()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let windLabel: UILabel = {
        let label = UILabel()
        label.prepareForConstraints()
        label.text = "Wind"
        label.font = UIFont(name: UIFont.overpass, size: 17)
        label.textColor = .white
        return label
    }()

    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.prepareForConstraints()
        label.font = UIFont(name: UIFont.overpass, size: 17)
        label.textColor = .white
        return label
    }()

    private let humLabel: UILabel = {
        let label = UILabel()
        label.prepareForConstraints()
        label.text = "Hum"
        label.font = UIFont(name: UIFont.overpass, size: 17)
        label.textColor = .white
        return label
    }()

    private let humValueLabel: UILabel = {
        let label = UILabel()
        label.prepareForConstraints()
        label.font = UIFont(name: UIFont.overpass, size: 17)
        label.textColor = .white
        return label
    }()

    private lazy var forecastButton: UIButton = {
        let button = UIButton()
        button.prepareForConstraints()
        button.setTitle("Forecast report", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(showForecast), for: .touchUpInside)
        return button
    }()

    private var separatorView: UIView {
        let view = UIView(frame: CGRect(
            x: Constants.separatorX,
            y: 0,
            width: 2,
            height: 20
        ))
        view.backgroundColor = .white
        return view
    }

    private var presenter: MainPresenter

    // MARK: — Lifecycle
    init(presenter: MainPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setViewDelegate(delegate: self)
        presenter.weatherForCurrentLocation()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Private functions
    private func setupViews() {
        view.setGradient(
            colors: [UIColor.gradientTop.cgColor, UIColor.gradientBottom.cgColor],
            startPoint: nil,
            endPoint: nil
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: locationButton)
        locationButton.titleLabel?.adjustsFontForContentSizeCategory = true
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(notificationImageView)
        view.addSubview(mainWheatherImage)
        view.addSubview(weatherInfoBackground)
        addSubviewsToInfoBackground()
        view.addSubview(forecastButton)
    }

    private func addSubviewsToInfoBackground() {
        weatherInfoBackground.addSubview(dateLabel)
        weatherInfoBackground.addSubview(temperatureLabel)
        weatherInfoBackground.addSubview(conditionsLabel)
        weatherInfoBackground.addSubview(windSpeedIcon)
        weatherInfoBackground.addSubview(humidityIcon)

        weatherInfoBackground.addSubview(windSpeedStacView)
        weatherInfoBackground.addSubview(humidityStackView)

        windSpeedStacView.addSubview(separatorView)
        humidityStackView.addSubview(separatorView)
    }

    private func setupConstraints() {
        setMainConstraints()
        setWeatherInfoConstraints()
    }

    private func setMainConstraints() {
        NSLayoutConstraint.activate([

            notificationImageView.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: Constraints.indentFromTop
            ),
            notificationImageView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constraints.indentFromSides
            ),
            notificationImageView.widthAnchor.constraint(equalToConstant: Constraints.smallIconSize),
            notificationImageView.heightAnchor.constraint(equalToConstant: Constraints.smallIconSize),

            mainWheatherImage.topAnchor.constraint(
                equalTo: notificationImageView.bottomAnchor,
                constant: Constraints.mainImageTopAnchor
            ),
            mainWheatherImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainWheatherImage.widthAnchor.constraint(equalToConstant: Constraints.mainImageSize),
            mainWheatherImage.heightAnchor.constraint(equalToConstant: Constraints.mainImageSize),

            forecastButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -Constraints.forecastButtonBottom
            ),
            forecastButton.widthAnchor.constraint(equalToConstant: Constraints.forecastButtonWidth),
            forecastButton.heightAnchor.constraint(equalToConstant: Constraints.forecastButtonHeight),
            forecastButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setWeatherInfoConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(
                equalTo: weatherInfoBackground.topAnchor,
                constant: Constraints.dateLabelTop
            ),
            dateLabel.centerXAnchor.constraint(equalTo: weatherInfoBackground.centerXAnchor),

            temperatureLabel.topAnchor.constraint(
                equalTo: dateLabel.bottomAnchor,
                constant: Constraints.temperatureLabelTop
            ),
            temperatureLabel.centerXAnchor.constraint(equalTo: weatherInfoBackground.centerXAnchor),
            temperatureLabel.heightAnchor.constraint(equalToConstant: 97),

            conditionsLabel.topAnchor.constraint(
                equalTo: temperatureLabel.bottomAnchor,
                constant: Constraints.conditionsLabelTop
            ),
            conditionsLabel.centerXAnchor.constraint(equalTo: weatherInfoBackground.centerXAnchor),

            windSpeedIcon.topAnchor.constraint(
                equalTo: conditionsLabel.bottomAnchor,
                constant: Constraints.windSpeedIconTop
            ),
            windSpeedIcon.leadingAnchor.constraint(
                equalTo: weatherInfoBackground.leadingAnchor,
                constant: Constraints.windSpeedIconLeading),
            windSpeedIcon.heightAnchor.constraint(equalToConstant: Constraints.smallIconSize),
            windSpeedIcon.widthAnchor.constraint(equalToConstant: Constraints.smallIconSize),

            humidityIcon.topAnchor.constraint(
                equalTo: windSpeedIcon.bottomAnchor,
                constant: Constraints.humidityIconTop
            ),
            humidityIcon.leadingAnchor.constraint(equalTo: windSpeedIcon.leadingAnchor),
            humidityIcon.heightAnchor.constraint(equalToConstant: Constraints.smallIconSize),
            humidityIcon.widthAnchor.constraint(equalToConstant: Constraints.smallIconSize),

            windSpeedStacView.centerYAnchor.constraint(equalTo: windSpeedIcon.centerYAnchor),
            windSpeedStacView.leadingAnchor.constraint(
                equalTo: windSpeedIcon.trailingAnchor,
                constant: Constraints.stackVewsLeading
            ),
            windSpeedStacView.trailingAnchor.constraint(equalTo: weatherInfoBackground.trailingAnchor, constant: -50),
            windSpeedStacView.heightAnchor.constraint(equalTo: windSpeedIcon.heightAnchor),

            humidityStackView.centerYAnchor.constraint(equalTo: humidityIcon.centerYAnchor),
            humidityStackView.leadingAnchor.constraint(equalTo: windSpeedStacView.leadingAnchor),
            humidityStackView.trailingAnchor.constraint(equalTo: weatherInfoBackground.trailingAnchor, constant: -50),
            humidityStackView.heightAnchor.constraint(equalTo: humidityIcon.heightAnchor)
        ])
    }

    // MARK: — Actions Handling
    @objc
    private func showForecast() {
        let forecastViewController = Factory.forecastScreen(location: self.currentCity)
        navigationController?.pushViewController(forecastViewController, animated: true)
    }

    @objc
    private func openMap() {
        let locationViewController = Factory.locationScreen()
        locationViewController.onDismiss = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        locationViewController.onSearchResult = { [weak self] location in
            self?.navigationController?.popViewController(animated: true)
            self?.currentCity = location
            self?.locationButton.setTitle(location, for: .normal)
            self?.presenter.weather(for: location)
        }
        navigationController?.pushViewController(locationViewController, animated: true)
    }
}
