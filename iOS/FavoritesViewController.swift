import UIKit

class FavoriteServersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var favoriteServers: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 10))
        loadFavoriteServersFromUserDefaults()
    }

    func loadFavoriteServersFromUserDefaults() {
        if let favoriteServersData = UserDefaults.standard.object(forKey: "favoriteServers") as? [[String: Any]] {
            favoriteServers = favoriteServersData
        } else {
            favoriteServers = []
        }
        tableView.reloadData()
    }

    func saveFavoriteServersToUserDefaults() {
        UserDefaults.standard.set(favoriteServers, forKey: "favoriteServers")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteServers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteServerCell", for: indexPath) as! CustomCell
        let row = favoriteServers[indexPath.row]
        cell.titleLabel.text = row["country"] as? String
        cell.imageView.image = svgImageFromData(svgData: row["image"] as? String)
        cell.doneImageView.image = svgImageFromData(svgData: row["selected"] as? Bool? "enabledCheckMark.svg" : "disabledCheckMark.svg")
        cell.favoriteImageView.image = svgImageFromData(svgData: row["favorited"] as? Bool? "favoriteStarFilled.svg" : "favoriteStarEmpty.svg")
        cell.favoriteImageView.tag = indexPath.row
        cell.favoriteImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(favoriteImageViewTapped(_:)))
        cell.favoriteImageView.addGestureRecognizer(tapGestureRecognizer)
        return cell
    }

    @objc func favoriteImageViewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let indexPathRow = gestureRecognizer.view?.tag
        if let indexPathRow = indexPathRow {
            favoriteServers[indexPathRow]["favorited"] =!(favoriteServers[indexPathRow]["favorited"] as? Bool?? false)
            tableView.reloadRows(at: [IndexPath(row: indexPathRow, section: 0)], with:.automatic)
            saveFavoriteServersToUserDefaults()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        favoriteServers[indexPath.row]["selected"] = true
        let cell = tableView.cellForRow(at: indexPath) as! CustomCell
        cell.doneImageView.image = svgImageFromData(svgData: "enabledCheckMark.svg")
        tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with:.automatic)
        saveFavoriteServersToUserDefaults()
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