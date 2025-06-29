//
//  AuthenticationModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 29/06/25.
//

import Foundation

struct RegisterRequest {
    let email: String
    let phoneNumber: String
    let password: String
}

struct LoginRequest {
    let emailOrPhone: String
    let password: String
}

enum AuthenticationError: LocalizedError {
    case invalidEmail
    case invalidPhoneNumber
    case weakPassword
    case emailAlreadyExists
    case phoneAlreadyExists
    case invalidCredentials
    case userNotFound
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Format email tidak valid"
        case .invalidPhoneNumber:
            return "Format nomor handphone tidak valid"
        case .weakPassword:
            return "Kata sandi minimal 6 karakter"
        case .emailAlreadyExists:
            return "Email sudah terdaftar"
        case .phoneAlreadyExists:
            return "Nomor handphone sudah terdaftar"
        case .invalidCredentials:
            return "Email/nomor handphone atau kata sandi salah"
        case .userNotFound:
            return "Pengguna tidak ditemukan"
        case .networkError:
            return "Terjadi kesalahan jaringan"
        }
    }
}

enum AuthenticationProvider {
    case email
    case google
    case apple
}
