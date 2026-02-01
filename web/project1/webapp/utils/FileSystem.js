sap.ui.define([], function () {
    "use strict";

    var FileSystem = {
        _files: {},
        _problemsCallback: null,
        _config: null,

        initialize: function (problemsCallback) {
            this._problemsCallback = problemsCallback;
            this._files = {};
            
            // Initialize with playground-style config
            this._config = {
                rules: {
                    "indentation": true,
                    "whitespace_end": true,
                    "line_length": { "max": 120 },
                    "empty_statement": true,
                    "space_before_colon": true,
                    "colon_missing_space": true,
                    "contains_tab": true
                }
            };
            
            console.log("FileSystem initialized with enhanced linting");
        },

        registerFile: function (uri, content) {
            this._files[uri] = {
                uri: uri,
                content: content
            };
            console.log("File registered:", uri);
            this._runLinting();
        },

        updateFile: function (uri, content) {
            if (this._files[uri]) {
                this._files[uri].content = content;
                this._runLinting();
            }
        },

        getFile: function (uri) {
            return this._files[uri];
        },

        getAllFiles: function () {
            return this._files;
        },

        _runLinting: function () {
            var allIssues = [];
            
            for (var fileUri in this._files) {
                var issues = this._lintFile(fileUri);
                allIssues = allIssues.concat(issues);
            }
            
            if (this._problemsCallback) {
                this._problemsCallback(allIssues);
            }
        },

        _lintFile: function (uri) {
            var issues = [];
            var file = this._files[uri];
            
            if (!file) {
                return issues;
            }

            var content = file.content;
            var lines = content.split('\n');

            // Enhanced ABAP linting rules (playground-style)
            if (uri.includes('.abap')) {
                lines.forEach(function (line, index) {
                    var lineNum = index + 1;
                    
                    // Check for lines longer than 120 characters
                    if (line.length > 120) {
                        issues.push(this._createIssue(
                            uri, lineNum, 1,
                            "Line too long (" + line.length + " chars, max 120)",
                            "line_length", "Warning"
                        ));
                    }

                    // Check for trailing whitespace
                    if (line.endsWith(' ') || line.endsWith('\t')) {
                        issues.push(this._createIssue(
                            uri, lineNum, line.trimEnd().length + 1,
                            "Trailing whitespace",
                            "whitespace_end", "Warning"
                        ));
                    }

                    // Check for tabs
                    if (line.indexOf('\t') !== -1) {
                        issues.push(this._createIssue(
                            uri, lineNum, line.indexOf('\t') + 1,
                            "Contains tab character, use spaces instead",
                            "contains_tab", "Error"
                        ));
                    }

                    // Check for empty statements
                    var trimmed = line.trim();
                    if (trimmed === '.') {
                        issues.push(this._createIssue(
                            uri, lineNum, 1,
                            "Empty statement",
                            "empty_statement", "Warning"
                        ));
                    }

                    // Check for missing space before colon
                    if (/\S:/.test(line) && !line.includes('::') && !line.includes('@')) {
                        var colonPos = line.search(/\S:/);
                        issues.push(this._createIssue(
                            uri, lineNum, colonPos + 1,
                            "Add space before colon",
                            "space_before_colon", "Warning"
                        ));
                    }

                    // Check for colon without following space (in DATA: declarations)
                    if (/:\S/.test(line) && !line.includes('::')) {
                        var colonPos = line.search(/:\S/);
                        issues.push(this._createIssue(
                            uri, lineNum, colonPos + 1,
                            "Add space after colon",
                            "colon_missing_space", "Warning"
                        ));
                    }

                    // Check indentation (should be multiples of 2)
                    var leadingSpaces = line.match(/^ */)[0].length;
                    if (leadingSpaces > 0 && leadingSpaces % 2 !== 0) {
                        issues.push(this._createIssue(
                            uri, lineNum, 1,
                            "Indentation should be a multiple of 2 spaces",
                            "indentation", "Warning"
                        ));
                    }

                    // Check for obsolete statements
                    if (trimmed.toUpperCase().startsWith('MOVE ')) {
                        issues.push(this._createIssue(
                            uri, lineNum, 1,
                            "Use assignment operator (=) instead of MOVE",
                            "obsolete_statement", "Info"
                        ));
                    }

                    // Check for WRITE statements (should use new APIs)
                    if (trimmed.toUpperCase().startsWith('WRITE')) {
                        issues.push(this._createIssue(
                            uri, lineNum, 1,
                            "Consider using modern output methods",
                            "obsolete_statement", "Info"
                        ));
                    }
                }.bind(this));
            }

            // JSON file checks
            if (uri.includes('.json')) {
                try {
                    JSON.parse(content);
                } catch (e) {
                    issues.push(this._createIssue(
                        uri, 1, 1,
                        "Invalid JSON: " + e.message,
                        "json_parse", "Error"
                    ));
                }
            }

            return issues;
        },

        _createIssue: function(uri, row, col, message, key, severity) {
            return {
                getFilename: function () { return uri; },
                getMessage: function () { return message; },
                getKey: function () { return key; },
                getSeverity: function () { return severity || "Warning"; },
                getStart: function () {
                    return {
                        getRow: function () { return row; },
                        getCol: function () { return col; }
                    };
                }
            };
        },

        getRegistry: function () {
            return null; // Simplified version doesn't use Registry
        }
    };

    return FileSystem;
});
