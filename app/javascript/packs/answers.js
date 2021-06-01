document.addEventListener('turbolinks:load', () => {
  const answers = document.querySelector('.answers');
  if (!answers) return

  answers.addEventListener('click', e => {
    const isEditCanceler = e.target.classList.contains('answer__edit--cancel')
    const isEditTrigger = e.target.classList.contains('answer__edit')
    if (!isEditCanceler && !isEditTrigger) return

    e.preventDefault()

    const answerId = e.target.dataset.answerId
    const form = document.querySelector(`form#answer-edit-form-${answerId}`)

    if (isEditTrigger) {
      e.target.classList.add('hidden')
      form.classList.remove('hidden')
    } else {
      answers.querySelector(`#answer-${answerId} .answer__edit`).classList.remove('hidden')
      form.classList.add('hidden')
    }
  })
})