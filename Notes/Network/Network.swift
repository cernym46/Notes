//
//  Network.swift
//  Notes
//
//  Created by Michal Černý on 13/07/2018.
//  Copyright © 2018 Michal Černý. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case dataEmpty
    case dataInvalid
    case responseInvalid
    case statusCode(Int)
    case urlInvalid
}

class Network {
    private let rootUrl = "http://private-9aad-note10.apiary-mock.com"
    
    func postRequest ( title: String ) {
        guard let url = URL(string: "\(rootUrl)/notes") else {
            print(NetworkError.urlInvalid.localizedDescription)
            return
        }
        var postUrlRequest = URLRequest(url: url)
        postUrlRequest.httpMethod = "POST"
        
        do {
            let newNote: [String: Any] = ["title": title]
            let jsonNote = try JSONSerialization.data(withJSONObject: newNote, options: [])
            postUrlRequest.httpBody = jsonNote
        } catch {
            print(NetworkError.dataInvalid.localizedDescription)
        }
        
        let task = URLSession.shared.dataTask(with: postUrlRequest) {
            (data, response, error) in
            if error != nil { print(error!.localizedDescription) }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print(NetworkError.responseInvalid.localizedDescription)
                return
            }
            if httpResponse.statusCode != 201 { print(NetworkError.statusCode(httpResponse.statusCode)) }
        }
        task.resume()
    }
    
    
    func deleteRequest(id: Int) {
        guard let url = URL(string: "\(rootUrl)/notes/\(id)") else {
            print(NetworkError.urlInvalid.localizedDescription)
            return
        }
        var deleteUrlRequest = URLRequest(url: url)
        deleteUrlRequest.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: deleteUrlRequest) {
            (data, response, error) in
            if error != nil { print(error!.localizedDescription) }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print(NetworkError.responseInvalid.localizedDescription)
                return
            }
            if httpResponse.statusCode != 204 { print(NetworkError.statusCode(httpResponse.statusCode)) }
            
            guard let _ = data else {
                print(NetworkError.responseInvalid.localizedDescription)
                return
            }
        }
        task.resume()
    }
    
    
    func putRequest(id: Int, title: String) {
        guard let url = URL(string: "\(rootUrl)/notes/\(id)") else {
            print(NetworkError.urlInvalid.localizedDescription)
            return
        }
        var putUrlRequest = URLRequest(url: url)
        putUrlRequest.httpMethod = "PUT"
        
        do {
            let newNote: [String: Any] = ["title": title]
            let jsonNote = try JSONSerialization.data(withJSONObject: newNote, options: [])
            putUrlRequest.httpBody = jsonNote
        } catch {
            print(NetworkError.dataInvalid.localizedDescription)
        }
        
        
        let task = URLSession.shared.dataTask(with: putUrlRequest) {
            (data, response, error) in
            if error != nil { print(error!.localizedDescription) }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print(NetworkError.responseInvalid.localizedDescription)
                return
            }
            if httpResponse.statusCode != 201 { print(NetworkError.statusCode(httpResponse.statusCode)) }
        }
        task.resume()
    }
    
    
    
    func getAllRequest() -> [Note] {
        guard let url = URL( string: "\(rootUrl)/notes" ) else {
            print(NetworkError.urlInvalid.localizedDescription)
            return []
        }
        
        var notes : [Note] = []
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil { print(error!.localizedDescription) }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print(NetworkError.responseInvalid.localizedDescription)
                return
            }
            if httpResponse.statusCode != 200 { print(NetworkError.statusCode(httpResponse.statusCode).localizedDescription) }
            
            if let data = data {
                do {
                    // Convert the data to JSON
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as! [[String : Any]]
                    
                    for note in jsonSerialized {
                        guard let note = Note(json: note) else { return }
                        notes.append(note)
                    }
                    
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            
            semaphore.signal();
        }
        
        task.resume()
        semaphore.wait()
        
        return notes
    }
}
