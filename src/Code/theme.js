const html = document.documentElement
const toggle = document.getElementById("theme-toggle")

function setTheme(theme) {
  html.setAttribute("data-theme", theme)
  localStorage.setItem("theme", theme)
  toggle.textContent = theme === "dark" ? "☀️" : "🌙"
}

toggle.addEventListener("click", () => {
  const newTheme = html.getAttribute("data-theme") === "dark" ? "light" : "dark"
  setTheme(newTheme)
})

const savedTheme = localStorage.getItem("theme")
setTheme(savedTheme || "light")
