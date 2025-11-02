# Solidity

[Solidity 中文文档 - 登链社区](https://learnblockchain.cn/docs/solidity/)

## 库合约

为了提升`Solidity`代码复用性和减少`gas`而存在的一系列的函数合集的特殊合约。与普通合约不同点：

1. 不能存在状态变量
2. 不能够继承或被继承
3. 不能接收以太币
4. 不可以被销毁

通过 `Library` 关键字声明库合约：

```sol
library Strings {
   function toString(uint256 value) public pure returns (string memory) {
      // ...
    }
}
```

常用库合约：

1. [Strings](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/4a9cc8b4918ef3736229a5cc5a310bdc17bf759f/contracts/utils/Strings.sol)：将`uint256`转换为`String`
2. [Address](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/4a9cc8b4918ef3736229a5cc5a310bdc17bf759f/contracts/utils/Address.sol)：判断某个地址是否为合约地址
3. [Create2](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/4a9cc8b4918ef3736229a5cc5a310bdc17bf759f/contracts/utils/Create2.sol)：更安全的使用`Create2 EVM opcode`
4. [Arrays](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/4a9cc8b4918ef3736229a5cc5a310bdc17bf759f/contracts/utils/Arrays.sol)：跟数组相关的库合约

### 使用

**using ... for ...**

```sol
// 引入合约库, Remix虚拟文件系统会自动从网络加载（无需安装npm）
import "@openzeppelin/contracts/utils/Strings.sol";

contract Library {
    using Strings for uint; // 附加Strings合约给uint256类型
    function formatUint2String(uint number) external pure returns(string memory){
        // 库合约中的函数会自动添加为uint256型变量的成员
        return number.toHexString(); // 调用uint256类型变量的toHexString方法
    } 
}
```

**库合约名调用**

```sol
// 直接通过库合约名调用
function getString2(uint256 _number) public pure returns(string memory){
    return Strings.toHexString(_number); // Strings即库合约中 Library Strings 合约名
}
```

### 模块规范

类似JS中ES Module引入其他合约（相对路径/npm依赖包），但支持

- 通过网址引用：`import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol';`

- 全局符号引入：`import {Yeye} from './Yeye.sol';`

## 合约账户ETH

### 接收ETH

Solidity中与接收ETH相关的**回调函数**有两个：`receive()` 和 `fallback()`

`receive()` ：将在合约账户接收ETH时执行该回调；不需要 `function` 关键字，不允许参数，不允许返回值，必须包含 `external` 和 `payable`：`receive() external payable { ... }`

`fallback()`：将在合约中不存在的函数被调用时执行该回调（可实现代理合约proxy contract）；在接收ETH但call: `msg.data` 不存在于合约时也会被调用（此时falllback必须为payable否则报错，但仍可以通过其他payable函数方式向合约发送ETH）；

**手动构造calldata**

calldata 是随交易一起发送给 EVM 的原始字节流，用于告诉合约要调用哪个函数以及传递的参数，通常由ABI工具库(ether.js/web3.js/solidity abi编码工具)自动生成；如 `const tx = { to: rokenAddress, value: 0 }; await signer.sendTransation(tx);`

```js
  // 发起手动狗造calldata的交易
  const [signer] = await hre.ethers.getSigners();
  signer.sendTransaction({
    to: contractAddress,
    data: "0x12345678", // 此时将触发合约的fallback函数
    value: hre.ethers.parseEther("0.1"),
  });
```

### 发送ETH

**transfer**

使用：`接收方地址.transfer(发送ETH数额)`，若转账失败将自动回滚交易（revert）

gas限制：2300，够用于转账但对方合约 fallback/receive 函数逻辑不能太复杂

error信息： `"ETH transfer failed"`，无需手动revert

```sol
function transferETH(address payable _toAddress, uint amount) external payable {
  _toAddress.transfer(amount);
}
```

**send**

使用：`接收方地址.send(发送ETH数额)`，若转账失败不会revert；

返回值：一个代表转账成功/失败的 `bool`

gas限制：同transfer

```sol
error SendFailed(address _to); // 定义send方法失败Error

function sendETF(address payable _toAddress, uint amount) external payable {
  bool success = _toAddress.send(amount);
  if (success == false) {
    revert SendFailed(_toAddress);
  }
}
```

**call（推荐）**

使用：`接收方地址.call{value: 发送ETH数额}("")`，若转账失败不会revert；

返回值：返回一个 `(bool, bytes)`，其中`bool`代表着转账成功/失败

gas限制：无限制，允许对方合约 fallback/receive 函数逻辑复杂

```sol
error CallFailed(address _to);  // 定义send方法失败Error

function callETF(address payable _toAddress, uint amount) external payable {
  // 类似调用合约payable函数：contractAddress.functionName{value: amount}(args);
  (bool success,) = _toAddress.call{value: amount}("");
  if (success == false) {
    revert CallFailed(_toAddress);
  }
}
```

## 合约互调

传入**合约地址**调用（常见）

```sol
import "./ReceiveETH.sol"; // 引入contract命名为ReceiveETH的合约

contract SendETH {
    address payable public receiveETHContract;
    // 构造函数接收合约真实地址
    constructor(address payable _receiveETHContract) payable {
        receiveETHContract = _receiveETHContract;
    }
    function sendETH(address payable to, uint amount) external payable {
        ReceiveETH(receiveETHContract).setTransferRecords(to, amount);
    }
}
```

传入**合约变量**调用

```sol
import "./ReceiveETH.sol";

contract SendETH {
    // 声明合约变量
    ReceiveETH public receiveETHContract;
    constructor(ReceiveETH _receiveETHContract) payable {
        receiveETHContract = _receiveETHContract;  // 赋值合约类型变量
    }

    function sendETH(address payable to, uint amount) external payable {
        receiveETHContract.setTransferRecords(to, amount); // 合约变量调用
    }
}
```

创建**合约变量**调用

```sol
import "./ReceiveETH.sol";

contract SendETH {
    address payable public receiveETHContractAddress;
    // 构造函数接收合约真实地址
    constructor(address payable _receiveETHContractAddress) payable {
        receiveETHContractAddress = _receiveETHContractAddress;
    }
    function sendETH(address payable to, uint amount) external payable {
        // 创建合约变量 by 合约地址
        ReceiveETH receiveETHContract = ReceiveETH(receiveETHContractAddress)
        receiveETHContract .setTransferRecords(to, amount);
    }
}
```

### 接口+地址调用合约

```sol
// 定义被调用合约接口
interface IReceiveETH {
    function setTransferRecords(address _from, uint _amount) external;
}

contract SendETH {
    IReceiveETH public receiveETHContract;
    // 接收被合约地址
    constructor(address _receiveETHContract) payable {
        receiveETHContract = IReceiveETH(_receiveETHContract); // 合约变量
    }

    function sendETH(address payable to, uint amount) external payable {
        receiveETHContract.setTransferRecords(to, amount); // 直接调用
    }
}
```

## call调用

`call` 作为 address 类型的低级成员函数，用于和其他合约交互；如实现触发fallback和receive的发送ETH的方法（推荐），调用另一个合约函数（不推荐），以及不知道对方合约的源代码或 `ABI`，仍可以通过 `call` + 函数名ABI编码来调用对方合约的函数

**call调用规则**：`目标合约地址.call{value:发送数额, gas:gas数额}(字节码);`

其中**字节码**可利用结构化编码函数 `abi.encodeWithSignature` 计算：

```sol
// 调用 contractAddress.add函数
(bool success, uint256 memory returnedData) = contractAddress.call(abi.encodeWithSignature("add(uint 256, uint 256)", 5, 3));
// success 是否调用成功，returnedData 函数返回值
return abi.decode(returnedData, (uint256));
```

**注**：以太坊虚拟机（EVM）层面，调用一个合约函数，本质上就是向一个合约地址**发送一段数据（calldata）**

## delegatecall调用
