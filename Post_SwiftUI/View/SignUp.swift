//
//  SignUp.swift
//  Post_SwiftUI
//
//  Created by MACPC on 15/03/24.
//

import SwiftUI

class viewModel : ObservableObject{
    
//    @Published var signUp : [signup] = []
    @Published var otpToken: String = ""
    
    func fetch(userName: String, email: String, password: String, confirmPassword: String){
        let url = "https://api.aibautomation.com/api/v1/auth/signup"
        
        let parameters : [String : Any] = [
            "userName": userName,
            "email" : email,
            "password" : password,
            "confirmPassword" : confirmPassword
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
                    print("Error Found:", error!)
                    return
                }
                
                guard let data = data else {
                    print(data)
                    print("Data not Found")
                    
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }
                print(data)
                
                print("HTTP Status Code:", response.statusCode)
                
            if (200 ..< 299) ~= response.statusCode {
                do {
                                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                                       let data = jsonResponse["data"] as? [String: Any],
                                       let otpToken = data["otpToken"] as? String {
                                        // Store otpToken in viewModel
                                        DispatchQueue.main.async {
                                            self.otpToken = otpToken
                                            print("otpToken:", otpToken)
                                        }
                                            
                                    }
                                } catch {
                                print("Error parsing response:", error)
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

struct SignUp: View {
    
    @ObservedObject var view1Model = viewModel()
    
    @State var name : String = ""
     @State var email : String = ""
    @State var password : String = ""
    @State var confoirmpassword : String = ""
    
    @State var otp : Bool = false
    
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            VStack{
                Spacer()
                TextField("Name", text: $name)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("email", text: $email)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("password", text: $password)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("confoirm password", text: $confoirmpassword)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer()
                Button(action: {
                                   // Call fetch method with parameters
                    view1Model.fetch(userName: name, email: email, password: password, confirmPassword: confoirmpassword)
                        self.otp = true // Activate the navigation link
                    
                               }) {
                                   Text("Sign Up")
                                       .font(.system(size: 25, weight: .bold))
                                       .foregroundColor(.black)
                                       .frame(maxWidth: .infinity, maxHeight: 50)
                                       .background(Color.white)
                                       .cornerRadius(20)
                                       .padding(.horizontal)
                                       .padding(.bottom, 10)
                               }
            }
            .navigationBarHidden(true)
            NavigationLink(destination: Otp(otpToken: view1Model.otpToken, numberofFields: 4), isActive: $otp) { EmptyView() }
        }
        
        
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
