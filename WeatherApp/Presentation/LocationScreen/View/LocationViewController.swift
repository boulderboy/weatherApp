import UIKit
import MapKit

final class LocationViewController: UIViewController,
                                    LocationViewDelegate,
                                    MKMapViewDelegate {
    // MARK: — Constants
    private enum Constants {
        static let searchBackgroundRadius = CGFloat(14)
        static let selectionCircleDiametr = CGFloat(35)
        static let selectionCircleBackground = UIColor(red: 0.07, green: 0.45, blue: 0.87, alpha: 0.5)
        static let searchPlaceholder = "Search here"
    }

    private enum Constraints {
        static let searchViewTop = CGFloat(68)
        static let searchViewSidesInset = CGFloat(28)
        static let searchViewHeight = CGFloat(53)

        static let textFieldTop = CGFloat(13)
        static let textFieldLeading = CGFloat(52)
        static let textFieldTrailing = -CGFloat(52)
        static let textFieldHeight = CGFloat(25)

        static let backButtonHeight = CGFloat(23)
        static let backButtonWidth = CGFloat(23)
        static let backButtonLeading = CGFloat(15)
    }

    // MARK: — Private properties
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.prepareForConstraints()
        view.delegate = self
        view.isRotateEnabled = false
        return view
    }()

    private let searchViewBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.searchBackgroundRadius
        view.layer.shadowRadius = 1.5
        view.layer.shadowOffset = CGSize(width: -1.5, height: 1.5)
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 0.5
        return view
    }()

    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.placeholder = Constants.searchPlaceholder
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldEditingHandler(_:)), for: .editingChanged)
        return textField
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()

    private lazy var resultsBackground: UIView = {
        let view = UIView(frame: CGRect(
            x: self.view.frame.size.width / 2,
            y: Constraints.searchViewTop + Constraints.searchViewHeight / 2,
            width: 0,
            height: 0
        ))
        view.backgroundColor = .white
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.prepareForConstraints()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.isHidden = true
        tableView.clipsToBounds = true
        tableView.register(LocationTableCell.self, forCellReuseIdentifier: LocationTableCell.cellId)
        tableView.register(DescriptionCell.self, forCellReuseIdentifier: DescriptionCell.cellId)
        tableView.register(RecentSearchCell.self, forCellReuseIdentifier: RecentSearchCell.caellId)
        return tableView
    }()

    private let presenter: LocationPresenter
    private let locationManager = CLLocationManager()

    // MARK: — Public properties
    var cities: [Weather.Location] = [] {
        didSet {
            adjustBackgroundSize()
            tableView.reloadData()
        }
    }

    var recentSearch: [String] = [] {
        didSet {
            presenter.weather(for: recentSearch)
            tableView.reloadData()
        }
    }

    var weatherForCities: [String: String] = [:] {
        didSet {
            tableView.reloadData()
        }
    }

    var onDismiss: (() -> Void)?
    var onSearchResult: ((String) -> Void)?

    // MARK: — Lifecycle
    init(presenter: LocationPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setViewDelegate(to: self)
        presenter.loadRecentSearch()
        setupLocationManager()
        setupViews()
    }

    // MARK: — Private functions
    private func setupLocationManager() {
        mapView.showsUserLocation  = true

        if let userLocation = locationManager.location?.coordinate {
            let coordinateRegion = MKCoordinateRegion(
                center: userLocation,
                latitudinalMeters: 20000,
                longitudinalMeters: 20000
            )
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }

    private func setupViews() {
        navigationController?.navigationBar.isHidden = true
        view.addSubview(mapView)
        mapView.addSubview(resultsBackground)
        mapView.addSubview(searchViewBackground)
        searchViewBackground.addSubview(searchTextField)
        searchViewBackground.addSubview(backButton)
        resultsBackground.addSubview(tableView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            searchViewBackground.topAnchor.constraint(equalTo: view.topAnchor, constant: Constraints.searchViewTop),
            searchViewBackground.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constraints.searchViewSidesInset
            ),
            searchViewBackground.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constraints.searchViewSidesInset
            ),
            searchViewBackground.heightAnchor.constraint(equalToConstant: Constraints.searchViewHeight),

            searchTextField.topAnchor.constraint(
                equalTo: searchViewBackground.topAnchor,
                constant: Constraints.textFieldTop
            ),
            searchTextField.leadingAnchor.constraint(
                equalTo: searchViewBackground.leadingAnchor,
                constant: Constraints.textFieldLeading
            ),
            searchTextField.trailingAnchor.constraint(
                equalTo: searchViewBackground.trailingAnchor,
                constant: Constraints.textFieldTrailing
            ),
            searchTextField.heightAnchor.constraint(equalToConstant: Constraints.textFieldHeight),

            backButton.centerYAnchor.constraint(equalTo: searchViewBackground.centerYAnchor),
            backButton.leadingAnchor.constraint(
                equalTo: searchViewBackground.leadingAnchor,
                constant: Constraints.backButtonLeading
            ),
            backButton.heightAnchor.constraint(equalToConstant: Constraints.backButtonHeight),
            backButton.widthAnchor.constraint(equalToConstant: Constraints.backButtonWidth),

            tableView.topAnchor.constraint(equalTo: searchViewBackground.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: resultsBackground.bottomAnchor, constant: -15)
        ])
    }

    private func adjustBackgroundSize() {
        let rows = cities.isEmpty ? recentSearch.count + 1 : cities.count + 1
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.resultsBackground.frame = CGRect(
                origin: self.resultsBackground.frame.origin,
                size: CGSize(
                    width: self.resultsBackground.frame.width,
                    height: CGFloat(rows) * 50 + Constraints.searchViewTop + Constraints.searchViewHeight
                )
            )
        }
    }

    // MARK: — Actions Handling
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func textFieldEditingHandler(_ textField: UITextField) {
        if let prefix = textField.text {
            if prefix.count >= 3 {
                presenter.search(by: prefix)
            } else {
                cities = []
                tableView.reloadData()
                adjustBackgroundSize()
            }
        }
    }
}

