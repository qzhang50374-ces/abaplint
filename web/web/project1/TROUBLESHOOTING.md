# 问题诊断和解决方案

## 当前项目状态

✅ **项目结构完整** - 所有必需文件已创建
✅ **配置文件就绪** - manifest.json, Component.js, ui5.yaml 等
✅ **代码文件完整** - 控制器、视图、工具类全部就绪
✅ **部署配置完成** - 可以通过 VSCode Fiori Tools 部署

## 可能存在的问题及解决方案

### 类别 1: 依赖和构建问题

#### 问题 1.1: npm install 失败

**可能的错误信息**：
```
npm ERR! code ERESOLVE
npm ERR! ERESOLVE unable to resolve dependency tree
```

**解决方案**：

方案 A - 使用 legacy-peer-deps：
```bash
npm install --legacy-peer-deps
```

方案 B - 使用 force：
```bash
npm install --force
```

方案 C - 清除缓存后重装：
```bash
npm cache clean --force
rm -rf node_modules package-lock.json
npm install --legacy-peer-deps
```

#### 问题 1.2: @sap/ux-ui5-tooling 安装失败

**原因**：SAP 包需要特定的 npm 配置

**解决方案**：

确认 `.npmrc` 文件存在且内容正确：
```
@sap:registry=https://registry.npmjs.org/
registry=https://registry.npmjs.org/
```

如果仍然失败，可以尝试使用 SAP npm registry：
```
@sap:registry=https://npm.sap.com/
```

#### 问题 1.3: UI5 CLI 命令不存在

**错误信息**：
```
'ui5' is not recognized as an internal or external command
```

**解决方案**：

全局安装 UI5 CLI：
```bash
npm install -g @ui5/cli
```

或者使用 npx：
```bash
npx ui5 serve
npx ui5 build
```

### 类别 2: 运行时问题

#### 问题 2.1: Monaco Editor 加载失败

**症状**：编辑器区域空白，控制台显示 404 错误

**原因**：无法访问 CDN

**解决方案 A** - 检查网络：
1. 打开浏览器访问：https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.52.2/min/vs/loader.min.js
2. 如果无法访问，说明网络被限制

**解决方案 B** - 使用本地 Monaco：

1. 下载 Monaco Editor：
```bash
npm install monaco-editor@0.52.2
```

2. 修改 `webapp/utils/MonacoLoader.js`：

将 CDN 路径改为本地路径：
```javascript
window.require.config({
    paths: {
        'vs': './resources/monaco-editor/min/vs'
    }
});
```

3. 配置 ui5.yaml 复制 Monaco 文件：
```yaml
builder:
  resources:
    configuration:
      paths:
        "/resources/monaco-editor": "./node_modules/monaco-editor"
```

#### 问题 2.2: 编辑器布局错误

**症状**：编辑器显示不完整或重叠

**原因**：Monaco Editor 需要明确的容器尺寸

**解决方案**：

1. 检查 `css/style.css` 中的样式
2. 确保编辑器容器有明确的高度
3. 切换标签时调用 `editor.layout()`

已在 `Main.controller.js` 的 `onTabSelect` 方法中实现：
```javascript
onTabSelect: function (oEvent) {
    var sKey = oEvent.getParameter("key");
    this._currentEditorKey = sKey;
    
    if (this._editors[sKey]) {
        setTimeout(function () {
            this._editors[sKey].editor.layout();
        }.bind(this), 100);
    }
}
```

#### 问题 2.3: ABAP 语法高亮不正确

**原因**：使用了简化的语法定义

**解决方案**：

要获得完整的 ABAP 语法支持，需要集成 @abaplint/monaco：

1. 修改 `webapp/utils/MonacoLoader.js`，在加载完成后添加：

```javascript
// 导入 abaplint monaco
sap.ui.require(["@abaplint/monaco"], function(abaplintMonaco) {
    // 获取 Registry
    var registry = FileSystem.getRegistry();
    if (registry) {
        abaplintMonaco.registerABAP(registry);
    }
});
```

2. 确保 @abaplint/monaco 和 @abaplint/core 已正确安装

#### 问题 2.4: Problems 面板不更新

**症状**：修改代码后，问题列表不刷新

**原因**：使用了简化的 linting 实现

