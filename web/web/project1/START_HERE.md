# 🚀 快速开始 - 从这里开始！

## ✅ 配置完成！

你的项目已经配置好了完整的 Preview 启动功能！

---

## ⚡ 3 步立即开始

### 步骤 1：确保依赖已安装

```bash
npm install
```

### 步骤 2：选择一种启动方式

**推荐方式**：在 VSCode NPM Scripts 面板点击 ▶️

1. 打开左侧 **Explorer**（资源管理器）
2. 滚动到 **NPM SCRIPTS** 面板
3. 展开 **zzabaplint**
4. 找到 **preview** 脚本
5. 点击右侧的 **▶️ 播放按钮**

**或者在终端运行**：

```bash
npm run preview
```

### 步骤 3：开始开发！

浏览器会自动打开应用，你可以：
- 编辑代码 → 自动刷新
- 使用 F12 打开开发者工具
- 按 F5 启动调试模式

---

## 🎯 最常用的 5 个命令

```bash
# 1. 日常开发（最推荐）⭐⭐⭐⭐⭐
npm run preview

# 2. UI 设计和调整
npm run preview-adaptation

# 3. 快速调试（最快启动）
npm run preview-standalone

# 4. 完整 FLP 环境测试
npm start

# 5. 前端开发（无需后端）
npm run preview-mock
```

---

## 📚 详细文档

需要更多信息？查看这些文档：

| 文档 | 内容 | 推荐指数 |
|------|------|----------|
| **VSCode_Preview_Guide.md** | VSCode 集成使用指南 | ⭐⭐⭐⭐⭐ |
| **PREVIEW_MODES.md** | 所有启动方式详解 | ⭐⭐⭐⭐ |
| **CHANGES.md** | 本次更新说明 | ⭐⭐⭐ |
| **README.md** | 项目完整文档 | ⭐⭐⭐ |
| **TROUBLESHOOTING.md** | 问题诊断指南 | ⭐⭐ |

**建议阅读顺序**：
1. 🔵 先看 `VSCode_Preview_Guide.md` - 学会在 VSCode 中操作
2. 🟢 再看 `PREVIEW_MODES.md` - 了解所有功能
3. 🔴 遇到问题看 `TROUBLESHOOTING.md` - 解决问题

---

## 🎨 VSCode 中的快捷操作

### 方法 1：NPM Scripts 面板（最简单）

```
Explorer
└── NPM SCRIPTS
    └── zzabaplint
        ├── preview ← 点这里！⭐
        ├── preview-adaptation
        ├── preview-standalone
        └── start
```

### 方法 2：快捷键

- `Ctrl+Shift+B` - 运行默认任务（FLP 模式）
- `Ctrl+Shift+P` → "Tasks: Run Task" → 选择任务
- `F5` - 启动调试模式

### 方法 3：终端命令

