# [ VOID ]

**[ VOID ]** is an iOS app for offline text encryption and encoding, designed to ensure maximum privacy.
Built with **SwiftUI** and **MVVM** architecture, it allows users to securely encrypt and decrypt messages without storing or transmitting any sensitive data.

---

## Features

- **AES-256 encryption** for strong data protection  
- **Argon2 key generation** with customizable parameters  
- **VOID Secret** — hidden key variants generated per device  
- **Offline-only operation**: no internet connection required  
- **No accounts or registration**: fully anonymous  
- **Temporary decryption timer**: encrypted data can self-expire  
- **Multilingual support**  
- **Customizable encryption layers** (up to 7)  
- **Emoji encoding**: convert text into emoji sequences using Base64 

---

## How it works

1. User enters a message and a password.  
2. The app generates a secure encryption key using **Argon2**.  
3. The message is encrypted using **AES-256**.  
4. User can send the encrypted message via any messenger or platform.  
5. Decryption can only occur within VOID using the correct password and optional VOID Secret.

---

## Installation

**For users:**  
Download VOID directly from the [App Store](https://apps.apple.com/) to use the app.

**For developers:**  
To explore or contribute to the source code:  
1. Clone this repository:  
```bash
git clone https://github.com/GE-Developer/Void.git ~/Desktop/Void
