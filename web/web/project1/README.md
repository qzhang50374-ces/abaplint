# ABAP Lint Editor - Fiori Application

这是一个将 ABAP Lint Playground 移植为 SAP Fiori 应用的项目，可以部署到 SAP Launchpad。

## 功能特性

- 基于 Monaco Editor 的 ABAP 代码编辑器
- 支持多文件标签编辑
- 实时语法检查和问题显示
- 支持 ABAP、JSON、CDS 等多种文件格式
- 符合 SAP Fiori 设计规范

## 项目结构

```
project1/
├── webapp/
│   ├── controller/          # 控制器
│   │   └── Main.controller.js
│   ├── view/               # 视图
│   │   └── Main.view.xml
│   ├── model/              # 模型
│   │   └── models.js
│   ├── utils/              # 工具类
│   │   ├── MonacoLoader.js # Monaco Editor 加载器
│   │   └── FileSystem.js   # 文件系统管理
│   ├── css/                # 样式
│   │   └── style.css
│   ├── i18n/               # 国际化
│   │   └── i18n.properties
│   ├── manifest.json       # 应用描述符
│   ├── Component.js        # 组件定义
│   ├── index.html          # 入口页面
│   └── xs-app.json         # 路由配置
├── ui5.yaml               # UI5 工具配置
├── ui5-deploy.yaml        # 部署配置
├── ui5-local.yaml         # 本地配置
└── package.json           # npm 依赖

```

## 安装和运行

### 前置条件

- Node.js (>= 18.x)
- npm (>= 9.x)
- SAP UI5 CLI

### 安装依赖

```bash
cd web/project1
npm install
```

### 本地开发

```bash
npm start
```

应用将在浏览器中自动打开，默认地址：http://localhost:8080

### 构建

```bash
npm run build
```

构建输出将在 `dist` 目录中。

## 部署到 SAP Launchpad

### 使用 VSCode Fiori 扩展部署

1. 在 VSCode 中打开项目
2. 确保已安装 SAP Fiori tools 扩展
3. 右键点击项目根目录
4. 选择 "Deploy" 或使用命令面板中的部署命令
5. 按照向导配置部署参数：
   - 目标系统 URL
   - Client
   - 包名称
   - 传输请求（可选）

### 手动部署配置

修改 `ui5-deploy.yaml` 中的配置：

```yaml
target:
  url: http://your-sap-system:8000  # 你的 SAP 系统地址
  client: "100"                     # Client 号
  auth: "basic"                     # 认证方式
app:
  name: ZABAPLINT                   # BSP 应用名称
  package: $TMP                     # 包名称（建议使用自定义包）
  transport: ""                     # 传输请求号
```

然后运行：

```bash
npm run deploy
```

## Launchpad 配置

部署成功后，需要在 SAP Launchpad 中配置磁贴：

### 1. 创建语义对象和操作

在 SAP GUI 中使用事务码 `/UI2/FLPD_CONF`：

- 语义对象：`AbaplintEditor`
- 操作：`display`

### 2. 配置目标映射

- 应用 ID：`com.abaplint.editor`
- 入站 ID：创建新的入站连接

### 3. 添加到目录和组

- 创建目录并添加应用
- 将目录分配到组
- 将组分配给用户角色

### 4. manifest.json 中的 Launchpad 配置

应用的 `manifest.json` 已经包含了必要的配置，可以根据需要调整：

```json
{
  "sap.app": {
    "crossNavigation": {
      "inbounds": {
        "intent1": {
          "signature": {
            "parameters": {},
            "additionalParameters": "allowed"
          },
          "semanticObject": "AbaplintEditor",
          "action": "display",
          "title": "{{appTitle}}",
          "icon": "sap-icon://write-new-document"
        }
      }
    }
  }
}
```

## 技术栈

- SAPUI5 1.120.0
- Monaco Editor 0.52.2
- @abaplint/core
- @abaplint/monaco

## 开发说明

### 添加新功能

1. 在 `controller/Main.controller.js` 中添加业务逻辑
2. 在 `view/Main.view.xml` 中更新 UI
3. 如需新的工具类，在 `utils/` 目录中创建

### 自定义样式

编辑 `css/style.css` 文件来自定义样式。

### 国际化

在 `i18n/i18n.properties` 中添加新的翻译键值对。

## 与原 Playground 的差异

- 使用 SAPUI5 组件替代 Phosphor Widgets
- 使用 IconTabBar 实现多文件标签
- 简化的 FileSystem 实现（可根据需要集成完整的 @abaplint/core）
- 添加了 SAP Fiori 标准的路由和导航
- 符合 SAP Launchpad 集成要求

## 故障排除

### Monaco Editor 未加载

检查网络连接，确保可以访问 CDN：
- https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/

### 部署失败

1. 检查 SAP 系统连接
2. 验证用户权限
3. 确认包名称和传输请求正确

### Launchpad 中应用未显示

1. 清除浏览器缓存
2. 检查用户角色分配
3. 验证语义对象和操作配置

## 许可证

与原 abaplint 项目保持一致。

## 联系方式

如有问题，请联系项目维护者。
