import 'dart:math';

import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/services/setting_services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect.dart';
import 'package:trust_wallet_core_plugin/trust_wallet_core_plugin.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class KardiaChainProvider extends GetConnect {
  static const String contractCreateTokenAbi =
      '0x9b222ce7E187B098fe6D622a0C3E316DE72191DB';

  /// Kaidex: V2 Router
  static const String contractSwapAbi =
      '0x66153fDc998252C0A98764933e2fC8D1B1009C2B';

  ///Kaidex: Factory
  static const String contractFactory =
      '0x64203f29f4d6a7e199b6f6aFbe65F1fa914c7C4e';
  static const String contractWrapKAI =
      '0xAF984E23EAA3E7967F3C5E007fbe397D8566D23d';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  late String _httpUrl;
  late String _wssUrl;
  late Web3Client _client;

  void initData(BlockChainModel blockChain) {
    _httpUrl = blockChain.nodeHttp;
    _wssUrl = blockChain.nodeWss;
    _client = Web3Client(_httpUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wssUrl).cast<String>();
    });
  }

  Future<dynamic> postApi({
    required EnumKardiaChainMethod method,
    required List<dynamic> params,
  }) async {
    final data = {
      'method': method.toString().split('.')[1],
      'params': params,
      'id': 1,
      'jsonrpc': '2.0'
    };
    final response = await httpClient.post(
      _httpUrl,
      body: data,
      headers: _headers,
    );
    // print('\n---------------------KardiaChainProvider---------------------');
    // print('body: $data');
    // print('response.statusCode: ${response.statusCode}');
    // print('response.body: ${response.body}');
    if (response.statusCode == 200 && response.body['error'] == null) {
      return response.body['result'];
    } else {
      throw Exception('KardiaChainProvider Error: ${response.body}');
    }
  }

  Future<int> getTransactionCount({required String address}) async {
    final result = await postApi(
      method: EnumKardiaChainMethod.account_nonce,
      params: [address],
    );
    return result;
  }

  Future<BigInt> getGasPrice() async {
    final result = await postApi(
      method: EnumKardiaChainMethod.kai_gasPrice,
      params: [],
    );

    return BigInt.parse(result);
  }

  Future<String> sendTransactionByWeb3({
    required String addrsassRecieve,
    required String privateKey,
    required String addressSender,
    required BigInt amount,
    required int gasLimit,
    required BigInt gasPrice,
  }) async {
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final nonce = await getTransactionCount(address: addressSender);
    final result = await _client.sendTransaction(
        credentials,
        Transaction(
          from: senderAddr,
          to: receiverAddr,
          maxGas: gasLimit,
          gasPrice: EtherAmount.inWei(gasPrice),
          value: EtherAmount.inWei(amount),
          nonce: nonce,
        ),
        chainId: null,
        fetchChainIdFromNetworkId: false);
    return result;
  }

  Future<String> sendTransactionKRC20({
    required String addressContract,
    required String addrsassRecieve,
    required String privateKey,
    required String addressSender,
    required BigInt amount,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final abiERC20 = Get.find<SettingService>().abiERC20BEP20;
    final contractAddr = EthereumAddress.fromHex(addressContract);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final nonce = await getTransactionCount(address: addressSender);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiERC20, 'KRC20 Token'), contractAddr);
    final sendFunction = contract.function('transfer');
    final result = await _client.sendTransaction(
        credentials,
        Transaction.callContract(
          from: senderAddr,
          contract: contract,
          function: sendFunction,
          parameters: [receiverAddr, amount],
          gasPrice: EtherAmount.inWei(gasPrice),
          maxGas: gasLimit.toInt(),
          nonce: nonce,
        ),
        chainId: null,
        fetchChainIdFromNetworkId: false);
    return result;
  }

  Future<BigInt> getBalance({required String address}) async {
    final result = await postApi(
        method: EnumKardiaChainMethod.account_balance,
        params: [
          address,
          EnumKardiaChainDefaultBlock.latest.toString().split('.')[1]
        ]);
    return BigInt.parse(result);
  }

  Future<BigInt> getBalanceOfKRC20({
    required String address,
    required String contractAddress,
  }) async {
    final contractAddr = EthereumAddress.fromHex(contractAddress);
    final abiERC20 = Get.find<SettingService>().abiERC20BEP20;
    final contract = DeployedContract(
        ContractAbi.fromJson(abiERC20, 'KRC20 Token'), contractAddr);
    final balanceFunction = contract.function('balanceOf');
    final balance = await _client.call(
        contract: contract,
        function: balanceFunction,
        params: [EthereumAddress.fromHex(address)]);
    return balance.first as BigInt;
  }

  Future<int> getCurrencyBlock() async {
    final result = await postApi(
        method: EnumKardiaChainMethod.kai_blockNumber, params: []);
    return result;
  }

  Future<BigInt> getGasLimit({
    required String addressSend,
    required String addressRecieve,
    required BigInt amount,
  }) async {
    try {
      final gasLimit = await _client.estimateGas(
          sender: EthereumAddress.fromHex(addressSend),
          to: EthereumAddress.fromHex(addressRecieve),
          value: EtherAmount.inWei(BigInt.from(0)));
      return gasLimit;
    } catch (exp) {
      throw 'Calculator fee failure';
    }
  }

  Future<Map<String, dynamic>> getTransactionsLatest(String address) async {
    final currenctNumber = await getCurrencyBlock();
    var txLatest = <String, dynamic>{};
    var isBreak = false;
    for (var i = currenctNumber; i >= currenctNumber - 100; i--) {
      final result = await postApi(
          method: EnumKardiaChainMethod.kai_getBlockByNumber, params: [i]);
      for (var tx in result['txs']) {
        final input = tx['input'];
        final data = TrustWalletCorePlugin.decodeTransfer(data: input);
        if (data != null) {
          if (data['recipient'].toLowerCase() == address.toLowerCase()) {
            txLatest = tx;
            isBreak = true;
            break;
          }
        }
        if ((tx['from'] as String).toLowerCase() == address.toLowerCase() ||
            (tx['to'] as String).toLowerCase() == address.toLowerCase()) {
          txLatest = tx;
          isBreak = true;
          break;
        }
      }
      if (isBreak) {
        break;
      }
    }
    return txLatest;
  }

  Future<Map<String, dynamic>> getTransactionByHash(String hash) async {
    final result = await postApi(
        method: EnumKardiaChainMethod.tx_getTransaction, params: [hash]);
    return result;
  }

  Future<Map<String, dynamic>?> getTransactionReceiptByHash(String hash) async {
    final result = await postApi(
        method: EnumKardiaChainMethod.tx_getTransactionReceipt, params: [hash]);
    return result;
  }

  Future<BigInt> getGasLimitToSendTransactionToken({
    required String addressContract,
    required String addrsassRecieve,
    required String addressSender,
    required BigInt amount,
  }) async {
    try {
      final abiBEP20 = Get.find<SettingService>().abiERC20BEP20;
      final contractAddr = EthereumAddress.fromHex(addressContract);
      final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
      final senderAddr = EthereumAddress.fromHex(addressSender);
      final contract = DeployedContract(
          ContractAbi.fromJson(abiBEP20, 'KRC20 Token'), contractAddr);
      final sendFunction = contract.function('transfer');
      final data = Transaction.callContract(
              from: senderAddr,
              contract: contract,
              function: sendFunction,
              parameters: [receiverAddr, amount],
              nonce: null)
          .data;
      final gasLimit = await _client.estimateGas(
        sender: senderAddr,
        to: contractAddr,
        data: data,
      );
      return gasLimit;
    } catch (exp) {
      throw 'Calculator fee failure';
    }
  }

  Future<CoinModel> getTokenModelKRC20Info(
      {required String addressContract}) async {
    final contractAddr = EthereumAddress.fromHex(addressContract);
    final abiERC20 = Get.find<SettingService>().abiERC20BEP20;
    final contract = DeployedContract(
        ContractAbi.fromJson(abiERC20, 'KRC20 Token'), contractAddr);
    final symbolFunction = contract.function('symbol');
    final decimalsFunction = contract.function('decimals');
    final nameFunction = contract.function('name');
    final symbol = await _client
        .call(contract: contract, function: symbolFunction, params: []);
    final decimals = await _client
        .call(contract: contract, function: decimalsFunction, params: []);
    final name = await _client
        .call(contract: contract, function: nameFunction, params: []);
    final coinModel = CoinModel.empty().copyWith(
        symbol: symbol.first.toString(),
        decimals: int.parse(decimals.first.toString()),
        name: name.first.toString(),
        contractAddress: addressContract,
        type: 'Token KardiaChain');
    return coinModel;
  }

  Future<String> swapExactKAIForTokensSupportingFeeOnTransferTokens({
    required String tokenContractTo,
    required String privateKey,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amount,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final abiKRC20 = Get.find<SettingService>().abiSwapKRC20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final wrapKAIContract = EthereumAddress.fromHex(contractWrapKAI);
    final tokenContract = EthereumAddress.fromHex(tokenContractTo);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final nonce = await getTransactionCount(address: addressSender);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiKRC20, 'KRC20 Token'), contractAbi);
    final swapFunction =
        contract.function('swapExactKAIForTokensSupportingFeeOnTransferTokens');
    final result = await _client.sendTransaction(
        credentials,
        Transaction.callContract(
            from: senderAddr,
            contract: contract,
            function: swapFunction,
            value: EtherAmount.inWei(amount),
            parameters: [
              BigInt.from(1),
              [wrapKAIContract, tokenContract],
              receiverAddr,
              BigInt.from(
                  (DateTime.now().millisecondsSinceEpoch / 1000).round() +
                      20 * 60)
            ],
            gasPrice: EtherAmount.inWei(gasPrice),
            maxGas: gasLimit.toInt(),
            nonce: nonce),
        chainId: null,
        fetchChainIdFromNetworkId: false);
    return result;
  }

  Future<BigInt> getGasLimitToSwapExactKAIForTokens({
    required String tokenContractTo,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amount,
  }) async {
    final abiKRC20 = Get.find<SettingService>().abiSwapKRC20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final wrapKAIContract = EthereumAddress.fromHex(contractWrapKAI);
    final tokenContract = EthereumAddress.fromHex(tokenContractTo);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiKRC20, 'KRC20 Token'), contractAbi);
    final swapFunction =
        contract.function('swapExactKAIForTokensSupportingFeeOnTransferTokens');
    final data = Transaction.callContract(
      from: senderAddr,
      contract: contract,
      function: swapFunction,
      value: EtherAmount.inWei(amount),
      parameters: [
        BigInt.from(1),
        [wrapKAIContract, tokenContract],
        receiverAddr,
        BigInt.from(
            (DateTime.now().millisecondsSinceEpoch / 1000).round() + 20 * 60)
      ],
    ).data;
    final gasLimit = await _client.estimateGas(
      sender: senderAddr,
      to: contractAbi,
      value: EtherAmount.inWei(amount),
      data: data,
    );
    return gasLimit;
  }

  Future<String> swapExactTokensForKAISupportingFeeOnTransferTokens({
    required String tokenContractFrom,
    required String privateKey,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amount,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final abiKRC20 = Get.find<SettingService>().abiSwapKRC20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final wrapKAIContract = EthereumAddress.fromHex(contractWrapKAI);
    final tokenContract = EthereumAddress.fromHex(tokenContractFrom);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final nonce = await getTransactionCount(address: addressSender);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiKRC20, 'KRC20 Token'), contractAbi);
    final swapFunction =
        contract.function('swapExactTokensForKAISupportingFeeOnTransferTokens');
    final result = await _client.sendTransaction(
        credentials,
        Transaction.callContract(
            from: senderAddr,
            contract: contract,
            function: swapFunction,
            parameters: [
              amount,
              BigInt.from(1),
              [tokenContract, wrapKAIContract],
              receiverAddr,
              BigInt.from(
                  (DateTime.now().millisecondsSinceEpoch / 1000).round() +
                      20 * 60)
            ],
            gasPrice: EtherAmount.inWei(gasPrice),
            maxGas: gasLimit.toInt(),
            nonce: nonce),
        chainId: null,
        fetchChainIdFromNetworkId: false);
    return result;
  }

  Future<BigInt> getGasLimitSwapExactTokensForKAI({
    required String tokenContractFrom,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amount,
  }) async {
    final abiSwap = Get.find<SettingService>().abiSwapKRC20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final wrapKAIContract = EthereumAddress.fromHex(contractWrapKAI);
    final tokenContract = EthereumAddress.fromHex(tokenContractFrom);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiSwap, 'KRC20 Token'), contractAbi);
    final swapFunction =
        contract.function('swapExactTokensForKAISupportingFeeOnTransferTokens');
    final data = Transaction.callContract(
      from: senderAddr,
      contract: contract,
      function: swapFunction,
      parameters: [
        amount,
        BigInt.from(1),
        [tokenContract, wrapKAIContract],
        receiverAddr,
        BigInt.from(
            (DateTime.now().millisecondsSinceEpoch / 1000).round() + 20 * 60)
      ],
    ).data;
    final gasLimit = await _client.estimateGas(
      sender: senderAddr,
      to: contractAbi,
      data: data,
    );

    return gasLimit;
  }

  Future<String> swapExactTokensForTokensSupportingFeeOnTransferTokens({
    required String tokenContractFrom,
    required String tokenContractTo,
    required String privateKey,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amount,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final abiKRC20 = Get.find<SettingService>().abiSwapKRC20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final wrapKAIContract = EthereumAddress.fromHex(contractWrapKAI);
    final tokenFrom = EthereumAddress.fromHex(tokenContractFrom);
    final tokenSwap = EthereumAddress.fromHex(tokenContractTo);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final nonce = await getTransactionCount(address: addressSender);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiKRC20, 'KRC20 Token'), contractAbi);
    final swapFunction = contract
        .function('swapExactTokensForTokensSupportingFeeOnTransferTokens');
    final path = [];
    if (tokenContractTo.toLowerCase() == contractWrapKAI.toLowerCase() ||
        tokenContractFrom.toLowerCase() == contractWrapKAI.toLowerCase()) {
      path..add(tokenFrom)..add(tokenSwap);
    } else {
      path..add(tokenFrom)..add(wrapKAIContract)..add(tokenSwap);
    }
    final result = await _client.sendTransaction(
        credentials,
        Transaction.callContract(
          from: senderAddr,
          contract: contract,
          function: swapFunction,
          parameters: [
            amount,
            BigInt.from(1),
            path,
            receiverAddr,
            BigInt.from((DateTime.now().millisecondsSinceEpoch / 1000).round() +
                20 * 60)
          ],
          gasPrice: EtherAmount.inWei(gasPrice),
          maxGas: gasLimit.toInt(),
          nonce: nonce,
        ),
        chainId: null,
        fetchChainIdFromNetworkId: false);
    return result;
  }

  Future<BigInt> getGasLimitSwapExactTokensForTokens({
    required String tokenContractFrom,
    required String tokenContractTo,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amount,
  }) async {
    final abiKRC20 = Get.find<SettingService>().abiSwapKRC20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final wrapKAIContract = EthereumAddress.fromHex(contractWrapKAI);
    final tokenFrom = EthereumAddress.fromHex(tokenContractFrom);
    final tokenSwap = EthereumAddress.fromHex(tokenContractTo);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiKRC20, 'KRC20 Token'), contractAbi);
    final swapFunction = contract
        .function('swapExactTokensForTokensSupportingFeeOnTransferTokens');
    final path = [];
    if (tokenContractTo.toLowerCase() == contractWrapKAI.toLowerCase() ||
        tokenContractFrom.toLowerCase() == contractWrapKAI.toLowerCase()) {
      path..add(tokenFrom)..add(tokenSwap);
    } else {
      path..add(tokenFrom)..add(wrapKAIContract)..add(tokenSwap);
    }
    final data = Transaction.callContract(
      from: senderAddr,
      contract: contract,
      function: swapFunction,
      parameters: [
        amount,
        BigInt.from(1),
        path,
        receiverAddr,
        BigInt.from(
            (DateTime.now().millisecondsSinceEpoch / 1000).round() + 20 * 60)
      ],
    ).data;
    final gasLimit = await _client.estimateGas(
      sender: senderAddr,
      to: contractAbi,
      data: data,
    );
    return gasLimit;
  }

  Future<double> getAmountsOut({
    required String tokenContractFrom,
    required String tokenContractTo,
    required BigInt amount,
  }) async {
    try {
      final abiKRC20 = Get.find<SettingService>().abiSwapKRC20;
      final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
      final tokenFrom = tokenContractFrom.isNotEmpty
          ? EthereumAddress.fromHex(tokenContractFrom)
          : EthereumAddress.fromHex(contractWrapKAI);
      final tokenTo = tokenContractTo.isNotEmpty
          ? EthereumAddress.fromHex(tokenContractTo)
          : EthereumAddress.fromHex(contractWrapKAI);
      final contract = DeployedContract(
          ContractAbi.fromJson(abiKRC20, 'KRC20 Token'), contractAbi);
      final getAmountsOutFunction = contract.function('getAmountsOut');
      final amountOut = await _client.call(
        contract: contract,
        function: getAmountsOutFunction,
        params: [
          amount,
          [tokenFrom, tokenTo],
        ],
      );
      final rate = amountOut[0][1] / amountOut[0][0];
      return rate;
    } catch (exp) {
      throw exp.toString();
    }
  }

  Future<BigInt> getGasLimitApprove({
    required String addressContract,
    required String addrsassSender,
    required String addressOwner,
    required BigInt amount,
  }) async {
    try {
      final abi = Get.find<SettingService>().abiERC20BEP20;
      final contractAddr = EthereumAddress.fromHex(addressContract);
      final senderAddr = EthereumAddress.fromHex(addrsassSender);
      final ownerAddr = EthereumAddress.fromHex(addressOwner);
      final contract = DeployedContract(
          ContractAbi.fromJson(abi, 'KRC20 Token'), contractAddr);
      final approveFunction = contract.function('approve');
      final data = Transaction.callContract(
              from: ownerAddr,
              contract: contract,
              function: approveFunction,
              parameters: [senderAddr, amount],
              nonce: null)
          .data;

      final gasLimit = await _client.estimateGas(
        sender: ownerAddr,
        to: contractAddr,
        data: data,
      );
      return gasLimit;
    } catch (exp) {
      throw 'Calculator fee failure';
    }
  }

  Future<String> sendTransactionApprove({
    required String addressContract,
    required String ownerAddress,
    required String senderAddress,
    required String privateKey,
    required BigInt amount,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final abi = Get.find<SettingService>().abiERC20BEP20;
    final contractAddr = EthereumAddress.fromHex(addressContract);
    final senderAddr = EthereumAddress.fromHex(senderAddress);
    final ownderAddr = EthereumAddress.fromHex(ownerAddress);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final nonce = await getTransactionCount(address: ownerAddress);
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, 'KRC20 Token'), contractAddr);
    final sendFunction = contract.function('approve');
    final result = await _client.sendTransaction(
        credentials,
        Transaction.callContract(
            from: ownderAddr,
            contract: contract,
            function: sendFunction,
            parameters: [senderAddr, amount],
            gasPrice: EtherAmount.inWei(gasPrice),
            maxGas: gasLimit.toInt(),
            nonce: nonce),
        chainId: null,
        fetchChainIdFromNetworkId: false);
    return result;
  }

  Future<BigInt> getAllowance({
    required String addressOwner,
    required String addressSender,
    required String contractAddress,
  }) async {
    final contractAddr = EthereumAddress.fromHex(contractAddress);
    final abiERC20 = Get.find<SettingService>().abiERC20BEP20;
    final contract = DeployedContract(
        ContractAbi.fromJson(abiERC20, 'KRC20 Token'), contractAddr);
    final allowanceFunction = contract.function('allowance');
    final value = await _client.call(
      contract: contract,
      function: allowanceFunction,
      params: [
        EthereumAddress.fromHex(addressOwner),
        EthereumAddress.fromHex(addressSender)
      ],
    );
    return value.first;
  }

  Future<String> sendTransactionRevokeKRC20({
    required String addressContract,
    required String ownerAddress,
    required String senderAddress,
    required String privateKey,
    required double amount,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final abiBEP20 = Get.find<SettingService>().abiERC20BEP20;
    final contractAddr = EthereumAddress.fromHex(addressContract);
    final senderAddr = EthereumAddress.fromHex(senderAddress);
    final ownderAddr = EthereumAddress.fromHex(ownerAddress);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final nonce = await getTransactionCount(address: ownerAddress);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiBEP20, 'KRC20 Token'), contractAddr);
    final sendFunction = contract.function('approve');
    final result = await _client.sendTransaction(
        credentials,
        Transaction.callContract(
            from: ownderAddr,
            contract: contract,
            function: sendFunction,
            parameters: [senderAddr, BigInt.from(amount)],
            gasPrice: EtherAmount.inWei(gasPrice),
            maxGas: gasLimit.toInt(),
            nonce: nonce),
        chainId: null,
        fetchChainIdFromNetworkId: false);
    return result;
  }

  Future<String> getPairFactory({
    required String tokenFrom,
    required String tokenTo,
  }) async {
    final abi = Get.find<SettingService>().abiFactory;
    final contractAddr = EthereumAddress.fromHex(contractFactory);
    final contractFrom = EthereumAddress.fromHex(
        tokenFrom.isEmpty ? contractWrapKAI : tokenFrom);
    final contractTo = EthereumAddress.fromHex(
      tokenTo.isEmpty ? contractWrapKAI : tokenTo,
    );
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, 'KRC20 Token'), contractAddr);
    final getPairFunction = contract.function('getPair');
    final result = await _client.call(
        contract: contract,
        function: getPairFunction,
        params: [contractFrom, contractTo]);
    return result.first.toString();
  }

  Future<List<dynamic>> getReservesLPToken({required String tokenLP}) async {
    final abi = Get.find<SettingService>().abiLPToken;
    final contractLP = EthereumAddress.fromHex(tokenLP);
    final contract =
        DeployedContract(ContractAbi.fromJson(abi, 'KRC20 Token'), contractLP);
    final getReservesFunction = contract.function('getReserves');
    final result = await _client
        .call(contract: contract, function: getReservesFunction, params: []);
    return result;
  }

  Future<String> getLpTokenA({required String tokenLP}) async {
    final abi = Get.find<SettingService>().abiLPToken;
    final contractLP = EthereumAddress.fromHex(tokenLP);
    final contract =
        DeployedContract(ContractAbi.fromJson(abi, 'KRC20 Token'), contractLP);
    final getToken0Function = contract.function('token0');
    final result = await _client
        .call(contract: contract, function: getToken0Function, params: []);
    return result.first.toString();
  }

  Future<BigInt> getGasLimitAddLiquidityKAI({
    required String token,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountToken,
    required BigInt amountCoin,
  }) async {
    final abiSwap = Get.find<SettingService>().abiSwapKRC20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final tokenContract = EthereumAddress.fromHex(token);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiSwap, 'KRC20 Token'), contractAbi);
    final addLiquidityFunction = contract.function('addLiquidityKAI');
    final data = Transaction.callContract(
      from: senderAddr,
      contract: contract,
      function: addLiquidityFunction,
      value: EtherAmount.inWei(amountCoin),
      parameters: [
        tokenContract,
        amountToken,
        BigInt.from(1),
        BigInt.from(1),
        receiverAddr,
        BigInt.from(
            (DateTime.now().millisecondsSinceEpoch / 1000).round() + 20 * 60)
      ],
    ).data;
    final gasLimit = await _client.estimateGas(
      sender: senderAddr,
      value: EtherAmount.inWei(amountCoin),
      to: contractAbi,
      data: data,
    );

    return gasLimit;
  }

  Future<String> addLiquidityKAI({
    required String token,
    required String privateKey,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountToken,
    required BigInt amountCoin,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final abiKRC20 = Get.find<SettingService>().abiSwapKRC20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final tokenContract = EthereumAddress.fromHex(token);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final nonce = await getTransactionCount(address: addressSender);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiKRC20, 'KRC20 Token'), contractAbi);
    final addLiquidityFunction = contract.function('addLiquidityKAI');
    final result = await _client.sendTransaction(
        credentials,
        Transaction.callContract(
          from: senderAddr,
          contract: contract,
          function: addLiquidityFunction,
          value: EtherAmount.inWei(amountCoin),
          parameters: [
            tokenContract,
            amountToken,
            BigInt.from(1),
            BigInt.from(1),
            receiverAddr,
            BigInt.from((DateTime.now().millisecondsSinceEpoch / 1000).round() +
                20 * 60)
          ],
          gasPrice: EtherAmount.inWei(gasPrice),
          maxGas: gasLimit.toInt(),
          nonce: nonce,
        ),
        chainId: null,
        fetchChainIdFromNetworkId: false);
    return result;
  }

  // Future<String> calculatorLPToken({
  //   required String token,
  //   required String addressSender,
  //   required String addrsassRecieve,
  //   required BigInt amountToken,
  //   required BigInt amountCoin,
  // }) async {
  //   print('---------------------11111---------------------');
  //   print(11111);
  //   print(amountToken);
  //   print(amountCoin);
  //   print('---------------------11111----------------------');
  //   final abiKRC20 = Get.find<SettingService>().abiSwapKRC20;
  //   final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
  //   final tokenContract = EthereumAddress.fromHex(token);
  //   final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
  //   final senderAddr = EthereumAddress.fromHex(addressSender);
  //   final contract = DeployedContract(
  //       ContractAbi.fromJson(abiKRC20, 'KRC20 Token'), contractAbi);
  //   final addLiquidityFunction = contract.function('addLiquidityKAI');
  //   final data = Transaction.callContract(
  //     from: senderAddr,
  //     contract: contract,
  //     function: addLiquidityFunction,
  //     value: EtherAmount.inWei(amountCoin),
  //     parameters: [
  //       tokenContract,
  //       amountToken,
  //       BigInt.from(1),
  //       BigInt.from(1),
  //       receiverAddr,
  //       BigInt.from(
  //           (DateTime.now().millisecondsSinceEpoch / 1000).round() + 20 * 60),
  //     ],
  //   ).data;
  //   final result = await _client.callRaw(
  //       sender: senderAddr, contract: contractAbi, data: data!);
  //   return result;
  // }

  Future<BigInt> getGasLimitAddLiquidityToken({
    required String tokenA,
    required String tokenB,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountTokenA,
    required BigInt amountTokenB,
  }) async {
    final abiSwap = Get.find<SettingService>().abiSwapKRC20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final tokenAContract = EthereumAddress.fromHex(tokenA);
    final tokenBContract = EthereumAddress.fromHex(tokenB);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiSwap, 'KRC20 Token'), contractAbi);
    final addLiquidityFunction = contract.function('addLiquidity');
    final data = Transaction.callContract(
      from: senderAddr,
      contract: contract,
      function: addLiquidityFunction,
      parameters: [
        tokenAContract,
        tokenBContract,
        amountTokenA,
        amountTokenB,
        BigInt.from(1),
        BigInt.from(1),
        receiverAddr,
        BigInt.from(
            (DateTime.now().millisecondsSinceEpoch / 1000).round() + 20 * 60)
      ],
    ).data;
    final gasLimit = await _client.estimateGas(
      sender: senderAddr,
      to: contractAbi,
      data: data,
    );

    return gasLimit;
  }

  Future<String> addLiquidityToken({
    required String tokenA,
    required String tokenB,
    required String privateKey,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountTokenA,
    required BigInt amountTokenB,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final abiKRC20 = Get.find<SettingService>().abiSwapKRC20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final tokenAContract = EthereumAddress.fromHex(tokenA);
    final tokenBContract = EthereumAddress.fromHex(tokenB);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final nonce = await getTransactionCount(address: addressSender);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiKRC20, 'KRC20 Token'), contractAbi);
    final addLiquidityFunction = contract.function('addLiquidity');
    final result = await _client.sendTransaction(
        credentials,
        Transaction.callContract(
          from: senderAddr,
          contract: contract,
          function: addLiquidityFunction,
          parameters: [
            tokenAContract,
            tokenBContract,
            amountTokenA,
            amountTokenB,
            BigInt.from(1),
            BigInt.from(1),
            receiverAddr,
            BigInt.from((DateTime.now().millisecondsSinceEpoch / 1000).round() +
                20 * 60)
          ],
          gasPrice: EtherAmount.inWei(gasPrice),
          maxGas: gasLimit.toInt(),
          nonce: nonce,
        ),
        chainId: null,
        fetchChainIdFromNetworkId: false);
    return result;
  }

  Future<BigInt> getBalanceOfLPToken({
    required String address,
    required String contractAddress,
  }) async {
    final contractAddr = EthereumAddress.fromHex(contractAddress);
    final abi = Get.find<SettingService>().abiLPToken;
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, 'KRC20 Token'), contractAddr);
    final balanceFunction = contract.function('balanceOf');
    final balance = await _client.call(
        contract: contract,
        function: balanceFunction,
        params: [EthereumAddress.fromHex(address)]);
    return balance.first as BigInt;
  }

  Future<CoinModel> getTokenModelLPInfo(
      {required String addressContract}) async {
    final contractAddr = EthereumAddress.fromHex(addressContract);

    final abi = Get.find<SettingService>().abiLPToken;
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, 'KRC20 Token'), contractAddr);
    final symbolFunction = contract.function('symbol');
    final decimalsFunction = contract.function('decimals');
    final nameFunction = contract.function('name');
    final symbol = await _client
        .call(contract: contract, function: symbolFunction, params: []);
    final decimals = await _client
        .call(contract: contract, function: decimalsFunction, params: []);
    final name = await _client
        .call(contract: contract, function: nameFunction, params: []);
    final coinModel = CoinModel.empty().copyWith(
        symbol: symbol.first.toString(),
        decimals: int.parse(decimals.first.toString()),
        name: name.first.toString(),
        contractAddress: addressContract,
        type: 'LP TOKEN');
    return coinModel;
  }

  Future<BigInt> getTokenTotalSupplyLPToken(
      {required String addressContract}) async {
    final contractAddr = EthereumAddress.fromHex(addressContract);
    final abi = Get.find<SettingService>().abiLPToken;
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, 'KRC20 Token'), contractAddr);
    final totalSupplyFunction = contract.function('totalSupply');
    final totalSupply = await _client
        .call(contract: contract, function: totalSupplyFunction, params: []);
    return totalSupply.first;
  }

  Future<BigInt> getGasLimitRemoveAddLiquidityKAI({
    required String token,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountTokenLP,
  }) async {
    final abiSwap = Get.find<SettingService>().abiSwapKRC20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final tokenContract = EthereumAddress.fromHex(token);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiSwap, 'KRC20 Token'), contractAbi);
    final addLiquidityFunction = contract.function('removeLiquidityKAI');
    final data = Transaction.callContract(
      from: senderAddr,
      contract: contract,
      function: addLiquidityFunction,
      parameters: [
        tokenContract,
        amountTokenLP,
        BigInt.from(1),
        BigInt.from(1),
        receiverAddr,
        BigInt.from(
            (DateTime.now().millisecondsSinceEpoch / 1000).round() + 20 * 60)
      ],
    ).data;
    final gasLimit = await _client.estimateGas(
      sender: senderAddr,
      to: contractAbi,
      data: data,
    );
    return gasLimit;
  }

  Future<String> removeAdddLiquidityKAI({
    required String token,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountTokenLP,
    required String privateKey,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final abiKRC20 = Get.find<SettingService>().abiSwapKRC20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final tokenContract = EthereumAddress.fromHex(token);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final nonce = await getTransactionCount(address: addressSender);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiKRC20, 'KRC20 Token'), contractAbi);
    final addLiquidityFunction = contract.function('removeLiquidityKAI');
    final result = await _client.sendTransaction(
        credentials,
        Transaction.callContract(
          from: senderAddr,
          contract: contract,
          function: addLiquidityFunction,
          parameters: [
            tokenContract,
            amountTokenLP,
            BigInt.from(1),
            BigInt.from(1),
            receiverAddr,
            BigInt.from((DateTime.now().millisecondsSinceEpoch / 1000).round() +
                20 * 60)
          ],
          gasPrice: EtherAmount.inWei(gasPrice),
          maxGas: gasLimit.toInt(),
          nonce: nonce,
        ),
        chainId: null,
        fetchChainIdFromNetworkId: false);
    return result;
  }

  Future<BigInt> getGasLimitRemoveAddLiquidityToken({
    required String tokenA,
    required String tokenB,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountTokenLP,
  }) async {
    final abiSwap = Get.find<SettingService>().abiSwapKRC20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final tokenAContract = EthereumAddress.fromHex(tokenA);
    final tokenBContract = EthereumAddress.fromHex(tokenB);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiSwap, 'KRC20 Token'), contractAbi);
    final addLiquidityFunction = contract.function('removeLiquidity');
    final data = Transaction.callContract(
      from: senderAddr,
      contract: contract,
      function: addLiquidityFunction,
      parameters: [
        tokenAContract,
        tokenBContract,
        amountTokenLP,
        BigInt.from(1),
        BigInt.from(1),
        receiverAddr,
        BigInt.from(
            (DateTime.now().millisecondsSinceEpoch / 1000).round() + 20 * 60)
      ],
    ).data;
    final gasLimit = await _client.estimateGas(
      sender: senderAddr,
      to: contractAbi,
      data: data,
    );
    return gasLimit;
  }

  Future<String> removeAddLiquidityToken({
    required String tokenA,
    required String tokenB,
    required String privateKey,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountTokenLP,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final abiKRC20 = Get.find<SettingService>().abiSwapKRC20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final tokenAContract = EthereumAddress.fromHex(tokenA);
    final tokenBContract = EthereumAddress.fromHex(tokenB);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final nonce = await getTransactionCount(address: addressSender);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiKRC20, 'KRC20 Token'), contractAbi);
    final addLiquidityFunction = contract.function('removeLiquidity');
    final result = await _client.sendTransaction(
        credentials,
        Transaction.callContract(
          from: senderAddr,
          contract: contract,
          function: addLiquidityFunction,
          parameters: [
            tokenAContract,
            tokenBContract,
            amountTokenLP,
            BigInt.from(1),
            BigInt.from(1),
            receiverAddr,
            BigInt.from((DateTime.now().millisecondsSinceEpoch / 1000).round() +
                20 * 60)
          ],
          gasPrice: EtherAmount.inWei(gasPrice),
          maxGas: gasLimit.toInt(),
          nonce: nonce,
        ),
        chainId: null,
        fetchChainIdFromNetworkId: false);
    return result;
  }

  Future<String> createNewTokenKRC20({
    required String name,
    required String symbol,
    required BigInt totalSuply,
    required String addressContract,
    required String addressSender,
    required String privateKey,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final contractAddr = EthereumAddress.fromHex(addressContract);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final abiNewTokenBSC = Get.find<SettingService>().abiNewTokenBSC;
    final contract = DeployedContract(
        ContractAbi.fromJson(abiNewTokenBSC, 'Create Token KAI'), contractAddr);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final createFunction = contract.function('create');
    final total = totalSuply * BigInt.from(pow(10, 18));
    final transaction = await _client.sendTransaction(
        credentials,
        Transaction.callContract(
            from: senderAddr,
            contract: contract,
            function: createFunction,
            parameters: [name, symbol, total],
            gasPrice: EtherAmount.inWei(gasPrice),
            maxGas: gasLimit.toInt()),
        chainId: null,
        fetchChainIdFromNetworkId: false);
    if (transaction.isNotEmpty) {
      return transaction;
    } else {
      throw 'Create Token failure';
    }
  }

  Future<BigInt> getGasLimitToCreateTokenKRC20({
    required String name,
    required String symbol,
    required BigInt totalSuply,
    required String addressContract,
    required String addressSender,
  }) async {
    try {
      final contractAddr = EthereumAddress.fromHex(addressContract);
      final senderAddr = EthereumAddress.fromHex(addressSender);
      final abiNewTokenBSC = Get.find<SettingService>().abiNewTokenBSC;
      final contract = DeployedContract(
          ContractAbi.fromJson(abiNewTokenBSC, 'abiNewTokenKAI'), contractAddr);
      final createFunction = contract.function('create');

      final data = Transaction.callContract(
        contract: contract,
        function: createFunction,
        from: senderAddr,
        parameters: [name, symbol, totalSuply * BigInt.from(pow(10, 18))],
      ).data;

      final gasLimit = await _client.estimateGas(
        sender: senderAddr,
        to: contractAddr,
        data: data,
      );
      return gasLimit;
    } catch (exp) {
      throw 'Calculator fee failure';
    }
  }

  Future<String> callCreateTokenKRC20({
    required String name,
    required String symbol,
    required BigInt totalSuply,
    required String addressContract,
    required String addressSender,
  }) async {
    try {
      final contractAddr = EthereumAddress.fromHex(addressContract);
      final senderAddr = EthereumAddress.fromHex(addressSender);
      final abiNewTokenBSC = Get.find<SettingService>().abiNewTokenBSC;
      final contract = DeployedContract(
          ContractAbi.fromJson(abiNewTokenBSC, 'abiNewTokenKAI'), contractAddr);
      final createFunction = contract.function('create');
      final result = await _client.call(
          sender: senderAddr,
          contract: contract,
          function: createFunction,
          params: [name, symbol, totalSuply * BigInt.from(pow(10, 18))]);
      return result.first.toString();
    } catch (exp) {
      throw 'Call Create Token Failure';
    }
  }
}

enum EnumKardiaChainMethod {
  account_nonce,
  account_balance,
  kai_gasPrice,
  tx_sendRawTransaction,
  kai_blockNumber,
  kai_getBlockByNumber,
  tx_getTransaction,
  tx_getTransactionReceipt
}

enum EnumKardiaChainDefaultBlock {
  earliest,
  latest,
  pending,
  undefined,
}
