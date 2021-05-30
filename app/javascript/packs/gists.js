import { request } from '@octokit/request'

const renderGists = async () => {
  const gistNodes = document.querySelectorAll('.gist')

  if (!gistNodes.length) return

  for (const node of gistNodes) {
    if (node.querySelector('pre')) continue

    const url = node.dataset.gistUrl,
      matches = url.match(/[\d\w]+/g),
      gist_id = matches[matches.length - 1]

      const {data: {files}} = await request('GET /gists/{gist_id}', { gist_id })
      const {filename, content} = Object.values(files)[0]
      node.querySelector('.gist-title').innerHTML = filename
      node.querySelector('.gist-content').innerHTML = `<pre>${content}</pre>`
  }
}

document.addEventListener('turbolinks:load', () => {
  document.addEventListener(':render-new-gist', renderGists)
  renderGists()
})