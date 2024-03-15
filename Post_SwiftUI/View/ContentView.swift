//
//  ContentView.swift
//  Post_SwiftUI
//
//  Created by MACPC on 15/03/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var signup : Bool = false
    @State var login : Bool = false
    
    var body: some View {
        
        NavigationView{
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack{
                    Spacer()
                    NavigationLink(isActive: $signup, destination: {SignUp()}, label: {
                        Text("Sign up")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth : .infinity , maxHeight: 50)
                            .background(.white)
                            .cornerRadius(20)
                            .padding(.leading)
                            .padding(.trailing)
                            .padding(.bottom , 5)
                    })
                    NavigationLink(isActive: $login, destination: {Login()}, label: {
                        Text("Login")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth : .infinity , maxHeight: 50)
                            .background(.white)
                            .cornerRadius(20)
                            .padding()
                    })
                }
                
            }
            
            .navigationBarHidden(true)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
