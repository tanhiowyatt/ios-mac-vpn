import UIKit

class ServersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var data = [
        ["country": "United States", "image": "US.svg", "favorited": false, "selected": true],
        ["country": "Russia", "image": "Russia.svg", "favorited": false, "selected": false],
        ["country": "United Kingdom", "image": "UK.svg", "favorited": false, "selected": false],
        ["country": "Germany", "image": "Germany.svg", "favorited": false, "selected": false],
        ["country": "France", "image": "France.svg", "favorited": false, "selected": false],
        ["country": "Poland", "image": "Poland.svg", "favorited": false, "selected": false]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 10))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        let row = data[indexPath.row]
        cell.titleLabel.text = row["country"] as? String
        cell.imageView.image = svgImageFromData(svgData: row["image"] as? String)
        cell.doneImageView.image = svgImageFromData(svgData: row["selected"] as? Bool? "enabledCheckMark.svg" : "disabledCheckMark.svg")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        data[indexPath.row]["selected"] = true
        let cell = tableView.cellForRow(at: indexPath) as! CustomCell
        cell.doneImageView.image = svgImageFromData(svgData: "enabledCheckMark.svg")
        tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with:.automatic)

        UserDefaults.standard.set(indexPath.row.text, forKey: "selectedServer")
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
