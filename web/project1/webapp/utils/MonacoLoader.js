sap.ui.define([], function () {
    "use strict";

    var MonacoLoader = {
        _loaded: false,
        _loadPromise: null,

        load: function () {
            if (this._loaded) {
                return Promise.resolve();
            }

            if (this._loadPromise) {
                return this._loadPromise;
            }

            this._loadPromise = new Promise(function (resolve, reject) {
                // Load Monaco loader script
                var loaderScript = document.createElement('script');
                loaderScript.src = 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.52.2/min/vs/loader.min.js';
                loaderScript.onload = function () {
                    // Configure require
                    window.require.config({
                        paths: {
                            'vs': 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.52.2/min/vs'
                        }
                    });

                    // Load Monaco editor
                    window.require(['vs/editor/editor.main'], function () {
                        MonacoLoader._loaded = true;
                        
                        // Register ABAP language (basic configuration)
                        if (!window.monaco.languages.getLanguages().some(lang => lang.id === 'abap')) {
                            window.monaco.languages.register({ id: 'abap' });
                            window.monaco.languages.setMonarchTokensProvider('abap', {
                                keywords: [
                                    'DATA', 'TYPE', 'BEGIN', 'END', 'OF', 'REPORT', 'WRITE', 'IF', 'ELSE', 'ENDIF',
                                    'LOOP', 'AT', 'ENDLOOP', 'SELECT', 'FROM', 'WHERE', 'INTO', 'TABLE', 'FORM',
                                    'ENDFORM', 'PERFORM', 'METHOD', 'ENDMETHOD', 'CLASS', 'ENDCLASS', 'PUBLIC',
                                    'PRIVATE', 'PROTECTED', 'DEFINITION', 'IMPLEMENTATION', 'CALL', 'FUNCTION',
                                    'EXPORTING', 'IMPORTING', 'CHANGING', 'TABLES', 'EXCEPTIONS', 'RAISE',
                                    'TRY', 'CATCH', 'ENDTRY', 'CASE', 'WHEN', 'ENDCASE', 'DO', 'ENDDO', 'WHILE',
                                    'ENDWHILE', 'CHECK', 'EXIT', 'CONTINUE', 'RETURN', 'CONSTANTS', 'PARAMETERS',
                                    'FIELD-SYMBOLS', 'ASSIGN', 'CREATE', 'OBJECT', 'CONCATENATE', 'SPLIT',
                                    'FIND', 'REPLACE', 'SHIFT', 'TRANSLATE', 'CONDENSE', 'CLEAR', 'REFRESH',
                                    'FREE', 'DESCRIBE', 'READ', 'MODIFY', 'DELETE', 'INSERT', 'APPEND', 'COLLECT',
                                    'SORT', 'MOVE', 'ADD', 'SUBTRACT', 'MULTIPLY', 'DIVIDE', 'COMPUTE', 'MODULE'
                                ],
                                typeKeywords: [
                                    'I', 'C', 'N', 'D', 'T', 'P', 'F', 'X', 'STRING', 'XSTRING'
                                ],
                                operators: [
                                    '=', '>', '<', '<=', '>=', '<>', 'EQ', 'NE', 'LT', 'LE', 'GT', 'GE',
                                    'CO', 'CN', 'CA', 'NA', 'CS', 'NS', 'CP', 'NP', 'AND', 'OR', 'NOT'
                                ],
                                symbols: /[=><!~?:&|+\-*\/\^%]+/,
                                tokenizer: {
                                    root: [
                                        [/"([^"\\]|\\.)*$/, 'string.invalid'],
                                        [/'([^'\\]|\\.)*$/, 'string.invalid'],
                                        [/"/, 'string', '@string."'],
                                        [/'/, 'string', "@string.'"],
                                        [/\*.*$/, 'comment'],
                                        [/"!.*$/, 'comment.doc'],
                                        [/[a-z_$][\w$]*/, {
                                            cases: {
                                                '@typeKeywords': 'keyword.type',
                                                '@keywords': 'keyword',
                                                '@default': 'identifier'
                                            }
                                        }],
                                        [/[A-Z][\w\$]*/, 'type.identifier'],
                                        [/[{}()\[\]]/, '@brackets'],
                                        [/@symbols/, {
                                            cases: {
                                                '@operators': 'operator',
                                                '@default': ''
                                            }
                                        }],
                                        [/\d*\.\d+([eE][\-+]?\d+)?/, 'number.float'],
                                        [/0[xX][0-9a-fA-F]+/, 'number.hex'],
                                        [/\d+/, 'number'],
                                        [/[;,.]/, 'delimiter'],
                                        [/[ \t\r\n]+/, 'white']
                                    ],
                                    string: [
                                        [/[^\\"']+/, 'string'],
                                        [/\\./, 'string.escape.invalid'],
                                        [/"/, {
                                            cases: {
                                                '$#==$S2': { token: 'string', next: '@pop' },
                                                '@default': 'string'
                                            }
                                        }],
                                        [/'/, {
                                            cases: {
                                                '$#==$S2': { token: 'string', next: '@pop' },
                                                '@default': 'string'
                                            }
                                        }]
                                    ]
                                }
                            });
                        }

                        // Register DDLS/CDS language
                        if (!window.monaco.languages.getLanguages().some(lang => lang.id === 'asddls')) {
                            window.monaco.languages.register({ id: 'asddls' });
                            window.monaco.languages.setMonarchTokensProvider('asddls', {
                                keywords: [
                                    'define', 'view', 'entity', 'as', 'select', 'from', 'where', 'inner', 'left', 'right',
                                    'join', 'on', 'union', 'association', 'to', 'key', 'case', 'when', 'then',
                                    'else', 'end', 'cast', 'group', 'by', 'having', 'order'
                                ],
                                typeKeywords: [],
                                operators: ['=', '>', '<', '<=', '>=', '<>', 'and', 'or', 'not'],
                                symbols: /[=><!~?:&|+\-*\/\^%]+/,
                                tokenizer: {
                                    root: [
                                        [/@[A-Za-z][\w\.]*/, 'annotation'],
                                        [/"([^"\\]|\\.)*$/, 'string.invalid'],
                                        [/'([^'\\]|\\.)*$/, 'string.invalid'],
                                        [/"/, 'string', '@string."'],
                                        [/'/, 'string', "@string.'"],
                                        [/\/\/.*$/, 'comment'],
                                        [/\/\*/, 'comment', '@comment'],
                                        [/[a-z_$][\w$]*/, {
                                            cases: {
                                                '@keywords': 'keyword',
                                                '@default': 'identifier'
                                            }
                                        }],
                                        [/[A-Z][\w\$]*/, 'type.identifier'],
                                        [/[{}()\[\]]/, '@brackets'],
                                        [/@symbols/, {
                                            cases: {
                                                '@operators': 'operator',
                                                '@default': ''
                                            }
                                        }],
                                        [/\d*\.\d+([eE][\-+]?\d+)?/, 'number.float'],
                                        [/\d+/, 'number'],
                                        [/[;,.]/, 'delimiter'],
                                        [/[ \t\r\n]+/, 'white']
                                    ],
                                    comment: [
                                        [/[^\/*]+/, 'comment'],
                                        [/\*\//, 'comment', '@pop'],
                                        [/[\/*]/, 'comment']
                                    ],
                                    string: [
                                        [/[^\\"']+/, 'string'],
                                        [/\\./, 'string.escape'],
                                        [/"/, {
                                            cases: {
                                                '$#==$S2': { token: 'string', next: '@pop' },
                                                '@default': 'string'
                                            }
                                        }],
                                        [/'/, {
                                            cases: {
                                                '$#==$S2': { token: 'string', next: '@pop' },
                                                '@default': 'string'
                                            }
                                        }]
                                    ]
                                }
                            });
                        }

                        console.log("Monaco Editor loaded with ABAP and CDS syntax highlighting");
                        resolve();
                    }, function (err) {
                        reject(err);
                    });
                };
                loaderScript.onerror = function (error) {
                    reject(error);
                };
                document.head.appendChild(loaderScript);
            });

            return this._loadPromise;
        }
    };

    return MonacoLoader;
});
