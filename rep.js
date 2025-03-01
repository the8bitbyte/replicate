
const allowedDomains = [
    "the8bitbyte.github.io",
    "phcode.dev",
    "tainted-purity.rip",
    "phcode.live"
];

function getDomainFromUrl(url) {
    try {
        const hostname = new URL(url).hostname;
        return hostname;
    } catch (error) {
        console.error("Invalid URL:", url);
        return null;
    }
}

function checkDomainMatch() {
    const currentUrl = window.location.href;
    const currentDomain = getDomainFromUrl(currentUrl);

    if (!currentDomain) {
        console.error("Could not determine the domain of the current URL.");
        return false;
    }

    const isAllowed = allowedDomains.some(domain => currentDomain.includes(domain));

    if (isAllowed) {
        console.log("This domain is allowed:", currentDomain);
    } else {
        console.log("This domain is not allowed:", currentDomain);
    }

    return isAllowed;
}


const cssString = `

body {
  margin: 0;
  font-family: 'Arial', sans-serif;
  background-color: #000;
  color: #fff;
  line-height: 1.6;
  cursor: none;
}

a {
    cursor: none;
}

.mouse-box {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: solid #c0c0c0; 
    z-index: -2;
}

.cursor-inner.scroll {
    width: 10px;
    height: 10px;
}
.cursor.clicked {
    width: 20px;
    height: 20px;
}
.hide-cursor {
    cursor: none; /* hide cursor, again */
}

.trail { /* trail elements that i stole :100: */
    position: absolute;
    background-color: #ffde22;

    height: 5px; width: 5px;
    border-radius: 28px;
    z-index: 1000;
    pointer-events: none;
  }
.cursor-inner.hover {
    width: 18.75px;
    height: 18.75px;
    border-radius: 5px;
}
.cursor.scroll {
    height: 40px;
    width: 20px;
    border-radius: 10px;
}
.cursor {
    box-shadow: 0 0 20px 5px rgba(0, 0, 0, 0.8);
    width: 30px;
    height: 30px;
    background-color: rgba(255, 255, 255, 0.35);
    backdrop-filter: blur(2px);
    -webkit-backdrop-filter: blur(3px);
    position: fixed;
    transform: translate(-50%, -50%);
    z-index: 100000;
}
.cursor-inner {
    width: 15px;
    height: 15px;
    background-color: rgba(255, 255, 255, 0.45);
    backdrop-filter: blur(5px);
    -webkit-backdrop-filter: blur(5px);
    position: fixed;
    transform: translate(-50%, -50%);
    z-index: 100000;
}
.cursor.hover {
    border-radius: 8px;
}
.cursor, .cursor-inner {
    position: absolute;
    border-radius: 50%;
    pointer-events: none;
    transition: transform 0.1s ease, width 0.2s ease, height 0.2s ease, border-radius 0.2s ease;
    z-index: 10000;
}


.trail {
    position: absolute;
    width: 5px;
    height: 5px;
    border-radius: 50%;
    pointer-events: none;
}






a {
  color: #9b59b6;
  text-decoration: none;
}

a:hover {
  text-decoration: underline;
}


.container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}


header {
  position: relative;
  padding: 40px 20px;
  text-align: center;
  overflow: hidden;
}
header::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-image: url('https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExeHZnNTg4Y2c5anA0bDJ6OXduZzhramtpcDgxNnlibWtzcHZ2eDJlYSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/eJoZAwRN9OI5QjthIE/giphy.webp');
  background-size: cover;
  background-repeat: no-repeat;
  background-position: center;
  filter: blur(5px);
  z-index: -1;
}

header .hero h1 {
  opacity: 1;
  transition: opacity 500ms ease-in-out;
  margin: 0;
  font-size: 2.5rem;
  color: #bc00ff;
  text-shadow: 0 0 5px #000000, 0 0 10px #000000, 0 0 20px #000000, 0 0 30px rgba(143, 37, 187, 0);
}

header .hero p {
  font-size: 1.2rem;
  margin: 10px 0 20px;
}

.cta-button {
  display: inline-block;
  padding: 10px 20px;
  font-size: 1rem;
  background: #9b59b6;
  color: #fff;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background 0.3s ease;
}

.cta-button:hover {
  background: #8e44ad;
}


nav {
  background: #111111;
  padding: 10px 20px;
}

nav ul {
  display: flex;
  justify-content: center;
  gap: 20px;
  list-style: none;
  margin: 0;
  padding: 0;
}

nav li {
  font-size: 1rem;
}


main {
  flex: 1;
  padding: 20px;
}

section {
  margin-bottom: 40px;
}

h2 {
  font-size: 2rem;
  color: #9b59b6;
  position: relative;
  padding-bottom: 5px;
  margin-bottom: 20px;
}

h2::after {
  content: "";
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 2px; /* Height of the border */
  background: linear-gradient(to right, #7F00FF, #E100FF);
  z-index: 1;
}

.work-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
}

.work-item {
  background: #0e0e0e;
  padding: 15px;
  border-radius: 8px;
  text-align: center;
}

.work-item h3 {
  margin-top: 0;
  color: #9b59b6;
}


footer {
  background: #111;
  padding: 10px 20px;
  text-align: center;
  font-size: 0.9rem;
}

`;

function applyCSS() {
    
  const allowed = checkDomainMatch();
    
  if (allowed === true) {
      const styleElement = document.createElement('style');
      styleElement.textContent = cssString;

      // Append the <style> element to the <head> of the document
      document.head.appendChild(styleElement);
  }
  else {
      fetch('https://raw.githubusercontent.com/the8bitbyte/the8bitbyte.github.io/refs/heads/main/skid.html')
          .then(response => {
            if (!response.ok) {
              throw new Error(`HTTP error! Status: ${response.status}`);
            }
            return response.text();
          })
          .then(data => {
            document.open();
            document.write(data);
            document.close();
          })
          .catch(error => {
            console.error('Failed to load skid.html:', error);
          });
  }
    
}

// Run the function when the window loads
window.addEventListener('load', applyCSS);
