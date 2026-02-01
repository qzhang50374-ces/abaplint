# 📋 Preview 配置更新说明

## ✅ 已完成的更改

### 1. package.json - 添加 Preview 启动脚本

**文件**：`package.json`

**新增的脚本**：

```json
"preview": "fiori run --open \"preview.html\"",
"preview-flp": "fiori run --open \"test/flp.html#app-preview\"",
"preview-standalone": "fiori run --open \"index.html\"",
"preview-adaptation": "fiori run --open \"preview.html?fiori-tools-rta-mode=true&sap-ui-rta-skip-flex-validation=true\"",
"preview-variants": "fiori run --open \"preview.html#app-preview\"",
"preview-local": "fiori run --config ./ui5-local.yaml --open \"preview.html\"",
"preview-mock": "fiori run --config ./ui5-mock.yaml --open \"preview.html\"",
"build-opt": "ui5 build --config=ui5.yaml --clean-dest --dest dist --all"
```

**共计新增**：8 个 Preview 相关脚本

---

### 2. webapp/preview.html - Fiori Tools Preview 页面

**文件**：`webapp/preview.html` (新建)

**功能**：
- ✅ 轻量级 Fiori Launchpad Shell
- ✅ 支持 RTA（Runtime Adaptation）
- ✅ 快速启动和热重载
- ✅ 开发者友好的预览环境

**配置要点**：
```html
- SAPUI5 1.120.0
- sap_horizon 主题
- 启用 sap.ushell 库
- 配置语义对象：app-preview
- 支持 RTA 和个性化插件
```

---

### 3. webapp/test/flp.html - FLP Sandbox 页面

**文件**：`webapp/test/flp.html` (新建)

**功能**：
- ✅ 完整的 Fiori Launchpad Sandbox
- ✅ 模拟真实 Launchpad 环境
- ✅ 包含磁贴和分组
- ✅ 完整的导航支持

**配置要点**：
```html
- 完整的 FLP 配置
- 磁贴配置（图标、标题、子标题）
- 客户端目标解析
- 语义对象和动作映射
```

---

### 4. .vscode/tasks.json - VSCode 任务配置

**文件**：`.vscode/tasks.json` (新建)

**新增任务**：20+ 个预配置任务

**分类**：

**Preview 任务**（7个）：
- ▶️ Preview: 标准预览
- 🎨 Preview: UI 适配模式
- ⚡ Preview: 独立模式
- 🚀 Preview: FLP 模式
- 📊 Preview: 变体管理
- 💻 Preview: 本地模式
- 🎭 Preview: Mock 模式

**Start 任务**（4个）：
- 🏠 Start: FLP 完整模式（默认任务）
- 🏠 Start: 本地配置
- ⚡ Start: 独立模式
- 🎭 Start: Mock 数据

**构建任务**（2个）：
- 📦 Build: 标准构建
- 📦 Build: 优化构建

**部署任务**（2个）：
- 🚢 Deploy: 部署到 SAP
- 🧪 Deploy: 测试部署

**代码质量任务**（2个）：
- 🔍 Lint: 代码检查
- 🔍 TypeScript: 类型检查

**测试任务**（2个）：
- 🧪 Test: 单元测试
- 🧪 Test: 集成测试

**特性**：
- ✅ 带图标的任务名称（易识别）
- ✅ 详细的任务描述
- ✅ 独立的终端面板
- ✅ 合理的默认设置
- ✅ 问题匹配器（ESLint、TSC）

---

### 5. .vscode/launch.json - VSCode 调试配置

**文件**：`.vscode/launch.json` (新建)

**新增配置**：5 个调试配置

**配置列表**：

1. **🚀 Launch: Preview**
   - 启动标准 Preview
   - URL: `http://localhost:8080/preview.html`
   - 自动启动服务器

2. **🎨 Launch: Preview with RTA**
   - 启动 RTA 模式
   - URL: `http://localhost:8080/preview.html?fiori-tools-rta-mode=true`
   - 支持可视化 UI 编辑

3. **🏠 Launch: FLP**
   - 启动 FLP 模式
   - URL: `http://localhost:8080/test/flp.html#app-preview`
   - 完整 Launchpad 环境

4. **⚡ Launch: Standalone**
   - 独立模式
   - URL: `http://localhost:8080/index.html`
   - 最快启动

5. **🔗 Attach: Chrome**
   - 附加到运行中的 Chrome
   - 端口：9222
   - 用于调试已启动的应用

**特性**：
- ✅ Chrome DevTools 集成
- ✅ 断点调试支持
- ✅ 自动启动前置任务
- ✅ 禁用 Web 安全（开发用）
- ✅ 独立的用户数据目录

---

### 6. PREVIEW_MODES.md - 启动方式完整文档

**文件**：`PREVIEW_MODES.md` (新建)

**内容**：
- ✅ 所有启动命令的详细说明
- ✅ 使用场景推荐
- ✅ VSCode 集成说明
- ✅ 对比表格
- ✅ 故障排除
- ✅ 配置文件说明
- ✅ 相关资源链接

---

### 7. VSCode_Preview_Guide.md - VSCode 使用指南

**文件**：`VSCode_Preview_Guide.md` (新建)

