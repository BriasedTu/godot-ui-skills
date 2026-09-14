# Godot UI Skills

面向 **Godot 原生游戏 UI 与动效开发**的技能集合，改编自
[emilkowalski/skills](https://github.com/emilkowalski/skills)。

保留原仓库的工作流：**发现机会 → 准确描述 → 比较原型 → 实现动效 →
审查 → 全局审计与改进计划 → 执行与复核**。所有技能的技术选择、示例、
参考资料和验证步骤均面向 Godot；不需要前端项目、网页动效库或移动端前端框架。
不包含任何特定游戏的美术、玩法或架构约束。

English: a native Godot adaptation of Emil Kowalski's interface craft workflows.
Twelve independently installable skills, native GDScript examples, and executable
lifecycle checks. Project conventions and the user's brief take priority.

## 技能与工作流

| 技能 | 使用场景 |
| --- | --- |
| [godot-design-engineering](skills/godot-design-engineering/SKILL.md) | UI 整体打磨：排版、层级、组件、反馈与动效协同 |
| [godot-find-animation-opportunities](skills/godot-find-animation-opportunities/SKILL.md) | 只读发现值得增加动效的位置，同时筛掉无益装饰 |
| [godot-animation-vocabulary](skills/godot-animation-vocabulary/SKILL.md) | 把模糊的运动描述变成准确术语 |
| [godot-prototype](skills/godot-prototype/SKILL.md) | 原生选择器内比较多个真实可交互方案，选择后再整合 |
| [godot-animate](skills/godot-animate/SKILL.md) | 按目的、工具、属性、曲线、中断、退出和验证顺序实现 |
| [godot-animate-mobile](skills/godot-animate-mobile/SKILL.md) | 触摸、拖拽、安全区、虚拟键盘、可选触觉反馈 |
| [godot-fluid-interface-design](skills/godot-fluid-interface-design/SKILL.md) | 直接操作、速度连续性、惯性、空间关系与流畅反馈 |
| [godot-review-animations](skills/godot-review-animations/SKILL.md) | 审查具体改动，按证据提出问题和结论 |
| [godot-improve-animations](skills/godot-improve-animations/SKILL.md) | 全局审计、排序、独立计划、执行和状态复核 |
| [godot-pick-ui-component](skills/godot-pick-ui-component/SKILL.md) | 选择原生控件、动效工具或必要的兼容插件 |
| [godot-write-gdscript](skills/godot-write-gdscript/SKILL.md) | 编写符合版本、资源与场景生命周期的 GDScript |
| [godot-notifications](skills/godot-notifications/SKILL.md) | 通知、消息堆叠、加载结果更新与过期生命周期 |

`godot-prototype` 与 `godot-pick-ui-component` 保留显式调用策略；其他技能
默认允许自动匹配。各技能的参考文件和资产都包含在自己的文件夹中，单独安装
不会依赖另一个技能目录。文中命名的其他技能是可选衔接。

## 获取与使用

使用有访问权限的 GitHub 身份克隆私有仓库：

```text
git clone https://github.com/BriasedTu/godot-ui-skills.git
```

将所需的 `skills/godot-*` **完整文件夹**复制到所用智能体配置的技能目录，
或使用该智能体支持的本地技能安装功能。保留参考文件、资产和 LICENSE。
无需运行依赖安装命令；示例只需要 Godot，仓库检查脚本只需要 Python 3.10+。

调用示例：

```text
用 $godot-animate 给物品栏增加键盘和手柄焦点反馈，快速切换时不能排队。
用 $godot-prototype 比较三种奖励面板的入场方式，提供原生选择器。
用 $godot-review-animations 审查这个面板在关闭途中再次打开的处理。
用 $godot-improve-animations 审计现有 UI，先给出前三项改进计划，不改游戏代码。
```

## 原生适配的关键区别

- 以 `Control`、`Container`、`Theme`、`Tween`、`AnimationPlayer` 和原生输入
  为基础；按需要选择材质、3D 表现或经过验证的弹簧实现。
- 高频键盘/手柄操作可以有短促反馈，语义状态与输入立即更新。
- 时长和曲线是调试起点，尊重项目规范；奖励、叙事与普通控件分别考虑节奏。
- 明确布局所有权、属性写入者、动画中断、节点销毁、暂停与时间倍率。
- 减少动态效果保留必要状态提示，并处理播放途中切换偏好的情况。
- 审查依据真实后果与证据，避免因“只淡入”“用了内置曲线”等直接否决。
- 审计和计划模式不改游戏源代码；明确要求执行时再进入实现与验证。

## 可运行示例与验证

使用 Godot 打开以下任一独立项目：

- [Motion Lab](skills/godot-animate/assets/motion-lab/project.godot)：原生按钮、
  稳定点击区域、可反向切换的面板、暂停和减少动态效果。
- [Prototype Lab](skills/godot-prototype/assets/prototype-lab/project.godot)：
  三种入场方向、原生选择器、重播和局部慢放。

技能指导先检查目标项目的版本。附带示例以 **Godot 4.6** 为基线，实际使用
**4.6.1** 验证；不承诺所有旧版本都支持示例 API，也不要求目标项目升级。

```text
python tools/validate_skills.py
python tools/verify.py --godot <Godot可执行文件路径>
python tools/verify.py --godot <Godot可执行文件路径> --capture
```

最后一项需要实际图形环境，会启动示例并保存视口画面。当前测试与限制见
[验证记录](docs/validation.md)。日志和生成截图保存在被忽略的 `reports/`。
示例是工作流验证素材，不能代替每个游戏的实际视觉验收与设备测试。

## 来源与授权

基于上游提交 `d23d7f88a2e21c9e4b1418c7abe420f5c1052ba7` 改编。
保留原作者 Emil Kowalski 的 [MIT 许可证](LICENSE) 和 Git 历史。
[改编映射](UPSTREAM.md) 记录原有 12 个技能的对应去向。
这是独立的 Godot 衍生项目，不代表原作者或 Godot 官方背书。
