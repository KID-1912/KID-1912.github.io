# Solidity

一种用于编写以太坊虚拟机（`EVM`）智能合约的编程语言。

## Remix

以太坊官方推荐的智能合约集成开发环境（IDE），可在浏览器中快速开发和部署合约，也可本地安装。[https://remix.ethereum.org](https://remix.ethereum.org/)

**基本流程**

【文件】新建 `HelloWeb3.sol`

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
contract HelloWeb3{
    string public _string = "Hello Web3!";
}
```

【编译】

`Ctrl + S` 自动编译

【部署】将使用 `Remix` 虚拟机模拟以太坊链，部署合约

## 基础语法

### 数据类型

**值类型(Value Type)** ：包括布尔型，整数型等等，这类变量赋值时候直接传递数值。

**引用类型(Reference Type)** ：包括数组和结构体，这类变量占空间大，赋值时候直接传递地址（类似指针）。

**映射类型(Mapping Type)** : Solidity中存储键值对的数据结构，可以理解为哈希表

#### 值类型

**字符串**：`string public _string = "Hello World!"`

**布尔值**：`bool public _lock = false`

**整型**：

```solidity
int public _amount = -123; // 整数（含负数）int
uint public _total= 10123; // 无符号整数
uint256 public _series = 20250829; // 256位无符号整数，等同于uint类型
```

**地址类型**：专表示一个地址的数字的类型

```solidity
address public _address = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71;
uint public balance = _address.balance; // 地址类型的balance成员（链上读取余额）
address payable public _address_payable = payable(_address); // payable address类型地址
// _adress_payable地址支持transfer/send方法（接收/发送ETH）
```

**定长字节数组**：

一个固定长度的数组，逐字节存储（必须每项有字节值），如bytes32/bytes

```solidity
bytes32 public _str_bytes = "str"; // 字符串会自动转换并填充为对应bytes类型
bytes8 public _str_bytes8 = "12345678";
bytes32 public _num = bytes32(uint(123)); // 数字需要转为256位无符号整数后转bytes类型
```

**枚举**：支持为 `uint` 分配名称，使程序易于阅读和维护

```solidity
// 枚举
enum StatusEnum { Success, Fail, Complete } // 用enum将uint 0， 1， 2表示Success, Fail, Complete
StatusEnum public status = StatusEnum.Success; // 支持 if (status == 0) 的判断
// 不支持 bool public isSuccess = (status == 0);
// 支持enum转uint
function enumToUint() external view returns(uint){
    return uint(action);
}
```

#### 数据存储

对于引用类型，必须声明数据存储位置：storage/memory/calldata（为了区分变量是链上/链下）

`storage`：合约里的状态变量默认都是`storage`，存储在链上（类似计算机的硬盘，消耗`gas`多）。

`memory`：函数里的参数和临时变量一般用`memory`，存储在内存中，不上链。尤其是如果返回数据类型是变长的情况下，必须加memory修饰，例如：string, bytes, array和自定义结构（动态分配的临时数据，不能永久存储）。

`calldata`：和`memory`类似，存储在内存中，不上链。与`memory`的不同点在于`calldata`变量不能修改（`immutable`），一般用于外部函数的参数。例子：

```solidity
function fCalldata(uint[] calldata _x) public pure returns(uint[] calldata){
    //参数为calldata数组，不能被修改
    // _x[0] = 0 //这样修改会报错
    return(_x);
}
```

**赋值规则**

不同存储类型相互赋值时候，有时会产生独立的副本（修改新变量不会影响原变量），有时会创建引用（修改新变量会影响原变量）。

创建引用：

`storage`（合约的状态变量）赋值给本地`storage`（函数里的）时候，会创建引用，改变新变量会影响原变量；

`memory`赋值给`memory`，会创建引用，改变新变量会影响原变量；

创建副本：其他情况下，赋值创建的是本体的副本；

**变量作用域**

状态变量：合约内函数外声明的变量值，`gas`消耗高

局部变量：函数执行中变量，存储在内存里，不上链，`gas`低

全局变量：全局范围工作的 `solidity` 预留关键字

如 `msg.sender`，`block.number`和`msg.data`，详见 [单位和全局可用变量](https://learnblockchain.cn/docs/solidity/units-and-global-variables.html#special-variables-and-functions)

以太单位：`Solidity`中不存在小数点，防止精度的损失，利用以太单位在合约中处理货币交易。1 == 1 wei，1 gwei  == 10000000000 wei（10亿），1 ether == 10000000000 gwei

时间单位：`seconds` `minutes` `hours` `days` `weeks` `days`

#### 引用类型

**string**

字符串拼接：`Strings.toHexString(uint160(_address), 20))`

**数组**

```solidity
// 定长数组
uint[3] array1;
address[3] array2;
bytes32 bytes3;
bytes32[3] array_bytes32;
// 变长数组
uint[] array1;
bytes32[] array_bytes32;
bytes array_byte;
```

创建数组：

```solidity
// memory 的变长数组是定长的
uint[] memory array1 = new uint[](5); // new的方式创建动态数组，必须设置初始化长度，允许非编码写死，可以是变量值作设为长度
uint[3] memory array2 = [uint(1), 2, 3]; // 字面量方式声明，必须固定长度
```

数组成员：

`length`: 数包含元素数量的`length`成员，`memory`数组的长度在创建后是固定的。

`push()`: `动态数组`拥有在数组最后添加一个`0`元素，并返回该元素的引用。

`push(x)`: `动态数组`拥有`push(x)`成员，可以在数组最后添加一个`x`元素。

`pop()`: `动态数组`移除数组最后一个元素。

**struct 结构体**

构造结构体自定义类型：

```solidity
struct Student {
  uint id;
  uint score；
}
```

初始化变量：

```solidity
Student student;
// 函数内：
Student storage _student = student; // 创建引用
_student.id = 1;
_student.score = 99;
// 或
Student storage _student = Student(2, 90);
// 或
Student storage _student = Student({
  id: 3,
  score: 89,
})
```

#### 映射类型

映射类型（Mapping）Solidity中存储键值对的数据结构，可以理解为哈希表；

```solidity
mapping(uint => address) public idToAddress;
mapping(uint => Student) public idTostudent;
idToAddress[_Key] = _Value;
```

**映射规则**

key必须为值类型（不允许引用类型）

映射的存储位置声明只能是storage；且不能作为public函数的参数或返回值

**映射特性**

无length属性，访问未赋值的key得到是类型默认值（uint即0，address即0x0000...）

#### 默认值与常量

**默认值**

对于声明的未初始化值的变量，会根据类型初始化对应默认值

```js
int/uint = 0
address = 0x0000...
bool = false
enum = 枚举项索引 0, 1, ...
bytes32 = 0x0000...(32*2)