**当前实现**：
- 基本的语法检查（行长度、尾随空格、JSON 语法）

**增强方案**：

要获得完整的 abaplint 功能，需要：

1. 在 `webapp/utils/FileSystem.js` 中集成 @abaplint/core Registry
2. 参考 playground 项目的实现：`web/playground/src/filesystem.ts`

示例代码框架：
```javascript
// 导入 abaplint core
var Registry = sap.ui.require("@abaplint/core").Registry;

initialize: function (problemsCallback) {
    this._problemsCallback = problemsCallback;
    this._registry = new Registry();
    this._files = {};
    
    // 配置 Registry
    var config = new Config(JSON.stringify({
        "global": { /* ... */ },
        "rules": { /* ... */ }
    }));
    this._registry.setConfig(config);
}
```

### 类别 3: 部署问题

#### 问题 3.1: 部署到 SAP 失败 - 连接错误

**错误信息**：
```
Error: connect ECONNREFUSED
```

**解决方案**：

1. 确认 SAP 系统 URL 正确：
   - 格式：`http://hostname:port`
   - 例如：`http://sapserver.company.com:8000`

2. 检查网络连接：
```bash
ping sapserver.company.com
telnet sapserver.company.com 8000
```

3. 确认防火墙设置允许访问

#### 问题 3.2: 部署失败 - 认证错误

**错误信息**：
```
401 Unauthorized
403 Forbidden
```

**解决方案**：

1. 确认用户名和密码正确
2. 检查用户权限 - 需要 S_DEVELOP 权限
3. 确认 Client 正确

在 SAP GUI 中检查权限：
- 事务码：`SU53` - 查看最近的权限检查
- 事务码：`SU01` - 查看用户权限

#### 问题 3.3: BSP 应用已存在

**错误信息**：
```
BSP application already exists
```

**解决方案**：

方案 A - 使用不同的名称：
修改 `ui5-deploy.yaml`：
```yaml
app:
  name: ZABAPLINT2  # 使用新名称
```

方案 B - 删除现有应用：
1. 事务码：`SE80`
2. 选择 "BSP Application"
3. 输入应用名称
4. 删除应用

方案 C - 覆盖现有应用：
在部署时选择覆盖选项

#### 问题 3.4: 传输请求错误

**错误信息**：
```
Transport request not found
Invalid transport request
```

**解决方案**：

方案 A - 不使用传输（仅测试环境）：
```yaml
app:
  package: $TMP
  transport: ""
```

方案 B - 创建新的传输请求：
1. 事务码：`SE09` 或 `SE10`
2. 创建新的可修改传输请求
3. 使用该请求号

方案 C - 使用现有传输：
1. 事务码：`SE09`
2. 找到你的传输请求（状态必须是"可修改"）
3. 复制请求号到配置中

### 类别 4: Launchpad 集成问题

#### 问题 4.1: Launchpad 中找不到应用

**症状**：部署成功，但 Launchpad 中看不到磁贴

**解决方案**：

步骤 1 - 检查应用是否已部署：
```
http://your-sap-system:8000/sap/bc/ui5_ui5/sap/zabaplint/index.html
```

步骤 2 - 配置语义对象（事务码 `/UI2/SEMOBJ`）：
- 创建语义对象：`AbaplintEditor`

步骤 3 - 创建目标映射（事务码 `/UI2/FLPD_CUST`）：
1. 创建目录
2. 添加应用 → 目标映射类型：URL
3. 填写：
   - 语义对象：`AbaplintEditor`
   - 操作：`display`
   - 应用 ID：`com.abaplint.editor`
   - URL：`/sap/bc/ui5_ui5/sap/zabaplint/index.html`

步骤 4 - 分配到组和角色：
1. 创建组
2. 添加应用到组
3. 分配组到角色
4. 分配角色给用户

步骤 5 - 清除缓存：
- 事务码：`/UI2/CACHE_CLEANUP`
- 清除浏览器缓存（Ctrl+F5）

#### 问题 4.2: 磁贴点击后显示 404

**症状**：磁贴存在，但点击后页面未找到

**解决方案**：

1. 检查应用 URL 配置是否正确
2. 确认 BSP 应用已正确激活
3. 使用事务码 `SICF` 检查服务是否激活

#### 问题 4.3: Launchpad 导航失败

