# Preview 启动方式说明

## 📋 所有可用的启动命令

### 🚀 标准启动方式

#### 1. `npm start`
**完整的 FLP 预览模式**
```bash
npm start
```
- ✅ 在 Fiori Launchpad 中运行
- ✅ 模拟真实的 Launchpad 环境
- ✅ 包含磁贴和导航
- 📂 打开：`test/flp.html#app-preview`
- 🎯 **推荐用于**：测试应用在 Launchpad 中的表现

#### 2. `npm run start-local`
**本地配置启动**
```bash
npm run start-local
```
- ✅ 使用 ui5-local.yaml 配置
- ✅ 包含本地框架库
- ✅ FLP 模式
- 📂 打开：`test/flp.html#app-preview`
- 🎯 **推荐用于**：本地开发，无需后端连接

#### 3. `npm run start-noflp`
**独立模式（无 FLP）**
```bash
npm run start-noflp
```
- ✅ 直接打开应用
- ✅ 不包含 Launchpad 外壳
- ✅ 禁用视图缓存
- 📂 打开：`/index.html?sap-ui-xx-viewCache=false`
- 🎯 **推荐用于**：快速开发和调试

#### 4. `npm run start-mock`
**Mock 数据模式**
```bash
npm run start-mock
```
- ✅ 使用 Mock 服务器
- ✅ 模拟 OData 服务
- ✅ FLP 模式
- 📂 打开：`test/flp.html#app-preview`
- 🎯 **推荐用于**：前端开发，无需真实后端

---

### 🎨 Preview 专用启动方式

#### 5. `npm run preview` ⭐
**标准 Preview 模式**
```bash
npm run preview
```
- ✅ 使用 Fiori Tools Preview 功能
- ✅ 支持 RTA（运行时适配）
- ✅ 轻量级 Launchpad
- 📂 打开：`preview.html`
- 🎯 **推荐用于**：日常开发和预览

#### 6. `npm run preview-flp`
**FLP Preview 模式**
```bash
npm run preview-flp
```
- ✅ 完整的 FLP 环境
- ✅ 包含所有 Launchpad 特性
- 📂 打开：`test/flp.html#app-preview`
- 🎯 **推荐用于**：测试 FLP 集成

#### 7. `npm run preview-standalone`
**独立 Preview 模式**
```bash
npm run preview-standalone
```
- ✅ 纯应用预览
- ✅ 无 Launchpad 外壳
- ✅ 最快的启动速度
- 📂 打开：`index.html`
- 🎯 **推荐用于**：专注应用本身的开发

#### 8. `npm run preview-adaptation` ⭐⭐⭐
**UI 适配模式**
```bash
npm run preview-adaptation
```
- ✅ 启用 RTA（Runtime Adaptation）
- ✅ 可视化编辑 UI
- ✅ 支持 UI 适配和变体管理
- ✅ 跳过 Flex 验证
- 📂 打开：`preview.html?fiori-tools-rta-mode=true&sap-ui-rta-skip-flex-validation=true`
- 🎯 **推荐用于**：UI 设计和适配工作

#### 9. `npm run preview-variants`
**变体管理模式**
```bash
npm run preview-variants
```
- ✅ 支持视图变体
- ✅ 用户个性化设置
- ✅ 轻量级预览
- 📂 打开：`preview.html#app-preview`
- 🎯 **推荐用于**：测试变体管理功能

#### 10. `npm run preview-local`
**本地 Preview 模式**
```bash
npm run preview-local
```
- ✅ 使用本地 UI5 库
- ✅ Preview 页面
- ✅ 离线开发
- 📂 打开：`preview.html`
- 🎯 **推荐用于**：无网络或内网环境

#### 11. `npm run preview-mock`
**Mock Preview 模式**
```bash
npm run preview-mock
```
- ✅ Mock 服务器 + Preview
- ✅ 模拟后端数据
- 📂 打开：`preview.html`
- 🎯 **推荐用于**：前端开发和演示

---

## 🏗️ 构建和部署命令

### 构建

#### `npm run build`
**标准构建**
```bash
npm run build
```
- 输出目录：`dist/`
- 清理目标目录
- 使用 ui5.yaml 配置

#### `npm run build-opt`
**优化构建**
```bash
npm run build-opt
```
- 包含所有依赖
- 自包含构建
- 适合生产环境

### 部署

#### `npm run deploy`
**部署到 SAP**
```bash
npm run deploy
```
- 先构建再部署
- 使用 ui5-deploy.yaml 配置
- 部署到配置的 SAP 系统

#### `npm run deploy-test`
**测试模式部署**
```bash
npm run deploy-test
```
- 测试模式
- 不实际部署
- 验证部署配置

#### `npm run undeploy`
**从 SAP 卸载**
```bash
npm run undeploy
```
- 从 SAP 系统移除应用

---

## 🧪 测试命令

#### `npm run unit-test`
**单元测试**
```bash
npm run unit-test
```
- 运行 QUnit 单元测试
- 打开：`test/unit/unitTests.qunit.html`

#### `npm run int-test`
**集成测试**
```bash
npm run int-test
```
- 运行 OPA5 集成测试
- 打开：`test/integration/opaTests.qunit.html`

---

## 🔍 代码质量命令

#### `npm run lint`
**代码检查**
```bash
npm run lint
```
- ESLint 代码检查
- 检查代码规范

#### `npm run ts-typecheck`
**TypeScript 类型检查**
```bash
npm run ts-typecheck
```
- 检查 TypeScript 类型错误
- 不生成输出文件

---

## 💡 VSCode 集成

### 在 VSCode 中使用

#### 方法 1：使用命令面板
1. 按 `Ctrl+Shift+P`（Windows）或 `Cmd+Shift+P`（Mac）
2. 输入 "Tasks: Run Task"
3. 选择 "npm: preview"（或其他 preview 命令）

