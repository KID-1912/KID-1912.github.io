# Solidity

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

`receive()` 将在合约账户接收ETH时执行该回调；

`fallback()` 将在合约中不存在的函数被调用时执行该回调（可实现代理合约proxy contract），在接收ETH但`msg.data`不存在时也会被调用；

**使用**

测试是否真实eth减少

### 发送ETH
