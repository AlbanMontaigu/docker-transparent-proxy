#!/usr/bin/env node
var clusterMaster = require("cluster-master")

clusterMaster({
  exec: "server.js",
  size: require('os').cpus().length,
  env: process.env,
  args: process.argv.splice(2),
  silent: true,
  signals: true,
  repl: '/var/run/transparent-proxy/cluster-master.socket'
})
