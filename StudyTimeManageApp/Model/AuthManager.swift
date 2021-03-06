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
    let studyTime = studyTimeClass()
    public func startAuth(phoneNumber:String,compleation:@escaping (Bool) -> Void){
        PhoneAuthProvider.provider().verifyPhoneNumber( phoneNumber, uiDelegate: nil) { (verificationId, error) in
            guard let verificationId = verificationId,error == nil else{
               print("------------------")
                print(error)
                print("------------------")
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

            if self.studyTime.getUserName().isEmpty {
                let initialDate = Date()
                let math = Math()
                let friendID = math.generator(30)
                UserDefaults.standard.setValue(friendID, forKey: "friendid")
                UserDefaults.standard.setValue(initialDate, forKey: "initialdate")
              
                Database.shered.postGoal(goal: "Goal", username: "No Name", image: "かえる")
                Database.shered.postFriendID(id: friendID)
            }
            UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "userid")
            compleation(true)
        }
    }
    
    
    
    func apple(){
        
    }
    
    func facebook(token:String,compleation:@escaping (Bool) -> Void){
        let credintial = FacebookAuthProvider.credential(withAccessToken:token)
        auth.signIn(with: credintial) { (result, error) in
            if let error = error{
                compleation(false)
                print(error)
                return
            }
            
            //保存されていないか確認する
            if self.studyTime.getUserName().isEmpty {
                let initialDate = Date()
                let math = Math()
                let friendID = math.generator(30)
//                let profileimage = result?.user.photoURL?.absoluteURL
                UserDefaults.standard.setValue(friendID, forKey: "friendid")
                UserDefaults.standard.setValue(initialDate, forKey: "initialdate")
                UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "userid")
                Database.shered.postGoal(goal: "10000時間達成を目指しています", username: (result?.user.displayName)!, image: "かえる")
                Database.shered.postFriendID(id: friendID)
            }
            UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: "userid")
            compleation(true)
            
        }
    }
    func Twitter(){}
    
    
    
    func logout() -> UIViewController{
            let auth = Auth.auth()
        
            do {
                try auth.signOut()
            }
            catch let signOutError as NSError {
                print("SignOutに失敗しました")
                print(signOutError)
                
            }
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "splash")
        VC.modalPresentationStyle = .fullScreen
       return VC
      
    }
    
    func deleteAllUserData(){
        let userid = Auth.auth().currentUser?.uid //
        
        Firestore.firestore().collection("Users").document(userid!).collection("MonthStudyTime").getDocuments { (snapshot, error) in
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
            print(error)
            print("アカウント削除に失敗しました")
          } else {
            // Account deleted.
            print("アカウントを削除しました")
          }
        }
    }
}