#### 方法 2：使用 NPM Scripts 面板
1. 打开 Explorer（资源管理器）
2. 展开 "NPM SCRIPTS" 面板
3. 点击相应的脚本名称旁的播放按钮

#### 方法 3：在终端中直接运行
1. 打开集成终端：`` Ctrl+` ``
2. 运行命令：`npm run preview`

### 创建快捷方式（可选）

在 `.vscode/tasks.json` 中添加：

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "type": "npm",
      "script": "preview",
      "label": "Preview: 标准模式",
      "problemMatcher": [],
      "presentation": {
        "reveal": "always",
        "panel": "new"
      }
    },
    {
      "type": "npm",
      "script": "preview-adaptation",
      "label": "Preview: UI 适配模式",
      "problemMatcher": [],
      "presentation": {
        "reveal": "always",
        "panel": "new"
      }
    },
    {
      "type": "npm",
      "script": "start",
      "label": "Start: FLP 模式",
      "problemMatcher": [],
      "presentation": {
        "reveal": "always",
        "panel": "new"
      }
    }
  ]
}
```

---

## 📊 启动方式对比表

| 命令 | FLP | Preview | RTA | Mock | 本地库 | 速度 | 推荐场景 |
|------|-----|---------|-----|------|--------|------|----------|
| `start` | ✅ | ❌ | ❌ | ❌ | ❌ | ⭐⭐⭐ | 标准开发 |
| `start-local` | ✅ | ❌ | ❌ | ❌ | ✅ | ⭐⭐ | 本地开发 |
| `start-noflp` | ❌ | ❌ | ❌ | ❌ | ❌ | ⭐⭐⭐⭐⭐ | 快速调试 |
| `start-mock` | ✅ | ❌ | ❌ | ✅ | ❌ | ⭐⭐⭐ | 前端开发 |
| `preview` | ⚡ | ✅ | ❌ | ❌ | ❌ | ⭐⭐⭐⭐ | 日常预览 |
| `preview-flp` | ✅ | ✅ | ❌ | ❌ | ❌ | ⭐⭐⭐ | FLP 测试 |
| `preview-standalone` | ❌ | ✅ | ❌ | ❌ | ❌ | ⭐⭐⭐⭐⭐ | 应用开发 |
| `preview-adaptation` | ⚡ | ✅ | ✅ | ❌ | ❌ | ⭐⭐⭐ | UI 设计 |
| `preview-variants` | ⚡ | ✅ | ❌ | ❌ | ❌ | ⭐⭐⭐⭐ | 变体管理 |
| `preview-local` | ⚡ | ✅ | ❌ | ❌ | ✅ | ⭐⭐ | 离线开发 |
| `preview-mock` | ⚡ | ✅ | ❌ | ✅ | ❌ | ⭐⭐⭐ | Mock 预览 |

**图例**：
- ✅ = 完整支持
- ⚡ = 轻量级 FLP
- ❌ = 不支持
- 速度：⭐ (慢) 到 ⭐⭐⭐⭐⭐ (快)

---

## 🎯 推荐的工作流程

### 日常开发
```bash
npm run preview              # 快速预览
npm run preview-standalone   # 专注应用开发
```

### UI 设计和适配
```bash
npm run preview-adaptation   # 启用 RTA 功能
```

### 测试 FLP 集成
```bash
npm start                    # 完整 FLP 环境
npm run preview-flp          # Preview 模式的 FLP
```

### 前端开发（无后端）
```bash
npm run start-mock           # Mock 数据 + FLP
npm run preview-mock         # Mock 数据 + Preview
```

### 本地/离线开发
```bash
npm run start-local          # 本地库 + FLP
npm run preview-local        # 本地库 + Preview
```

### 生产部署前
```bash
npm run build                # 构建
npm run deploy-test          # 测试部署
npm run deploy               # 正式部署
```

---

## ⚙️ 配置文件说明

- **ui5.yaml** - 标准开发配置，连接到 SAP 后端
- **ui5-local.yaml** - 本地开发配置，使用本地 SAPUI5 库
- **ui5-mock.yaml** - Mock 服务器配置，模拟 OData 服务
- **ui5-deploy.yaml** - 部署到 ABAP 系统的配置

---

## 🔧 故障排除

### 问题 1: Preview 页面无法打开

**解决方案**：
```bash
# 确保 preview.html 存在
ls webapp/preview.html

# 如果不存在，文件已自动创建
```

### 问题 2: FLP 无法加载应用

**检查**：
- `test/flp.html` 文件是否存在
- `manifest.json` 中的 `sap.app.id` 是否正确
- Component.js 是否正确加载

### 问题 3: RTA 模式无法启动

**解决方案**：
- 确保已安装 `@sap/ux-ui5-tooling`
- 检查 ui5.yaml 中的 fiori-tools-preview 配置

### 问题 4: Mock 服务器不工作

**检查**：
- ui5-mock.yaml 中的 sap-fe-mockserver 配置
- localService 目录和文件是否存在

---

## 📚 相关资源

- [SAP Fiori Tools](https://help.sap.com/docs/SAP_FIORI_tools)
- [UI5 Tooling](https://sap.github.io/ui5-tooling/)
- [SAPUI5 SDK](https://sapui5.hana.ondemand.com/)

---

## 💬 快速参考

最常用的命令：

```bash
# 开发阶段
npm run preview                    # 日常预览 ⭐⭐⭐⭐⭐

# UI 设计
npm run preview-adaptation         # UI 适配

# 调试
npm run start-noflp               # 快速启动

# 部署
npm run deploy                    # 部署到 SAP
```

享受开发！🎉
