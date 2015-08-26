module.exports =
    context: __dirname + "/app",
    entry: "./entry.coffee",
    output:
        path: __dirname + "/dist/app",
        filename: "bundle.js",
    module:
        loaders: [
            { test: /\.coffee$/, loader: "coffee-loader" },
            { test: /\.(coffee\.md|litcoffee)$/, loader: "coffee-loader?literate" },
            { test: /\.css$/, loader: "style-loader!css-loader" },
            { test: /\.(png|woff|woff2|eot|ttf|svg)$/, loader: 'url-loader?limit=100000' }
        ]

