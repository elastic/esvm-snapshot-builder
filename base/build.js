const { execFileSync } = require('child_process')
const { join } = require('path')

const {
  BRANCH,
  S3_BUCKET,
  S3_PREFIX,
  REPO_URL
} = process.env

const BUCKET_PREFIX = join(S3_BUCKET, S3_PREFIX)
const ROOT_DIR = '/'
const REPO_DIR = '/repo'

const exec = (cwd, cmd, args, stdio = ['ignore', 'inherit', 'inherit']) => {
  try {
    console.log('## EXEC in', cwd)
    console.log('##   ', cmd, args.join(' '))
    console.log('')
    return execFileSync(cmd, args, { cwd, stdio })
  } finally {
    console.log('')
  }
}

const list = buffer =>
  String(buffer).trim().split('\n').filter(Boolean)

const one = list => {
  if (list.length > 1) {
    throw new Error(`Multiple items in a list that should only have one \n  ${list.join('\n  ')}`)
  }
  return list[0]
}

const getTarballPaths = () =>
  list(exec(REPO_DIR, 'find', ['distribution/tar', '-name', '*.tar.gz'], 'pipe'))

const getZipPaths = () =>
  list(exec(REPO_DIR, 'find', ['distribution/zip', '-name', '*elasticsearch*.zip'], 'pipe'))

exec(ROOT_DIR, 'mkdir', ['-p', REPO_DIR])
exec(ROOT_DIR, 'git', ['clone', REPO_URL, '--branch', BRANCH, '--depth', 1, REPO_DIR])
exec(REPO_DIR, './gradlew', ['clean', ':distribution:tar:assemble', ':distribution:zip:assemble', '--stacktrace'])
exec(REPO_DIR, 'aws', ['s3', 'cp', '--region', process.env.S3_DEFAULT_REGION, one(getTarballPaths()), `s3://${join(BUCKET_PREFIX, BRANCH)}.tar.gz`])
exec(REPO_DIR, 'aws', ['s3', 'cp', '--region', process.env.S3_DEFAULT_REGION, one(getZipPaths()), `s3://${join(BUCKET_PREFIX, BRANCH)}.zip`])
