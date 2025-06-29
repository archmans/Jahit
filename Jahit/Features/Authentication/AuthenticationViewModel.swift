//
//  AuthenticationViewModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 29/06/25.
//

import SwiftUI
import Combine

class AuthenticationViewModel: ObservableObject {
    @Published var email = ""
    @Published var phoneNumber = ""
    @Published var password = ""
    @Published var emailOrPhone = ""
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var showError = false
    @Published var isAuthenticated = false
    
    private let userManager = UserManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Check if user is already logged in
        isAuthenticated = userManager.currentUser.isLoggedIn
    }
    
    func register() {
        guard validateRegistrationInput() else { return }
        
        isLoading = true
        errorMessage = ""
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Check if email or phone already exists (mock check)
            if self.email.lowercased() == "test@example.com" {
                self.showErrorMessage("Email sudah terdaftar")
                return
            }
            
            if self.phoneNumber == "081234567890" {
                self.showErrorMessage("Nomor handphone sudah terdaftar")
                return
            }
            
            // Success - create user account
            self.userManager.registerUser(
                email: self.email,
                phoneNumber: self.phoneNumber,
                password: self.password
            )
            
            self.isAuthenticated = true
            self.isLoading = false
            self.clearFields()
        }
    }
    
    func login() {
        guard validateLoginInput() else { return }
        
        isLoading = true
        errorMessage = ""
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Mock authentication
            let isValid = self.mockAuthentication()
            
            if isValid {
                self.userManager.loginUser(identifier: self.emailOrPhone, password: self.password)
                self.isAuthenticated = true
                self.clearFields()
            } else {
                self.showErrorMessage("Email/nomor handphone atau kata sandi salah")
            }
            
            self.isLoading = false
        }
    }
    
    func loginWithGoogle() {
        isLoading = true
        
        // Simulate Google login
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.userManager.loginWithSocialProvider(
                provider: .google,
                email: "user@gmail.com",
                name: "Google User"
            )
            self.isAuthenticated = true
            self.isLoading = false
        }
    }
    
    func loginWithApple() {
        isLoading = true
        
        // Simulate Apple login
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.userManager.loginWithSocialProvider(
                provider: .apple,
                email: "user@icloud.com",
                name: "Apple User"
            )
            self.isAuthenticated = true
            self.isLoading = false
        }
    }
    
    func logout() {
        userManager.logout()
        isAuthenticated = false
    }
    
    private func validateRegistrationInput() -> Bool {
        if email.isEmpty || !isValidEmail(email) {
            showErrorMessage("Format email tidak valid")
            return false
        }
        
        if phoneNumber.isEmpty || !isValidPhoneNumber(phoneNumber) {
            showErrorMessage("Format nomor handphone tidak valid")
            return false
        }
        
        if password.count < 6 {
            showErrorMessage("Kata sandi minimal 6 karakter")
            return false
        }
        
        return true
    }
    
    private func validateLoginInput() -> Bool {
        if emailOrPhone.isEmpty {
            showErrorMessage("Email atau nomor handphone harus diisi")
            return false
        }
        
        if password.isEmpty {
            showErrorMessage("Kata sandi harus diisi")
            return false
        }
        
        return true
    }
    
    private func mockAuthentication() -> Bool {
        // Mock successful login for demo purposes
        return emailOrPhone.lowercased() == "user@jahit.com" && password == "123456" ||
               emailOrPhone == "081234567890" && password == "123456" ||
               emailOrPhone.lowercased() == "test@example.com" && password == "password"
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPhoneNumber(_ phone: String) -> Bool {
        let phoneRegex = "^[0-9]{10,15}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
        isLoading = false
    }
    
    private func clearFields() {
        email = ""
        phoneNumber = ""
        password = ""
        emailOrPhone = ""
        errorMessage = ""
        showError = false
    }
}
