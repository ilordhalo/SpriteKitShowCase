# SpriteKit&GameplayKit - 2D游戏开发

## SpriteKit

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ff6c56777357436692c8f0ddf3dbc9db~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=878&h=410&s=71080&e=png&b=141414)

SpriteKit 是一个通用框架，用于在二维坐标系中绘制形状、粒子、文本、图像和视频。它利用 Metal 实现高性能渲染，同时提供简单的编程接口，使创建游戏和其他图形密集型应用程序变得容易。使用一组丰富的动画和物理行为，您可以快速为您的视觉元素添加生命，并在屏幕之间优雅地过渡。

在 iOS、macOS、tvOS 和 watchOS 上都支持 SpriteKit，并且它与 GameplayKit 和 SceneKit 等框架很好地集成。

属于2D游戏引擎

### SpriteKit基本的渲染流程

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0ba817dca6e842ffa47f1f03783cca9f~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=552&h=377&s=108741&e=png&b=fefdfd)

-   在iOS传统的view的系统中，view的内容被渲染一次后就将一直等待，直到需要渲染的内容发生改变（比如用户发生交互，view的迁移等）的时候， 才进行下一次渲染。这主要是因为传统的view大多工作在静态环境下，并没有需要频繁改变的需求。而对于SpriteKit来说，其本身就是用来制作大 多数时候是动态的游戏的，为了保证动画的流畅和场景的持续更新，在SpriteKit中view将会循环不断地重绘。

  


-   动画和渲染的进程是和SKScene对象绑定的，只有当场景被呈现时，这些渲染以及其中的action才会被执行。SKScene实例中，一个循环按执行顺序包括：

  


1.  每一帧开始时，SKScene的-update:方法将被调用，参数是从开始时到调用时所经过的时间。在该方法中，我们应该实现一些游戏逻辑，包括AI，精灵行为等等， 另外也可以在该方法中更新node的属性或者让node执行action
1.  在 update执行完毕后，SKScene将会开始执行所有的action。因为action是可以由开发者设定的（还记得runBlock:么），因此在这一个阶段我 们也是可以执行自己的代码的
1.  在当前帧的action结束之后，SKScene的-didEvaluateActions将被调用，我们可以在这个方法里对结点做最后的调整或者限制， 之后将进入物理引擎的计算阶段。
1.  然后SKScene将会开始物理计算，如果在结点上添加了SKPhysicsBody的话，那么这个结点将会具有物理特性，并参与到这个阶段的计算。 根据物理计算的结果，SpriteKit将会决定结点新的状态。
1.  然后-didSimulatePhysics会被调用，这类似之前的-didEvaluateActions。这里是我们开发者能参与的最后的地方， 是我们改变结点的最后机会。
1.  一帧的最后是渲染流程，根据之前设定和计算的结果对整个呈现的场景进行绘制。完成之后，SpriteKit将开始新的一帧。

### SKNode

SpriteKit 中的每个屏幕元素都称为一个Node。Node要么是视觉元素，要么是其他节点的容器。可以通过以分层形式在彼此并排和顶部添加节点来设置 SpriteKit 场景的外观。这种结构统称为节点树或节点层次结构。

