//
//  Otp.swift
//  Post_SwiftUI
//
//  Created by MACPC on 15/03/24.
//

import SwiftUI

class viewmodel : ObservableObject{
    
    
    func fetch(otp : String , otpToken : String, completion: @escaping (Bool) -> Void){
    let url = "https://api.aibautomation.com/api/v1/auth/verify-account"

    let parameter: [String: Any] = [
        "otp": otp,
        "resetToken" :  otpToken
    ]
    

    guard let apiUrl = URL(string: url) else {
        print("Url can not be created")
        completion(false)
        return
    }

    guard let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: [])
    else {
        completion(false)
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
            completion(false)
            return
        }

        guard let data = data else {
            print("Data not Found")
            completion(false)
            return
        }

        guard let response = response as? HTTPURLResponse else {
            print("Invalid response")
            completion(false)
            return
        }
        print(otpToken)

        print("HTTP Status Code:", response.statusCode)

        if (200 ..< 299) ~= response.statusCode {
            completion(true)
           
            // Navigate to WelcomeViewController
//            DispatchQueue.main.async {
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                if let welcomeViewController = storyboard.instantiateViewController(withIdentifier: "welcome") as? WelcomeViewController {
//                    // Set any necessary properties on welcomeViewController before presenting it
//                    self.navigationController?.pushViewController(welcomeViewController, animated: true)
//                }
//            }
        } else {
            // Handle unsuccessful response
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response - Error:", responseString)
            }
            completion(false)
            
        }
    }.resume()
    }
}

struct Otp: View {
    @ObservedObject var view = viewmodel()
    let otpToken: String
    private var numberofFields: Int
    
    @State private var otpValues: [String]
    @FocusState private var fieldFocus: Int?
    @State private var oldValue = ""
    
    @State var welcome: Bool = false
    
    init(otpToken: String, numberofFields: Int){
        self.otpToken = otpToken
        self.numberofFields = numberofFields
        self.otpValues = Array(repeating: "", count: numberofFields)
    }
    
    // Function to concatenate the values of text fields
    private func concatenateOTP() -> String {
        return otpValues.joined()
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                ForEach(0..<numberofFields, id: \.self) { index in
                    TextField("", text: $otpValues[index], onEditingChanged: { editing in
                        if editing {
                            oldValue = otpValues[index]
                        }
                    })
                    .keyboardType(.numberPad)
                    .frame(width: 48, height: 48)
                    .background(.gray.opacity(0.1))
                    .cornerRadius(15)
                    .multilineTextAlignment(.center)
                    .focused($fieldFocus, equals: index)
                    .tag(index)
                    .onChange(of: otpValues[index]) { newValue in
                        if otpValues[index].count > 1 {
                            otpValues[index] = String(otpValues[index].suffix(1))
                        }
                        if !newValue.isEmpty {
                            if index == numberofFields - 1 {
                                fieldFocus = nil
                            } else {
                                fieldFocus = (fieldFocus ?? 0) + 1
                            }
                        } else {
                            fieldFocus = (fieldFocus ?? 0) - 1
                        }
                    }
                    .disableAutocorrection(true) // Disable autocorrection
                }
            }
            Spacer()
            
            Button(action: {
                let concatenatedOTP = concatenateOTP()
                print("Entered OTP: \(concatenatedOTP)")
                view.fetch(otp: concatenatedOTP, otpToken: otpToken){  success in
                    if success{
                        self.welcome = true
                    } else{
                        print("Enter the correct otp")
                    }
                }
               
            }, label: {
                Text("Verify")
                    .foregroundColor(.white)
                    .font(.system(size: 25, weight: .bold))
                    .frame(maxWidth : .infinity , maxHeight: 50)
                    .background(.black)
                    .cornerRadius(20)
                    .padding()
            })
        }
        .navigationBarHidden(true)
        NavigationLink(destination: Welcome(), isActive: $welcome) { EmptyView() }
    }
}
struct Otp_Previews: PreviewProvider {
    static var previews: some View {
        Otp( otpToken: "", numberofFields: 4)
    }
}
