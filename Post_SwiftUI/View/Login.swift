//
//  Login.swift
//  Post_SwiftUI
//
//  Created by MACPC on 15/03/24.
//

import SwiftUI

class ViewModel : ObservableObject{
    
    func fetch(email : String , password : String){
        let url = "https://api.aibautomation.com/api/v1/auth/login"
        
        let parameters : [String : Any] = [
            "email" : email,
            "password": password
        ]
        
        
        guard let apiUrl = URL(string: url) else{
            print("Url can not be created")
            return
        }
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("Error Found", error)
                return
            }

            guard let data = data else {
                print("Data not Found")
                return
            }

            guard let response = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }

            print("HTTP Status Code:", response.statusCode)

            if (200 ..< 299) ~= response.statusCode {
                do{
                
                    if let jsonResponse = try JSONSerialization.jsonObject(with : data , options: []) as? [String : Any],
                       let userData = jsonResponse["data"] as? [String : Any],
                       let userId = userData["id"] as? Int{
                        
//
//                        UserDefaults.standard.set(userId, forKey: "userId")
//                        print(userId)
                // Navigate to WelcomeViewController
//                DispatchQueue.main.async {
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    if let welcomeViewController = storyboard.instantiateViewController(withIdentifier: "welcome") as? WelcomeViewController {
//                        // Set any necessary properties on welcomeViewController before presenting it
//                        self.navigationController?.pushViewController(welcomeViewController, animated: true)
//                    }
//                }
                    }
                } catch {
                    print("Error", error)
                }
            } else {
                // Handle unsuccessful response
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response - Error:", responseString)
                }
            }
        }.resume()
    }
}

struct Login: View {
    
    @ObservedObject var viewmodel = ViewModel()
    
    @State var email : String = ""
    @State var password : String = ""
    
    @State var login : Bool = false
    var body: some View {
        ZStack{
            Color.black
            VStack{
                Spacer()
                TextField("email", text: $email)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("password", text: $password)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer()
                Button(action: {
                                   // Call fetch method with parameters
                    viewmodel.fetch(email: email, password: password)
                        self.login = true // Activate the navigation link
                    
                               }) {
                                   Text("Login")
                                       .font(.system(size: 25, weight: .bold))
                                       .foregroundColor(.black)
                                       .frame(maxWidth: .infinity, maxHeight: 50)
                                       .background(Color.white)
                                       .cornerRadius(20)
                                       .padding(.horizontal)
                                       .padding(.bottom, 10)
                               }
                
            }
            NavigationLink(destination: Welcome(), isActive: $login) { EmptyView() }
            .navigationBarHidden(true)
        }
        .ignoresSafeArea()
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
