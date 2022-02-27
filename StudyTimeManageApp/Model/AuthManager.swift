//
//  AuthManager.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/02/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthManager{
    static let shered = AuthManager()
    private let auth = Auth.auth()
    private var verificationId: String?
    public func startAuth(phoneNumber:String,compleation:@escaping (Bool) -> Void){
        PhoneAuthProvider.provider().verifyPhoneNumber( phoneNumber, uiDelegate: nil) { (verificationId, error) in
            guard let verificationId = verificationId,error == nil else{
                compleation(false)
                return
            }
            self.verificationId = verificationId
            compleation(true)
        }
    }
    public func vertifycode(smCode: String,compleation:@escaping (Bool) -> Void){
        guard  let vetificationId = verificationId else {
            return
        }
        let credintial = PhoneAuthProvider.provider().credential(withVerificationID: vetificationId, verificationCode: smCode)
        auth.signIn(with: credintial) { (result, error) in
            if let error = error{
                print(error)
                compleation(false)
                return
            }
            UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "userid")
            Database.shered.postGoal(goal: "Goal", username: "No Name", image: "かえる")
            compleation(true)
        }
    }
    
    func deleteAllUserData(){
        let userid = Auth.auth().currentUser?.uid
        
        Firestore.firestore().collection("Users").document(userid!).collection("MonthlyStudyTime").getDocuments { (snapshot, error) in
            if let error = error{
                print("エラー",error)
                return
            }
         
            for document in snapshot!.documents{
                document.reference.delete()
            }
            
        }
        
        Firestore.firestore().collection("Users").document(userid!).collection("Record").getDocuments { (snapshot, error) in
            if let error = error{
                print("エラー",error)
                return
            }
            
            for document in snapshot!.documents{
                document.reference.delete()
            }
            
        }
        Firestore.firestore().collection("Users").document(userid!).collection("StudyTime").getDocuments { (snapshot, error) in
            if let error = error{
                print("エラー",error)
                return
            }
            
            for document in snapshot!.documents{
                document.reference.delete()
            }
            
        }
        Firestore.firestore().collection("Users").document(userid!).collection("Total").getDocuments { (snapshot, error) in
            if let error = error{
                print("エラー",error)
                return
            }
            
            for document in snapshot!.documents{
                document.reference.delete()
            }
            
        }
        
        
        Firestore.firestore().collection("Users").document(userid!).delete()
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        
        let user = Auth.auth().currentUser

        user?.delete { error in
          if let error = error {
            // An error happened.
            print("アカウント削除に失敗しました")
          } else {
            // Account deleted.
            print("アカウントを削除しました")
          }
        }
    }
}
