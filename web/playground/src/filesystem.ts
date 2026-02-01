import { ProblemsWidget, EditorWidget } from "./widgets";
import {
  Registry,
  IRegistry,
  Config,
  MemoryFile,
  IFile,
  Version,
} from "@abaplint/core";
import { DockPanel } from "@phosphor/widgets";

// magic God class
export class FileSystem {
  private static files: MemoryFile[];
  private static reg: IRegistry;
  private static problems: ProblemsWidget;
  private static dock: DockPanel;

  /** Normalize all filenames to file:///... to avoid duplicates and broken updates */
  private static normalize(filename: string) {
    if (!filename) {
      return "file:///";
    }
    if (filename.startsWith("file:///")) {
      return filename;
    }
    if (filename.startsWith("file://")) {
      // ensure exactly triple slash
      return filename.replace(/^file:\/\//, "file:///");
    }
    // handle "/foo" or "foo"
    return "file:///" + filename.replace(/^\/+/, "");
  }

  public static setup(problems: ProblemsWidget, dock: DockPanel): IRegistry {
    this.files = [];
    this.reg = new Registry();
    this.dock = dock;
    this.problems = problems;

    // ===== config =====
    const defaultConfig = Config.getDefault().get();

    // ABAP version
    defaultConfig.syntax.version = Version.v758;

    // allow more namespaces (local classes/test classes/RAP handlers)
    defaultConfig.syntax.errorNamespace =
      "^(Z|Y|LCL_|LTC_|TY_|LIF_|LHC_|LBP_|LSC_|CL_|IF_)";

    defaultConfig.syntax.globalConstants =
      defaultConfig.syntax.globalConstants || [];
    defaultConfig.syntax.globalMacros = defaultConfig.syntax.globalMacros || [];

    // rules tuning
    defaultConfig.rules["main_file_contents"] = false;
    defaultConfig.rules["7bit_ascii"] = false;
    // 禁用 CDS 解析器错误
    defaultConfig.rules["cds_parser_error"] = false;
    // 禁用公有属性检查
    defaultConfig.rules["no_public_attributes"] = false;
    // 禁用未知类型检查 - 避免 RAP 基类/DDIC 类型找不到的警告
    defaultConfig.rules["unknown_types"] = false;
    defaultConfig.rules["method_length"] = false;
    // 禁用前缀检查（保留 local_variable_names）
    defaultConfig.rules["no_prefixes"] = false;
    defaultConfig.rules["method_parameter_names"] = false;
    defaultConfig.rules["local_class_naming"] = false;
    // 禁用描述检查 - RAP 基类没有 XML 文件
    defaultConfig.rules["description_empty"] = false;
    // 禁用未使用类型检查 - 桩代码类型供其他文件使用
    defaultConfig.rules["unused_types"] = false;
    // 禁用对象命名检查 - 允许标准类如 CL_ABAP_BEHAVIOR_HANDLER
    defaultConfig.rules["object_naming"] = false;
    // 禁用类型命名检查 - 允许 abap_bool, zrap_pg_* 等命名
    defaultConfig.rules["types_naming"] = false;
    // 禁用 Yoda 条件检查
    defaultConfig.rules["no_yoda_conditions"] = false;
    // 禁用全局类检查
    defaultConfig.rules["global_class"] = false;
    // 禁用方法实现检查
    defaultConfig.rules["implement_methods"] = false;
    // 禁用消息存在检查
    defaultConfig.rules["message_exists"] = false;
    // unused_variables - 启用（已修复桩代码）
    // align_type_expressions - 启用（已修复对齐）
    // parser_error 规则 - 排除测试类和本地类文件
    defaultConfig.rules["parser_error"] = {
      "severity": "Error",
      "exclude": [".*\\.testclasses\\.abap$", ".*\\.locals_imp\\.abap$"]
    };
    // check_syntax 规则 - 启用但忽略特定错误类型（表/组件找不到）
    defaultConfig.rules["check_syntax"] = {
      "severity": "Error",
      "ignoreTableNotFound": true,      // 忽略 "Database table not found" 错误
      "ignoreComponentNotFound": true,  // 忽略 "Component not found in structure" 错误
      "ignoreUnknownType": true,        // 忽略 "Unknown type" 错误
      "ignoreMethodNotFound": true,     // 忽略 "Method not found" 错误
      "ignoreClassNotFound": true,      // 忽略 "Class not found" / "Unknown class" 错误
      "ignoreInterfaceNotFound": true,  // 忽略 "Interface not found" / "Unknown interface" 错误
      "ignoreTargetNotFound": true,     // 忽略 "not found, Target" 错误 (TEST-INJECTION 变量)
      "ignoreNotObjectReference": true, // 忽略 "Not an object reference" 错误
      "ignoreFindTopNotFound": true,    // 忽略 "not found, findTop" 错误 (TEST-INJECTION 变量)
      "ignoreParameterNotExist": true,  // 忽略 "parameter does not exist" 错误
      "ignoreNotTableType": true,       // 忽略 "not a table type" 错误
      "ignoreMustBeSupplied": true      // 忽略 "must be supplied" 错误
    };
    // 禁用全局类方法间注释检查 - 与 abapdoc checkImplementation 冲突
    defaultConfig.rules["no_comments_between_methods"] = false;

    // select_performance - 只对测试类(.testclasses.abap)放宽，本地类仍严格检查
    defaultConfig.rules["select_performance"] = {
      "severity": "Warning",
      "exclude": [".*\\.testclasses\\.abap$"]
    };
    // 禁用 select_add_order_by
    defaultConfig.rules["select_add_order_by"] = false;
    // 禁用 avoid_use - 允许 seam 等
    defaultConfig.rules["avoid_use"] = false;
    // 禁用 local_variable_names - Clean ABAP 不需要 LV_ 前缀
    defaultConfig.rules["local_variable_names"] = false;
    // omit_parameter_name - 对测试类(.testclasses.abap)和本地类(.locals_imp.abap)放宽
    defaultConfig.rules["omit_parameter_name"] = {
      "severity": "Warning",
      "exclude": [".*\\.testclasses\\.abap$", ".*\\.locals_imp\\.abap$"]
    };
    // superclass_final - 对测试类(.testclasses.abap)和本地类(.locals_imp.abap)放宽
    defaultConfig.rules["superclass_final"] = {
      "severity": "Warning",
      "exclude": [".*\\.testclasses\\.abap$", ".*\\.locals_imp\\.abap$"]
    };

    // abapdoc checks - 对测试类和本地类放宽（不强制 IF/LOOP 注释）
    defaultConfig.rules["abapdoc"] = {
      severity: "Error",
      checkLocal: true,
      classDefinition: false,
      interfaceDefinition: false,
      ignoreTestClasses: true,
      checkPrivate: true,
      checkProtected: true,
      checkImplementation: true,
      checkStatements: false,      // 关闭 - 不强制 IF/LOOP/SELECT 等注释
      checkSubrcHandling: false,   // 关闭 - 不强制 sy-subrc 处理注释
      allowNormalComment: true,    // 允许普通注释（" 开头），不强制要求 "! 开头
    };

    // Add config file first so it's applied
    this.addFile("abaplint.json", JSON.stringify(defaultConfig, undefined, 2));

    // ===== stub: standard class =====

    // RAP Behavior Handler base class
    this.addFile(
      "cl_abap_behavior_handler.clas.abap",
      `"! RAP Behavior Handler base class
CLASS cl_abap_behavior_handler DEFINITION PUBLIC ABSTRACT.
ENDCLASS.

CLASS cl_abap_behavior_handler IMPLEMENTATION.
ENDCLASS.`
    );

    // ===== sample files =====

    this.addFile(
      "zcl_test.clas.abap",
      `"! Sample test class
CLASS zcl_test DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    " Define public method
    METHODS run RETURNING VALUE(rv_msg) TYPE string.
ENDCLASS.

CLASS zcl_test IMPLEMENTATION.
  " Return Hello World message
  METHOD run.
    rv_msg = |Hello World|.
  ENDMETHOD.
ENDCLASS.`
    );

    this.addFile(
      "zfoo.ddls.asddls",
      `@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Hello World,.:'
define view entity zfoo
  as select from tadir
{
  pgmid,
  object,
  obj_name
}`
    );

    // Main class shell for pasting code
    this.addFile(
      "zfoo.clas.abap",
      `"! Main class shell for testing
CLASS zfoo DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    " Main method
    METHODS main.
ENDCLASS.

CLASS zfoo IMPLEMENTATION.
  " Main entry method
  METHOD main.
    " Add your code here
  ENDMETHOD.
ENDCLASS.`
    );

    // Local class file (locals_imp)
    this.addFile(
      "zfoo.clas.locals_imp.abap",
      `"! Paste your local class code here
CLASS lcl_helper DEFINITION.
  PUBLIC SECTION.
    " Helper method declaration
    METHODS do_something RETURNING VALUE(rv_result) TYPE string.
ENDCLASS.

CLASS lcl_helper IMPLEMENTATION.
  " Helper method implementation
  METHOD do_something.
    rv_result = |Done|.
  ENDMETHOD.
ENDCLASS.`
    );

    // Test class file (CLASS ... FOR TESTING goes here)
    this.addFile(
      "zfoo.clas.testclasses.abap",
      `"! Paste your test class code here
CLASS ltc_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    " Test method declaration
    METHODS test_something FOR TESTING.
ENDCLASS.

CLASS ltc_test IMPLEMENTATION.
  " Test some functionality
  METHOD test_something.
    " Test logic
  ENDMETHOD.
ENDCLASS.`
    );

    return this.reg;
  }

  private static updateConfig(contents: string) {
    try {
      const conf = new Config(contents);
      this.reg.setConfig(conf).parse();

      // force update to update diagnostics
      for (const f of this.files) {
        if (f.getFilename().endsWith(".abap")) {
          const editor = this.findEditor(f);
          if (editor) {
            editor.getModel()?.setValue(editor.getModel()?.getValue());
          }
        }
      }
    } catch {
      return;
    }
  }

  public static openFile(filename: string) {
    const f = this.getFile(filename);
    if (f) {
      const editor = this.findEditor(f);
      if (editor) {
        this.dock.activateWidget(editor);
      } else {
        const w = new EditorWidget(f.getFilename(), f.getRaw());
        this.dock.addWidget(w);
        this.dock.activateWidget(w);
      }
    }
  }

  private static findEditor(f: IFile): EditorWidget | undefined {
    const it = this.dock.children();
    for (;;) {
      const res = it.next();
      if (res === undefined) {
        break;
      } else if (res instanceof EditorWidget) {
        if (res.getModel().uri.toString() === f.getFilename()) {
          return res;
        }
      }
    }
    return undefined;
  }

  public static getFile(filename: string): IFile | undefined {
    const fn = this.normalize(filename);
    for (const f of this.getFiles()) {
      if (f.getFilename() === fn) {
        return f;
      }
    }
    return undefined;
  }

  public static updateFile(filename: string, contents: string) {
    const fn = this.normalize(filename);

    if (fn === "file:///abaplint.json") {
      this.updateConfig(contents);
    } else {
      const file = new MemoryFile(fn, contents);
      this.reg.updateFile(file);

      // keep local cache in sync
      const idx = this.files.findIndex((f) => f.getFilename() === fn);
      if (idx >= 0) {
        this.files[idx] = file;
      } else {
        this.files.push(file);
      }
    }
    this.update();
  }

  public static addFile(filename: string, contents: string) {
    const fn = this.normalize(filename);
    const file = new MemoryFile(fn, contents);

    if (fn === "file:///abaplint.json") {
      this.updateConfig(contents);
    } else {
      this.reg.addFile(file);
    }

    // avoid duplicates
    const idx = this.files.findIndex((f) => f.getFilename() === fn);
    if (idx >= 0) {
      this.files[idx] = file;
    } else {
      this.files.push(file);
    }

    this.update();
  }

  public static getFiles(): IFile[] {
    return this.files;
  }

  public static getRegistry(): IRegistry {
    return this.reg;
  }

  public static getIssues(filename?: string) {
    const issues = this.reg.findIssues();
    if (filename) {
      const fn = this.normalize(filename);
      return issues.filter((i) => i.getFilename() === fn);
    }
    return issues;
  }

  private static update() {
    this.problems.updateIt();
  }
}
