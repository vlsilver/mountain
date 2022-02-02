package com.example.trust_wallet_core_plugin

import android.location.Address
import androidx.annotation.NonNull
import com.google.protobuf.ByteString

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import wallet.core.java.AnySigner
import wallet.core.jni.*
import wallet.core.jni.proto.Bitcoin
import wallet.core.jni.proto.Ethereum
import wallet.core.jni.proto.Stellar
import wallet.core.jni.proto.Tron
import java.math.BigInteger
import kotlin.experimental.and


/** TrustWalletCorePlugin */
class TrustWalletCorePlugin: FlutterPlugin, MethodCallHandler {

  init {
    System.loadLibrary("TrustWalletCore")
  }


  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity


//  companion object {
//    @JvmStatic
//    fun registerWith(registrar: PluginRegistry.Registrar): Unit {
//      plugin.channel = MethodChannel(registrar.messenger(), "trust_wallet_core_plugin")
//      plugin.context = registrar.context()
//    }

  private lateinit var wallet: HDWallet
  private lateinit var channel: MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "trust_wallet_core_plugin")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

    var args: Map<String, Any> = call.arguments as Map<String, Any>;

    print(args)

    when (call.method) {
      "createMultiCoinWallet" -> {
        val strength = args["strength"] as Int
        val passphrase = args["passphrase"] as String
        val data = createMultiCoinWallet(strength, passphrase)
        result.success(data)
      }
      "importMultiCoinWallet" -> {
        val mnemonic = args["mnemonic"] as String
        val passphrase = args["passphrase"] as String
        val data = importMultiCoinWallet(mnemonic, passphrase)
        result.success(data)
      }
      "getAddressFromIndex" -> {
        val coinType = args["coinType"] as Int
        val derivationPath = args["derivationPath"] as String
        val data = getAddressByCoinType(coinType, derivationPath)
        result.success(data)
      }
      "getAddressFromPrivakey" -> {
        val privatekey = args["privatekey"] as String
        val coinType = args["coinType"] as Int
        val data = getAddressFromPrivateKey(privatekey, coinType)
        result.success(data)
      }
      "checkValidAddressOfCoinType" -> {
        val address = args["address"] as String
        val coinType = args["coinType"] as Int
        val data = checkValidAddressOfCoinType(address, coinType)
        result.success(data)
      }
      "getPrivateKey" -> {
        val derivationPath = args["derivationPath"] as String
        val coinType = args["coinType"] as Int
        val data = getPrivateKey(derivationPath, coinType)
        result.success(data)
      }
      "createTransactionEthereum" -> {
        val toAddress = args["toAddress"] as String
        val nonce = args["nonce"] as String
        val chainId = args["chainId"] as String
        val gasPrice = args["gasPrice"] as String
        val gasLimit = args["gasLimit"] as String
        val amount = args["amount"] as String
        val derivationPath = args["derivationPath"] as String
        val secretKey = args["secretKey"] as String
        val data = createTransactionEthereum(nonce, chainId, gasPrice, gasLimit, toAddress, amount, derivationPath, secretKey)
        result.success(data)
      }
      "createTransactionBitcoin" -> {
        val toAddress = args["toAddress"] as String
        val fromAddress = args["fromAddress"] as String
        val hashs = args["hashs"] as List<String>
        val indexUtxos = args["indexUtxos"] as List<Int>
        val amount = (args["amount"] as String).toLong()
        val amountUtxos = mutableListOf<Long>();
        val amountUtxosInInt = args["amountUtxos"] as List<Int>;
        for (item in amountUtxosInInt) {
          amountUtxos.add(item.toLong());
        }
        val derivationPath = args["derivationPath"] as String
        val secretKey = args["secretKey"] as String
        val byteFee = (args["byteFee"] as Int).toLong()
        val data = createTransactionBitcoin(toAddress,fromAddress,hashs,indexUtxos,amount,amountUtxos,byteFee,derivationPath,secretKey)
        result.success(data)
      }
      "createTransactionBinanceSmart" -> {
        val toAddress = args["toAddress"] as String
        val nonce = args["nonce"] as String
        val chainId = args["chainId"] as String
        val gasPrice = args["gasPrice"] as String
        val gasLimit = args["gasLimit"] as String
        val amount = args["amount"] as String
        val derivationPath = args["derivationPath"] as String
        val secretKey = args["secretKey"] as String
        val data = createTransactionBinanceSmart(nonce, chainId, gasPrice, gasLimit, toAddress, amount, derivationPath, secretKey)
        result.success(data)
      }

      "createTransactionPolygon" -> {
        val toAddress = args["toAddress"] as String
        val nonce = args["nonce"] as String
        val chainId = args["chainId"] as String
        val gasPrice = args["gasPrice"] as String
        val gasLimit = args["gasLimit"] as String
        val amount = args["amount"] as String
        val derivationPath = args["derivationPath"] as String
        val secretKey = args["secretKey"] as String
        val data = createTransactionPolygon(nonce, chainId, gasPrice, gasLimit, toAddress, amount, derivationPath, secretKey)
        result.success(data)
      }

       "createTransactionStellar" -> {
         val fromAddress = args["fromAddress"] as String
         val toAddress = args["toAddress"] as String
         val sequence = (args["sequence"] as String).toLong() + 1
         val fee = args["fee"] as Int
         val amount = (args["amount"] as String).toLong()
         val derivationPath = args["derivationPath"] as String
         val secretKey = args["secretKey"] as String
              val data = createTransactionStellar(fee,sequence, fromAddress,toAddress,amount,derivationPath, secretKey)
              result.success(data)
       }

      "createTransactionPiTestnet" -> {
        val fromAddress = args["fromAddress"] as String
        val toAddress = args["toAddress"] as String
        val sequence = (args["sequence"] as String).toLong() + 1
        val fee = args["fee"] as Int
        val amount = (args["amount"] as String).toLong()
        val derivationPath = args["derivationPath"] as String
        val secretKey = args["secretKey"] as String
            val data =  createTransactionPiTestnet(fee,sequence, fromAddress,toAddress,amount,derivationPath, secretKey)
            result.success(data)
      }

       "createTransactionTron" -> {
         val fromAddress = args["fromAddress"] as String
         val toAddress = args["toAddress"] as String
         val fee = (args["fee"] as Int).toLong()
         val amount = (args["amount"] as String).toLong()
         val derivationPath = args["derivationPath"] as String
         val secretKey = args["secretKey"] as String
         val txTrieRoot = args["txTrieRoot"] as String
         val parentHash = args["parentHash"] as String
         val witnessAddress = args["witnessAddress"] as String
         val timestamp = (args["timestamp"] as Long).toLong()
         val number = (args["number"] as Int).toLong()
         val version = args["version"] as Int
              val data = createTransactionTron(fee, fromAddress, toAddress, amount, derivationPath, timestamp, number, version, parentHash, txTrieRoot, witnessAddress, secretKey)
              result.success(data)
       }

      "createTransactionTronTRC20" -> {
        val contractAddress = args["contractAddress"] as String
        val fromAddress = args["fromAddress"] as String
        val toAddress = args["toAddress"] as String
        val fee = (args["fee"] as Int).toLong()
        val amount = args["amount"] as String
        val derivationPath = args["derivationPath"] as String
        val secretKey = args["secretKey"] as String
        val txTrieRoot = args["txTrieRoot"] as String
        val parentHash = args["parentHash"] as String
        val witnessAddress = args["witnessAddress"] as String
        val timestamp = (args["timestamp"] as Long).toLong()
        val number = (args["number"] as Int).toLong()
        val version = args["version"] as Int
             val data = createTransactionTronTRC20(fee,contractAddress, fromAddress, toAddress, amount, derivationPath, timestamp, number, version, parentHash, txTrieRoot, witnessAddress, secretKey)
             result.success(data)
      }

       "base58Decode" -> {
         val addressString = args["addressString"] as String
              val data = base58Decode( addressString)
              result.success(data)
       }

       "base58Encode" -> {
         val addressHexString = args["addressHexString"] as String
             val data =  base58Encode(addressHexString)
             result.success(data)
       }

      "getAddressFromSeedphrase" -> {
        val seedphrase = args["seedphrase"] as String
            val data =  getAddressFromSeedphrase(seedphrase)
            result.success(data)
      }

      else -> result.notImplemented()
    }

  }

  private fun createMultiCoinWallet(strength: Int, passphrase: String): String {
    wallet = HDWallet(strength, passphrase)
    return if (wallet == null) ""
    else {
      wallet.mnemonic();
    }

  }

  private fun importMultiCoinWallet(mnemonic: String, passphrase: String): Boolean {
    val isValid: Boolean = HDWallet.isValid(mnemonic)
    if (isValid) {
      wallet = HDWallet(mnemonic, passphrase)
    }
    return isValid
  }

  private fun getAddressByCoinType(coinType: Int, derivationPath: String): String {
    val coinType = CoinType.createFromValue(coinType);
    val key = wallet?.getKey(coinType, derivationPath)
    return coinType.deriveAddress(key)
  }

  private fun getAddressFromPrivateKey(privatekey: String, coinType: Int): String {
    val data: ByteArray = privatekey.hexStringToByteArray()
    val coinType = CoinType.createFromValue(coinType);
    val isValid = PrivateKey.isValid(data, coinType.curve())
    var address = ""
    if (isValid) {
      val key = PrivateKey(data)
      address = coinType.deriveAddress(key)
    }
    return address
    }

  private fun getAddressFromSeedphrase(seedphrase: String): List<String> {
    val isValid = HDWallet.isValid(seedphrase)
    var address = ""
    var privatekey = ""
    if (isValid) {
      val walletForAddress = HDWallet( seedphrase,"")
      val key = walletForAddress.getKey(CoinType.STELLAR, "m/44'/314159'/0'")
      address  = CoinType.STELLAR.deriveAddress(key)
      privatekey = key.data().toHexString(false)
    }
    var result = mutableListOf<String>();
    result.add(address)
    result.add(privatekey)
    return result
  }

    private fun checkValidAddressOfCoinType(address: String, coinType: Int): Boolean {
      val coinType = CoinType.createFromValue(coinType);
      return coinType.validate(address)
    }

  private fun getPrivateKey(derivationPath: String, coinType: Int): String {
    val coinType = CoinType.createFromValue(coinType);
    val privateKey = wallet?.getKey(coinType, derivationPath)
    return privateKey.data().toHexString(false)
  }



    private fun createTransactionBitcoin(toAddress: String, fromAddress: String, hashs: List<String>, indexUtxos: List<Int>, amount: Long, amountUtxos: List<Long>, byteFee: Long, derivationPath: String, secretKey: String):String {
      val privateKey: PrivateKey
      if (secretKey.isEmpty()) {
        privateKey = wallet.getKey(CoinType.BITCOIN, derivationPath)
      } else {
        privateKey = PrivateKey(secretKey.hexStringToByteArray())
      }
      val utxos = mutableListOf<Bitcoin.UnspentTransaction>();

      for(index in hashs.indices) {
        val outPoint = Bitcoin.OutPoint.newBuilder().apply {
          this.hash = ByteString.copyFrom(hashs[index].hexStringToByteArray().reversedArray())
          this.index = indexUtxos[index]
        }.build()
        val utxo = Bitcoin.UnspentTransaction.newBuilder().apply {
          this.amount = amountUtxos[index]
          this.outPoint = outPoint
          this.script = ByteString.copyFrom(BitcoinScript.lockScriptForAddress(fromAddress, CoinType.BITCOIN).data())
        }.build()
        utxos.add(utxo)
      }
      val input = Bitcoin.SigningInput.newBuilder().apply {
        this.amount = amount
        this.hashType = BitcoinScript.hashTypeForCoin(CoinType.BITCOIN)
        this.toAddress = toAddress
        this.changeAddress = fromAddress
        this.byteFee = byteFee
        this.coinType = CoinType.BITCOIN.value()
        this.addPrivateKey(ByteString.copyFrom(privateKey.data()))
        this.addAllUtxo(utxos)
      }
      // Calculate fee (plan a tranaction)
      val plan  = AnySigner.plan(input.build(), CoinType.BITCOIN, Bitcoin.TransactionPlan.parser())
      print("Fee: ${plan.fee},Amount: ${plan.amount}, Avail_amount: ${plan.availableAmount}, Change: ${plan.change}")
      // Set the precomputed plan
      input.plan = plan
      input.amount = plan.amount
      val output = AnySigner.sign(input.build(), CoinType.BITCOIN, Bitcoin.SigningOutput.parser())
      return output.encoded.toByteArray().toHexString(false)
    }

  private fun createTransactionEthereum(nonce: String, chainId: String, gasPrice: String, gasLimit: String, toAddress: String, amount: String, derivationPath: String, secretKey: String): String {
    val privateKey: PrivateKey
    if (secretKey.isEmpty()) {
      privateKey = wallet.getKey(CoinType.ETHEREUM, derivationPath)

    } else {
      privateKey = PrivateKey(secretKey.hexStringToByteArray())
    }
    val signerInput = Ethereum.SigningInput.newBuilder().apply {
      this.privateKey = ByteString.copyFrom(privateKey.data())
      this.nonce = ByteString.copyFrom(BigInteger(nonce,16).toByteArray())
      this.chainId = ByteString.copyFrom(BigInteger(chainId,16).toByteArray())
      this.gasPrice = ByteString.copyFrom(BigInteger(gasPrice,16).toByteArray())
      this.gasLimit = ByteString.copyFrom(BigInteger(gasLimit,16).toByteArray())
      this.toAddress = toAddress
      this.transaction = Ethereum.Transaction.newBuilder().apply {
        this.transfer = Ethereum.Transaction.Transfer.newBuilder().apply {
          this.amount = ByteString.copyFrom(BigInteger(amount, 16).toByteArray())
        }.build()
      }.build()
    }.build()

    val outputEth = AnySigner.sign( signerInput,  CoinType.ETHEREUM, Ethereum.SigningOutput.parser())
    return outputEth.encoded.toByteArray().toHexString(false)
  }

    private fun createTransactionBinanceSmart(nonce: String, chainId: String, gasPrice: String, gasLimit: String, toAddress: String, amount: String, derivationPath: String, secretKey: String): String {
      val privateKey: PrivateKey
              if (secretKey.isEmpty()) {
                privateKey = wallet.getKey(CoinType.SMARTCHAIN, derivationPath)
              } else {
                privateKey = PrivateKey(secretKey.hexStringToByteArray())
              }
      val signerInput = Ethereum.SigningInput.newBuilder().apply {
        this.privateKey = ByteString.copyFrom(privateKey.data())
        this.nonce = ByteString.copyFrom(BigInteger(nonce,16).toByteArray())
        this.chainId = ByteString.copyFrom(BigInteger(chainId,16).toByteArray())
        this.gasPrice = ByteString.copyFrom(BigInteger(gasPrice,16).toByteArray())
        this.gasLimit = ByteString.copyFrom(BigInteger(gasLimit,16).toByteArray())
        this.toAddress = toAddress
        this.transaction = Ethereum.Transaction.newBuilder().apply {
       this.transfer = Ethereum.Transaction.Transfer.newBuilder().apply {
         this.amount = ByteString.copyFrom(BigInteger(amount,16).toByteArray())
       }.build()
      }.build()
      }.build()

      val outputEth = AnySigner.sign( signerInput,  CoinType.SMARTCHAIN, Ethereum.SigningOutput.parser())
      return outputEth.encoded.toByteArray().toHexString(false)
    }

  private fun createTransactionPolygon(nonce: String, chainId: String, gasPrice: String, gasLimit: String, toAddress: String, amount: String, derivationPath: String, secretKey: String): String {
    val privateKey: PrivateKey
    if (secretKey.isEmpty()) {
      privateKey = wallet.getKey(CoinType.POLYGON, derivationPath)
    } else {
      privateKey = PrivateKey(secretKey.hexStringToByteArray())
    }
    val signerInput = Ethereum.SigningInput.newBuilder().apply {
      this.privateKey = ByteString.copyFrom(privateKey.data())
      this.nonce = ByteString.copyFrom(BigInteger(nonce,16).toByteArray())
      this.chainId = ByteString.copyFrom(BigInteger(chainId,16).toByteArray())
      this.gasPrice = ByteString.copyFrom(BigInteger(gasPrice,16).toByteArray())
      this.gasLimit = ByteString.copyFrom(BigInteger(gasLimit,16).toByteArray())
      this.toAddress = toAddress
      this.transaction = Ethereum.Transaction.newBuilder().apply {
        this.transfer = Ethereum.Transaction.Transfer.newBuilder().apply {
          this.amount = ByteString.copyFrom(BigInteger(amount,16).toByteArray())
        }.build()
      }.build()
    }.build()

    val outputEth = AnySigner.sign( signerInput,  CoinType.POLYGON, Ethereum.SigningOutput.parser())
    return outputEth.encoded.toByteArray().toHexString(false)
  }

  private fun createTransactionStellar(fee: Int, sequence: Long, fromAddress: String, toAddress: String, amount: Long, derivationPath: String, secretKey: String):String {
    val privateKey: PrivateKey
    if (secretKey.isEmpty()) {
      privateKey = wallet.getKey(CoinType.STELLAR, derivationPath)

    } else {
      privateKey = PrivateKey(secretKey.hexStringToByteArray())
    }
    val signerInput = Stellar.SigningInput.newBuilder().apply {
      this.fee = fee
      this.account = fromAddress
      this.sequence = sequence
      this.passphrase = StellarPassphrase.STELLAR.toString()
      this.privateKey = ByteString.copyFrom(privateKey.data())
      this.opPayment = Stellar.OperationPayment.newBuilder().apply {
        this.destination = toAddress
        this.amount = amount
      }.build()
    }.build()
    val outputStellar = AnySigner.sign(signerInput, CoinType.STELLAR, Stellar.SigningOutput.parser())
    return outputStellar.signature
  }

  private fun createTransactionPiTestnet(fee: Int, sequence: Long, fromAddress: String, toAddress: String, amount: Long, derivationPath: String, secretKey: String):String {
    val privateKey: PrivateKey
    if (secretKey.isEmpty()) {
      privateKey = wallet.getKey(CoinType.STELLAR, derivationPath)
    } else {
      privateKey = PrivateKey(secretKey.hexStringToByteArray())
    }
    val signerInput = Stellar.SigningInput.newBuilder().apply {
      this.fee = fee
      this.account = fromAddress
      this.sequence = sequence
      this.passphrase = "Pi Testnet"
      this.privateKey = ByteString.copyFrom(privateKey.data())
      this.opPayment = Stellar.OperationPayment.newBuilder().apply {
        this.destination = toAddress
        this.amount = amount
      }.build()
    }.build()
    val outputStellar = AnySigner.sign(signerInput, CoinType.STELLAR, Stellar.SigningOutput.parser())
    return outputStellar.signature
  }

  private fun createTransactionTron(fee: Long, fromAddress: String, toAddress: String, amount: Long, derivationPath: String, timestamp : Long, number: Long, version: Int, parentHash: String, txTrieRoot: String, witnessAddress: String,secretKey: String):String {
    val privateKey: PrivateKey
    if (secretKey.isEmpty()) {
      privateKey = wallet.getKey(CoinType.TRON, derivationPath)
    } else {
      privateKey = PrivateKey(secretKey.hexStringToByteArray())
    }
    val signerInput = Tron.SigningInput.newBuilder().apply {
      this.privateKey = ByteString.copyFrom(privateKey.data())
      this.transaction = Tron.Transaction.newBuilder().apply {
        this.transfer = Tron.TransferContract.newBuilder().apply {
          this.ownerAddress = fromAddress
          this.toAddress = toAddress
          this.amount = amount
        }.build()
        this.blockHeader = Tron.BlockHeader.newBuilder().apply {
          this.timestamp = timestamp
          this.txTrieRoot = ByteString.copyFrom(txTrieRoot.hexStringToByteArray())
          this.parentHash = ByteString.copyFrom(parentHash.hexStringToByteArray())
          this.number = number
          this.witnessAddress = ByteString.copyFrom(witnessAddress.hexStringToByteArray())
          this.version = version
        }.build()
        this.timestamp = timestamp
        this.expiration = timestamp + 10*60*60*1000
        this.feeLimit = fee
      }.build()
    }.build()
    val outputTron = AnySigner.sign(signerInput, CoinType.TRON, Tron.SigningOutput.parser())
    return outputTron.json
  }

  private fun createTransactionTronTRC20(fee: Long, contractAddress: String, fromAddress: String, toAddress: String, amount: String, derivationPath: String, timestamp : Long, number: Long, version: Int, parentHash: String, txTrieRoot: String, witnessAddress: String,secretKey: String):String {
    val privateKey: PrivateKey
    if (secretKey.isEmpty()) {
      privateKey = wallet.getKey(CoinType.TRON, derivationPath)
    } else {
      privateKey = PrivateKey(secretKey.hexStringToByteArray())
    }
    val signerInput = Tron.SigningInput.newBuilder().apply {
      this.privateKey = ByteString.copyFrom(privateKey.data())
      this.transaction = Tron.Transaction.newBuilder().apply {
        this.transferTrc20Contract = Tron.TransferTRC20Contract.newBuilder().apply {
          this.ownerAddress = fromAddress
          this.toAddress = toAddress
          this.contractAddress = contractAddress
          this.amount = ByteString.copyFrom(amount.hexStringToByteArray())
        }.build()
        this.blockHeader = Tron.BlockHeader.newBuilder().apply {
          this.timestamp = timestamp
          this.txTrieRoot = ByteString.copyFrom(txTrieRoot.hexStringToByteArray())
          this.parentHash = ByteString.copyFrom(parentHash.hexStringToByteArray())
          this.number = number
          this.witnessAddress = ByteString.copyFrom(witnessAddress.hexStringToByteArray())
          this.version = version
        }.build()
        this.timestamp = timestamp
        this.expiration = timestamp + 10*60*60*1000
        this.feeLimit = fee
      }.build()
    }.build()
    val outputTron = AnySigner.sign(signerInput, CoinType.TRON, Tron.SigningOutput.parser())
    return outputTron.json
  }

  private fun BigInteger.toByteString(): ByteString {
    return ByteString.copyFrom(this.toByteArray())
  }

  private fun ByteArray.toHexString(withPrefix: Boolean = true): String {
    val stringBuilder = StringBuilder()
    if(withPrefix) {
      stringBuilder.append("0x")
    }
    for (element in this) {
      stringBuilder.append(String.format("%02x", element and 0xFF.toByte()))
    }
    return stringBuilder.toString()
  }

  private fun String.hexStringToByteArray() : ByteArray {
    val HEX_CHARS = "0123456789ABCDEF"
    val result = ByteArray(this.length / 2)
    for (i in 0 until length step 2) {
      val firstIndex = HEX_CHARS.indexOf(this[i].toUpperCase());
      val secondIndex = HEX_CHARS.indexOf(this[i + 1].toUpperCase());
      val octet = firstIndex.shl(4).or(secondIndex)
      result.set(i.shr(1), octet.toByte())
    }
    return result
  }

  private fun base58Encode(addressHexString: String):String {
    return Base58.encode(addressHexString.hexStringToByteArray())
  }

  private fun  base58Decode(addressString: String):String {
    return Base58.decode(addressString).toString()
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

}
