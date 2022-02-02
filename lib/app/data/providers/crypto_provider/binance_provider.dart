import 'dart:math';

import 'package:base_source/app/core/utils/format_utils.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/services/setting_services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class BinanceSmartProvider extends GetConnect {
  static const String contractCreateTokenAbi =
      '0xfacD650D7577b38cF1f6067a21D2b4040B9b4E8e';

  /// PancakeSwap: V2 Router
  static const String contractSwapAbi =
      '0x10ed43c718714eb63d5aa57b78b54704e256024e';

  /// PancakeSwap: V2 Factory
  static const String contractFactory =
      '0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73';

  static const String contractLaunchPad =
      '0x05EFCe7985a3dd292aEEEe95c819dE2fc9BCf8fB';

  static const String contractWrapBNB =
      '0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c';
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  late String _httpUrl;
  late String _wssUrl;
  late String _apiUrl;
  late Web3Client _client;

  void initData(BlockChainModel blockChain) {
    _httpUrl = blockChain.nodeHttp;
    _wssUrl = blockChain.nodeWss;
    _apiUrl = blockChain.api;
    _client = Web3Client(_httpUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wssUrl).cast<String>();
    });
  }

  Future<dynamic> postApi({
    required EnumBinanceSmartMethod method,
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
    // print('\n---------------------Binance Smart Provider---------------------');
    // print('body: $data');
    // print('response.statusCode: ${response.statusCode}');
    // print('response.body: ${response.body}');
    if (response.statusCode == 200 && response.body['error'] == null) {
      return response.body['result'];
    } else {
      throw response.body['error'] ?? 'Binance Smart Chain RPC failure';
    }
  }

  Future<List<dynamic>> getApi({
    required dynamic query,
  }) async {
    final response = await httpClient.get(
      _apiUrl,
      query: query,
      headers: _headers,
    );
    // print('\n---------------------Binance Smart Provider---------------------');
    // print('query: $query');
    // print('response.statusCode: ${response.statusCode}');
    // print('response.body: ${response.body}');
    if (response.statusCode == 200 && response.body['result'] != null) {
      return response.body['result'] as List<dynamic>;
    } else {
      throw response.body['error'] ?? 'Get information failure';
    }
  }

  Future<String> getChainId() async {
    try {
      final result = await postApi(
        method: EnumBinanceSmartMethod.eth_chainId,
        params: [],
      );
      return AppFormat.dropHexString(hexString: result);
    } catch (exp) {
      throw 'Get chainId failure';
    }
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
          ContractAbi.fromJson(abiBEP20, 'BEP20 Token'), contractAddr);
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

  Future<BigInt> getGasLimitApprove({
    required String addressContract,
    required String addrsassSender,
    required String addressOwner,
    required BigInt amount,
  }) async {
    try {
      final abiBEP20 = Get.find<SettingService>().abiERC20BEP20;
      final contractAddr = EthereumAddress.fromHex(addressContract);
      final senderAddr = EthereumAddress.fromHex(addrsassSender);
      final ownerAddr = EthereumAddress.fromHex(addressOwner);
      final contract = DeployedContract(
          ContractAbi.fromJson(abiBEP20, 'BEP20 Token'), contractAddr);
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

  Future<BigInt> getGasLimitToCreateTokenBEP20({
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
          ContractAbi.fromJson(abiNewTokenBSC, 'abiNewTokenBSC'), contractAddr);
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

  Future<BigInt> getGasPrice() async {
    try {
      final result = await postApi(
        method: EnumBinanceSmartMethod.eth_gasPrice,
        params: [],
      );
      final hexString = AppFormat.dropHexString(hexString: result);
      return BigInt.parse(hexString, radix: 16);
    } catch (exp) {
      throw 'Calculator fee failure';
    }
  }

  Future<BigInt> getBalance({required String address}) async {
    final result = await postApi(
        method: EnumBinanceSmartMethod.eth_getBalance,
        params: [
          address,
          EnumBinanceDefaultBlock.latest.toString().split('.')[1]
        ]) as String;
    return BigInt.parse(result == '0x0' ? '0' : result.substring(2), radix: 16);
  }

  Future<BigInt> getBalanceOfBEP20({
    required String address,
    required String contractAddress,
  }) async {
    final contractAddr = EthereumAddress.fromHex(contractAddress);
    final abiERC20 = Get.find<SettingService>().abiERC20BEP20;

    final contract = DeployedContract(
        ContractAbi.fromJson(abiERC20, 'BEP20 Token'), contractAddr);
    final balanceFunction = contract.function('balanceOf');
    final balance = await _client.call(
        contract: contract,
        function: balanceFunction,
        params: [EthereumAddress.fromHex(address)]);

    return balance.first as BigInt;
  }

  Future<String> getTransactionCount({required String address}) async {
    final result = await postApi(
      method: EnumBinanceSmartMethod.eth_getTransactionCount,
      params: [
        address,
        EnumBinanceDefaultBlock.pending.toString().split('.')[1]
      ],
    );
    return AppFormat.dropHexString(hexString: result);
  }

  Future<String> sendTransaction({required String data}) async {
    final result = await postApi(
        method: EnumBinanceSmartMethod.eth_sendRawTransaction, params: [data]);
    return result;
  }

  Future<String> sendTransactionBEP20({
    required String addressContract,
    required String addrsassRecieve,
    required String privateKey,
    required BigInt amount,
    required String addressSender,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final abiBEP20 = Get.find<SettingService>().abiERC20BEP20;
    final contractAddr = EthereumAddress.fromHex(addressContract);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final senderAddre = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final chainIdHexString = await getChainId();
    final chainId = int.parse(chainIdHexString, radix: 16);
    final nonce = await getTransactionCount(address: addressSender);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiBEP20, 'BEP20 Token'), contractAddr);
    final sendFunction = contract.function('transfer');
    final result = await _client.sendTransaction(
      credentials,
      Transaction.callContract(
          from: senderAddre,
          contract: contract,
          function: sendFunction,
          parameters: [receiverAddr, amount],
          gasPrice: EtherAmount.inWei(gasPrice),
          maxGas: gasLimit.toInt(),
          nonce: int.parse(nonce, radix: 16)),
      chainId: chainId,
    );
    return result;
  }

  Future<List<dynamic>> getTransactionsOfBEP20(
      {required String address}) async {
    final query = {
      'module': 'account',
      'action': 'tokentx',
      'address': address,
      'startblock': '0',
      'endblock': EnumBinanceDefaultBlock.latest.toString().split('.')[1],
      'page': '1',
      'offset': '25',
      'sort': 'desc',
      'apikey': '7YRASAZA4FBB5UAYPDK2PJ6N8DMTG3KBIY',
    };
    final data = await getApi(query: query);
    return data;
  }

  Future<List<dynamic>> getTransactions({
    required String address,
    int? offset,
    int? startblock,
    int? endblock,
  }) async {
    try {
      final query = {
        'module': 'account',
        'action': 'txlist',
        'address': address,
        'startblock': '${startblock ?? 0}',
        'endblock': endblock == null
            ? EnumBinanceDefaultBlock.latest.toString().split('.')[1]
            : '$endblock',
        'page': '1',
        'offset': '${offset ?? 25}',
        'sort': 'desc',
        'apikey': 'NE4DSMRWBYW22AAF1B9K5WH7558UKJR6KH',
      };
      final data = await getApi(query: query);
      return data;
    } catch (exp) {
      throw 'Get transactions list failure';
    }
  }

  Future<BigInt> getAllowance({
    required String addressOwner,
    required String addressSender,
    required String contractAddress,
  }) async {
    final contractAddr = EthereumAddress.fromHex(contractAddress);
    final abiERC20 = Get.find<SettingService>().abiERC20BEP20;
    final contract = DeployedContract(
        ContractAbi.fromJson(abiERC20, 'BEP20 Token'), contractAddr);
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

  Future<CoinModel> getTokenModelBEP20Info(
      {required String addressContract}) async {
    final contractAddr = EthereumAddress.fromHex(addressContract);
    final abiERC20 = Get.find<SettingService>().abiERC20BEP20;
    final contract = DeployedContract(
        ContractAbi.fromJson(abiERC20, 'BEP20 Token'), contractAddr);
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
        type: 'Token Binance Smart Chain');
    return coinModel;
  }

  Future<String> createNewTokenBEP20({
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
        ContractAbi.fromJson(abiNewTokenBSC, 'Create Token BSC'), contractAddr);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final chainIdHexString = await getChainId();
    final chainId = int.parse(chainIdHexString, radix: 16);
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
      chainId: chainId,
    );

    if (transaction.isNotEmpty) {
      return transaction;
    } else {
      throw 'Create Token failure';
    }
  }

  Future<List<dynamic>> getTransactionInternal(String hash) async {
    try {
      final query = {
        'module': 'account',
        'action': 'txlistinternal',
        'txhash': hash,
        'apikey': 'T54JMTC45FS6H1G9W3DTDTUDTF4RP85YKN',
      };
      final data = await getApi(query: query);
      return data;
    } catch (exp) {
      throw 'Get transaction information failure';
    }
  }

  Future<int> getCurrentBlock() async {
    try {
      final blockNumber = await _client.getBlockNumber();
      return blockNumber;
    } catch (exp) {
      throw 'Get current block failure';
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
    final abiBEP20 = Get.find<SettingService>().abiERC20BEP20;
    final contractAddr = EthereumAddress.fromHex(addressContract);
    final senderAddr = EthereumAddress.fromHex(senderAddress);
    final ownderAddr = EthereumAddress.fromHex(ownerAddress);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final chainIdHexString = await getChainId();
    final chainId = int.parse(chainIdHexString, radix: 16);
    final nonce = await getTransactionCount(address: ownerAddress);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiBEP20, 'BEP20 Token'), contractAddr);
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
          nonce: int.parse(nonce, radix: 16)),
      chainId: chainId,
    );
    return result;
  }

  Future<Map<String, dynamic>?> getTransactionInformation(
      {required String hash}) async {
    final result = await postApi(
        method: EnumBinanceSmartMethod.eth_getTransactionByHash,
        params: [hash]);
    return result;
  }

  Future<Map<String, dynamic>?> getTransactionReceiptByHash(String hash) async {
    final result = await postApi(
        method: EnumBinanceSmartMethod.eth_getTransactionReceipt,
        params: [hash]);
    return result;
  }

  Future<String> swapExactBNBForTokensSupportingFeeOnTransferTokens({
    required String tokenContractTo,
    required String privateKey,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amount,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final abiBEP20 = Get.find<SettingService>().abiSwapERC20BEP20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final wrapBNBContract = EthereumAddress.fromHex(contractWrapBNB);
    final tokenContract = EthereumAddress.fromHex(tokenContractTo);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final nonce = await getTransactionCount(address: addressSender);
    final chainIdHexString = await getChainId();
    final chainId = int.parse(chainIdHexString, radix: 16);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiBEP20, 'BEP20 Token'), contractAbi);
    final swapFunction =
        contract.function('swapExactETHForTokensSupportingFeeOnTransferTokens');
    final result = await _client.sendTransaction(
      credentials,
      Transaction.callContract(
          from: senderAddr,
          contract: contract,
          function: swapFunction,
          value: EtherAmount.inWei(amount),
          parameters: [
            BigInt.from(0),
            [wrapBNBContract, tokenContract],
            receiverAddr,
            BigInt.from((DateTime.now().millisecondsSinceEpoch / 1000).round() +
                20 * 60)
          ],
          gasPrice: EtherAmount.inWei(gasPrice),
          maxGas: gasLimit.toInt(),
          nonce: int.parse(nonce, radix: 16)),
      chainId: chainId,
    );
    return result;
  }

  Future<BigInt> getGasLimitToSwapExactBNBForTokens({
    required String tokenContractTo,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amount,
  }) async {
    final abiBEP20 = Get.find<SettingService>().abiSwapERC20BEP20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final wrapBNBContract = EthereumAddress.fromHex(contractWrapBNB);
    final tokenContract = EthereumAddress.fromHex(tokenContractTo);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiBEP20, 'BEP20 Token'), contractAbi);
    final swapFunction =
        contract.function('swapExactETHForTokensSupportingFeeOnTransferTokens');

    final data = Transaction.callContract(
      from: senderAddr,
      contract: contract,
      function: swapFunction,
      value: EtherAmount.inWei(amount),
      parameters: [
        BigInt.from(0),
        [wrapBNBContract, tokenContract],
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

  Future<String> swapExactTokensForBNBSupportingFeeOnTransferTokens({
    required String tokenContractFrom,
    required String privateKey,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amount,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final abiBEP20 = Get.find<SettingService>().abiSwapERC20BEP20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final wrapBNBContract = EthereumAddress.fromHex(contractWrapBNB);
    final tokenContract = EthereumAddress.fromHex(tokenContractFrom);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final nonce = await getTransactionCount(address: addressSender);
    final chainIdHexString = await getChainId();
    final chainId = int.parse(chainIdHexString, radix: 16);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiBEP20, 'BEP20 Token'), contractAbi);
    final swapFunction =
        contract.function('swapExactTokensForETHSupportingFeeOnTransferTokens');
    final result = await _client.sendTransaction(
      credentials,
      Transaction.callContract(
          from: senderAddr,
          contract: contract,
          function: swapFunction,
          parameters: [
            amount,
            BigInt.from(0),
            [tokenContract, wrapBNBContract],
            receiverAddr,
            BigInt.from((DateTime.now().millisecondsSinceEpoch / 1000).round() +
                20 * 60)
          ],
          gasPrice: EtherAmount.inWei(gasPrice),
          maxGas: gasLimit.toInt(),
          nonce: int.parse(nonce, radix: 16)),
      chainId: chainId,
    );
    return result;
  }

  Future<BigInt> getGasLimitSwapExactTokensForBNB({
    required String tokenContractFrom,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amount,
  }) async {
    final abiBEP20 = Get.find<SettingService>().abiSwapERC20BEP20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final wrapBNBContract = EthereumAddress.fromHex(contractWrapBNB);
    final tokenContract = EthereumAddress.fromHex(tokenContractFrom);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiBEP20, 'BEP20 Token'), contractAbi);
    final swapFunction =
        contract.function('swapExactTokensForETHSupportingFeeOnTransferTokens');

    final data = Transaction.callContract(
      from: senderAddr,
      contract: contract,
      function: swapFunction,
      parameters: [
        amount,
        BigInt.from(0),
        [tokenContract, wrapBNBContract],
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
    final abiBEP20 = Get.find<SettingService>().abiSwapERC20BEP20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final wrapBNBContract = EthereumAddress.fromHex(contractWrapBNB);
    final tokenFrom = EthereumAddress.fromHex(tokenContractFrom);
    final tokenSwap = EthereumAddress.fromHex(tokenContractTo);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final nonce = await getTransactionCount(address: addressSender);
    final chainIdHexString = await getChainId();
    final chainId = int.parse(chainIdHexString, radix: 16);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiBEP20, 'BEP20 Token'), contractAbi);
    final swapFunction = contract
        .function('swapExactTokensForTokensSupportingFeeOnTransferTokens');
    final path = [];
    if (tokenContractTo.toLowerCase() == contractWrapBNB.toLowerCase() ||
        tokenContractFrom.toLowerCase() == contractWrapBNB.toLowerCase()) {
      path..add(tokenFrom)..add(tokenSwap);
    } else {
      path..add(tokenFrom)..add(wrapBNBContract)..add(tokenSwap);
    }
    final result = await _client.sendTransaction(
      credentials,
      Transaction.callContract(
          from: senderAddr,
          contract: contract,
          function: swapFunction,
          parameters: [
            amount,
            BigInt.from(0),
            path,
            receiverAddr,
            BigInt.from((DateTime.now().millisecondsSinceEpoch / 1000).round() +
                20 * 60)
          ],
          gasPrice: EtherAmount.inWei(gasPrice),
          maxGas: gasLimit.toInt(),
          nonce: int.parse(nonce, radix: 16)),
      chainId: chainId,
    );
    return result;
  }

  Future<BigInt> getGasLimitSwapExactTokensForTokens({
    required String tokenContractFrom,
    required String tokenContractTo,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amount,
  }) async {
    final abiBEP20 = Get.find<SettingService>().abiSwapERC20BEP20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final wrapBNBContract = EthereumAddress.fromHex(contractWrapBNB);
    final tokenFrom = EthereumAddress.fromHex(tokenContractFrom);
    final tokenSwap = EthereumAddress.fromHex(tokenContractTo);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiBEP20, 'BEP20 Token'), contractAbi);
    final swapFunction = contract
        .function('swapExactTokensForTokensSupportingFeeOnTransferTokens');
    final path = [];
    if (tokenContractTo.toLowerCase() == contractWrapBNB.toLowerCase() ||
        tokenContractFrom.toLowerCase() == contractWrapBNB.toLowerCase()) {
      path..add(tokenFrom)..add(tokenSwap);
    } else {
      path..add(tokenFrom)..add(wrapBNBContract)..add(tokenSwap);
    }
    final data = Transaction.callContract(
      from: senderAddr,
      contract: contract,
      function: swapFunction,
      parameters: [
        amount,
        BigInt.from(0),
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
      final abi = Get.find<SettingService>().abiSwapERC20BEP20;
      final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
      final tokenFrom = tokenContractFrom.isNotEmpty
          ? EthereumAddress.fromHex(tokenContractFrom)
          : EthereumAddress.fromHex(contractWrapBNB);
      final tokenTo = tokenContractTo.isNotEmpty
          ? EthereumAddress.fromHex(tokenContractTo)
          : EthereumAddress.fromHex(contractWrapBNB);
      final contract = DeployedContract(
          ContractAbi.fromJson(abi, 'KRC20 Token'), contractAbi);
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
      rethrow;
    }
  }

  Future<String> getPairFactory({
    required String tokenFrom,
    required String tokenTo,
  }) async {
    final abi = Get.find<SettingService>().abiFactory;
    final contractAddr = EthereumAddress.fromHex(contractFactory);
    final contractFrom = EthereumAddress.fromHex(
        tokenFrom.isEmpty ? contractWrapBNB : tokenFrom);
    final contractTo = EthereumAddress.fromHex(
      tokenTo.isEmpty ? contractWrapBNB : tokenTo,
    );
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, 'BEP20 Token'), contractAddr);
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
        DeployedContract(ContractAbi.fromJson(abi, 'BEP20 Token'), contractLP);
    final getReservesFunction = contract.function('getReserves');
    final result = await _client
        .call(contract: contract, function: getReservesFunction, params: []);
    return result;
  }

  Future<String> getLpTokenA({required String tokenLP}) async {
    final abi = Get.find<SettingService>().abiLPToken;
    final contractLP = EthereumAddress.fromHex(tokenLP);
    final contract =
        DeployedContract(ContractAbi.fromJson(abi, 'BEP20 Token'), contractLP);
    final getToken0Function = contract.function('token0');
    final result = await _client
        .call(contract: contract, function: getToken0Function, params: []);
    return result.first.toString();
  }

  Future<BigInt> getGasLimitAddLiquidityBNB({
    required String token,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountToken,
    required BigInt amountCoin,
  }) async {
    final abiSwap = Get.find<SettingService>().abiSwapERC20BEP20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final tokenContract = EthereumAddress.fromHex(token);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiSwap, 'BEP20 Token'), contractAbi);
    final addLiquidityFunction = contract.function('addLiquidityETH');
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
      to: contractAbi,
      value: EtherAmount.inWei(amountCoin),
      data: data,
    );

    return gasLimit;
  }

  Future<String> addLiquidityBNB({
    required String token,
    required String privateKey,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountToken,
    required BigInt amountCoin,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final abiKRC20 = Get.find<SettingService>().abiSwapERC20BEP20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final tokenContract = EthereumAddress.fromHex(token);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final nonce = await getTransactionCount(address: addressSender);
    final chainIdHexString = await getChainId();
    final chainId = int.parse(chainIdHexString, radix: 16);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiKRC20, 'BEP20 Token'), contractAbi);
    final addLiquidityFunction = contract.function('addLiquidityETH');
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
          BigInt.from(
              (DateTime.now().millisecondsSinceEpoch / 1000).round() + 20 * 60)
        ],
        gasPrice: EtherAmount.inWei(gasPrice),
        maxGas: gasLimit.toInt(),
        nonce: int.parse(nonce, radix: 16),
      ),
      chainId: chainId,
    );
    return result;
  }

  Future<BigInt> getGasLimitAddLiquidityToken({
    required String tokenA,
    required String tokenB,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountTokenA,
    required BigInt amountTokenB,
  }) async {
    final abiSwap = Get.find<SettingService>().abiSwapERC20BEP20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final tokenAContract = EthereumAddress.fromHex(tokenA);
    final tokenBContract = EthereumAddress.fromHex(tokenB);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiSwap, 'BEP20 Token'), contractAbi);
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
    final abi = Get.find<SettingService>().abiSwapERC20BEP20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final tokenAContract = EthereumAddress.fromHex(tokenA);
    final tokenBContract = EthereumAddress.fromHex(tokenB);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final nonce = await getTransactionCount(address: addressSender);
    final chainIdHexString = await getChainId();
    final chainId = int.parse(chainIdHexString, radix: 16);
    final contract =
        DeployedContract(ContractAbi.fromJson(abi, 'BEP20 Token'), contractAbi);
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
          BigInt.from(
              (DateTime.now().millisecondsSinceEpoch / 1000).round() + 20 * 60)
        ],
        gasPrice: EtherAmount.inWei(gasPrice),
        maxGas: gasLimit.toInt(),
        nonce: int.parse(nonce, radix: 16),
      ),
      chainId: chainId,
    );
    return result;
  }

  Future<BigInt> getBalanceOfLPToken({
    required String address,
    required String contractAddress,
  }) async {
    final contractAddr = EthereumAddress.fromHex(contractAddress);
    final abi = Get.find<SettingService>().abiLPToken;
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, 'BEP20 Token'), contractAddr);
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
        ContractAbi.fromJson(abi, 'BEP20 Token'), contractAddr);
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

  Future<BigInt> getGasLimitRemoveAddLiquidityBNB({
    required String token,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountTokenLP,
  }) async {
    final abiSwap = Get.find<SettingService>().abiSwapERC20BEP20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final tokenContract = EthereumAddress.fromHex(token);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiSwap, 'BEP20 Token'), contractAbi);
    final addLiquidityFunction = contract.function('removeLiquidityETH');
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

  Future<String> removeAdddLiquidityBNB({
    required String token,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountTokenLP,
    required String privateKey,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final abiKRC20 = Get.find<SettingService>().abiSwapERC20BEP20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final tokenContract = EthereumAddress.fromHex(token);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final nonce = await getTransactionCount(address: addressSender);
    final chainIdHexString = await getChainId();
    final chainId = int.parse(chainIdHexString, radix: 16);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiKRC20, 'BEP20 Token'), contractAbi);
    final addLiquidityFunction = contract.function('removeLiquidityETH');
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
          BigInt.from(
              (DateTime.now().millisecondsSinceEpoch / 1000).round() + 20 * 60)
        ],
        gasPrice: EtherAmount.inWei(gasPrice),
        maxGas: gasLimit.toInt(),
        nonce: int.parse(nonce, radix: 16),
      ),
      chainId: chainId,
    );
    return result;
  }

  Future<BigInt> getGasLimitRemoveAddLiquidityToken({
    required String tokenA,
    required String tokenB,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amountTokenLP,
  }) async {
    final abiSwap = Get.find<SettingService>().abiSwapERC20BEP20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final tokenAContract = EthereumAddress.fromHex(tokenA);
    final tokenBContract = EthereumAddress.fromHex(tokenB);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiSwap, 'BEP20 Token'), contractAbi);
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
    final abi = Get.find<SettingService>().abiSwapERC20BEP20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final tokenAContract = EthereumAddress.fromHex(tokenA);
    final tokenBContract = EthereumAddress.fromHex(tokenB);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final nonce = await getTransactionCount(address: addressSender);
    final chainIdHexString = await getChainId();
    final chainId = int.parse(chainIdHexString, radix: 16);
    final contract =
        DeployedContract(ContractAbi.fromJson(abi, 'BEP20 Token'), contractAbi);
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
          BigInt.from(
              (DateTime.now().millisecondsSinceEpoch / 1000).round() + 20 * 60)
        ],
        gasPrice: EtherAmount.inWei(gasPrice),
        maxGas: gasLimit.toInt(),
        nonce: int.parse(nonce, radix: 16),
      ),
      chainId: chainId,
    );
    return result;
  }

  Future<BigInt> getTokenTotalSupplyLPToken(
      {required String addressContract}) async {
    final contractAddr = EthereumAddress.fromHex(addressContract);
    final abi = Get.find<SettingService>().abiLPToken;
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, 'BEP20 Token'), contractAddr);
    final totalSupplyFunction = contract.function('totalSupply');
    final totalSupply = await _client
        .call(contract: contract, function: totalSupplyFunction, params: []);
    return totalSupply.first;
  }

  Future<BigInt> getGasLimitToDepositLaunchPadIDO({
    required String addressSender,
    required BigInt amount,
    required BigInt index,
  }) async {
    try {
      final abi = Get.find<SettingService>().abiLaunchPad;
      final contractAddr = EthereumAddress.fromHex(contractLaunchPad);
      final senderAddr = EthereumAddress.fromHex(addressSender);
      final contract = DeployedContract(
          ContractAbi.fromJson(abi, 'BEP20 Token'), contractAddr);
      final depositFunction = contract.function('deposit');
      final data = Transaction.callContract(
              from: senderAddr,
              contract: contract,
              function: depositFunction,
              parameters: [index, amount],
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

  Future<String> depositTransactionLaunchPadIDO({
    required String addressSender,
    required String privateKey,
    required BigInt amount,
    required BigInt index,
    required BigInt gasPrice,
    required BigInt gasLimit,
  }) async {
    final abi = Get.find<SettingService>().abiLaunchPad;
    final contractAddr = EthereumAddress.fromHex(contractLaunchPad);
    final senderAddress = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final chainIdHexString = await getChainId();
    final chainId = int.parse(chainIdHexString, radix: 16);
    final nonce = await getTransactionCount(address: addressSender);
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, 'BEP20 Token'), contractAddr);
    final depositFunction = contract.function('deposit');
    final result = await _client.sendTransaction(
      credentials,
      Transaction.callContract(
          from: senderAddress,
          contract: contract,
          function: depositFunction,
          parameters: [index, amount],
          gasPrice: EtherAmount.inWei(gasPrice),
          maxGas: gasLimit.toInt(),
          nonce: int.parse(nonce, radix: 16)),
      chainId: chainId,
    );
    return result;
  }

  Future<BigInt> getGasLimitToUserClaimLaunchPadIDO({
    required String addressSender,
    required BigInt index,
  }) async {
    try {
      final abi = Get.find<SettingService>().abiLaunchPad;
      final contractAddr = EthereumAddress.fromHex(contractLaunchPad);
      final senderAddr = EthereumAddress.fromHex(addressSender);
      final contract = DeployedContract(
          ContractAbi.fromJson(abi, 'BEP20 Token'), contractAddr);
      final userClaimTokenFunction = contract.function('userClaimToken');
      final data = Transaction.callContract(
              from: senderAddr,
              contract: contract,
              function: userClaimTokenFunction,
              parameters: [index],
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

  Future<String> userClaimTokenTransactionLaunchPadIDO({
    required String addressSender,
    required String privateKey,
    required BigInt index,
    required BigInt gasPrice,
    required BigInt gasLimit,
  }) async {
    final abi = Get.find<SettingService>().abiLaunchPad;
    final contractAddr = EthereumAddress.fromHex(contractLaunchPad);
    final senderAddress = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final chainIdHexString = await getChainId();
    final chainId = int.parse(chainIdHexString, radix: 16);
    final nonce = await getTransactionCount(address: addressSender);
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, 'BEP20 Token'), contractAddr);
    final userClaimTokenFunction = contract.function('userClaimToken');
    final result = await _client.sendTransaction(
      credentials,
      Transaction.callContract(
          from: senderAddress,
          contract: contract,
          function: userClaimTokenFunction,
          parameters: [index],
          gasPrice: EtherAmount.inWei(gasPrice),
          maxGas: gasLimit.toInt(),
          nonce: int.parse(nonce, radix: 16)),
      chainId: chainId,
    );
    return result;
  }

  Future<List<dynamic>> getIDOInfo({
    required BigInt index,
  }) async {
    try {
      final abi = Get.find<SettingService>().abiLaunchPad;
      final contractAddr = EthereumAddress.fromHex(contractLaunchPad);
      final contract = DeployedContract(
          ContractAbi.fromJson(abi, 'BEP20 Token'), contractAddr);
      final idoInfoFunction = contract.function('idoInfo');
      final result = await _client
          .call(contract: contract, function: idoInfoFunction, params: [
        [index]
      ]);
      return result;
    } catch (exp) {
      throw 'Get IDO Info Error';
    }
  }

  Future<bool> getIsClaimed({
    required String addressSender,
    required BigInt index,
  }) async {
    try {
      final abi = Get.find<SettingService>().abiLaunchPad;
      final contractAddr = EthereumAddress.fromHex(contractLaunchPad);
      final senderAddr = EthereumAddress.fromHex(addressSender);
      final contract = DeployedContract(
          ContractAbi.fromJson(abi, 'BEP20 Token'), contractAddr);
      final isClaimedFunction = contract.function('isClaimed');
      final result = await _client
          .call(contract: contract, function: isClaimedFunction, params: [
        [index, senderAddr]
      ]);
      return result.first;
    } catch (exp) {
      throw 'Check IsClaimed Error';
    }
  }

  Future<BigInt> getAmountDepositedLaunchPadIDO({
    required String addressSender,
    required BigInt index,
  }) async {
    try {
      final abi = Get.find<SettingService>().abiLaunchPad;
      final contractAddr = EthereumAddress.fromHex(contractLaunchPad);
      final senderAddr = EthereumAddress.fromHex(addressSender);
      final contract = DeployedContract(
          ContractAbi.fromJson(abi, 'BEP20 Token'), contractAddr);
      final amountDepositedFunction = contract.function('amountDeposited');
      final result = await _client
          .call(contract: contract, function: amountDepositedFunction, params: [
        [index, senderAddr]
      ]);
      return result.first;
    } catch (exp) {
      throw 'Get Amount Desposited Error';
    }
  }

  Future<String> callCreateTokenBEP20({
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
          ContractAbi.fromJson(abiNewTokenBSC, 'abiNewTokenBSC'), contractAddr);
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

  // Future<int> getCurrencyBlock() async {
  //   final String result = await postApi(
  //       method: EnumBinanceSmartMethod.eth_blockNumber, params: []);
  //   return int.parse(result.substring(2), radix: 16);
  // }

  // Future<Map<String, dynamic>> getTransactionsLatest(String address) async {
  //   final currenctNumber = await getCurrencyBlock();
  //   var txLatest = <String, dynamic>{};
  //   var isBreak = false;
  //   for (var i = currenctNumber; i >= currenctNumber - 100; i--) {
  //     final result = await postApi(
  //         method: EnumBinanceSmartMethod.eth_getBlockByNumber,
  //         params: ['0x' + i.toRadixString(16), true]);
  //     for (var tx in result['transactions']) {
  //       final input = tx['input'];
  //       final data = TrustWalletCorePlugin.decodeTransfer(data: input);
  //       if (data != null) {
  //         if (data['recipient'].toLowerCase() == address.toLowerCase()) {
  //           txLatest = tx;
  //           isBreak = true;
  //           break;
  //         }
  //       }
  //       if ((tx['from']).toLowerCase() == address.toLowerCase() ||
  //           (tx['to'] ?? '').toLowerCase() == address.toLowerCase()) {
  //         txLatest = tx;
  //         isBreak = true;
  //         break;
  //       }
  //     }
  //     if (isBreak) {
  //       break;
  //     }
  //   }
  //   return txLatest;
  // }
}

enum EnumBinanceSmartMethod {
  eth_getTransactionCount,
  eth_chainId,
  eth_gasPrice,
  eth_sendRawTransaction,
  eth_getBalance,
  eth_getTransactionByHash,
  eth_getTransactionReceipt,
  eth_blockNumber,
  eth_getBlockByNumber
}

enum EnumBinanceDefaultBlock {
  earliest,
  latest,
  pending,
  undefined,
}
