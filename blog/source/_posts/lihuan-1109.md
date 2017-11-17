---
title: THE MANY FACES OF FUNCTIONS IN JAVASCRIPT(翻译：js中的函数)
date: 2017-09-15 14:01:25
tags:
---
通常，js代码一般都包含定义和调用函数，但是，真的了解定义一个函数有哪些方法吗？这是在Test262中编写和维护测试的一个常见挑战。特别是当一个新特性关联到任何现有的函数语法或扩展了函数API时。

以下是JavaScript中现有的函数语法形式的说明性概述。这个文档不会包含类声明和表达式，因为这些方式产生的对象不是“可调用的”，对于本文，我们只会看看产生“可调用”函数对象的形式。此外，我们不会覆盖非简单的参数列表（包含默认参数，解构或尾随逗号的参数列表），因为这是一个值得自己的文章的主题。

### 传统的方式：
####函数声明和表达式
    最传统的方式：函数声明和函数表达式。前者是原始设计（1995）的一部分，出现在规格说明书第一版（1997）（pdf）中，而后者则在第三版（1999）（pdf）中介绍。可以从中提取三种不同的形式：
<!--more-->
```javascript
// Function Declaration
function BindingIdentifier() {}

// Named Function Expression
// (BindingIdentifier is not accessible outside of this function)
// BindingIdentifier不能在这个函数之外访问
(function BindingIdentifier() {}); 

// Anonymous Function Expression （匿名函数）
(function() {});
```
匿名函数表达式可能仍然有一个“名称” （https://bocoup.com/blog/whats-in-a-function-name）

#### 函数构造器（Function Contructor）
一开始，讨论语言的『函数API』时，当考虑原始语言设计时，语法函数声明形式可以被解释为函数构造器的『文字』形式。
Function 构造器提供了一种方法来定义函数，该方法是通过N个字符串参数来指定参数和函数体，其中最后一个字符串参数始终是函数体（重要的是要调用，这是一个动态代码评估形式）。对于大多数用例来说， 这种形式很尴尬，因此他的使用很少见，但自从ECMAScript的第一版以来，就已经是语言了。

```javascript
new Function('x', 'y', 'return x ** y;');
```

### 新方式：
    自从ES2015发布以来， 引入了集中新的语法形式，这几种形式的改变还是巨大的
#### 非匿名函数的声明
匿名函数声明有一个新的形式，可以识别ES Modules的工作环境，它可能看起来类似于一个匿名函数的函数表达式，它实际上有一个绑定的名字“* default *”

```javascript
// The not-so-anonymous Function Declaration
export default function() {}
```
这个'name'本身不是一个有效的标识符，并且没有创建绑定。


#### 方法定义（Method Definitions）

将函数表达式，匿名函数和命名函数定义为属性的值。但这些不是相同的语法形式！他们是前面提到的函数表达式的例子，设置在对象的初始值中，这最初是在ES3中引入的。
```javascript
let object = {
    propertyName: function() {},
};
let object = {
    // (BindingIdentifier is not accessible outside of this function)
    // BindingIdentifier不能在这个函数之外访问
    propertyName: function BindingIdentifier() {},
};
```

在ES5中，引入存取属性的定义：

``` javascript
let object = {
  get propertyName() {},
  set propertyName(value) {},
};
```

从ES2015开始，js提供给了一个简写的语法来定义方法，包含文字属性名称和计算属性名称形式，和存取属性
``` javascript
let object = {
  propertyName() {},
  ["computedName"]() {},
  get ["computedAccessorName"]() {},
  set ["computedAccessorName"](value) {},
};
```
也可以会用这些新方式在类声明和表达式里定义属性方法

```javascript
// Class Declaration (类声明)
class C {
  methodName() {}
  ["computedName"]() {}
  get ["computedAccessorName"]() {}
  set ["computedAccessorName"](value) {}
}

// Class Expression (类表达式)
let C = class {
  methodName() {}
  ["computedName"]() {}
  get ["computedAccessorName"]() {}
  set ["computedAccessorName"](value) {}
};
```
以及用来定义静态方法
```javascript
// Class Declaration
class C {
  static methodName() {}
  static ["computedName"]() {}
  static get ["computedAccessorName"]() {}
  static set ["computedAccessorName"](value) {}
}

// Class Expression
let C = class {
  static methodName() {}
  static ["computedName"]() {}
  static get ["computedAccessorName"]() {}
  static set ["computedAccessorName"](value) {}
};
```

