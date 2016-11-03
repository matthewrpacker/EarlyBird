import Foundation

class Course {
    var ID: Int
    var name: String
    var street: String
    var city: String
    var state: String
    var address: String { return "\(street), \(city), \(state)" }
    var imageURL: URL
    var phone: String
    var webURL: URL { return URL(string: "https://early-bird-golf.herokuapp.com/courses/\(ID)")! }
    
    init(dictionary: [String: AnyObject]) {
        self.ID = dictionary["id"]! as! Int
        self.name = dictionary["name"]! as! String
        self.street = dictionary["street"]! as! String
        self.city = dictionary["city"]! as! String
        self.state = dictionary["state"]! as! String
        self.imageURL = URL(string: dictionary["image_path"]! as! String)!
        self.phone = dictionary["phone"]! as! String
    }
}
