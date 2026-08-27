output = System.argv() |> List.first() || Mix.raise("output path is required")
key = :public_key.generate_key({:rsa, 2048, 65_537})
entry = :public_key.pem_entry_encode(:RSAPrivateKey, key)
File.write!(output, :public_key.pem_encode([entry]))
