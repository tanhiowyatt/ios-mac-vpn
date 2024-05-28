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

        let selectedButton = GlowingButton(type:.custom)
        selectedButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        selectedButton.setBackgroundImage(
            svgImageFromData(
                svgData: row["selected"] as? Bool? "enabledCheckMark.svg" : "disabledCheckMark.svg"
            ), for:.normal
        )
        selectedButton.addTarget(self, action: #selector(selectedButtonTapped), for:.touchUpInside)
        selectedButton.tag = indexPath.row
        cell.contentView.addSubview(selectedButton)
        cell.selectedButton = selectedButton

        let favoriteButton = GlowingButton(type:.custom)
        favoriteButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        favoriteButton.setBackgroundImage(
            svgImageFromData(
                svgData: row["favorited"] as? Bool? "enabledFavorite.svg" : "disabledFavorite.svg"
            ), for:.normal
        )
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for:.touchUpInside)
        favoriteButton.tag = indexPath.row
        cell.contentView.addSubview(favoriteButton)
        cell.favoriteButton = favoriteButton

        return cell
    }

    @objc func selectedButtonTapped(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        data[indexPath.row]["selected"] = true
        tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with:.automatic)

        UserDefaults.standard.set(indexPath.row, forKey: "selectedServer")
    }

    @objc func favoriteButtonTapped(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        data[indexPath.row]["favorited"] =!data[indexPath.row]["favorited"]!
        sender.setBackgroundImage(
            svgImageFromData(
                svgData: data[indexPath.row]["favorited"] as? Bool? "enabledFavorite.svg" : "disabledFavorite.svg"
            ), for:.normal
        )
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // no implementation needed
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
    var selectedButton: GlowingButton!
    var favoriteButton: GlowingButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode =.scaleAspectFit
    }
}