import UIKit

extension UIView {

    func prepareForConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    func setGradient(colors: [CGColor], startPoint: CGPoint? = nil, endPoint: CGPoint? = nil) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors
        if let startPoint = startPoint, let endPoint = endPoint {
            gradient.startPoint = startPoint
            gradient.endPoint = endPoint
        }
        self.layer.addSublayer(gradient)
    }
}
