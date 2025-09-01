const {launch} = require('puppeteer')
const {join} = require("node:path")
const { createReadStream, readFileSync, writeFileSync } = require('node:fs');
const { createInterface } = require('node:readline');
const DOCKERFILE_PATH = join(__dirname, "Dockerfile")

async function getActiveHref(url) {
  const browser = await launch({ headless: true, executablePath: '/usr/bin/chromium', args: [
    '--no-sandbox',
    '--disable-dev-shm-usage',
    '--disable-gpu',
  ] });
  const page = await browser.newPage();

  try {
    await page.goto(url, { waitUntil: 'domcontentloaded' });

    const containerSelector =
      'html.fontawesome-i2svg-active.fontawesome-i2svg-complete body section.section div.container nav.panel';

    const href = await page.$eval(
      `${containerSelector} a.is-active`,
      el => el.getAttribute('href')
    );

    return href.split("/")[1];
  } catch (err) {
    console.error('Error:', err.message);
    return null;
  } finally {
    await browser.close();
  }
}

async function update() {
	const url = 'https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/';
	const href = await getActiveHref(url);
	if (!href) return

	const fileStream = createReadStream(DOCKERFILE_PATH);

	const rl = createInterface({
		input: fileStream,
		crlfDelay: Infinity,
	});
	let curver
	for await (const line of rl) {
		if (line.includes("FIVEM_VER")) {
			curver = line.split("=")[1]
			break
		}
	}
	if (curver != href) {
		console.log(`Fivem update! Régi verzió: ${curver} Új verzió: ${href}`)
		let r = readFileSync(DOCKERFILE_PATH, 'utf8')
		r = r.replaceAll(curver, href)
		writeFileSync(DOCKERFILE_PATH, r, {encoding:"utf8"})
		console.log("Dockerfile frissítve!")
	} else {
		console.log("Fivem up-to-date!")
	}
}
setInterval(()=>{
    (async () => {
        update()
    })();
},60*60*1000);
(async ()=>{update()})();
console.log("Server running.")