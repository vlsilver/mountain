import Flutter
import WalletCore

public class SwiftTrustWalletCorePlugin: NSObject, FlutterPlugin {
  var wallet: HDWallet?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "trust_wallet_core_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftTrustWalletCorePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any]
    switch call.method {
    case "createMultiCoinWallet":
      let strength = args?["strength"] as! Int32
      let passphrase = args?["passphrase"] as! String
      createMultiCoinWallet(strength: strength, passphrase: passphrase, flutterResult: result)
    case "importMultiCoinWallet":
      let passphrase = args?["passphrase"] as! String
      let mnemonic = args?["mnemonic"] as! String
      importMultiCoinWallet(mnemonic: mnemonic, passphrase: passphrase, flutterResult: result)
    case "getAddressFromIndex":
      let coinType = args?["coinType"] as! Int32
      let derivationPath = args?["derivationPath"] as! String
      getAddressCrypto(coinType: coinType, derivationPath: derivationPath, flutterResult: result)
    case "getAddressFromPrivakey":
      let privatekey = args?["privatekey"] as! String
      let coinType = args?["coinType"] as! Int32
      getAddressFromPrivateKey(privatekey: privatekey, coinType: coinType, flutterResult: result)
    case "getAddressFromSeedphrase":
      let seedphrase = args?["seedphrase"] as! String
      getAddressFromSeedphrase(seedphrase: seedphrase, flutterResult: result)
    case "checkValidAddressOfCoinType":
      let address = args?["address"] as! String
      let coinType = args?["coinType"] as! Int32
      checkValidAddressOfCoinType(address: address, coinType: coinType, flutterResult: result)
    case "getPrivateKey":
      let derivationPath = args?["derivationPath"] as! String
      let coinType = args?["coinType"] as! Int32
      getPrivateKey(coinType: coinType, derivationPath: derivationPath, flutterResult: result)
    case "createTransactionEthereum":
      let toAddress = args?["toAddress"] as! String
      let nonce = args?["nonce"] as! String
      let chainId = args?["chainId"] as! String
      let gasPrice = args?["gasPrice"] as! String
      let gasLimit = args?["gasLimit"] as! String
      let amount = args?["amount"] as! String
      let derivationPath = args?["derivationPath"] as! String
      let secretKey = args?["secretKey"] as! String
      createTransactionEthereum(nonce: nonce, chainId: chainId, gasPrice: gasPrice, gasLimit: gasLimit, toAddress: toAddress, amount: amount, derivationPath: derivationPath, secretKey: secretKey, flutterResult: result)
    case "createTransactionBitcoin":
      let toAddress = args?["toAddress"] as! String
      let fromAddress = args?["fromAddress"] as! String
      let hashs = args?["hashs"] as! [String]
      var indexUtxos: [UInt32] = []
      let indexUtxosInt32 = args?["indexUtxos"] as! [Int32]
      for indexUtxoInt32 in indexUtxosInt32 {
        indexUtxos.append(UInt32(indexUtxoInt32))
      }
      let amount = Int64(args?["amount"] as! String,radix: 10)!
      let amountUtxos = args?["amountUtxos"] as! [Int64]
      let derivationPath = args?["derivationPath"] as! String
      let byteFee = args?["byteFee"] as! Int64
      let secretKey = args?["secretKey"] as! String
      createTransactionBitcoin(toAddress: toAddress, fromAddress: fromAddress, hashs: hashs, indexUtxos: indexUtxos, amount: amount, amountUtxos: amountUtxos, byteFee: byteFee, derivationPath: derivationPath, secretKey: secretKey, flutterResult: result)
    case "createTransactionBinanceSmart":
      let toAddress = args?["toAddress"] as! String
      let nonce = args?["nonce"] as! String
      let chainId = args?["chainId"] as! String
      let gasPrice = args?["gasPrice"] as! String
      let gasLimit = args?["gasLimit"] as! String
      let amount = args?["amount"] as! String
      let derivationPath = args?["derivationPath"] as! String
      let secretKey = args?["secretKey"] as! String
      createTransactionBinanceSmart(nonce: nonce, chainId: chainId, gasPrice: gasPrice, gasLimit: gasLimit, toAddress: toAddress, amount: amount, derivationPath: derivationPath, secretKey: secretKey, flutterResult: result)
        
    case "createTransactionPolygon":
      let toAddress = args?["toAddress"] as! String
      let nonce = args?["nonce"] as! String
      let chainId = args?["chainId"] as! String
      let gasPrice = args?["gasPrice"] as! String
      let gasLimit = args?["gasLimit"] as! String
      let amount = args?["amount"] as! String
      let derivationPath = args?["derivationPath"] as! String
      let secretKey = args?["secretKey"] as! String
      createTransactionPolygon(nonce: nonce, chainId: chainId, gasPrice: gasPrice, gasLimit: gasLimit, toAddress: toAddress, amount: amount, derivationPath: derivationPath, secretKey: secretKey, flutterResult: result)

    case "createTransactionStellar":
      let fromAddress = args?["fromAddress"] as! String
      let toAddress = args?["toAddress"] as! String
        let sequence = Int64(args?["sequence"] as! String,radix: 10)! + 1
      let fee = args?["fee"] as! Int32
      let amount = Int64(args?["amount"] as! String,radix: 10)!
      let derivationPath = args?["derivationPath"] as! String
      let secretKey = args?["secretKey"] as! String
      createTransactionStellar(fee: fee, sequence: sequence, fromAddress: fromAddress, toAddress: toAddress, amount: amount, derivationPath: derivationPath, secretKey: secretKey, flutterResult: result)
        
    case "createTransactionPiTestnet":
      let fromAddress = args?["fromAddress"] as! String
      let toAddress = args?["toAddress"] as! String
      let sequence = Int64(args?["sequence"] as! String,radix: 10)! + 1
      let fee = args?["fee"] as! Int32
      let amount = Int64(args?["amount"] as! String,radix: 10)!
      let derivationPath = args?["derivationPath"] as! String
      let secretKey = args?["secretKey"] as! String
      createTransactionPiTestnet(fee: fee, sequence: sequence, fromAddress: fromAddress, toAddress: toAddress, amount: amount, derivationPath: derivationPath, secretKey: secretKey, flutterResult: result)

    case "createTransactionTron":
      let fromAddress = args?["fromAddress"] as! String
      let toAddress = args?["toAddress"] as! String
      let fee = args?["fee"] as! Int64
      let amount = Int64(args?["amount"] as! String, radix: 10)!
      let derivationPath = args?["derivationPath"] as! String
      let secretKey = args?["secretKey"] as! String
      let txTrieRoot = args?["txTrieRoot"] as! String
      let parentHash = args?["parentHash"] as! String
      let witnessAddress = args?["witnessAddress"] as! String
      let timestamp = args?["timestamp"] as! Int64
      let number = args?["number"] as! Int64
      let version = args?["version"] as! Int32
      createTransactionTron(fee: fee, fromAddress: fromAddress, toAddress: toAddress, amount: amount, derivationPath: derivationPath, timestamp: timestamp, number: number, version: version, parentHash: parentHash, txTrieRoot: txTrieRoot, witnessAddress: witnessAddress, secretKey: secretKey, flutterResult: result)

    case "createTransactionTronTRC20":
      let contractAddress = args?["contractAddress"] as! String
      let fromAddress = args?["fromAddress"] as! String
      let toAddress = args?["toAddress"] as! String
      let fee = args?["fee"] as! Int64
      let amount = args?["amount"] as! String
      let derivationPath = args?["derivationPath"] as! String
      let secretKey = args?["secretKey"] as! String
      let txTrieRoot = args?["txTrieRoot"] as! String
      let parentHash = args?["parentHash"] as! String
      let witnessAddress = args?["witnessAddress"] as! String
      let timestamp = args?["timestamp"] as! Int64
      let number = args?["number"] as! Int64
      let version = args?["version"] as! Int32
      createTransactionTronTRC20(fee: fee, contractAddress: contractAddress, fromAddress: fromAddress, toAddress: toAddress, amount: amount, derivationPath: derivationPath, timestamp: timestamp, number: number, version: version, parentHash: parentHash, txTrieRoot: txTrieRoot,
                                 witnessAddress: witnessAddress, secretKey: secretKey, flutterResult: result)
        
    case "decodeApprove":
      let data = args?["data"] as! String
        decodeApprove(data: data, flutterResult: result)
        
    case "base58Decode":
      let addressString = args?["addressString"] as! String
      base58Decode(addressString: addressString, flutterResult: result)
        
    case "base58Encode":
      let addressHexString = args?["addressHexString"] as! String
      base58Encode(addressHexString: addressHexString, flutterResult: result)
        
    default:
      result("default")
    }
  }

  private func createMultiCoinWallet(strength: Int32, passphrase: String, flutterResult: @escaping FlutterResult) {
    wallet = HDWallet(strength: strength, passphrase: passphrase)
    flutterResult(wallet!.mnemonic)
  }

  private func importMultiCoinWallet(mnemonic: String, passphrase: String, flutterResult: @escaping FlutterResult) {
    let isValid = HDWallet.isValid(mnemonic: mnemonic)
    if isValid {
      wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
    }
    flutterResult(isValid)
  }

  private func getAddressCrypto(coinType: Int32, derivationPath: String, flutterResult: @escaping FlutterResult) {
    let coinType = CoinType(rawValue: UInt32(coinType))
    let key = wallet?.getKey(coin: coinType!, derivationPath: derivationPath)
    let address = coinType!.deriveAddress(privateKey: key!)
    flutterResult(address)
  }

  private func getAddressFromPrivateKey(privatekey: String, coinType: Int32, flutterResult: @escaping FlutterResult) {
    let data = Data(hexString: privatekey)
    if data != nil {
        let coinType = CoinType(rawValue: UInt32(coinType))
      var address = ""
      let isValid = PrivateKey.isValid(data: data!, curve: coinType!.curve)
      if isValid {
        let key = PrivateKey(data: data!)
        address = coinType!.deriveAddress(privateKey: key!)
      }
      flutterResult(address)
    } else {
      flutterResult("")
    }
  }
    
    private func getAddressFromSeedphrase(seedphrase: String, flutterResult: @escaping FlutterResult) {
        let isValid = HDWallet.isValid(mnemonic: seedphrase)
        var address = "";
        var privateKey = "";
        if isValid {
            let walletForAddress = HDWallet(mnemonic: seedphrase, passphrase: "")
            let key = walletForAddress.getKey(coin: CoinType.stellar, derivationPath: "m/44'/314159'/0'")
            address = CoinType.stellar.deriveAddress(privateKey: key)
            privateKey = key.data.hexString
            
        }
        flutterResult([address,privateKey])
    }


  private func checkValidAddressOfCoinType(address: String, coinType: Int32, flutterResult: @escaping FlutterResult) {
    var isValid = false
    let coinType = CoinType(rawValue: UInt32(coinType))
    isValid = coinType!.validate(address: address)
    flutterResult(isValid)
  }

  private func createTransactionEthereum(nonce: String, chainId: String, gasPrice: String, gasLimit: String, toAddress: String, amount: String, derivationPath: String, secretKey: String, flutterResult: @escaping FlutterResult) {
    let privateKey: PrivateKey
    if secretKey.isEmpty {
      privateKey = wallet!.getKey(coin: CoinType.ethereum, derivationPath: derivationPath)
    } else {
      privateKey = PrivateKey(data: Data(hexString: secretKey)!)!
    }

    let signerInput = EthereumSigningInput.with {
      $0.nonce = Data(hexString: nonce)!
      $0.chainID = Data(hexString: chainId)!
      $0.gasPrice = Data(hexString: gasPrice)!
      $0.gasLimit = Data(hexString: gasLimit)!
      $0.toAddress = toAddress
      $0.transaction = EthereumTransaction.with {
        $0.transfer = EthereumTransaction.Transfer.with {
          $0.amount = Data(hexString: amount)!
        }
      }
      $0.privateKey = privateKey.data
    }
    let outputEth: EthereumSigningOutput = AnySigner.sign(input: signerInput, coin: CoinType.ethereum)
    flutterResult(outputEth.encoded.hexString)
  }

  private func createTransactionBitcoin(toAddress: String, fromAddress: String, hashs: [String], indexUtxos: [UInt32], amount: Int64, amountUtxos: [Int64], byteFee: Int64, derivationPath: String, secretKey: String, flutterResult: @escaping FlutterResult) {
    let privateKey: PrivateKey
    if secretKey.isEmpty {
      privateKey = wallet!.getKey(coin: CoinType.bitcoin, derivationPath: derivationPath)
    } else {
      privateKey = PrivateKey(data: Data(hexString: secretKey)!)!
    }
    var utxos: [BitcoinUnspentTransaction] = []
    for index in 0 ... (hashs.count - 1) {
      let outPoint = BitcoinOutPoint.with {
        $0.hash = Data.reverse(hexString: hashs[index])
        $0.index = indexUtxos[index]
      }
      let utxo = BitcoinUnspentTransaction.with {
        $0.amount = amountUtxos[index]
        $0.outPoint = outPoint
        $0.script = BitcoinScript.lockScriptForAddress(address: fromAddress, coin: CoinType.bitcoin).data
      }
      utxos.append(utxo)
    }
    var input = BitcoinSigningInput.with {
      $0.amount = amount
      $0.hashType = BitcoinScript.hashTypeForCoin(coinType: .bitcoin)
      $0.toAddress = toAddress
      $0.changeAddress = fromAddress
      $0.byteFee = byteFee
      $0.coinType = CoinType.bitcoin.rawValue
      $0.privateKey = [privateKey.data]
      $0.utxo = utxos
    }
    // Calculate fee (plan a tranaction)
    let plan: BitcoinTransactionPlan = AnySigner.plan(input: input, coin: CoinType.bitcoin)
    print("Fee:  ", plan.fee, "Amount:", plan.amount, "Available Amount:", plan.availableAmount, "Change:", plan.utxos)
    // Set the precomputed plan
    input.plan = plan
    input.amount = plan.amount
    let output: BitcoinSigningOutput = AnySigner.sign(input: input, coin: CoinType.bitcoin)
    flutterResult(output.encoded.hexString)
  }

  private func createTransactionBinanceSmart(nonce: String, chainId: String, gasPrice: String, gasLimit: String, toAddress: String, amount: String, derivationPath: String, secretKey: String, flutterResult: @escaping FlutterResult) {
    let privateKey: PrivateKey
    if secretKey.isEmpty {
      privateKey = wallet!.getKey(coin: CoinType.smartChain, derivationPath: derivationPath)
    } else {
      privateKey = PrivateKey(data: Data(hexString: secretKey)!)!
    }
    let signerInput = EthereumSigningInput.with {
      $0.nonce = Data(hexString: nonce)!
      $0.chainID = Data(hexString: chainId)!
      $0.gasPrice = Data(hexString: gasPrice)!
      $0.gasLimit = Data(hexString: gasLimit)!
      $0.toAddress = toAddress
      $0.transaction = EthereumTransaction.with {
        $0.transfer = EthereumTransaction.Transfer.with {
          $0.amount = Data(hexString: amount)!
        }
      }
      $0.privateKey = privateKey.data
    }
    let outputEth: EthereumSigningOutput = AnySigner.sign(input: signerInput, coin: CoinType.smartChain)
    flutterResult(outputEth.encoded.hexString)
  }
    
    private func createTransactionPolygon(nonce: String, chainId: String, gasPrice: String, gasLimit: String, toAddress: String, amount: String, derivationPath: String, secretKey: String, flutterResult: @escaping FlutterResult) {
      let privateKey: PrivateKey
      if secretKey.isEmpty {
        privateKey = wallet!.getKey(coin: CoinType.polygon, derivationPath: derivationPath)
      } else {
        privateKey = PrivateKey(data: Data(hexString: secretKey)!)!
      }
      let signerInput = EthereumSigningInput.with {
        $0.nonce = Data(hexString: nonce)!
        $0.chainID = Data(hexString: chainId)!
        $0.gasPrice = Data(hexString: gasPrice)!
        $0.gasLimit = Data(hexString: gasLimit)!
        $0.toAddress = toAddress
        $0.transaction = EthereumTransaction.with {
          $0.transfer = EthereumTransaction.Transfer.with {
            $0.amount = Data(hexString: amount)!
          }
        }
        $0.privateKey = privateKey.data
      }
      let outputEth: EthereumSigningOutput = AnySigner.sign(input: signerInput, coin: CoinType.polygon)
      flutterResult(outputEth.encoded.hexString)
    }
        
  private func createTransactionStellar(fee: Int32, sequence: Int64, fromAddress: String, toAddress: String, amount: Int64, derivationPath: String, secretKey: String, flutterResult: @escaping FlutterResult) {
    let privateKey: PrivateKey
    if secretKey.isEmpty {
      privateKey = wallet!.getKey(coin: CoinType.stellar, derivationPath: derivationPath)
    } else {
      privateKey = PrivateKey(data: Data(hexString: secretKey)!)!
    }

    let signerInput = StellarSigningInput.with {
        $0.opPayment = StellarOperationPayment.with {
           $0.destination = toAddress
           $0.amount = amount
           }
      $0.fee = fee
      $0.account = fromAddress
      $0.sequence = sequence
      $0.passphrase = StellarPassphrase(rawValue: 0)!.description
      $0.privateKey = privateKey.data
    }
    let outputStellar: StellarSigningOutput = AnySigner.sign(input: signerInput, coin: CoinType.stellar)
    flutterResult(outputStellar.signature)
  }

  private func createTransactionPiTestnet(fee: Int32, sequence: Int64, fromAddress: String, toAddress: String, amount: Int64, derivationPath: String, secretKey: String, flutterResult: @escaping FlutterResult) {
    let privateKey: PrivateKey
    if secretKey.isEmpty {
      privateKey = wallet!.getKey(coin: CoinType.stellar, derivationPath: derivationPath)
    } else {
      privateKey = PrivateKey(data: Data(hexString: secretKey)!)!
    }

    let signerInput = StellarSigningInput.with {
     $0.opPayment = StellarOperationPayment.with {
        $0.destination = toAddress
        $0.amount = amount
        }
      $0.fee = fee
      $0.account = fromAddress
      $0.sequence = sequence
      $0.passphrase = "Pi Testnet"
      $0.privateKey = privateKey.data
    }
    let outputStellar: StellarSigningOutput = AnySigner.sign(input: signerInput, coin: CoinType.stellar)
    flutterResult(outputStellar.signature)
  }

  private func createTransactionTron(fee: Int64, fromAddress: String, toAddress: String, amount: Int64, derivationPath: String, timestamp : Int64, number: Int64, version: Int32, parentHash: String, txTrieRoot: String, witnessAddress: String, secretKey: String, flutterResult: @escaping FlutterResult) {
    let privateKey: PrivateKey
    if secretKey.isEmpty {
      privateKey = wallet!.getKey(coin: CoinType.tron, derivationPath: derivationPath)
    } else {
      privateKey = PrivateKey(data: Data(hexString: secretKey)!)!
    }
    
    let signerInput = TronSigningInput.with {
      $0.transaction = TronTransaction.with {
        $0.blockHeader = TronBlockHeader.with {
          $0.timestamp = timestamp
          $0.number = number
          $0.version = version
          $0.parentHash = Data(hexString: parentHash)!
          $0.txTrieRoot = Data(hexString: txTrieRoot)!
          $0.witnessAddress = Data(hexString: witnessAddress)!
        }
        $0.contractOneof = .transfer(TronTransferContract.with {
          $0.amount = amount
          $0.ownerAddress = fromAddress
          $0.toAddress = toAddress
        })
        $0.timestamp = timestamp
        $0.expiration = timestamp + 10 * 60 * 60 * 1000
        $0.feeLimit = fee
      }
      $0.privateKey = privateKey.data
    }
    let outputTron: TronSigningOutput = AnySigner.sign(input: signerInput, coin: CoinType.tron)
    flutterResult(outputTron.json)
  }

  private func createTransactionTronTRC20(fee: Int64, contractAddress: String, fromAddress: String, toAddress: String, amount: String, derivationPath: String, timestamp : Int64, number: Int64, version: Int32, parentHash: String, txTrieRoot: String, witnessAddress: String, secretKey: String, flutterResult: @escaping FlutterResult) {
    let privateKey: PrivateKey
    if secretKey.isEmpty {
      privateKey = wallet!.getKey(coin: CoinType.tron, derivationPath: derivationPath)
    } else {
      privateKey = PrivateKey(data: Data(hexString: secretKey)!)!
    }
    let signerInput = TronSigningInput.with {
      $0.transaction = TronTransaction.with {
        $0.blockHeader = TronBlockHeader.with {
          $0.timestamp = timestamp
          $0.number = number
          $0.version = version
          $0.parentHash = Data(hexString: parentHash)!
          $0.txTrieRoot = Data(hexString: txTrieRoot)!
          $0.witnessAddress = Data(hexString: witnessAddress)!
        }
        $0.contractOneof = .transferTrc20Contract(TronTransferTRC20Contract.with {
          $0.amount = Data(hexString: amount)!
          $0.contractAddress = contractAddress
          $0.ownerAddress = fromAddress
          $0.toAddress = toAddress
        })
        $0.feeLimit = fee
        $0.timestamp = timestamp
        $0.expiration = timestamp + 10 * 60 * 60 * 1000
      }
      $0.privateKey = privateKey.data
    }
    let outputTron: TronSigningOutput = AnySigner.sign(input: signerInput, coin: CoinType.tron)
    flutterResult(outputTron.json)
  }

  private func base58Encode(addressHexString: String, flutterResult: @escaping FlutterResult) {
    let data: String = Base58.encode(data: Data(hexString: addressHexString)!)
    flutterResult(data)
  }

  private func base58Decode(addressString: String, flutterResult: @escaping FlutterResult) {
    let data = Base58.decode(string: addressString)
    flutterResult(data!.hexString)
  }

  private func getPrivateKey(coinType: Int32, derivationPath: String, flutterResult: @escaping FlutterResult) {
    let coinType = CoinType(rawValue: UInt32(coinType))
    let privateKey = wallet!.getKey(coin: coinType!, derivationPath: derivationPath)
    flutterResult(privateKey.data.hexString)
  }
    
    private func decodeApprove(data: String, flutterResult: @escaping FlutterResult) {
        do {
        let dataAbi =  Data(hexString: data)!
            print(dataAbi)
            let url = Bundle(for: SwiftTrustWalletCorePlugin.self).url(forResource: "erc20", withExtension: "json")!
            print(url)
        let abi = try String(contentsOf: url)
        let decoded = EthereumAbi.decodeCall(data: dataAbi, abi: abi)
            flutterResult(decoded)
        }
        catch {
            
        }
    }
    
}
