export function getThemeMode() {
  const savedMode = localStorage.getItem('theme-mode')
  if (savedMode) {
    return savedMode
  }
  
  if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
    return 'dark'
  }
  
  return 'light'
}

export function setThemeMode(mode) {
  localStorage.setItem('theme-mode', mode)
  
  const html = document.documentElement
  const body = document.body
  
  body.classList.add('theme-transition')
  
  if (mode === 'dark') {
    html.setAttribute('data-theme', 'dark')
  } else {
    html.removeAttribute('data-theme')
  }
  
  setTimeout(() => {
    body.classList.remove('theme-transition')
  }, 800)
}

export function initTheme() {
  const mode = getThemeMode()
  setThemeMode(mode)
  return mode === 'dark'
} 