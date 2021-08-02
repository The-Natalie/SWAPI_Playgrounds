import Foundation

struct Person: Decodable {
    let name: String
    let films: [URL]
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

class SwapiService {
    static let baseURL = URL(string: "https://swapi.dev/api/")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        guard let baseURL = baseURL else { return completion(nil) }
        let finalURL = baseURL.appendingPathComponent("people").appendingPathComponent("\(id)")
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            
            guard let data = data else { return completion(nil) }
            
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                return completion(person)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            
            guard let data = data else { return completion(nil) }
            
            do {
                let decoder = JSONDecoder()
                let film = try decoder.decode(Film.self, from: data)
                return completion(film)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
        }.resume()
    }
    
} // End of Class

SwapiService.fetchPerson(id: 10) { person in
  if let person = person {
      print(person)
    for film in person.films {
        fetchFilm(url: film)
    }
  }
}

func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { film in
        if let film = film {
            print(film)
        }
    }
}
