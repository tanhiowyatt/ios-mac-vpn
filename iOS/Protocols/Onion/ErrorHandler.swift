enum TorManagerError: Error {
        case invalidURL
        case circuitCreationFailed
        case decryptionFailed
    }