- `` Ctrl+` `` 打开终端
- 输入 `npm run preview`
- 回车运行

---

## 💡 使用场景推荐

| 场景 | 推荐命令 | 方式 |
|------|---------|------|
| 日常开发 | `preview` | NPM Scripts 点击 ▶️ |
| UI 设计 | `preview-adaptation` | NPM Scripts 点击 ▶️ |
| 快速调试 | `preview-standalone` | 终端或 F5 |
| FLP 测试 | `start` | Ctrl+Shift+B |
| 前端开发 | `preview-mock` | NPM Scripts 点击 ▶️ |

---

## 🔥 推荐工作流

### 标准开发流程：

1. **启动应用**
   - 在 NPM Scripts 点击 `preview` ▶️
   - 或运行：`npm run preview`

2. **启用自动保存**
   - `File` → `Auto Save`
   - 或按 `Ctrl+Shift+P` → "File: Toggle Auto Save"

3. **编辑代码**
   - 修改 TypeScript/XML/CSS 文件
   - 浏览器自动刷新
   - 查看效果

4. **调试问题**
   - 按 `F5` 启动调试
   - 设置断点
   - 逐步调试

5. **UI 调整**
   - 切换到 `preview-adaptation` 模式
   - 在浏览器中拖拽调整
   - 保存更改

6. **测试和部署**
   - 运行 `npm run build`
   - 运行 `npm run deploy`
   - 或使用 VSCode Fiori Tools 扩展

---

## ⚠️ 常见问题快速解决

### Q: 点击 NPM Scripts 没反应？
**A**: 运行 `npm install` 安装依赖

### Q: 浏览器没自动打开？
**A**: 手动打开 http://localhost:8080/preview.html

### Q: 页面显示空白？
**A**: 
1. 按 F12 查看控制台错误
2. 清除浏览器缓存（Ctrl+Shift+Delete）
3. 重启开发服务器

### Q: 端口 8080 被占用？
**A**: 
1. 查看终端输出的实际端口号
2. 或关闭占用 8080 的程序

---

## 📊 对比：不同启动方式

| 模式 | 启动速度 | FLP | RTA | 适合场景 |
|------|---------|-----|-----|----------|
| preview | ⚡⚡⚡⚡ | 轻量 | ✅ | 日常开发 |
| preview-adaptation | ⚡⚡⚡ | 轻量 | ✅✅✅ | UI 设计 |
| preview-standalone | ⚡⚡⚡⚡⚡ | ❌ | ❌ | 快速调试 |
| start | ⚡⚡⚡ | ✅✅✅ | ❌ | FLP 测试 |
| preview-mock | ⚡⚡⚡⚡ | 轻量 | ✅ | 前端开发 |

---

## 🎁 额外功能

### VSCode 调试（F5）

按 F5 启动调试，可以：
- ✅ 在代码中设置断点
- ✅ 查看变量值
- ✅ 单步执行
- ✅ 调用堆栈分析

### 任务菜单（Ctrl+Shift+P）

输入 "Tasks: Run Task"，可以看到所有任务：
- ✅ 带图标的任务名称
- ✅ 详细的任务描述
- ✅ 分类组织

### 默认任务（Ctrl+Shift+B）

一键启动 FLP 完整模式

---

## 🎓 学习路径

### 新手：
1. ✅ 运行 `npm install`
2. ✅ 在 NPM Scripts 点击 `preview` ▶️
3. ✅ 看到应用打开
4. ✅ 开始编辑代码

### 进阶：
1. ✅ 阅读 `VSCode_Preview_Guide.md`
2. ✅ 尝试不同的启动模式
3. ✅ 学习使用 F5 调试
4. ✅ 自定义任务和快捷键

### 高级：
1. ✅ 阅读 `PREVIEW_MODES.md`
2. ✅ 自定义 `.vscode/tasks.json`
3. ✅ 配置 `.vscode/launch.json`
4. ✅ 优化工作流程

---

## 🌟 核心优势

✅ **11 种启动方式** - 覆盖所有场景  
✅ **图形界面操作** - NPM Scripts 一键启动  
✅ **快捷键支持** - Ctrl+Shift+B、F5  
✅ **完整文档** - 详细的使用指南  
✅ **调试支持** - Chrome DevTools 集成  
✅ **热重载** - 自动刷新浏览器  

---

## 🚀 现在就开始！

### 方式 1：最快开始（推荐）

1. 打开 VSCode
2. 在左侧 NPM SCRIPTS 面板
3. 点击 **preview** 旁的 ▶️
4. 等待浏览器打开
5. 开始编码！

### 方式 2：命令行方式

```bash
# 在终端运行
npm run preview
```

### 方式 3：调试方式

1. 按 `F5`
2. 或点击左侧调试图标
3. 选择配置并启动

---

## 📞 需要帮助？

- 🔵 **VSCode 使用** → `VSCode_Preview_Guide.md`
- 🟢 **命令详解** → `PREVIEW_MODES.md`
- 🔴 **遇到问题** → `TROUBLESHOOTING.md`
- 🟡 **本次更新** → `CHANGES.md`

---

## ✨ 快速参考卡片

```
┌──────────────────────────────────────┐
│  最快开始的 3 种方法                 │
├──────────────────────────────────────┤
│  1. NPM Scripts 面板 → preview ▶️    │
│  2. 终端: npm run preview            │
│  3. 快捷键: Ctrl+Shift+B             │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│  最常用命令                          │
├──────────────────────────────────────┤
│  npm run preview         日常开发    │
│  npm run preview-adaptation UI设计  │
│  npm run preview-standalone 快速调试│
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│  VSCode 快捷键                       │
├──────────────────────────────────────┤
│  Ctrl+Shift+B    默认任务            │
│  F5              调试模式            │
│  Ctrl+`          打开终端            │
│  Ctrl+Shift+P    命令面板            │
└──────────────────────────────────────┘
```

---

**现在就开始开发吧！** 🎉

如有疑问，查看 `VSCode_Preview_Guide.md` 获取详细指导。
