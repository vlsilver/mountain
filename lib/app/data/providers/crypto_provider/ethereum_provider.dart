import 'package:base_source/app/core/utils/format_utils.dart';
import 'package:base_source/app/data/models/local_model/blockchain_model.dart';
import 'package:base_source/app/data/models/local_model/coin_model.dart';
import 'package:base_source/app/data/services/setting_services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web3dart/web3dart.dart';

class EthereumProvider extends GetConnect {
  ///Uniswap:Router V2
  static const String contractSwapAbi =
      '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D';

  ///Uniswap: Factory V2
  static const contractFactory = '0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f';
  static const String contractWrapETH =
      '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2';
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
    required EnumEthereumMethod method,
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
    // print('\n---------------------Ethereum Provider---------------------');
    // print('body: $data');
    // print('response.statusCode: ${response.statusCode}');
    // print('response.body: ${response.body}');
    if (response.statusCode == 200 && response.body['error'] == null) {
      return response.body['result'];
    } else {
      throw response.body['error'] ?? 'Ethereum RPC failure';
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
    // print('\n---------------------Ethereum Provider ---------------------');
    // print('query: $query');
    // print('response.statusCode: ${response.statusCode}');
    if (response.statusCode == 200 && response.body['result'] != null) {
      return response.body['result'];
    } else {
      throw 'Get information failure';
    }
  }

  Future<String> getTransactionCount({required String address}) async {
    try {
      final result = await postApi(
        method: EnumEthereumMethod.eth_getTransactionCount,
        params: [
          address,
          EnumEthereumDefaultBlock.latest.toString().split('.')[1]
        ],
      );
      return AppFormat.dropHexString(hexString: result);
    } catch (exp) {
      throw 'Get transaction count failure';
    }
  }

