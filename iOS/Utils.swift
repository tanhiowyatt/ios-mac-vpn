import SwiftSVG

func svgImageFromData(svgData: Data, size: CGSize) -> UIImage {
    let svgString = String(data: svgData, encoding: .utf8)
    let svgImage = SVGKImage(string: svgString)
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    svgImage?.draw(at: CGPoint.zero)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image ?? UIImage()
}
