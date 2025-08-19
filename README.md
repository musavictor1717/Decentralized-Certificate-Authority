# 🎓 Decentralized Certificate Authority

A blockchain-based academic certificate system built on Stacks that issues tamper-proof digital diplomas as NFTs.

## ✨ Features

- 🏛️ **Institution Management**: Register and manage authorized educational institutions
- 🎖️ **Certificate Issuance**: Issue academic certificates as unique NFTs
- 🔍 **Verification System**: Instantly verify certificate authenticity and validity
- 🚫 **Revocation Support**: Institutions can revoke certificates if needed
- 📋 **Comprehensive Metadata**: Store student info, degree type, GPA, and graduation year
- 🔄 **Transfer Capability**: Certificates can be transferred between wallets

## 🚀 Getting Started

### Prerequisites
- Clarinet CLI installed
- Stacks wallet for testing

### Installation
```bash
git clone https://github.com/your-username/Decentralized-Certificate-Authority
cd Decentralized-Certificate-Authority
clarinet check
```

## 📖 Usage

### For Contract Owner

#### Register an Institution
```clarity
(contract-call? .Decentralized-Certificate-Authority register-institution 'SP1ABC... "Harvard University")
```

#### Revoke an Institution
```clarity
(contract-call? .Decentralized-Certificate-Authority revoke-institution 'SP1ABC...)
```

### For Educational Institutions

#### Issue a Certificate
```clarity
(contract-call? .Decentralized-Certificate-Authority issue-certificate 
    'SP2STUDENT...
    "John Doe"
    "Bachelor of Science"
    "Computer Science"
    u2024
    u375)  ;; GPA as 3.75 * 100
```

#### Revoke a Certificate
```clarity
(contract-call? .Decentralized-Certificate-Authority revoke-certificate u1)
```

### For Certificate Holders

#### Transfer Certificate
```clarity
(contract-call? .Decentralized-Certificate-Authority transfer-certificate u1 tx-sender 'SP3RECIPIENT...)
```

### For Everyone

#### Verify Certificate
```clarity
(contract-call? .Decentralized-Certificate-Authority verify-certificate u1)
```

#### Get Certificate Metadata
```clarity
(contract-call? .Decentralized-Certificate-Authority get-certificate-metadata u1)
```

#### Check Certificate Owner
```clarity
(contract-call? .Decentralized-Certificate-Authority get-certificate-owner u1)
```

## 🔧 Contract Functions

### Public Functions
- `register-institution`: Register a new educational institution (owner only)
- `revoke-institution`: Remove an institution's authorization (owner only)
- `issue-certificate`: Issue a new academic certificate NFT (institutions only)
- `revoke-certificate`: Mark a certificate as revoked (issuing institution only)
- `transfer-certificate`: Transfer certificate ownership

### Read-Only Functions
- `get-certificate-metadata`: Get all certificate details
- `get-certificate-owner`: Get current certificate owner
- `is-certificate-revoked`: Check if certificate is revoked
- `is-authorized-institution`: Verify institution authorization
- `get-institution-name`: Get institution display name
- `verify-certificate`: Complete certificate verification with all details
- `get-total-certificates`: Get total number of certificates issued
- `get-contract-info`: Get contract statistics

## 📊 Data Structures

### Certificate Metadata
```clarity
{
    student-name: (string-ascii 100),
    institution: principal,
    degree-type: (string-ascii 50),
    major: (string-ascii 80),
    graduation-year: uint,
    gpa: uint,
    issued-at: uint
}
```

## 🛡️ Security Features

- ✅ Only authorized institutions can issue certificates
- ✅ Only certificate issuers can revoke their certificates  
- ✅ Revoked certificates cannot be transferred
- ✅ Owner-only functions for institution management
- ✅ Comprehensive verification system

## 🧪 Testing

Run the test suite:
```bash
clarinet test
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙋‍♂️ Support

For questions and support, please open an issue on GitHub or contact the development team.

---

*Built with ❤️ using Clarity and Stacks blockchain*

