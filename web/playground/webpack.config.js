/* eslint-disable @typescript-eslint/no-require-imports */
/* eslint-disable @typescript-eslint/no-var-requires */
const path = require("path");
const webpack = require("webpack");
const HtmlWebpackPlugin = require("html-webpack-plugin");

module.exports = ({mode} = {mode: "development"}) => {
  const isProduction = mode === "production";
  
  return {
    entry: {
      "app": "./src/index.ts",
      "editor.worker": "monaco-editor/esm/vs/editor/editor.worker.js",
      "json.worker": "monaco-editor/esm/vs/language/json/json.worker.js",
    },
    mode,
    output: {
      path: path.join(__dirname, "build"),
      filename: isProduction ? "[name].[contenthash:8].bundle.js" : "[name].bundle.js",
      chunkFilename: isProduction ? "[name].[contenthash:8].chunk.js" : "[name].chunk.js",
      globalObject: "self",
      clean: true,
    },
    optimization: isProduction ? {
      minimize: true,
      splitChunks: {
        chunks: "all",
        cacheGroups: {
          monaco: {
            test: /[\\/]node_modules[\\/]monaco-editor[\\/]/,
            name: "monaco",
            priority: 20,
          },
          vendor: {
            test: /[\\/]node_modules[\\/]/,
            name: "vendors",
            priority: 10,
          },
        },
      },
      runtimeChunk: "single",
    } : undefined,
    performance: isProduction ? {
      hints: "warning",
      maxEntrypointSize: 512000,
      maxAssetSize: 512000,
    } : false,
  devServer: {
    static: {
      directory: path.join(__dirname, "public"),
    },
    open: true,
    hot: true,
  },
  resolve: {
    fallback: {
      "buffer": require.resolve("buffer/"),
      "path": require.resolve("path-browserify"),
      "stream": require.resolve("stream-browserify"),
      "crypto": false,
    },
    extensions: [".js", ".ts", ".tsx"],
  },
  module: {
    rules: [
      {test: /\.css$/, use: ["style-loader", "css-loader"]},
      {test: /\.less$/, use: ["style-loader", "css-loader", "less-loader"]},
      {
        test: /\.png$/,
        include: /favicon/,
        use: "file-loader?name=[name].[ext]",
      },
      {
        test: /\.png$|\.svg$/,
        exclude: /favicon/,
        use: "url-loader?limit=1024",
      },
      {
        test: /\.ttf$/,
        type: "asset/resource",
        generator: {
          filename: "[name][ext]",
        },
      },
      {
        test: /\.tsx?$/,
        loader: "ts-loader",
        exclude: /node_modules/,
      },
    ],
  },
    plugins: [
      new HtmlWebpackPlugin({
        template: "public/index.html",
        minify: isProduction ? {
          removeComments: true,
          collapseWhitespace: true,
          removeRedundantAttributes: true,
          useShortDoctype: true,
          removeEmptyAttributes: true,
          removeStyleLinkTypeAttributes: true,
          keepClosingSlash: true,
          minifyJS: true,
          minifyCSS: true,
          minifyURLs: true,
        } : false,
      }),
      new webpack.ProvidePlugin({
        Buffer: ["buffer", "Buffer"],
      }),
    ],
  };
};
