//
//  LoginView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 29/06/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showRegisterView = false
    @State private var isPasswordVisible = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Logo and Title
                    logoSection
                    
                    // Login Form
                    loginForm
                    
                    // Login Button
                    loginButton

                    // Divider
                    dividerSection
                    
                    // Social Login Options
                    socialLoginSection
                    
                    // Register Link
                    registerLinkSection
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            }
            .background(Color.white)
            .navigationBarHidden(true)
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") {
                    viewModel.showError = false
                }
            } message: {
                Text(viewModel.errorMessage)
            }
            .navigationDestination(isPresented: $showRegisterView) {
                RegisterView()
            }
            .onChange(of: viewModel.isAuthenticated) { _, isAuthenticated in
                if isAuthenticated {
                    dismiss()
                }
            }
        }
    }
    
    private var logoSection: some View {
        VStack(spacing: 16) {
            HStack{
                Image("JahitLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                
                Text("Jahit")
                    .font(.custom("PlusJakartaSans-Regular", size: 32).weight(.bold))
                    .foregroundColor(.blue)
            }
            Text("Selamat datang di Jahit!")
                .font(.custom("PlusJakartaSans-Regular", size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 40)
    }
    
    private var loginForm: some View {
        VStack(spacing: 20) {
            // Email/Phone Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Email/No Handphone")
                    .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                    .foregroundColor(.black)
                
                TextField("Masukkan email atau nomor handphone", text: $viewModel.emailOrPhone)
                    .font(.custom("PlusJakartaSans-Regular", size: 16))
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textContentType(.username)
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            
            // Password Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Kata Sandi")
                    .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                    .foregroundColor(.black)
                
                HStack {
                    Group {
                        if isPasswordVisible {
                            TextField("Masukkan kata sandi", text: $viewModel.password)
                        } else {
                            SecureField("Masukkan kata sandi", text: $viewModel.password)
                        }
                    }
                    .font(.custom("PlusJakartaSans-Regular", size: 16))
                    .textContentType(.password)
                    
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                    }
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
    
    private var loginButton: some View {
        Button(action: {
            viewModel.login()
        }) {
            HStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Text("Login")
                        .font(.custom("PlusJakartaSans-Regular", size: 16).weight(.semibold))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(viewModel.isLoading ? Color.blue.opacity(0.7) : Color.blue)
            .cornerRadius(12)
        }
        .disabled(viewModel.isLoading)
    }

        private var dividerSection: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.3))
            
            Text("atau login dengan")
                .font(.custom("PlusJakartaSans-Regular", size: 14))
                .foregroundColor(.gray)
                .padding(.horizontal, 8)
                .fixedSize()
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.3))
        }
    }
    
    private var socialLoginSection: some View {
        HStack(spacing: 20) {
            // Google Button
            Button(action: {
                viewModel.loginWithGoogle()
            }) {
                Image("google")
                    .frame(width: 56, height: 56)
                    .background(Color.white)
                    .cornerRadius(28)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            .disabled(viewModel.isLoading)
            
            // Apple Button
            Button(action: {
                viewModel.loginWithApple()
            }) {
                Image(systemName: "applelogo")
                    .foregroundColor(.black)
                    .font(.system(size: 32))
                    .frame(width: 56, height: 56)
                    .background(Color.white)
                    .cornerRadius(28)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            .disabled(viewModel.isLoading)
        }
    }
    
    private var registerLinkSection: some View {
        HStack(spacing: 4) {
            Text("Belum punya akun?")
                .font(.custom("PlusJakartaSans-Regular", size: 14))
                .foregroundColor(.gray)
            
            Button(action: {
                showRegisterView = true
            }) {
                Text("Register di sini")
                    .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.semibold))
                    .foregroundColor(.blue)
                    .underline()
            }
        }
        .padding(.bottom, 40)
    }
}

#Preview {
    LoginView()
}
