import UIKit

final class LocationTableCell: UITableViewCell {

    static let cellId = "locationCell"

    private let cityLabel: UILabel = {
        let label = UILabel()
        label.prepareForConstraints()
        label.font = UIFont(name: UIFont.overpassBold, size: 16)
        label.textColor = .black
        return label
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
        contentView.addSubview(cityLabel)

        NSLayoutConstraint.activate([
            cityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30)
        ])
    }

    func setCity(to cityName: String) {
        cityLabel.text = cityName
    }
}