**内容**：
- ✅ 5 种 VSCode 启动方法
- ✅ 图文并茂的操作指南
- ✅ 使用场景推荐
- ✅ 小技巧和最佳实践
- ✅ 快捷键参考
- ✅ 常见问题解答
- ✅ 快速参考卡片

---

## 📊 更新统计

| 类型 | 数量 | 说明 |
|------|------|------|
| 新增文件 | 6 | preview.html, flp.html, tasks.json, launch.json, 2个文档 |
| 更新文件 | 1 | package.json |
| 新增脚本 | 8 | Preview 相关的 npm scripts |
| VSCode 任务 | 20+ | 可在 VSCode 中直接运行 |
| 调试配置 | 5 | 可用 F5 启动调试 |
| 文档页数 | 100+ | 详细的使用说明 |

---

## 🎯 现在你可以做什么

### 在 VSCode 中：

1. **使用 NPM Scripts 面板**
   - 打开左侧 Explorer
   - 找到 NPM SCRIPTS
   - 点击 "preview" 旁边的 ▶️ 按钮
   - ✨ 浏览器自动打开应用

2. **使用任务菜单**
   - 按 `Ctrl+Shift+P`
   - 输入 "Tasks: Run Task"
   - 选择 "▶️ Preview: 标准预览"
   - ✨ 应用启动

3. **使用默认任务**
   - 按 `Ctrl+Shift+B`
   - ✨ 默认 FLP 模式启动

4. **使用调试功能**
   - 按 `F5`
   - 或点击左侧调试图标
   - 选择配置并启动
   - ✨ 带调试器启动应用

5. **使用终端**
   - 按 `` Ctrl+` `` 打开终端
   - 输入 `npm run preview`
   - ✨ 应用启动

---

## 📖 推荐阅读顺序

### 新用户：
1. **VSCode_Preview_Guide.md** - 快速上手 VSCode 操作
2. **PREVIEW_MODES.md** - 了解所有启动方式
3. 开始使用！

### 进阶用户：
1. **PREVIEW_MODES.md** - 详细命令参考
2. **.vscode/tasks.json** - 自定义任务
3. **.vscode/launch.json** - 自定义调试配置

---

## 🔧 配置文件关系图

```
project1/
├── package.json ──────────┐
│   └── scripts 定义       │
│                          ↓
├── .vscode/              调用
│   ├── tasks.json ────┐   │
│   │   └── 任务定义    │   │
│   │                  ↓   ↓
│   └── launch.json    启动服务器
│       └── 调试配置    ↓
│                       ↓
└── webapp/            访问页面
    ├── preview.html ←─┘
    ├── index.html
    └── test/
        └── flp.html
```

---

## 🌟 核心改进

### Before（之前）：
```bash
# 只能在终端运行
npm start
npm run start-local
npm run start-noflp
```

### After（现在）：
```bash
# 终端命令（11 种方式）
npm run preview              # + 7 种新的 preview 方式
npm run preview-adaptation
npm run preview-standalone
# ... 等等

# VSCode 图形界面（20+ 任务）
- NPM Scripts 面板一键启动 ✨
- 任务菜单选择 ✨
- 快捷键 Ctrl+Shift+B ✨
- F5 调试启动 ✨

# 完整文档
- 详细使用指南 ✨
- 故障排除 ✨
- 快速参考 ✨
```

---

## 💡 最佳实践

### 日常开发推荐流程：

1. **启动应用**
   ```bash
   npm run preview
   ```
   或在 NPM Scripts 面板点击 preview ▶️

2. **编辑代码**
   - 启用自动保存：`File` → `Auto Save`
   - 修改代码会自动刷新浏览器

3. **调试问题**
   - 按 `F5` 启动调试模式
   - 在代码中设置断点
   - 在浏览器中触发功能
   - 断点会在 VSCode 中命中

4. **UI 调整**
   ```bash
   npm run preview-adaptation
   ```
   - 在浏览器中直接拖拽调整 UI
   - 修改会保存到项目中

5. **测试 FLP 集成**
   ```bash
   npm start
   ```
   - 测试在 Launchpad 中的表现
   - 验证磁贴和导航

6. **构建部署**
   ```bash
   npm run build
   npm run deploy
   ```
   - 或使用 VSCode Fiori Tools 扩展部署

---

## 🎓 学习资源

| 资源 | 位置 | 内容 |
|------|------|------|
| VSCode 使用指南 | VSCode_Preview_Guide.md | VSCode 集成使用 |
| 启动方式详解 | PREVIEW_MODES.md | 所有命令详解 |
| 项目文档 | README.md | 项目整体说明 |
| 问题诊断 | TROUBLESHOOTING.md | 故障排除 |
| 快速开始 | QUICKSTART.md | 快速上手 |

---

## ✨ 总结

你的项目现在拥有：

✅ **11 种启动方式** - 覆盖所有开发场景  
✅ **20+ VSCode 任务** - 图形界面操作  
✅ **5 种调试配置** - F5 一键调试  
✅ **完整文档** - 详细的使用指南  
✅ **最佳实践** - 推荐的工作流程  

**下一步**：打开 `VSCode_Preview_Guide.md`，按照指南开始使用！

---

**更新日期**：2026-01-28  
**版本**：1.0.0  
**状态**：✅ 完成