**症状**：应用打开，但导航不工作

**原因**：Launchpad 的路由配置问题

**解决方案**：

确认 `manifest.json` 中的配置正确：
```json
"crossNavigation": {
  "inbounds": {
    "intent1": {
      "semanticObject": "AbaplintEditor",
      "action": "display"
    }
  }
}
```

### 类别 5: 性能问题

#### 问题 5.1: 应用加载缓慢

**解决方案**：

1. **启用压缩**：
   - 在 SAP 中启用 BSP 应用压缩
   - 事务码：`SE80` → BSP Application 属性

2. **优化资源加载**：
   - 使用 `async="true"` 加载 UI5
   - 已在 `index.html` 中配置

3. **使用 CDN**：
   - 对于 Monaco Editor，使用 CDN 通常比本地加载更快
   - 除非内网有缓存服务器

#### 问题 5.2: 编辑器响应慢

**解决方案**：

1. **减少语法检查频率**：
   在 `FileSystem.js` 中添加防抖：
```javascript
updateFile: function (uri, content) {
    if (this._files[uri]) {
        this._files[uri].content = content;
        // 防抖：延迟 500ms 后执行 linting
        clearTimeout(this._lintTimeout);
        this._lintTimeout = setTimeout(function() {
            this._runLinting(uri);
        }.bind(this), 500);
    }
}
```

2. **禁用 minimap**：
   在 `Main.controller.js` 中：
```javascript
var editor = window.monaco.editor.create(editorDiv, {
    model: model,
    theme: "vs-dark",
    automaticLayout: true,
    minimap: { enabled: false },  // 禁用 minimap
    // ...
});
```

### 类别 6: 浏览器兼容性问题

#### 问题 6.1: IE 11 不工作

**原因**：Monaco Editor 不支持 IE 11

**解决方案**：

添加不支持浏览器的提示，在 `index.html` 中添加：
```html
<script>
if (!!window.MSInputMethodContext && !!document.documentMode) {
    alert('此应用不支持 Internet Explorer。请使用 Edge、Chrome 或 Firefox。');
}
</script>
```

#### 问题 6.2: Safari 显示异常

**解决方案**：

在 `css/style.css` 中添加 Safari 特定样式：
```css
/* Safari 兼容 */
@supports (-webkit-appearance: none) {
    .monaco-editor {
        -webkit-transform: translateZ(0);
    }
}
```

## 调试技巧

### 启用详细日志

在浏览器控制台中运行：
```javascript
// 启用 SAPUI5 调试
sap.ui.getCore().getConfiguration().setDebug(true);

// 查看所有已加载的模块
sap.ui.require.toUrl("");

// 检查 Monaco 是否已加载
console.log(window.monaco);

// 检查 FileSystem 状态
var FileSystem = sap.ui.require("com/abaplint/editor/utils/FileSystem");
console.log(FileSystem.getAllFiles());
```

### 检查网络请求

1. 打开浏览器开发者工具（F12）
2. 切换到 Network 标签
3. 刷新页面
4. 查找失败的请求（红色）
5. 检查请求详情和响应

### 检查控制台错误

常见错误及含义：

- `Failed to load resource` → 文件路径错误或文件不存在
- `Uncaught ReferenceError` → 变量未定义，可能是加载顺序问题
- `SAPUI5 Load Error` → UI5 库加载失败
- `Monaco is not defined` → Monaco Editor 未正确加载

## 寻求帮助

如果以上方案都无法解决问题：

1. **收集信息**：
   - 浏览器和版本
   - 错误信息截图
   - 控制台日志
   - Network 标签内容

2. **检查 SAP Note**：
   - 搜索相关的 SAP Note
   - 特别是关于 UI5 和 Fiori Launchpad 的

3. **社区支持**：
   - SAP Community
   - Stack Overflow
   - GitHub Issues (abaplint)

## 验证清单

在报告问题前，请确认：

- [ ] 已运行 `npm install`
- [ ] 能够本地运行 `npm start`
- [ ] 浏览器控制台无错误
- [ ] 已检查所有配置文件
- [ ] SAP 系统连接正常
- [ ] 用户权限正确
- [ ] 已尝试清除缓存
- [ ] 已查看本文档的相关章节

祝你顺利解决问题！🔧
