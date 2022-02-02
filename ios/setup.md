## Create TrustWalletCore Plugin
https://github.com/trustwallet/wallet-core

https://developer.trustwallet.com/wallet-core/integration-guide

https://github.com/trustwallet/wallet-core/tree/master/samples/osx/cocoapods/WalletCoreExample

https://github.com/trustwallet/wallet-core/tree/master/samples/android

https://openethereum.github.io/JSONRPC-eth-module#eth_sendrawtransaction

https://documenter.getpostman.com/view/4117254/ethereum-json-rpc/RVu7CT5J?version=latest

https://developer.bitcoin.org/reference/rpc/getbalance.html

https://github.com/trustwallet/wallet-core/blob/master/coins.json

https://iancoleman.io/bip39/

https://flightwallet.github.io/decode-eth-tx/

https://pi-blockchain.net/

https://github.com/trustwallet/wallet-core/blob/master/swift/Tests/Blockchains/TronTests.swift#L24

1. create dart package:
```dart
$ flutter create --platform=android,ios --template=plugin packages/trust_wallet_core_plugin
```

2. IOS.
>2.1 Add `TrustWalletCore` to Podfile in packages/trust_wallet_core_plugin/ios/Podfile. 
```
pod 'TrustWalletCore'
```
>2.2 Get Swift package, change platform :ios, '12.0' in podfile
```
pod install
```
3. Android◊
>3.1 Add `TrustWalletCore` to Podfile in packages/trust_wallet_core_plugin/ios/Podfile. 
```
pod 'TrustWalletCore'
```
>2.2 Get Swift package, change platform :ios, '12.0' in podfile
```
pod install
```