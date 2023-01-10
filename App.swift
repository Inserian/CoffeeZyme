import UIKit

class Product {
    var name: String
    var imageURL: URL
    var price: Double
    var productDescription: String

    init(name: String, imageURL: URL, price: Double, productDescription: String) {
        self.name = name
        self.imageURL = imageURL
        self.price = price
        self.productDescription = productDescription
    }
}

class ProductCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!

    func configure(with product: Product) {
        nameLabel.text = product.name
        priceLabel.text = "$\(product.price)"
        productDescriptionLabel.text = product.productDescription

        let task = URLSession.shared.dataTask(with: product.imageURL) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.productImageView.image = image
                }
            }
        }
        task.resume()
    }
}

class ProductsViewController: UITableViewController {
    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. Get the JSON data from the server
        let url = URL(string: "http://www.coffeezyme.com/api/products")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                // 2. Parse the JSON data into an array of Product objects
                let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
                self.products = json.map { productJson in
                    let name = productJson["name"] as! String
                    let imageURL = URL(string: productJson["image_url"] as! String)!
                    let price = productJson["price"] as! Double
                    let productDescription = productJson["description"] as! String
                    return Product(name: name, imageURL: imageURL, price: price, productDescription: productDescription)
                }

                // 3. Reload the table view
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
