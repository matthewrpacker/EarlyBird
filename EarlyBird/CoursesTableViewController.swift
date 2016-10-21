import UIKit

class CoursesTableViewController: UITableViewController {
    let courseNames = ["Wellshire", "Overland Park", "Kennedy"]

    init() {
        super.init(style: .plain)
        title = "Courses"
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self)) as UITableViewCell?
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: String(describing: UITableViewCell.self))
            cell!.textLabel!.font = .systemFont(ofSize: 18)
        }
        cell!.textLabel!.text = courseNames[indexPath.row]
        return cell!
    }
}
