//
//  Photo.swift

import Foundation

//
struct Photos: Decodable {
    let pictures: [Photo]
    let page: Int
    let pageCount: Int
    let hasMore: Bool
    
    enum CodingKeys : String, CodingKey {
        case pictures
        case page
        case pageCount
        case hasMore
    }
}

//
struct Photo: Decodable {
    
    public static let fake = Photo(id: "", croppedPicture: "")
    
    let id: String
    let croppedPicture: String
    
    enum CodingKeys : String, CodingKey {
        case id
        case croppedPicture = "cropped_picture"
    }
}

struct PhotoDetails: Decodable {
    let id: String
    let author: String
    let camera: String
    let cropped_picture: String
    let full_picture: String
    
    enum CodingKeys : String, CodingKey {
        case id
        case author
        case camera
        case cropped_picture
        case full_picture
    }
}

//
extension Photo {
    //
    func posterURL() -> URL? {
//        guard let url = URL(string: Settings().PosterEndpoint + posterPath) else {
//            Log.error("FAILED CREATING POSTER URL")
//            return nil
//        }
//
//        return url
        return nil
    }
}
