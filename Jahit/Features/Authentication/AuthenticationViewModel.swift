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
    @Published var showRegistrationSuccess = false
    @Published var registrationSuccessMessage = ""
    
    private let userManager = UserManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        isAuthenticated = userManager.currentUser.isLoggedIn
        
        // Observe UserManager state changes
        userManager.$currentUser
            .map { $0.isLoggedIn }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoggedIn in
                self?.isAuthenticated = isLoggedIn
            }
            .store(in: &cancellables)
    }
    
    func register() {
        guard validateRegistrationInput() else { return }
        
        isLoading = true
        errorMessage = ""
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Check if email or phone already exists
            if self.userManager.isEmailRegistered(self.email) {
                self.showErrorMessage("Email sudah terdaftar")
                return
            }
            
            if self.userManager.isPhoneRegistered(self.phoneNumber) {
                self.showErrorMessage("Nomor handphone sudah terdaftar")
                return
            }
            
            // Success - create user account
            self.userManager.registerUser(
                email: self.email,
                phoneNumber: self.phoneNumber,
                password: self.password
            )
            
            self.showRegistrationSuccessMessage("Pendaftaran berhasil! Silakan login dengan akun Anda.")
            self.isLoading = false
        }
    }
    
    func login() {
        guard validateLoginInput() else { return }
        
        isLoading = true
        errorMessage = ""
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Try to authenticate with registered users
            let isValid = self.userManager.authenticateUser(identifier: self.emailOrPhone, password: self.password)
            
            if isValid {
                self.clearFields()
                // isAuthenticated will be automatically updated via Combine subscription
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
                name: "Google User",
                phoneNumber: "081234567890" // Add mock phone number
            )
            self.isLoading = false
            // isAuthenticated will be automatically updated via Combine subscription
        }
    }
    
    func loginWithApple() {
        isLoading = true
        
        // Simulate Apple login
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.userManager.loginWithSocialProvider(
                provider: .apple,
                email: "user@icloud.com",
                name: "Apple User",
                phoneNumber: "081987654321" // Add mock phone number
            )
            self.isLoading = false
            // isAuthenticated will be automatically updated via Combine subscription
        }
    }
    
    func logout() {
        userManager.logout()
        // isAuthenticated will be automatically updated via Combine subscription
    }
    
    private func validateRegistrationInput() -> Bool {
        if email.isEmpty || !isValidEmail(email) {
            showErrorMessage("Format email tidak valid")
            return false
        }
        
        if phoneNumber.isEmpty || !isValidPhoneNumber(phoneNumber) {
            showErrorMessage("Format nomor handphone tidak valid (contoh: 081234567890)")
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
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPhoneNumber(_ phone: String) -> Bool {
        let phoneRegex = "^(\\+62|62|0)[0-9]{9,13}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
        isLoading = false
    }
    
    private func showRegistrationSuccessMessage(_ message: String) {
        registrationSuccessMessage = message
        showRegistrationSuccess = true
    }
    
    private func clearFields() {
        email = ""
        phoneNumber = ""
        password = ""
        emailOrPhone = ""
        errorMessage = ""
        showError = false
        showRegistrationSuccess = false
        registrationSuccessMessage = ""
    }
}