  Future<String> getChainId() async {
    try {
      final result = await postApi(
        method: EnumEthereumMethod.eth_chainId,
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
          ContractAbi.fromJson(abiBEP20, 'ERC20 Token'), contractAddr);
      final sendFunction = contract.function('transfer');

      final data = Transaction.callContract(
              from: senderAddr,
              contract: contract,
              function: sendFunction,
              parameters: [receiverAddr, BigInt.from(0)],
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

  Future<BigInt> getGasPrice() async {
    try {
      final result = await postApi(
        method: EnumEthereumMethod.eth_gasPrice,
        params: [],
      );
      final hexString = AppFormat.dropHexString(hexString: result);
      return BigInt.parse(hexString, radix: 16);
    } catch (exp) {
      throw 'Calculator fee failure';
    }
  }

  Future<String> sendTransaction({required String data}) async {
    final result = await postApi(
        method: EnumEthereumMethod.eth_sendRawTransaction, params: [data]);
    return result;
  }

  Future<BigInt> getBalance({required String address}) async {
    final result = await postApi(
        method: EnumEthereumMethod.eth_getBalance,
        params: [
          address,
          EnumEthereumDefaultBlock.latest.toString().split('.')[1]
        ]);
    return BigInt.parse(result == '0x0' ? '0' : result.substring(2), radix: 16);
  }

  Future<CoinModel> getTokenModelERC20Info(
      {required String addressContract}) async {
    final contractAddr = EthereumAddress.fromHex(addressContract);
    final abiERC20 = Get.find<SettingService>().abiERC20BEP20;
    final contract = DeployedContract(
        ContractAbi.fromJson(abiERC20, 'ERC20 Token'), contractAddr);
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
        type: 'Token Ethereum');
    return coinModel;
  }

  Future<String> sendTransactionERC20({
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
    final chainIdHexString = await getChainId();
    final chainId = int.parse(chainIdHexString, radix: 16);
    final nonce = await getTransactionCount(address: addressSender);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiERC20, 'ERC20 Token'), contractAddr);
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
            nonce: int.parse(nonce, radix: 16)),
        chainId: chainId);
    return result;
  }

  Future<BigInt> getBalanceOfERC20({
    required String address,
    required String contractAddress,
  }) async {
    final contractAddr = EthereumAddress.fromHex(contractAddress);
    final abiERC20 = Get.find<SettingService>().abiERC20BEP20;
    final contract = DeployedContract(
        ContractAbi.fromJson(abiERC20, 'ERC20 Token'), contractAddr);
    final balanceFunction = contract.function('balanceOf');

    final balance = await _client.call(
        contract: contract,
        function: balanceFunction,
        params: [EthereumAddress.fromHex(address)]);

    return balance.first as BigInt;
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
        'endblock': endblock == null ? 'latest' : '$endblock',
        'page': '1',
        'offset': '${offset ?? 25}',
        'sort': 'desc',
        'apikey': 'NWEC3M2BI6UGX968148PSW3ZFG939ZH3ZZ',
      };
      final data = await getApi(query: query);
      return data;
    } catch (exp) {
      throw 'Get transaction list failure';
    }
  }

  Future<List<dynamic>> getTransactionsOfERC20(
      {required String address}) async {
    try {
      final query = {
        'module': 'account',
        'action': 'tokentx',
        'address': address,
        'startblock': '0',
        'endblock': 'latest',
        'page': '1',
        'offset': '25',
        'sort': 'desc',
        'apikey': 'BMF55Q9BWSWW4ECN67QIUDUT6BC2JD6REE',
      };
      final data = await getApi(query: query);
      return data;
    } catch (exp) {
      throw 'Get transaction list failure';
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
          ContractAbi.fromJson(abiBEP20, 'ERC20 Token'), contractAddr);
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
    final abiBEP20 = Get.find<SettingService>().abiERC20BEP20;
    final contractAddr = EthereumAddress.fromHex(addressContract);
    final senderAddr = EthereumAddress.fromHex(senderAddress);
    final ownderAddr = EthereumAddress.fromHex(ownerAddress);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final chainIdHexString = await getChainId();
    final chainId = int.parse(chainIdHexString, radix: 16);
    final nonce = await getTransactionCount(address: ownerAddress);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiBEP20, 'ERC20 Token'), contractAddr);
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

  Future<int> getCurrentBlock() async {
    try {
      final blockNumber = await _client.getBlockNumber();
      return blockNumber;
    } catch (exp) {
      throw 'Get current block failure';
    }
  }

  Future<Map<String, dynamic>?> getTransactionInformation(
      {required String hash}) async {
    final result = await postApi(
        method: EnumEthereumMethod.eth_getTransactionByHash, params: [hash]);
    return result;
  }

  Future<Map<String, dynamic>?> getTransactionReceiptByHash(String hash) async {
    final result = await postApi(
        method: EnumEthereumMethod.eth_getTransactionReceipt, params: [hash]);
    return result;
  }

  Future<String> swapExactETHForTokensSupportingFeeOnTransferTokens({
    required String tokenContractTo,
    required String privateKey,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amount,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final abiERC20 = Get.find<SettingService>().abiSwapERC20BEP20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final wrapETHContract = EthereumAddress.fromHex(contractWrapETH);
    final tokenContract = EthereumAddress.fromHex(tokenContractTo);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final nonce = await getTransactionCount(address: addressSender);
    final chainIdHexString = await getChainId();
    final chainId = int.parse(chainIdHexString, radix: 16);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiERC20, 'ERC20 Token'), contractAbi);
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
            [wrapETHContract, tokenContract],
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

  Future<BigInt> getGasLimitToSwapExactETHForTokens({
    required String tokenContractTo,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amount,
  }) async {
    final abiERC20 = Get.find<SettingService>().abiSwapERC20BEP20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final wrapETHContract = EthereumAddress.fromHex(contractWrapETH);
    final tokenContract = EthereumAddress.fromHex(tokenContractTo);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiERC20, 'ERC20 Token'), contractAbi);
    final swapFunction =
        contract.function('swapExactETHForTokensSupportingFeeOnTransferTokens');

    final data = Transaction.callContract(
      from: senderAddr,
      contract: contract,
      function: swapFunction,
      value: EtherAmount.inWei(amount),
      parameters: [
        BigInt.from(0),
        [wrapETHContract, tokenContract],
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

  Future<String> swapExactTokensForETHSupportingFeeOnTransferTokens({
    required String tokenContractFrom,
    required String privateKey,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amount,
    required BigInt gasLimit,
    required BigInt gasPrice,
  }) async {
    final abiERC20 = Get.find<SettingService>().abiSwapERC20BEP20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final wrapETHContract = EthereumAddress.fromHex(contractWrapETH);
    final tokenContract = EthereumAddress.fromHex(tokenContractFrom);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final nonce = await getTransactionCount(address: addressSender);
    final chainIdHexString = await getChainId();
    final chainId = int.parse(chainIdHexString, radix: 16);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiERC20, 'ERC20 Token'), contractAbi);
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
            [tokenContract, wrapETHContract],
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

  Future<BigInt> getGasLimitSwapExactTokensForETH({
    required String tokenContractFrom,
    required String addressSender,
    required String addrsassRecieve,
    required BigInt amount,
  }) async {
    final abiERC20 = Get.find<SettingService>().abiSwapERC20BEP20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final wrapETHContract = EthereumAddress.fromHex(contractWrapETH);
    final tokenContract = EthereumAddress.fromHex(tokenContractFrom);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiERC20, 'ERC20 Token'), contractAbi);
    final swapFunction =
        contract.function('swapExactTokensForETHSupportingFeeOnTransferTokens');

    final data = Transaction.callContract(
      from: senderAddr,
      contract: contract,
      function: swapFunction,
      parameters: [
        amount,
        BigInt.from(0),
        [tokenContract, wrapETHContract],
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
    final abiERC20 = Get.find<SettingService>().abiSwapERC20BEP20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final wrapETHContract = EthereumAddress.fromHex(contractWrapETH);
    final tokenFrom = EthereumAddress.fromHex(tokenContractFrom);
    final tokenSwap = EthereumAddress.fromHex(tokenContractTo);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final credentials = await _client.credentialsFromPrivateKey(privateKey);
    final nonce = await getTransactionCount(address: addressSender);
    final chainIdHexString = await getChainId();
    final chainId = int.parse(chainIdHexString, radix: 16);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiERC20, 'ERC20 Token'), contractAbi);
    final swapFunction = contract
        .function('swapExactTokensForTokensSupportingFeeOnTransferTokens');

    final path = [];
    if (tokenContractTo.toLowerCase() == contractWrapETH.toLowerCase() ||
        tokenContractFrom.toLowerCase() == contractWrapETH.toLowerCase()) {
      path..add(tokenFrom)..add(tokenSwap);
    } else {
      path..add(tokenFrom)..add(wrapETHContract)..add(tokenSwap);
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
    final abiERC20 = Get.find<SettingService>().abiSwapERC20BEP20;
    final contractAbi = EthereumAddress.fromHex(contractSwapAbi);
    final wrapETHContract = EthereumAddress.fromHex(contractWrapETH);
    final tokenFrom = EthereumAddress.fromHex(tokenContractFrom);
    final tokenSwap = EthereumAddress.fromHex(tokenContractTo);
    final senderAddr = EthereumAddress.fromHex(addressSender);
    final receiverAddr = EthereumAddress.fromHex(addrsassRecieve);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiERC20, 'ERC20 Token'), contractAbi);
    final swapFunction = contract
        .function('swapExactTokensForTokensSupportingFeeOnTransferTokens');
    final path = [];
    if (tokenContractTo.toLowerCase() == contractWrapETH.toLowerCase() ||
        tokenContractFrom.toLowerCase() == contractWrapETH.toLowerCase()) {
      path..add(tokenFrom)..add(tokenSwap);
    } else {
      path..add(tokenFrom)..add(wrapETHContract)..add(tokenSwap);
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
          : EthereumAddress.fromHex(contractWrapETH);
      final tokenTo = tokenContractTo.isNotEmpty
          ? EthereumAddress.fromHex(tokenContractTo)
          : EthereumAddress.fromHex(contractWrapETH);
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
      throw 'Get AmountsOut failure';
    }
  }

  Future<String> getPairFactory({
    required String tokenFrom,
    required String tokenTo,
  }) async {
    final abi = Get.find<SettingService>().abiFactory;
    final contractAddr = EthereumAddress.fromHex(contractFactory);
    final contractFrom = EthereumAddress.fromHex(
        tokenFrom.isEmpty ? contractWrapETH : tokenFrom);
    final contractTo = EthereumAddress.fromHex(
      tokenTo.isEmpty ? contractWrapETH : tokenTo,
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
        DeployedContract(ContractAbi.fromJson(abi, 'ERC20 Token'), contractLP);
    final getToken0Function = contract.function('token0');
    final result = await _client
        .call(contract: contract, function: getToken0Function, params: []);
    return result.first.toString();
  }

  Future<BigInt> getGasLimitAddLiquidityETH({
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
        ContractAbi.fromJson(abiSwap, 'ERC20 Token'), contractAbi);
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
      data: data,
    );

    return gasLimit;
  }

  Future<String> addLiquidityETH({
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
        ContractAbi.fromJson(abiKRC20, 'ERC20 Token'), contractAbi);
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
        ContractAbi.fromJson(abiSwap, 'ERC20 Token'), contractAbi);
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
        DeployedContract(ContractAbi.fromJson(abi, 'ERC20 Token'), contractAbi);
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
        ContractAbi.fromJson(abi, 'ERC20 Token'), contractAddr);
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
        ContractAbi.fromJson(abi, 'ERC20 Token'), contractAddr);
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

  Future<BigInt> getGasLimitRemoveAddLiquidityETH({
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
        ContractAbi.fromJson(abiSwap, 'ERC20 Token'), contractAbi);
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

  Future<String> removeAdddLiquidityETH({
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
        ContractAbi.fromJson(abiKRC20, 'ERC20 Token'), contractAbi);
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
        ContractAbi.fromJson(abiSwap, 'ERC20 Token'), contractAbi);
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
        DeployedContract(ContractAbi.fromJson(abi, 'ERC20 Token'), contractAbi);
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
        ContractAbi.fromJson(abi, 'ERC20 Token'), contractAddr);
    final totalSupplyFunction = contract.function('totalSupply');
    final totalSupply = await _client
        .call(contract: contract, function: totalSupplyFunction, params: []);
    return totalSupply.first;
  }
}

enum EnumEthereumMethod {
  eth_getTransactionCount,
  eth_chainId,
  eth_gasPrice,
  eth_sendRawTransaction,
  eth_getBalance,
  eth_getTransactionByHash,
  eth_getTransactionReceipt,
}

enum EnumEthereumDefaultBlock {
  earliest,
  latest,
  pending,
  undefined,
}
