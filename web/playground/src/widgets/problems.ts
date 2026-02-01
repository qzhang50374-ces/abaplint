import * as monaco from "monaco-editor";
import {Message} from "@phosphor/messaging";
import {Widget} from "@phosphor/widgets";
import {FileSystem} from "../filesystem";
import {Severity} from "@abaplint/core";

export class ProblemsWidget extends Widget {

  public static createNode(): HTMLElement {
    const node = document.createElement("div");
    const content = document.createElement("div");
    const input = document.createElement("tt");
    input.innerText = "problems";
    content.appendChild(input);
    node.appendChild(content);
    return node;
  }

  public constructor() {
    super({node: ProblemsWidget.createNode()});
    this.setFlag(Widget.Flag.DisallowLayout);
    this.addClass("content");
  }

  protected onActivateRequest(msg: Message): void {
    return;
  }

  private escape(str: string) {
    str = str.replace(/&/g, "&amp;");
    str = str.replace(/>/g, "&gt;");
    str = str.replace(/</g, "&lt;");
    str = str.replace(/"/g, "&quot;");
    str = str.replace(/'/g, "&#039;");
    return str;
  }

  public updateIt() {
    const content = document.createElement("div");
    this.addClass("content");
    
    const issues = FileSystem.getIssues();
    
    // 按文件和严重程度统计
    const stats: { [key: string]: { errors: number; warnings: number; info: number } } = {};
    let totalErrors = 0;
    let totalWarnings = 0;
    let totalInfo = 0;
    
    for (const i of issues) {
      const path = monaco.Uri.parse(i.getFilename()).path;
      if (!stats[path]) {
        stats[path] = { errors: 0, warnings: 0, info: 0 };
      }
      const severity = i.getSeverity();
      if (severity === Severity.Error) {
        stats[path].errors++;
        totalErrors++;
      } else if (severity === Severity.Warning) {
        stats[path].warnings++;
        totalWarnings++;
      } else { // Info
        stats[path].info++;
        totalInfo++;
      }
    }
    
    // 显示统计摘要
    const summary = document.createElement("div");
    summary.style.cssText = "padding: 8px; background: #252526; border-bottom: 1px solid #3c3c3c; font-family: monospace;";
    
    const totalCount = issues.length;
    let summaryText = `<span style="font-weight: bold;">Problem Summary:</span> Total ${totalCount} issues`;
    if (totalErrors > 0) {
      summaryText += ` | <span style="color: #f48771;">❌ Error: ${totalErrors}</span>`;
    }
    if (totalWarnings > 0) {
      summaryText += ` | <span style="color: #cca700;">⚠️ Warning: ${totalWarnings}</span>`;
    }
    if (totalInfo > 0) {
      summaryText += ` | <span style="color: #3794ff;">ℹ️ Info: ${totalInfo}</span>`;
    }
    if (totalCount === 0) {
      summaryText = `<span style="color: #89d185;">✅ No issues found</span>`;
    }
    summary.innerHTML = summaryText;
    
    // 按文件统计
    const fileStats = document.createElement("div");
    fileStats.style.cssText = "padding: 4px 8px; background: #1e1e1e; border-bottom: 1px solid #3c3c3c; font-family: monospace; font-size: 12px;";
    let fileStatsHtml = "";
    for (const [path, counts] of Object.entries(stats)) {
      const fileName = path.split("/").pop() || path;
      fileStatsHtml += `<div style="margin: 2px 0;"><span style="color: #569cd6;">${fileName}</span>: `;
      const parts = [];
      if (counts.errors > 0) parts.push(`<span style="color: #f48771;">${counts.errors} Errors</span>`);
      if (counts.warnings > 0) parts.push(`<span style="color: #cca700;">${counts.warnings} Warnings</span>`);
      if (counts.info > 0) parts.push(`<span style="color: #3794ff;">${counts.info} Info</span>`);
      fileStatsHtml += parts.join(", ") + "</div>";
    }
    fileStats.innerHTML = fileStatsHtml;
    
    // 问题列表
    const input = document.createElement("tt");
    for (const i of issues) {
      const position = "[" + i.getStart().getRow() + ", " + i.getStart().getCol() + "]";
      const path = monaco.Uri.parse(i.getFilename()).path;
      const message = this.escape(i.getMessage());
      const severity = i.getSeverity();
      let color = "#d4d4d4";
      let icon = "";
      if (severity === Severity.Error) {
        color = "#f48771";
        icon = "❌ ";
      } else if (severity === Severity.Warning) {
        color = "#cca700";
        icon = "⚠️ ";
      } else {
        color = "#3794ff";
        icon = "ℹ️ ";
      }
      input.innerHTML = input.innerHTML + "<br>" +
        `<span style="color: ${color};">${icon}${path}${position}: ${message}(${i.getKey()})</span>`;
    }
    content.appendChild(input);

    while (this.node.firstChild) {
      this.node.removeChild(this.node.firstChild);
    }

    this.node.appendChild(summary);
    if (Object.keys(stats).length > 0) {
      this.node.appendChild(fileStats);
    }
    this.node.appendChild(content);
  }
}