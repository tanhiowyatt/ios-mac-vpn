import SwiftSVG

func svgImageFromData(svgData: Data, size: CGSize) -> UIImage {
    guard let svgString = String(data: svgData, encoding:.utf8) else {
        return UIImage()
    }
    guard let svgImage = SVGKImage(string: svgString) else {
        return UIImage()
    }
    svgImage.size = size
    let renderer = UIGraphicsImageRenderer(size: size)
    let image = renderer.image { _ in
        svgImage.draw(at: CGPoint.zero)
    }
    return image
}