-   SKNode：是一个容器节点。它不渲染自己的任何内容，而是作为其子节点的布局工具。
-   SKReferenceNode：不定义自己的内容，而是引用另一个节点或存档文件。
-   SKCameraNode：定义场景中的视点。可以通过SKConstraint绑定视点和角色的关系，保证角色处于视图最中心。[Getting Started with a Camera](https://developer.apple.com/documentation/spritekit/skcameranode/getting_started_with_a_camera)
-   SKVideoNode：用于播放视频。
-   SKAudioNode：用于播放音频，可以实现空间音频效果 [Using Audio Nodes with the Scene's Listener](https://developer.apple.com/documentation/spritekit/skscene/using_audio_nodes_with_the_scene_s_listener)
-   SKSpriteNode：用于图像纹理绘制

如 ShowCase中的可见元素均为SKSpriteNode

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/36fac0e1c64941fc99a2a93c970a0a61~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=2590&h=1024&s=1258971&e=png&b=292929)

更多详见 [Nodes for Scene Building](https://developer.apple.com/documentation/spritekit/nodes_for_scene_building#2242745)

### SKAction

当需要为游戏添加动画时使用，在SKScene处理动画帧时会执行你设置的SKAction。通过SKAction可以实现Node的平移、缩放、旋转、播放音视频、播放帧动画等效果

如 ShowCase中人物的动画动作均为SKAction实现

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7e338fd6ff5547288f2f161591466c6b~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=2864&h=1792&s=518042&e=png&b=292a2f)

-   除此之外还可以用于，游戏中的一些不受限于物理引擎的实时动画（如：反派角色突然冲进屋子打晕主角，抢走主角手中的奶茶）

更多详见 [Getting Started with Actions](https://developer.apple.com/documentation/spritekit/getting_started_with_actions)

### 物理引擎

物理引擎是用来在游戏中模拟现实中真实物理世界的运动方式的。SpriteKit的物理引擎是使用Box2D 库，因为Box2D库是使用C++写的，所以苹果直接对其进行了OC/Swift的封装，简单易懂，相比于cocos2dx 有着很大的优势。但是，这样的同时也是有弊端的，因为封装的，不开源的问题，SpriteKit的物理引擎就不如cocos2dx的功能丰富。[Box2D](https://box2d.org/documentation/index.html)

尽管可以控制场景中每个节点的确切位置，但通常您希望这些节点相互交互、相互碰撞并在过程中传递速度变化。您可能还想做一些动作系统无法处理的事情，例如模拟重力和其他力。为此，您创建物理体 (SKPhysicsBody) 并将它们附加到场景中的节点。

-   SKPhysicsWorld：场景中物理引擎的驱动程序；它为您提供了配置和查询物理系统的能力（如：配置物体关联，碰撞检测等）。SKScene持有
-   SKPhysicsBody：SKNode的属性描述该Node的物理性质（如：质量、摩擦系数、恢复系数）以及碰撞属性

关于碰撞：

-   SKPhysicsBody.categoryMask 表示物体的碰撞体类型
-   SKPhysicsBody.collisionMask 描述会与该物体发生碰撞的类型集合
-   SKPhysicsBody.contactMask 描述碰撞后会触发碰撞检测的类型集合

如：ShowCase中 定义了障碍(001)、玩家(010)、坏人(100)三种碰撞类型

player.physicsBody.collisionMask = 001 表示只有障碍能与玩家发生碰撞

player.physicsBody.contactMask = 111 表示这三种物理体与玩家碰撞后都会触发碰撞检测

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/920f654e21ec4c0d8d3cebf58aa0327d~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=2148&h=1542&s=407727&e=png&b=292a2f)

给SKPhysicsWorld设置SKPhysicsContactDelegate ，然后代理中实现即可在代码中监听到碰撞发生和结束

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8dd8171310f5419789db7fa03a807e05~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=1410&h=366&s=76319&e=png&b=292a2f)

当然对于复杂的物理效果，需要设置物理体的连接。具体可以看 [Connecting Bodies with Joints](https://developer.apple.com/documentation/spritekit/skphysicsjoint/connecting_bodies_with_joints)

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/484f1d62c5184099ba2a2e40418e70f7~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=1360&h=721&s=56610&e=png&b=ffffff)

## GameplayKit

GameplayKit 框架集合了为编写 iOS 和 OS X 游戏的基础工具和技术。与 SpriteKit 或 SceneKit 这些高级引擎不同的是，GameplayKit 不参与动画和视觉渲染等相关内容。相反，你可以使用 GameplayKit 来开发你的游戏机制，并利用最小的代价来设计模块化，可扩展的游戏架构。

### 组件实体设计模式

暂时无法在飞书文档外展示此内容

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2c24737d4efc432386d53a0a2a5b71a4~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=584&h=902&s=186279&e=png&b=39343d)

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/535b12a7f6494fd9a7f3fc1a16196c10~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=1974&h=408&s=114087&e=png&b=292a2f)

