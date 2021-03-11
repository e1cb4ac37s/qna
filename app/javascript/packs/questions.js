document.addEventListener('turbolinks:load', () => {
  const questionWrapper = document.querySelector('.question-wrapper')
  if (!questionWrapper) return

  questionWrapper.addEventListener('click', e => {
    if (!e.target.classList.contains('question__edit')) return
    e.preventDefault()

    const actionsNode = document.querySelector('.question__actions')
    if (!actionsNode) return

    actionsNode.classList.add('hidden')
    const form = document.querySelector(`form#question-edit-form`)
    form.classList.remove('hidden')
  })
})