string = ""
int[4]/uint[] = [0, ...]
bytes = 0x0000...
struct = 对应值类型的默认值
mapping(uint => address) = 0 => 0x0000...
```

**常量**

**constant**：`int256 public constant _amount = 123` 必须在声明时初始化赋值

**immutable**：`int256 public immutable _amount` 不变量，允许声明后仅在constructor内初始化值

### 函数

#### 关键字

**语法**：

```solidity
function <function name>([parameter types[, ...]]) {internal|external|public|private} [pure|view|payable] [virtual|override] [<modifiers>] [returns (<return types>)]{ <function body> }
```

`{internal|external|public|private}`

- `public`：内部和外部均可见。
- `private`：只能从本合约内部访问，继承的合约也不能使用。
- `external`：只能从合约外部访问（但内部可以通过 `this.f()` 来调用，`f`是函数名）。
- `internal`: 只能从合约内部访问，继承的合约可以用。

`[pure|view|payable]`：决定函数权限/功能的关键字。`payable`（可支付的）很好理解，带着它的函数，运行的时候可以给合约转入 ETH。

`[virtual|override]`: 方法是否可以被重写，或者是否是重写方法。`virtual`用在父合约上，标识的方法可以被子合约重写。`override`用在自合约上，表名方法重写了父合约的方法。

**pure & view**

合约的状态变量存储在链上，gas fee 很贵，如果计算不改变链上状态，就可以不用付 `gas`。包含 `pure` 和 `view` 关键字的函数是不改写链上状态的，因此用户直接调用它们是不需要付 gas 的；

在以太坊中，以下语句被视为修改链上状态：

1. 写入状态变量。
2. 释放事件。
3. 创建其他合约。
4. 使用 `selfdestruct`
5. 通过调用发送以太币。
6. 调用任何未标记 `view` 或 `pure` 的函数。
7. 使用低级调用（low-level calls）。
8. 使用包含某些操作码的内联汇编。

`pure` 函数既不能读取也不能写入链上的状态变量。

`view`函数能读取但也不能写入状态变量。

非 `pure` 或 `view` 的函数既可以读取也可以写入状态变量。

**return & returns**

`returns`：跟在函数名后面，用于声明返回的变量类型及变量名。

`return`：用于函数主体中，返回指定的变量。

```solidity
// 返回多个变量
function returnMultiple() public pure returns(uint256, bool, uint256[3] memory){
    return(1, true, [uint256(1),2,5]);
}
```

```solidity
// 命名式返回
function returnNamed() public pure returns(uint256 _number, bool _bool, uint256[3] memory _array){
    _number = 2;
    _bool = false;
    _array = [uint256(3),2,1]; 
    return (_number, _bool, _array);
}
```

想法：返回单个值时允许不命名返回值变量，返回多个值必须命名所有返回变量；

**解构赋值**

```solidity
unint256 _number;
bool _bool;
unint256[3] _array;
(_number, _bool, _array) = returnNamed();
(, _bool2, ) = returnNamed();
```

#### constructor

构造函数，合约支持传参

```solidity
address public immutable ownerAddress;
  constructor(address _address){
    ownerAddress = _address;
}
```

#### modifier

**修饰器**：类似于面向对象语言的装饰器，声明函数拥有的特性封装；如运行函数前的检查。

```solidity
modifier onlyOwner {
    require(msg.sender == ownerAddress, "no auth"); // 检查，否则报错revert交易
    _; // 运行函数主体
}
function changeOwnerAddress(address _address) external onlyOwner {
    require(_address != ownerAddress, string.concat("ownerAddress has been ", Strings.toHexString(uint160(_address), 20)));
    ownerAddress = _address;
}
```

#### 重载

即名字相同但输入**参数类型不同**的函数可以同时存在，视为不同函数被外部使用；

### 控制流

与javascript一致

### 事件

事件（Event）是EVM日志的抽象，它的职能包括：

可响应：ethers.js的应用程序可以通过`RPC`接口订阅和监听这些事件，并在前端做响应。

经济性：事件是`EVM`上比较经济的存储数据的方式，每个大概消耗2,000 `gas`；相比之下，链上存储一个新变量至少需要20,000 `gas`。

**声明事件**

event关键字 +事件名称 + 事件记录的变量

```solidity
event Transfer(address indexed from, address indexed to, uint value);
```

`indexed`关键字的变量会保存在以太坊虚拟机日志的`topics`中方便检；

**释放/发送事件**

```solidity
contract Event {
    mapping(address => uint) public userBanlance;
    event Receive (address indexed payer, address indexed receiver, uint _amount);
    event Transfer (address indexed from, address indexed to, uint _amount);

    // 接收Receive
    function _receive(address receive_address, uint _amount) external {
        userBanlance[receive_address] += _amount;
        emit Receive(address(this), receive_address, _amount);
    }

    // 转账交易
    function _transfer(address to, uint _amount) external {
        require(_amount <= userBanlance[msg.sender], "Insufficient balance");
        userBanlance[msg.sender] -= _amount;
        userBanlance[to] += _amount;
        emit Transfer(msg.sender, to, _amount);
    }
}
```

#### 日志结构

**Topics**：一个描述事件长度不超过`4`的数组。第一个元素是事件名的哈希，另外元素是至多`3`个`indexed`参数

**Data**：不带 `indexed`的参数会被存储为无法检索的值，允许任意结构任意大小的数据；

### 继承

通过 `is` 关键字声明继承父合约，将继承父合约所有状态和方法，并支持构造函数继承调用

```solidity
contract Persion {
  constuctor(uint _age){
    age = _age;
  }
  function sayHello() public pure {
    emit Log("Hello");
  }
  modify onlyOwner() virtual {
    require(msg.sender == ownerAddress, "no auth");
    _;
  }
}
contract Student is Person {
  // 子合约支持调用继承的sayHello函数, onlyOwner修饰器
  constuector(uint _class, uint _age) Person(_age) {} // 调用父合约构造函数
}
contract Student is Person, Child {
  // 多重继承：继承多个合约
}
```

**覆写**

父合约中 `virtual` 关键词声明的函数允许在子合约使用 `overried` 声明同名函数实现覆写

```solidity
contract Persion {
  function sayHello() public pure virtual {
    emit Log("Hello!");
  }
}
contract Student is Person {
  function sayHello public pure override {
    emit Log("Hello, I'm a student.");
  }
}
```

**注**：父合约的状态变量将被继承，但不可被覆写；但可以用同名变量覆盖（隐藏父变量）

```solidity
contract Parent {
    uint256 public value = 100; // 父合约的状态变量
}