SKScene中持有所有component，可以在主循环直接通知抽象的component执行动作，无需关注具体Entity

如下图中的，攻击检测代码

-   遍历GameScene所有AttackComponent，找到isAttacking的component
-   遍历所有HurtComponent（定义为可被攻击的组件）
-   判断HurtComponent和AttackComponent的距离和方向
-   距离方向合理，则通知HurtComponent被攻击到

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b33b56bd6677445189fd9be680ab00e2~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=2666&h=1066&s=298587&e=png&b=292a2f)

### GKStateMachine

在几乎所有的游戏中，游戏相关的代码逻辑往往高度依赖于当前游戏所处的状态。比方说，一个玩家角色的动画代码将随着他当时处于行走，跳跃还是站立状态而改变；一个敌方角色的移动代码也将随着他被赋予的 AI 智能的判断而改变，这个智能决定了他当时会去追逐一个弱小的玩家，还是逃离一个强大的玩家；甚至你的游戏在任何时候的每一帧里哪部分代码将被执行也随着游戏是否在运行，是否被暂定又或者是否处在菜单场景或者一些剪辑场景等等这些状态而改变。

当你开始编写一个游戏时，你可以简单的将所有的依赖状态变化的代码放在一个地方——比如说，放在一个 SpriteKit 游戏的每一帧的更新方法中。然而，当你的游戏不断地变大变复杂，这个方法将变得难以维护，也更难扩展。

更好的是，你可以有条理定义游戏中不同的状态，并且进一步规定状态间的切换规则。而这些定义被我们称之为状态机（State Machines）。这样，你可以将不同状态和相应的代码关联起来，那样在一个特定状态下，你就知道游戏的每一帧应该做什么，什么时候应该转化到另一个状态，以及转换状态过程中应该做什么动作。通过使用状态机来组织你的代码，你可以更加简单的区分游戏的复杂行为。

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/343d23fe7aeb4755862271befbdc6366~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=1221&h=571&s=110730&e=png&b=fefefe)

例图：一个为角色动画设计的状态机

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/9679706b7115451281be4debb67a57d1~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=1286&h=796&s=374898&e=png&b=ffffff)

例图：一个为游戏界面设计的状态机

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3f9f81ba8f5e4d609b281eb741393a77~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=995&h=844&s=126324&e=png&b=181818)

暂时无法在飞书文档外展示此内容

初始化时，状态定义由Entity传给对应component，对应component持有stateMachine

当进入不同状态时获取animationComponent来执行动画（下图为：RunningState，进入后会调用animationComponent来设置执行动画）

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b06ed23e80ae4926aaaf0c15b8297ec6~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=1702&h=878&s=207055&e=png&b=2a2b30)

### RuleSystem

很多游戏包含复杂的规则设定。例如，一个回合制的角色扮演游戏就可能包括以下的规则：当对立的角色进入同一个空间时会发生什么，谁将在接下来的战斗中占上风？或者说角色是否有机会去攻击对方？当其他角色试图攻击或者和参战者对战，会发生什么？这些规则的设定会变得非常复杂，以至于编程语言里的条件逻辑语句变得非常笨重。

一些非常有趣的游戏会包含突发行为系统，依附于一些简单规则的简单实体，它们之间的相互作用会在整个系统中呈现出有趣的模式。例如，单个敌人角色在动作游戏中的目标可能取决于人物的血量，敌人如何看到玩家角色，有多少其他的敌对角色在附近，玩家如何经常击败敌人，以及其他因素。总之，在游戏中，这些因素会使得游戏变得更加逼真，一些敌人会成群的攻击玩家，有些则会逃跑。

在 GameplayKit 中，规则系统解决了这两个问题。通过把游戏逻辑中确定的基本部分抽象成数据，规则系统能够帮助你把游戏分解成功能性的、可重复的、可扩展的块。通过合并模糊的逻辑，规则系统能够把角色的行为判断变为连续的变量而不是离散的状态，即使是简单的规则组合也能完成完成复杂的动作。

