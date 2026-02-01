# 快速开始指南

## 项目完整性检查

✅ 项目已经完整创建，包含以下内容：

### 目录结构
```
project1/
├── webapp/
│   ├── controller/
│   │   └── Main.controller.js      ✅ 主控制器
│   ├── view/
│   │   └── Main.view.xml           ✅ 主视图
│   ├── model/
│   │   └── models.js               ✅ 模型工厂
│   ├── utils/
│   │   ├── MonacoLoader.js         ✅ Monaco Editor 加载器
│   │   └── FileSystem.js           ✅ 文件系统管理
│   ├── css/
│   │   └── style.css               ✅ 样式文件
│   ├── i18n/
│   │   ├── i18n.properties         ✅ 国际化（默认）
│   │   ├── i18n_en.properties      ✅ 英文
│   │   └── i18n_zh_CN.properties   ✅ 简体中文
│   ├── manifest.json               ✅ 应用描述符（含 Launchpad 配置）
│   ├── Component.js                ✅ 组件定义
│   ├── index.html                  ✅ 入口页面
│   └── xs-app.json                 ✅ 路由配置
├── ui5.yaml                        ✅ UI5 工具配置
├── ui5-deploy.yaml                 ✅ 部署配置
├── ui5-local.yaml                  ✅ 本地配置
├── package.json                    ✅ npm 依赖
├── .npmrc                          ✅ npm 配置
├── .gitignore                      ✅ Git 忽略配置
└── README.md                       ✅ 项目文档
```

## 立即开始

### 步骤 1: 安装依赖

打开命令行，进入项目目录：

```bash
cd C:\Users\q_zhang50374\.cursor\worktrees\web\dum\web\project1
npm install
```

如果遇到安装问题，可以尝试：

```bash
npm install --legacy-peer-deps
```

### 步骤 2: 本地运行

```bash
npm start
```

应用将自动在浏览器中打开：`http://localhost:8080`

### 步骤 3: 测试功能

在打开的应用中，你应该能看到：

1. **左侧面板**：欢迎信息和快速开始指南
2. **中间编辑器**：4 个标签页，每个包含一个 Monaco Editor
   - `abaplint.json` - JSON 配置文件
   - `zfoo.prog.abap` - ABAP 程序
   - `zfoo.ddls.asddls` - CDS 视图
   - `zfoo.prog.screen_0100.abap` - Screen 程序
3. **底部面板**：问题列表（显示语法检查结果）

### 步骤 4: 构建部署包

```bash
npm run build
```

构建完成后，`dist/` 目录中将包含可部署的文件。

## 部署到 SAP Launchpad

### 方式 1: 使用 VSCode Fiori Tools（推荐）

你提到会使用 VSCode 的 Fiori 扩展进行部署，这是推荐的方式：

1. 在 VSCode 中打开项目
2. 右键点击 `ui5-deploy.yaml`
3. 选择 "Deploy" 选项
4. 按向导输入：
   - SAP 系统 URL
   - Client
   - 用户名/密码
   - BSP 应用名称（如：ZABAPLINT）
   - 包名称（建议创建自定义包，而不是 $TMP）
   - 传输请求号（如果使用传输）

### 方式 2: 修改 ui5-deploy.yaml 后命令行部署

编辑 `ui5-deploy.yaml`：

```yaml
configuration:
  target:
    url: http://your-sap-system:8000  # 改为你的系统
    client: "100"                     # 改为你的 Client
  app:
    name: ZABAPLINT                   # BSP 应用名
    package: ZTEST                    # 改为你的包
    transport: "XXXK900123"           # 传输请求（可选）
```

然后运行：

```bash
npm run deploy
```

## 配置 Launchpad 磁贴

部署成功后，在 SAP GUI 中：

### 1. 使用事务码 `/UI2/FLPD_CUST`

创建目录和组：

1. **创建目录** → 添加应用
   - 语义对象：`AbaplintEditor`
   - 操作：`display`
   - 应用 ID：`com.abaplint.editor`

2. **创建组** → 添加磁贴
   - 从目录中选择刚创建的应用

3. **分配到角色**
   - 将组分配给用户角色

### 2. 测试访问

在浏览器中打开 Launchpad：

```
http://your-sap-system:8000/sap/bc/ui5_ui5/ui2/ushell/shells/abap/FioriLaunchpad.html
```

你应该能看到 "ABAP Lint Editor" 磁贴。

## 常见问题解决

### 问题 1: Monaco Editor 未加载

**症状**：编辑器区域空白

**解决方案**：
- 检查浏览器控制台（F12）是否有错误
- 确认可以访问 CDN：https://cdnjs.cloudflare.com
- 如果内网无法访问外网，需要下载 Monaco Editor 到本地

### 问题 2: npm install 失败

**症状**：依赖安装错误

**解决方案**：
```bash
npm cache clean --force
npm install --legacy-peer-deps
```

### 问题 3: 部署失败 - 认证错误

**症状**：401 或 403 错误

**解决方案**：
- 检查用户权限
- 确认有 S_DEVELOP 权限
- 使用正确的 Client

### 问题 4: Launchpad 中找不到应用

**症状**：磁贴不显示

**解决方案**：
1. 清除浏览器缓存
2. 使用事务码 `/UI2/FLPCM_CUST` 检查目录分配
3. 确认用户角色包含对应的目录/组
4. 使用事务码 `/UI2/CACHE_CLEANUP` 清除缓存

### 问题 5: 编辑器布局混乱

**症状**：编辑器显示不正常

**解决方案**：
- 切换标签页触发 layout 重新计算
- 调整浏览器窗口大小
- 检查 `css/style.css` 是否正确加载

## 进一步开发

### 添加完整的 abaplint 集成

当前的实现使用了简化的 linting。要使用完整的 @abaplint/core：

1. 参考 `web/playground/src/filesystem.ts` 中的实现
2. 在 `webapp/utils/FileSystem.js` 中集成 @abaplint/core
3. 使用 @abaplint/monaco 注册语言支持

### 添加更多功能

- 文件上传/下载
- 代码模板
- 搜索和替换
- 设置面板
- 多主题支持

### 自定义样式

编辑 `webapp/css/style.css` 来匹配你的企业主题。

## 技术支持

如果遇到问题：

1. 查看详细的 README.md
2. 检查浏览器控制台的错误信息
3. 确认所有依赖正确安装
4. 检查 SAP 系统连接和权限

## 与原 Playground 的主要改进

✅ **SAPUI5 标准组件** - 替代了 Phosphor Widgets
✅ **Fiori 设计规范** - 符合 SAP 标准 UI/UX
✅ **Launchpad 集成** - 可直接部署到企业门户
✅ **多语言支持** - 内置中英文国际化
✅ **响应式布局** - 支持桌面、平板、手机
✅ **可扩展架构** - 易于添加新功能

## 下一步

1. ✅ 运行 `npm install`
2. ✅ 运行 `npm start` 测试
3. ✅ 修改 `ui5-deploy.yaml` 配置
4. ✅ 使用 VSCode Fiori Tools 部署
5. ✅ 在 SAP GUI 中配置 Launchpad
6. ✅ 访问 Launchpad 测试应用

祝你使用愉快！🚀
