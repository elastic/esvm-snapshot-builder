const { writeFileSync } = require('fs')
const { resolve } = require('path')

const jsYaml = require('js-yaml')

const branches = [
  'master',
  '5.x',
  '5.4',
  '5.3',
  '5.2'
  // '5.1',
  // '5.0',
  // '2.4',
  // '2.3',
  // '2.2',
  // '2.1',
  // '2.0'
]

const version = '2'
const services = branches.reduce((all, branch) => {
  const [major] = branch.split()
  const image = parseInt(major, 10) < 3
    ? 'esvm-builder-maven'
    : 'esvm-builder-gradle'

  return Object.assign(all, {
    [branch]: {
      tty: true,
      container_name: branch,
      image,
      env_file: [
        '.env.defaults',
        '.env'
      ],
      environment: {
        BRANCH: branch
      }
    }
  })
}, {})

const yaml = (
`## autogenerated by generate-config.js
${jsYaml.safeDump({ version, services })}`
)

writeFileSync(resolve(__dirname, 'docker-compose.yml'), yaml, 'utf8')
