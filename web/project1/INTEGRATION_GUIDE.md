# ABAP Lint Editor - Integration Guide

## 完整 abaplint 引擎集成方案

由于 UI5 框架无法直接加载 `@abaplint/core` 这样的 npm 包，我们采用了将完整 playground 应用嵌入到 UI5 应用中的方案。

### 方案优势

✅ **完整功能** - 使用playground 中所有自定义规则和配置  
✅ **真正的 abaplint 引擎** - Registry、MemoryFile、完整的语法检查  
✅ **您的自定义内容** - 所有在 playground 中的修改都会生效  
✅ **简单维护** - 只需在一个地方维护规则配置  

### 使用步骤

#### 1. 启动 Playground 服务器

在第一个终端运行：

```bash
cd C:\Users\q_zhang50374\Documents\abaplint\abaplint\web\playground
npm run dev
```

Playground 会运行在 `http://localhost:8090`

#### 2. 启动 UI5 应用

在第二个终端运行：

```bash
cd C:\Users\q_zhang50374\Documents\abaplint\abaplint\web\project1
npm start
```

UI5 应用会运行在 `http://localhost:8080`

#### 3. 访问应用

打开浏览器访问 `http://localhost:8080/index.html`

您会看到 playground 编辑器嵌入在 UI5 应用的界面中。

### 已集成的功能

从您的 playground `filesystem.ts` 中集成的所有内容：

1. **ABAP 版本**: v758
2. **错误命名空间**: `^(Z|Y|LCL_|LTC_|TY_|LIF_|LHC_|LBP_|LSC_|CL_|IF_)`
3. **禁用的规则**:
   - main_file_contents
   - 7bit_ascii
   - cds_parser_error
   - no_public_attributes
   - unknown_types
   - method_length
   - no_prefixes
   - method_parameter_names
   - local_class_naming
   - description_empty
   - unused_types
   - object_naming
   - types_naming
   - no_yoda_conditions
   - global_class
   - implement_methods
   - message_exists
   - no_comments_between_methods
   - select_add_order_by
   - avoid_use
   - local_variable_names

4. **特殊规则配置**:
   - `parser_error`: 排除 testclasses 和 locals_imp
   - `check_syntax`: 忽略多种查找错误
   - `select_performance`: 测试类放宽
   - `omit_parameter_name`: 测试类和本地类放宽
   - `superclass_final`: 测试类和本地类放宽
   - `abapdoc`: 完整的文档检查配置

5. **桩代码文件**:
   - `cl_abap_behavior_handler.clas.abap` - RAP 行为处理器基类

6. **示例文件**:
   - `zcl_test.clas.abap` - 示例测试类
   - `zfoo.ddls.asddls` - CDS 视图
   - `zfoo.clas.abap` - 主类外壳
   - `zfoo.clas.locals_imp.abap` - 本地类文件
   - `zfoo.clas.testclasses.abap` - 测试类文件

### 修改自定义规则

要修改规则配置，只需编辑：

```
C:\Users\q_zhang50374\Documents\abaplint\abaplint\web\playground\src\filesystem.ts
```

然后重启 playground 服务器即可。

### 独立使用 Playground

如果您更喜欢直接使用 playground，也可以：

```bash
cd C:\Users\q_zhang50374\Documents\abaplint\abaplint\web\playground
npm run dev
```

然后直接访问 `http://localhost:8090`

### 技术说明

- **为什么不能直接在 UI5 中使用 @abaplint/core？**  
  UI5 使用自己的模块加载系统（sap.ui.define），无法直接加载 CommonJS/ES6 npm 包。

- **Iframe 方案的优势？**  
  - 完全隔离，不会有模块冲突
  - playground 可以独立开发和测试
  - UI5 应用提供企业级的外壳界面

- **性能考虑？**  
  Iframe 通信有轻微延迟，但对于代码编辑器来说完全可以接受。

### 故障排除

**问题**: Playground 未运行  
**解决**: 确保在 `../playground` 目录运行了 `npm run dev`

**问题**: 端口冲突  
**解决**: 修改 playground 的 webpack 配置中的端口号

**问题**: CORS 错误  
**解决**: 两个服务器都在 localhost，不应该有 CORS 问题

### 下一步

您现在可以：
1. 在 playground/src/filesystem.ts 中添加更多自定义规则
2. 添加更多桩代码文件
3. 创建您的测试用例
4. 所有更改会立即反映在嵌入的编辑器中

享受完整的 abaplint 功能！🎉