GameplayKit 包含了两个主要的类来构建规则系统：[GKRule](https://developer.apple.com/library/prerelease/ios/documentation/GameplayKit/Reference/GKRule_Class/index.html#//apple_ref/occ/cl/GKRule) 和 [GKRuleSystem](https://developer.apple.com/library/prerelease/ios/documentation/GameplayKit/Reference/GKRuleSystem_Class/index.html#//apple_ref/occ/cl/GKRuleSystem)

-   `GKRule`：代表基于外部状态而作出的具体决定；
-   `GKRuleSystem`：计算一系列对应状态数据的规则来决定一系列的事实；

一个 [GKRuleSystem](https://developer.apple.com/library/prerelease/ios/documentation/GameplayKit/Reference/GKRuleSystem_Class/index.html#//apple_ref/occ/cl/GKRuleSystem) 对象有三个关键部分：`规则议程`，`状态数据`和`事实`。

-   `议程`。将一组规则添加到规则系统对象的 [agenda](https://developer.apple.com/library/prerelease/ios/documentation/GameplayKit/Reference/GKRuleSystem_Class/index.html#//apple_ref/occ/instp/GKRuleSystem/agenda) 中（ [addRule:](https://developer.apple.com/library/prerelease/ios/documentation/GameplayKit/Reference/GKRuleSystem_Class/index.html#//apple_ref/occ/instm/GKRuleSystem/addRule:) 或[addRulesFromArray:](https://developer.apple.com/library/prerelease/ios/documentation/GameplayKit/Reference/GKRuleSystem_Class/index.html#//apple_ref/occ/instm/GKRuleSystem/addRulesFromArray:)方法）。默认情况下，系统会按照他们添加到议程中的顺序来计算规则，这样做能够确保某些规则始终在其他规则前面计算，改变这些规则的显著性。
-   `状态`。规则系统的 [state](https://developer.apple.com/library/prerelease/ios/documentation/GameplayKit/Reference/GKRule_Class/index.html#//apple_ref/occ/instp/GKRule/salience) 字典包含的信息规则可以根据其进行测试。状态字典可以为你的规则设置提供任何有用的参考，例如你游戏模式中的字符串、数字或者自定义类。你如何编写规则决定了这些规则将使用数据结构。
-   `事实`。事实表示从系统中的规则评估得出一个结论，并且可以是任何类型的对象，通常是像字符串这样简单的数据对象就足够了，从游戏模型中定义对象也可以被使用。一个事实的隶属度是一个数字，决定了它在事实的系统设置存在。1.0 级的事实包括，但零级的事实并非如此。当一个规则系统评估其规则，该规则操作可以确定一个事实，将其添加到系统中，或收回一个事实，从系统中删除。

ShowCase中 定义了几种事实

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/19d787da3d134eb6b51f20f285c54745~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=1960&h=346&s=150815&e=png&b=292a2f)

PlayerNearRule中，通过ruleSystem中state带来的当前环境信息，我们能方便的判断。玩家在附近这样一个事实。grade()评价函数，ShowCase中我们定义1.0为发生了事实

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ccad0d91faa7440a930f82bf36aebacb~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=1450&h=658&s=116482&e=png&b=292a2f)

通过RuleComponentDelegate 我们能得知RuleComponent已经完成了对当前场景发生事实的判断，在BadGuyEntity中 我们就能根据事实结论来决定反派执行的动作

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/69f14e9fd55f470487dcce8ca27dc4c5~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=1872&h=700&s=202912&e=png&b=292a2f)

### 游戏中的智能

对于ShowCase中，BadGuy追杀玩家就属于一种简单的智能，通过Component、StateMachine以及RuleSystem我们得以实现。

不过不止于此，苹果还提供了为智能博弈设计的 [GKMinmaxStrategist](https://developer.apple.com/library/prerelease/ios/documentation/GameplayKit/Reference/GKMinmaxStrategist_Class/index.html#//apple_ref/occ/cl/GKMinmaxStrategist)

使用了最小最大搜索。通过配置估值函数和搜索深度即可获取对手的博弈判断结论

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ad786ab4ddb04442882c0a9fa9d45088~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=594&h=480&s=60116&e=png&b=fdfcfc)

该算法具体可以查看 [对抗搜索(最小最大搜索Minimax、Alpha-Beta剪枝搜索、蒙特卡洛树搜索](https://www.cxyzjd.com/article/hxxjxw/105848821)

### 游戏中的随机

-   `GKRandomDistribution`类自身将产生一个特定范围内的均匀分布——也就是说，任何一个在既定的最大值和最小值之间的值将有同等概率出现。任何时候当你需要生成一个具体区间的随机值时，你可以使用这个类。掷骰子就是一个特定范围内的产生均匀分布的常见例子，如图 2-1 所示。

**图 2-1** 随机分布模拟单个骰子

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b04e51d028d14f1f8bc1d0cf27a4863c~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=1205&h=289&s=15500&e=png&b=fefefe)

-   `GKGaussianDistribution`类将提供了一个高斯分布（又称正态分布）模型，如图 2-2 所示。在一个正态分布中，处于中间值（均值）的结果出现的概率最高，而更大值或更小值的结果出现的概率更低。这种分布是对称的：无论是高于或低于平均值，平均值距离相同的结果的发生概率都是一样的。

**图 2-2** 高斯分布相当于多个骰子投掷的结果

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e3a3509cc9e842b6813897f150210540~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=1076&h=424&s=44459&e=png&b=fefefe)

-   高斯分布出现在许多你可能模拟在游戏中的真实世界的现象。例如：

    -   **多个骰子投掷。** 如果一个角色扮演游戏利用投掷三个六面骰子（通常简称3D6）来计算一击的伤害，你可以在游戏中击中最常造成 9 到 13 点伤害的前提下安全的平衡其他变量。
    -   **玩家投掷飞镖。** 每个飞镖击中 X 或者 Y 坐标是均匀分布的，这导致了飞镖将在飞镖盘的中心区域聚集。
    -   **随机生成个性角色。** 在身高，体重，以及其他非玩家角色的物理特性上使用正态分布，将使你的游戏人口更加真实，其中大多数人是平均身高，很高或者很矮的人则并不多见。

-   `GKShuffledDistribution`本身是均匀分布的，但随着时间推移也阻止了重复值在序列中发生，如图 2-3 所示。

-   **图 2-3** 洗牌类随机分布避免了重复出现相同值

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/15dd8e44dae942388c6a5d78664139bb~tplv-k3u1fbpfcp-jj-mark:0:0:0:0:q75.image#?w=1215&h=317&s=19948&e=png&b=fdfdfd)

## 参考

https://developer.apple.com/spritekit/

https://www.kingyeung.com/2014/05/spritekitkuai-su-ru-men/

[SpriteKit Programming Guide](https://developer.apple.com/library/prerelease/ios/documentation/GraphicsAnimation/Conceptual/SpriteKit_PG/Introduction/Introduction.html#//apple_ref/doc/uid/TP40013043)

[SpriteKit Framework Reference](https://developer.apple.com/library/prerelease/ios/documentation/SpriteKit/Reference/SpriteKitFramework_Ref/index.html#//apple_ref/doc/uid/TP40013041)

[GameplayKit Programming Guide](https://developer.apple.com/library/archive/documentation/General/Conceptual/GameplayKit_Guide/index.html#//apple_ref/doc/uid/TP40015172)

## Sample Code
-   [SpriteKitShowCase - 本文项目的源码](https://github.com/ilordhalo/SpriteKitShowCase)
-   [Boxes: GameplayKit Entity-Component Basics](https://developer.apple.com/library/archive/samplecode/Boxes_GamePlayKit/Introduction/Intro.html#//apple_ref/doc/uid/TP40016459)
-   [AgentsCatalog: Using the Agents System in GameplayKit](https://developer.apple.com/library/archive/samplecode/AgentsCatalog/Introduction/Intro.html#//apple_ref/doc/uid/TP40016141)
-   [DemoBots: Building a Cross Platform Game with SpriteKit and GameplayKit](https://developer.apple.com/library/archive/samplecode/DemoBots/Introduction/Intro.html#//apple_ref/doc/uid/TP40015179)
