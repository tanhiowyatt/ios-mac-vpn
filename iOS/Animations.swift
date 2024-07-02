import UIKit

class GlowingButton: UIButton {

    private var isAnimating = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    private func setupButton() {
        self.backgroundColor = .systemBlue
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.shadowColor = UIColor.cyan.cgColor
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.addTarget(self, action: #selector(toggleAnimation), for: .touchUpInside)
    }

    @objc private func toggleAnimation() {
        if isAnimating {
            stopGlowingAnimation()
        } else {
            startGlowingAnimation()
        }
        isAnimating.toggle()
    }

    private func startGlowingAnimation() {
        let glowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        glowAnimation.fromValue = 0.0
        glowAnimation.toValue = 1.0
        glowAnimation.duration = 1.0
        glowAnimation.autoreverses = true
        glowAnimation.repeatCount = .infinity

        self.layer.add(glowAnimation, forKey: "glowingAnimation")
    }

    private func stopGlowingAnimation() {
        self.layer.removeAnimation(forKey: "glowingAnimation")
    }
}


class RotatingGradientButton: UIButton {

    private var glowingLayer: CAGradientLayer!
    private var isAnimating = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        setupGlowingLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
        setupGlowingLayer()
    }

    private func setupButton() {
        self.backgroundColor = .systemBlue
        self.layer.cornerRadius = self.frame.size.width / 2
        self.addTarget(self, action: #selector(toggleAnimation), for: .touchUpInside)
    }

    private func setupGlowingLayer() {
        glowingLayer = CAGradientLayer()
        glowingLayer.frame = self.bounds.insetBy(dx: -10, dy: -10)
        glowingLayer.cornerRadius = self.layer.cornerRadius + 10
        glowingLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.cyan.withAlphaComponent(0.5).cgColor,
            UIColor.cyan.cgColor,
            UIColor.cyan.withAlphaComponent(0.5).cgColor,
            UIColor.clear.cgColor
        ]
        glowingLayer.locations = [0, 0.2, 0.5, 0.8, 1]
        glowingLayer.startPoint = CGPoint(x: 0.5, y: 0)
        glowingLayer.endPoint = CGPoint(x: 0.5, y: 1)
        self.layer.insertSublayer(glowingLayer, below: self.layer)
    }

    @objc private func toggleAnimation() {
        if isAnimating {
            stopGlowingAnimation()
        } else {
            startGlowingAnimation()
        }
        isAnimating.toggle()
    }

    private func startGlowingAnimation() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat.pi * 2
        rotateAnimation.duration = 4.0
        rotateAnimation.repeatCount = .infinity

        glowingLayer.add(rotateAnimation, forKey: "rotateAnimation")
    }

    private func stopGlowingAnimation() {
        glowingLayer.removeAnimation(forKey: "rotateAnimation")
    }
}


class ScalingFadingArcButton: UIButton {

    private var arcLayer: CAShapeLayer!
    private var isAnimating = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        setupArcLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
        setupArcLayer()
    }

    private func setupButton() {
        self.backgroundColor = .systemBlue
        self.layer.cornerRadius = self.frame.size.width / 2
        self.addTarget(self, action: #selector(toggleAnimation), for: .touchUpInside)
    }

    private func setupArcLayer() {
        arcLayer = CAShapeLayer()
        let arcPath = UIBezierPath(ovalIn: self.bounds.insetBy(dx: -15, dy: -15))
        arcLayer.path = arcPath.cgPath
        arcLayer.fillColor = UIColor.clear.cgColor
        arcLayer.strokeColor = UIColor.cyan.cgColor
        arcLayer.lineWidth = 5
        arcLayer.opacity = 0.0

        self.layer.insertSublayer(arcLayer, below: self.layer)
    }

    @objc private func toggleAnimation() {
        if isAnimating {
            stopGlowingAnimation()
        } else {
            startGlowingAnimation()
        }
        isAnimating.toggle()
    }

    private func startGlowingAnimation() {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.8
        scaleAnimation.toValue = 1.2
        scaleAnimation.duration = 1.0
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = .infinity

        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 0.5
        fadeAnimation.toValue = 1.0
        fadeAnimation.duration = 1.0
        fadeAnimation.autoreverses = true
        fadeAnimation.repeatCount = .infinity

        arcLayer.add(scaleAnimation, forKey: "scaleAnimation")
        arcLayer.add(fadeAnimation, forKey: "fadeAnimation")
    }

    private func stopGlowingAnimation() {
        arcLayer.removeAnimation(forKey: "scaleAnimation")
        arcLayer.removeAnimation(forKey: "fadeAnimation")
    }
}
