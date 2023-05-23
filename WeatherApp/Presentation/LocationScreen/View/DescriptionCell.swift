import UIKit

final class DescriptionCell: UITableViewCell {

    static let cellId = "descriptionCell"

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.prepareForConstraints()
        label.font = UIFont(name: UIFont.overpassBold, size: 13)
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
        contentView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28)
        ])
    }

    func configure(for description: String) {
        descriptionLabel.text = description
    }
}
