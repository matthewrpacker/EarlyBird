import UIKit
import Foundation

class CoursesTableViewController: UITableViewController {
    var courses = [Course]()

    init() {
        super.init(style: .plain)
        title = "Courses"
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") } // NSCoding

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        makeGetRequest()
    }
    
    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self)) as UITableViewCell?
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: String(describing: UITableViewCell.self))
            cell!.textLabel!.font = .systemFont(ofSize: 18)
            cell!.accessoryType = .disclosureIndicator
        }
        let course = courses[indexPath.row]
        cell!.textLabel!.text = course.name
        cell!.detailTextLabel!.text = course.address
        return cell!
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let course = courses[indexPath.row]
        UIApplication.shared.open(course.webURL, options: [:])
    }

    // MARK: - Helpers

    func makeGetRequest() {
        let courseEndpoint = "https://early-bird-courses.herokuapp.com/api/v1/courses"
        let urlRequest = URLRequest(url: URL(string: courseEndpoint)!)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let responseData = data else {
                return DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Networing Error", message: "Could not connect.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(alert, animated: true)
                }
            }
            let courseDictionaries = try! JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [[String: AnyObject]]
            for courseDictionary in courseDictionaries {
                let course = Course(dictionary: courseDictionary)
                self.courses.append(course)
            }
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
        dataTask.resume()
    }
}
