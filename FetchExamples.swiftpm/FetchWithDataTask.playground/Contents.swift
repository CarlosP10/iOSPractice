import UIKit
import Foundation

func fetchData(from urlString: String){
    //1. Create a url object
    guard let url = URL(string: urlString) else {
        print("Invalid URL string")
        return
    }
    
    //Step 2. Create URL Request
    let request = URLRequest(url: url)
    
    //Step 3. Create url session data task
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        //Handle errors
        if let error = error {
            print("Error making requestion \(error.localizedDescription)")
            return
        }
        
        //Ensure got a valid reponse
        guard let response = response as? HTTPURLResponse,
              (200...209).contains(response.statusCode) else {
            print("Invalid reponse")
            return
        }
        
        //Ensure we got a data
        guard let data = data else {
            print("No data received")
            return
        }
        
        // Step 4: Parse the data into JSON format
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON RESPONSE \n \(jsonString)")
            }
        } catch {
            print("Error parsing JSON data: \(error.localizedDescription)")
        }
    }
    //Step 5. Start the task
    task.resume()
}

let urlString = "https://jsonplaceholder.typicode.com/posts/1"
fetchData(from: urlString)
