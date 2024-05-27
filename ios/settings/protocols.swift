import UIKit

// This class is a subclass of UIViewController and conforms to the UITableViewDataSource and UITableViewDelegate protocols. It's responsible for managing the Protocols view.
class ProtocolsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // This is an IBOutlet property that's connected to a UITableView in the storyboard. It's used to display the list of protocols.
    @IBOutlet weak var tableView: UITableView!

    // This is a constant array that contains the names of the protocols to be displayed in the table view.
    let protocols = ["Protocol 1", "Protocol 2", "Protocol 3"]

    // This method is called when the view controller's view is fully loaded into memory. It's used to perform initial setup and configuration.
    override func viewDidLoad() {
        super.viewDidLoad()

        // This line sets the title of the view controller, which is displayed in the navigation bar.
        title = "Protocols"

        // These lines set the data source and delegate of the table view to the view controller itself. The data source is responsible for providing the data to be displayed in the table, while the delegate is responsible for handling events and customizing the appearance of the table.
        tableView.dataSource = self
        tableView.delegate = self

        // This line registers a default UITableViewCell class for the reuse identifier "Cell". This allows the table view to dequeue and reuse cells when they're scrolled off the screen, which can greatly improve performance for large tables.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    // This method is required by the UITableViewDataSource protocol. It's called by the table view to determine the number of rows to display in a given section. In this case, it returns the number of protocols in the array.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return protocols.count
    }

    // This method is required by the UITableViewDataSource protocol. It's called by the table view to dequeue a reusable cell for a given index path and to configure the cell with the appropriate data. In this case, it sets the text of the cell's label to the name of the protocol at the corresponding index in the array.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = protocols[indexPath.row]
        return cell
    }
}
