(define-non-fungible-token academic-certificate uint)

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-not-authorized (err u102))
(define-constant err-already-exists (err u103))
(define-constant err-invalid-institution (err u104))

(define-data-var next-certificate-id uint u1)

(define-map institutions principal bool)
(define-map certificate-metadata uint {
    student-name: (string-ascii 100),
    institution: principal,
    degree-type: (string-ascii 50),
    major: (string-ascii 80),
    graduation-year: uint,
    gpa: uint,
    issued-at: uint
})
(define-map institution-names principal (string-ascii 100))
(define-map revoked-certificates uint bool)

(define-public (register-institution (institution principal) (name (string-ascii 100)))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (map-set institutions institution true)
        (map-set institution-names institution name)
        (ok true)
    )
)

(define-public (revoke-institution (institution principal))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (map-delete institutions institution)
        (map-delete institution-names institution)
        (ok true)
    )
)

(define-public (issue-certificate 
    (recipient principal)
    (student-name (string-ascii 100))
    (degree-type (string-ascii 50))
    (major (string-ascii 80))
    (graduation-year uint)
    (gpa uint))
    (let ((certificate-id (var-get next-certificate-id))
          (current-block stacks-block-height))
        (asserts! (default-to false (map-get? institutions tx-sender)) err-not-authorized)
        (try! (nft-mint? academic-certificate certificate-id recipient))
        (map-set certificate-metadata certificate-id {
            student-name: student-name,
            institution: tx-sender,
            degree-type: degree-type,
            major: major,
            graduation-year: graduation-year,
            gpa: gpa,
            issued-at: current-block
        })
        (var-set next-certificate-id (+ certificate-id u1))
        (ok certificate-id)
    )
)

(define-public (revoke-certificate (certificate-id uint))
    (let ((metadata (unwrap! (map-get? certificate-metadata certificate-id) err-not-found)))
        (asserts! (is-eq tx-sender (get institution metadata)) err-not-authorized)
        (map-set revoked-certificates certificate-id true)
        (ok true)
    )
)

(define-public (transfer-certificate (certificate-id uint) (sender principal) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender sender) err-not-authorized)
        (asserts! (not (default-to false (map-get? revoked-certificates certificate-id))) err-not-authorized)
        (try! (nft-transfer? academic-certificate certificate-id sender recipient))
        (ok true)
    )
)

(define-read-only (get-certificate-metadata (certificate-id uint))
    (map-get? certificate-metadata certificate-id)
)

(define-read-only (get-certificate-owner (certificate-id uint))
    (nft-get-owner? academic-certificate certificate-id)
)

(define-read-only (is-certificate-revoked (certificate-id uint))
    (default-to false (map-get? revoked-certificates certificate-id))
)

(define-read-only (is-authorized-institution (institution principal))
    (default-to false (map-get? institutions institution))
)

(define-read-only (get-institution-name (institution principal))
    (map-get? institution-names institution)
)

(define-read-only (verify-certificate (certificate-id uint))
    (let ((metadata (unwrap! (map-get? certificate-metadata certificate-id) err-not-found))
          (owner (unwrap! (nft-get-owner? academic-certificate certificate-id) err-not-found)))
        (ok {
            certificate-id: certificate-id,
            student-name: (get student-name metadata),
            institution: (get institution metadata),
            institution-name: (default-to "Unknown Institution" (map-get? institution-names (get institution metadata))),
            degree-type: (get degree-type metadata),
            major: (get major metadata),
            graduation-year: (get graduation-year metadata),
            gpa: (get gpa metadata),
            issued-at: (get issued-at metadata),
            current-owner: owner,
            is-revoked: (default-to false (map-get? revoked-certificates certificate-id)),
            is-institution-authorized: (default-to false (map-get? institutions (get institution metadata)))
        })
    )
)

(define-read-only (get-certificates-by-owner (owner principal))
    (ok (map get-certificate-metadata 
        (filter is-owner-certificate 
            (list u1 u2 u3 u4 u5 u6 u7 u8 u9 u10))))
)

(define-private (is-owner-certificate (certificate-id uint))
    (match (nft-get-owner? academic-certificate certificate-id)
        owner true
        false
    )
)

(define-read-only (get-total-certificates)
    (- (var-get next-certificate-id) u1)
)

(define-read-only (get-contract-info)
    (ok {
        contract-owner: contract-owner,
        total-certificates: (- (var-get next-certificate-id) u1),
        current-block:stacks-block-height
    })
)
