document.addEventListener('turbolinks:load', () => {
  const answers = document.querySelector('.answers');
  if (!answers) return

  answers.addEventListener('click', e => {
    if (!e.target.classList.contains('answer__edit')) return

    e.preventDefault()
    e.target.classList.add('hidden')
    const answerId = e.target.dataset.answerId
    const form = document.querySelector(`form#answer-edit-form-${answerId}`)
    form.classList.remove('hidden')
  })
})