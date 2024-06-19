//
//  DbFirebase.swift
//  MyProject
//
//  Created by 김마리아 on 6/19/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class DbFirebase: Database {
    var reference: CollectionReference = Firestore.firestore().collection("items")
    var parentNotification: (([String: Any]?, String?) -> Void)?
    var existQuery: ListenerRegistration?

    required init(parentNotification: (([String: Any]?, String?) -> Void)?) {
        self.parentNotification = parentNotification
    }

    func saveChange(key: String, object: [String: Any], action: String) {
        if action == "delete" {
            reference.document(key).delete()
            return
        }
        reference.document(key).setData(object)
    }

    func setQuery(from: Any, to: Any) {
        if let query = existQuery {
            query.remove()
        }

        let query = reference.whereField("timestamp", isGreaterThanOrEqualTo: from).whereField("timestamp", isLessThanOrEqualTo: to)
        existQuery = query.addSnapshotListener(onChangingData)
    }

    func onChangingData(querySnapshot: QuerySnapshot?, error: Error?) {
        guard let querySnapshot = querySnapshot else { return }
        if querySnapshot.documentChanges.count == 0 { return }

        for documentChange in querySnapshot.documentChanges {
            let dict = documentChange.document.data()
            var action: String?
            switch documentChange.type {
            case .added: action = "add"
            case .modified: action = "modify"
            case .removed: action = "delete"
            }
            if let parentNotification = parentNotification {
                parentNotification(dict, action)
            }
        }
    }

    func uploadImage(imageName: String, image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        let reference = Storage.storage().reference().child("items").child(imageName)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"

        reference.putData(imageData, metadata: metaData) { metadata, error in
            if error != nil {
                completion(nil)
                return
            }
            reference.downloadURL { url, error in
                completion(url?.absoluteString)
            }
        }
    }

    func downloadImage(imageName: String, completion: @escaping (UIImage?) -> Void) {
        let reference = Storage.storage().reference().child("items").child(imageName)
        let megaByte = Int64(10 * 1024 * 1024)

        reference.getData(maxSize: megaByte) { data, error in
            completion(data != nil ? UIImage(data: data!) : nil)
        }
    }
}
