
function component() {
  const element = document.createElement('div');
  element.innerHTML = 'Hello From Vite';
  return element;
}
document.body.appendChild(component());
