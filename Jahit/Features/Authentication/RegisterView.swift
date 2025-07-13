//
//  RegisterView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 29/06/25.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showLoginView = false
    @State private var isPasswordVisible = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Logo and Title
                    logoSection
                    
                    // Registration Form
                    registrationForm
                    
                    // Register Button
                    registerButton
                    
                    // Divider
                    dividerSection
                    
                    // Social Login Options
                    socialLoginSection
                    
                    // Login Link
                    loginLinkSection
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
            .alert("Berhasil!", isPresented: $viewModel.showRegistrationSuccess) {
                Button("OK") {
                    viewModel.showRegistrationSuccess = false
                }
            } message: {
                Text(viewModel.registrationSuccessMessage)
            }
            .navigationDestination(isPresented: $showLoginView) {
                LoginView()
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
    
    private var registrationForm: some View {
        VStack(spacing: 20) {
            // Email Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                    .foregroundColor(.black)
                
                TextField("Masukkan email Anda", text: $viewModel.email)
                    .font(.custom("PlusJakartaSans-Regular", size: 16))
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            
            // Phone Number Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Nomor Handphone")
                    .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.medium))
                    .foregroundColor(.black)
                
                TextField("Contoh: 081234567890", text: $viewModel.phoneNumber)
                    .font(.custom("PlusJakartaSans-Regular", size: 16))
                    .keyboardType(.phonePad)
                    .textContentType(.telephoneNumber)
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
                    .textContentType(.newPassword)
                    
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
    
    private var registerButton: some View {
        Button(action: {
            viewModel.register()
        }) {
            HStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Text("Register")
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
            
            Text("atau register dengan")
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
    
    private var loginLinkSection: some View {
        HStack(spacing: 4) {
            Text("Sudah punya akun?")
                .font(.custom("PlusJakartaSans-Regular", size: 14))
                .foregroundColor(.gray)
            
            Button(action: {
                showLoginView = true
            }) {
                Text("Login di sini")
                    .font(.custom("PlusJakartaSans-Regular", size: 14).weight(.semibold))
                    .foregroundColor(.blue)
                    .underline()
            }
        }
        .padding(.bottom, 40)
    }
}

#Preview {
    RegisterView()
}
