import UIKit

protocol TorBridgeSelectionDelegate: AnyObject {
    func didChooseBridge(_ bridge: String)
}

class TorBridgeSelectionView: UIView, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView()
    private let okButton = UIButton()
    private let bridges = ["Obfs4", "Meek Azure", "Snowflake"]
    private var selectedBridge: String?
    weak var delegate: TorBridgeSelectionDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)

        tableView.frame = CGRect(x: 20, y: 100, width: bounds.width - 40, height: bounds.height - 200)
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BridgeCell")
        blurEffectView.contentView.addSubview(tableView)

        okButton.frame = CGRect(x: (bounds.width - 100) / 2, y: bounds.height - 80, width: 100, height: 40)
        okButton.setTitle("OK", for: .normal)
        okButton.backgroundColor = .systemBlue
        okButton.layer.cornerRadius = 10
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        blurEffectView.contentView.addSubview(okButton)
    }

    @objc private func okButtonTapped() {
        removeFromSuperview()
        if let selectedBridge = selectedBridge {
            delegate?.didChooseBridge(selectedBridge)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bridges.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BridgeCell", for: indexPath)
        cell.textLabel?.text = bridges[indexPath.row]
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBridge = bridges[indexPath.row]
        if selectedBridge == "Input Custom Bridge" {
            showCustomBridgeInput()
        }
    }

    private func showCustomBridgeInput() {
        let alertController = UIAlertController(title: "Custom Bridge", message: "Enter the custom bridge URL", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Bridge URL"
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if let bridgeURL = alertController.textFields?.first?.text {
                self?.selectedBridge = bridgeURL
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.selectedBridge = nil
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        if let viewController = self.window?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}
