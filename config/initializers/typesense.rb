require 'typesense'

TYPESENSE_CLIENT = Typesense::Client.new(
    api_key: 'HHc7/wIE1QFvMu8Y3V6p0Ku8Ln+ObGsFzx8KDb+n4sU=',
    nodes: [
      {
        host: 'typesense-typesense-compose.leiusn.easypanel.host',
        port: '8108',
        protocol: 'http'
      }
    ],
  connection_timeout_seconds: 2
)