// MARK: - TextFieldDelegate
extension LocationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.resultsBackground.frame = CGRect(
                origin: CGPoint(x: 0, y: Constraints.searchViewTop),
                size: CGSize(width: self.view.frame.width, height: Constraints.searchViewHeight)
            )
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0) {
                self.resultsBackground.frame = CGRect(
                    origin: CGPoint(x: 0, y: 0),
                    size: CGSize(
                        width: self.view.frame.width,
                        height: 350))
                self.resultsBackground.layer.cornerRadius = 27
            } completion: { _ in
                self.tableView.isHidden = false
            }
        }
    }
}

// MARK: — UITableViewDelegate, UITableViewDataSource
extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cities.isEmpty {
            if recentSearch.isEmpty {
                return 1
            } else {
                return recentSearch.count + 1
            }
        } else {
            return cities.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cities.isEmpty {
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionCell.cellId)
                        as? DescriptionCell else { return DescriptionCell() }
                cell.configure(for: "Recent search")
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.caellId)
                        as? RecentSearchCell else { return RecentSearchCell() }
                cell.configure(with: recentSearch[indexPath.row - 1])
                if let temperature = weatherForCities[recentSearch[indexPath.row - 1]] {
                    cell.setTemperature(to: temperature)
                }
                return cell
            }
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableCell.cellId)
                    as? LocationTableCell else { return UITableViewCell() }
            cell.setCity(to: cities[indexPath.row].name)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let onSearchResult = onSearchResult {
            if cities.isEmpty {
                onSearchResult(recentSearch[indexPath.row - 1])
            } else {
                presenter.saveNewSearch(city: cities[indexPath.row].name)
                onSearchResult(cities[indexPath.row].name)
            }
        }
    }
}