contract Child is Parent {
    uint256 public value = 200; // 子合约定义同名变量，隐藏父合约的 value
}
```

有时我们会覆写父合约某个变量的默认getter函数，自定义返回值逻辑：

```solidity
contract Child is Parent {
    mapping(address => uint256) private _realBalances;

    // 覆写 getter 添加额外逻辑
    function balanceOf(address account) public override view returns (uint256) {
        return _realBalances[account] * 2; // 返回双倍余额
    }

    function deposit(address account, uint256 amount) public {
        _realBalances[account] += amount;
    }
}
```

**访问父合约**

子合约覆写父合约函数下，如何调用符合函数？如何访问父合约的状态变量（如被隐藏）？

```sol
Person.sayHello();
Person.age;
super.sayHello(); // 调用最近的父合约函数
```

## 抽象合约与接口

由于合约支持被继承的子合约覆写函数，父合约我们可以定义一个未实现的函数专门用于被覆写，即抽象合约

```solidity
abstract contract InsertionSort {
  function insertionSort(uint[] memory list) pure virtual returns(uint[] memory);
}
```

### 接口

定义合约里每个函数的`bytes4`选择器，以及函数签名`函数名(每个参数类型）`即接口，如果其它合约实现了该接口（比如`ERC20`或`ERC721`），则所有Dapps和合约知晓如何与其交互。

接口的规则：

1. 不能包含状态变量
2. 不能包含构造函数
3. 不能继承除接口外的其他合约
4. 所有函数都必须是external且不能有函数体
5. 继承接口的非抽象合约必须实现接口定义的所有功能

```solidity
interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved); 
    // ...
}
```

当知晓一个合约对某个接口有实现，那么我们只需关注接口提供的函数与它交互（而不关心内部实现），如引入无聊猿`BAYC`合约，并调用合约函数；

```solidity
contract interactBAYC {
    // 利用BAYC地址创建接口合约变量（ETH主网）
    IERC721 BAYC = IERC721(0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D);

    // 通过接口调用BAYC的balanceOf()查询持仓量
    function balanceOfBAYC(address owner) external view returns (uint256 balance){
        return BAYC.balanceOf(owner);
    }

    // 通过接口调用BAYC的safeTransferFrom()安全转账
    function safeTransferFromBAYC(address from, address to, uint256 tokenId) external{
        BAYC.safeTransferFrom(from, to, tokenId);
    }
}
```

## 异常

**revert Error**

定义异常：

```solidity
error TransferNotOwner(address sender); // 自定义参数的带错误信息的error
```

`error`可以定义参数，这些参数会在交易回滚时被记录在链上（但不会消耗 gas 存储）;

抛出异常并回退

```solidity
function transferOwner1(uint256 tokenId, address newOwner) public {
    if(_owners[tokenId] != msg.sender){
        revert TransferNotOwner(msg.sender); // 异常并传递参数
    }
    _owners[tokenId] = newOwner;
}
```

**Require**

```solidity
function transferOwner2(uint256 tokenId, address newOwner) public {
    require(_owners[tokenId] == msg.sender, "Transfer Not Owner"); // 检查是否满足条件
    _owners[tokenId] = newOwner;
}
```

**Assert**

不能描述异常版的`Require`

```solidity
function transferOwner3(uint256 tokenId, address newOwner) public {
    assert(_owners[tokenId] == msg.sender);
    _owners[tokenId] = newOwner;
}
```
