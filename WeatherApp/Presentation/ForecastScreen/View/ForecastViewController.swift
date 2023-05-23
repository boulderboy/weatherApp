import UIKit

protocol ForecastViewProtocol {
    var forecast: ForecastViewModel { get set }
    var location: String { get }
}

final class ForecastViewController:
    UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UITableViewDelegate,
    UITableViewDataSource,
    ForecastViewProtocol {

    private enum ConstraintValues {
        static let weekdayTop = CGFloat(128)
        static let sideInset = CGFloat(27.81)
        static let hourlyWeatherCollectionTop = CGFloat(30)
        static let hourlyWeatherCollectionHeight = CGFloat(144)
        static let weekdayHeight = CGFloat(28)
        static let tableTop = CGFloat(47.28)
        static let tableHeight = CGFloat(350)
    }

    private let weekdayLabel: UILabel = {
        let label = UILabel()
        label.prepareForConstraints()
        label.text = "Today"
        label.font = UIFont(name: UIFont.overpassBold, size: 22)
        label.textColor = .white
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.prepareForConstraints()
        label.text = ""
        label.font = UIFont(name: UIFont.overpass, size: 17)
        label.textColor = .white
        return label
    }()

    private lazy var hourlyWheatherHighlighter: ViewWithGradientBorder = {
        let frameWidth = (self.view.frame.size.width - 11 * 4) / 5
        let view = ViewWithGradientBorder(frame: CGRect(
            x: (self.view.frame.width / 2) - (frameWidth / 2),
            y: ConstraintValues.hourlyWeatherCollectionTop +
                ConstraintValues.weekdayTop +
                ConstraintValues.weekdayHeight +
                view.safeAreaInsets.top,
            width: frameWidth,
            height: 144)
        )
        return view
    }()

    private lazy var hourlyWeatherCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: ((self.view.frame.size.width - 11 * 4) / 5), height: 144)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 11
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.prepareForConstraints()
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HourlyWeatherCell.self, forCellWithReuseIdentifier: HourlyWeatherCell.cellId)
        return collectionView
    }()

    private lazy var forecastTableView: UITableView = {
        let tableView = UITableView()
        tableView.prepareForConstraints()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.indicatorStyle = .white
        tableView.showsVerticalScrollIndicator = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(DailyWeatherCell.self, forCellReuseIdentifier: DailyWeatherCell.cellId)
        return tableView
    }()

    private let presenter: ForecastPresenterProtocol

    var location: String
    var forecast: ForecastViewModel = ForecastViewModel.empty {
        didSet {
            hourlyWeatherCollection.reloadData()
            forecastTableView.reloadData()
        }
    }

    init(location: String, presenter: ForecastPresenterProtocol) {
        self.location = location
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setViewProtocol(self)
        presenter.requestForecast()
        setupViews()
    }

    private func setupViews() {
        view.setGradient(
            colors: [UIColor.gradientTop.cgColor, UIColor.gradientBottom.cgColor]
        )

        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(weekdayLabel)
        view.addSubview(dateLabel)
        view.addSubview(hourlyWheatherHighlighter)
        view.addSubview(hourlyWeatherCollection)
        view.addSubview(forecastTableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            weekdayLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: ConstraintValues.weekdayTop),
            weekdayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstraintValues.sideInset),
            weekdayLabel.heightAnchor.constraint(equalToConstant: ConstraintValues.weekdayHeight),

            dateLabel.bottomAnchor.constraint(equalTo: weekdayLabel.bottomAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ConstraintValues.sideInset),

            hourlyWeatherCollection.topAnchor.constraint(
                equalTo: weekdayLabel.bottomAnchor,
                constant: ConstraintValues.hourlyWeatherCollectionTop
            ),
            hourlyWeatherCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hourlyWeatherCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hourlyWeatherCollection.heightAnchor.constraint(
                equalToConstant: ConstraintValues.hourlyWeatherCollectionHeight
            ),

            forecastTableView.topAnchor.constraint(
                equalTo: hourlyWeatherCollection.bottomAnchor,
                constant: ConstraintValues.tableTop
            ),
            forecastTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: ConstraintValues.sideInset
            ),
            forecastTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -ConstraintValues.sideInset
            ),
            forecastTableView.heightAnchor.constraint(equalToConstant: ConstraintValues.tableHeight)
        ])
    }

    // MARK: - CollectionViewDelegate CollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecast.hours.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HourlyWeatherCell.cellId,
            for: indexPath
        )
                as? HourlyWeatherCell else { return HourlyWeatherCell() }
        cell.configure(to: forecast.hours[indexPath.row])
        return cell
    }

    // MARK: - TableViewDelegate and TableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecast.day.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyWeatherCell.cellId)
                as? DailyWeatherCell else { return DailyWeatherCell() }
        cell.configure(with: forecast.day[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }

}
