import UIKit

class GlowingButton: UIButton {
    private let animationDuration: timeInterval = 0.786
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGlowEffect()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGlowEffect()
    }

    private func setupGlowEffect() {
        layer.shadowColor = UIColor(red: 0.4627, green: 0.8392, blue: 1.0, alpha: 1.0).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }

    func glowForSecond() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.5
        animation.toValue = 1
        animation.duration = animationDuration
        animation.autoreverses = true
        animation.repeatCount = 1
        layer.add(animation, forKey: "glow")
    }

    func createRipple(at point: CGPoint) {
        let circlePath = UIBezierPath(arcCenter: point, radius: 0, startAngle: 0, endAngle: 2 *.pi, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor(red: 0.4627, green: 0.8392, blue: 1.0, alpha: 1.0).cgColor
        shapeLayer.opacity = 0
        layer.addSublayer(shapeLayer)

        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1.5
        animation.duration = animationDuration
        animation.timingFunction =.easeOut
        shapeLayer.add(animation, forKey: "scale")

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0
        opacityAnimation.toValue = 1
        opacityAnimation.duration = animationDuration
        opacityAnimation.timingFunction =.easeOut
        shapeLayer.add(opacityAnimation, forKey: "opacity")

        DispatchQueue.main.asyncAfter(deadline:.now() + animationDuration) {
            shapeLayer.removeFromSuperlayer()
        }
    }
}