### 箭头函数（Arrow Functions）
箭头函数已经众所周知且随处可见，箭头函数语法被定义，在命名ConciseBody时提供了两个不同的形式:AssignmentExpression-赋值表达式（当箭头后面没有大括号「{」）和FunctionBody-函数体 （代码里包含零个或多个语句时），语法还允许描述单个参数时可以省略括号，而零或大于一个参数将需要括号（这个语法允许以多种形式书写箭头函数）。

```javascript
// Zero parameters, with assignment expression （赋值表达式中无参数）
(() => 2 ** 2);

// Single parameter, omitting parentheses, with assignment expression 
(x => x ** 2);

// Single parameter, omitting parentheses, with function body
(x => { return x ** 2; });

// A covered parameters list, with assignment expression 
((x, y) => x ** y);
```

在上述的最后一个形式中，参数可以是被包括在括号中的参数列表，还提供了一种表示标记参数列表或特殊解构模式的语法：({x}) => x.
还有一种形式箭头函数，只用一个无括号的标识符作为参数。当箭头函数被定义在异步函数或generators中，这个标识符需要用await和yield加上前缀定义，这是在箭头函数中能得到最大程度的不用括号的参数列表的情况
  箭头函数也会出现在初始值赋值或属性定义中，上面所示的箭头函数表达式形式已经包含了这种情况，如以下示例所示：

```javascript
  let foo = x => x**2

  let object = {
    propertyName: x => x ** 2
  }
```


### 生成器（Generators）
Generators有一种特殊的语法，除了箭头函数和定义setter/getter方法时不能添加外，可以添加在其他形式中，可以用作函数声明，函数表达式，函数定义以及构造器类似的方式，如下：
```javascript
// Generator Declaration
function *BindingIdentifer() {}

// Another not-so-anonymous Generator Declaration!
export default function *() {}

// Generator Expression
// (BindingIdentifier is not accessible outside of this function)
(function *BindingIdentifier() {});

// Anonymous Generator Expression
(function *() {});

// Method definitions
let object = {
  *methodName() {},
  *["computedName"]() {},
};

// Method definitions in Class Declarations
class C {
  *methodName() {}
  *["computedName"]() {}
}

// Static Method definitions in Class Declarations
class C {
  static *methodName() {}
  static *["computedName"]() {}
}

// Method definitions in Class Expressions
let C = class {
  *methodName() {}
  *["computedName"]() {}
};

// Method definitions in Class Expressions
let C = class {
  static *methodName() {}
  static *["computedName"]() {}
};
```


## ES2017
### 异步函数（Async Functions）
异步函数将在2017年6月发布的第八版“EcmaScript语言规范”中引入，尽管如此，由于Babel中的支持，很多开发者已经在使用这个特性了！

异步函数的语法提供了一个描述异步操作的简单、统一方式。调用时，Async函数对象会返回一个Promise对象。当异步函数返回时，该对象将被解析。异步函数还可以在包含await表达式时暂停执行该函数，然后将其用作异步函数的返回值。
语法没有多大区别，同其他形式一样，函数的形式是：
```javascript
// Async Function Declaration
async function BindingIdentifier() { /**/ }

// Another not-so-anonymous Async Function declaration
export default async function() { /**/ }

// Named Async Function Expression
// (BindingIdentifier is not accessible outside of this function)
(async function BindingIdentifier() {});

// Anonymous Async Function Expression
(async function() {});

// Async Methods
let object = {
  async methodName() {},
  async ["computedName"]() {},
};

// Async Method in a Class Statement
class C {
  async methodName() {}
  async ["computedName"]() {}
}

// Static Async Method in a Class Statement
class C {
  static async methodName() {}
  static async ["computedName"]() {}
}

// Async Method in a Class Expression
let C = class {
  async methodName() {}
  async ["computedName"]() {}
};

// Static Async Method in a Class Expression
let C = class {
  static async methodName() {}
  static async ["computedName"]() {}
};
```

### Aysnc Arrow Functions 异步箭头函数
async 和 await 不限于普通的声明和表达式形式，还可以用于箭头函数中：
```javascript
// Single identified parameter followed by an assignment expression
(async x => x ** 2);

// Single identified parameter followed by a function body
(async x => { return x ** 2; });

// A covered parameters list followed by an assignment expression
(async (x, y) => x ** y);

// A covered parameters list followed by a function body
(async (x, y) => { return x ** y; });

```

## Post ES2017
### Async Generators 异步生成器

Post ES2017,async和await关键字将被扩展为支持新的Async Generator形式。这个功能的进展可以通过提案的github仓库来跟踪。正如所猜想的那样，这是async、await以及现有的Generator 声明和Generator 表达式形式的组合。当被调用时，异步生成器会返回一个迭代器iterator，它的next()方法返回Promise对象，用作迭代器结果对象的解析，而不是直接返回迭代器结果对象。

在你生成器函数中，异步Generator可以在许多地方找到
```javascript
// Async Generator Declaration
async function *BindingIdentifier() { /**/ }

// The not-so-anonymous Async Generator Declaration
export default async function *() {}

// Async Generator Expression
// (BindingIdentifier is not accessible outside of this function)
(async function *BindingIdentifier() {});

// Anonymous Function Expression
(async function *() {});

// Method Definitions
let object = {
  async *propertyName() {},
  async *["computedName"]() {},
};


// Prototype Method Definitions in Class Declarations
class C {
  async *propertyName() {}
  async *["computedName"]() {}
}

// Prototype Method Definitions in Class Expressions
let C = class {
  async *propertyName() {}
  async *["computedName"]() {}
};

// Static Method Definitions in Class Declarations
class C {
  static async *propertyName() {}
  static async *["computedName"]() {}
}

// Static Method Definitions in Class Expressions
let C = class {
  static async *propertyName() {}
  static async *["computedName"]() {}
};
```

## Complex Challenge
每个函数形式不仅是学习和使用的挑战，而且也是JS运行和Test262中的实现和维护的一个挑战。当引入新的语法形式时，Test262必须结合所有相关的语法规则来测试这种形式。例如，将默认参数语法的测试限制为简单的函数声明形式是不明智的，并且假设它以其他形式正常工作。每个语法规则都必须经过测试，编写这些测试是分配给一个人是一项不合理的。这导致了测试生成工具的设计和实现。测试生成工具提供了一种确保覆盖范围更详尽的方法。

## 为什么了解所有的函数格式是很重要的？
除非需要在Test262上编写测试，否则计算并列出所有的函数形式可能并不那么重要。这里列出的许多形式已经有了一个精简的模板列表。新的测试可以轻松地使用现有的模板作为起点。

确保EcmaScript规范得到充分测试是Test262的主要事项。这对所有JavaScript运行时间都有直接的影响，我们发现的形式越多，覆盖范围就越广泛，这有助于新功能更加无缝地集成，无论使用什么平台。