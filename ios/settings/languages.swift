import UIKit // Importing the UIKit framework which provides the necessary infrastructure for your iOS apps

class LanguageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // This class is a subclass of UIViewController and conforms to the UITableViewDataSource and UITableViewDelegate protocols. It's responsible for managing the view that displays a list of languages.

    @IBOutlet weak var tableView: UITableView!
    // This is an outlet for a UITableView. It's a weak reference because it's expected to be set by the storyboard at runtime and it doesn't need to persist beyond that.

    let languages = ["English", "Russian", "Spanish", "French", "Chinese"]
    // This is an array of strings that represents the languages to be displayed in the table view.

    override func viewDidLoad() {
        super.viewDidLoad()
        // Calling the superclass's viewDidLoad method to ensure that the view is properly initialized.

        title = "Language"
        // Setting the title of the view controller, which will be displayed in the navigation bar.

        tableView.dataSource = self
        // Setting the table view's data source to the current instance of the LanguageViewController. This means that the table view will ask this instance for the data to display.

        tableView.delegate = self
        // Setting the table view's delegate to the current instance of the LanguageViewController. This means that the table view will ask this instance for permission to do certain things, like deleting a row.

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // Registering a UITableViewCell class for a reuse identifier. This is a way to tell the table view how to create a new cell. When the table view needs a new cell, it will dequeue a reusable one if it exists, or it will create a new one using the registered class or nib.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // This method is required by the UITableViewDataSource protocol. It's called by the table view to determine the number of rows in a given section.

        return languages.count
        // Returning the count of the languages array, which represents the number of rows in the table view.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // This method is required by the UITableViewDataSource protocol. It's called by the table view to get a cell to display for a particular row.

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // Dequeuing a reusable cell with the given reuse identifier for the specified index path.

        cell.textLabel?.text = languages[indexPath.row]
        // Setting the text of the cell's text label to the language at the current row in the languages array.

        return cell
        // Returning the configured cell to the table view.
    }
}
