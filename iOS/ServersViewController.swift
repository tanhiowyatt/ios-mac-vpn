import UIKit

class ServersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var data = [
        ["country": "United Stated", "image": "US.svg", "favorited": false, "selected": true],
        ["country": "Russia", "image": "Russia.svg", "favorited": false, "selected": false],
        ["country": "United Kingdome", "image": "UK.svg", "favorited": false, "selected": false]
        ["country": "Germany", "image": "Germany.svg", "favorited": false, "selected": false],
        ["country": "France", "image": "France.svg", "favorited": false, "selected": false],
        ["country": "Poland", "image": "Poland.svg", "favorited": false, "selected": false]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        let row = data[indexPath.row]
        cell.titleLabel.text = row["country"] as? String
        cell.imageView.image = svgImageFromData(
            svgData: NSData(contentsOfFile: String(row["image"]) as Data, size: CGSize(width: 100, height: 100)
            )
        )
        cell.doneImageView.image = svgImageFromData(
            svgData: NSData(
                contentsOfFile: String(row["selected"] as Bool .false? "disabledCheckMark.svg" : "enabledCheckMark.svg") as Data,
                size: CGSize(width: 100, height: 100)
            )
        )
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        data[indexPath.row]["selected"] = true
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        cell.imageView.image = svgImageFromData(
            svgData: NSData(contentsOfFile: String("enabledCheckMark.svg") as Data, size: CGSize(width: 100, height: 100))
        )
        tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with:.automatic)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor =.gray
        return view
    }
}

class CustomCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteImageVIew: UIImageView!
    @IBOutlet weak var doneImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode =.scaleAspectFit
        doneImageView.contentMode =.scaleAspectFit
    }
}