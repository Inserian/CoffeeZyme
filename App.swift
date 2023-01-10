#CoffeeZyme
import UIKit
import Foundation

class Product {
    var name: String
    var price: Double
    var image: UIImage

    init(name: String, price: Double, image: UIImage) {
        self.name = name
        self.price = price
        self.image = image
    }
}

class ShoppingCart {
    var items: [Product]

    func totalPrice() -> Double {
        var total: Double = 0
        for item in items {
            total += item.price
        }
        return total
    }

    func addProduct(product: Product) {
        items.append(product)
    }

    func removeProduct(product: Product) {
        if let index = items.firstIndex(of: product) {
            items.remove(at: index)
        }
    }
}

class ProductTableViewCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
}

class ProductTableViewController: UITableViewController {
    var products: [Product] = []
    var shoppingCart = ShoppingCart()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize products array with sample data
        products.append(Product(name: "Brazilian", price: 10.99, image: UIImage(named: "brazilian")!))
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
        let product = products[indexPath.row]
        cell.productNameLabel.text = product.name
        cell.productPriceLabel.text = "$\(product.price)"
        cell.productImageView.image = product.image
        cell.addToCartButton.tag = indexPath.row
        cell.addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped(_:)), for: .touchUpInside)
        return cell
    }

    @objc func addToCartButtonTapped(_
    @objc func addToCartButtonTapped(_ sender: UIButton) {
        let product = products[sender.tag]
        shoppingCart.addProduct(product: product)
        let alertController = UIAlertController(title: "Success", message: "Product added to cart", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func viewCartButtonTapped(_ sender: UIBarButtonItem) {
        let cartViewController = storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        cartViewController.shoppingCart = shoppingCart
        navigationController?.pushViewController(cartViewController, animated: true)
    }
}

class CartViewController: UIViewController {
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    var shoppingCart: ShoppingCart!

    override func viewDidLoad() {
        super.viewDidLoad()
        totalPriceLabel.text = "$\(shoppingCart.totalPrice())"
    }

    @IBAction func purchaseButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Success", message: "Purchase complete", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
