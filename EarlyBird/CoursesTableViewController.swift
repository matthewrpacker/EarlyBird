import UIKit
import Foundation

class CoursesTableViewController: UITableViewController {
    var courseNames = [String]()
    
    init() {
        super.init(style: .plain)
        title = "Courses"
        makeGetRequest()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
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
    
    func makeGetRequest() {
        let courseEndpoint: String = "https://early-bird-courses.herokuapp.com/api/v1/courses/1"
        
        guard let url = URL(string: courseEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the GET request
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print("error calling GET on /courses/1")
                print(error)
                return
            }

            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON
            do {
                guard let course = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                // print the entire course dictionary
                print("The course is: \(course)")
                
                // assign course["name"] to constant courseName
                guard let courseName = course["name"] as? String else {
                    print("Could not get course name from JSON")
                    return
                }
                self.courseNames.append(courseName)
                // prove that courseName is appended to courseNames array
                print(self.courseNames)
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            // reload main thread (UI view) with appended data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
}
