import UIKit

final class ViewWithGradientBorder: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.setGradient(
            colors: [UIColor.white.cgColor, UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.00).cgColor],
            startPoint: CGPoint(x: 1, y: 0),
            endPoint: CGPoint(x: 0, y: 1)
        )
        self.clipsToBounds = true
        self.layer.cornerRadius = 18.5

        let coloredView = UIView(frame: CGRect(
            x: 1.85,
            y: 1.85,
            width: self.frame.size.width - (1.85 * 2),
            height: self.frame.size.height - (1.85 * 2)
        ))
        self.addSubview(coloredView)
        coloredView.backgroundColor = UIColor(red: 0.51, green: 0.76, blue: 0.96, alpha: 1.00)
        coloredView.layer.cornerRadius = 18.5
    }
}
