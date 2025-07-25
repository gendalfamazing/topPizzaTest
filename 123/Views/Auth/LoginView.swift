//
//  LoginView.swift
//  123
//
//  Created by Artur Vladymcev on 25.07.25.
//


import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @AppStorage("isAuthorized") private var isAuthorized: Bool = false
    @AppStorage("justLoggedIn") private var justLoggedIn: Bool = false
    @State private var showToast = false
    @State private var toastText = ""
    @State private var toastError = false
    @State private var isPasswordVisible: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                Color.back.edgesIgnoringSafeArea(.top)
                VStack(spacing: 0) {
                    Image ("logo")
                        .resizable()
                        .frame(width: 322, height: 103)
                        .padding(.horizontal, 26)
                        .padding(.vertical, 32)
                    VStack(spacing: 8) {
                        HStack (spacing: 10){
                            Image("Union")
                                .resizable()
                                .frame(width: 18, height: 18)
                            TextField("Логин", text: $username)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        .padding(16)
                        .frame(height: 50)
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                        .overlay(RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.3)))

                        HStack {
                            Image("lock-line")
                                .resizable()
                                .frame(width: 18, height: 18)

                            if isPasswordVisible {
                                TextField("Пароль", text: $password)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                            } else {
                                SecureField("Пароль", text: $password)
                            }

                            Button(action: { isPasswordVisible.toggle() }) {
                                Image(isPasswordVisible ? "eye-open" : "eye-close")
                                    .resizable()
                                    .frame(width: 16, height: 12)
                            }
                        }
                        .padding(16)
                        .frame(height: 50)
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                        .overlay(RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.3)))
                    }
                    .padding(.horizontal)
                    Spacer()
                    ZStack {
                        Color.white
                            .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))

                        Button(action: {
                            if username == "Qwerty123" && password == "Qwerty123" {
                                isAuthorized = true
                                justLoggedIn = true
                                toastText = "Вход выполнен успешно"
                                toastError = false
                            } else {
                                toastText = "Неверный логин или пароль"
                                toastError = true
                            }
                            withAnimation { showToast = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation { showToast = false }
                            }
                        }) {
                            Text("Войти")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, maxHeight: 48)
                                .background((username.isEmpty || password.isEmpty)
                                    ? Color.custPinkBack
                                    : Color.custPink)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                        .padding(.horizontal)
                        .disabled(username.isEmpty || password.isEmpty)
                    }
                    .frame(height: 88)
                    .ignoresSafeArea(edges: .bottom)
                }
            }
            .overlay(alignment: .top) {
                if showToast {
                    ToastView(text: toastText, isError: toastError)
                        .ignoresSafeArea(edges: .top)
                        .padding(.top, 1)
                }
            }
            .navigationTitle("Авторизация")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
